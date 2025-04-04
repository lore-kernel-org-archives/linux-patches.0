Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2FB1EF09A
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 13:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773311; cv=none; b=kpUXqYAn8SmldG/aaWTiuCCtyiApjtnrH7HZP3UwswvkHYBts18/sFMtsAVKn3tahZehRZldQFmo/GkN+BR47HiXvO3W+p4fJNf/uuNBgwd9zwLGu/meu24TlzHPEPoN7ZoxjS9Lz7QQBwYR2cZRY/+mBlFrgnukk9oaacEslvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773311; c=relaxed/simple;
	bh=8am3I0YCErYUO2PgNgYpMqXVi36aEv+QHl9QuGEDE0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fYU9xxP4GFbH3j1/bPZK5YEVrCu4N6cZ7xUn7SE3yLwXhCYKQHbmmhno3wmPNDEy3HlDYcWJYA1pSQdAAWhFtW31+hRY9uRW0m204O+nSKvHuaFzBdBoEccawIkKKWLE7ULdxOLbsxgK83RNYCd61kRCDP5uSHb+jYXvnPQVyac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbIhFUJo; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbIhFUJo"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-301493f461eso1496947a91.3
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 06:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743773308; x=1744378108; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L1EvrIpOY5/BQY+g5/bXbxzle3Uu4BHi9J4gn0QSKck=;
        b=nbIhFUJoRBnIc5F8S+uDzk8CbCS/Q3shzMwsfsroIGh2J6jVogMIB0jX650xI9l8l4
         QfglVCPyz6EUVtz7mWQAAjipsepuQ5E/m8n1Ftut5XwcwB5c3I3mh2zXxirESoX7eAK4
         BHhHeSw7sSJXU2b+Gt4rCbO0j69SVfwKa0CyE0KlxxvCu7HToS3SzqdL7rToU/+y5Gkw
         VFEykGpJNxGMVPruLLcSjhufR/BdXwaFPLq1N9YnYo5C8QfI3NFpkKHxDKgUCst6xkll
         M0DCJRYEkqDOMLzTED5jPzf3+pMZPw9ams+1ab1hBN4BZK6vER2Ex/GzS6J9uu5dEwbM
         0ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743773308; x=1744378108;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L1EvrIpOY5/BQY+g5/bXbxzle3Uu4BHi9J4gn0QSKck=;
        b=dwwNQ2QPW0urF0JepYsY2/MV53a49xi8xtBCDSoYAQ3l72Ari9H68+Q8icUJtkeH1q
         VwkUyLiZpj9NmlYvGp/NlTHY5w7SWZ7MaXeB9r2guTWUY1KYcJv7Lb9+x7oboWjNOBCc
         JR7AP/lZTqU7ifwkx52GTWma+7u2aDl0KDrohMwYiBPuuFNbrC0n7Xydy/5++UJS09xa
         /7JLjgEBcgi5C/1R96hlnuONePD5D71jksvDgZQb98rWbI9AiruBUrWK7NeckDT8Kpfg
         98O9n2z1Peftuvw5abJ26zPxc+97u/edVEPtmlE45nfNEBOfxTIRk7Z9+oCVuTEwF3u6
         L8zg==
X-Forwarded-Encrypted: i=1; AJvYcCXNnKyolQva27ff39+ZpLw7mxayPQPzV+OSYu0DMMbHiBn2sAOtL873x+Bzv7NC+SwU59XTDmOB@lists.linux.dev
X-Gm-Message-State: AOJu0YyN4n2vwhhXODw0WlQvj9r2h+s0g4bWpUkGnjYC7p9KTVOOI4wW
	ZhmBZClGtqx7CW5t54P/veJmbVzlWn/2nUsbF7zI25BmsFKIZASirqSQiy9L6R5kWoSk1VsQDEs
	UCRO/HAYRGmWdkUhY2Fci1ZZ4WpI=
X-Gm-Gg: ASbGncs9q8z0vTiX+hbeM5nsA/ni/uS/O6Kh6iaUbcT4R4dJLkCNWLtHkVT6wTUM215
	EJMcH4UFJUH0421nup9KW/53zwIzVGAtYBiVIWagemHWzlPYBrJqQLYXTY8HG0K2TBev1g/Tkuw
	F8u9OmRR6nh1lBEQqKEOmJXDEq+XL1XkNPi+sOqH2U
X-Google-Smtp-Source: AGHT+IEH3oSAaHUxdWxzytgERI3jEbHxHJwBXGrj94vlYzIgv60oEEOga0t/vF9UsR7u5ZJVVEVDpQRL1UPkN/SYW60=
X-Received: by 2002:a17:90a:d883:b0:2fe:a0ac:5fcc with SMTP id
 98e67ed59e1d1-306a6245becmr3055286a91.34.1743773308463; Fri, 04 Apr 2025
 06:28:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250403151621.130541515@linuxfoundation.org> <CADo9pHjHSDjbGHrx1bY0JAxPRNWW63772wGt0e4wQ_kDq50JhA@mail.gmail.com>
In-Reply-To: <CADo9pHjHSDjbGHrx1bY0JAxPRNWW63772wGt0e4wQ_kDq50JhA@mail.gmail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Fri, 4 Apr 2025 15:28:15 +0200
X-Gm-Features: ATxdqUGgEPhFd7pK9_-fqa9Wl-BBCEXuGiINgFnjtn_Peku-eWbJr_Dz5WTiQlg
Message-ID: <CADo9pHhFbPMfURmsAdxaUX0R9pp0aaPxD3KW3PEh2B5iT_YATg@mail.gmail.com>
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Works good on my laptop too with the same OS

