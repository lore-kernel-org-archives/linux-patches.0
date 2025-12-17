Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4933B1E520C
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765994737; cv=none; b=EzQvZl72vco+wb1RsiCL/HholwZM8KxFf+19+PIjSk/vrqF+sN8W0CRWC920xDSUzO3hLjjMyPntMEhKhLzvuTZj7p2ESSuYjI3cwy5S4MD8WqPC4X6kpNJqDHTokVMSqDQV14y4eToFNbnPRQaSyDy+tD6A/kj2hh888hgE+P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765994737; c=relaxed/simple;
	bh=p1cvpTX5RLoAO8HeSmuv2dfbdIEinYB2dnMfMZOY2Xk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2m5uXrfIInzsXV5One5dOlJNCqAS0XuezHWi6ImoK2LxBl5iNg6X3sEglL6j5kmoP5HzZLEw2UtluBPvaqX3ewJOiucZjhDbSDB4xKwqkN0yXdr/Dh0cM4yussdpjWqeg1Ftm9Syiy5J6PjCcoMw0caaQHlGLV0563jKSur/wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=BGRR8SZR; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="BGRR8SZR"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79ea617f55so633961366b.3
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 10:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765994733; x=1766599533; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uNbYUFZZYG5LLhuFezjR0F4Hdhz6rQmi452cio67adk=;
        b=BGRR8SZRR1VgKjp4h/zvECmZAFfCBbr7xrGimAZNawiKSQzsrPmaR09tyRohXRLD7r
         ntBJ4mGzzjn38z6bv4HiNzLF7409Ofdm7e3wdHKVvgmqsurGsGttggK6ANSxxzPLGEAg
         ApmFVAqZvAf7g5OCJcshTN8IT+wqfWlDugJkh+nVGiROP8qQzdilsoMpe6ArRGXKJjfu
         4ijQt9adGGW91VhA2aEJjFaYcZYOLVu3q5ZQBXKYHGX3ZsSGG5MkZ1Wnm+DizRsK6cqa
         X1ZqwzMo4Io36uomy/KNirtWgRmItoKEwvq0npf0RHGWhT3o7vEy5JBDkYEZhkVrrbgC
         BwMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765994733; x=1766599533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uNbYUFZZYG5LLhuFezjR0F4Hdhz6rQmi452cio67adk=;
        b=Yq1ibe5ru6UKfcspSBiuc7AhN7iR6lA3pI+z85WLkgsyTBpezA4J/MJ6ohGhnLHedn
         5iflsCUUkFh1cPcmjGQlIRgkQvceDncEzS+rMCDzRGT8f/BxrAAXUv12MDfOrNoCwwXm
         GrhNhRvR5D8WQkHIL9oR+lok+Nwj5vkpkv47L9GNQDELc5YKYXom9qPQnaJuw3FFUxCL
         RkxaHHtMj35/CeEW2Jv65BBEeyVZ8cEQ1Js3vixb9FnAEYwsDwYDEnrTBsNt6FHPJvwI
         j/+bL46H9LhMsXPlVYkXbhAvoRhXckY/IjeY9UW0HY5CjEBafoLRa0RyeDytIa8GO1M7
         nZCA==
X-Forwarded-Encrypted: i=1; AJvYcCXYAmJnt5RgvmMBvWIMsypZPxdncpFAILEZkhYJXFFfcXzGopp0Q/USPIwJNVvyhRW7etcck7z0@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2l4huTUgSJQzK07JZ2kb4uwvuL+XTKPLYYUFZAKxQLSatM1zy
	DJIK3T5zkaSYYRheItB/DxnM29T2/Qb7/ckaACrEKnJ94A3mMBelgF2jSoBNZdND1KgJxsQ7eAh
	M8Y7KNhVQhcWTg6Hi4xa7OkvgKJE18g3WMI4ScQu0GQ==
X-Gm-Gg: AY/fxX4Cz9+tMJsjYupydTKju6m6WD++Nu5BsaOx+gA7hQG6BMPcdUfZj+LcjvI17fA
	JKcUloO7zx8T/VE3hWExMNmRnLwPAy8XZpBaavFbFQNvCLD+yNeu2reNTYf4TYMG+BbgaMjQuxF
	bWZi4hjMXdyhh1beJWtdmIFXperF18//9b35nvzPD1gtLbOS1PcR65aRqgBey+BxRenXxapZP0w
	e5vZIBjUomQ8Dd+nwaelYHoTcIxUxB8cQ5QMeO8nx8lZxDhDCr0uC+xFP8lFam1fSTTBSt/skI5
	sX8RUw==
X-Google-Smtp-Source: AGHT+IFrXPT5pcsN4U9JlCw3uDxBO5Lgj2D0BJHK4Sibf7pThlYmGH7eHfZlo4QOetU1br00xeRdHfxUZK63kQf3PlY=
X-Received: by 2002:a17:907:9411:b0:b76:74b6:dbf8 with SMTP id
 a640c23a62f3a-b7d236af43amr1989150966b.14.1765994733369; Wed, 17 Dec 2025
 10:05:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111947.723989795@linuxfoundation.org> <CAG=yYwnv+EsEhOSUFFFGQYm6MXzDFzPKq=pp+wk2J5rvLupoQQ@mail.gmail.com>
 <CAG=yYwkuq=WCGMqYcuWh5eHuVY5rUFWRtbZKgcUb1Eg1GxgM3w@mail.gmail.com> <2025121746-hardcopy-curry-5e02@gregkh>
