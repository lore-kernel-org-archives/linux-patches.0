Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C3DBE5D
	for <patches@lists.linux.dev>; Sat, 30 Dec 2023 19:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3YNWA4c"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40b5155e154so101862865e9.3
        for <patches@lists.linux.dev>; Sat, 30 Dec 2023 11:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703965141; x=1704569941; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7JHhM7jbOB+wY2wLgwyx4XsHrIJ0CwMn7xqcJQu5ww=;
        b=E3YNWA4cdn6Bg3J3sS/2SXDwVdlNIiTPYFDQiOK9x+KUw60xcgDtFC1edVmmigHWvZ
         6S+Mlox8emQ+oFFA+e0A1lMLrY59HR3+/fahw7nSLN+7mwiokgu/0SJHzFZ1bQaIfbAH
         a3gddo7u5ntv+0ZsMxigLJJieVQ535YOSZieDPhmU1Jg+IKiQrDyEads6cmG2H1AxG8q
         IKQ77YyOl/4hTgXAv1STF+RBrIAlTEId9T4cyZ2hkfc4Z4hPfmVglT2xpffA80v023Gc
         XaDx4nahh8fvkZbOYk2dBvtKfVAFb22DyLgQRTugpr6ln0P6DoSiYUC+TpMEllY0s0Tj
         7++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703965141; x=1704569941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7JHhM7jbOB+wY2wLgwyx4XsHrIJ0CwMn7xqcJQu5ww=;
        b=GF60tT4y/Gts57RSeWFgmpa3y6Xj0mxR69sX1JJiOs/aSt03NjBa0YN2JGuywbX2fm
         8L2sd9drYB8mYW2yfhyQkxJZN2s1h9MLoW579XspBEkaRyKpll7rLYl2IyIPlWFoWNNO
         Iq/pzdmEyoG7HwcUfZV4F3f7Kq5je0i3BOqMPRJ/ZDsrzs3+4rHoQKXKAzd6Ybn9bkAk
         VKai2ts2FcBcLZDK3BWzWiUU23BImB+zQXL5uOkECirridNDaB93T//0Lkw2lgRW6oWk
         F5qlT7k0gnjTXJ4VEbDIzk+Crz82CRE1DIW9TD8P/rXk/GEKVQovZigr+D+3vy8cVLnD
         uszg==
X-Gm-Message-State: AOJu0YyokdHPgTmPimmDMr9gwbirE7Jv5l4e2lVp0Dzf8WYJpgXHw50N
	78FZxDHu0ljoET4n3dhqkRE=
X-Google-Smtp-Source: AGHT+IFEGA0A7r9OvarUZi116HsIRUFLLyo3Djefw7VCB6dNZsNsbGiwrCgq9zTnsB00AIPHlJLJUA==
X-Received: by 2002:a05:600c:4506:b0:40d:6c77:8570 with SMTP id t6-20020a05600c450600b0040d6c778570mr2047305wmo.72.1703965141079;
        Sat, 30 Dec 2023 11:39:01 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c3b9200b0040d8632cb60sm435361wms.34.2023.12.30.11.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Dec 2023 11:39:00 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id B3B03BE2DE0; Sat, 30 Dec 2023 20:38:59 +0100 (CET)
Date: Sat, 30 Dec 2023 20:38:59 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Christoph Hellwig <hch@lst.de>, Huacai Chen <chenhuacai@kernel.org>,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH 5.10 81/97] MIPS: Loongson64: Enable DMA noncoherent
 support
Message-ID: <ZZBx01WttA3R1XjI@eldamar.lan>
References: <20231211182019.802717483@linuxfoundation.org>
 <20231211182023.277870337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182023.277870337@linuxfoundation.org>

Hi,

