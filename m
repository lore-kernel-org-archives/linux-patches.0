Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003643909B1
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 17:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776880131; cv=pass; b=RXw3qt3RkyqiWLv8/Ep+S6fjLlYgCS4guHXPPl2sGe2Qr3vGZBNyV1kNg7z5nGrDQ425oE4uh+fOVNEmRB4yG9+R4jsEVnj5BNAq6fKgeJ6cnIi3U5YhwNN7u1wG6PZXScrvNL73aHvb+YPl4N4EzD5hoVwOjYhNaujR2oMVEm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776880131; c=relaxed/simple;
	bh=qon7y6o9zTnB/Xx99TUqlH+uNjnbrTNWb007t17VXAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l8bjbo63F609wVGRIWQRIlnv0pGINeTuwN3HQNvgOg3Q1QXPul7FRiw7fDO1FUZ4l5/24wtOm4LDUfGgS/VzqTbqRjL3JkxjNCyqG6Zejj3cD9nhuEPM/GmDmY3lx7WOrX+aKH84myGP1zCtBFn2h4w1rPc3//DA0zxAx2FB650=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oEhw4rEx; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oEhw4rEx"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a2b5ea59a1so7920780e87.1
        for <patches@lists.linux.dev>; Wed, 22 Apr 2026 10:48:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776880128; cv=none;
        d=google.com; s=arc-20240605;
        b=A6nU4khRnLMUW8rDYsZK+kFkZQiPgfBoK68dOIma0d1fOo5oQWWDw4nIMjlQqZqaxb
         MSrJk+gX5m13qgA+Wdwa7BHhsFHx5RiZARts0SZDbN8NMO0je1GKM9mt5gAMNO7FTjA+
         L64SCWGQ3TiephhTWMHREgF0ZRafBz+uiKeLEVlHc7y+fD3h3T0wTM5vPmc9VJ3xUV1E
         fLmAiEZ1f45/FRYsKxbKdpqcf6WXXmafDuDTv1k31A6ku2GWclOjqoqY4akKIbBlUHdM
         cFFbeZsqWn/iF+h4piT5CwikvI3KDrVJ8T9VwBG0FWNqpAtyWycC2PiNtcq7lzBH5tHY
         5ykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vzy81VImjVVpgnx2EjGyMDO4d342RAyW8Y30pwd644s=;
        fh=vmDp5/boERc4loKJVzvm38jTy0cXFri9pkcacMbeLOI=;
        b=LM1/KdDaY3GCFbjjYqub+7POSwLwJEaLRcKZJEcyDyiltQmuOC5I4WBsLTqRcK20KQ
         jl+BqlSPCmm7hz9No2RX8BfO2mTNNGq8PFKpgfFQ7L0m0tbU2fxKFZpUdf0y+RloBnhV
         vO/uREA1LS/Oj3bXvEfuJE5U4CW6rgApyu9QyCTVVRbZpu8MYACYRZXUWUvvsttUgitV
         C3YPP+M2lgWgyeV9dSJxrg7IYrgIrmDrLvYIKGCl9KeRPo2eI7J/CkFvIV5/pjk1D4uq
         HvCoG05FxQ+fXjMLp8ZQyR6+DzEMcH/obU7IVxFVa1HJLvHYqaYZCt95zOVTUJbsGaKL
         O5Eg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776880128; x=1777484928; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzy81VImjVVpgnx2EjGyMDO4d342RAyW8Y30pwd644s=;
        b=oEhw4rExGrUESUjIn8vB246nPVoG1Ey5OJyV82ZFFUdETLO5BAHqtEgFoyuroMYV5e
         7n3xSuCkySGw3K8PZGfyrZ7Bkf4Wl86ILaDZrS2PAPUxLDMGmGbj0GMyYH0ppDw2N5tm
         tHoUdJbWI2ZdbyIQG2O3/Db3Q3hkY5X/VZYa5n8b/egT6JagR1aPVh5f5xBm430DpiPW
         faudealmWtKouxPub+Zb01mw+tpZLHtGDA/YB/XO9awCNffH/ynqBS6ss/KzB1ARvjBd
         YDyzfhHn39n/N3cFkuK58wzeC3bMXyLhC9yhVLzxY9TszBwOBzc41ASjuyDxxIUsKiHj
         HL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776880128; x=1777484928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vzy81VImjVVpgnx2EjGyMDO4d342RAyW8Y30pwd644s=;
        b=ZJ3uOl67kxNntX+g7dgbC15dI0Z8peJmRtOEHQ+rLtc6A8lmvnb+/wvuBrq1FIdU+h
         iLtXkX0h+hiFZl3Tq45ptcr4292gqw3IS8/mVDLNmTyvfELbrHdl5i5r/2Rb2nwUiMnK
         5rC4797Xp6DtrH6F3i0vKjzcUBn+q3yZGMDQVw79BszxjRUIUt7m5W6fDHxwH4sUFHso
         kjZJ48vKwPP6oMy3WjVmufQTxDr+wmgini+sd5wClVrx3hI2xUyIZFKbRa0Vj6JPR8ik
         x38u3uwjcJyqHTj7IJkgzwY06KRHl6RelqD1+6YfbhnRnZ5bCJHf6c5s/ONFqwry9SbQ
         IVmQ==
