#ifndef __PPORT_H
#define __PPORT_H

#define PP_CMD_SIZE 4

#define PP_OUT_EXT             0x79
#define PP_IN_EXT              0x80
#define PP_CTL                 0x77       // pport control
#define   PP_CTL_OPEN          0x00
#define   PP_CTL_CLOSE         0x01
#define   PP_CTL_PROM          0x02
#define PP_FCTL                0x78       // file control
#define   PP_FCTL_DIR          0x00
#define   PP_FCTL_RDIR         0x01
#define   PP_FCTL_OPEN         0x02
#define   PP_FCTL_CLOSE        0x03
#define   PP_FCTL_READ         0x04
#define   PP_FCTL_WRITE        0x05
#define   PP_FCTL_SEEK         0x06
#define   PP_FCTL_FLUSH        0x07
#define   PP_FCTL_RENAME       0x08
#define   PP_FCTL_DEL          0x09
#define   PP_FCTL_FINFO        0x0a
#define   PP_FCTL_DSK_OPEN     0x10
#define   PP_FCTL_DSK_CLOSE    0x11
#define   PP_FCTL_DSK_WP       0x12
#define   PP_FCTL_DSK_GET      0x13
#define   PP_FCTL_TAPE_GET     0x14
#define   PP_FCTL_CFG_CLEAR    0x20
#define   PP_FCTL_CFG_GFLAGS   0x21
#define   PP_FCTL_CFG_SFLAGS   0x22

#define PP_ACK                 0x73

#define PP_MAKE_WORD(cmd, sub) ((((word)cmd) << 8) | ((word)sub))

#define PP_CMD_CTL(cmd)        PP_MAKE_WORD(PP_CTL, cmd)
#define PP_CMD_FCTL(cmd)       PP_MAKE_WORD(PP_FCTL, cmd)
#define PP_W_ACK               PP_MAKE_WORD(PP_ACK, 0)

#define CFG_FLG_DRVA_WP 0x0001
#define CFG_FLG_DRVB_WP 0x0002
#define CFG_FLG_DRVC_WP 0x0004
#define CFG_FLG_DRVD_WP 0x0008
#define CFG_FLG_RST_TR  0x0010
#define CFG_FLG_STROM1  0x0020

#endif
