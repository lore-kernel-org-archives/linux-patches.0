Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D52A33
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 08:55:18 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id i133so1826113vki.8
        for <patches@lists.linux.dev>; Fri, 04 Mar 2022 00:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L/NeTMxhGm+l5YpPOiR/XhgTXlp1h5VVk6yshpmQCRE=;
        b=56j9XhNYiA8woKGKlSZHTjIQl9iJyNN57/HrtidOR64VIfI1Alv0MdyLfepbuzK3nI
         aemnpRGqNE2ciGcnIie5SPgNxb+kVV+81ww3BW2SlYPjCijCdUO89gPsYI59l9PjVjp2
         n367k8MBeE4oQGC0zgMfYmY3SD7QBEm6lUoiIIt5xDM87fwapLlCDHMhS49LIXaqkjV9
         7ndTnMqvP3lxOi2rXgZoP7MoYZ7cyAMXl5sY1qDHA7SK6mIgCunWqRdy9V3xPHiCOOXf
         RV5yP1kGG1KD4UlmCX0951WsMLVU6oTKdwGlBX6rwXLQdHzM/X9LaKzIAOdVyTRZ4lCb
         12mw==
X-Gm-Message-State: AOAM533MU87nRVRyKJcU/wpWor6oOsj1Wq/zIqQgQ74KwhOn6os1DdrE
	FCKjldOEsf7Rl6h+Vc3D5k50QsGRelaUrw==
X-Google-Smtp-Source: ABdhPJy6jGjIjexWO6KJdT9i2gPIHsONmpMarQ7d641XB7KH6lA/pr/KJoKA53px21GFC7ZCIdfr9Q==
X-Received: by 2002:a05:6122:2010:b0:32d:aa1a:2e5f with SMTP id l16-20020a056122201000b0032daa1a2e5fmr17304067vkd.16.1646384116960;
        Fri, 04 Mar 2022 00:55:16 -0800 (PST)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id u70-20020ab045cc000000b0034a4433fe7fsm678206uau.33.2022.03.04.00.55.16
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 00:55:16 -0800 (PST)
Received: by mail-ua1-f48.google.com with SMTP id b37so3275092uad.12
        for <patches@lists.linux.dev>; Fri, 04 Mar 2022 00:55:16 -0800 (PST)
X-Received: by 2002:ab0:3da4:0:b0:306:a7f8:f28b with SMTP id
 l36-20020ab03da4000000b00306a7f8f28bmr17141959uac.47.1646384115825; Fri, 04
 Mar 2022 00:55:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220304033531.28667-1-rdunlap@infradead.org>
In-Reply-To: <20220304033531.28667-1-rdunlap@infradead.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 4 Mar 2022 09:55:04 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWM_a7gmBw3gQd+BCTuFGpsHN3o9HuU=ivWnZraYXewqQ@mail.gmail.com>
Message-ID: <CAMuHMdWM_a7gmBw3gQd+BCTuFGpsHN3o9HuU=ivWnZraYXewqQ@mail.gmail.com>
Subject: Re: [PATCH] m68k: tweak coldfire/device.c for COMPILE_TEST
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Angelo Dureghello <angelo@sysam.it>, Greg Ungerer <gerg@kernel.org>, 
	Greg Ungerer <gerg@linux-m68k.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, 
	uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset="UTF-8"

Hi Randy,

On Fri, Mar 4, 2022 at 4:35 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> When CONFIG_MCF_EDMA is set (due to COMPILE_TEST, not due to
> CONFIG_M5441x), coldfire/device.c has compile errors due to
> missing MCFEDMA_* symbols. In the .config file that was provided,
> CONFIG_M5206=y, not CONFIG_M5441x, so <asm/m5441xsim.h> is not
> included in coldfire/device.c.
>
> Only build the MCF_EDMA code in coldfire/device.c if both MCF_EDMA
> and M5441x are enabled.
>
> Fixes these build errors:
>
> ../arch/m68k/coldfire/device.c:512:35: error: 'MCFEDMA_BASE' undeclared here (not in a function); did you mean 'MCFDMA_BASE1'?
>   512 |                 .start          = MCFEDMA_BASE,
> ../arch/m68k/coldfire/device.c:513:50: error: 'MCFEDMA_SIZE' undeclared here (not in a function)
>   513 |                 .end            = MCFEDMA_BASE + MCFEDMA_SIZE - 1,
> ../arch/m68k/coldfire/device.c:517:35: error: 'MCFEDMA_IRQ_INTR0' undeclared here (not in a function)
>   517 |                 .start          = MCFEDMA_IRQ_INTR0,
> ../arch/m68k/coldfire/device.c:523:35: error: 'MCFEDMA_IRQ_INTR16' undeclared here (not in a function)
>   523 |                 .start          = MCFEDMA_IRQ_INTR16,
> ../arch/m68k/coldfire/device.c:529:35: error: 'MCFEDMA_IRQ_INTR56' undeclared here (not in a function)
>   529 |                 .start          = MCFEDMA_IRQ_INTR56,
> ../arch/m68k/coldfire/device.c:535:35: error: 'MCFEDMA_IRQ_ERR' undeclared here (not in a function)
>   535 |                 .start          = MCFEDMA_IRQ_ERR,
>
> Fixes: d7e9d01ac292 ("m68k: add ColdFire mcf5441x eDMA platform support")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Thanks for your patch!

> --- linux-next-20220303.orig/arch/m68k/coldfire/device.c
> +++ linux-next-20220303/arch/m68k/coldfire/device.c
> @@ -480,7 +480,7 @@ static struct platform_device mcf_i2c5 =
>  #endif /* MCFI2C_BASE5 */
>  #endif /* IS_ENABLED(CONFIG_I2C_IMX) */
>
> -#if IS_ENABLED(CONFIG_MCF_EDMA)
> +#if IS_ENABLED(CONFIG_MCF_EDMA) && IS_ENABLED(CONFIG_M5441x)

As this protects hardware description, I'm wondering if this and
below shouldn't just be"#ifdef CONFIG_M5441x"?

See also commit 322c512f476f07e9 ("m68knommu: include SDHC support
only when hardware has it")

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
