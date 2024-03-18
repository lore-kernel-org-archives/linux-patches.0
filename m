Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C60E4EB5E
	for <patches@lists.linux.dev>; Mon, 18 Mar 2024 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710775292; cv=none; b=EpFt9XTQl+wZDivCfoUjOPKbTiKBe7bjFqXGn4xthE1rFPY6tk3VZdrMeus+jT4tBF3vlb36Y66O548ljfHWXPAL5ss/uflqJmO7H7qXP46NDdJ+6OCK6WAvwOGcZ0pktL9VBFJZmKwHNm+c0u1+xt4WYP10J0g27H6SDERFT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710775292; c=relaxed/simple;
	bh=qYFnOCn6WDf/TDGMX2fOvjOWt1OS3MGMyadhL+gfoDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dup4luCVVEnXWrquCnyQa3jis6DHkwEIrRp3uSnDe9IIocrWm50fSX88YZvsVHN4+7Y8sAak5ek7A1sbyRMEaV9BARw8Q+krLRY3u34Kuy8F8yxWCKj7XE0qwrIt7duMVdy1nCVvJjjv7DPcsNdvZaNdh2lxwgQcsgTksY3iWAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kN0WEUgD; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kN0WEUgD"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-609eb3e5a56so48358907b3.1
        for <patches@lists.linux.dev>; Mon, 18 Mar 2024 08:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1710775290; x=1711380090; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hOVOG+zKU5pC1qctxxPXGwr2e/TIrZYm9xcdBAyBJDc=;
        b=kN0WEUgDfoDc7aO5H0c/PjrDwse3uWOEpIuJomatER8FCSQ27IG1u6JknjzfRLEHLL
         H+hb2AjAg0ZQORz4+3X4ZhPTe1bcaY9BN5leMdgx0tb70HILiGu+T/Tu6SoICI1ujt/z
         nt8xaUgeaGgzuts7WHFexoOoUyJKl1hqpfelTQF/JxmXHVgJkB+RonybcVBSvFhQv4f3
         gvvYe+afU0z1tfIYFZ3qsV0A/HSPqCSCEXKf71ZcTU3ANf2iAiL+CqMW4DcPgQMxABva
         bid+4nvTY1tfiEn2ktiWuQx7bI85EZ9yHdwcacQWrZfnyXGCGfVaJbXkSMCB22guxEpD
         Iirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710775290; x=1711380090;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hOVOG+zKU5pC1qctxxPXGwr2e/TIrZYm9xcdBAyBJDc=;
        b=HYDYZ3mPjmSYS6jZyrzZGh397W0lu7Dg+hOt8n8Ai6v+ZA0jTxDqmbba4W7Ei8K4FV
         Y6fTozqirde8d+mgA4wf2rSMYeRb7Dr9SHDO6nDkDej16I2nQ+4WRE8tqGCLuCghw5Gn
         bDjZJwY2+uYF0KRJz0DoBChcQzMwmIUUE0KHd34a7HAPFk72mvY+UzgmwmYS3rXQCw/U
         xTp3wSMJK7v5Hk7dGv5+89vVE5g1ERJ4ckcB2TBOewZVRKopUyZ5sf8JEXQPe1zSbggT
         LfY147oAu6PvB70QKaJakpDKMvxWbarwxSjOEE45fDKizaupLecU8yLZKcE8nS1lnGfG
         i5eA==
X-Forwarded-Encrypted: i=1; AJvYcCUkbn2O8Kk5oxi72tsNa7KCEDbwUO4IhDHbCIcL5p1sLheox9AcMVKmDNK8vBGyQ4G/5mhdqjDqjOntsjWOpbm57zUfQt/m0Q==
X-Gm-Message-State: AOJu0YwXpEPHgPevp50UWN18v80LSb5Yh8cHZ3Xbk1NEvUWMtysJY/gl
	TbDNL3q3y5Fo4qrgwYw7bY9piReL1W9RqvRvYjUE4YyrPgbiHHOrBLHoV2gueeMBUGdNogSPXnP
	SGmMX26H7t4KCtXL3y5AOF73KknQlvn0oR6aGzA==
X-Google-Smtp-Source: AGHT+IFJe43EDKmy0gsRwURevoOtqocpaWKI8M3F4/AHqWtzh9RYrXXwtHPYbESuPhxVR8rlneuVdtvcCGFvYumLYjQ=
X-Received: by 2002:a25:a2cb:0:b0:dcf:bc57:cd61 with SMTP id
 c11-20020a25a2cb000000b00dcfbc57cd61mr10785295ybn.50.1710775289937; Mon, 18
 Mar 2024 08:21:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240318-fix-some-qcom-kconfig-deps-v1-0-ea0773e3df5a@kernel.org> <20240318-fix-some-qcom-kconfig-deps-v1-1-ea0773e3df5a@kernel.org>
In-Reply-To: <20240318-fix-some-qcom-kconfig-deps-v1-1-ea0773e3df5a@kernel.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Mon, 18 Mar 2024 17:21:17 +0200
Message-ID: <CAA8EJpqxuVrL7_OYCAFaMM8bocpRHbqZ30B5=KS-7wUn2vH4cQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: qcom: Fix SC_CAMCC_8280XP dependencies
To: Nathan Chancellor <nathan@kernel.org>
Cc: sboyd@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org, 
	mturquette@baylibre.com, bryan.odonoghue@linaro.org, 
	neil.armstrong@linaro.org, linux-arm-msm@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Mar 2024 at 17:19, Nathan Chancellor <nathan@kernel.org> wrote:
>
> CONFIG_SC_GCC_8280XP depends on ARM64 but it is selected by
> CONFIG_SC_CAMCC_8280XP, which can be selected on ARM, resulting in a
> Kconfig warning.
>
> WARNING: unmet direct dependencies detected for SC_GCC_8280XP
>   Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=y] && (ARM64 || COMPILE_TEST [=n])
>   Selected by [y]:
>   - SC_CAMCC_8280XP [=y] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=y]
>
> Add the same dependencies to CONFIG_SC_CAMCC_8280XP to resolve the
> warning.
>
> Fixes: ff93872a9c61 ("clk: qcom: camcc-sc8280xp: Add sc8280xp CAMCC")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/clk/qcom/Kconfig | 1 +
>  1 file changed, 1 insertion(+)


Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