On Mon, Dec 11, 2023 at 07:22:24PM +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jiaxun Yang <jiaxun.yang@flygoat.com>
> 
> commit edc0378eee00200a5bedf1bb9f00ad390e0d1bd4 upstream.
> 
> There are some Loongson64 systems come with broken coherent DMA
> support, firmware will set a bit in boot_param and pass nocoherentio
> in cmdline.
> 
> However nonconherent support was missed out when spin off Loongson-2EF
> form Loongson64, and that boot_param change never made itself into
> upstream.
> 
> Support DMA noncoherent properly to get those systems working.
> 
> Cc: stable@vger.kernel.org
> Fixes: 71e2f4dd5a65 ("MIPS: Fork loongson2ef from loongson64")
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/mips/Kconfig                                  |    2 ++
>  arch/mips/include/asm/mach-loongson64/boot_param.h |    3 ++-
>  arch/mips/loongson64/env.c                         |   10 +++++++++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -468,6 +468,7 @@ config MACH_LOONGSON2EF
>  
>  config MACH_LOONGSON64
>  	bool "Loongson 64-bit family of machines"
> +	select ARCH_DMA_DEFAULT_COHERENT
>  	select ARCH_SPARSEMEM_ENABLE
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
>  	select ARCH_MIGHT_HAVE_PC_SERIO
> @@ -1379,6 +1380,7 @@ config CPU_LOONGSON64
>  	select CPU_SUPPORTS_MSA
>  	select CPU_DIEI_BROKEN if !LOONGSON3_ENHANCEMENT
>  	select CPU_MIPSR2_IRQ_VI
> +	select DMA_NONCOHERENT
>  	select WEAK_ORDERING
>  	select WEAK_REORDERING_BEYOND_LLSC
>  	select MIPS_ASID_BITS_VARIABLE
> --- a/arch/mips/include/asm/mach-loongson64/boot_param.h
> +++ b/arch/mips/include/asm/mach-loongson64/boot_param.h
> @@ -117,7 +117,8 @@ struct irq_source_routing_table {
>  	u64 pci_io_start_addr;
>  	u64 pci_io_end_addr;
>  	u64 pci_config_addr;
> -	u32 dma_mask_bits;
> +	u16 dma_mask_bits;
> +	u16 dma_noncoherent;
>  } __packed;
>  
>  struct interface_info {
> --- a/arch/mips/loongson64/env.c
> +++ b/arch/mips/loongson64/env.c
> @@ -13,6 +13,8 @@
>   * Copyright (C) 2009 Lemote Inc.
>   * Author: Wu Zhangjin, wuzhangjin@gmail.com
>   */
> +
> +#include <linux/dma-map-ops.h>
>  #include <linux/export.h>
>  #include <linux/pci_ids.h>
>  #include <asm/bootinfo.h>
> @@ -131,8 +133,14 @@ void __init prom_init_env(void)
>  	loongson_sysconf.pci_io_base = eirq_source->pci_io_start_addr;
>  	loongson_sysconf.dma_mask_bits = eirq_source->dma_mask_bits;
>  	if (loongson_sysconf.dma_mask_bits < 32 ||
> -		loongson_sysconf.dma_mask_bits > 64)
> +			loongson_sysconf.dma_mask_bits > 64) {
>  		loongson_sysconf.dma_mask_bits = 32;
> +		dma_default_coherent = true;
> +	} else {
> +		dma_default_coherent = !eirq_source->dma_noncoherent;
> +	}
> +
> +	pr_info("Firmware: Coherent DMA: %s\n", dma_default_coherent ? "on" : "off");
>  
>  	loongson_sysconf.restart_addr = boot_p->reset_system.ResetWarm;
>  	loongson_sysconf.poweroff_addr = boot_p->reset_system.Shutdown;

While preparing an update for Debian and finally building for all
supported architecture, the builds for mipsel and mips64el were
failing with:

/<<PKGBUILDDIR>>/arch/mips/loongson64/env.c: In function 'prom_init_env':
/<<PKGBUILDDIR>>/arch/mips/loongson64/env.c:138:3: error: 'dma_default_coherent' undeclared (first use in this function); did you mean 'dma_free_coherent'?
  138 |   dma_default_coherent = true;
      |   ^~~~~~~~~~~~~~~~~~~~
      |   dma_free_coherent
/<<PKGBUILDDIR>>/arch/mips/loongson64/env.c:138:3: note: each undeclared identifier is reported only once for each function it appears in
make[6]: *** [/<<PKGBUILDDIR>>/scripts/Makefile.build:291: arch/mips/loongson64/env.o] Error 1
make[6]: *** Waiting for unfinished jobs....

Is here a prerequisite missing for the commit?

Backporting though 6d4e9a8efe3d ("driver core: lift dma_default_coherent into
common code") which is from 5.12-rc1 though seems too intrusive, correct? Would
the alternative be to just revert the 3ee7e2faef87 ("MIPS: Loongson64: Enable
DMA noncoherent support") commit which landed in 5.10.204?

Regards,
Salvatore
