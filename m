Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4688F40
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 10:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743761914; cv=none; b=EU7k816Szq3t/5zVgy/2XqqLDjcAGtHhklB+6ndZovPa8VL0KiHjU46HFhvrCn8tvwQDQjUZME9GqGxYNNeQYEqKmgym431grfyunZJRIHXuoc0Es60FB0sW9Vpvf7jjiAIvARv15MiP+ptxFtVuipdyCwyG1LA2SzXAuZEJpY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743761914; c=relaxed/simple;
	bh=80splu1n8pOU1KBBOO6Kic2gl/SyiEiRofLtsBPJG04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F0WLA7pevYIrcgj0J4VysPDmV4Bl8DJexjCQiFEXnqTEnV7JN1eu2BJo17NY4s3JpbeWPeeH0aSaeJWRDVI0ILXN7K0n9PQ0bDgMaOSK+qNrA2RHEr0tSH8P0Yf8DQEl/VpWGf2r37y7MIYMOMGOsNzYmzc7yY9/NNwl8pVEi38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cE718JA6; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cE718JA6"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-af519c159a8so1671556a12.3
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 03:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743761911; x=1744366711; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kk2+ssM+Oku3Smc5VL3MHZ4lXHAgsUA/66b+AhTOPFU=;
        b=cE718JA6QXILASwMIpJtnnGnMj+EGHZeIOcN9BLmYkb48dDV2TxPfd3o1gyZb3pSmo
         eu2KDmdrVMMz5MSfp+x8WMgd1+sbGM2TY8t41NbmOAO1MmalTkQ8qcFiUh68gLP8vzTq
         yvcsHi8Hh1CwNYQEfEXnKVHyvHLDymcLWw+DEm7jhrgyqMXu9p1WvQ9mOXh6Yh/NDBO5
         KZtJQX9oQHPVP1oNJTAdB5fWtQCt38gh6Q4mqw6Gis8DfMSozm9Nm4kLLvcBrc+hcO0U
         B6RNUlm8u0I6Y+LWaYkxpDleK+q+8C8XnRqFzK8m8pFa5lqXMkX5ZZj3zHsxpW7HrqsR
         yv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743761911; x=1744366711;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kk2+ssM+Oku3Smc5VL3MHZ4lXHAgsUA/66b+AhTOPFU=;
        b=UTecVpt2GqgltGIUkrv/YNbuiTJuHHMJgSBESxtu4F1jSHTeUeCEnd50OIObouAy5Q
         eKAPZSq9zVeYE24utPiaiWLRlVW3l4Q+ncgOrXSolwERq3KozG50QGW5ewE5i7iVkJi3
         8y9kk7+z/emcrfXhmTRHdmNOAHNiVIynjG5VWVLBAw4B3Q5eHglqshdR4z/78zj3YUr8
         6sDLcCpUagQ+yTeKBfOsv+UOkRIPFxJJY/tVfJHmC3sQHY7JM2Jj0IaO+a/mOJMf/xGn
         LKJOrzDrVea4yUrOJZSrkIiRU9VimFIFoma8VEXgMhlFmWOxzIbebSErfIwmSXjgljmV
         prFA==
X-Forwarded-Encrypted: i=1; AJvYcCU7N0hZhe3ulfI1YxiuYGiHAPMspxE04yg7t/0QGQcTRves9JbRblF5a0qV1HRF9itONorps9lR@lists.linux.dev
X-Gm-Message-State: AOJu0YykhLmiUaf3E6Z3D5U7167ivB7Az00oWZ1npZS4wvNbEgke/UR2
	x0V3Hxy90aO/2LmQUgM8gYuBHjNHsWZtwmAcZp6F/hD/bM7yhKtd7nePvxmLExdndyTjl7s3OXj
	qVh6YXck6wDWdDDjI+0FEAw+Nd+Y=
X-Gm-Gg: ASbGncu/CxBdd5x7tghg7foA7rin7qnhoQFUigvUBR7tx/uoJym27Mj7QtELnvg2+lr
	cAjZBNN1sUXoYu5xDwTxj4X0uHSIlss25xS/v0fWm7K2jxeYijsOa5i9xdJQKvMJCkePtbDV51l
	cXGuj4nXNB77QsjrURjmbMeRZZoR4UnoIndjMzL+sZ
X-Google-Smtp-Source: AGHT+IF5qLApiWtmfEDZpNEBNfwwjniKGCedGrVsIBSll8ZYZ6bWrMHRGsz5hNK6ku+PeSNjXvg1TdI1HKVtH14YtJA=
X-Received: by 2002:a17:90b:254c:b0:2ee:aed6:9ec2 with SMTP id
 98e67ed59e1d1-306a6159281mr3617039a91.14.1743761910715; Fri, 04 Apr 2025
 03:18:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250403151621.130541515@linuxfoundation.org>
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Fri, 4 Apr 2025 12:18:18 +0200
X-Gm-Features: ATxdqUGBb48kNnIvxkBjFnEnOVymJCkadN_wHW90QF4tTA66dTROAv5n4CAYZjs
Message-ID: <CADo9pHjHSDjbGHrx1bY0JAxPRNWW63772wGt0e4wQ_kDq50JhA@mail.gmail.com>
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

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

