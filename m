Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637973FE4C
	for <patches@lists.linux.dev>; Thu, 23 Nov 2023 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dKR9Z3D1"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-db3fd3e971cso1051206276.3
        for <patches@lists.linux.dev>; Thu, 23 Nov 2023 09:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700759948; x=1701364748; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QzfEo5WBvdgfB1Az5F9u3yyf28qwDoy9yb7+zzh0FnU=;
        b=dKR9Z3D1mlNeD2eMUhuFDz6wSApRB9zkxFNwEnuUuDcLcgi3jv9ColshzT6qkhQo3q
         d3m88i+uQxhSPTTPJ/HKDDxcEMoEfz4TvNi05ZhVxNgHDRw63FVed4VPCimQWmZ0dFDP
         ACimezwKprpN9cwlYOBbhDnOX4zDY0kgJwdBjpORRpJQF7/waStrmqx2k1vM5zIjzU4k
         4g33lZHMtqbRFu3QcjvM/a1C7rn9zKCAGhex0mfsZZLrxq+gN/a7WoZ93ZwoG80zxWkp
         3cR8TsSNChgZC51av9g2XHwTE9kFP3oLj7EpnDsWgg/3LusyqtZcLGd+u49xAoHSLP7r
         wm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700759948; x=1701364748;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QzfEo5WBvdgfB1Az5F9u3yyf28qwDoy9yb7+zzh0FnU=;
        b=KwaxVxHRm73UH02B7PXUYdN1FrHd1CCImOg5xqJnZKsd63cnNzxyadYX1ArM/Li/Vy
         YqjDqJuitfpSG4dwxToZDxc+cvsix9ywo82Svbv1jGIPxxFDuiVJ/ovSyEKJMJny07oF
         jtMKCDuz4DLSg9WsOfPDNoCDCba0vK7i1IakA/4B4xvQw5dvhvF5x8ty0/ZJGbuRkrT2
         hG8wO6n1uQCOty5jBVLeW2hX2OTsEn2QsPc/qWdp/mXys1QYC29PLgdgtuZ86eaLfOiL
         Dmw+XqhI9FzI0VUjrwOK7m/R1I56Ies/ieDYSAzsxfmIeORZ/F9yHSl4S6sOS5X4ukjy
         RSbw==
X-Gm-Message-State: AOJu0Yx71ujgA1A8EgwJE7ZBP0uU6YXdy/G/XJxdIu8SmZiR5yIkMlzv
	PEVNsyLg58ayfGpDDWgeyNr6IqYB6uoqGGQKro6o0A==
X-Google-Smtp-Source: AGHT+IEmXW41Yp+RFIjdjtRm1iq8rHwdxF6zrXwjU0rUmegEetlfzR0xiq7PtKWXXUYlM7wUx54oeIEvylixkhQM9x4=
X-Received: by 2002:a25:24e:0:b0:d9a:485f:5852 with SMTP id
 75-20020a25024e000000b00d9a485f5852mr5831926ybc.13.1700759948302; Thu, 23 Nov
 2023 09:19:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-v1-1-7e1a7f4ccaab@kernel.org>
In-Reply-To: <20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-v1-1-7e1a7f4ccaab@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 23 Nov 2023 18:18:32 +0100
Message-ID: <CAPDyKFosve2awkdzzsCJb38tt2154kKKKneXiaBNqQATwdUupw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-of-dwcmshc: Use logical OR instead of bitwise
 OR in dwcmshc_probe()
To: Nathan Chancellor <nathan@kernel.org>
Cc: adrian.hunter@intel.com, dfustini@baylibre.com, linux-mmc@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 Nov 2023 at 02:46, Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=y):
>
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>     873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
>         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                                        ||
>     875 |                     (device_property_read_bool(dev, "mmc-hs400-1_8v")))
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>     873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
>         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                                      ||
>     874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
>   2 errors generated.
>
> There is little reason for this if statement to use bitwise ORs, as the
> short circuiting of logical OR does not need to be avoided in this
> context; it would be wasteful to call device_property_read_bool() three
> times if the first two calls returned true. Switch to logical OR to fix
> the warning.
>
> While in the area, the parentheses around the calls to
> device_property_read_bool() are not necessary and make the if statement
> harder to read, so remove them.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1960
> Fixes: aff35fbc7830 ("mmc: sdhci-of-dwcmshc: Add support for T-Head TH1520")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied for next, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/sdhci-of-dwcmshc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
> index 0eb72544c09e..a1f57af6acfb 100644
> --- a/drivers/mmc/host/sdhci-of-dwcmshc.c
> +++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
> @@ -870,9 +870,9 @@ static int dwcmshc_probe(struct platform_device *pdev)
>         if (pltfm_data == &sdhci_dwcmshc_th1520_pdata) {
>                 priv->delay_line = PHY_SDCLKDL_DC_DEFAULT;
>
> -               if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
> -                   (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
> -                   (device_property_read_bool(dev, "mmc-hs400-1_8v")))
> +               if (device_property_read_bool(dev, "mmc-ddr-1_8v") ||
> +                   device_property_read_bool(dev, "mmc-hs200-1_8v") ||
> +                   device_property_read_bool(dev, "mmc-hs400-1_8v"))
>                         priv->flags |= FLAG_IO_FIXED_1V8;
>                 else
>                         priv->flags &= ~FLAG_IO_FIXED_1V8;
>
> ---
> base-commit: 3f00051234f02d0d9d1f63b9a334d0fd4c65b6ca
> change-id: 20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-bf8fed73b5bb
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
