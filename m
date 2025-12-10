Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691C21D5147
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 21:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765400552; cv=none; b=jyo1CHzfVn+MZGzgAYcUCe6Uy0RWo2fJjC2LG/GoizmaWTC2yRnB7I0zBOjRn/0ijiHFuPDAH6aKKfaEGyMQvsIRB3fsB6EraONxMrRhgIHzpCFcSIYATOWraBGRlO8eMfuGvFkihHpFO7FL49rgqUYqV7OKGomIeJy6UPbY7ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765400552; c=relaxed/simple;
	bh=bnsj608qcKuRX7D9T0qi0UTR0898IU4h+H1WOag+sD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=erDIe8LDIQJPjHZ+j4iMgSn1BIXqJ46f8FHSHQbc7CUUVXRPKlVNhB+/nhBOuBqBXIpYmRsU3XOd59M+CzLFIEr3KgHo1RmXZGwkJz+vShrQq6Mzg/GBwKI9n0o5H67O/FbyYjVYmR07wwgH0WzvBpqdoE+e5pSc32x8GIxtAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ED8DYXin; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ED8DYXin"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5958232f806so193258e87.0
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 13:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765400548; x=1766005348; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haIYg7KE0egTD4YFbfAK5E8Ks8h25fX2CGf27BHTDnU=;
        b=ED8DYXinUDFj4fYCjKeQMouSli1x2hWtRzQMMoL/JNx/SCrYJOR3waNAxKfnrJfSuh
         +3fJ8evkiRmYDhm2ITzwNdoetRIW45MApoHxC4CiXQsmWzLrI3maNckrmb5ejSNsCiYq
         G1DSk3UsM3sacKIKJ62g1PvXRmBZ1rjv5dhLz3TzbI3YW7zDqU45Yhlqk2eKyowoWkhy
         jYxpXkcFdpYiFwMAp8B9Hs7rZfxiN/UM7yPhDD0DMHWCaxiAYH366X0VmFkDp1DctHI1
         3PYDCvy/yzdEF6EwqG+uh3v3hrz3GwXGCG1RQG1c1HHR0t8/AUEqD1keJYy13hIeJxER
         BZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765400548; x=1766005348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=haIYg7KE0egTD4YFbfAK5E8Ks8h25fX2CGf27BHTDnU=;
        b=wEKOklgv+OvuJxQ1AqXPICmEBKYxKd/3OpZqG6Qs8QP3Z5WnKZGrU1nT637Tgp2dO8
         xtZBJ31elUGKcX4sHQNxKW1tVeeqhbBVP2jYw1nwg6J+KFkWmvbSwQnOgYpOv9vMtOMx
         MED1ylp756hWQhy5KeLI6Lv1C0tQpzMS0acDbcb0wpUP1LNAOfRYEzaWSVUiBstpFlPO
         Npuhkdl51T2iYKJubWKEy6lBUmsF9KRGalR6uPiBWT+Glu1d/ffr34C+5LVG8V4UqQmx
         BGv7pS0ATiosuwDybCsRMV/oKJYzuGrbab2KEvR0904EpXC8O8CTtvvXRjEk2r17NQLk
         zZKA==
X-Forwarded-Encrypted: i=1; AJvYcCVq754etge7tgXbrVTSYlkpxG1plN6GlHmmYcyQZCAGmK2eSZnz9pcKMwT1C9SrRuhio+x9DWF9@lists.linux.dev
X-Gm-Message-State: AOJu0YwEnV9DvSBmoEdpP1/9Tr1kX9hycrCgq43bSXIl1TDhS94pQj2j
	T+vdUEo+iUzP0Ow3SLWCSksZ1r3OO59FK+MFVL0TjWSyLbXvosxB+ZZJMn9R+NwXu0pH5rpvTQ+
	LXINlBDuI4wEE2XiV1HC9s+IO0xY/nF0=
X-Gm-Gg: AY/fxX5JXBBNBXEvWSrlZyJ/SNt+ChyzSJenfafVKvV59OWaNhLvAUDwxBXDb+stSuD
	JnuSbSyqgyj1bM6XXk9bUblvm4Ir/JR5CgXNIXocL+RVp71ExyGWUhl+pZafuBD7yJM4LJhoG4F
	uEHGb4BFhdPM5pPTHOc1BTX7h2nBw9uR5hhjLUNmplV+YISBCcwVCGeMyy8TgX1lmNKMVQq824y
	Dc7f/jGgC+hFskYyvE2HCzyRA4yvBFABJRVcumgdXwrt8ExT4HODG5WM7ykJzGZfU27DWkNdA==
X-Google-Smtp-Source: AGHT+IEAEguLLqdu/ojq5/wCiMInqb+jeMis84tJ3BDJ0H2ZwTI5Dd/msvltOu1A3dIMoe7uh+Qrn8LlFfLm6WanlFU=
X-Received: by 2002:a05:6512:e93:b0:590:6119:6b73 with SMTP id
 2adb3069b0e04-598ee50c38fmr1344362e87.48.1765400548093; Wed, 10 Dec 2025
 13:02:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072944.363788552@linuxfoundation.org> <4b1a256f-5d1d-489a-9c87-c38b4465a6bc@gmail.com>
In-Reply-To: <4b1a256f-5d1d-489a-9c87-c38b4465a6bc@gmail.com>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 11 Dec 2025 02:32:16 +0530
X-Gm-Features: AQt7F2qSIeNouKnAegFy2IqN363aZRc74HdkUV6qpoU_1C2Uw8csLLOY6YM4mSE
Message-ID: <CAC-m1rrLzwywf+6t31kJdfBXuz1fvu4PtyLA=G8V-+qh7RZRMw@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 1:12=E2=80=AFAM Florian Fainelli <f.fainelli@gmail.=
com> wrote:
>
> On 12/9/25 23:30, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.1 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 12 Dec 2025 07:29:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.1-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h

Build and Boot Report for 6.18.1-rc1

The kernel version 6.18.1 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.18.1
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : 7d4c06f4000feb509a90ba5eeb00be9839decb91

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
