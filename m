Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F96274B5F
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776256005; cv=pass; b=HPsL+Z/eIAtGUeWyoWI51jiwHXsGG1f4jgsQ3Pye6sm3ldWENjmlCeogN5mKNBNTBO1OcPjWwOnwwMOkNLp9ijAnFRXL1RR5Kyb5n7z0VSJWXurehlTVWFbBVU2YXpttwXU6Be/CpLTS1cuiOd3BrIUaQ8dmw0hkC6yDH6plCr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776256005; c=relaxed/simple;
	bh=GEeHQr3KyW99nqGCoP60H77ymExJJnsL3KEri2OiJEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DJ04FFHXhrw7vRmP6kYA+4p2r6N23OXgaVYiGAc+hv1O0tAnM7DuCC4L0RUcczlA73f73lqD5JBnOn0GFmcX8dJYMnns3CO/v+hCj9pUTQBKne+XHwp+z3aTZ6UIdNTxFw5jUUXIp/t6cLy+uBva6sQoPzFuaK8Xoxzp6ZdMEkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/EixcrM; arc=pass smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/EixcrM"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-38df1889fb9so72836281fa.1
        for <patches@lists.linux.dev>; Wed, 15 Apr 2026 05:26:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776256001; cv=none;
        d=google.com; s=arc-20240605;
        b=Dm9Zfkd/r22tQcrAQ/c09o8Rf8snVpOCshqskRrjDv5Hz27bD9Dm1A9FN6E5CMA0GS
         nyOpuehzBKB8VJUR0PEBRj4+s/rB5G+8KrwJEGeYZSvGll7fXOl6rHhWC8BwCq9S8jXF
         e0VvH16nmdLmrp5HJnKlilxDRyCbwK8yQPoFrh69D6A5qQ6A1U4Vm74HDCq31l5/f7hv
         S8omkYGr+Ua59gRDl1jWRONlPkEds71A0xN5EQ4KJ0VRUbP2+5VV9dknj7VpnHIAr8XG
         787p0gZqMMXwXm8E8K/9qtjGA8nplmX9lx/Xdiqi4DQQvUjFXTjcYtmxCtcg6cZYhwu/
         G17g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qUV1dTOfFSErWpSsm2W8MI+dW7Ua6AIcmXKVwDRvbSY=;
        fh=k8vJeFJgPigubtcdAxZTRwk4/YPB+j7Opp/NpwSRnN0=;
        b=B0tZE+YohvgH5Lxtg3fT7wUUuR7GU8LnawMy4WwABkQzo/irLlSsqKCJ/fgboaedAM
         At0IQNkmZO+bJn/SyQzbhXeVCMcKaDcFPJBfCx/Lp6H+vEcDkZO5qUxHND900+LrcHOy
         41FdoxHID8gADT6Ak2jIWk8xQHJSEY51amPrbSCJAcmLDew85V1QB1quwJZmoIDY9pdX
         wht2uiT5PB6MlwX64MRsl4tZM0xQsQu3EXKweoUqeYgRNEzuHyCtsHvzfzcv1EPsMmaZ
         EPcDuho4X6G8wJEsTI4OS64M899o2C+8+q4M1qXW6qwIOh2rmbDzeB4ypm/tCqXyE0ia
         SKSA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776256001; x=1776860801; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUV1dTOfFSErWpSsm2W8MI+dW7Ua6AIcmXKVwDRvbSY=;
        b=k/EixcrMU9fiUfZFGwQQeO9KcuThv0fG9BmCFRrcOkEr12mnyzPUxmFIdbDJvlZ+qg
         rUPY6MFM53rX6PZje2wwk/xM6IRm+l8uvqYCenJLfD9wXhUbMUFFpte9PZVci9eKjeMF
         RHfzhOFqjsCoTr5tdCu1C2iytk/UesqenMKL/I6S47LJNzajM8emPkwHUACo/kSs1gdq
         M6OCzh/XIewaj1N0M3sTVCI/Ou89CppXoX1iL2xIrbngU1d7F2iJODSIrJsxnhRjERBA
         iuJz+Snz2JMsPdiVXKKSVTeamdU4Pqcwd1stL4mmVai54cUezFqdyt6gGbLMkAvSDR1a
         R27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776256001; x=1776860801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qUV1dTOfFSErWpSsm2W8MI+dW7Ua6AIcmXKVwDRvbSY=;
        b=IIAOC242cZ5YWN1nGvpfoAJgUZi4OEp6vd4GPpNwpWzfhWh35afG9sguNxtXwGIrvQ
         VKpwsP4hCCjawFSuTEnOT2BSxxplsk/ShTDPN8mQTCwCjfolZUH9ZSMmWdke8x2zrKqk
         qQ8t7+oGnJ0NEupRqYqXEQ2j4VpsrRFWHIYvZyMX4L2IFTb/LWGEDqzvWdYj2uALJSxp
         xfp1O78rMoLOcqtS0aVrBAuHo57QwrrHKI7zriwT2f1F+ZYT/Le452KlenxjEsIh23e6
         JhvDLvbjxVOiSqBzv8YAuKoODaHTYQX3TYG1a/d7vMWJnpWUwyncOaEDr/ZS6GqVbWFT
         VekA==
X-Forwarded-Encrypted: i=1; AFNElJ+f+sw1HwkyyN/OlE9okHuGb9MCPIiKm8XL25yvvZctt870Ifn5f5PTULBzAniC20GaetFnLZY5@lists.linux.dev
X-Gm-Message-State: AOJu0YwuzWy1ReZJeBVqbFsW2pxW81mQeVuTWd+mRWFY8VeWJxYONzI8
	AAmc9L9aBeEhVrPo5UyrCVOiuzI1jpBB4fMd2yuEeiFi5K7xhbgPaWTKn7s7QkjMzLqL5zRSU5k
	0RWA7f/TxKb4XJM0JQ1wwuO+zERCweK8=
X-Gm-Gg: AeBDiesLzlUK5HI4uNFUdRM5AufqzlJdz+nVfDxoMbixvz9nsbhvjwCOCzc0LytS7pj
	rV+lzhGdRrTQHNvd32rQ8b5S+sqOgQoc+3HpghgoQpO2Xh6f6k0JWQFUcA5M9QW3/M5IVS6csb9
	XP8ujXlPwVAIaCpm7VbEtoVjyUOMxBJ8GW4AH47Jm5J8h94QdUbZjT9Quq0tCEd7O9YO/JcsjcI
	knnWYAYsg+nPaTRhYV6zg1TCAGc4wH5vG2op8/TohSqCZ6aheQTfXMXuU8iym2hoAZ7VsqIGBGZ
	fem2J9V5PBbYMp+ZhSnN/dOSYMMWixCjNVKc2WSeXJ8qRE25xg==
X-Received: by 2002:a05:6512:3d18:b0:5a2:c62c:1edd with SMTP id
 2adb3069b0e04-5a3efd78d9fmr7649424e87.25.1776256001069; Wed, 15 Apr 2026
 05:26:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155731.568515178@linuxfoundation.org>
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 15 Apr 2026 17:56:28 +0530
X-Gm-Features: AQROBzDMaHVELjOLmt_LmQKQ854O8io-UBrQ5UQ56tiNjfT4Q4VKgjvAvqu7LZw
Message-ID: <CAC-m1ro5_HUtk2gC4wSdatR3LvFzE+Mu36qt=W3GR3sEf5NKPw@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 13, 2026 at 9:35=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report  6.19.13-rc1

I built and tested Linux kernel version 6.19.13 using the default configura=
tions
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 6.19.13-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit:

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
