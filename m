Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927B1133981
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736922; cv=none; b=Qa9wPA4eIkbb8B+LG3VkZGt27S0KtRRoCGe2ImsnwHvI5jw8o9k5pKUjA2Jxe57+0wFLFhRS10oLnSLoAJsZpfnKzlyOGdCpEatceNwblgUgozez6KM2J2npenjNhVxGFtCvNNRqG/s6CTS3cU0IrYTXgacIIRC8zd8dE2gSX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736922; c=relaxed/simple;
	bh=XaDAf89/uDA4n7xDi6aw4UHtLzFhOCr6g7gX8vmEAqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b5YXyrNluyOzNI+w7CM3q/J+mfXdenMKOe/4wGsLsIinHiNx3jbN/kjOUeQOL3BKlDA2qIL9F5P9c7gu+EGBeyqFdekeqYpSji2KwjdntRFhcO/TOm9wbT76DtoU1COi3a/wDPoBBDGobxol0vfzZO5Xq3GF9bPDb0Vv+NU1j9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRowLkZ7; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRowLkZ7"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dd41ed9b74so3337385ad.2
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 06:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709736920; x=1710341720; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G78MndKWFM+DYsygT2bBdMaWOBPhKkS5vi6PnsSzrjk=;
        b=BRowLkZ7ldBcTuAhD5OugCjm1zV/dYjb09cXL/PjpTsvfIPpIqcXH1xkmOX/dxNp4M
         petQ28S58w6gRmTPm2fkruAnL4FiyMsxa+tgxXcLSvKYzykaiEnkRQJ6ICW/q2hi9JyF
         QPe9XQdaOYFC/knnrvMkAJLBSbbobOPfp/aKY0mFI1pR4miKDvyGXD0Cyfw/EZTAM0Sr
         8//wDiINQVodc8ev0EQubsOQkDp89R7KsJy/Sw+glottnMnUkPeT7lMBKgF5wFIlabeL
         m/VJEXshusUAUjrFoo8f6Ghpx8fxtXvPmQ+AW4oaOe7tDP7AeYCkzOWwXLQj0M05n/mW
         pFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709736920; x=1710341720;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G78MndKWFM+DYsygT2bBdMaWOBPhKkS5vi6PnsSzrjk=;
        b=TGgcR+xqiNHYM9D+UNX4O/x55mbDloxoDUFsbwaXSshh4r082TWE51LvfQe0J2cCxs
         lgYz4J1pNybjiYVSntzTWE2ZXnnRACMF8AVAAEbk3PkwhHhSOzSGap9F1NHYCtoRYtum
         vNyKnexGVpmbG3dqlVsJczuU2ZEGZv+Ah/ig+u3S438d6TIzoB/Jd/6GYebhl9rupSf0
         AN8u2SQqhB8RF97GICyv456HjYfb6BZEkkA0gYUbCKRoG5sUzO5DsWAFI+gJ+0NkOvKF
         52wqS582rAwWCWUeAxdHuZNRZGedlL7JYFU6N+EiJSkd5H5DYCncgdnYy9swuAP8/RwV
         qwxA==
X-Forwarded-Encrypted: i=1; AJvYcCWq0G25ht7Nij6YEA3K6rM5T64spseqRiMmxVGGE5L9IGgHIWZ/Vb+rotaunWKRtJcSFuknfiErrqA9aXf3vGEm7jk3VDJl6g==
X-Gm-Message-State: AOJu0YwdmXs4A6Gt5cev6qbQ9MFAMgqYjqAJK/4Pksk7m+W5rTTgoosJ
	EggaU4+00Xf6mZftrdaX7+7tiyLvTuucQBSE4Vyxz5Fhsh7mh2Mnqmnnp4QmsGi04Tyk5Drp8ou
	oTEERqDC3fEmEibJTPFeq28M13E8=
X-Google-Smtp-Source: AGHT+IF3wcyAkHvZMzF9WcuiVVSj1V8rCwuDjIsG1zgOIc5nmnGmvau6gumyfzxT/W9FQweluiS847DbJEZzWhG9rZM=
X-Received: by 2002:a17:90a:fb81:b0:299:879a:7da7 with SMTP id
 cp1-20020a17090afb8100b00299879a7da7mr14069741pjb.34.1709736919930; Wed, 06
 Mar 2024 06:55:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305074649.580820283@linuxfoundation.org> <20240305-arson-panhandle-afa453ccb0aa@wendy>
 <1a9a5456-ea3f-8a30-d8db-f49269966e71@w6rz.net> <fc131a72-6421-ad75-44bd-5ab7761d1cc4@w6rz.net>
 <013ebb78-46df-0db7-d95e-51229273bd2c@w6rz.net> <2024030521-uncover-pushchair-e68c@gregkh>
