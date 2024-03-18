Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8080C4EB5E
	for <patches@lists.linux.dev>; Mon, 18 Mar 2024 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710775312; cv=none; b=MVf54z/tk/pWHKCZKQ/MEysKH+Vfv8QABeW2KorYznU/hpZY1maCvDtm/xiJDGpF7xBT3mq/JIZ2xREtKtPWPgKiEof4GmOEMp5IvNYzr7VYp1l0ZX838qW2AY4zkkcoApZs21W6Uv7aeC66ZZlOZOLp6eIyMxZ1FWsJ945PUl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710775312; c=relaxed/simple;
	bh=fOMNZ9RkrucUBElQm7DZeJsg0EKL7/lwJeVNrUgtgk0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ep3Q2n4Dsu/Tfh6hpfbyLGm6RfUP9eD8JnS9ssla7Qz3457rVpSPkWvO0IbAkmwvjVmKjWtdYjvNhdGljM2TYTM70FF82Cj96Pyz8qtKPrR1Kl5LhWwxVg9ZPzK1IcFGeuDR2pkE7d8R5/tKWb1lJ2+epoI42Ib6CaJt67ITrEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Eorq3GFu; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Eorq3GFu"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-60a104601dcso47502257b3.2
        for <patches@lists.linux.dev>; Mon, 18 Mar 2024 08:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1710775309; x=1711380109; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fuDnp5FuC/P7zMV0CMzQ7SKWMn/6RKLauSf7pCwN0Ys=;
        b=Eorq3GFuFDXuxEc/i3Npan41qhl0NUx2Kzlfi7G1pGxTZ7dr3elY0JvL5+PzcLP0R6
         dEU0CYLLIuNtcI2YZQFdiDC/JngWke8cqQb6qFis/jzcGTupwKOuKLeDT/knekh6sc++
         n64io7fUdEuR4qw3JXn7XPbPy39b2Vrf/s+7TbHZplCNZSw3CqYY0tdh0sO5wMHng5Hd
         9KS6T8HlLUtyvGmUtFwT3P2l0AhBBHHRv1lIYNxlieKjw82aPp29wjB1i8CCUJkBSKgx
         ng74yplXpo0QiF79PKlcJXrzc8y4cSJoU1vLig3KncVjWjV1FWnO1UURTU9xzpQI4IRj
         FztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710775309; x=1711380109;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fuDnp5FuC/P7zMV0CMzQ7SKWMn/6RKLauSf7pCwN0Ys=;
        b=UKAl2z3JMUTKNaIt3OUynCLTqxg5JEfjxOROsDNwVy5sOcEclUfKB9VzQ9jVAhU5fG
         xnGijCnfZL/TpApBPGNreSn8fSi5vmHHShedUgCx4aDEKm/XkHuYKTF5iSVaEScsajeP
         6/EzTln8xX+AwsdR//USl6ePzrlOL351z7GNegYQ0Cik1a6iFa4NMO5mjGdUfG8MsjA1
         OilHZjomupsjsMKn/7wgZ1QandBMPhEGzuW7tjGYOxh937QoCJBPfvPKN3jr+NdEh71J
         Jl6d8LYMzktAk+Y88ZGJKfksMGlHVu6qggRKOhA3AHLHIIPNlzKzxD9fOFa0eT6c/Zcn
         i/zw==
X-Forwarded-Encrypted: i=1; AJvYcCWc+UHtZ5L0rjTg05OMURqDv0DYizg+4mfUBDCfwqUeG+/1MFIdJrDkrFDndn5nuDS/Te9ddU/zpYT+H/0/QfIQxr4+mlvrgw==
X-Gm-Message-State: AOJu0YzAMtGW4bfHI0nIcB5W81Uuw2J1LqDl2QID5ioPnjJybdzXYq5n
	qpB+unSG3ULp2Yc/hm/k531t/UDeKvsLC8FQDg8kh4INbXhFZ8PlVX4tWxqTHUV2tgtTLqyXIw3
	RXY3QQfAKHdR7u/Vt0uQ29uxZO9wVxUvITFkBXQ==
X-Google-Smtp-Source: AGHT+IF0vRwq0/LTZx5W4OOx+6BDAgX2Cv7pmp/4K30l52XoHIktLBjVZGf3PZvQhq3f4F6CP5ViSyfckOvjx94eNnE=
X-Received: by 2002:a81:8402:0:b0:60c:bda8:cd7c with SMTP id
 u2-20020a818402000000b0060cbda8cd7cmr11623167ywf.10.1710775309518; Mon, 18
 Mar 2024 08:21:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240318-fix-some-qcom-kconfig-deps-v1-0-ea0773e3df5a@kernel.org> <20240318-fix-some-qcom-kconfig-deps-v1-2-ea0773e3df5a@kernel.org>
In-Reply-To: <20240318-fix-some-qcom-kconfig-deps-v1-2-ea0773e3df5a@kernel.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Mon, 18 Mar 2024 17:21:38 +0200
Message-ID: <CAA8EJprT0d1gn-JbPRdXUz2iMAjxzX2_nKjMxZNG5dvtjSmz_w@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: qcom: Fix SM_GPUCC_8650 dependencies
To: Nathan Chancellor <nathan@kernel.org>
Cc: sboyd@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org, 
	mturquette@baylibre.com, bryan.odonoghue@linaro.org, 
	neil.armstrong@linaro.org, linux-arm-msm@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Mar 2024 at 17:19, Nathan Chancellor <nathan@kernel.org> wrote:
>
> CONFIG_SM_GCC_8650 depends on ARM64 but it is selected by
> CONFIG_SM_GPUCC_8650, which can be selected on ARM, resulting in a
> Kconfig warning.
>
> WARNING: unmet direct dependencies detected for SM_GCC_8650
>   Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=y] && (ARM64 || COMPILE_TEST [=n])
>   Selected by [y]:
>   - SM_GPUCC_8650 [=y] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=y]
>
> Add the same dependencies to CONFIG_SM_GPUCC_8650 to resolve the
> warning.
>
> Fixes: 8676fd4f3874 ("clk: qcom: add the SM8650 GPU Clock Controller driver")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/clk/qcom/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>


-- 
With best wishes
Dmitry
