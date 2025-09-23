Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0172D660E
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 07:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758611369; cv=none; b=ljp9a1e6zcxNt59SUln1QD68GM3aL3QXtPZY+s2oPgM0PlhjiDgI7ZgYNl90PYWY6jU+ivQsbXtzaC2mv+nlJPRB3MB+CIV77TmjP1BWeZljpBcMu2fxBs+dVPgfbPY4UjRpE6ATVw2hsobwQ/xBPFA38IP3GDuqxpqwj552AU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758611369; c=relaxed/simple;
	bh=ysHSnboJ1VSr6jkBIcIUCwgVamK+FIg8Tw8ZKEJoTYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LHvZG27mHbtmnlOJRQf53/56iwy7H83NBXOkDCk4oeWySxes0934wZHajVYWGDrx245nQ0PgyQcZ1KYCDmwpMgQQ95TKKboHd/Ewc5IBST+2x6O4GXe9knnesKzJxUx6IG7+PkhTEy3Ghj4OyBjQRVlS6j1mVYZliCwSAtT0VE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Px/qgNhc; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Px/qgNhc"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b54c86f3fdfso4594864a12.1
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 00:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1758611367; x=1759216167; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WS/Hcgt6nxISZoclCG4XRiK7DJieVFaBpkh9uC8ETIk=;
        b=Px/qgNhcrZeFCnZ0Pd+nM2uTsi2hXNe0N1unHTXiw0Iz/KuNCpdnacRfVTntcsvO0Y
         sxdRf+hbNwYu7S/NZ5qWzIoQUUnCu1Mmc5EzAcpLrWsgeLKjBUem7aRtzs1RKxxTk3fW
         m6b/qci+tf+FFYvGPXrYG0IwpJsNkvDHt9jFlefzP973sJ+YuPcCWnBFyCYu8bV4h4uA
         snZt9d5tibyv21mQ2zlUJ6OnXu8aTFGquJv7nvC7xA15IN2SDqbZ+0hqR+9sa06OVvRW
         xoeNy6rLSpliqxU6EaQBO63yst2stBn0IXE9nkC3qgiWTCUr1IGImOMLEhphK+JtZCpT
         mFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758611367; x=1759216167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WS/Hcgt6nxISZoclCG4XRiK7DJieVFaBpkh9uC8ETIk=;
        b=vAa2VYOL0kWw7+IAgddR1yJRW8dgHer2TvMHSVELyDfNUPvV1m2x8cAIvtd1LcYPPq
         GpY3sQGvieWZGt/ljBhswgI76z8izDcEp0WjMDRkDkAtqzcGX/PW2sFbh39vXIPZaxgl
         21Up2e5w+fKjeRFLUvROolZvAS7cPWB7C5vF90mnpnKwMAGI5kobppwl2tK0uBDnEKwr
         i76V5yeLGsIeJA2GFhJfFyM4V1UNMf1VtbyrHPEGTucawU4hDzkAm9eJp3ox8avLBi/e
         Ha3gqql/9OpCGu9wsgaFH/TBKyYigwIV4yCMsfzo27+MlF/Jh3u3rKW86A3KUZB2Gq9W
         qpJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbWA5GXw9kQXVJ+qq4c4pg80My08OqXjCYHkAaBIuUFogqiwQItkTDI7GDrU8C9tazONFVRnCf@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0idZsEdJLRVZ7U9whZQW3shlIVphFKx3SUDWnm8gjAizicJEr
	XXgvOfOzDW4FoDPIts3EFZuqXCcJ+I5bjD1ks8zfc1EG4PbvnHGOD6m0DMDvw4ZaiCF2/Xq1a8d
	ffthEJm9Rj91ov3glRbta6n1dxxcmjD3UwyKtj6RVJQ==
X-Gm-Gg: ASbGnctRz0sYabb7G7npHIw17Uzj+OUq8w0RkEOTg0PWi1F6kRetBJLPFySJ6cCx5ZR
	AmumxuLYWqFzCmnMqTjs8ay9Yek7QSJVXqVjE8DGGHEDM/XTCc18ojR5n7Osbm1QPu+uf8WYBDM
	hnMUTWtlBFJgyiX38J7i9o3Guk1eKfR4fyXQHdZPbJ+qW2q5D4MOlFuctOk7ck5n38H+GObjNMz
	f6ySc77
X-Google-Smtp-Source: AGHT+IEgoLb6RErKTnJ5NIZWIJLVpqUBP5g71PH2B1xh1MeH1Fl+3zcfHUqPKMdNb0NwcitDlAsWFhiPjv2M7Hdy56I=
X-Received: by 2002:a17:90b:4f45:b0:32e:64ed:c20a with SMTP id
 98e67ed59e1d1-332ab42e4c4mr2037223a91.0.1758611367438; Tue, 23 Sep 2025
 00:09:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250922192412.885919229@linuxfoundation.org>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 23 Sep 2025 16:09:10 +0900
X-Gm-Features: AS18NWAU1ht66y9EVnhyxXlwR9JHytYi8_B10g0jSKv9pePNQntsZc8-dhugOu0
Message-ID: <CAKL4bV7Z+Kf=gDvmxL27hV4P8aHqYhOm+n3gU-WoAxESY-dNQg@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Sep 23, 2025 at 4:42=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.16.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.9-rc1rv-gfef8d1e3eca6
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Tue Sep 23 15:36:05 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
