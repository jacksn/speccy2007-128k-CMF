#include <stdio.h>
#include <io.h>
#include <fcntl.h>

struct fdi_head {
  char sig[3];
  unsigned char wp;
  unsigned short cyls;
  unsigned short sides;
  unsigned short cmt_off;
  unsigned short dta_off;
  unsigned short ext_len;
}__attribute__((packed));

struct trk_info {
  unsigned long trk_off;
  unsigned short res0;
  unsigned char secs;
} __attribute__((packed));

struct sec_info {
  unsigned char cyl;
  unsigned char head;
  unsigned char sec;
  unsigned char sec_size;
  unsigned char flags;
  unsigned short dta_off;
} __attribute__((packed));

int main(int argc, char **argv)
{
  int h, i, j, k;
  struct fdi_head fdi_head;
  struct trk_info trk_info;
  struct sec_info sec_info;
  unsigned long trk_offset;
  unsigned long trk_head_offset;
  
  if (argc < 2) {
    printf("usage: dumpfdi <filename>\n");
    exit(1);
  }

  h = open(argv[1], _O_RDONLY | _O_BINARY);
  if (h < 0) {
    printf("error: failed to open %s\n", argv[1]);
    exit (1);
  }
  if (read(h, &fdi_head, sizeof(fdi_head)) < sizeof(fdi_head)) {
    printf("error: reading main head\n");
    exit (1);
  }
  if (memcmp(fdi_head.sig, "FDI", 3) != 0) {
    printf("error: invalid signature\n");
    exit (1);
  }
  printf("FDI valid, number of cyls = %u, sides = %u, data_ofs = %u\n", fdi_head.cyls, fdi_head.sides, fdi_head.dta_off);
  trk_head_offset = fdi_head.ext_len + 0xe;
  trk_offset = fdi_head.dta_off;
  for (i = 0; i < fdi_head.cyls; i++) {
    for (j = 0; j < fdi_head.sides; j++) {
      lseek(h, trk_head_offset, SEEK_SET);
      if (read(h, &trk_info, sizeof(trk_info)) < sizeof(trk_info)) {
        printf("error: reading trk head\n");
        exit(1);
      }
      trk_offset = fdi_head.dta_off+trk_info.trk_off;
      printf(" TRK=%u, SIDE=%u, SECS=%u (HEAD=%u)\n", i, j, trk_info.secs, trk_head_offset);
      for (k = 0; k < trk_info.secs; k++) {
        lseek(h, trk_head_offset + (k + 1) * 7, SEEK_SET);
        if (read(h, &sec_info, sizeof(sec_info)) < sizeof(sec_info)) {
          printf("error: reading sec head\n");
          exit(1);
        }
        printf(" SEC %u, C=%u,H=%u,R=%u,N=%u,F=%x DATA=%x\n", k, sec_info.cyl, sec_info.head, sec_info.sec, sec_info.sec_size, sec_info.flags, trk_offset + sec_info.dta_off);
      }
      trk_head_offset += (trk_info.secs + 1) * 7;
    }
  }
}