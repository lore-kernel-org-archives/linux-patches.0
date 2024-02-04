Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19247249E6
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707066419; cv=none; b=lim/b+CtO5/rRJMDIKEgnsPkqoSIgdnuZkhS9guiV6yThWSC3D7Z+PEwJNlekJX1PsdQ50E2LMHjhab7iP5qJYg0bIMadkH7lmcs1nIMmpoys5J0YIhGIDFP+f18sh8qzQad7nfXVR3iX58eVvpQjJyI/YxowOA/9BH3WwRX1RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707066419; c=relaxed/simple;
	bh=ByeceGA27Ixs+UrMZ4SRTFzcGbuGmGiLPFgcM7emWsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SCfvRzprrNg9x8zApA31fN5WfvebvH8o489s37sK7uGQg239AVstVbG3F8qWj5P3JRBA9pA4vP7RHY1KiN7ceqoG5PVATNJ95CP32gllgtsWmpRpTc+6rLUTgpDRcYhqdLA27FK2l1yD2Raqij0cDapnHqTYXqcgY7kyiTpXADo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zhw+tMdR; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zhw+tMdR"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4c01c53efe5so318176e0c.2
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 09:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707066417; x=1707671217; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fi4AuTTvC82QwungzGuHUs4Rd+GX71D+j2MK7Iqe+OU=;
        b=Zhw+tMdRbxszUnXqYJnBzYCPiKwoZfgwoofzmTZIB6UQyV/ooq0oEtvuDgSVFdlNtt
         0BTRo6mub3khRQa8wi8zlj8Zlv2tL2EWGby6gtVLfQ8OiFbOu0BS4trkwKqdhpu0QvKX
         I87szQxz1aOTXX9ngrdUeJrTf7NxEczGJCw7h4YnrrvvIb2SIoqZJZ0FqhZDMF29i2PG
         JZWO26y+s9EAalQj/VGDRt+rHPCWfJUOIR2sskrK8f0Jl9tRWcVF6fw9Jjw4LvpzjMNz
         q1FgLyUykmlwBil8iesRqLRk6tXkXYeE6QvpqU73pVFgAp2CYX6jHyGC/6CqJfVtu73p
         7oEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707066417; x=1707671217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fi4AuTTvC82QwungzGuHUs4Rd+GX71D+j2MK7Iqe+OU=;
        b=Wkre9GDWIiDVbWf7H5B9xXFAlBMF24JORPxfMLg2cdQ3wi0ebdURitf6VhE/85UXI8
         N0yp4yy41zNnE0XhzNIj9v+7QAZ2RFIpTfHIGv4y+qPXhfqvZA7siaGpz8Sy6SxYFGAs
         IYI4HUIObU6wFACOqpCReho4fxp1rfXI2LniNaU+9A+AMnYhIYHJt5kUQuHf6ZXIg588
         NjeXH/wKty2dntkSY/d9iBqX/cX2RIIyry9AXZhF/zoLSuMAIB2DRjiY+KoHLhawvPwt
         PHnQz1Nb17inaQp+NtGG1K2pd01AyJHvmpDmOZQ+vU5jMrovC/g4WMp0ljAdq8GDzYdq
         b2kw==
X-Gm-Message-State: AOJu0YyoIdYxdo4PoVSawYfWH+p/4LNUGZndysq3+hsKXcIYutN3myu+
	Ne7HCRLWt5Sq+IY3ceFDtpd7CrSDDEs4nBjiB2k4nONfNY0D0Ias93gmOGTcu5gPnNK7klHbsiL
	LMn2J5fWp5gK2xv/TTDCzucJKj078MPHjJoubIg==
X-Google-Smtp-Source: AGHT+IHU6gSbjHEb/W7OF52+o5q4BiVoPlZAYWZnplufKFHK468DFH7McRHN63v7vk8gRYVWC8JKd6ssMXUt4Wa6NWw=
X-Received: by 2002:a05:6122:2001:b0:4c0:2b39:dc86 with SMTP id
 l1-20020a056122200100b004c02b39dc86mr306387vkd.5.1707066415531; Sun, 04 Feb
 2024 09:06:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203174756.358721205@linuxfoundation.org> <CA+G9fYt2je2FKwdgm31isfxF2xm+HAZ-+vfwmiXhS2SpdBGLFw@mail.gmail.com>
In-Reply-To: <CA+G9fYt2je2FKwdgm31isfxF2xm+HAZ-+vfwmiXhS2SpdBGLFw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 4 Feb 2024 22:36:44 +0530
Message-ID: <CA+G9fYtf1Ui3Eb_inQbDuod=0hTx00cGXFJV19xKu+2epUASwg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/221] 6.1.77-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Feb 2024 at 22:27, Naresh Kamboju <naresh.kamboju@linaro.org> wro=
te:
>
> On Sat, 3 Feb 2024 at 23:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.77 release.
> > There are 221 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.1.77-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.
>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> NOTE:
> ----
> Following Powerpc defconfig clang nightly build errors noticed linux-6.7.=
y,
> linux-6.6.y, linux-6.1.y and Linux next-20240201 tag.
>
>   error: option '-msoft-float' cannot be specified with '-maltivec'
>   make[5]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] E=
rror 1
>
> We may have to wait for the following clang fix patch to get accepted
> into mainline
>  - https://lore.kernel.org/llvm/20240127-ppc-xor_vmx-drop-msoft-float-v1-=
1-f24140e81376@kernel.org/
>
>
> ## Build
> * kernel: 6.6.16-rc2
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-6.6.y
> * git commit: 8e1719211b07ef9172b231100722f54ffc23ed27
> * git describe: v6.6.15-327-g8e1719211b07
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6=
.15-327-g8e1719211b07

[ My apologies ]
Please ignore this 6.6.16-rc2 report on 6.1.77-rc2 review email.

- Naresh
