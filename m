Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9A88BE8
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723911743; cv=none; b=kDollRGYOwOgdYu5S8za7XgXpA0UbTsTdR7oZgoU0Je03REC2lvCxubzuU4vZdaRD//hiaYVRZ94uQybBlz1QoUabB/6b8jYEbhRZJuVezML3Bvm5J6lMgbjKjkGsZGtGTTYL3MePfC6Mc9B3xarTtdOzaoRHHfHHU9lHNtiUn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723911743; c=relaxed/simple;
	bh=eHPTgf5wRj1IVdjxkVYmpqaT5IAXgAF4Sg/kOLkGvXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LsmHmZxD4Wa1cfE0DUesZIr2O+hNNQuJLCm0Oc2KAOgShrBRwxYkiIVpXWdjBi60biiiT4/+4cTyJ2K4gcfa3TsfepZPi1rQhr36GCi4S5hv+4Kl5d80XS1tr2bgg/Qv/6p4WPFPg9HoBqO8ttkCqT4LxwUUHMgqsb9vatOPWrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hLkWIOcF; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLkWIOcF"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-842f1dd60deso974164241.2
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 09:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723911741; x=1724516541; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t12/vKBQ+BTOwmEU28CoMcUpgMEMzkHiojh3S4o8A64=;
        b=hLkWIOcFFiYtgpeJ0JYPjePp1i2rB/tW5L8OlmRp5jU0qCUlG9+PTPLXUX2LQ/PqTj
         uLxG7Hkv5/5vhxUmZNKXEWrBMy5+mVs1GZILpP3jB0fz1QP2f8r7L9hrL0U0fzbiSYwx
         AXrFPtt7vDJo2SsPHoLVY4KPAE3FvBKg1S3aYrbBUKm1E3yxlxklNOE98kS01HyHnLkb
         zF+/7fRWfW7hTBT8Loj5TuDhQwlQ9MVTcOu6vgxFeMgX5t8h25nour15GVmopaISKuSW
         6aaS4cuaXmk6938CVz+v9pkNtf/eCSBheoV9d0CWfhTq1UZH4xYX628HCTO01uaxjWFm
         kiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723911741; x=1724516541;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t12/vKBQ+BTOwmEU28CoMcUpgMEMzkHiojh3S4o8A64=;
        b=uXmZzd88ZN8CshTax0t6eCRciVQuip/DIWQa7BP98ySiV6SF2KbGQ0Na3Z1n1yBZ1X
         tyyVwXkZ54KQC0jebb8b77p7DVMYMf8li1cUMRzJiRXPSFXHn9FkuzEN7dKCp5rJ7c5l
         VBhhcHJW4dyBr8hi0zz3Rt6poInoTsxt2VPD4eEGpABtCfFTHLPfca3AJvBd+YaxLaIP
         KPyGY/+lxvT9oA57OWWYb88wCWNegJKTWm2r25IDwpDYJDnuFc+ptr83yyiYpQz0+8ZU
         31hoaYplnRhdStg65XJmo3+cw0+oNxD30EAPdIS5wc6bdbENkpR7lXJCheW8tlgK31Ym
         1QCA==
X-Forwarded-Encrypted: i=1; AJvYcCXtwhqe5F0zqY4dsK6Bg//+JO/MlQlfJr03RA5CG5V1letp/fSRbJQ02+wjAjoMUSl9kJ5tqQ8reiXbPMkKl4D7g+vM5o4cZg==
X-Gm-Message-State: AOJu0YwweZcFwkcqjAIJQZ08glU+6ZsCOeKlyIP/MPjn34p6TCdHewS5
	D87IWa38bJ2V/UQ6s3xwFKg2qy7ggvhvzHS1lm2rU+b5LZ9o56TDaOqj3P1xyg5GtbdsWXeNavZ
	0bajot8rvYrKL6xe3Cl7epxj5e34=
X-Google-Smtp-Source: AGHT+IGGYMDNINV6tzu1edYqfq60zKD89vxmcioB62e6R3vGJZzREKM2WCQ8g+oP+MeoG5ozLwEKe/lqkBgOUSJnSSE=
X-Received: by 2002:a05:6102:5487:b0:48f:e57a:e2f6 with SMTP id
 ada2fe7eead31-4977989a328mr7027949137.1.1723911740752; Sat, 17 Aug 2024
 09:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240812160132.135168257@linuxfoundation.org>
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 17 Aug 2024 09:22:09 -0700
Message-ID: <CAOMdWS+OiSaHXQsChisvGJAJSAi4b6A2BcAVECXFdkjiK-yOfw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.46 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.46-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
