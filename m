Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D42FDC25
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930392; cv=none; b=gN5xgKCg4DXjPqF2sxFnqTrDQBjGt++YhTYykDZO32BXI2jRUMVMyo6PeqVgRFL6nGFIrVVvNuWpWVIuTIPdWqtyXt9ZgOCS02Jlx4DCXs40Xftl4P0CHISuL272HZqFWK5vm7m4oqycYer3EtvfQvGUJOIofULik2R0BqYvi0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930392; c=relaxed/simple;
	bh=V4e11FPTB70217C5nj91+hem0/N3V+YGbQrtmxcFY/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LfocEmGxOTv1dkn0IIBiGHD2u1bVxF8nmNwXvu1l9kaCCd8y6bmG7JcIzzy6XskRpvQYSm3FrbllgzkEl9M/1HX0w3ALgQwbDFlxfovT09W1RsbDicSEyUR6mtd6iXVuh5ZhHYNw1Y85amZHuKprI8ndX01cxRXZc6oK3A0wVkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IEhaT/lR; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IEhaT/lR"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-591ea9ccfc2so3463053e87.1
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 10:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761930388; x=1762535188; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMkJiBcxuds+akFzr16pnTLfygNUfqye+Q3+HnkrYH8=;
        b=IEhaT/lRwBoXye9oiB3APBWDJ7wD+69E4MuFDLrgCf5T7hzLjarv2St8kEWNKLeP3I
         ojlECp3mQrjl2g3jsPnp7GKF7Wk8oFOZLK1cl0YTw7mavil5wsK4JkEehzhHHqtDSUlp
         T9w7dzrSXUI37gV5dI8Gho1kd/q+VeaIdq4GYNgyUAoYkE/h0EgF9v4bftguAO99botB
         81/qej21vG+nJqYPqyQFwQDEHFPlbAWDH49f3zyz4GPqUZ2qpfOGmd2OocQ8Lb0WOsuT
         RuDNZJF8yLbicXubrB7pYg5JqJ9fwRAT0IYJF4lW096MXMG/qNtEEyMh17HUhHVDoRqy
         u5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930388; x=1762535188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sMkJiBcxuds+akFzr16pnTLfygNUfqye+Q3+HnkrYH8=;
        b=CSp6oYyzstchT6QyTwsF/EEZpopDNExXcW3VXQ1NVLtBOP/LWSfMBVhXx0GVPHxAfN
         eCxVJflrmm2b2076TR7yQgxIfFr0glfNoSJXnW8PX4TX9UwlAg5BdOflazxTFqTQGhcF
         xUZjthit42mrb28KVpWPRCwDgW995A88FOHqaa16VlnCOIpwvCo81UUPQZsmAnFID6rx
         mHOQhRyiCuyTxmDeR0JQjek8ogYJ2mCJwPkMPKTcaLMH9gPS05DgRooqIxb7IDv2mzhF
         pAjGfmbhjaoxJTIlKECybaSVl/yEOFnYq/UrehypvLBpzjnTtJvgSt8A99fbG13oYd3u
         1Eew==
X-Forwarded-Encrypted: i=1; AJvYcCVXylIsmErKqI+MoEJWpbZKpJwJlKxjBb7u3dqjSmNeWvGAQKV+SVsbJ8RuEhpkaJXD7qP1snpw@lists.linux.dev
X-Gm-Message-State: AOJu0YxYOBeaMuwqTG5i7wvi8XtrZayMqDaQLQt1ocPXiQontRR1scdQ
	55tKjzmT0pRKeiUiwmOIOvD7npzgvy38+XGxI5W9O/L40SL1q2qcO7burXGtZ4i4qT3r79A14sU
	S2YSt3EA4+Wh3BIxdUHUeu7koqyF+wW4=
X-Gm-Gg: ASbGncsqQRnvc+rjth3jU6Ehvc2x9Bx785ivgW7EQ1k6EvzMugGSM2ltJK8wkzW/xaE
	Cka17J8XKEytKYiMJM7MEbnW4mwo9hNcAL7AhPcW/HB+/cYI8NJFpk0saTN/27yXmskHvjQwrfP
	8SLreBe3cuW5xTjAJ5/jp2RJhvLfTxaVG70/V+dIjhIy6XBBv+4Hl0Fw2VI+9+W7xNAog5cTD7x
	vNqYlK3CGTKtFzJXFArc7cLjLw39d1KLmuW5C4keWgnZumhPHxP9g95YIGcRKm6WE+aETnmL33K
	7OHNKQJzTqJpU+/4+Q==
X-Google-Smtp-Source: AGHT+IFnG8xxlm9juE2SEhrODTBOOrCE0rh37MNi8KlVkCf6aXpO0iApavTsldubjEQyHeOMvNj5YZ+IFGx8qPHgQyY=
X-Received: by 2002:a05:6512:220c:b0:585:2df4:7965 with SMTP id
 2adb3069b0e04-5941d39c3d0mr1492676e87.14.1761930387930; Fri, 31 Oct 2025
 10:06:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031140043.564670400@linuxfoundation.org>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 31 Oct 2025 22:36:16 +0530
X-Gm-Features: AWmQ_bnNapyza39VXDxGKokse023cnqtK8m6TeE7upn_35b0lbcczdmC83kKVz8
Message-ID: <CAC-m1rod_Qsk917N9A5G4a9B1vwA=n+E0RTujMPBAk96ZR3J=A@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
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

Hyy Greg,

On Fri, Oct 31, 2025 at 7:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report for 6.17.7-rc1

The kernel version 6.17.7-rc1 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.17.7-rc1
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : 7914a8bbc909547c8cb9b1af5fbc4f1741e9e680

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
