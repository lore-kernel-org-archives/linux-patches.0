Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204D77E599
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 07:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709624673; cv=none; b=LdlRZqWGSdxt1U/IbjGI40PfTgtqJ5LTyrsEMCCuNd2x5aStJvxUosk9n2AF5anpKUlsjdva5l0w75w49t0f+y0r4PvhR+tKCxky+HoKX8tgToJtdGXP9qpS3J6pEjoJILwZEvaUYHYaXkfQftSXT1frTRdWmgfww6DirXDw29Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709624673; c=relaxed/simple;
	bh=BCQGFqrl9qAJiLjSxFHy/VDGRlS1Q7ZbEuhboWZ4S6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=liSGR6+JsBCEyPM3qiIyE/UCh2AkKuDg0H6AQ4PIJU21DmlzSjCHG+d7y9slcU7aQAtxiVeLUDgT7fEJBYnVtVr+6Ph9Y3An8K32/h16FjOgLLhwuq3dOTqT/ZBEnrOSTaQPWq81OnVpqQj+JJgPYWKrhXT+URiiCGrABUeGjZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SECGlyxs; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SECGlyxs"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-29aa91e173dso265930a91.0
        for <patches@lists.linux.dev>; Mon, 04 Mar 2024 23:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709624671; x=1710229471; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMd2OlEWfF0C6xL6a9NwH9s2DhRohxTw6+HDyEIrfVI=;
        b=SECGlyxsRRX2FZ3d98tro0whNlFAlXcfC7u3OBA40lm6gwxX8dByA45WOhBCQSxFhB
         rpdXUCdcSjlW4Bbou01yRDHfC+68BMngOok7Uyfuu9Q4jNhvyUOPE9L+3Q6cLphjHYFf
         XRIEi3Nr1B2hi9OhwwZCKYYULoXu0R8xdE0l627lhdeU06eX9brGkUAhJ9wdn8YE3Daq
         XZ7IQB29wJm2PFCmUecX/lZfF6/6v9UzuQwwp2IcqhUtmq10AJBwXlD8eD6hTcDWMgpl
         F2T1tq9OucdFXQL1DgK9qmme0oEeHnCQwN4Ou0e98i6q30DJ36DSacaApa8o+cd6EW0m
         3hJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709624671; x=1710229471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMd2OlEWfF0C6xL6a9NwH9s2DhRohxTw6+HDyEIrfVI=;
        b=Vtm+8Bo5FwCK50Mpi8A6RYGSxky9hU4zCfPp8fPKAGxdUfXBQKjOdVOq/krupKYAun
         oQgAOYA5nsjf4d2t5tJ8U1mGgBsxe69m/d1he0ulu7mMG8DrTm4KVhwu4fcbB5A66OGM
         uCvq3K1TqUGZOd96RfuB0zZWiCS3J8u+9LXTFPDsb/nU3to/LqevyjiG2BcldcWpltZm
         iGcyVmn1qOam2nuHsAuPcJ6lUkFDYhU/TqDKBVUwA/zOmaioWcPeNnBSXESCVXSq9kFN
         rZl9rL9N4XN+fGC1D+tgXHmLcBrbAb56my5kv3hBeIA3qzAxMLF+W7KItE9Sk3vHV53m
         O8ug==
X-Forwarded-Encrypted: i=1; AJvYcCWO7yQHKkRAxsioEjWQWEfrS6Qr1V615do+i2cJHpL+DrLgR8rcDWxNbUQS6yKieW4O9r+RDT2iCKOEXFDU2JOy1OEBr7o/Ug==
X-Gm-Message-State: AOJu0YyLEd3EVdt/Yy+Rf5IVTlqtr6hTzfHvG43lQCu59ja0hVWv3d+i
	GpfS1YMZwPVHAuOiwm8RYwDHz19AXYIVczzQKkfaYBDlpQXSwcD3b+KE/8OyovSUqtQt44Jgny3
	kImmTA7cAW4N82vnav5mukeLQqQ0=
X-Google-Smtp-Source: AGHT+IG2+qfdZr1nofkwlPclqBFT5xGc+hrjVZinMntd1h9imMZoywFZlWNRZV/8mQmYGVx+i3QwYJ1WuvFEUSzxJWI=
X-Received: by 2002:a17:90a:3907:b0:299:5b06:5814 with SMTP id
 y7-20020a17090a390700b002995b065814mr8213585pjb.40.1709624671459; Mon, 04 Mar
 2024 23:44:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211551.833500257@linuxfoundation.org> <dcc13107-8e7e-12c9-e9f0-d0fa96ea9c39@w6rz.net>
 <2024030538-affair-bristle-25d8@gregkh>
In-Reply-To: <2024030538-affair-bristle-25d8@gregkh>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 5 Mar 2024 08:44:18 +0100
Message-ID: <CADo9pHg4YfspsQNmLip_DEOeJb-RjSM3GaWQPeCXoZ-uyMdv3g@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/162] 6.7.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ron Economos <re@w6rz.net>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Den tis 5 mars 2024 kl 08:41 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> On Mon, Mar 04, 2024 at 03:31:00PM -0800, Ron Economos wrote:
> > On 3/4/24 1:21 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.7.9 release.
> > > There are 162 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.9-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The build fails on RISC-V RV64 with:
> >
> > arch/riscv/kernel/suspend.c: In function =E2=80=98suspend_save_csrs=E2=
=80=99:
> > arch/riscv/kernel/suspend.c:14:66: error: =E2=80=98RISCV_ISA_EXT_XLINUX=
ENVCFG=E2=80=99
> > undeclared (first use in this function); did you mean
> > =E2=80=98RISCV_ISA_EXT_ZIFENCEI=E2=80=99?
> >    14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id()=
,
> > RISCV_ISA_EXT_XLINUXENVCFG))
> > | ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > | RISCV_ISA_EXT_ZIFENCEI
> > arch/riscv/kernel/suspend.c:14:66: note: each undeclared identifier is
> > reported only once for each function it appears in
> > arch/riscv/kernel/suspend.c: In function =E2=80=98suspend_restore_csrs=
=E2=80=99:
> > arch/riscv/kernel/suspend.c:37:66: error: =E2=80=98RISCV_ISA_EXT_XLINUX=
ENVCFG=E2=80=99
> > undeclared (first use in this function); did you mean
> > =E2=80=98RISCV_ISA_EXT_ZIFENCEI=E2=80=99?
> >    37 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id()=
,
> > RISCV_ISA_EXT_XLINUXENVCFG))
> > | ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > | RISCV_ISA_EXT_ZIFENCEI
> > make[4]: *** [scripts/Makefile.build:243: arch/riscv/kernel/suspend.o] =
Error
> > 1
> > make[3]: *** [scripts/Makefile.build:480: arch/riscv/kernel] Error 2
> > make[2]: *** [scripts/Makefile.build:480: arch/riscv] Error 2
> >
> > The patch "riscv: Save/restore envcfg CSR during CPU suspend" (commit
> > 64e54f78d9f2dc30ac399a632922bb1fe036778a) requires patch "riscv: Add a
> > custom ISA extension for the [ms]envcfg CSR" (upstream commit
> > 4774848fef6041716a4883217eb75f6b10eb183b).
>
> Ah, that wasn't obvious, I've applied that pre-requsite patch now,
> needed to be done by-hand.  I'll push out a -rc2 in a bit with this fix
> in it, thanks for testing!
>
> greg k-h
>

Alright thanks for the info will test RC2 later today then