(still building on my Dell Latitude laptop)

Den tors 3 apr. 2025 kl 17:25 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.14.1-rc1
>
> John Keeping <jkeeping@inmusicbrands.com>
>     serial: 8250_dma: terminate correct DMA in tx_dma_flush()
>
> Cheick Traore <cheick.traore@foss.st.com>
>     serial: stm32: do not deassert RS485 RTS GPIO prematurely
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     perf tools: Fix up some comments and code to properly use the event_source bus
>
> Luo Qiu <luoqiu@kylinsec.com.cn>
>     memstick: rtsx_usb_ms: Fix slab-use-after-free in rtsx_usb_ms_drv_remove
>
> Michal Pecio <michal.pecio@gmail.com>
>     usb: xhci: Apply the link chain quirk on NEC isoc endpoints
>
> Michal Pecio <michal.pecio@gmail.com>
>     usb: xhci: Don't skip on Stopped - Length Invalid
>
> Dominique Martinet <dominique.martinet@atmark-techno.com>
>     net: usb: usbnet: restore usb%d name exception for local mac addresses
>
> Fabio Porcedda <fabio.porcedda@gmail.com>
>     net: usb: qmi_wwan: add Telit Cinterion FE990B composition
>
> Fabio Porcedda <fabio.porcedda@gmail.com>
>     net: usb: qmi_wwan: add Telit Cinterion FN990B composition
>
> Sherry Sun <sherry.sun@nxp.com>
>     tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers
>
> Cameron Williams <cang1@live.co.uk>
>     tty: serial: 8250: Add Brainboxes XC devices
>
> Cameron Williams <cang1@live.co.uk>
>     tty: serial: 8250: Add some more device IDs
>
> William Breathitt Gray <wbg@kernel.org>
>     counter: microchip-tcb-capture: Fix undefined counter channel state on probe
>
> Fabrice Gasnier <fabrice.gasnier@foss.st.com>
>     counter: stm32-lptimer-cnt: fix error handling when enabling
>
> Andres Traumann <andres.traumann.01@gmail.com>
>     ALSA: hda/realtek: Bass speaker fixup for ASUS UM5606KA
>
> Dhruv Deshpande <dhrv.d@proton.me>
>     ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx
>
> Maxim Mikityanskiy <maxtram95@gmail.com>
>     netfilter: socket: Lookup orig tuple for IPv6 SNAT
>
> Abel Wu <wuyun.abel@bytedance.com>
>     cgroup/rstat: Fix forceidle time in cpu.stat
>
> Minjoong Kim <pwn9uin@gmail.com>
>     atm: Fix NULL pointer dereference
>
> Terry Junge <linuxhid@cosmicgizmosystems.com>
>     HID: hid-plantronics: Add mic mute mapping and generalize quirks
>
> Terry Junge <linuxhid@cosmicgizmosystems.com>
>     ALSA: usb-audio: Add quirk for Plantronics headsets to fix control names
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                  |   4 +-
>  drivers/counter/microchip-tcb-capture.c   |  19 ++++
>  drivers/counter/stm32-lptimer-cnt.c       |  24 +++--
>  drivers/hid/hid-plantronics.c             | 144 ++++++++++++++----------------
>  drivers/memstick/host/rtsx_usb_ms.c       |   1 +
>  drivers/net/usb/qmi_wwan.c                |   2 +
>  drivers/net/usb/usbnet.c                  |  21 +++--
>  drivers/tty/serial/8250/8250_dma.c        |   2 +-
>  drivers/tty/serial/8250/8250_pci.c        |  46 ++++++++++
>  drivers/tty/serial/fsl_lpuart.c           |  17 ++++
>  drivers/tty/serial/stm32-usart.c          |   4 +-
>  drivers/usb/host/xhci-ring.c              |   4 +
>  drivers/usb/host/xhci.h                   |  13 ++-
>  kernel/cgroup/rstat.c                     |  29 +++---
>  net/atm/mpc.c                             |   2 +
>  net/ipv6/netfilter/nf_socket_ipv6.c       |  23 +++++
>  sound/pci/hda/patch_realtek.c             |   2 +
>  sound/usb/mixer_quirks.c                  |  51 +++++++++++
>  tools/perf/Documentation/intel-hybrid.txt |  12 +--
>  tools/perf/Documentation/perf-list.txt    |   2 +-
>  tools/perf/arch/x86/util/iostat.c         |   2 +-
>  tools/perf/builtin-stat.c                 |   2 +-
>  tools/perf/util/mem-events.c              |   2 +-
>  tools/perf/util/pmu.c                     |   4 +-
>  24 files changed, 304 insertions(+), 128 deletions(-)
>
>
>
