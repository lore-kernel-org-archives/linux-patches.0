Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A01719AA46;
	Wed, 23 Oct 2024 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729694868; cv=none; b=NB6/phA1EcQTFfXuJNJwpq5e0DIvIzFnv82q9+TmcIobGHuC8O+E5VFSQaJfZdL+suAuEiiHikdoJohwpDRBoxogxOc+YK7fPW+qy0PVnsI65nInTEMnMgUqr6jRoro2S2/KQzoUjKN9L+pKMbmkBznmNjhfVlCLeqrcyIcBhvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729694868; c=relaxed/simple;
	bh=G7nV0595+QdxL/Bdb/5BBR9rBXEA70xZKwEIsowEpy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IkVDIFZX/+EIUaMNXs34rxQ6trvjJvkpTsOIQIzmFKd1UBa7kZjYg7WotLqn5/dCVvgNEfrmtfu+1+k2btjSWdjQ8yde3VOq78G9RkD9iMeamRTRXVeZtwLaJa4mv9E6BNHx0Hdy46GiqDU/kuuV8VRcXsd9KYnlQb7K6eVtHmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+UDPEVz; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+UDPEVz"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20c6f492d2dso79875285ad.0;
        Wed, 23 Oct 2024 07:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729694865; x=1730299665; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUqhFqL+Zg6XvavgGcWGzdRxe6SAMlyCd/batBn/A/8=;
        b=J+UDPEVzz/sFJwwQjDhD3ZSKeuCBr9nM/ViZDEhNoAkhXdaY5sngAsUDYgziQ1HMwW
         FnN3rxaUtYvKYMQKPvdktRzaXbq+IPpBQzhhF/vh9L3ooQsRU1PmxV3iBPCB4IJs4Lux
         9H4WTbtVMY2Qu5AxgygwRH5Omubz3fyYDqT+YDHr8dSkmn2O1lnD5EpKlHDMJevaU5kK
         CpOw0YS7oMh5e+/DEEQXrXGo9nIudVNPLzuw8aZkU+875Fc/s0j9c+EYCFuOXd5O4DEw
         QWk4ebgaMphe2wvuokENysTEeD901Gls6sC2PgZTDl3XRgwKbjxkEUJOi3REnn/+hrSP
         eoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729694865; x=1730299665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oUqhFqL+Zg6XvavgGcWGzdRxe6SAMlyCd/batBn/A/8=;
        b=rohAuG6ShjErGNgMbKKIBO/pN89W7hOQpSwrMOR96OsZXDbuTKv6fWDsafOJulR9/8
         cQ1XQDgpEoF8SQn/yR5eqapix6ssb2AQmQ3E1kOuclCVVNCgEg8z/n6L0ORxdZwXnJbF
         ru6ScQQdhM75gNgxlJ+6NufjsQbTE/0fqfWYmu153t6GFSG5gPbNwQ1ha/rKi/eqYI4j
         J5x4iW6YGrh4Pw5GKwHw6V1FtBjkTSB8M+BfWOmrXhRY4NSOxcCTlmP83I+KBzsar75v
         U36QeDDqfy+UeifW0xyttQsM/+lzYTeykXgszqHDrx5pjLeSbLUKXTf8IQSoEnZXAEZt
         2hkw==
X-Forwarded-Encrypted: i=1; AJvYcCUWUQwRZvlT1f5CSEAiuHdBB5lDLYflQxmkp4mq5H2/hOY1jel00eBHylllU2lTuAVE76vUjyKIDg==@lists.linux.dev, AJvYcCVMKZnJRph/1Tts3TEzrhWEOiunBYUlQnw59jpGaInfY1AZNAkdcyXba79QLPdcqgAwx90=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZvoVaAXR3ulJuIGja82co9/j/VQWc+jVi/uhrePvyioOBSTxK
	dxSCzff04Y17jGqxFmb9sptxVVTojUreV/qTeILk1gClqor+Urqp
