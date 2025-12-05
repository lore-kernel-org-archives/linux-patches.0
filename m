Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A76A1F4CB3
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764951588; cv=none; b=IfbExd1T6fjfIm735CDQ2f5nMOmyYWGKSgwv3qjWj9ehs6UHvT0nmoAjuepBaEsmEKu9NLfoqEYSa6fkTlJb0ZgMr3YYi8wTKWw+LoQAu7CAGCUBdbr6irpT07pXNntMZ8ylkfgjgphTPubB+p8R21KZnyVpAp3Yhvuxt/m3K0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764951588; c=relaxed/simple;
	bh=hDMbzfmENdHfWL79AM2kPjpbwBhLSdqhPtR6U4xOajM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cWQIhmxnyopQqA2lT/7K2GDTnKibU08b30uRSdYQ3HxCofZZzW/FlrG6rqVG1Mtq7bv/fKNCCspwR5p6L4Zxi5lxe+EZZIQUClUWZP5jE1wCTrOlTshisSuXsN/iPbrxU69WcMnpb9/0DUR6Z3OAjy+h8WaQKTpRyBwYz3tLNbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=luBL/tDI; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="luBL/tDI"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so501434166b.3
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 08:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1764951581; x=1765556381; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DAbqYtjoS1Tqer4NnfEvoEpU3/4o6IX/rjsldncYrIg=;
        b=luBL/tDI3vQrXc1ZOXqU7mOoPJ3ZR6+WEvYRzoQspBYUamAqbkoDv6ihuDW0pDg+ui
         mo3rkNH4DxgKFA+KgcfBRLeyVDvE60JqJbct0rLjqqsvp+o9iOmbUeB2X7qRmcCR5mDm
         Jm8DHk0/HGl4ZABeQ3L9qixYh1JPbqIYbt0mCj3ZpiXqlFNdKrMwZn9yGGgDRYo2H8OV
         PCpkC/AeBhvi0CyPoDK5x52wGi+lB6QjTQFcTYFuQwRLF88UEkdBGNcFgw5SDMLY7BTt
         D2PiWn+fYYTalDu4mXrlmQI439pIzCtDSBA5ZRbFQ3oAKgFlCNh+BvLO/SeP8xTvriEf
         Ucww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764951581; x=1765556381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DAbqYtjoS1Tqer4NnfEvoEpU3/4o6IX/rjsldncYrIg=;
        b=g/IwXTgk9U7dtdXCsovyendWkJSzfSqFzV7g68CwmG61HMSX7Rrb4BqJUC96MqJ9Yu
         y0RLgIZEv0SeFhfRMSlPrjGax/Cay8AU+GVfg15UH2BbFkfE1iHL5wQBTmJ0DIqYPTKk
         WGc7+giHW2FKKMSN9sQGZNKwUWRyHcxiFzZ5y/j/Z4FsZXImrVLiQzlD+i/kJdIH6yl2
         UgD3t3tGmVYA956yGSdcTpqDXRKLpFVqwCkDDheXwuKRIfcHfy+BLImCrh0HHk7S0/Mu
         VEJ1R37oONtrechj8uuXRtlYJe2LY0tMh2x7AEMJoJZTHyEV6vS3RWj6g1WMzFAtvzIT
         mb8A==
X-Forwarded-Encrypted: i=1; AJvYcCXBzhfW51/EsOECWRtotAw9vL7RRcKJds01La3ivcpWdhbLS54uxN8VG4C4uvFTmlQnAoNDfeS1@lists.linux.dev
X-Gm-Message-State: AOJu0YzfcfbkeywzuQAXdM2pAPhpvQKh4homdMmZ5xeHoN1wbziu6/Ot
	rQ3Fo0L0WjihtMrEmkN3I9aLuriQeV4GpKY3IHC6dTgDs+kyMfDKChXFCM2ekjPb+Kiql85ABXN
	s6e/HTn1o7OWeFGre+dGY024gfxf3oSEW33HatACMAw==
X-Gm-Gg: ASbGnctAd2Wm4oKKzSOn2moXEKVWteiKBP7gJMSaAonKJ70kFYy7ass1DoOLk7tnna+
	FhyGHVaCIpXhPtmc/wXKaPWO1ih/7gdmIr0iztONfmZXyCy3MpU4oHroOj+rMGrMc8pCJI+5n+m
	opB8+lYJIbflSkBZ6LH330OTR7H3xRZTUjFdrkLQU3uStYLxrGDznsEPipkgvqPsvwX1X1AGO1i
	aThgFyGGk5pCC8ak9koUkzw3h9ETEKf+cWK9i4Wj4XXB6ie64befSBr8kc/3KL5FwhYIug=
