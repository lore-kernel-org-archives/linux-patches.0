Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009911DED55
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739978149; cv=none; b=RceaK3dxCNAvjmSzbFXCbsfKTU0TC2olr1NLEdJDH17CIWoKtr8msqJOvY45913Vz8mwazxur++71cPEBpwE0n/9Vj6GfG2zRvg3drD5O/3FTmKVc63cTucrpiwX+pIycxFRAe//7BUK6Gy/9YPxkdLhOcduKk1n1r3XaxMDCyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739978149; c=relaxed/simple;
	bh=Iv6t7FRn2B5grw2+MtJh7t4h4IagAcD/o0AdA80NfQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T7CvM/sAUFdIjXLVvfqKdC3+ZavjrF1oGQ9n5dPwVQXf4zrO3jUejGVmnH/9r/J1OGpMRgPJQynhYKsoEbcHdMLk3JFNb9M3LQuB70QB1gA48TkXLmkjpqlcbpALnDZvSqqgCmnj6IOMFb/mZDp2PyB0mPzqMrirLw4x+mX9Elo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EaFUlCWg; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EaFUlCWg"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6e1b11859a7so32923366d6.1
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 07:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739978147; x=1740582947; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i4BufmELc/H5oLk6Se7bfRixYeydt1UGAVr8rJzEKPM=;
        b=EaFUlCWg9Yw/FNkP1kBnJgYiChWn8yw0sL3h45Vm/tlzLnYe8+olZBsYdhTKq5UMO2
         SngcNZAeUPX3CNL137XufDdRSd9cjFKgKX+nZ5hbcR5Slj5VP4JJ+Ye/DEi/uC99Ebmp
         WjiEdE+UBwOaLm7UPHPcz7x9gJl6D9uAKPkmYK4xaUr4xmX935on8q71xkJFVXeyIgeh
         89YYfGj6cDC6fKubALATWN2sHOrW6/Dfd2MDHYJIzfR0qrgsqaKYPXY6/z/H/IpD39vL
         FzKkGRYgZApV2sUyP3CVQaSbsM7JcNXcN8L9Cww7tMy2Ly4+pCX2D3gLFqHCP5vg77jK
         PbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739978147; x=1740582947;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i4BufmELc/H5oLk6Se7bfRixYeydt1UGAVr8rJzEKPM=;
        b=uIhW3GykkS0UMuwyo2Egy0LKOxr3YLnkdQ2IzMQTJXdTwkb8ApczlMNvpQmnQmCD7u
         ip8FLT9t+tVdj5L2GURNt1rMSayZgeVvL4mUglfiFpcjMwaudIijU1+MfR6kIxWi/CkW
         WZfnrgP95XxTyExXGooYr7Ki3X9zABoUGZSBF2ocafLtS2KXR0Ds9z0nFAqriJJQe/rJ
         Xs1hOmNLSMejPGqNawe4B5hhf9RKnbbqho0SvpzkY7LRT9T8JOBMiJx/wzM6ghckfndk
         4MiYgB/3JXrFD7tOH/wUR5Kq9kVPbKAcwblK6xeHiRqojbz/sNmTDiFIwFdeNXrSeRRr
         rv7w==
X-Forwarded-Encrypted: i=1; AJvYcCUQ8yC8w+4ugFKsWavD45jCkaF3T/vaAom/HJ8KIyrkrtQHY4Cm1E2hF12RfUT9EwxQHac2xIy+@lists.linux.dev
X-Gm-Message-State: AOJu0YzN13RJIpb1ZGsXEVmuwZQHsW3uVOTxbcasI3YItwia+DqrPTbe
	hUYPLCrQRv/u+r3irzRnBEsaaQXjpizSxqq0Zbr8EEsFbzLnCOdJG5pKoKIuRGoObJOvglHIsD+
	jrZLZAZPkvar15ebouoo9PQGpMFsMKlGIAwvlBw==
X-Gm-Gg: ASbGnctJA4r8jARKBZqgLPE3qmOfqjrmVYI4DXArM6o8dgCvviO/PdOSPEOpPHzG4mW
	bE1o6Wbu4cqPdckw8PVzHsyyo3YaAYdkFczU0H0weZfwMDHdgWUxlpGzMHQ76j1JbRTG2QiS4ml
	w=
X-Google-Smtp-Source: AGHT+IFOL53hLpR9huwVKcdEp9S5ol3K22XXCd3/mcd/L2bQqRKMnRbCt0AScL5oNtTya9R/VDI/ycGal6VHuQEUFVs=
X-Received: by 2002:a05:6214:1d2c:b0:6e6:5d61:4f01 with SMTP id
 6a1803df08f44-6e6974fc658mr68832166d6.8.1739978146707; Wed, 19 Feb 2025
 07:15:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250215075701.840225877@linuxfoundation.org> <CA+G9fYsBu8DOLEDQoGrdZmjwZKvz72tMmrVPnQSJLNMbefYymw@mail.gmail.com>
In-Reply-To: <CA+G9fYsBu8DOLEDQoGrdZmjwZKvz72tMmrVPnQSJLNMbefYymw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 19 Feb 2025 20:45:34 +0530
X-Gm-Features: AWEUYZmBriKaF0g7ZN6AKPL4WUNipNS0LvWaItl7Uel4aGCuiaCeYdtgGR_kvUY
Message-ID: <CA+G9fYugvbR5jJrOUHd==_h2MXKDfVjivRnaXxvwWL_dzBXdGw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Feb 2025 at 13:08, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Sat, 15 Feb 2025 at 13:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.14 release.
> > There are 418 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Mon, 17 Feb 2025 07:52:41 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc3.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regression on qemu-arm64, qemu-armv7 and qemu-x86-64 on 6.12.14-rc3
> We will investigate this and get back to you.
>
> Test regression: arm64, arm, x86 selftests: memfd: run_fuse_test.sh
>
> * fvp-aemva, kselftest-memfd
>   - memfd_run_fuse_test_sh
> * qemu-armv7, kselftest-memfd
>   - memfd_run_fuse_test_sh
> * qemu-arm64, kselftest-memfd
>   - memfd_run_fuse_test_sh
> * qemu-x86_64, kselftest-memfd
>   - memfd_run_fuse_test_sh
>
> # Test log
> selftests: memfd: run_fuse_test.sh
> ./fuse_mnt: error while loading shared libraries: libfuse.so.2: cannot
> open shared object file: No such file or directory
> not ok 2 selftests: memfd: run_fuse_test.sh  exit=127

We are installing libfuse2 in our rootfs to fix this at our end.

- Naresh