X-Google-Smtp-Source: AGHT+IFrOeQe/TaOIUf37oS9/kPD1q9KCCPzPv9f2hTZnTNLqUg1SZo5nQm+mzGCGEJmuC13zVMRVA==
X-Received: by 2002:a17:902:ea0f:b0:206:c486:4c4c with SMTP id d9443c01a7336-20fab2da20cmr33057325ad.57.1729694864996;
        Wed, 23 Oct 2024 07:47:44 -0700 (PDT)
Received: from localhost.localdomain ([43.129.202.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0c0e09sm58444105ad.139.2024.10.23.07.47.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Oct 2024 07:47:44 -0700 (PDT)
From: Lance Yang <ioworker0@gmail.com>
To: kexybiscuit@aosc.io
Cc: aospan@netup.ru,
	conor.dooley@microchip.com,
	ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org,
	dushistov@mail.ru,
	fancer.lancer@gmail.com,
	geert@linux-m68k.org,
	gregkh@linuxfoundation.org,
	hoan@os.amperecomputing.com,
	ink@jurassic.park.msu.ru,
	jeffbai@aosc.io,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com,
	netdev@vger.kernel.org,
	nikita@trvn.ru,
	ntb@lists.linux.dev,
	patches@lists.linux.dev,
	richard.henderson@linaro.org,
	s.shtylyov@omp.ru,
	serjk@netup.ru,
	shc_work@mail.ru,
	torvalds@linux-foundation.org,
	tsbogend@alpha.franken.de,
	v.georgiev@metrotek.ru,
	wangyuli@uniontech.com,
	wsa+renesas@sang-engineering.com,
	xeb@mail.ru,
	Lance Yang <ioworker0@gmail.com>
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various compliance requirements."
Date: Wed, 23 Oct 2024 22:47:14 +0800
Message-ID: <20241023144716.69132-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023080935.2945-2-kexybiscuit@aosc.io>
References: <20241023080935.2945-2-kexybiscuit@aosc.io>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Oct 23, 2024 at 4:19 PM Kexy Biscuit <kexybiscuit@aosc.io> wrote:
>
> This reverts commit 6e90b675cf942e50c70e8394dfb5862975c3b3b2.
>
> An absolutely no-one-ever-reviewed patch, not even by the maintainers who
> got removed themselves - at least not on the mailing list. Then the patch
> just got slipped into an unrelated subsystem pull request, and got pulled
> by Torvalds with not even a comment.
>
> What about the next time? Who next would be removed from the MAINTAINERS
> file, the kernel.org infrastructure? What if the compliance requires
> another XZ backdoor to be developed without further explanation? Is the
> kernel development process still done in public?
>
> Are the "compliance requirements" documented on docs.kernel.org? Who are
> responsible for them? Are all that are responsible employees of
> The Linux Foundation, which is regulated by the U.S. legislature?
>
> Fixes: 6e90b675cf94 ("MAINTAINERS: Remove some entries due to various compliance requirements.")
> Signed-off-by: Kexy Biscuit <kexybiscuit@aosc.io>

OMG, I cannot believe this is true :(
Please keep all discussions on at least one of the mailling lists.

Acked-by: Lance Yang <ioworker0@gmail.com>

Thanks,
Lance

> ---
> Please keep all discussions on at least one of the mailing lists.
>
>  MAINTAINERS | 178 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 178 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e9659a5a7fb3..501aa5c0887e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -258,6 +258,12 @@ L: linux-acenic@sunsite.dk
>  S:     Maintained
>  F:     drivers/net/ethernet/alteon/acenic*
>
> +ACER ASPIRE 1 EMBEDDED CONTROLLER DRIVER
> +M:     Nikita Travkin <nikita@trvn.ru>
> +S:     Maintained
> +F:     Documentation/devicetree/bindings/platform/acer,aspire1-ec.yaml
> +F:     drivers/platform/arm64/acer-aspire1-ec.c
> +
>  ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
>  M:     Peter Kaestle <peter@piie.net>
>  L:     platform-driver-x86@vger.kernel.org
> @@ -882,6 +888,7 @@ F:  drivers/staging/media/sunxi/cedrus/
>
>  ALPHA PORT
>  M:     Richard Henderson <richard.henderson@linaro.org>
> +M:     Ivan Kokshaysky <ink@jurassic.park.msu.ru>
>  M:     Matt Turner <mattst88@gmail.com>
>  L:     linux-alpha@vger.kernel.org
>  S:     Odd Fixes
> @@ -2256,6 +2263,12 @@ L:       linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:     Maintained
>  F:     arch/arm/mach-ep93xx/ts72xx.c
>
> +ARM/CIRRUS LOGIC CLPS711X ARM ARCHITECTURE
> +M:     Alexander Shiyan <shc_work@mail.ru>
> +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:     Odd Fixes
> +N:     clps711x
> +
>  ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
>  M:     Hartley Sweeten <hsweeten@visionengravers.com>
>  M:     Alexander Sverdlin <alexander.sverdlin@gmail.com>
> @@ -3802,6 +3815,14 @@ F:       drivers/video/backlight/
>  F:     include/linux/backlight.h
>  F:     include/linux/pwm_backlight.h
>
> +BAIKAL-T1 PVT HARDWARE MONITOR DRIVER
> +M:     Serge Semin <fancer.lancer@gmail.com>
> +L:     linux-hwmon@vger.kernel.org
> +S:     Supported
> +F:     Documentation/devicetree/bindings/hwmon/baikal,bt1-pvt.yaml
> +F:     Documentation/hwmon/bt1-pvt.rst
> +F:     drivers/hwmon/bt1-pvt.[ch]
> +
>  BARCO P50 GPIO DRIVER
>  M:     Santosh Kumar Yadav <santoshkumar.yadav@barco.com>
>  M:     Peter Korsgaard <peter.korsgaard@barco.com>
> @@ -6455,6 +6476,7 @@ F:        drivers/mtd/nand/raw/denali*
>
>  DESIGNWARE EDMA CORE IP DRIVER
>  M:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> +R:     Serge Semin <fancer.lancer@gmail.com>
>  L:     dmaengine@vger.kernel.org
>  S:     Maintained
>  F:     drivers/dma/dw-edma/
> @@ -9737,6 +9759,14 @@ F:       drivers/gpio/gpiolib-cdev.c
>  F:     include/uapi/linux/gpio.h
>  F:     tools/gpio/
>
> +GRE DEMULTIPLEXER DRIVER
> +M:     Dmitry Kozlov <xeb@mail.ru>
> +L:     netdev@vger.kernel.org
> +S:     Maintained
> +F:     include/net/gre.h
> +F:     net/ipv4/gre_demux.c
> +F:     net/ipv4/gre_offload.c
> +
>  GRETH 10/100/1G Ethernet MAC device driver
>  M:     Andreas Larsson <andreas@gaisler.com>
>  L:     netdev@vger.kernel.org
> @@ -12929,6 +12959,12 @@ S:     Maintained
>  F:     drivers/ata/pata_arasan_cf.c
>  F:     include/linux/pata_arasan_cf_data.h
>
> +LIBATA PATA DRIVERS
> +R:     Sergey Shtylyov <s.shtylyov@omp.ru>
> +L:     linux-ide@vger.kernel.org
> +F:     drivers/ata/ata_*.c
> +F:     drivers/ata/pata_*.c
> +
>  LIBATA PATA FARADAY FTIDE010 AND GEMINI SATA BRIDGE DRIVERS
>  M:     Linus Walleij <linus.walleij@linaro.org>
>  L:     linux-ide@vger.kernel.org
> @@ -12945,6 +12981,15 @@ F:     drivers/ata/ahci_platform.c
>  F:     drivers/ata/libahci_platform.c
>  F:     include/linux/ahci_platform.h
>
> +LIBATA SATA AHCI SYNOPSYS DWC CONTROLLER DRIVER
> +M:     Serge Semin <fancer.lancer@gmail.com>
> +L:     linux-ide@vger.kernel.org
> +S:     Maintained
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata.git
> +F:     Documentation/devicetree/bindings/ata/baikal,bt1-ahci.yaml
> +F:     Documentation/devicetree/bindings/ata/snps,dwc-ahci.yaml
> +F:     drivers/ata/ahci_dwc.c
> +
>  LIBATA SATA PROMISE TX2/TX4 CONTROLLER DRIVER
>  M:     Mikael Pettersson <mikpelinux@gmail.com>
>  L:     linux-ide@vger.kernel.org
> @@ -14140,6 +14185,16 @@ S:     Maintained
>  T:     git git://linuxtv.org/media_tree.git
>  F:     drivers/media/platform/nxp/imx-pxp.[ch]
>
> +MEDIA DRIVERS FOR ASCOT2E
> +M:     Sergey Kozlov <serjk@netup.ru>
> +M:     Abylay Ospan <aospan@netup.ru>
> +L:     linux-media@vger.kernel.org
> +S:     Supported
> +W:     https://linuxtv.org
> +W:     http://netup.tv/
> +T:     git git://linuxtv.org/media_tree.git
> +F:     drivers/media/dvb-frontends/ascot2e*
> +
>  MEDIA DRIVERS FOR CXD2099AR CI CONTROLLERS
>  M:     Jasmin Jessich <jasmin@anw.at>
>  L:     linux-media@vger.kernel.org
> @@ -14148,6 +14203,16 @@ W:     https://linuxtv.org
>  T:     git git://linuxtv.org/media_tree.git
>  F:     drivers/media/dvb-frontends/cxd2099*
>
> +MEDIA DRIVERS FOR CXD2841ER
> +M:     Sergey Kozlov <serjk@netup.ru>
> +M:     Abylay Ospan <aospan@netup.ru>
> +L:     linux-media@vger.kernel.org
> +S:     Supported
> +W:     https://linuxtv.org
> +W:     http://netup.tv/
> +T:     git git://linuxtv.org/media_tree.git
> +F:     drivers/media/dvb-frontends/cxd2841er*
> +
>  MEDIA DRIVERS FOR CXD2880
>  M:     Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
>  L:     linux-media@vger.kernel.org
> @@ -14192,6 +14257,35 @@ F:     drivers/media/platform/nxp/imx-mipi-csis.c
>  F:     drivers/media/platform/nxp/imx7-media-csi.c
>  F:     drivers/media/platform/nxp/imx8mq-mipi-csi2.c
>
> +MEDIA DRIVERS FOR HELENE
> +M:     Abylay Ospan <aospan@netup.ru>
> +L:     linux-media@vger.kernel.org
> +S:     Supported
> +W:     https://linuxtv.org
> +W:     http://netup.tv/
> +T:     git git://linuxtv.org/media_tree.git
> +F:     drivers/media/dvb-frontends/helene*
> +
> +MEDIA DRIVERS FOR HORUS3A
> +M:     Sergey Kozlov <serjk@netup.ru>
> +M:     Abylay Ospan <aospan@netup.ru>
> +L:     linux-media@vger.kernel.org
> +S:     Supported
> +W:     https://linuxtv.org
> +W:     http://netup.tv/
> +T:     git git://linuxtv.org/media_tree.git
> +F:     drivers/media/dvb-frontends/horus3a*
> +
> +MEDIA DRIVERS FOR LNBH25
> +M:     Sergey Kozlov <serjk@netup.ru>
> +M:     Abylay Ospan <aospan@netup.ru>
> +L:     linux-media@vger.kernel.org
> +S:     Supported
> +W:     https://linuxtv.org
> +W:     http://netup.tv/
> +T:     git git://linuxtv.org/media_tree.git
> +F:     drivers/media/dvb-frontends/lnbh25*
> +
>  MEDIA DRIVERS FOR MXL5XX TUNER DEMODULATORS
>  L:     linux-media@vger.kernel.org
>  S:     Orphan
> @@ -14199,6 +14293,16 @@ W:     https://linuxtv.org
>  T:     git git://linuxtv.org/media_tree.git
>  F:     drivers/media/dvb-frontends/mxl5xx*
>
> +MEDIA DRIVERS FOR NETUP PCI UNIVERSAL DVB devices
> +M:     Sergey Kozlov <serjk@netup.ru>
> +M:     Abylay Ospan <aospan@netup.ru>
> +L:     linux-media@vger.kernel.org
> +S:     Supported
> +W:     https://linuxtv.org
> +W:     http://netup.tv/
> +T:     git git://linuxtv.org/media_tree.git
> +F:     drivers/media/pci/netup_unidvb/*
> +
>  MEDIA DRIVERS FOR NVIDIA TEGRA - VDE
>  M:     Dmitry Osipenko <digetx@gmail.com>
>  L:     linux-media@vger.kernel.org
> @@ -14842,6 +14946,13 @@ F:     drivers/mtd/
>  F:     include/linux/mtd/
>  F:     include/uapi/mtd/
>
> +MEMSENSING MICROSYSTEMS MSA311 DRIVER
> +M:     Dmitry Rokosov <ddrokosov@sberdevices.ru>
> +L:     linux-iio@vger.kernel.org
> +S:     Maintained
> +F:     Documentation/devicetree/bindings/iio/accel/memsensing,msa311.yaml
> +F:     drivers/iio/accel/msa311.c
> +
>  MEN A21 WATCHDOG DRIVER
>  M:     Johannes Thumshirn <morbidrsa@gmail.com>
>  L:     linux-watchdog@vger.kernel.org
> @@ -15175,6 +15286,7 @@ F:      drivers/tty/serial/8250/8250_pci1xxxx.c
>
>  MICROCHIP POLARFIRE FPGA DRIVERS
>  M:     Conor Dooley <conor.dooley@microchip.com>
> +R:     Vladimir Georgiev <v.georgiev@metrotek.ru>
>  L:     linux-fpga@vger.kernel.org
>  S:     Supported
>  F:     Documentation/devicetree/bindings/fpga/microchip,mpf-spi-fpga-mgr.yaml
> @@ -15429,6 +15541,17 @@ F:     arch/mips/
>  F:     drivers/platform/mips/
>  F:     include/dt-bindings/mips/
>
> +MIPS BAIKAL-T1 PLATFORM
> +M:     Serge Semin <fancer.lancer@gmail.com>
> +L:     linux-mips@vger.kernel.org
> +S:     Supported
> +F:     Documentation/devicetree/bindings/bus/baikal,bt1-*.yaml
> +F:     Documentation/devicetree/bindings/clock/baikal,bt1-*.yaml
> +F:     drivers/bus/bt1-*.c
> +F:     drivers/clk/baikal-t1/
> +F:     drivers/memory/bt1-l2-ctl.c
> +F:     drivers/mtd/maps/physmap-bt1-rom.[ch]
> +
>  MIPS BOSTON DEVELOPMENT BOARD
>  M:     Paul Burton <paulburton@kernel.org>
>  L:     linux-mips@vger.kernel.org
> @@ -15441,6 +15564,7 @@ F:      include/dt-bindings/clock/boston-clock.h
>
>  MIPS CORE DRIVERS
>  M:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> +M:     Serge Semin <fancer.lancer@gmail.com>
>  L:     linux-mips@vger.kernel.org
>  S:     Supported
>  F:     drivers/bus/mips_cdmm.c
> @@ -16408,6 +16532,12 @@ F:     include/linux/ntb.h
>  F:     include/linux/ntb_transport.h
>  F:     tools/testing/selftests/ntb/
>
> +NTB IDT DRIVER
> +M:     Serge Semin <fancer.lancer@gmail.com>
> +L:     ntb@lists.linux.dev
> +S:     Supported
> +F:     drivers/ntb/hw/idt/
> +
>  NTB INTEL DRIVER
>  M:     Dave Jiang <dave.jiang@intel.com>
>  L:     ntb@lists.linux.dev
> @@ -18428,6 +18558,13 @@ F:     drivers/pps/
>  F:     include/linux/pps*.h
>  F:     include/uapi/linux/pps.h
>
> +PPTP DRIVER
> +M:     Dmitry Kozlov <xeb@mail.ru>
> +L:     netdev@vger.kernel.org
> +S:     Maintained
> +W:     http://sourceforge.net/projects/accel-pptp
> +F:     drivers/net/ppp/pptp.c
> +
>  PRESSURE STALL INFORMATION (PSI)
>  M:     Johannes Weiner <hannes@cmpxchg.org>
>  M:     Suren Baghdasaryan <surenb@google.com>
> @@ -19518,6 +19655,15 @@ S:     Supported
>  F:     Documentation/devicetree/bindings/i2c/renesas,iic-emev2.yaml
>  F:     drivers/i2c/busses/i2c-emev2.c
>
> +RENESAS ETHERNET AVB DRIVER
> +R:     Sergey Shtylyov <s.shtylyov@omp.ru>
> +L:     netdev@vger.kernel.org
> +L:     linux-renesas-soc@vger.kernel.org
> +F:     Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> +F:     drivers/net/ethernet/renesas/Kconfig
> +F:     drivers/net/ethernet/renesas/Makefile
> +F:     drivers/net/ethernet/renesas/ravb*
> +
>  RENESAS ETHERNET SWITCH DRIVER
>  R:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>  L:     netdev@vger.kernel.org
> @@ -19567,6 +19713,14 @@ F:     Documentation/devicetree/bindings/i2c/renesas,rmobile-iic.yaml
>  F:     drivers/i2c/busses/i2c-rcar.c
>  F:     drivers/i2c/busses/i2c-sh_mobile.c
>
> +RENESAS R-CAR SATA DRIVER
> +R:     Sergey Shtylyov <s.shtylyov@omp.ru>
> +L:     linux-ide@vger.kernel.org
> +L:     linux-renesas-soc@vger.kernel.org
> +S:     Supported
> +F:     Documentation/devicetree/bindings/ata/renesas,rcar-sata.yaml
> +F:     drivers/ata/sata_rcar.c
> +
>  RENESAS R-CAR THERMAL DRIVERS
>  M:     Niklas Söderlund <niklas.soderlund@ragnatech.se>
>  L:     linux-renesas-soc@vger.kernel.org
> @@ -19642,6 +19796,16 @@ S:     Supported
>  F:     Documentation/devicetree/bindings/i2c/renesas,rzv2m.yaml
>  F:     drivers/i2c/busses/i2c-rzv2m.c
>
> +RENESAS SUPERH ETHERNET DRIVER
> +R:     Sergey Shtylyov <s.shtylyov@omp.ru>
> +L:     netdev@vger.kernel.org
> +L:     linux-renesas-soc@vger.kernel.org
> +F:     Documentation/devicetree/bindings/net/renesas,ether.yaml
> +F:     drivers/net/ethernet/renesas/Kconfig
> +F:     drivers/net/ethernet/renesas/Makefile
> +F:     drivers/net/ethernet/renesas/sh_eth*
> +F:     include/linux/sh_eth.h
> +
>  RENESAS USB PHY DRIVER
>  M:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>  L:     linux-renesas-soc@vger.kernel.org
> @@ -22295,11 +22459,19 @@ F:    drivers/tty/serial/8250/8250_lpss.c
>
>  SYNOPSYS DESIGNWARE APB GPIO DRIVER
>  M:     Hoan Tran <hoan@os.amperecomputing.com>
> +M:     Serge Semin <fancer.lancer@gmail.com>
>  L:     linux-gpio@vger.kernel.org
>  S:     Maintained
>  F:     Documentation/devicetree/bindings/gpio/snps,dw-apb-gpio.yaml
>  F:     drivers/gpio/gpio-dwapb.c
>
> +SYNOPSYS DESIGNWARE APB SSI DRIVER
> +M:     Serge Semin <fancer.lancer@gmail.com>
> +L:     linux-spi@vger.kernel.org
> +S:     Supported
> +F:     Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
> +F:     drivers/spi/spi-dw*
> +
>  SYNOPSYS DESIGNWARE AXI DMAC DRIVER
>  M:     Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
>  S:     Maintained
> @@ -23609,6 +23781,12 @@ L:     linux-input@vger.kernel.org
>  S:     Maintained
>  F:     drivers/hid/hid-udraw-ps3.c
>
> +UFS FILESYSTEM
> +M:     Evgeniy Dushistov <dushistov@mail.ru>
> +S:     Maintained
> +F:     Documentation/admin-guide/ufs.rst
> +F:     fs/ufs/
> +
>  UHID USERSPACE HID IO DRIVER
>  M:     David Rheinsberg <david@readahead.eu>
>  L:     linux-input@vger.kernel.org
> --
> 2.47.0
>
>

-- 
2.45.2

