Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BCB18B470
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 09:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731661661; cv=none; b=aCAH+ceFcD8fNQHPYC8WcPtHN0zYfwjqPGqXi75aUO/MIVKW/JU0TLTSPMMDBX2VAy1zf0H/GHH5O4i0ZO0D+VdXCkkroA10Bixz9S3rZ3lT3x+BPQE4+HDmfrw4TupsSDIGIW9qidBgjzucTzIXQd7yvcR5ufUNjcbilyqUzJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731661661; c=relaxed/simple;
	bh=LX2q62WYby1zXSo+OspoR6SQ4JOEQtEGQY1uhwAGwsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kSnDWfl3eMab/atWuv2TZZ7a3kKAmPigxRymGCFibTxE5eWOqPLprcDQD6z6FxNzLu24Z1EIzL4fyPPgj4tYzTkhlVqPIwEKWzmvt5HcC1yN6rhC+VE/9mjTSlDs0eAsRWbOBoLTZPu3SC31ujq20Zk/RuwqBw7V4U0/YFeVPk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=q9aMBp6c; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="q9aMBp6c"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71e49ad46b1so1231474b3a.1
        for <patches@lists.linux.dev>; Fri, 15 Nov 2024 01:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1731661658; x=1732266458; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/GGcDKwuNPpMFO6GIJo1U2NCmyHIGhmOInYHhaYUCk=;
        b=q9aMBp6cye7nyVggFPg+uCYXE5I1KrIozzM1stM4BNJXjhUiCM20orczxCwyYlr3b3
         QclZMOdAtYJfdIL4nkf4cyXYQqdt/QSOD3wJWhqjB/UxCi9mPEwfIGtxcmFpMbFKEuA4
         XiddZAumPUAQhj7REdu/DD00wjnPjj0tkh5to1irhuC5OI9s7nxtwu/0xaCN3qLflkR8
         QtGHxoHJnXvWnfljUKu2r70GOEI8pRB3u08nkMAkSDj38/RWjs+ojhpwcl3K22D4fdig
         qOBZyCJfELBGQIWsYf9bY3aFDPHRmzjPKNoi7J4+kbWEULUjB5qfqI8KA2nYoWCaHZ9O
         eojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731661658; x=1732266458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/GGcDKwuNPpMFO6GIJo1U2NCmyHIGhmOInYHhaYUCk=;
        b=LszqzCNEH4RNj7WtQalMwudl1yeCM1buohHoADwxJq8J9070ZpNYgvkm0oZNRoqXSu
         glvkMjFbc5Do7YDQghUoMw2jl9BYzZ2KWQHWDh1tPEZf3qB6BMU/p3ddq8kAfQxoms88
         1dEJU+Q9No2xDMsdT2efGkuYGL/gSv/YcNc3abdRkUEkuK2ArQZjbY6Vehd0W9o5dR9Z
         jSm4775LT/d0J6hEVHyFLD/xvLN9hnH4Urkm4W1zCX2PIGlP/xiDm2yrzxsEGHFWrU+r
         lpO9chdPE/LJ2u98Gs40zNuYY2NV3GF0I4tb1UvZOsD5320mqpZ8prngWZCisjkOTGfr
         ev3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbqvCT7I7ysRtXzy58AA1FXR0ePfijUJ/356SLtsJlwNdTtxRotXN+6OAGgJqqXtcrZssSMTXR@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7CjPlQyEExqNr5/SMFtzhupLpoiKEYmq/jb3KF+dxJI6+Fbr0
	UYwsWmuYy04W9d/q3cYdqDbCZzyoybQGfuu8MMETBHbi6IMLBcVgvqa2K+ldhSur4QKZr8GCHH5
	X8ec2Y1WEpvntaQbeRLCvEVBLp1zvLJoUs0WVyg==
X-Google-Smtp-Source: AGHT+IEipBAtaSO6qTco6CXlymxGLqUFgKpppjq1+DZHQLwOzlZTO2vDwCJPay9SltCtNZBs+tQmMU2jQDqrwF3BKco=
X-Received: by 2002:a05:6a00:188e:b0:71d:eb7d:20d5 with SMTP id
 d2e1a72fcca58-72476b96ccbmr2943756b3a.8.1731661657842; Fri, 15 Nov 2024
 01:07:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115063722.962047137@linuxfoundation.org>
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 15 Nov 2024 18:07:27 +0900
Message-ID: <CAKL4bV48qydBq=_LGWDHW=bYB5JPvKa=3Nwg1WZC_aU3Upf8Zw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
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

On Fri, Nov 15, 2024 at 3:51=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.62-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.62-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.62-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Fri Nov 15 17:47:19 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
