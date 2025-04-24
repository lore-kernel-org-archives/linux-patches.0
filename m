Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A6BD529
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 08:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745482937; cv=none; b=nbwCsYD+2pVxtyK3kWGCY/PbqBugMLzO1FbaHK1kZpN6kBrCbyfHMwOzG9xTXQoy/nigG7c1AZ3iZjsS0+s6Kb7ZuiGbZF5Bdq4HCtbYS3a+dRkm0FfBMA+GOV87Slceh33mVfb6nMXNDgWKn23pub4eeAJu0j+2S+i5/N41Myg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745482937; c=relaxed/simple;
	bh=U2SWfmtUHoaXDz9lMOYfUI1uPEx2HBdKts1pl/F1720=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hTDDeO8kHpwIuQO/RgcmOHtX9OwqspmfOior9015IAR8XiWaPmvz2gN0k8CC8xxGVBgZhKYUKG0HhH/1bmSJeOhxfH8OyK3uvZtVK3UjH0jor4sTSus6jDLnf2HnW5kNXQ00Y7uEkKSwJHi0w6bgfmr+ZNi7wqWymz7iUCYs/yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rVcOhgjr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rVcOhgjr"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43ede096d73so4551155e9.2
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 01:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745482934; x=1746087734; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIynMgzNZBX//p8JMkyZp6ri1Xu2zjE3M0NHiMyj2e8=;
        b=rVcOhgjr8H75UT7mba6QptPpPjjMWnswi/bdAsoWkEcQdouG8lbuM6uSnCUqTEFYs6
         RTXuCUsNwZMGHOUVSOfjHJ2JlAl15w5gAYUd3cQU6GLf5mgfsNkoPJzidnJuyyW3WyZt
         5KnkzOEtrl8AEgk+qLmgTkjnE6O9MRoWWQJ6MFmjxGXbfBQM+uGqVVwD6Q3+bLUkZMv7
         gy3+xgoNqtTuzhJpVf2xkENyEFAeEbnjaJKpKiGM/1Twtm4h7hBvP3R1ZZDpGSziOe29
         LA+UDUtdYdC3fzSjbdhKWGvJNElV60WT92nUkLg//P6qUGfkMgHFtcadjdh7OG96MIc8
         yrkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745482934; x=1746087734;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HIynMgzNZBX//p8JMkyZp6ri1Xu2zjE3M0NHiMyj2e8=;
        b=LlXDubVrxyHhG7qazwSSURg81aSByvxCJGJ13Xoz58WOtAl52c1aFfd5amdVOOQr6f
         NKuh5baAz+RSIkg0zV79vZIjZ1gt4i7BwGt82UZSuJULWJryFyOkUyAss8R6Fjv0MdUr
         b3tpfKQRo41p4jEsm7fcJFVjlM7xb2ZXBgcImlb/nAdL32DupK8BMBosv/ZNYQqplRwu
         eMc+Zm6oB1JOj5eQveXhRiSODe4h8OXc6LEzPlzIuoXs7hGSIDwCPdiIz3QPEremP663
         ceCNRP/UE6nxnEuhCPkeDaqEboqEqi97vHwCMcXbrfKTSeQxL2PRJpZCrjNGX0n48EeI
         C1IA==
X-Forwarded-Encrypted: i=1; AJvYcCWFG99h2e90DM30VCC9OCbwkSNe7tEm+OrgQVfTsSFBqi0YA/osyjapJ5syNlHply7WM2ubqabL@lists.linux.dev
X-Gm-Message-State: AOJu0YxgqXNvpW8oh4orRd+CwkDk/vVIwia4W359WCBXYYP4EYhejG4N
	DunLskEV4zNM2/CTkSu1keKwwPCAoU82Ilp+PMstxW0gZ1Z9awAEUtsP4S7aGauurl50lKscOUZ
	a
X-Gm-Gg: ASbGncsU+U2I+miBf/iE20I3cuhp89V+SxKSjGObDwmt/k/Uh8gKhI2qApXwsKCwzfG
	FpT0IY/nF70jkFTu9j617Q+IegHTQ28AeAqV6pCFWJnF+O4QSovjWiWGtBugnfNJv4bCkJ6Ft9l
	RaepMDh3HO+oMPFlWIR5FpKZA+r6zzy/sGdnTyxvwym8GZygCgh9onLGDWyCdLS5ZwK/wDMlXyR
	u7NZUPF8I220jcDkbrUrjrOuh4Um8ZDxyGUeuJGQkp/A+NnKdRDxcQaLbQdceETgQxw6rk/imW0
	aJdsN+vPCJneVu1zDdaCGp4WcpGZaEyrNqACpqmuvzi6a8fj6efJMlf3V96sEg==
X-Google-Smtp-Source: AGHT+IGNoVo6KhUwBfuui2yrKQx8otgicR7UifrdI9urzxt8lGP1itEapAxnVeqq6j8kw3geKV6JYA==
X-Received: by 2002:a05:600c:45cd:b0:43d:2313:7b4a with SMTP id 5b1f17b1804b1-4409bd07569mr14887825e9.3.1745482934032;
        Thu, 24 Apr 2025 01:22:14 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:3d9:2080:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29bfc4sm11229415e9.8.2025.04.24.01.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 01:22:13 -0700 (PDT)
From: Neil Armstrong <neil.armstrong@linaro.org>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Nathan Chancellor <nathan@kernel.org>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev
In-Reply-To: <20250423-panel-himax-hx8279-fix-sometimes-uninitialized-v2-1-fc501c6558d9@kernel.org>
References: <20250423-panel-himax-hx8279-fix-sometimes-uninitialized-v2-1-fc501c6558d9@kernel.org>
Subject: Re: [PATCH v2] drm/panel: himax-hx8279: Always initialize
 goa_{even,odd}_valid in hx8279_check_goa_config()
Message-Id: <174548293341.3240462.5657130460856318772.b4-ty@linaro.org>
Date: Thu, 24 Apr 2025 10:22:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

Hi,

On Wed, 23 Apr 2025 10:41:41 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/gpu/drm/panel/panel-himax-hx8279.c:838:6: error: variable 'goa_even_valid' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>     838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/gpu/drm/panel/panel-himax-hx8279.c:842:23: note: uninitialized use occurs here
>     842 |         if (goa_odd_valid != goa_even_valid)
>         |                              ^~~~~~~~~~~~~~
>   drivers/gpu/drm/panel/panel-himax-hx8279.c:838:2: note: remove the 'if' if its condition is always true
>     838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     839 |                 goa_even_valid = false;
>   drivers/gpu/drm/panel/panel-himax-hx8279.c:818:36: note: initialize the variable 'goa_even_valid' to silence this warning
>     818 |         bool goa_odd_valid, goa_even_valid;
>         |                                           ^
>         |                                            = 0
> 
> [...]

Thanks, Applied to https://gitlab.freedesktop.org/drm/misc/kernel.git (drm-misc-next)

[1/1] drm/panel: himax-hx8279: Always initialize goa_{even,odd}_valid in hx8279_check_goa_config()
      https://gitlab.freedesktop.org/drm/misc/kernel/-/commit/0228687423587d8ef448fc1d81f96539507aa5bb

-- 
Neil

