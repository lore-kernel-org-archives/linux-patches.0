Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE33632E74B
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765915177; cv=none; b=lOIYsW8Q3HreUHgYmbucqQIyhcsErS6NlMzJY1gGow5aGjgfvQUXggXovsjdB21ycF7HhsXI5M/kC7UR7zp4L12yiN5tjcxlV9LmiYTGLcUj7/GU3btrk+ZhkAIORj8/onGy/FEUbp+johaY+UIM5xxETxlB10MVSYboJbylw4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765915177; c=relaxed/simple;
	bh=8d8vMlcuqrcetGiukAccRMJhujaTPxUi42V0eQLoMBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XAYflDRDNjaAf4bMKvqCW25NFGWvvZBFryu0nKldHFJ7efUpxna9KxCPGJC/Kn1WuDWIyVHdpSW2QDAq0jhglWG7qCUwj/qfEghI/MycoCPLgx0jDTvzH/lR+++QMhO2DnF9G34NHfEDDpomQGsP1shzc+Q9517vfJ4zgQX0eVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lATfafbb; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lATfafbb"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37b97e59520so39890021fa.2
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 11:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765915174; x=1766519974; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKP3/pV9HL8rJ89JiBKTKQm/pSwijNbQxYatjpzb6Ao=;
        b=lATfafbb1Yj/okzmXJEgfTaDRo/9QhueWSzQxrMkEsYZqM+btxi7OdI89XFyyqv53/
         rinPnoUbexb9lhYJKu5rvlALG0ZBnWU8rm+kYUBZULrmfGEWTCeH5zB+CF+9mTl2jB65
         C/G/JoG+riKD3tRgzuMZaMLbACxPSpXErOUuV8FqDUDBdtqQXZhcbEZ5PqUMmYFF9gO5
         iVQ5Uf8/g/ow6weDxI3/Rieabe7DygMi4qbC1tJl/A9vehakcirVJT7mm1LKoLzmfRwE
         bIIWjTBgmYCIoPo1KW1oGoCb6EyYuDzAnozRyiSyPtf+Uh4/Ubl3XZ09RU3/aR78Bwuz
         su1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915174; x=1766519974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jKP3/pV9HL8rJ89JiBKTKQm/pSwijNbQxYatjpzb6Ao=;
        b=BclPkgf3bf5ZLxbd0BmKWNWwxAnoeB5VqTrXKNubxHfkhiAhjHyx5kY/5KLyRqYBzZ
         RWTmdb1rhoL35b8FQO85Zhdg+Lbm6K0N5bw2UrJB+EBfLKSD3E+8GpPaDXU6M/qmc539
         8rU1UzUlz7jXivP17WMvU/ID0CPZpT21NLWlmjnEINzHuRFjtnfo3E5jIWRVgpXSCBVr
         GHnEZtthrloULS8M0Ezyrt4YI1HE9pqP/aeZBq7YbNd5+MNuxdjM9Y9CcYhqsRvjAziv
         wobCl99POwIQ4KyNEMJL9vjq8muTXANX6MO2381ErMrfMOwpw50Od5wyMsekel4843ao
         fsAw==
X-Forwarded-Encrypted: i=1; AJvYcCUqJ2lNwJYmqsv+z6Dgj5elUtnn8heNFbm6J5bA8pDDe3xO20GTt0+ngU9zWZwLjsRGCKBstpgh@lists.linux.dev
X-Gm-Message-State: AOJu0Yw89oEjkOcJZvAOlEKqnHfNJXi/wIPzA0VnBs49SyQm5+FA0f7H
	F3kzkhVWxsrvbwDUhcD7vkOMMR7Zn9mrziB7tyoM/BcvkYQE9YiXE8fryaWOTO3ilLAEumUu5eL
	r4dYQKwVMCq32ZuBN9S29FnyUwvb/5f0=
X-Gm-Gg: AY/fxX7pisZHW1W2bxDWpFEFP7Vz31tzGKTyVZm4LI8Z/3OmgeqcjELBWG907dFaUvA
	99SFXYnMMVRcJGV35GUn9lzxKCh1dG+KYyfFSynmKCvUCDPX4auLMw2LzdDwjLflPlTWv7o8deQ
	cJ0KzlRYPkwp59/gkkkgc8xH1KQEbIX84jpgIlATVzVgOMNZ+Kw4UgmAkwMiGVXW16mp8OD5y5Z
	ZNkccB4ehHJTO5SRBX956o2u6LPdj/pRingLs5h7tAmpNvMRScpyyO4rajBWRArubrRe2mXI9Ch
	lbzs18jikIpVXV2proNI1V8jbTIF
X-Google-Smtp-Source: AGHT+IEoOwx2O+UDgb2f0yIKh4N1D7Pr3XV6xfDNke54zDaPEw72IJS4jRqNFlBTPI0ntktOfvWQhWxSFoYmzXQrTsg=
X-Received: by 2002:a05:651c:1c7:b0:37a:2b5d:e855 with SMTP id
 38308e7fff4ca-37fd08e94d1mr48591801fa.40.1765915173887; Tue, 16 Dec 2025
 11:59:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111947.723989795@linuxfoundation.org>
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 17 Dec 2025 01:29:22 +0530
X-Gm-Features: AQt7F2oW5vTlzd7FXzKICbt4nLS9t6NSWyDjk-BuP4m6qMC0a_yiDrofInRso24
Message-ID: <CAC-m1rq9fSvZf5cPy-zAj+vYk3=nODsfT4QL+rcuDeCdqbfctg@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
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

On Tue, Dec 16, 2025 at 6:40=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:18:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and Boot Report for 6.17.13-rc2

The kernel version 6.17.13 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.17.13
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit :

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
