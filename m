Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F526F2A7
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 19:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767123008; cv=none; b=dmvGVgZ0odpIViXl4k21lQ+Byi+O2XWMrgZsMLaqxMN1yu+cR0wH7sty6ZCZlRY3Zva+phxUj2VDpuvwEbis23idIW5qbsB5NovVLTuAzADSGVp0RdtwpEYdcgVvV/ae61prq8C4eoeyPbZu4tLG3G/GicNJRhhJbFSVRuvmqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767123008; c=relaxed/simple;
	bh=VOG1S3/hPGN625m7jo9CcGLdrvR/LyclfuVau8azLdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVoGw0utQ04Xe0y5SUKldByheba4ZLWZf71vQhRbdqqMHZyyyx4gbDP9ngpB/ZESRSShuzgRJKzyaHbvfnjzbadAx7SgnHW09MORINUT+F3zZUSXcEltn3vD+f7Z66RFQWVZS/DTI3eZBQK4J1u3LwfeS0+058JF54LHxYz0jGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DSe0lLRQ; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSe0lLRQ"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37fdb95971eso76133461fa.1
        for <patches@lists.linux.dev>; Tue, 30 Dec 2025 11:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767123004; x=1767727804; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKPOxdFvjNOz9JlYzXz/QJIIlpA6vvDk1R0yH4qi2ao=;
        b=DSe0lLRQrBRVn2eixNSu6XQCYB7RKDonxNj1lON35BqRqfSKCweMYnAMvU7eeWfUoG
         2EQy+XS2mgBQMbDRr6SHKZkb6S1aL1ipq84TXi1mzXEQPZcDFdmbg5zfg9EAh0NiOMzC
         yltvbatoUZOpn7rbobwRACTm6qnef5+0Q5WqFBRDR1Bzg/mvgXMwt3JI4lIdKmxc+ntL
         6ifSxjfETWyP0ZwibLCbOA55a3xAGydMn0IiChKdBdxHTcS1u5ziAsvMIdzRGVz9ljPq
         6M8kXA7NwE0+immkWoiwX53V3TeDY9PdL1uCcKfHbO40M3/2bQ/YbqqQT4MgeLcKwX1u
         dXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767123004; x=1767727804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LKPOxdFvjNOz9JlYzXz/QJIIlpA6vvDk1R0yH4qi2ao=;
        b=IXQlKzObAk3Uaa4N8/6wjRaY6+hgCaDK2CCOIGR134VR//Th7CDrHhSWDkwEqbgXLm
         sU84H9Bm9nc7xqtwSrPAYyV+enj1EggHzmcm4vp9eOJoiwZRj1rswD2KmA661U7AliRJ
         ScMDsZ1hgctpHHGmxTPmjNPylDpV6EfLJ5F/2Oih/KwFmzSTT2ISjm8UbiJ5wuIbaMuD
         Ly51vqVU0uT4zBDQyxhZZ/J+12YjBmoafpcLmMYW0sJ8ivjouu4M2xQ72uAVtvfvraC4
         h6LyYZkTvo0D8mEt1GV5NldXPrKnOJfaxPsR3dGj4/gRBy+Z1roypR1O3XsU+jb3hyn2
         VcrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXr4PcwYbTiZ6gKZvu294+A+12UGh0t69vTC47I/SZuOQTTRxZkf5srXJAfn9Uu7noPs7BiVPOX@lists.linux.dev
X-Gm-Message-State: AOJu0Yxcir+0DXNwRNFJadTwfqyo1iaFAYiCJf7oLEWyLg+9iPjei8JE
	Ooq0/dSUPUDHvfQPHNK5mD/WS1FPS9RDiYQpj1paRzCNjNUaCF0hpQuljJFOOuTgbD2MKaRoT8r
	tl1czMZM6lTbC74B2emYcqWQ0KuzIUV0=
X-Gm-Gg: AY/fxX5xBucmifgyNN2nLB1DoEZLziJfGphTDmNYUEyPkgOpOsNdNmLMPm9LaybAWan
	WNXGfAcDHaw4fBBuDIGJ+tSOfq/ZigDFwjVNaEuo6OvQjrfzlGrs/fr1+6PkOwPNK3WZFBUbz2U
	JJXUttrqHwz0Xn/rjp3Va5W9tGgAIok9gLagWiE9i4OEYuRAMG8WmYEJKP2Adp1G9qrPDLr39xu
	rNuMvQyLUji5leb2clkWFVMuCD3OHakJAajt/huD/hbAwgigjyBLpkHflrUiAPCClJV6Nt5kM/K
	rPTQeOtCakBH90PUBSdLO5uHmoKlfmHYBO2PRsk=
X-Google-Smtp-Source: AGHT+IFElL4UyDpI2pVT853yD7czcRF3ovEXW+NcmNMICaMJyVmaMk4AVn3L9PKTtjh7GXPRGmRHUPcLvUfWOf+57ek=
X-Received: by 2002:a05:651c:325b:b0:37f:a216:e455 with SMTP id
 38308e7fff4ca-381215d0e05mr109636731fa.18.1767123003342; Tue, 30 Dec 2025
 11:30:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251229160724.139406961@linuxfoundation.org>
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 31 Dec 2025 00:59:51 +0530
X-Gm-Features: AQt7F2oMihyvHbVC_-x05OR2oAVUqQkLTRw7FDc00WccKyvAY6qIsH9VEp9ab6U
Message-ID: <CAC-m1ro7r5Ss9GSmTzr8Mj7HjjrV9P9nPcjWgMowzEU_MjH0mg@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
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

On Mon, Dec 29, 2025 at 9:46=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
The Linux kernel version 6.18.3 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig).

Both build and boot processes completed successfully on arm64 and x86_64.
The kernel operated as expected in the virtualized environments, and no iss=
ues
were observed. No dmesg regressions were found.

Build details:
Architectures: arm64, x86_64
Kernel version: 6.18.3
Configuration: defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit: 685a8a2ad6494bf0b31b9421d98414225146b792
Tested-by: Dileep Malepu dileep.debian@gmail.com

Best regards,
Dileep Malepu
