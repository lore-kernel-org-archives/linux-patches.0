Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF46A47
	for <patches@lists.linux.dev>; Fri, 18 Oct 2024 11:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729251114; cv=none; b=CvB4CKRma7ALn1Zi1awHVBR7S+/yRVPVcSp6ixfJGe6kzMQcak3bv46jXYoP1Ptl3YY3rScNI5ZnVyxv+o0qgVz4haixVZdiChtr9MdX7FW08P6g0x3weC8h3HSvsnwg4tTvX1DH/7gvSkveM3Qzvz/o68t4uy00vjxeKNOWDqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729251114; c=relaxed/simple;
	bh=7PEFr8eNBCmv5CVP82EJdqGKJxely0WZJAq2bfpZGVg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KQKGTq9rjUqCc8UdbjKV2Gci27YlynPqExSuAeRaFAUXoD7UNTfy//84LAJVixYMwAD3G17SZgll5rKA/snAyKYR1V217O35eVMM4/YkDlyYpMa9mAGUqUn5uT86y/HtKChoHZxVv7GBratsfKecVH+kq0bPNR3Z+UaA8pcrtdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGAOmbwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGAOmbwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68530C4CEC6;
	Fri, 18 Oct 2024 11:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729251113;
	bh=7PEFr8eNBCmv5CVP82EJdqGKJxely0WZJAq2bfpZGVg=;
	h=From:To:Cc:Subject:Date:From;
	b=UGAOmbwj+k+e0tPpq3ohjXj8CQOLau1C1+MY+VnJI+a+D0/Rw+FK5C0ZwPwDS0jGT
	 RDwFhXFCsYdfX91piLFvMTpv+LrEhD5Co010H3biLwSVtCWG2vJYv1Ogo7U1CJzZHF
	 Z9CX+NJtLoB7Zre8Vd4qhfzTx0aq9vXJAtz1GWTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: patches@lists.linux.dev
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] MAINTAINERS: Remove some entries due to various compliance requirements.
Date: Fri, 18 Oct 2024 13:31:34 +0200
Message-ID: <2024101835-tiptop-blip-09ed@gregkh>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11596; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=7PEFr8eNBCmv5CVP82EJdqGKJxely0WZJAq2bfpZGVg=; b=owGbwMvMwCRo6H6F97bub03G02pJDOlC7hLHYjWdLTn3bam5e7sg3YUjaEmVXt+Dlvyupwd3R K6cOCurI5aFQZCJQVZMkeXLNp6j+ysOKXoZ2p6GmcPKBDKEgYtTACbyXI9hwexnbUH/o74obf3E c+yikNOdfW0ZpgwLmiyWtOiujp99O096g5cVp32QxVt3AA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Remove some entries due to various compliance requirements. They can come
back in the future if sufficient documentation is provided.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS | 177 ----------------------------------------------------
 1 file changed, 177 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d20ace6fa40..21b31c6d20d0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -258,12 +258,6 @@ L:	linux-acenic@sunsite.dk
 S:	Maintained
 F:	drivers/net/ethernet/alteon/acenic*
 
-ACER ASPIRE 1 EMBEDDED CONTROLLER DRIVER
-M:	Nikita Travkin <nikita@trvn.ru>
-S:	Maintained
-F:	Documentation/devicetree/bindings/platform/acer,aspire1-ec.yaml
-F:	drivers/platform/arm64/acer-aspire1-ec.c
-
 ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
 M:	Peter Kaestle <peter@piie.net>
 L:	platform-driver-x86@vger.kernel.org
@@ -888,7 +882,6 @@ F:	drivers/staging/media/sunxi/cedrus/
 
 ALPHA PORT
 M:	Richard Henderson <richard.henderson@linaro.org>
-M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
 M:	Matt Turner <mattst88@gmail.com>
 L:	linux-alpha@vger.kernel.org
 S:	Odd Fixes
@@ -2263,12 +2256,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ep93xx/ts72xx.c
 
-ARM/CIRRUS LOGIC CLPS711X ARM ARCHITECTURE
-M:	Alexander Shiyan <shc_work@mail.ru>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Odd Fixes
-N:	clps711x
-
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 M:	Hartley Sweeten <hsweeten@visionengravers.com>
 M:	Alexander Sverdlin <alexander.sverdlin@gmail.com>
@@ -3815,14 +3802,6 @@ F:	drivers/video/backlight/
 F:	include/linux/backlight.h
 F:	include/linux/pwm_backlight.h
 
