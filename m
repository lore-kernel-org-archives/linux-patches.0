Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29F92475C8
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 11:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750679625; cv=none; b=RX8iMeE9MhaX5gAZc8/uXFLImTNJDwvtrOHH7LAuHKZDL6My9xJV4jk8X4NdQyAOel9hxcHEgkalPZ0bQvJimPH5/SCqoTrb2LHlsdfboB4KlVL6pR7INEmYwRsbiSzlztklwLM5zJG3Cf5aZBtakxyLGvQtFVb6ub5Nyv6IIrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750679625; c=relaxed/simple;
	bh=dLO58gER4/9we8S0TLinFsUMTSqy1jSiQM5gDQyH4uo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cqVgdKoeU0juxq3kbTdRRKw0xeJUlyQyFKBRSKYSXOd59gr6aomcjizpfC3A5P2X2Ee5TySr9Sxe6PxNnL2AZaCckV+3KcczAmvI898MfLLvw2UF3Y1/BscMOUu8yTEqEAs3jO/HU/xybDUGOW+hKl/aq2LLMDQXpKpjcfOW+yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ulYAmRqu; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ulYAmRqu"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e819aa98e7aso3414834276.2
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 04:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750679623; x=1751284423; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B805XrZKRxPEF7q0TmzBdS99aJNQ99+WDQeiV+moFIY=;
        b=ulYAmRqurcy5Ox5FCZLSg4XwXgEb8AI1a6XXGkWQKxBa9kdtGWWdl035z+o3skS73w
         EMSM/V/de6yTBeFBoKI1EmotXNKekBefHzqGojAnmpETw8WLO7a+pdbiHE9ryAgyXUzd
         I8jgZ4U/o8VW7NeERnxMY4QaKzfTbMwOnc0YSnITjNjoQRlVrYFZzRc3pLaVBALIkWS6
         P6NPEvafF3GKryc0BDLrwBxxBOd42Lc8P/aYfQ2NuGp6TqDZN17/j0yX/0qPeADmcjUG
         ZoZZy/w2LrmsJ2CXVQhJlEcbKDucG/WgUPDI4WgImhItWZ8vXZWIWogyFYM/UwSMcXCA
         qOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750679623; x=1751284423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B805XrZKRxPEF7q0TmzBdS99aJNQ99+WDQeiV+moFIY=;
        b=iV4vjzx3Ef1GIjAtS1ZBkv6MZXRnuCjsrKiTn2wOaO+LeXKcdvSGVOVSxi5aayOCCw
         TbROkPZi/YceKmZW5BrJ3LRQ2X111igJweS/WGbq2g7e6ag7vOSjvMg/WwAhLNl4Bb8m
         d0mFb+GHoTT0I8yxn+xJZudOm0qHT3aU5O9Vz6z3MM+FD3LGfuDhv1twDutPBE16fO19
         Ty9UlxR+4sJ/eDawY0pSvxfdMUua+TwB2eSG5mV+eLNlO1CpRZFg6c/tBrjSjDAZLvNg
         bW2oEHB20w5DDDcMacrNz51VJawBOgd8AYes6FFV2HQGZC5i2NvhDbkIpGTxmoyQvouH
         5NvA==
X-Forwarded-Encrypted: i=1; AJvYcCU9hIsFGzxpgqzBWYG2+iLlWuORmz+xFke3EDwYwHSs6mcP8aiggA+ToFnqXqPqzaMHSAr+YY3K@lists.linux.dev
X-Gm-Message-State: AOJu0YzdUWydj5HX1xNN8p0XkxRWVt7CM0TcdZStdVMEVKL+0JEstWQV
	rCjqsYsLfT+WVHq4XumBy0bUtRG1OHi61QUpB8i4p594c0f2zQeYchNgvG5tzxwDr8/eFibydfg
	9hT7vRQbU8uvwh5Dcp35LKbg0I2rn21W5w8xEizW2jA==
X-Gm-Gg: ASbGncsdqKnR0w0kWgN6XEgWfNG2kp5TILP+jPJUu6EjI/LEvkqMq7zrYB4QPnzYwCe
	Tlw8V8FFdSj5GRTQQWiEJkSHWUzoKXslfoVSPghIZDSppSrOoQK4tPIia9Wfojc6NjqmJjiOtsK
	c9AXZli3zTvDApcsy0YsvmHqkTn9tqHCrKMr78eDxKqwgK6GrgtegnJzg=
X-Google-Smtp-Source: AGHT+IELqiLxPqxfP1B6M+PoD9dckt5ie65k3DRMyhajXGBqAf5XZnld8i7QkaUB7/s6v+6stoYuis0ocxT18YOr0D8=
X-Received: by 2002:a05:6902:1612:b0:e7f:6815:ce6e with SMTP id
 3f1490d57ef6-e842bca3da2mr14607843276.20.1750679622828; Mon, 23 Jun 2025
 04:53:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250620-mmc-rtsx-usb-sdmmc-fix-clang-implicit-fallthrough-v1-1-4031d11159c0@kernel.org>
In-Reply-To: <20250620-mmc-rtsx-usb-sdmmc-fix-clang-implicit-fallthrough-v1-1-4031d11159c0@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Mon, 23 Jun 2025 13:53:06 +0200
X-Gm-Features: AX0GCFsecqypaGAnLbHfqAW49LWdYlrsXNE5tE8Z_-FA8P0SbCCQ99PmaGdH8eM
Message-ID: <CAPDyKFpavS8o8X6zYzJXuS=N_3ya7f5gWH_xQDbxbZstSAuaRA@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx_usb_sdmmc: Fix clang -Wimplicit-fallthrough in sd_set_power_mode()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Ricky Wu <ricky_wu@realtek.com>, linux-mmc@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 20 Jun 2025 at 20:25, Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=y):
>
>   drivers/mmc/host/rtsx_usb_sdmmc.c:1042:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>    1042 |         case MMC_POWER_UNDEFINED:
>         |         ^
>   drivers/mmc/host/rtsx_usb_sdmmc.c:1042:2: note: insert 'break;' to avoid fall-through
>    1042 |         case MMC_POWER_UNDEFINED:
>         |         ^
>         |         break;
>
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing break to silence
> the warning.
>
> Fixes: 2c3809bd6f65 ("mmc: rtsx_usb_sdmmc: Add 74 clocks in poweron flow")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied for next, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/rtsx_usb_sdmmc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
> index 591d37206654..c5f6b9df066b 100644
> --- a/drivers/mmc/host/rtsx_usb_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
> @@ -1039,6 +1039,8 @@ static void sd_set_power_mode(struct rtsx_usb_sdmmc *host,
>         case MMC_POWER_ON:
>                 /* stop to send the clock signals */
>                 rtsx_usb_write_register(ucr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, 0x00);
> +               break;
> +
>         case MMC_POWER_UNDEFINED:
>                 break;
>
>
> ---
> base-commit: f5c755ef810009b85350884c483705bd04365370
> change-id: 20250620-mmc-rtsx-usb-sdmmc-fix-clang-implicit-fallthrough-732a574554b0
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
