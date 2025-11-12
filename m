Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F6F34C121
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972503; cv=none; b=IUsk5khxRS0mVRtAJwMLaEOqe+/5jkmCEfv0Vg0Jryxc9TLSAB9BWSjwpm0fRD8W/NjcI96OIdkHEcqh/eMJsmLG+dVDUdqpE3RfbKUtzofKC4lp9ivZ+SDVVwaLf6i0syfIJRqrC/3blWMJ/lgYXNM1mzwKUMnELwtilokC8Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972503; c=relaxed/simple;
	bh=CiCb/WxR5IiY4zTCVf9V+wc+I2yi8BeC/aaOHbPg3pA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mgsYU7uV9gVwqJ33DzOD0z4p5hFyUlrw4wJ+brb82QLCcL0tK5PRzlBbFjY6zZ9upQZ2FJY6F1KdYyWD/O3VrZ86YDXVomg7vfu8dsYUs4iDhd1dk2aOgQ87DnrIy/sX6gk6kH6F19Fc75t02Tlm4kM74qLZPVI663jo5TFQj3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gkrq5pUP; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gkrq5pUP"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37b999d0c81so4212321fa.2
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 10:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762972499; x=1763577299; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjohzFTrNt1dds0Ak9mhbsBPxnWVffo9MAGuUzPAPSI=;
        b=gkrq5pUPmo2IsppKM83/Q7ELylLhS5Gg+hlQ5gQMfcWlhmVR1UCsR1n3CFUuwghuRP
         HPzvqZ5Dzk4gtRWMh0wivwEikYtmxR/8YMB3oFpCa9W2pT3eTUzRozBQ7OaTMRIaozQx
         YvFDUYzhQt15Nkx5VnUdv9lPatkFBGhTlm7Qc7nHWj+026imrcaK+6D+dPnyx0vobQL4
         8s3jBKeKJUSarbjPCEoGslKOnjeKkbB7U93EsR8EF7NjAhmG03VwOG8ntiT8rlXP3J8/
         0Z0LI1xZ0biosgR+uH/ry57ckA4W8MEuWzWTF1zd7igMv7iGOupDv6FU3ZdJ0CAGPcsH
         zuMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762972499; x=1763577299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jjohzFTrNt1dds0Ak9mhbsBPxnWVffo9MAGuUzPAPSI=;
        b=nXhyGsDCKlOMbFcpXk4ULrAuXnHsVOw1F2If9NpPCsaTr4qA0Lv5VhXfmoqGy9guiy
         33Sade6c3BIpr75t74iRLNIXCJoNk/YY5/q/Px2vxHNPjubQtrUoR/Ghv5YZuvIQhLPP
         K0ysRsi69VPJTa+h2FQcf5rj5ihrfOHZy1DA4lUoMuR/1rausUIAdGEi11j8iGJ+x+Fn
         cI6a86ZS+7FvBQFPdpVIUZMx3/xFtzmuPuqD3d5mw8vZT8tHqzxk/qFPhhvJy9VZ6ehL
         QPRrHUocmVKIfPxuCbeWRIxHjd+A1lzjmn2BMNqvPHjIra2Pv29mNjo5cQeJG8r/DchN
         Y4zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmKg8MC9mrDRh9GoAQdAl3XGaBapU/CgRQKRLs+Ew6xWScxrAESTzCqjbZ0zPjuxIL4mqxjUDz@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+2SvHhZV1HQKnsPPAAHMHZmeKlFHfKKtdN0lYA0pGjpJ89NDn
	D+jFx5GLtqOjEgNhQXUq1nC1yGkkWcuMrh3YQ0ya7Tb4IAxQxTGu+D97jgZVWDsk0HdduLyXDo0
	J+fmOK5qctm0pOEWZ0Di68buVvTouIk6BQCQj
X-Gm-Gg: ASbGnctPrYp/pt26p9hdUVdnfHzIAfvhN3Q0PP44ZnlZ/92/FbQzrpL1bvMu98fK4lY
	DhqCo+T33y1Bbt+Iw7Pgx0piQMGJi1bzmEThdRDcvV28hSg+KELj27hDsDwyPZrjces9Np7Zka4
	dfCb8KlFtNUJIhybXpU+o0QDsp71VRkNlZI/RD0vH4KQJo0M57oIyyd0i77FWWTbA230GiVdYED
	oRuM32obKPkv/bXj81BjLOhPLOrcjY8G/565YMk3fdLnX5dc2M9tnPGmxaA
X-Google-Smtp-Source: AGHT+IEa3xVTKMLat1Wb0V6k6SNt6JXXRV4if7NrYfYOs9e0hkHkyyXtZb+lc0TmiRtVlY0vx8iH0c8Q2gESBvg9vVA=
X-Received: by 2002:a2e:98d2:0:b0:37a:9558:5bf8 with SMTP id
 38308e7fff4ca-37b8c3dca00mr9373041fa.32.1762972499219; Wed, 12 Nov 2025
 10:34:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111012348.571643096@linuxfoundation.org>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 13 Nov 2025 00:04:47 +0530
X-Gm-Features: AWmQ_bkg2w5p36Lweybo9KaHemnwRDH-EtITn2wPi38Rv8gnjjgkxCZ4pHNcSPE
Message-ID: <CAC-m1rqHCCMwVu4WVVV4w0SXuZNuv+e+Q1qZUzVrxH+=EeGJNw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
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

HIII greg,

On Tue, Nov 11, 2025 at 7:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.58-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Build and Boot Report for 6.12.58-rc2

The kernel version 6.12.58-rc2 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.12.58-rc2
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit :

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