-BAIKAL-T1 PVT HARDWARE MONITOR DRIVER
-M:	Serge Semin <fancer.lancer@gmail.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Supported
-F:	Documentation/devicetree/bindings/hwmon/baikal,bt1-pvt.yaml
-F:	Documentation/hwmon/bt1-pvt.rst
-F:	drivers/hwmon/bt1-pvt.[ch]
-
 BARCO P50 GPIO DRIVER
 M:	Santosh Kumar Yadav <santoshkumar.yadav@barco.com>
 M:	Peter Korsgaard <peter.korsgaard@barco.com>
@@ -6476,7 +6455,6 @@ F:	drivers/mtd/nand/raw/denali*
 
 DESIGNWARE EDMA CORE IP DRIVER
 M:	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
-R:	Serge Semin <fancer.lancer@gmail.com>
 L:	dmaengine@vger.kernel.org
 S:	Maintained
 F:	drivers/dma/dw-edma/
@@ -9759,14 +9737,6 @@ F:	drivers/gpio/gpiolib-cdev.c
 F:	include/uapi/linux/gpio.h
 F:	tools/gpio/
 
-GRE DEMULTIPLEXER DRIVER
-M:	Dmitry Kozlov <xeb@mail.ru>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	include/net/gre.h
-F:	net/ipv4/gre_demux.c
-F:	net/ipv4/gre_offload.c
-
 GRETH 10/100/1G Ethernet MAC device driver
 M:	Andreas Larsson <andreas@gaisler.com>
 L:	netdev@vger.kernel.org
@@ -12949,12 +12919,6 @@ S:	Maintained
 F:	drivers/ata/pata_arasan_cf.c
 F:	include/linux/pata_arasan_cf_data.h
 
-LIBATA PATA DRIVERS
-R:	Sergey Shtylyov <s.shtylyov@omp.ru>
-L:	linux-ide@vger.kernel.org
-F:	drivers/ata/ata_*.c
-F:	drivers/ata/pata_*.c
-
 LIBATA PATA FARADAY FTIDE010 AND GEMINI SATA BRIDGE DRIVERS
 M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-ide@vger.kernel.org
@@ -12971,14 +12935,6 @@ F:	drivers/ata/ahci_platform.c
 F:	drivers/ata/libahci_platform.c
 F:	include/linux/ahci_platform.h
 
-LIBATA SATA AHCI SYNOPSYS DWC CONTROLLER DRIVER
-M:	Serge Semin <fancer.lancer@gmail.com>
-L:	linux-ide@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/ata/baikal,bt1-ahci.yaml
-F:	Documentation/devicetree/bindings/ata/snps,dwc-ahci.yaml
-F:	drivers/ata/ahci_dwc.c
-
 LIBATA SATA PROMISE TX2/TX4 CONTROLLER DRIVER
 M:	Mikael Pettersson <mikpelinux@gmail.com>
 L:	linux-ide@vger.kernel.org
@@ -14174,16 +14130,6 @@ S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/platform/nxp/imx-pxp.[ch]
 
-MEDIA DRIVERS FOR ASCOT2E
-M:	Sergey Kozlov <serjk@netup.ru>
-M:	Abylay Ospan <aospan@netup.ru>
-L:	linux-media@vger.kernel.org
-S:	Supported
-W:	https://linuxtv.org
-W:	http://netup.tv/
-T:	git git://linuxtv.org/media_tree.git
-F:	drivers/media/dvb-frontends/ascot2e*
-
 MEDIA DRIVERS FOR CXD2099AR CI CONTROLLERS
 M:	Jasmin Jessich <jasmin@anw.at>
 L:	linux-media@vger.kernel.org
@@ -14192,16 +14138,6 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/dvb-frontends/cxd2099*
 
-MEDIA DRIVERS FOR CXD2841ER
-M:	Sergey Kozlov <serjk@netup.ru>
-M:	Abylay Ospan <aospan@netup.ru>
-L:	linux-media@vger.kernel.org
-S:	Supported
-W:	https://linuxtv.org
-W:	http://netup.tv/
-T:	git git://linuxtv.org/media_tree.git
-F:	drivers/media/dvb-frontends/cxd2841er*
-
 MEDIA DRIVERS FOR CXD2880
 M:	Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
 L:	linux-media@vger.kernel.org
@@ -14246,35 +14182,6 @@ F:	drivers/media/platform/nxp/imx-mipi-csis.c
 F:	drivers/media/platform/nxp/imx7-media-csi.c
 F:	drivers/media/platform/nxp/imx8mq-mipi-csi2.c
 
