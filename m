Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3295C37BE88
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774981515; cv=pass; b=t4eIdUh9+hmPIQw9DabgQ0fIweWuVxUgV5wXk4h6vC+iTVuX9wdDLn5Y1lQWdoqLkb0pQQuHa3WAT138LLG9sWRdPAOPat5aVov74Q0bXOzVqTdlZzh/hBjCL6gcwqkl1gY+CtjrjHkx2a2e05InqH21LHRxw8RSuTe+WZg1wv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774981515; c=relaxed/simple;
	bh=vTWd/5txerNR6ocKIJ21Zh2GeUmfEADmayV6P1Cd3Os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qldPrMbaC2kLl3htxhvrh2Vj4IfqCTUzL1zOfsr9wMee87HPeBjok0GwhAwJfZnKUcv2V09t2EZd6efFFobKves/dnFEFB5qdRCu3BJYR7/S83JxpW8yW3mbgXJINZ1GeBP8S7UjbzZGfmMDdXX19AeS9AIjKSHqW76+RGZf1Hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYc/tMNB; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYc/tMNB"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a27b5ad832so6922091e87.2
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 11:25:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774981511; cv=none;
        d=google.com; s=arc-20240605;
        b=CnwIugRjF88X5/fnGH0Z5eCTotCNBvTX/CVT1sNPVpsqneUGFWHHXYMusZwzNPkkvD
         uBMoy978m1sNK57EiJvuL6yLg/ty4O7l0q3d7QYhv1kNpR5M+x8j/aug1JTzSd83Hpy+
         ALX0GD+l4wMmBRzbyGu7JZbGoy7b7Ocoa17S8+nAhHe1bICV/+7jUeu941sUIiRvH9ar
         76FeLTJVW5z/QbCvbHPZD8KvYbcYtQALkom1VKiQdnQRurerQBDoi7nsosEycZew798Q
         epF1/Pcvt9W4q9DxmP7WI9QM5/Trq3N0/XQ16ZnFHUoe7Py99dZ4mVhaDpwuqgDnSxvt
         vWGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PntACFZQg5z9mtUa4D8HfpGNuTMnQ1Jh/pka0ARSWzk=;
        fh=fyJ4oMnTxzTo3VYkVD4Jrpb5gJbxc13+omjyQiW9o4Q=;
        b=LEGyH05MPTqpVk9ZhCh3y3Iya+LX6FXauHrOVgkq0BYOAYwo1CEq4l0VGhozB51XNR
         u+uqW0m0QeapvkJ/lf4nyF3G4yjYtRQOMAsFgSyq5Uzhiuuycl6C91HkakaxQwWzSGzE
         j/iQkQC4zRiJKDraf19XSLReEMx2XkWBVQToM4IQHVV8MQGBti1eQsonOT3Gr9xFE2Mc
         jU2q13p1bP2u/WAeKIvhGR9PyoABUbYNGEGoaaBYcKOS2qpmdh6LDZMJ38hxYbZxMiMZ
         0cMipHLNfMr/Fyh28YMMQ9+hQrRmHgfCQD/GmwXYMdxWVENiyEG2ROW9PU/Sc15Wjy3C
         KyMA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774981511; x=1775586311; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PntACFZQg5z9mtUa4D8HfpGNuTMnQ1Jh/pka0ARSWzk=;
        b=iYc/tMNBw1ajOD/GFIgjshhWeyJv1CCMv3p7nASb/pHgHLYElElO9J7pLHD7gEqPn0
         0PW2FYHJHVQQmR0W/Btkac8RWAJ0wwn9N6n2OuLIX627M46+zUb9PBf3m8xyqGP6Llw2
         AwTWFtHuzjS5z3hU3FnGURrzPojlHyA8unPEK/qF+fp9nHdeQ0ftmVhYV92b0Jw25U3u
         bCT/fmhc3PL7SgGTYr9iQMnv7FyPnFgYzmyhe6XtH84tqRuntWgnMg4T3j2vqRtCScaK
         EfjZdPfUTcBsxHjm4FLkvFkPQfVL9P+j+ceEePKcnfI3cIdpMj2HrYdkHq5dY7GFpc9q
         AQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774981511; x=1775586311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PntACFZQg5z9mtUa4D8HfpGNuTMnQ1Jh/pka0ARSWzk=;
        b=MpJM0pinLjSAAQvoaTmADQzHO7x8qUM/14nvnS8wNAJQyN0LKRV7t5Gs7DXZ+Kww5+
         l+IUSjVhhr4ipc2SCSbU/0NI4SayaGYdSAAUAPZN64Y8zrDgIvczMGwUV/GGXvmxSCGx
         1iNUuodvTEm8znPS//F/Z2moIReYslm6DatOCd1T09h6mQuPVc+1uhqmW1ZMddDuhMVJ
         svLZz45OtztblFfsC/9bVK9yiOAk2Bybd42DnDXaCKGonm425Puvaux8Kqi86ZmYogKk
         UtSRcpEQ6yWFdJxsqenaBhhOym5VphD9KYiUTj1C/ZICJRVusDwDrv9a0yx0pERFkOoG
         da1g==
X-Forwarded-Encrypted: i=1; AJvYcCVyvpowEoRN2jgCc2S33khwwu71rXq4FS36GCtp+B4Ek6h032gE9zx0AirhcvMfnYxx9etkTO8r@lists.linux.dev
X-Gm-Message-State: AOJu0YzAMoCQONxHhi31cAVxoE3URmJST0ZHgDp2aBRKH6gFdMmxyVtg
	24yaFjq4HJkJEhxyie1oxGerMxkwgeNKj1cr6HXRrRKcvmZ/9DewijJ1RdPBg1qul5fQ5podqJH
	2773ZkZrenz4fFxFIuukDIioVnvXjGfA=
X-Gm-Gg: ATEYQzz/9908FeavxSeZt6ZUEzO4J9dpUPz1MXm4n2ZgHQEbNg9Mtf83XE7G6XqyWZP
	9IvsPl6mbMV9zORj+82hTtlOM2FCdgFVa7Hi3lSa2o+IlrvZ+W1/JZqjnGlrSt7KCxIEW6ucF9E
	luIuTNO/UMRNW+YFpcFlxwEKhAIALKPKh5pGrD6LAYBcvOS1fWkqL21zWo06PZ9dbV4zWCKoKBE
	gQVvXFlh+Uea/nV4GKum1P7xOxuXPl3Yv1gN22sGyRuqzmCVFyWem3oODAFwtNH0xYl0X8BbS0X
	ZqcjKCjMqbFKtdAg3g3urgeP8wFRXXrS8QyL79gTUA==
X-Received: by 2002:a05:6512:3047:b0:5a1:448b:317b with SMTP id
 2adb3069b0e04-5a2c1f3b10cmr176273e87.42.1774981511023; Tue, 31 Mar 2026
 11:25:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331161758.909578033@linuxfoundation.org>
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 31 Mar 2026 23:54:59 +0530
X-Gm-Features: AQROBzDJx3vNak3oGS7asZcNSCohTEGtmqc9XYuavS2Fe2-SJUVoo5tp3uAo77U
Message-ID: <CAC-m1rrRUvxNs==Vzb_myMdRH_nCFU6oPqhQc7+pHcZAoSBQZQ@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
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

On Tue, Mar 31, 2026 at 10:17=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.11-rc1.gz
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
Build and Boot Report for 6.19.11-rc1

Build and boot testing was performed on version 6.19.11-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 6.19.11-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 411f8a553ae8d2f6aa5462b6dd5f1d6e9103fbac

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