X-Google-Smtp-Source: AGHT+IHwYlHgHLDk6t0DAeyZR6wuIa1pzzye0g91Dzw8CXF4QIhSiYZYQhtr31uSprLcgsbZQVlfF/dGe1kN6wqxzeY=
X-Received: by 2002:a17:907:8694:b0:b76:8077:4eaa with SMTP id
 a640c23a62f3a-b79dbe49c0bmr1122346866b.6.1764951581403; Fri, 05 Dec 2025
 08:19:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152346.456176474@linuxfoundation.org> <CAG=yYw=7i7O7nLLDQ5hdP03wHFSQ04QEXtP8dX-2ytBmiJWsaw@mail.gmail.com>
 <2025120413-impotence-cornfield-16aa@gregkh> <CAG=yYwkbpW8KG8ks9QGfOroV44sishtjFwvhnxBpD9O2en+7Ng@mail.gmail.com>
 <F776C81D-B1E8-403D-848D-1C6A189E6740@sladewatkins.com>
In-Reply-To: <F776C81D-B1E8-403D-848D-1C6A189E6740@sladewatkins.com>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 5 Dec 2025 21:49:03 +0530
X-Gm-Features: AWmQ_bkXtUvbLDIW8AM_8JgOiORNeZ5xJPz9MSTKCVysh3B10mLS_p-LNes_9y0
Message-ID: <CAG=yYwkuemRE+66q9+5g8=yPZHWrfEFDk3Aa1sWnMwkuHe0Vhw@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
To: Slade Watkins <sr@sladewatkins.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 5:41=E2=80=AFPM Slade Watkins <sr@sladewatkins.com> =
wrote:
>
>
>
> On December 5, 2025 6:51:36 AM EST, Jeffrin Thalakkottoor <jeffrin@rajagi=
ritech.edu.in> wrote:
> >On Thu, Dec 4, 2025 at 9:46=E2=80=AFPM Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> wrote:
> >>
> >> On Thu, Dec 04, 2025 at 02:38:10PM +0530, Jeffrin Thalakkottoor wrote:
> >> >  hello
> >> >
> >> > Compiled and booted  6.17.11-rc1+
> >> >
> >> > dmesg shows err and warn
> >>
> >> Are these new from 6.17.10?  if so, can you bisect to find the offendi=
ng
> >> commit?
> >>
> >> thanks,
> >>
> >> greg k-h
> >
> >hello
> >
> >6.17.10 has the same dmesg err  and  warn .
> >
>
> Hey Jeffrin,
>
> Can you please bisect and find the offending commit? We'd love to figure =
this out, but can't do much of anything with no information from you.
>
> Reading your previous emails on this, it seems like you're using a differ=
ent machine. Have you run this on your usual machine to see if it builds?

compiled and booted 6.17.11-rc1 on my laptop (typical usual machine)
no typical errors and  typical warnings .
so the error has something to do with my Desktop
one thing i want to say is that  my onboard graphics is connected to a vga =
port
which is converted to hdmi using a converter. video=3DVGA-1:1366x768@144.

--------my desktop ------------------
jeffrin@debian:~/kernel/linux-stable-rc$ sudo dmesg -l debug
[sudo] password for jeffrin:
[    0.000000] e820: remove [mem 0xff000000-0xffffffff] reserved
[    0.001421] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.001425] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.001653] e820: update [mem 0x9f800000-0xffffffff] usable =3D=3D> rese=
rved
[    0.025796] pcpu-alloc: s212992 r8192 d28672 u1048576 alloc=3D1*2097152
[    0.025799] pcpu-alloc: [0] 0 1
[    0.361824] PCI: pci_cache_line_size set to 64 bytes
[    0.361824] e820: reserve RAM buffer [mem 0x9e5e4000-0x9fffffff]
[    0.361824] e820: reserve RAM buffer [mem 0x9eeb7000-0x9fffffff]
[    0.361824] e820: reserve RAM buffer [mem 0x9f4d3000-0x9fffffff]
[    0.361824] e820: reserve RAM buffer [mem 0x9f800000-0x9fffffff]
[    0.361824] e820: reserve RAM buffer [mem 0x23f000000-0x23fffffff]
[    0.364954] pnp 00:06: [dma 0 disabled]
[    1.132492]   with arguments:
[    1.132494]     /init
[    1.132496]   with environment:
[    1.132498]     HOME=3D/
[    1.132500]     TERM=3Dlinux
[    2.382115] QUIRK: Enable AMD PLL fix
[    2.560086] libata version 3.00 loaded.
[    3.420789] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.648703] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   34.329828] PM: Image not found (code -22)
[   49.778876] rfkill: input handler disabled
[   61.785074] rfkill: input handler enabled
jeffrin@debian:~/kernel/linux-stable-rc$
-------------------my desktop---------------------

i have to find a kernel that  works without  the given err and warn related

please explain to me how to do git bisect with two sources( kernel x
and kernel y)






--
software engineer
rajagiri school of engineering and technology
