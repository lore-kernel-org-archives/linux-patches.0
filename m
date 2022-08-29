Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE7D53A4
	for <patches@lists.linux.dev>; Mon, 29 Aug 2022 16:26:16 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id y141so8694060pfb.7
        for <patches@lists.linux.dev>; Mon, 29 Aug 2022 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=GZn8dsR0SbA0LLgWvk778Eamu3Zg1IxsU3hRYJ60c7M=;
        b=aS17D91EapqzI7ABckllr6kGJmh53zKm8Ab/RLyCrQ2T6m60LjWajmatv2MqT+ogbm
         nDctr/DZ5AzdO6GGwIRsA5FqrLIFE546oMGi+hW69AiT8RmFQuqczTEZxYvQjIxvXTGy
         ajPhqS0GiGY82FoBGb8Nyk6ryTN9eb36x3Bpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GZn8dsR0SbA0LLgWvk778Eamu3Zg1IxsU3hRYJ60c7M=;
        b=qtxwJ7F0/8cQXIP0MUUkN7HI9UvoH3RYJ8lRFaoViphLxsFvnnc1cv00+/9/ABjmiy
         vwtqtIRGM2AbSUIWgnZpkkiMfGRjmYbOoYgdcNlq48u0U+lnyhQABdRZhp7axkv9HhQY
         e3L0Pkd3NnT5DhpL0fqQDDsSoPh40XGpJ2PycF6k0DnpboVv6IENUJ9tQihcg5130xz2
         62+lcOtaqyg670s9RmFXuB7Yx5YMz5Pafsr0CjGiZDDI9qnO34uNodVS6PDalm48vl+L
         hZhkHf+WdwjlOKd4e0FYydYVeX21qZdEV8w5lyHzH/n4iKkCP7PHvEBVUpCCUBQoCa5c
         yVlg==
X-Gm-Message-State: ACgBeo2uFcd41D02zolXmEVFF1gMPuuhvCYeGttCbXaSvyo0F82QZ+g2
	rQBBHqtrmkj/WAWNCHSHgsdDUQ==
X-Google-Smtp-Source: AA6agR5OfdZX/Iwy3uNY6EY8EZTIaYP6u/ZP6JC8pbO1oWB01yejMfZT11uQYFJhzLe9LSpYsAr7aA==
X-Received: by 2002:a63:8a43:0:b0:42b:347d:4ad7 with SMTP id y64-20020a638a43000000b0042b347d4ad7mr14171354pgd.188.1661790375765;
        Mon, 29 Aug 2022 09:26:15 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:49ac:6e1:90a2:a0e0])
        by smtp.gmail.com with UTF8SMTPSA id m2-20020a170902db0200b0016bf9437766sm7843322plx.261.2022.08.29.09.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 09:26:15 -0700 (PDT)
Date: Mon, 29 Aug 2022 09:26:12 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Keep pm6150_adc
 enabled for TZ
Message-ID: <YwzopMkUBfLfFtc8@google.com>
References: <20220827004901.511543-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220827004901.511543-1-swboyd@chromium.org>

On Fri, Aug 26, 2022 at 05:49:00PM -0700, Stephen Boyd wrote:
> There's still a thermal zone using pm6150_adc in the pm6150.dtsi file,
> pm6150_thermal. It's not super obvious because it indirectly uses the
> adc through an iio channel in pm6150_temp. Let's keep this enabled on
> lazor and coachz so that reading the temperature of the pm6150_thermal
> zone continues to work. Otherwise we get -EINVAL when reading the zone,
> and I suspect the PMIC temperature trip doesn't work properly so we
> don't shutdown when the PMIC overheats.
> 
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Fixes: b8d1e3d33487 ("arm64: dts: qcom: sc7180-trogdor: Delete ADC config for unused thermistors")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
