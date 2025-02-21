Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3A3202C56
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 08:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740127887; cv=none; b=HP5WHP1Q2DC6LC1eOhS7JBr6FkcoiE593hEXwnFTep5Kf25kyH4FSF+SQITNQS2dW/5459rWgj0a0nZoE5I3aed7d+JUxjIbX+0n+IZRO5L788zg29yk+uCsIHqqBW54ektLVjB3MH2hv72IZ2BgKiqvLKcQJ9aRW3e+uFoR49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740127887; c=relaxed/simple;
	bh=j/wOYnB67jjGhylOIqHHXdLyAsqr7kq9q2ecSsLgwdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hE3Y2Bf7l0THHaYYmADwNWOTgyjjVuDD34BgJdDFojxJN+3AJ2txjn4I++CM4qsjVMzxlPcRik+gTpy4LuyzQIJCnUaUflUXExHetT6qtTPXaamz54BWeD7IGP9/ldJ450Kr2JF9hZDFtXbNvi3vu1+uWjRIPQXCfmmyBX1+u0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=En9rdRJP; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="En9rdRJP"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fcb6c42c47so2997889a91.1
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 00:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1740127885; x=1740732685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XO8S0SaLHILveS4ht7ABmq8EQhy1d2PZCdXORUNN1qU=;
        b=En9rdRJPJ2Q7oO+iQuU4acDVDjnd23cLirCvQZpFp9amkpf++lN55oEJamy/DeUlUc
         0X0CIvwB9zwZH685vQg0Y42VEkSRB5r5KQ1bNi1K7fAMtuWqnfnkU7pGH418xg2/iO0J
         TPFinqySgj9/GvfqfrJyNa8p7Ruf+dJ0VXvpzsugnS1LV7LxrrI/3d2ufqluAli2piiD
         oZhiS4dcNI4sjmA43O8vaZV9Yz4QRmcOaxJ6h5fmGu112cM4eu6z7tpTN8qRmgbpCpNh
         dDD7rLn+CKUGT0zSOHAW0mgXe6g/1mvDjuAzfL8UsKtQel0vgsybU9qzZktdzwkkgtWY
         HjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740127885; x=1740732685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XO8S0SaLHILveS4ht7ABmq8EQhy1d2PZCdXORUNN1qU=;
        b=rP7k67avevD4Ic7Vg254l67tZ+2wJ7P3Ez18SvhvU5FgtsVpswkmViyHrQFRCIdcci
         kkn0IQP8OAVIlI6i7Lqa9eydm4Un598bpl3+aLHBw5IYfdz3FvRRBdteEJQUW1ynoQ5Y
         Ll4Wlujg0+nSyAD8nXAi6DWGEGh/J6Qga41FDKt74WjE9CeW9s1ny3UpWbsKPpHNqy5a
         gcYNLx+/8JjxBmDlC57rREA3mVtbzijWdlQcBgpcXVTVk0uCS4g/GhZe+bfDyfT+cCTL
         yd0oV6xjTKIyTGpHbJwek9/FWVCWgm9NVhze3HoHLA+QKWtt4hwfJVpIlpXwH4C+7NpP
         Xh3g==
X-Forwarded-Encrypted: i=1; AJvYcCXtFYMCt61h3JQEpLRue9zgvumcHu4/2D1cWdX2ZqkrnfL+wePRLc9MT1iYv7VCZUIGk/BrF5oV@lists.linux.dev
X-Gm-Message-State: AOJu0YwbO9IwPG/H+f1uZm4zuIVZBAgXNvV+3ibDu2XYGpls5OD98Mr3
	LWWjpuvoOoEpJVpHxAGMdkjdkxYqZw8NFGvx9QoIKDZim3sTPwQf+ut3+zRf/XutbKAN5B33LLR
	JE7Uny/qgik8QiKb0TTiGlVIGYrMFw4tnEzt8Xg==
X-Gm-Gg: ASbGncsMgAcfXMmAKeFZgpg9ILhW5adYW496Dcks5x7N5n1YC2YNlpZL9/c7YKVs/sl
	o++LrlfLex5AdrXKgj3xZuNwgbbEPiKZxBvPQKNpd2Y0xGiy+O1RMjCtj9WvwCTLmD9UYXwLPRb
	/8ERKoMRk=
X-Google-Smtp-Source: AGHT+IEys1/8M/P5ptc+GdcwlwtIRcEANusxbYrUGgN9ECPEJXUzZ5K8uZ0Zj8B3SEJuEhZa535B38wLxLJpyCPHfMY=
X-Received: by 2002:a17:90b:1dcb:b0:2f8:4a3f:dd2d with SMTP id
 98e67ed59e1d1-2fce78d1b51mr4418486a91.15.1740127885545; Fri, 21 Feb 2025
 00:51:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250220104454.293283301@linuxfoundation.org>
In-Reply-To: <20250220104454.293283301@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 21 Feb 2025 17:50:49 +0900
X-Gm-Features: AWEUYZmUcCpUlvaYFgWvcXhbRnoQJXLD6KDcZQvtYu61SAoEEDpaEQOuReQ8_i8
Message-ID: <CAKL4bV7rLDPWnveigQc3ak9O5aUMNM6iQ+h7Bki39fGH31GcPA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/225] 6.12.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Feb 20, 2025 at 8:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.16-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.16-rc2rv tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.16-rc2rv-gc3d6b353438e
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Fri Feb 21 17:21:36 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
