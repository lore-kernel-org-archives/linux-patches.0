Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C4626B2B3
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 06:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752044115; cv=none; b=rZqoIjMFDJCLMxoUa5PmpvWrMISu+y6ZQA2eYUStJuKlVO568tjJCSFg9gKC4T9+tX/bNpFkfbEK4MPTI1qiAD/3O0o1izmIhptfGQsGNnP48VzBA2oJsIv3O/Hfw9bFwD/mAoQt9hRCavUXlPqWZAjWdO7uixV9USmN6AmjL1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752044115; c=relaxed/simple;
	bh=Llz36kufN52xm0i4d8RFpEM5cFRnEKZ/vBmybKKThBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Un5foFa68YAVkKPIiJo7LPv7fckiy+ssCzUx+sgnlyn77WcnXd0fUe/C3nYGKvckv7E1QK5OoSC5AKuNkwVPK4bBCwSSxQ6Sc/ebY6Aw5wd3aywZEZ4hBXjgGSSLSIPMvipaOe6F3z+66CcrJo8t1hPakm4BuiY+eFHjhKZsHII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=qr0FC1kG; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="qr0FC1kG"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b391ca6146eso2809026a12.3
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 23:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1752044113; x=1752648913; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxSHhqCIu08V3Qwag9o38Kp5WRa0opkmxc/P0igOUiI=;
        b=qr0FC1kGGuhB8SsmIJihPbib4IBxjlac1KE9Fwq2xhdF5s4x+68LAw9ptN22b66Wsc
         QHONZNrENXwn7S6EnzBRx5oDBpCfEymOcnzAKKtwPsDMpDmITw/WnX4SIjzyJwkGoZ8N
         W1rDIIHymIwx0Mh2WKGSstg0kJUBV3D0ulBNKyOawkzPT3/XQFvnrhGWDy8ClgiHJtKm
         9Bl5HcjLZRM0DdDq1nEUmHWoOADc0+Vg59QHwiZRsx0D1/Y8zx5D5zOyqD44EQwWwfjo
         dtpOMi6JnLQzsWJwK7dZf/L2PJMW17yUsuEM97alhqTzl3/cYxAzLHGXR8U3P6tGtinT
         IyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752044113; x=1752648913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yxSHhqCIu08V3Qwag9o38Kp5WRa0opkmxc/P0igOUiI=;
        b=PXfJRqUmvHGZbqTWOh78FmrMTxrY7GZ1qfp2Wh583gmjKF/ZiEuXvqYST7wRw5VJ6I
         LjPuO2Z9iZ06UQYz5045TxfKjJQA5afKFoofCqCIQpKs0lV5ugnzOcC44FCILpkvFsLD
         pMNSwSYTfpiOPT88r5hptcEFWlh1ZwAOu1ZoKfs1Up9e9FV1jD/swYO4rWFU1XPr59jj
         26XdJci720b5N3gVtvjI4CgzsBU1QLzWWjDI6Ce0lzeNjFL2Z3r1opDwncpn4vkfNzNX
         C8PLTs0LctSAk3zhm11Aj55hBo1ozf2q5xwZGMise3yEKRI/zk/iHeHIGJRcwSW4B8XW
         +YqA==
X-Forwarded-Encrypted: i=1; AJvYcCWcYg0jumZXWYEL6r5E0D+VsCWkk/3NcLGE+ivpFGM9yuGYAAtdxkBjTw5XxSL9+PwGZY4AqxJ1@lists.linux.dev
X-Gm-Message-State: AOJu0YwjfuLYAwoK6L+F3LilXgKMZTudnMHU3FcTKU1Gnly+MXQVV61R
	LcR/G3n1PiuBAK4RojyAo+70VKIcLr4rXFbiZDl/s2cFaOHpv2NIGZAE0hmYQcdLQgo1lFId4dc
	O7jMzFH14vlGK+7uFfsrwEif3iT36YvbXXtjGEsjE5w==
X-Gm-Gg: ASbGncsj4dllGPmbtKsDhtaHzBhkU/S129UYr54yMr6LU08mmpFAXXXBuhpmjr6tjFe
	vbgt5NPFuVVU2Mx6nCjaZNA59QPVpAogYQOncREKuhBv8L6cxCZOHacILQeFMk1FehRkPFmNdgY
	5uf4j4csAdCyoGODFFPTW1IELCZT1D/FLa4ID8EpeBoPg=
X-Google-Smtp-Source: AGHT+IF5H0//doa2nKgKyMBFHav2Tca1UhHeZa/y5+70t9CTKpzojdZBrhFAhrvWQGEyl4cbrKijcS3La+7jkZmxDZ4=
X-Received: by 2002:a17:90b:510a:b0:313:f883:5d36 with SMTP id
 98e67ed59e1d1-31c2fcc389amr2109500a91.1.1752044112748; Tue, 08 Jul 2025
 23:55:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250708162236.549307806@linuxfoundation.org>
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 9 Jul 2025 15:54:55 +0900
X-Gm-Features: Ac12FXzuUaKQ0Ks2xEiZvI9ZcmwyTtrC1KBrVsD1P6JK2q27gyC7Ngbilk0Vh6g
Message-ID: <CAKL4bV5Q1eGnsOXbf2bL4kjcU8ZGn5W+bMPKsYzBNqp9OxY2xQ@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
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

On Wed, Jul 9, 2025 at 1:23=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.15.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.6-rc1rv-gb283c37b8f14
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Wed Jul  9 14:44:32 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