-MEDIA DRIVERS FOR HELENE
-M:	Abylay Ospan <aospan@netup.ru>
-L:	linux-media@vger.kernel.org
-S:	Supported
-W:	https://linuxtv.org
-W:	http://netup.tv/
-T:	git git://linuxtv.org/media_tree.git
-F:	drivers/media/dvb-frontends/helene*
-
-MEDIA DRIVERS FOR HORUS3A
-M:	Sergey Kozlov <serjk@netup.ru>
-M:	Abylay Ospan <aospan@netup.ru>
-L:	linux-media@vger.kernel.org
-S:	Supported
-W:	https://linuxtv.org
-W:	http://netup.tv/
-T:	git git://linuxtv.org/media_tree.git
-F:	drivers/media/dvb-frontends/horus3a*
-
-MEDIA DRIVERS FOR LNBH25
-M:	Sergey Kozlov <serjk@netup.ru>
-M:	Abylay Ospan <aospan@netup.ru>
-L:	linux-media@vger.kernel.org
-S:	Supported
-W:	https://linuxtv.org
-W:	http://netup.tv/
-T:	git git://linuxtv.org/media_tree.git
-F:	drivers/media/dvb-frontends/lnbh25*
-
 MEDIA DRIVERS FOR MXL5XX TUNER DEMODULATORS
 L:	linux-media@vger.kernel.org
 S:	Orphan
@@ -14282,16 +14189,6 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/dvb-frontends/mxl5xx*
 
