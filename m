Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE96382F1C
	for <patches@lists.linux.dev>; Sat, 25 Apr 2026 22:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777155613; cv=pass; b=X7KpTpax8xPAtIck9MRzdPRM9mrBwfKMv1dA+5DUX0uraHXitBjq3cyGs2jfeRPpoIZMg4WkCHqvLKWP8FCNymSpquSZom4eVF0picg8vGybsDHyX3fPrbhmJn8UAsSLFIpmQmTG4LHEBdwl9N3pEPrH33sJpTz+w7CQ0kA780A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777155613; c=relaxed/simple;
	bh=PrYaB+nuPevR3vXc/LAPV6jrBso4CMNvE3hTiLwWF1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hC8GieOF5KePqlAWjyDQCYunvHd1EFUWG3ZAcj11z0Kyr10r1+wN/BY7h7M7R2fszl9rZ1x+9qOMOGoT5RqQqfKu01X9neHOBTNOe6BbHsTMItkeJ9ZyrnoN+GwTu4Zg9aR0tlPYcmkl5E2n0moHKCSkal/X4I3SX5JIZmPr7qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FE5R2Cjw; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FE5R2Cjw"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a40502e63bso8055958e87.0
        for <patches@lists.linux.dev>; Sat, 25 Apr 2026 15:20:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777155611; cv=none;
        d=google.com; s=arc-20240605;
        b=BilYWtJU3SqA/qXGpmKG7VPCxuKC8uOLUQtUHMIr0ldWBxjyzENSFh2giWf+Zo8Uki
         CpYpho61+wwfc7WIJkrhW98xnjrNj0YrANS8G8/XkasD0B5l8t7TmLa8Dv6GAt5EStTP
         a3TqOgqFKj3cRmwnzBBXMKoQK5tasu6aVoSiXDev/BYDjhXB4CKCIgTTN+lzdoEFt6Yq
         bz3e3x3Q/XyhHZoovrIDFkvbllzinF1DLkDf1d5/L3C6fAVCjsReh6Do6hBxnG5whmMf
         +HOplxNe/foYw6QuQ2x4+Wa5OCRS1czov9PaAXN+I4uotXixpdhhzyLtnkx5/bRdKzw3
         6UAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2iwLFmkmCKwubEVSy1rfo6FTR9VvgMF9EWfGsJg5DJk=;
        fh=N9BnW1M/9V7BbOSeMCz8zCrPq5e/cnKaKy0sqrrWkyI=;
        b=KHqdSUBN1/GpE5eFYbP1JXOVqL9ztLKbCUOyQ1Hsrbp891qHHz1d2hIlH5B4siwyML
         fnDMA0juN7OcZaa+ZK8rNfXN+zXKCNBgcRYTRf8hLAzAPQUDDUNBx1YnHho7Z13CPzgL
         x/FJNOPaXTq8ecKECUrq23t/D1kgVZ9BrKOEW+W+BRWqDZvoCJF09n1KYAtjMEgg1CtG
         JZzMhN7cmoUSp1Qm1VcRN/aet3b0QLSINNtmo8cuE9a6voWpalU82d3vtAN9PrJ6K3kN
         ZWGwjW/tL9eWIGHAoa2nCF1E28IANdBCqsXiLABs7hGqXQTaCtaTVHfvINovqu4w+PEI
         ebSA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777155611; x=1777760411; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2iwLFmkmCKwubEVSy1rfo6FTR9VvgMF9EWfGsJg5DJk=;
        b=FE5R2Cjwo9Wpt3qW4+2f9Tx1sDdqBQHapmAjUYP72VDV2RrbEL7mNYHuSfRsBxK0Cq
         mUbf1MPDhNlF+X0jHV/2zWwfJOpOa9JSa73w+qXJNbQj3ZsGHn4Qag2e5G4MRBWyVIKa
         Tl5bQa1ziLwWF7BB+ql2iBw/i5kAUkt0GM1xyiEL35A+NgJO4aDCuj8w0lttCbn+Ir4E
         5QnIFvTli0iOCTHxXNoAOwg33ygHm9UOFLkvHZMiHf+d/xOVkMDm02hO/UlXJhezHqgT
         VnQjcG+q1Ip8P0CiL9pUlSlC1F/pXoQx6DJ+q/ECyDXSJMGC99MXGsLI/99JVqUquKRW
         zhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777155611; x=1777760411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2iwLFmkmCKwubEVSy1rfo6FTR9VvgMF9EWfGsJg5DJk=;
        b=Wv0sz+3XDy112cfwYkhEnvJHe1k5TbwDJL9j4+GJRRxD1nLqkhLc2c7V3ErQ69ywVS
         rDvYugr/qN/mAeMl+vAqS2qUy3LtJKhvVgZ7PbtknYrYmL73XhYPxlHMeyr3TEjDE8Eq
         LQBaSVxyNlLxrUpxRi5HKdQYzdHdE4wSvAzFcmTapvRILKRLY6xXjLgYGgbVaOF9RCo1
         Cbs4qkCvkiowRwRUsX0oafQNaXxmCKaZelR728s+50O2hbGs0rudzkrRX2CIL1Zn8K/g
         5X9Q0jlv8+AbEKm1QGUrpwP2ji0MeIsnqYL3wA4h6dg22zqfjycVrFFQQanyJ3slAMBu
         UewA==
