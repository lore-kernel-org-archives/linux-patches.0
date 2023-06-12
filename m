Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77E1881F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 20:04:40 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-30fb4b3e62fso1508805f8f.2
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 13:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20221208.gappssmtp.com; s=20221208; t=1686600279; x=1689192279;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=YzNsZC6f0ahxcqJoEVkr3mmh3LhtJkgOMa+jSW4jW4w=;
        b=Bf7pNtCF/I7e3eWMOv6SyG52CdpbOvoHwSlm74rGPTi0sdpPC5Xm2EU1eb2u2exmi5
         VQYrRpwns3q4FMFWvCysI1lQC78YYuPi41xQ5jbvO78hzMN/IC6uoBDK/9RHY5chnSPP
         v4Y76tVi+eYetxsQmh8lVUkyls4uhh3oH7n2FCjYv3DVqHjz6HmByWfLgI1xSma3GsvV
         n6CEGg/H2X4y5vHSMKug5EY8rkNH/8EajTI/1t6BhbAUucSiY54Ce3wnRGXHe9N0/1vy
         kVGvZX2QYB2KPKR7cOLweqyKOg61L9MJrPm1cfK5iiUBZteYlHJEkM0wkQ8sHVFlepS1
         Jo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686600279; x=1689192279;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzNsZC6f0ahxcqJoEVkr3mmh3LhtJkgOMa+jSW4jW4w=;
        b=ACEpmAe9P1f/+dfc1GhCeFHQRRt0lGoufDZ+GA/SHm8IKfM+Shzxp2f1YkKXkwISDc
         LgXc9whO5kIlzz+teuyyK/+TQG3di+1ejodtWrPuOMvAwAk02du3ajO3goC/IWBHv8cp
         6aoCfJMu6rhQMKfQHVhCE+oMt1d5tuKidCzbXoOyixU6HLBoKPaqhWbX6GJEr0xXs5wO
         6gqIewPw32XnfrDT4nRICfSEeyPwH2A15EgWJRq5u6PDLEIhpOMRfpm9kr9WVTak7qDT
         meNbt5l6VluB1N9cu/8wV7wOxStiF4Nu6H4G2Xwpjh5YXVSFj/i/xZv1ba7q8nJgg4OA
         D9QA==
X-Gm-Message-State: AC+VfDzeb8OxEhNHLUOxflegKo7x0+ycX+mzxGSg+aBCHh8M3MmIBUB4
	i9OgTL3/xyalFTTrGenhtA5v7A==
X-Google-Smtp-Source: ACHHUZ4u9yNXmp6fhE5G8NnIfX3V5/d6Zvn8rSRouBJFVjUSo4oN1ZFCeTUbWQfFUxGOVTVzl54GQg==
X-Received: by 2002:adf:f410:0:b0:30f:bc8f:6d49 with SMTP id g16-20020adff410000000b0030fbc8f6d49mr4131648wro.13.1686600278783;
        Mon, 12 Jun 2023 13:04:38 -0700 (PDT)
Received: from localhost (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.gmail.com with ESMTPSA id i17-20020a5d6311000000b0030fae360f14sm8035712wru.68.2023.06.12.13.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 13:04:37 -0700 (PDT)
References: <20230612182332.371003-1-sboyd@kernel.org>
User-agent: mu4e 1.8.13; emacs 28.2
From: Jerome Brunet <jbrunet@baylibre.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, Jian Hu <jian.hu@amlogic.com>, Dmitry Rokosov
 <ddrokosov@sberdevices.ru>, Martin Blumenstingl
 <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH] clk: meson: a1: Staticize rtc clk
Date: Mon, 12 Jun 2023 22:03:11 +0200
In-reply-to: <20230612182332.371003-1-sboyd@kernel.org>
Message-ID: <1jzg54fnvw.fsf@starbuckisacylon.baylibre.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


On Mon 12 Jun 2023 at 11:23, Stephen Boyd <sboyd@kernel.org> wrote:

> Sparse rightly complains that this symbol is supposed to be static.
>
> Cc: Jian Hu <jian.hu@amlogic.com>
> Cc: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Cc: Jerome Brunet <jbrunet@baylibre.com>
> Fixes: 84af914404db ("clk: meson: a1: add Amlogic A1 Peripherals clock controller driver")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>

Sorry this got through.

> ---
>  drivers/clk/meson/a1-peripherals.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/meson/a1-peripherals.c b/drivers/clk/meson/a1-peripherals.c
> index b320134fefeb..75dfae210fe5 100644
> --- a/drivers/clk/meson/a1-peripherals.c
> +++ b/drivers/clk/meson/a1-peripherals.c
> @@ -218,7 +218,7 @@ static struct clk_regmap rtc_32k_sel = {
>  	},
>  };
>  
> -struct clk_regmap rtc = {
> +static struct clk_regmap rtc = {
>  	.data = &(struct clk_regmap_gate_data){
>  		.offset = RTC_BY_OSCIN_CTRL0,
>  		.bit_idx = 30,

