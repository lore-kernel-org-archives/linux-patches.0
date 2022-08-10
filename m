Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81654428
	for <patches@lists.linux.dev>; Wed, 10 Aug 2022 21:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6BAC433C1
	for <patches@lists.linux.dev>; Wed, 10 Aug 2022 21:15:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mJ2qrO5M"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 10 Aug 2022 22:15:37 +0100
Resent-Message-ID: <YvQf+cG1RbbJ123R@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 10 Aug 2022 22:14:35 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=A4nv=YO=google.com=ndesaulniers@kernel.org>)
	id 1oLt28-008Sx2-WD
	for broonie@sirena.co.uk; Wed, 10 Aug 2022 22:14:35 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 9EAC4B81E9D
	for <broonie@sirena.co.uk>; Wed, 10 Aug 2022 21:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7D0C7C433B5; Wed, 10 Aug 2022 21:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88AA3C433C1
	for <broonie@kernel.org>; Wed, 10 Aug 2022 21:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 88AA3C433C1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id o2so15618789lfb.1
        for <broonie@kernel.org>; Wed, 10 Aug 2022 14:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KstM2C1nqWzbgiq4lXjESSIV1F+sGBJqXZBKfIDDeII=;
        b=mJ2qrO5MX6fYku8PgLw5AnOtIoBprrurL+nSadvPZ/nI6zBSOd74G8iKYlHjlxhSGK
         USn07FxYrgyBuEIA+f2Mxh4Oa/e+iiBOCs19euWtk22Fu/Z9qw8oaRo30nQiHAkryS6Y
         OkGFpD8kk5juBZ0pa8b2rWt/+dgD8gCXmdnRvQK+0MF8N9K8OaD4UraP7imW+XgEtrf+
         eVDcIqCbW5EuGYwj2bh4+gx/7LwAiCviv4k3pi6iA8Z/WIOSMsyBb/O9EBsYHE7ukUS8
         xokR0vi2c3FQE9t2Udn3bU0+uZ3i4ejbYLZGKdMm/LrvNqJ66BM5i1pvxlXY91KPTSBE
         Nynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KstM2C1nqWzbgiq4lXjESSIV1F+sGBJqXZBKfIDDeII=;
        b=XH0cugIB6XOdHs4JoQ/HdK/m0ltGuXFfLv73KBdRAMFo21BO2LyJ3e9yQm41EkadgB
         dA/bm0vToFIrBkWYfGoujZRJemxTOFMPfcXctDt4X/L074GJYBWX9QtKiVTliW/A82hC
         lqPmJsQ/BpV/fcWcAI2udN4cFvsHf/60tvz+oms+S3J/VKYuKJixosj8GFTx5Zx79zps
         Nk6ie2hpCxhjAoO9BYVGRDjEAexKXuph7bqI7Ig5EEBwzLDB44UActWBLSBgYvBNTmWm
         Git2HuNztHIjXhKZ9drgfxAnDBuWxgYxMztp4UcU57C9SoFduCN5KgncWWHVsXujmX94
         dJ9Q==
X-Gm-Message-State: ACgBeo06F74TI/hdRU0e6uY6RAyZMbama5IdhYlJL9kMrkMSazOI/496
	DrN49QqBLW3sELb68ejCT88ZOfSHDZw5K25+lv/ujQ==
X-Google-Smtp-Source: AA6agR7XAy8+dRFXr1tYRU78D2cRU1qIJone22+JuKdzodOZmAEH3tkfVSaACFucoUikH/AMCJJ0BTbB6CoPorjLq5E=
X-Received: by 2002:ac2:4f03:0:b0:48a:6061:bd8e with SMTP id
 k3-20020ac24f03000000b0048a6061bd8emr11290623lfr.647.1660166068361; Wed, 10
 Aug 2022 14:14:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220810010809.2024482-1-nathan@kernel.org>
In-Reply-To: <20220810010809.2024482-1-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 10 Aug 2022 14:14:16 -0700
Message-ID: <CAKwvOdmZvB_=JTeLg08uMFhEMpWga4FJey50QHjzCv_jMVpwkg@mail.gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>, Liam Girdwood <lgirdwood@gmail.com>, 
	Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Claudiu Beznea <claudiu.beznea@microchip.com>, Tom Rix <trix@redhat.com>, 
	alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=A4nv=YO=google.com=ndesaulniers@kernel.org
Subject: Re: [PATCH] ASoC: mchp-spdiftx: Fix clang -Wbitfield-constant-conversion
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: zMFokUGRt4vO

On Tue, Aug 9, 2022 at 6:08 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> A recent change in clang strengthened its -Wbitfield-constant-conversion
> to warn when 1 is assigned to a 1-bit signed integer bitfield, as it can
> only be 0 or -1, not 1:
>
>   sound/soc/atmel/mchp-spdiftx.c:505:20: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           dev->gclk_enabled = 1;
>                             ^ ~
>   1 error generated.
>
> The actual value of the field is never checked, just that it is not
> zero, so there is not a real bug here. However, it is simple enough to
> silence the warning by making the bitfield unsigned, which matches the
> mchp-spdifrx driver.
>
> Fixes: 06ca24e98e6b ("ASoC: mchp-spdiftx: add driver for S/PDIF TX Controller")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1686
> Link: https://github.com/llvm/llvm-project/commit/82afc9b169a67e8b8a1862fb9c41a2cd974d6691
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Ah yes, my favorite, signed one bit integers...thanks for the patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

grepping for `gclk_enabled`, we see three drivers with similar
duplication (single bit bitfields):

sound/soc/atmel/mchp-spdifrx.c
241: unsigned int gclk_enabled:1;

sound/soc/atmel/mchp-pdmc.c
118: u8 gclk_enabled:1;

sound/soc/atmel/mchp-spdiftx.c
200: int gclk_enabled:1;

> ---
>  sound/soc/atmel/mchp-spdiftx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/sound/soc/atmel/mchp-spdiftx.c b/sound/soc/atmel/mchp-spdiftx.c
> index 4850a177803d..ab2d7a791f39 100644
> --- a/sound/soc/atmel/mchp-spdiftx.c
> +++ b/sound/soc/atmel/mchp-spdiftx.c
> @@ -196,7 +196,7 @@ struct mchp_spdiftx_dev {
>         struct clk                              *pclk;
>         struct clk                              *gclk;
>         unsigned int                            fmt;
> -       int                                     gclk_enabled:1;
> +       unsigned int                            gclk_enabled:1;
>  };
>
>  static inline int mchp_spdiftx_is_running(struct mchp_spdiftx_dev *dev)
>
> base-commit: 15205c2829ca2cbb5ece5ceaafe1171a8470e62b
> --
> 2.37.1
>


-- 
Thanks,
~Nick Desaulniers
