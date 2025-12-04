Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9927233C1A6
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 12:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764850806; cv=none; b=GQvRkZieyRhfA085uHc5mSndQw6A6LYOkhMR7SkEx9ysZSoFzao2VooW0idIKC+2ngCaBZ8butWZm74HUun0YdfsXD4P58IopVd33o/BQDFhWH+sK6BRx07wNhDmJidz3+l64DQ4fPxk/PbY70jZ7M4NGBXUdwkXtUdjtHq+YSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764850806; c=relaxed/simple;
	bh=Sm+2aIqqw/aJL0UULdrPGtoo9777nMIW6rAyg//L9Es=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pLbUtqXTPT3xRn5FK6KNLIg8Mk5iS+6uHshArAf3IImxGexqOjYgdIiU+SHaKrspnIgMmumO10Tjbw3sDTCwYgCgzBI3X0IQnJFBIm1PJWpYPCfV9vJYMIDTH16qh4I8ZMCFIyW7I8mdzDFSMNQn/F0L813vKmtfgzK9L9+b6P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSrCzels; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSrCzels"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59428d2d975so833854e87.3
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 04:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764850803; x=1765455603; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVE6hBdJYPcwOdHbdSZFSWUTtXmvEkPiG0rIieF7pLo=;
        b=fSrCzelsQxzejPFk018F7AN+m5MnctQpkD6zJybZh93Eh/J7kXqXrIJ9eYfJWkjvHU
         Vy6uxATahwAUTZviHnZIwMUSTrgmO8CaxfHyn/I+JDu/i+pUvKJvtZhMGQCEDEkSZX0c
         0HSy9wHONXeaD+ndv5PQ9AVDKlIm+DiSPe7Mw3h4Y3XnuaxWQ+sa+cz196LSQy2N+MFq
         /Kkh9QRWZluaVhZN00TiQhIg7Ds4vo+EC348CWsIdRD+11qOwUXPVWgW/50guMREJzJc
         Tor45XooTLJeXLkg9mAP1gkUzS0SnzOvfDVMKPnZMEkXjS2F4HUCw+iY/VuoyR2YYgBA
         +OnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764850803; x=1765455603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PVE6hBdJYPcwOdHbdSZFSWUTtXmvEkPiG0rIieF7pLo=;
        b=SOrrYB57egRlzUrbzD73uKUzITJCqGRHaEsBqexPtD0o1/2Ij9X/dxuhaJrUiaPUxb
         9nqpAvHHTMJP+sZAdQBGOu7jjTfjfUqZcEgUqddXXoFG/t5WSoWvzH/F9jzzVyeTWwFq
         jLBfYOCdY0Kmfu5B3qbF/Kgqe6i02L6YX9lrjP4XZZHGBO6DgWQY7FiS7AAZ4m8QlAyP
         3ukJllwgVpWEN5iXMZxhRjO+YoRAgTs2aoF02b6EjFIKsuQyaWyIS555vkdaBrHoMNM8
         OPqPmBBWk0BcRzI3zGciF4MCWRZAP9EQi/4jZRj8PktJA2iv73rBBC13fEHvic6zCikd
         tokQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwllKQ0X5sj3uWUYFDdAJZQbwRBILHNWmWbtI776rqsr/8qFLrSCwEPqipVsvxvLoAWd8Hz9XM@lists.linux.dev
X-Gm-Message-State: AOJu0Yxxy4lo+4Y/UacQfAqUE9+fLHTYRavuQsNhWj1gckRyeTeJnUCS
	tzFfYdNYKzJo8rUi6gzroMkVejh5BS/8y6EZpT9RI58+JmprSqCrtfQTi7T7Ilv0hQB98g7oawk
	63VNwPKSZ0Ms+EJoYS/aOOZasTdglMbw=
X-Gm-Gg: ASbGncvs0gYY3Cnicpw8ETqSlChx9wacvc7VTaZbEKMcO3zIM5kQs79CsMF+Scwcghw
	71hnrY2ya2lhshZ8TvZsFEzdpzK7ISty2IJt1q2bRK8SKGPt2T65S1DuEaBUeipjsyuFNXzbTcZ
	yyxlYrtC2US4SUXTBpxv6+v6NRw0R+YuR446VDB0m/KjoJIbloHnoRhWfjLTZs9zykdHpDKdp34
	G/NbstlcA67gUQlVE1awrPe0NnKcw7Q29z08rN74Ef/oVqhfDtia7oGFLdnv+Rl4MT27VlQkM8N
	LJbKy/lPENt0PkZIBR7nNRKjbBU=
X-Google-Smtp-Source: AGHT+IGLvxVV/M97ZmEkGVvfo4Tf9FL4xyhf//LVP5ERW2nQ+Ke3B00ZYe6M3S+hezXlFm8a8YvGZNIvlr6TcLp6yAE=
X-Received: by 2002:a05:6512:1304:b0:594:341a:ab1e with SMTP id
 2adb3069b0e04-597d66bf1b8mr991213e87.31.1764850802355; Thu, 04 Dec 2025
 04:20:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152343.285859633@linuxfoundation.org>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 4 Dec 2025 17:49:50 +0530
X-Gm-Features: AWmQ_bk0f6iYX6aUaNOnG7cxZkVHJ86386Sxl9-0SaNSWSqrFCgcFoUdQC02II0
Message-ID: <CAC-m1roWM-JydNvmrt0+8XJH4ovapPjO6oe8V0XwA2=xV=Xw=A@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 10:27=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and Boot Report for 6.12.61-rc1

The kernel version 6.12.61 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.12.61
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : 8402b87f21e8163831f70759368ad9a87192eb40

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