X-Forwarded-Encrypted: i=1; AFNElJ9LZRLVAsNHT+TnYgFAIrniV/Y7Mq62U6suGFDVBUJZ1dUJY7aBNXmBjARxwKHxo4cLOO9Fw974@lists.linux.dev
X-Gm-Message-State: AOJu0YxjVUk402Riizkdqya8nD1DKh4x1T3kLoFO4nFjUN4WyqxByRpP
	Php3xvgSeClgIJlAXY3/0CiV+Z4HdRp9M9s5DVMft/lFzGqVYL2HSyICoYcGq/nGm9+fA8BNWsz
	T3tPwXXjo5SRF/ccXpqikUXg+LpvdERg=
X-Gm-Gg: AeBDievmwzprfROANlQyhDRmxP0AT2/kdfeJnPmOoDV4yR2jVupZRln4/WVkccRpGju
	Aafv/LZsU8LipSaSIN6b8VKPWAY0Ffkn2SLnkl1Qgd6DD0jp5gM+qyHWCrqe91GchsaTbJiyanB
	H6roprKAoA5RbRkcPzgN11xAZ5N/UyqrMafFlqVyL3RK21m4juQRaDYYDjraf3MOlMXeGVwjXfi
	FYPG1AQaGIMt91KDoa8sSh6RQBTn8Aj9sIWA60GXlgdRRXBHGzXGArfRx/mIZ9fGcC7TGGyR+Ti
	6cXZcVtOWwl9LLL3c+M4Igya28j2au7pY/4VLYtBgFL879d22ryOlRcay8jt
X-Received: by 2002:a05:6512:3e05:b0:5a2:c0d9:4e95 with SMTP id
 2adb3069b0e04-5a417303620mr7782695e87.39.1776880127780; Wed, 22 Apr 2026
 10:48:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260420153934.013228280@linuxfoundation.org>
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 22 Apr 2026 23:18:35 +0530
X-Gm-Features: AQROBzBf9c1uXFX2JRLrU-CAhd3tpip7zBxRUwVFK1FS2T-mKKlIpYYYyDXQrFA
Message-ID: <CAC-m1rrppB60zSoh=EKCv75oOOJ7RGRG1eauJ0AAFjFXH2usww@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
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

On Mon, Apr 20, 2026 at 10:57=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.14-rc1.gz
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

Build and Boot Report  6.19.14-rc1

I built and tested Linux kernel version 6.19.14 using the default configura=
tions
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 6.19.14-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: d5ff99d1ccf4eb2e2288c5126f1f846a8ed7e4ab

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
