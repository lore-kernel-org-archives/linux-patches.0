Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578F95D753
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 11:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706010381; cv=none; b=qsbD/53obyzm3zXj3Mi3yWTq90nrGhTBGMKhE3xSGZTzGB0Grq/QvXKpp6FlEE4xeG6u3XJ5oqsq4E675XPYMyQQghH+TSKaEO1V6NwsVrSZ7WJlyC9EnZhahCTVo8Op1n/ey7TLHwhPFhdoZAUui2+HoKyxjwmIvUj62FT+lLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706010381; c=relaxed/simple;
	bh=u+vnMh0bDwsz8C9HM93KCNUrx9aKpW+7M6cJvDcuWDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hVWjt9CRpTogWwj0B7pLrUdYP5anaalAyeALYts5BNi6hl/HO+aHM6V4tLWiSOfP7CAwF51VB9cZ4Y5j4fQ6IdNpPCNBB7oOFMeV4QUAoJ90NAXOitGCSND2YtkOaPEEjdB8Pc9Zg8ZV/TWWHvtGpjSzlVrxv6p5DvSeAPzOjWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=nYV8X6mT; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="nYV8X6mT"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5cf1f4f6c3dso2018558a12.2
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 03:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1706010379; x=1706615179; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwSEZTvPmPib/iq3ufXx/1zhqV62G5jcQEWDJ/1dtko=;
        b=nYV8X6mTrCHLSrLr/7r5o2m7adr9rqsGh7yeBMOJm56oS9xwQEYtZrKVc5EMXBD5pq
         4RNCIrNm4vQ7E3x2IlqYd1YVDpoemh2e0OV7zz7AxG51sQ9Q6gfRxJF/DgT+gClYraki
         Qsd94/gt14UIuU56OYsCKeY4PaV9uS0IfKZnyZSdq2aqWEwzFq2E9WeyoPKRaXP0W89f
         e2F7RfSzvS5cqmS0eV9G3eF9EKXkh3oSzZEi5qwjuw48c3Llsooc6uT44/TrEvaY4wj9
         xygp2kw9DegS+XK6mYBrvHyewCCI9ZyS6QJjviJs8Aw5iMYR1NzSwwlf+hPXf4HGhCMr
         rwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706010379; x=1706615179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LwSEZTvPmPib/iq3ufXx/1zhqV62G5jcQEWDJ/1dtko=;
        b=M7T4Vlm4UO8d0VTuIsbgsb4t4Uuhkrj9GiG3yycUF82jz5Xkfto1nQ9EEVnvXznl59
         a4to+6smLQJc9+JD/DI2qnloWDsoxiLeZekyR6RioGPatoGiJ/svIi3iKGGIenF8zGaM
         3MJGWGvDJAJi6RSX56DdKYeC0EW9fCvjmmh/2PgC2cRsurNmH+LMgqoRDC3ryNgD0SU8
         0wcXxWtFsKIJoJAfOMMNxbSO9QBVVAJ2t1EYqdylCcHOHhyWQ3DPoQojR+2wF5I/uL+B
         tEmNZLq03tXS7TgSiRfFino1d4478tW52CtS/jRwBs8B/8ghf3KOacXnYBypwDFaRrOQ
         oiRQ==
X-Gm-Message-State: AOJu0YwpxW9NENqo40MN7GeuAmFvqo8U908/QMxA1PZZRwehdu8zOuYf
	CuPcT7Vrv1QyrnrO4p1kUB3oujfSoXTtj5s8VVTmD3W+olvWvEgNtloVZpKqzQk7uUKuWhGJ3Kt
	DyAHjpNQQhX+MP8uKocivq/BYN9wEa3Zc5Di16A==
X-Google-Smtp-Source: AGHT+IEACBp9H8QI1TqOIOZDLZgpEkwSJrj7m5dkRr4i9ZL9tXNUnb1GT+Fl2iLJmxsq+b68QpV00sU4bXL7cu2SlKk=
X-Received: by 2002:a17:90b:10f:b0:28d:f182:b85 with SMTP id
 p15-20020a17090b010f00b0028df1820b85mr2536584pjz.87.1706010379397; Tue, 23
 Jan 2024 03:46:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235812.238724226@linuxfoundation.org>
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 23 Jan 2024 20:46:08 +0900
Message-ID: <CAKL4bV55aK_qpQ-ubYKGrZ+=2tnr5zLqTgdaGuMUEVvNEe2w4Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/583] 6.6.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Jan 23, 2024 at 11:17=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.14 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.14-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.14-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Tue Jan 23 20:11:26 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