In-Reply-To: <2025121746-hardcopy-curry-5e02@gregkh>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 17 Dec 2025 23:34:55 +0530
X-Gm-Features: AQt7F2o6K-RhZYV1UO-lRzII2PWuZegpdTnwtoiI-vNUJHGfd8UCWzLlPz6azE4
Message-ID: <CAG=yYwmY7_iqUTG9m1yPyaSNFqMTsNCTz-Yx=H6=rU_HeXxygg@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
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

On Wed, Dec 17, 2025 at 8:34=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 17, 2025 at 08:24:15PM +0530, Jeffrin Thalakkottoor wrote:
> > On Wed, Dec 17, 2025 at 1:09=E2=80=AFPM Jeffrin Thalakkottoor
> > <jeffrin@rajagiritech.edu.in> wrote:
> > >
> > > hello
> > >
> > > Compiled and booted  6.17.13-rc2+
> > >
> > > dmesg shows error...  file attached
> > >
> > > As per dmidecode command.
> > > Version: AMD Ryzen 3 3250U with Radeon Graphics
> > >
> > > Processor Information
> > >         Socket Designation: FP5
> > >         Type: Central Processor
> > >         Family: Zen
> > >         Manufacturer: Advanced Micro Devices, Inc.
> > >         ID: 81 0F 81 00 FF FB 8B 17
> > >         Signature: Family 23, Model 24, Stepping 1
> > >
> > > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> >
> > i  have done a  git bisect  and the log is attached.
> > THANKS
> >
> >
> > --
> > software engineer
> > rajagiri school of engineering and technology
>
> > git bisect start
> > # status: waiting for both good and bad commits
> > # bad: [f89c72a532b507111acfe1b83ff4855dc6772043] Linux 6.17.13-rc2
> > git bisect bad f89c72a532b507111acfe1b83ff4855dc6772043
> > # status: waiting for good commit(s), bad commit known
> > # good: [6fedb515e7f90986da3de36a35752e6dc2e0c911] Linux 6.17.12
> > git bisect good 6fedb515e7f90986da3de36a35752e6dc2e0c911
> > # good: [6fedb515e7f90986da3de36a35752e6dc2e0c911] Linux 6.17.12
> > git bisect good 6fedb515e7f90986da3de36a35752e6dc2e0c911
> > # good: [bef2390379e56d44e5fed5400bba2f6c2486cd6c] tracefs: fix a leak =
in eventfs_create_events_dir()
> > git bisect good bef2390379e56d44e5fed5400bba2f6c2486cd6c
> > # good: [16be45fa274beefba34a25da3551276b9fb48382] vhost: Fix kthread w=
orker cgroup failure handling
> > git bisect good 16be45fa274beefba34a25da3551276b9fb48382
> > # good: [3e619964439334c23c079ff3986fd62d94d8c842] NFS: Initialise veri=
fiers for visible dentries in _nfs4_open_and_get_state
> > git bisect good 3e619964439334c23c079ff3986fd62d94d8c842
> > # good: [9786c2e58c42de159067fa3ae7a5b1e029bdcab1] rtc: gamecube: Check=
 the return value of ioremap()
> > git bisect good 9786c2e58c42de159067fa3ae7a5b1e029bdcab1
> > # good: [96b48878043620b06e74f5e435f0caf16105db8d] scsi: imm: Fix use-a=
fter-free bug caused by unfinished delayed work
> > git bisect good 96b48878043620b06e74f5e435f0caf16105db8d
> > # good: [299f05075dfe002156bbc46ba7da2a89357fe94f] usb: phy: Initialize=
 struct usb_phy list_head
> > git bisect good 299f05075dfe002156bbc46ba7da2a89357fe94f
> > # good: [0ecfb458bae89e7cc2ceca578405a014a7090c33] ALSA: hda/realtek: A=
dd match for ASUS Xbox Ally projects
> > git bisect good 0ecfb458bae89e7cc2ceca578405a014a7090c33
> > # good: [25b1100cb9ff0dcbd7263ab57fcede673be0ecc4] ALSA: hda: cs35l41: =
Fix NULL pointer dereference in cs35l41_hda_read_acpi()
> > git bisect good 25b1100cb9ff0dcbd7263ab57fcede673be0ecc4
> > # good: [5f0bc5d1d892e7bd28dab743c9e8dce2b6596fbc] ALSA: wavefront: Fix=
 integer overflow in sample size validation
> > git bisect good 5f0bc5d1d892e7bd28dab743c9e8dce2b6596fbc
> > # first bad commit: [f89c72a532b507111acfe1b83ff4855dc6772043] Linux 6.=
17.13-rc2
>
> So the change that sets the makefile is the bad commit?  I don't think
> the testing went correct for some reason :(
>
>

Actually i think that  the problem was with my kernel config and
during the test process
i was requested to  at least  change the config if i wanted . I
accepted the default values.
I booted with the new configuration  and dmesg -l err was clean.THANKS
for helping me :)




--=20
software engineer
rajagiri school of engineering and technology
