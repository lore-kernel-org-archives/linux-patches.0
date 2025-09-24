Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082642E2657
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722160; cv=none; b=X+1JrXMuLNKroS1GEUclMjcVoRR1+D7l23W+Xj1YWnuBaGgctMo8p4O5WxQ1YAk1oYNd1Cn9VOObOHP9DMr2A36qOhNYYowjmNmyT9Kqkr8X4iQISjt9iSZdSvr4cM5r40hSn+sku1yK0L3f4UtYuLRBTMK5FxMVhB0ZubNzLz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722160; c=relaxed/simple;
	bh=DcpJ689quYGtSVJ/jZ50x9baeFfRVXjVK6frpcghcfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZjSFT7hiygPquIbehRaljHPbVCHX8PS84FNbNVtOI87zGswJ2kdOogo8SNtrHJxO4sDeKHkB6/HLZkULB4LvTQ6jmEJW+wXc942RCwtlRAVDm3XA0ss1Xeva8OBmeeLA86g4WcZmdDhg/jiX9Z+G5b/zkeQVULrLb7OO5KEK8l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TihiP0b6; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TihiP0b6"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-57db15eeb11so4329710e87.2
        for <patches@lists.linux.dev>; Wed, 24 Sep 2025 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758722157; x=1759326957; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZpCdxXN+Lj5Wtx0PEqxVxK+0pszwy0+LCFjR3ki0Po=;
        b=TihiP0b69vdKnpzvoKg+6ykSdzqQpBMrmf3u9NXxbotBufTlGu8bVsemvrC0HxWNSr
         Z2wD/XxQE8qvEoisUMUrWsNeOnZ6FS5vxa48pZCys+obGdLRjaM4fErDYx8UkjmPJ678
         IHBWOU4oIwHp5f1WQhOau33lwbaIBPPfi06uG6i1eLxquF1gGCFaoa0W9/WkR7FHn60v
         OsFok5ejh8ofMWQ0Lqows6stUlofA//4Ynf83BNRF45HePOOrqpcdwgeREKXAhW3irdl
         ORG/04Xj9Gq5vkbWzBTL9eHO8LfwOECYZDuZXrbtfr0ewF6TpjnWrhVQlgdOa6zTqyhU
         dwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758722157; x=1759326957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pZpCdxXN+Lj5Wtx0PEqxVxK+0pszwy0+LCFjR3ki0Po=;
        b=nbl7M0psyEHj45dPZMR+4Xw2Eteg2BO6lavB3TRnaTdD902yx/orVArNyrPjLF/iW+
         xiD1wy46iiPuWlRkyIt2HHUsZkLH7KkTjPa3R5Xt+nsQknGSaAdMFajqYZ3S3UUZpS9k
         REvd5uQU51HBiGjssx/Rt6/8MgE2ren1F4M8pl9jkMEVJCcogDqN2lNEHwtLGqVss++5
         5Ac0MJz4/FvMcqyw9qXc2cRSttW0c4LauZ92NAf51lvdE4bsJ0XaZxa4LorUx75iYJBj
         eMmACejZ1kQd0H5mg12UF0CKwjzPRg9k/SDsSLT2TTvp06/uptA8Ef4RGbVIqJ5Zu99u
         QqPw==
X-Forwarded-Encrypted: i=1; AJvYcCWvAcv9PnTozMVbsTE4Qh/031n+OhM49hCTMoJpvHU8sLEXHckD/1ZZBde5pUwNTRpCps+P74UB@lists.linux.dev
X-Gm-Message-State: AOJu0YxEYAVd20kqXLjT06JrMxPzyLMk9MQCj0x+nBQ3bdx5ZNobDcVZ
	V6r60KlGRwsT0+GAQSm8VKEOPPEJZZSIQY2NZabQktSFY4XF5Blzqy60DzsBbRp7jt53vpZiezn
	M32/uEbFStgpPR+zH+CXAuTuCf6ggv7A=
X-Gm-Gg: ASbGncsDy+W4FETPDtSHLAt+leeItqpZr5SOU/c6yPVmG9R6tuDZEdhUq6Uw98B43dS
	xbCMhw1ILVNdLMTkTG+Yb37cOg8g3RU6h7M0D7gKenvMjRDrQwwKSG39FPPhrD306+uwaaAt7Xp
	UudJI2TgzS8Fwc8xzSW5olU/L7MkXl02y44UaBizBMt2JpHPI2aRtqr0hwlpQ5HRcxOhNBY/8g+
	QPNMGlZx0R1zGaoqBVDzHo/M4l0fqHNl8Ezwk1tvw==
X-Google-Smtp-Source: AGHT+IFFrQiSJq3sO4DDheNScCAZEm7ChSSXL0OrRgD+E9nQCbhqy0d6xm+S7jAokm2e7jUsgL24742yoK4fyiXLJlA=
X-Received: by 2002:a05:6512:2903:b0:577:1168:5e44 with SMTP id
 2adb3069b0e04-580732fc04cmr1917640e87.38.1758722156813; Wed, 24 Sep 2025
 06:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250922192412.885919229@linuxfoundation.org>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 24 Sep 2025 19:25:44 +0530
X-Gm-Features: AS18NWBDacVBK1YPgwur6lrJBXLhApl2Qt6ZIWcyrgcUSkgfBZfG1VuayMkdzxc
Message-ID: <CAC-m1rryCr1KGcCWYWkd47sy92-SP0+3WFqsU2mPSxmesQr4yg@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 1:12=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and boot tested 6.16.9-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without
issues.

Build
kernel: 6.16.9-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: fef8d1e3eca6557cae4f0149eb2071123c473c26

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