In-Reply-To: <2024030521-uncover-pushchair-e68c@gregkh>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 6 Mar 2024 15:55:06 +0100
Message-ID: <CADo9pHhF-yaw_EgenkUt5Z6t9_TW9XroWeoeXVRquLQJfuO+FA@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/163] 6.7.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ron Economos <re@w6rz.net>, Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den tis 5 mars 2024 kl 12:38 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> On Tue, Mar 05, 2024 at 01:52:59AM -0800, Ron Economos wrote:
> > On 3/5/24 1:48 AM, Ron Economos wrote:
> > > On 3/5/24 1:27 AM, Ron Economos wrote:
> > > > On 3/5/24 12:31 AM, Conor Dooley wrote:
> > > > > On Tue, Mar 05, 2024 at 07:58:57AM +0000, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 6.7.9 release.
> > > > > > There are 163 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being
> > > > > > applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Thu, 07 Mar 2024 07:46:26 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > > >      riscv: Save/restore envcfg CSR during CPU suspend
> > > > > >
> > > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > > >      riscv: Add a custom ISA extension for the [ms]envcfg CSR
> > > > > I left a comment in response to the off-list email about this patch,
> > > > > I don't think it's gonna work as the number this custom extension has
> > > > > been given exceeds the max in 6.7/
> > > > >
> > > > > Cheers,
> > > > > Conor.
> > > > >
> > > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > > >      riscv: Fix enabling cbo.zero when running in M-mode
> > > >
> > > > Yeah, it doesn't work. Here's the new error:
> > > >
> > > > arch/riscv/kernel/cpufeature.c:180:9: error: implicit declaration of
> > > > function '__RISCV_ISA_EXT_SUPERSET'; did you mean
> > > > 'RISCV_ISA_EXT_SVPBMT'? [-Werror=implicit-function-declaration]
> > > >   180 |         __RISCV_ISA_EXT_SUPERSET(zicbom,
> > > > RISCV_ISA_EXT_ZICBOM, riscv_xlinuxenvcfg_exts),
> > > >       |         ^~~~~~~~~~~~~~~~~~~~~~~~
> > > >       |         RISCV_ISA_EXT_SVPBMT
> > > > arch/riscv/kernel/cpufeature.c:180:34: error: 'zicbom' undeclared
> > > > here (not in a function)
> > > >   180 |         __RISCV_ISA_EXT_SUPERSET(zicbom,
> > > > RISCV_ISA_EXT_ZICBOM, riscv_xlinuxenvcfg_exts),
> > > >       |                                  ^~~~~~
> > > > arch/riscv/kernel/cpufeature.c:181:34: error: 'zicboz' undeclared
> > > > here (not in a function)
> > > >   181 |         __RISCV_ISA_EXT_SUPERSET(zicboz,
> > > > RISCV_ISA_EXT_ZICBOZ, riscv_xlinuxenvcfg_exts),
> > > >       |                                  ^~~~~~
> > > > cc1: some warnings being treated as errors
> > > > make[4]: *** [scripts/Makefile.build:243:
> > > > arch/riscv/kernel/cpufeature.o] Error 1
> > > > make[3]: *** [scripts/Makefile.build:480: arch/riscv/kernel] Error 2
> > > > make[2]: *** [scripts/Makefile.build:480: arch/riscv] Error 2
> > > >
> > > >
> > > This depends on a much earlier patch, "riscv: add ISA extension parsing
> > > for vector crypto" (upstream commit
> > > aec3353963b8de889c3f1ab7cc8ba11e99626606).
> > >
> > > I think the best solution will be to revert all three patches.
> > >
> > > riscv: Save/restore envcfg CSR during CPU suspend
> > >
> > > riscv: Add a custom ISA extension for the [ms]envcfg CSR
> > >
> > > riscv: Fix enabling cbo.zero when running in M-mode
> > >
> > >
> > >
> > Sorry, "riscv: Fix enabling cbo.zero when running in M-mode" is okay. Just
> > the first two.
>
> Ok, will go drop both of them now and will push out a -rc3.
>
> thanks,
>
> greg k-h
>