X-Forwarded-Encrypted: i=1; AFNElJ9bVWThhoKAZL6dE5JuS+zk94UpVeO82Py0T33EIrzWkYnehzEA4n6d4kYF1z4eVhNsloMCPoFP@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2eMuBOdNCw9Yvl0p5AKyC74OrKRx1eii4XgNWGLMZrEWFlKXj
	kx8fnmhWXwopQSC4sKZEIWxWOf9NvJzRmBL/3RywQcxmpnzLV3LS8yyuzTgII9bUFVl5v5cF6qH
	JUgA8C5EgOi5pRiS8YeNiL/nvDn12kEQ=
X-Gm-Gg: AeBDiesf4qowVFd8x+/KsB7Pw+wC+c34UDKevRyf/AobmHwxyI1oNyNk8pXC62/ceC7
	CTO34WuD9qLHUa6NB0VdCRCFb2ArqEJIEI1gkuArocJmvzp2U/gtmEVFRdW7fOf9Np2mf8cDsSU
	Vb53VX/fWCzkljF7lyyZZrJu64dgUU1vO5YIpPO6G0pn7dUG8fQtkUa3xxK+tt1BkOSwuwqRRSK
	S5sJgR/WoE9WEDcz47qNF2ZlRxwrS2cGxQHXuFObWkY+8m6a+CMxZqoN82vdKTi2AP6qRuM/uGF
	arqnb5RNgGm1b3cUzXN6NtHmUa2sFnFvV5YTvG4Srd+u6mtsUg4=
X-Received: by 2002:a05:6512:3f15:b0:5a4:6f3:df5 with SMTP id
 2adb3069b0e04-5a4172e2d00mr11233638e87.29.1777155610465; Sat, 25 Apr 2026
 15:20:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260424132420.410310336@linuxfoundation.org>
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sun, 26 Apr 2026 03:49:58 +0530
X-Gm-Features: AVHnY4Ky_m_JioNNP4XLWEamao25keQJUB08If5UpCJ6aWS3riLWE3AuK7Y_MbM
Message-ID: <CAC-m1rpZKzivfC2sw08ADJoD3F=gjk9dYZQoHsLFJNK4u9JLFQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
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

On Fri, Apr 24, 2026 at 7:03=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

I tested kernel version 7.0.2-rc1 by building and booting it in
a virtual environment on both x86_64 and arm64 architectures.

Build and boot testing was performed on version 7.0.2-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 7.0.2-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: ce7a64af92ed7270208a84dce3ee2e63614212e9


Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Regards,
Dileep Malepu