Dell Latitude 7390 Intel(R) Core(TM) i5-8350U (8) @ 3.60 GHz

Den fre 4 apr. 2025 kl 12:18 skrev Luna Jernberg <droidbittin@gmail.com>:
>
> Tested-by: Luna Jernberg <droidbittin@gmail.com>
>
> AMD Ryzen 5 5600 6-Core Processor:
> https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
> https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
> https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
> motherboard :)
>
> running Arch Linux with the testing repos enabled:
> https://archlinux.org/ https://archboot.com/
> https://wiki.archlinux.org/title/Arch_Testing_Team
>
> (still building on my Dell Latitude laptop)
>
> Den tors 3 apr. 2025 kl 17:25 skrev Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>:
> >
> > This is the start of the stable review cycle for the 6.14.1 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
> >
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Linux 6.14.1-rc1
> >
> > John Keeping <jkeeping@inmusicbrands.com>
> >     serial: 8250_dma: terminate correct DMA in tx_dma_flush()
> >
> > Cheick Traore <cheick.traore@foss.st.com>
> >     serial: stm32: do not deassert RS485 RTS GPIO prematurely
> >
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     perf tools: Fix up some comments and code to properly use the event_source bus
> >
> > Luo Qiu <luoqiu@kylinsec.com.cn>
> >     memstick: rtsx_usb_ms: Fix slab-use-after-free in rtsx_usb_ms_drv_remove
> >
> > Michal Pecio <michal.pecio@gmail.com>
> >     usb: xhci: Apply the link chain quirk on NEC isoc endpoints
> >
> > Michal Pecio <michal.pecio@gmail.com>
> >     usb: xhci: Don't skip on Stopped - Length Invalid
> >
> > Dominique Martinet <dominique.martinet@atmark-techno.com>
> >     net: usb: usbnet: restore usb%d name exception for local mac addresses
> >
> > Fabio Porcedda <fabio.porcedda@gmail.com>
> >     net: usb: qmi_wwan: add Telit Cinterion FE990B composition
> >
> > Fabio Porcedda <fabio.porcedda@gmail.com>
> >     net: usb: qmi_wwan: add Telit Cinterion FN990B composition
> >
> > Sherry Sun <sherry.sun@nxp.com>
> >     tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers
> >
> > Cameron Williams <cang1@live.co.uk>
> >     tty: serial: 8250: Add Brainboxes XC devices
> >
> > Cameron Williams <cang1@live.co.uk>
> >     tty: serial: 8250: Add some more device IDs
> >
> > William Breathitt Gray <wbg@kernel.org>
> >     counter: microchip-tcb-capture: Fix undefined counter channel state on probe
> >
> > Fabrice Gasnier <fabrice.gasnier@foss.st.com>
> >     counter: stm32-lptimer-cnt: fix error handling when enabling
> >
> > Andres Traumann <andres.traumann.01@gmail.com>
> >     ALSA: hda/realtek: Bass speaker fixup for ASUS UM5606KA
> >
> > Dhruv Deshpande <dhrv.d@proton.me>
> >     ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx
> >
> > Maxim Mikityanskiy <maxtram95@gmail.com>
> >     netfilter: socket: Lookup orig tuple for IPv6 SNAT
> >
> > Abel Wu <wuyun.abel@bytedance.com>
> >     cgroup/rstat: Fix forceidle time in cpu.stat
> >
> > Minjoong Kim <pwn9uin@gmail.com>
> >     atm: Fix NULL pointer dereference
> >
> > Terry Junge <linuxhid@cosmicgizmosystems.com>
> >     HID: hid-plantronics: Add mic mute mapping and generalize quirks
> >
> > Terry Junge <linuxhid@cosmicgizmosystems.com>
> >     ALSA: usb-audio: Add quirk for Plantronics headsets to fix control names
> >
> >
> > -------------
> >
> > Diffstat:
> >
> >  Makefile                                  |   4 +-
> >  drivers/counter/microchip-tcb-capture.c   |  19 ++++
> >  drivers/counter/stm32-lptimer-cnt.c       |  24 +++--
> >  drivers/hid/hid-plantronics.c             | 144 ++++++++++++++----------------
> >  drivers/memstick/host/rtsx_usb_ms.c       |   1 +
> >  drivers/net/usb/qmi_wwan.c                |   2 +
> >  drivers/net/usb/usbnet.c                  |  21 +++--
> >  drivers/tty/serial/8250/8250_dma.c        |   2 +-
> >  drivers/tty/serial/8250/8250_pci.c        |  46 ++++++++++
> >  drivers/tty/serial/fsl_lpuart.c           |  17 ++++
> >  drivers/tty/serial/stm32-usart.c          |   4 +-
> >  drivers/usb/host/xhci-ring.c              |   4 +
> >  drivers/usb/host/xhci.h                   |  13 ++-
> >  kernel/cgroup/rstat.c                     |  29 +++---
> >  net/atm/mpc.c                             |   2 +
> >  net/ipv6/netfilter/nf_socket_ipv6.c       |  23 +++++
> >  sound/pci/hda/patch_realtek.c             |   2 +
> >  sound/usb/mixer_quirks.c                  |  51 +++++++++++
> >  tools/perf/Documentation/intel-hybrid.txt |  12 +--
> >  tools/perf/Documentation/perf-list.txt    |   2 +-
> >  tools/perf/arch/x86/util/iostat.c         |   2 +-
> >  tools/perf/builtin-stat.c                 |   2 +-
> >  tools/perf/util/mem-events.c              |   2 +-
> >  tools/perf/util/pmu.c                     |   4 +-
> >  24 files changed, 304 insertions(+), 128 deletions(-)
> >
> >
> >