-MEDIA DRIVERS FOR NETUP PCI UNIVERSAL DVB devices
-M:	Sergey Kozlov <serjk@netup.ru>
-M:	Abylay Ospan <aospan@netup.ru>
-L:	linux-media@vger.kernel.org
-S:	Supported
-W:	https://linuxtv.org
-W:	http://netup.tv/
-T:	git git://linuxtv.org/media_tree.git
-F:	drivers/media/pci/netup_unidvb/*
-
 MEDIA DRIVERS FOR NVIDIA TEGRA - VDE
 M:	Dmitry Osipenko <digetx@gmail.com>
 L:	linux-media@vger.kernel.org
@@ -14935,13 +14832,6 @@ F:	drivers/mtd/
 F:	include/linux/mtd/
 F:	include/uapi/mtd/
 
-MEMSENSING MICROSYSTEMS MSA311 DRIVER
-M:	Dmitry Rokosov <ddrokosov@sberdevices.ru>
-L:	linux-iio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/iio/accel/memsensing,msa311.yaml
-F:	drivers/iio/accel/msa311.c
-
 MEN A21 WATCHDOG DRIVER
 M:	Johannes Thumshirn <morbidrsa@gmail.com>
 L:	linux-watchdog@vger.kernel.org
@@ -15275,7 +15165,6 @@ F:	drivers/tty/serial/8250/8250_pci1xxxx.c
 
 MICROCHIP POLARFIRE FPGA DRIVERS
 M:	Conor Dooley <conor.dooley@microchip.com>
-R:	Vladimir Georgiev <v.georgiev@metrotek.ru>
 L:	linux-fpga@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/fpga/microchip,mpf-spi-fpga-mgr.yaml
@@ -15530,17 +15419,6 @@ F:	arch/mips/
 F:	drivers/platform/mips/
 F:	include/dt-bindings/mips/
 
-MIPS BAIKAL-T1 PLATFORM
-M:	Serge Semin <fancer.lancer@gmail.com>
-L:	linux-mips@vger.kernel.org
-S:	Supported
-F:	Documentation/devicetree/bindings/bus/baikal,bt1-*.yaml
-F:	Documentation/devicetree/bindings/clock/baikal,bt1-*.yaml
-F:	drivers/bus/bt1-*.c
-F:	drivers/clk/baikal-t1/
-F:	drivers/memory/bt1-l2-ctl.c
-F:	drivers/mtd/maps/physmap-bt1-rom.[ch]
-
 MIPS BOSTON DEVELOPMENT BOARD
 M:	Paul Burton <paulburton@kernel.org>
 L:	linux-mips@vger.kernel.org
@@ -15553,7 +15431,6 @@ F:	include/dt-bindings/clock/boston-clock.h
 
 MIPS CORE DRIVERS
 M:	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
-M:	Serge Semin <fancer.lancer@gmail.com>
 L:	linux-mips@vger.kernel.org
 S:	Supported
 F:	drivers/bus/mips_cdmm.c
@@ -16521,12 +16398,6 @@ F:	include/linux/ntb.h
 F:	include/linux/ntb_transport.h
 F:	tools/testing/selftests/ntb/
 
-NTB IDT DRIVER
-M:	Serge Semin <fancer.lancer@gmail.com>
-L:	ntb@lists.linux.dev
-S:	Supported
-F:	drivers/ntb/hw/idt/
-
 NTB INTEL DRIVER
 M:	Dave Jiang <dave.jiang@intel.com>
 L:	ntb@lists.linux.dev
@@ -18547,13 +18418,6 @@ F:	drivers/pps/
 F:	include/linux/pps*.h
 F:	include/uapi/linux/pps.h
 
-PPTP DRIVER
-M:	Dmitry Kozlov <xeb@mail.ru>
-L:	netdev@vger.kernel.org
-S:	Maintained
-W:	http://sourceforge.net/projects/accel-pptp
-F:	drivers/net/ppp/pptp.c
-
 PRESSURE STALL INFORMATION (PSI)
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Suren Baghdasaryan <surenb@google.com>
@@ -19636,15 +19500,6 @@ S:	Supported
 F:	Documentation/devicetree/bindings/i2c/renesas,iic-emev2.yaml
 F:	drivers/i2c/busses/i2c-emev2.c
 
-RENESAS ETHERNET AVB DRIVER
-R:	Sergey Shtylyov <s.shtylyov@omp.ru>
-L:	netdev@vger.kernel.org
-L:	linux-renesas-soc@vger.kernel.org
-F:	Documentation/devicetree/bindings/net/renesas,etheravb.yaml
-F:	drivers/net/ethernet/renesas/Kconfig
-F:	drivers/net/ethernet/renesas/Makefile
-F:	drivers/net/ethernet/renesas/ravb*
-
 RENESAS ETHERNET SWITCH DRIVER
 R:	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
 L:	netdev@vger.kernel.org
@@ -19694,14 +19549,6 @@ F:	Documentation/devicetree/bindings/i2c/renesas,rmobile-iic.yaml
 F:	drivers/i2c/busses/i2c-rcar.c
 F:	drivers/i2c/busses/i2c-sh_mobile.c
 
-RENESAS R-CAR SATA DRIVER
-R:	Sergey Shtylyov <s.shtylyov@omp.ru>
-L:	linux-ide@vger.kernel.org
-L:	linux-renesas-soc@vger.kernel.org
-S:	Supported
-F:	Documentation/devicetree/bindings/ata/renesas,rcar-sata.yaml
-F:	drivers/ata/sata_rcar.c
-
 RENESAS R-CAR THERMAL DRIVERS
 M:	Niklas Söderlund <niklas.soderlund@ragnatech.se>
 L:	linux-renesas-soc@vger.kernel.org
@@ -19777,16 +19624,6 @@ S:	Supported
 F:	Documentation/devicetree/bindings/i2c/renesas,rzv2m.yaml
 F:	drivers/i2c/busses/i2c-rzv2m.c
 
-RENESAS SUPERH ETHERNET DRIVER
-R:	Sergey Shtylyov <s.shtylyov@omp.ru>
-L:	netdev@vger.kernel.org
-L:	linux-renesas-soc@vger.kernel.org
-F:	Documentation/devicetree/bindings/net/renesas,ether.yaml
-F:	drivers/net/ethernet/renesas/Kconfig
-F:	drivers/net/ethernet/renesas/Makefile
-F:	drivers/net/ethernet/renesas/sh_eth*
-F:	include/linux/sh_eth.h
-
 RENESAS USB PHY DRIVER
 M:	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
 L:	linux-renesas-soc@vger.kernel.org
@@ -22440,19 +22277,11 @@ F:	drivers/tty/serial/8250/8250_lpss.c
 
 SYNOPSYS DESIGNWARE APB GPIO DRIVER
 M:	Hoan Tran <hoan@os.amperecomputing.com>
-M:	Serge Semin <fancer.lancer@gmail.com>
 L:	linux-gpio@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/gpio/snps,dw-apb-gpio.yaml
 F:	drivers/gpio/gpio-dwapb.c
 
-SYNOPSYS DESIGNWARE APB SSI DRIVER
-M:	Serge Semin <fancer.lancer@gmail.com>
-L:	linux-spi@vger.kernel.org
-S:	Supported
-F:	Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
-F:	drivers/spi/spi-dw*
-
 SYNOPSYS DESIGNWARE AXI DMAC DRIVER
 M:	Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
 S:	Maintained
@@ -23762,12 +23591,6 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/hid/hid-udraw-ps3.c
 
-UFS FILESYSTEM
-M:	Evgeniy Dushistov <dushistov@mail.ru>
-S:	Maintained
-F:	Documentation/admin-guide/ufs.rst
-F:	fs/ufs/
-
 UHID USERSPACE HID IO DRIVER
 M:	David Rheinsberg <david@readahead.eu>
 L:	linux-input@vger.kernel.org
-- 
2.47.0

