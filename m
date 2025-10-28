Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34680333439
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 17:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671526; cv=none; b=lOJT5J01z74hR+aLjAmqTzS6jF3lYH2nGniNSfd4fixBMEd2E5dR261uzRgOGz+R8Cqi2A+XpjdgM7+Vg1oVcJcRqqUDRhuDSiI61hEO2kFG1b59UP0tsUokFnYq2kG6p/d08uiqlAP0n0MYm95r3oXpi1Tri55ozmMidGgSng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671526; c=relaxed/simple;
	bh=uRk8EwEwcOWT3u2NM1bPYXtYi7WeFHtlYV5DrUELKj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MIAMbsxfsbEtps+ZKzRS4Fc9pJhLxArEvVAr1LPCzN8Y8LrWYaBJH0qi+Yegyq+4s2ORK/udwmaU5Hfwj4WXbqK7jBUqj/+qXQX2QHK8pqEjYeoS2Hij6kINCVdJCRXLLIP9gFr0EFa2B19FiNEEx92sIwP6P6Td8GzdABK+DMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoaQuUU/; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoaQuUU/"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-57e8e67aa3eso132141e87.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 10:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761671523; x=1762276323; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3Pj3kvcN6aBQ6j/0SMZsas3fPFyjC2TU5uVuC6Co/U=;
        b=FoaQuUU/stPCN2vAZ8/Uk7Q+Zt3c6AEY4405e22G+o9ESdVIXXTSZj0xqCzSVnNuhW
         wKT5yN6oawP/DaTUMdzduA+T65x0AdskTn8KRmCBV7ox5H8ZZolLz6baxL7uK9+ji+MW
         eA2KlAvp5Akn7EBDyVBf3HU+fkzi4Oso5jKmu8jnhZNozaWHcBJwFVednzogplwhwoc+
         TCOEB6d03avEkfBu6x3/v7qthbpi7avc6cgBNXDukS8TmiELsFkSPMZImSqn34Z7C2SV
         XtSK2m2jmsDr3xzWui2RirZzdJJUL7XLebvEef63hQHw/KD05eNtnlIGSoRkxhUG+pK9
         owqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761671523; x=1762276323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3Pj3kvcN6aBQ6j/0SMZsas3fPFyjC2TU5uVuC6Co/U=;
        b=opr1U2RzK3eK2dOiJBDr78whrzogql7xclT6WCDN3/JgpqUZElC2tAoEaPeSHV7SCt
         dtt9XgiSRijcJX2f+p6Olr3K7nJnXnIsR5mkiBsf/m8UbAn0jn4FNNp+rJ0utnN+0YbO
         1c1YQH3dQTimvTvWT49ijYWtAa2TOJSwYitg02mwOqLqm0Bt+0k+Yyl8sxnKrluxo1YP
         weDOJ1bmKYD//WL7l0RqVSyvVjE6aQr4squw7R9LE7YoQDF35fDTnxyfSDdfa/wAQ3UN
         uQkOGHxcLSWneDhUdjr3u02P8lHsBPubsho4+ncscSWuIelsB9wMR+jlBjQzrJLPfUuu
         v7UA==
X-Forwarded-Encrypted: i=1; AJvYcCVCI+VFXjNyY1X5YsSpyDHwXhGp+AZLNy57gWNT6RAEHTESzbS/uydJ2QKPfoyXOz/AW/xebDaD@lists.linux.dev
X-Gm-Message-State: AOJu0YxiTeLZzQebGUrPaCi0m0YG4AojKKvpZye7agMYJa+blx7TRJdY
	D4t81ya400D63afEgZHKxevp5P0T3fft8bHWrQJQiLv212M25r8O9EH/Tqsq9YXZmGGwGC66OnP
	tNKENWhN9t5XlPrSW7BNnFZVyi5mgbMo=
X-Gm-Gg: ASbGncsL00hcWeBf/X+vemhbsaBoq6gRJ0a2kGoKrSuQuIomoBDIoFYywPuwPaTQvRE
	jYtquq4UwU7wXkqtTE7oaZAURmYukEU75DFxRuoGQy4HrILKpUZrJFS8T5E7a3yejK4azy/yOdy
	HleiIj1GsKhXe1Pz/TpGX1rhDb7skf8VnvKSS2DLHY/icdpgswqNHT7GkamsLkUp+tXoklR52Ik
	BLXKoWaNtI+RSIRn9+KHlc65dKL+GU4CmABi6azXfthVjPWPo1dMccCP1eTIU1H6Hu+W2Z216Uk
	1A7ygpt7F5J2sdoQ+A==
X-Google-Smtp-Source: AGHT+IFiHrUMwVmkTCLb9w5Mom04LhEQB7TPo2rlpYqTBqyrPAneD8NpZPc6wf+wC2DY8YSbv1v4z9OiFrCUDrWhegI=
X-Received: by 2002:a05:6512:2312:b0:55f:3f57:a64 with SMTP id
 2adb3069b0e04-5930edf7cf6mr1431299e87.18.1761671521998; Tue, 28 Oct 2025
 10:12:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183453.919157109@linuxfoundation.org>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 28 Oct 2025 22:41:49 +0530
X-Gm-Features: AWmQ_blC5Fm1cvehLp8Fe4c8zA-3g-SfayVM4q9tWXtt4kuTKi3hE7u8Q4HxCIM
Message-ID: <CAC-m1ro02LHYLz4-J_9_+XUOBs9YXRO9sAr+Otd4ddj6gxndog@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
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

Hii Greg..

On Tue, Oct 28, 2025 at 1:21=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.56-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report for 6.12.56-rc1

The kernel version 6.12.56-rc1 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.

Build Details :
Kernel Version: 6.12.56-rc1
Source: linux-stable-rc.git
Commit: 426f7f601ca06d40c899834021f62b7cf90894ca

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
