Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B6A6341B
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 11:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712057572; cv=none; b=DF1GA4nearNSs9Q3krl/W3QBwuNyZpKITAYfxFwPVAYDbLE+l56NupctmCwb9XuWfXtIaNiIYSbxxUjz3+EHU5mfLh5zLQyVChFy8bvsLLnw/lyJF6ceDdAUBGMKXocnoLakkQlUM0NHjtHBiVv3yWnOWDWvFrs0yYeNGO74sAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712057572; c=relaxed/simple;
	bh=YRmGqypfvRqmg3mcQPuCwYHUt0Glp5uhzSXwBXtnwMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QMWQHWRBbobEvYGlx8ctCjGnMudTYfWLbdYI4fKROBQTzQh4ktNxvuav6emuP1lg8ORwX1fBZ7UNyQRTkBizNHw6XTt0fIMWJPnDsySiaBVXG9zX8B8N8Z9Sjwj1EdJtYNwfJ6Y/J2XcBjR4HBjp4A7DgtpIaaHX+tor0crr/2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Osj5uhk2; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Osj5uhk2"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2a2559fe607so489248a91.2
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 04:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1712057570; x=1712662370; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWJ1eWNsf3mDKXSgx9qyOAX+jE4gBs0xL5TwqXBogn4=;
        b=Osj5uhk2dFHfcCyQCpICZnsNYpjrtIiqsaYRkFAlp2G1ie4vlnAUflZXfT1nw83oZl
         lhGK8cyUuIxFb52+SxNeys7P3H1IPowZO2apXA/WGofl/z6hk0rVynEZp+dVlAbiOQ/k
         DV8h5uPVc+S+0pRbs/6vzuEzb3b+JXW9lIuIQG+/xTHbfo5ExVZGMx2UAYHbv76yW2LP
         yd/CVpv2nEVRD23VR4TLaogu+PcDyF6bS7AnryjjaVLEAhHOv2QGcuJ6xXqdrwQ972Do
         vwNlulPKod5yzb/1J2h1I7encc/34wavlvO2GzMdxiQRvH/GEs/i3arhmEyzLSkJkcSX
         5RWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712057570; x=1712662370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mWJ1eWNsf3mDKXSgx9qyOAX+jE4gBs0xL5TwqXBogn4=;
        b=sWxxmB4LoIsg07nh2iK6KuvxYGvqBe/UhJ/cGVng8GV0gMmA0fuS9d0WxU3QiT47QD
         pGk0PkkMPanVtuh8tUvzdPBPYgbTTUkg+f55i3hQxUoYNRSX2MezvEkI+TNQbav9CobU
         EjlXx3ozaHsZxv9utP0iYn4axDlxXoDGKOJaZ/uP0qfxK3Khwr10kxaPyNf7IUqSwcHg
         zvIpblhJ+JMnJ1xwhw3hjvvYXoVWdzBcZGV3Uk8v/WhMzWlNkj7jUv/7ev0Z6j0UFQcX
         vLAqp9g5wxR6ITKBZcINrJvR/tNl67XHvWTYzq7FWfhYuDbfFScHWWhk+h9TsGhWCIIw
         1wng==
X-Forwarded-Encrypted: i=1; AJvYcCWyBsbDjJKL3g0GbErN1pB5JV+LOr1woWJXG9+Fr7H95syV0sgLnWE6OSWJf8VoRIvFgzFkkCFz3TjQEZtqwiqwT02sFZEyRQ==
X-Gm-Message-State: AOJu0Yy+Ud5EuohQufSbJz4y43ez17VfDuTncbZaWnc5vtIOJ3VVCi31
	UnUPe4gtT8NOFUslfnwYoxh/yGqBl7U0og9lk4s+5RWfaY69MBtfzYwwPvM3J/FgRviYnE23XVo
	R2BL+3fNCTkxp+joSi883xqOxL0XQ/kr1i04GNA==
X-Google-Smtp-Source: AGHT+IHx7EUuj7nvRf9Fi4J4iGIeWWtS0WlmsxgcMUaOaz7SMmHrxBW5v4aSmkZaEIencF5agCUbDZwn4zRGfIEOf2I=
X-Received: by 2002:a17:90a:a092:b0:2a2:2dad:66a3 with SMTP id
 r18-20020a17090aa09200b002a22dad66a3mr6122871pjp.13.1712057570207; Tue, 02
 Apr 2024 04:32:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152547.867452742@linuxfoundation.org>
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 2 Apr 2024 20:32:39 +0900
Message-ID: <CAKL4bV4EQ0SMMCE2fYqovSm3PHThObmKHNJpaNSNOWKGP59CDg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/396] 6.6.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Apr 2, 2024 at 1:36=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.24 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.24-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.24-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.24-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Tue Apr  2 19:48:41 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
