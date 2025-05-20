Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ED61A238F
	for <patches@lists.linux.dev>; Tue, 20 May 2025 21:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.61.224.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747776911; cv=none; b=e8HH62oH9xTs4d6R7bErWDyRnRLPmvmYFM/EFoc9MiPFtvEPwASww1btymXiasB4KsOmtqlc4pqZnSTnnSNyMs7+DAzC0vP9a4VI2bV8RQfoQzyxCo03tqaUZnlO/Jppwo6FtaKSV4Rej+doS3d4kR/KvAGddn//gRolI9mk+Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747776911; c=relaxed/simple;
	bh=pklFVVj4rdtK/G7E+QRlkAS5jw1ndgfBgBVtfsca26w=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=oJjBOc20VDguizeVGQWTZWH/XjSuryyumVMNne1aaWgbuYnUNh7ThXt4EY/DusCJAEgnNhAvlMhPFW5+1DugKKUuZ2258r/vgC1B4haucdZF7bStFFuneijlvrVM1eF5oF85jaYqsqLXz/v4HppA9C4iyQ1+VmiNiZgSTOoM3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org; spf=pass smtp.mailfrom=cachyos.org; dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b=nrF1lYfh; arc=none smtp.client-ip=202.61.224.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cachyos.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b="nrF1lYfh"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1A857283950;
	Tue, 20 May 2025 23:34:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1747776906; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-language:in-reply-to:references;
	bh=w+sL5G1yMrb/skVt79PeYVTS2nz2cC5KOg3u5+j5is0=;
	b=nrF1lYfhHWqR/mSE7+8PmStwOTrpL0njnndomE39wFSzDd0WbEEx2g4ioXGtc/2D0zR0Xw
	1bbMs3t0/F0C/wZYr5Ypu2nlDx4nrfPpTC6ky41XjQmoZVzgeopWFNAggf8793V3ppDS8j
	CBl5HwIb8svNFBSy8k/+Zwff2CSSE+3rLb5IQtsmVEzYdRgKjwLcjkm42e3XlGUtroAhzH
	tRWG8p8JBOt6MPFh27E4gQPwKfEM3fWM+w4vmlrKIRDgILro3Gor8KoivmV0DCxpS99YN6
	imnCa29z5TYwvPbrScZca7PhAYJlP36d6J/B2B4OFW6ae7PU+Tvc83ANqwSikQ==
Content-Type: multipart/mixed; boundary="------------49kDrCDt7nAYG2hh0k9TvVBb"
Message-ID: <8db9b7cb-03ff-4aca-aafa-bcab4d1b5d82@cachyos.org>
Date: Wed, 21 May 2025 05:34:53 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 David.Wu3@amd.com, alexander.deucher@amd.com, mario.limonciello@amd.com
References: <20250520125810.535475500@linuxfoundation.org>
Content-Language: en-US
From: Eric Naim <dnaim@cachyos.org>
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3

This is a multi-part message in MIME format.
--------------49kDrCDt7nAYG2hh0k9TvVBb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

On 5/20/25 21:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
>     Linux 6.14.8-rc1
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>     phy: tegra: xusb: remove a stray unlock
> 
> Tiezhu Yang <yangtiezhu@loongson.cn>
>     perf tools: Fix build error for LoongArch
> 
> Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>     mm/page_alloc: fix race condition in unaccepted memory handling
> 
> Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>     drm/xe/gsc: do not flush the GSC worker from the reset path
> 
> Maciej Falkowski <maciej.falkowski@linux.intel.com>
>     accel/ivpu: Flush pending jobs of device's workqueues
> 
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Fix missing MMU events if file_priv is unbound
> 
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Fix missing MMU events from reserved SSID
> 
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Move parts of MMU event IRQ handling to thread handler
> 
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Dump only first MMU fault from single context
> 
> Maciej Falkowski <maciej.falkowski@linux.intel.com>
>     accel/ivpu: Use workqueue for IRQ handling
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: Refactor remove call with idxd_cleanup() helper
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: fix memory leak in error handling path of idxd_alloc
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: Add missing cleanups in cleanup internals
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: Add missing cleanup for early error out in idxd_setup_internals
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
> 
> Shuai Xue <xueshuai@linux.alibaba.com>
>     dmaengine: idxd: fix memory leak in error handling path of idxd_setup_wqs
> 
> Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
>     dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
> 
> Ronald Wahl <ronald.wahl@legrand.com>
>     dmaengine: ti: k3-udma: Add missing locking
> 
> Barry Song <baohua@kernel.org>
>     mm: userfaultfd: correct dirty flags set for both present and swap pte
> 
> Wupeng Ma <mawupeng1@huawei.com>
>     mm: hugetlb: fix incorrect fallback for subpool
> 
> hexue <xue01.he@samsung.com>
>     io_uring/uring_cmd: fix hybrid polling initialization issue
> 
> Jens Axboe <axboe@kernel.dk>
>     io_uring/memmap: don't use page_address() on a highmem page
> 
> Nathan Chancellor <nathan@kernel.org>
>     net: qede: Initialize qede_ll_ops with designated initializer
> 
> Steven Rostedt <rostedt@goodmis.org>
>     ring-buffer: Fix persistent buffer when commit page is the reader page
> 
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: fix missing hdr_trans_tlv command for broadcast wtbl
> 
> Fedor Pchelkin <pchelkin@ispras.ru>
>     wifi: mt76: disable napi on driver removal
> 
> Jarkko Sakkinen <jarkko@kernel.org>
>     tpm: Mask TPM RC in tpm2_start_auth_session()
> 
> Aaron Kling <webgeek1234@gmail.com>
>     spi: tegra114: Use value to check for invalid delays
> 
> Jethro Donaldson <devel@jro.nz>
>     smb: client: fix memory leak during error handling for POSIX mkdir
> 
> Steve Siwinski <ssiwinski@atto.com>
>     scsi: sd_zbc: block: Respect bio vector limits for REPORT ZONES buffer
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     phy: renesas: rcar-gen3-usb2: Set timing registers only once
> 
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     phy: renesas: rcar-gen3-usb2: Fix role detection on unbind/bind
> 
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: phy: micrel: remove KSZ9477 EEE quirks now handled by phylink
> 
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: dsa: microchip: let phylink manage PHY EEE configuration on KSZ switches
> 
> Ma Ke <make24@iscas.ac.cn>
>     phy: Fix error handling in tegra_xusb_port_init
> 
> Wayne Chang <waynec@nvidia.com>
>     phy: tegra: xusb: Use a bitmask for UTMI pad power state tracking
> 
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: samples: Initialize trace_array_printk() with the correct function
> 
> Ashish Kalra <ashish.kalra@amd.com>
>     x86/sev: Make sure pages are not skipped during kdump
> 
> Ashish Kalra <ashish.kalra@amd.com>
>     x86/sev: Do not touch VMSA pages during SNP guest memory kdump
> 
> pengdonglin <pengdonglin@xiaomi.com>
>     ftrace: Fix preemption accounting for stacktrace filter command
> 
> pengdonglin <pengdonglin@xiaomi.com>
>     ftrace: Fix preemption accounting for stacktrace trigger command
> 
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     i2c: designware: Fix an error handling path in i2c_dw_pci_probe()
> 
> Nathan Chancellor <nathan@kernel.org>
>     kbuild: Disable -Wdefault-const-init-unsafe
> 
> Michael Kelley <mhklinux@outlook.com>
>     Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()
> 
> Michael Kelley <mhklinux@outlook.com>
>     Drivers: hv: Allow vmbus_sendpacket_mpb_desc() to create multiple ranges
> 
> Michael Kelley <mhklinux@outlook.com>
>     hv_netvsc: Remove rmsg_pgcnt
> 
> Michael Kelley <mhklinux@outlook.com>
>     hv_netvsc: Preserve contiguous PFN grouping in the page buffer array
> 
> Michael Kelley <mhklinux@outlook.com>
>     hv_netvsc: Use vmbus_sendpacket_mpb_desc() to send VMBus messages
> 
> Dragan Simic <dsimic@manjaro.org>
>     arm64: dts: rockchip: Remove overdrive-mode OPPs from RK3588J SoC dtsi
> 
> Sam Edwards <cfsworks@gmail.com>
>     arm64: dts: rockchip: Allow Turing RK1 cooling fan to spin down
> 
> Christian Hewitt <christianshewitt@gmail.com>
>     arm64: dts: amlogic: dreambox: fix missing clkc_audio node
> 
> Hyejeong Choi <hjeong.choi@samsung.com>
>     dma-buf: insert memory barrier before updating num_fences
> 
> Nicolas Chauvet <kwizart@gmail.com>
>     ALSA: usb-audio: Add sample rate quirk for Microdia JP001 USB Camera
> 
> Christian Heusel <christian@heusel.eu>
>     ALSA: usb-audio: Add sample rate quirk for Audioengine D1
> 
> Wentao Liang <vulab@iscas.ac.cn>
>     ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()
> 
> Jeremy Linton <jeremy.linton@arm.com>
>     ACPI: PPTT: Fix processor subtable walk
> 
> Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
>     gpio: pca953x: fix IRQ storm on system wake up
> 
> Alexey Makhalov <alexey.makhalov@broadcom.com>
>     MAINTAINERS: Update Alexey Makhalov's email address
> 
> Wayne Lin <Wayne.Lin@amd.com>
>     drm/amd/display: Avoid flooding unnecessary info messages
> 
> Wayne Lin <Wayne.Lin@amd.com>
>     drm/amd/display: Correct the reply value when AUX write incomplete
> 
> Philip Yang <Philip.Yang@amd.com>
>     drm/amdgpu: csa unmap use uninterruptible lock
> 
> Tim Huang <tim.huang@amd.com>
>     drm/amdgpu: fix incorrect MALL size for GFX1151
> 
> David (Ming Qiang) Wu <David.Wu3@amd.com>
>     drm/amdgpu: read back register after written for VCN v4.0.5
> 

This commit seems to breaking a couple of devices with the Phoenix APU, most notably the Ryzen AI chips. Note that this commit in mainline seems to work as intended, and after doing a little bit of digging, [1] landed in 6.15 and so this cherrypick may not be so trivial after all. Attached is a kernel trace highlighting the breakage caused by this commit, along with [2] for the full log.

Also adding Alex, David and Mario to Ccs.

-- 
Regards,
  Eric

[1] https://lore.kernel.org/20250131165741.1798488-6-alexander.deucher@amd.com/
[2] https://paste.cachyos.org/p/d853a3c.log
--------------49kDrCDt7nAYG2hh0k9TvVBb
Content-Type: text/x-log; charset=UTF-8; name="dmesg.log"
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: base64

WyAgICA2LjU1NTMzMF0gQlVHOiBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLCBh
ZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDA0ClsgICAgNi41NTUzNTZdICNQRjogc3VwZXJ2aXNv
ciByZWFkIGFjY2VzcyBpbiBrZXJuZWwgbW9kZQpbICAgIDYuNTU1MzY5XSAjUEY6IGVycm9y
X2NvZGUoMHgwMDAwKSAtIG5vdC1wcmVzZW50IHBhZ2UKWyAgICA2LjU1NTM4M10gUEdEIDAg
UDREIDAgClsgICAgNi41NTUzOTJdIE9vcHM6IE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFNN
UCBOT1BUSQpbICAgIDYuNTU1NDA1XSBDUFU6IDE0IFVJRDogMCBQSUQ6IDMwOSBDb21tOiAo
dWRldi13b3JrZXIpIFRhaW50ZWQ6IEcgICAgICAgICAgIE9FICAgICAgNi4xNC44LXJjMS0x
aG9tZSAjMSAwNjAzODIxNjlmMGEwZWNmNzA4YTg4YmJhODMwMmNhYWU1MzAxNzU1ClsgICAg
Ni41NTU0MjldIFRhaW50ZWQ6IFtPXT1PT1RfTU9EVUxFLCBbRV09VU5TSUdORURfTU9EVUxF
ClsgICAgNi41NTU0NDFdIEhhcmR3YXJlIG5hbWU6IEFTVVNUZUsgQ09NUFVURVIgSU5DLiBS
T0cgWmVwaHlydXMgRzE2IEdBNjA1V1ZfR0E2MDVXVi9HQTYwNVdWLCBCSU9TIEdBNjA1V1Yu
MzEwIDEyLzIzLzIwMjQKWyAgICA2LjU1NTQ1OF0gUklQOiAwMDEwOnZjbl92NF8wXzVfc2V0
X3Bvd2VyZ2F0aW5nX3N0YXRlKzB4YjQwLzB4MzhjMCBbYW1kZ3B1XQpbICAgIDYuNTU1NzAy
XSBDb2RlOiAwMCAzMSBkMiA0OCA4OSBlZiBlOCA0ZiA4YyBkZiBmZiAwZiBiNiA4NSA3OSBl
ZSAwMiAwMCA0MSA4MyBjNCAwMSA0MSAzOSBjNCAwZiA4YyA2YSBmNSBmZiBmZiA0OSA2MyBj
NCA0OCA4YiA4NCBjNSAyMCA4YyAwNCAwMCA8OGI+IDcwIDA0IDgxIGM2IDg1IDAwIDAwIDAw
IGY2IDg1IDU4IGJkIDA0IDAwIDA0IDc0IDBlIDQ4IDgzIGJkIDMwClsgICAgNi41NTU3MzNd
IFJTUDogMDAxODpmZmZmYmQwODgwZGQ3NzYwIEVGTEFHUzogMDAwMTAyNDYKWyAgICA2LjU1
NTc0Nl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjlmZWIyZDIwMDAwMCBSQ1g6
IDAwMDAwMDAwNDAwMDBjNDgKWyAgICA2LjU1NTc2MV0gUkRYOiBmZmZmYmQwODg2MDFmOWM4
IFJTSTogMDAwMDAwMDAwMDAwN2U3MiBSREk6IGZmZmY5ZmViMmQyMDAwMDAKWyAgICA2LjU1
NTc3Nl0gUkJQOiBmZmZmOWZlYjJkMjAwMDAwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6
IDAwMDAwMDAwMDAwMDAwMTQKWyAgICA2LjU1NTc5MF0gUjEwOiBmZmZmOWZlYjE2YTQ0Mjgw
IFIxMTogMDAwMDAwMDAwMDAwMDAwMSBSMTI6IDAwMDAwMDAwMDAwMDAwMDEKWyAgICA2LjU1
NTgwNV0gUjEzOiAwMDAwMDAwMDAwMDAwMDAxIFIxNDogMDAwMDAwMDAwMDAwMDAwYiBSMTU6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICA2LjU1NTgyMF0gRlM6ICAwMDAwN2Y5OTQxNzc5ODgw
KDAwMDApIEdTOmZmZmY5ZmYxNjFkMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MApbICAgIDYuNTU1ODM2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAw
MDAwMDgwMDUwMDMzClsgICAgNi41NTU4NDldIENSMjogMDAwMDAwMDAwMDAwMDAwNCBDUjM6
IDAwMDAwMDAxMTBmNTEwMDAgQ1I0OiAwMDAwMDAwMDAwZjUwZWYwClsgICAgNi41NTU4NjRd
IFBLUlU6IDU1NTU1NTU0ClsgICAgNi41NTU4NzJdIENhbGwgVHJhY2U6ClsgICAgNi41NTU4
NzldICA8VEFTSz4KWyAgICA2LjU1NTg4NV0gIGFtZGdwdV9kZXZpY2VfaXBfc2V0X3Bvd2Vy
Z2F0aW5nX3N0YXRlKzB4NWQvMHhiMCBbYW1kZ3B1IDc4OGE4YjI0OTE5MGM1NTQwOGU4ZDZi
MWYyMWRjMDAyMmM0MGNiNDRdClsgICAgNi41NTYwMTddICA/IGFtZGdwdV9kcG1fc3dpdGNo
X3Bvd2VyX3Byb2ZpbGUrMHg4Mi8weGEwIFthbWRncHUgNzg4YThiMjQ5MTkwYzU1NDA4ZThk
NmIxZjIxZGMwMDIyYzQwY2I0NF0KWyAgICA2LjU1NjIwNl0gIGFtZGdwdV92Y25fcmluZ19i
ZWdpbl91c2UrMHg2NC8weDFhMCBbYW1kZ3B1IDc4OGE4YjI0OTE5MGM1NTQwOGU4ZDZiMWYy
MWRjMDAyMmM0MGNiNDRdClsgICAgNi41NTYzNjFdICBhbWRncHVfcmluZ19hbGxvYysweDQw
LzB4NjAgW2FtZGdwdSA3ODhhOGIyNDkxOTBjNTU0MDhlOGQ2YjFmMjFkYzAwMjJjNDBjYjQ0
XQpbICAgIDYuNTU2NzY0XSAgYW1kZ3B1X3Zjbl9kZWNfc3dfcmluZ190ZXN0X3JpbmcrMHgz
OS8weGYwIFthbWRncHUgNzg4YThiMjQ5MTkwYzU1NDA4ZThkNmIxZjIxZGMwMDIyYzQwY2I0
NF0KWyAgICA2LjU1NzE2MF0gIGFtZGdwdV9yaW5nX3Rlc3RfaGVscGVyKzB4MWYvMHhhMCBb
YW1kZ3B1IDc4OGE4YjI0OTE5MGM1NTQwOGU4ZDZiMWYyMWRjMDAyMmM0MGNiNDRdClsgICAg
Ni41NTc1NDddICB2Y25fdjRfMF81X2h3X2luaXQrMHg3NS8weGEwIFthbWRncHUgNzg4YThi
MjQ5MTkwYzU1NDA4ZThkNmIxZjIxZGMwMDIyYzQwY2I0NF0KWyAgICA2LjU1Nzk0NF0gIGFt
ZGdwdV9kZXZpY2VfaW5pdC5jb2xkKzB4MTcyYS8weDIyNGQgW2FtZGdwdSA3ODhhOGIyNDkx
OTBjNTU0MDhlOGQ2YjFmMjFkYzAwMjJjNDBjYjQ0XQpbICAgIDYuNTU4NDA2XSAgYW1kZ3B1
X2RyaXZlcl9sb2FkX2ttcysweDE1LzB4NzAgW2FtZGdwdSA3ODhhOGIyNDkxOTBjNTU0MDhl
OGQ2YjFmMjFkYzAwMjJjNDBjYjQ0XQpbICAgIDYuNTU4ODA0XSAgYW1kZ3B1X3BjaV9wcm9i
ZSsweDFlNC8weDUwMCBbYW1kZ3B1IDc4OGE4YjI0OTE5MGM1NTQwOGU4ZDZiMWYyMWRjMDAy
MmM0MGNiNDRdClsgICAgNi41NTkyMDJdICA/IF9fcG1fcnVudGltZV9yZXN1bWUrMHg1Zi8w
eDkwClsgICAgNi41NTk0ODZdICBsb2NhbF9wY2lfcHJvYmUrMHgzZi8weDkwClsgICAgNi41
NTk3NjldICBwY2lfZGV2aWNlX3Byb2JlKzB4ZGIvMHgyOTAKWyAgICA2LjU2MDA0Ml0gID8g
c3lzZnNfZG9fY3JlYXRlX2xpbmtfc2QrMHg2ZC8weGQwClsgICAgNi41NjAzMTNdICByZWFs
bHlfcHJvYmUrMHhkYi8weDM0MApbICAgIDYuNTYwNTc4XSAgPyBwbV9ydW50aW1lX2JhcnJp
ZXIrMHg1NS8weDkwClsgICAgNi41NjA4MzZdICBfX2RyaXZlcl9wcm9iZV9kZXZpY2UrMHg3
OC8weDE0MApbICAgIDYuNTYxMDg1XSAgZHJpdmVyX3Byb2JlX2RldmljZSsweDFmLzB4YTAK
WyAgICA2LjU2MTMyOV0gID8gX19wZnhfX19kcml2ZXJfYXR0YWNoKzB4MTAvMHgxMApbICAg
IDYuNTYxNTY3XSAgX19kcml2ZXJfYXR0YWNoKzB4Y2IvMHgxZTAKWyAgICA2LjU2MTc5Nl0g
IGJ1c19mb3JfZWFjaF9kZXYrMHg4Ny8weGUwClsgICAgNi41NjIwMThdICBidXNfYWRkX2Ry
aXZlcisweDEwYi8weDFmMApbICAgIDYuNTYyMjM3XSAgPyBfX3BmeF9hbWRncHVfaW5pdCsw
eDEwLzB4MTAgW2FtZGdwdSA3ODhhOGIyNDkxOTBjNTU0MDhlOGQ2YjFmMjFkYzAwMjJjNDBj
YjQ0XQpbICAgIDYuNTYyNTc5XSAgZHJpdmVyX3JlZ2lzdGVyKzB4NzUvMHhlMApbICAgIDYu
NTYyODA0XSAgPyBhbWRncHVfaW5pdCsweDRiLzB4ZmYwIFthbWRncHUgNzg4YThiMjQ5MTkw
YzU1NDA4ZThkNmIxZjIxZGMwMDIyYzQwY2I0NF0KWyAgICA2LjU2MzE1NV0gIGRvX29uZV9p
bml0Y2FsbCsweDU5LzB4MzEwClsgICAgNi41NjMzOTRdICBkb19pbml0X21vZHVsZSsweDYy
LzB4MjQwClsgICAgNi41NjM2MjddICBpbml0X21vZHVsZV9mcm9tX2ZpbGUrMHg4Yi8weGUw
ClsgICAgNi41NjM4NTddICBpZGVtcG90ZW50X2luaXRfbW9kdWxlKzB4MTE1LzB4MzEwClsg
ICAgNi41NjQwODVdICBfX3g2NF9zeXNfZmluaXRfbW9kdWxlKzB4NjcvMHhjMApbICAgIDYu
NTY0MzA4XSAgZG9fc3lzY2FsbF82NCsweDdiLzB4MTkwClsgICAgNi41NjQ1MzRdICA/IF9f
cGZ4X3BhZ2VfcHV0X2xpbmsrMHgxMC8weDEwClsgICAgNi41NjQ3NjNdICA/IGFsbG9jX2Zk
KzB4MTJkLzB4MTkwClsgICAgNi41NjQ5ODNdICA/IGRvX3N5c19vcGVuYXQyKzB4OTYvMHhl
MApbICAgIDYuNTY1MTk1XSAgPyBzeXNjYWxsX2V4aXRfdG9fdXNlcl9tb2RlKzB4MzcvMHgx
YzAKWyAgICA2LjU2NTQwM10gID8gZG9fc3lzY2FsbF82NCsweDg3LzB4MTkwClsgICAgNi41
NjU2MDRdICA/IF9feDY0X3N5c19wcmVhZDY0KzB4YWIvMHhkMApbICAgIDYuNTY1Nzk5XSAg
PyBzeXNjYWxsX2V4aXRfdG9fdXNlcl9tb2RlKzB4MzcvMHgxYzAKWyAgICA2LjU2NTk5MF0g
ID8gZG9fc3lzY2FsbF82NCsweDg3LzB4MTkwClsgICAgNi41NjYxNzRdICA/IGlycWVudHJ5
X2V4aXRfdG9fdXNlcl9tb2RlKzB4MmMvMHgxYjAKWyAgICA2LjU2NjM1Nl0gIGVudHJ5X1NZ
U0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDc2LzB4N2UKWyAgICA2LjU2NjUzNV0gUklQOiAw
MDMzOjB4N2Y5OTQyMGMyY2RkClsgICAgNi41NjY3MDddIENvZGU6IGZmIGMzIDY2IDJlIDBm
IDFmIDg0IDAwIDAwIDAwIDAwIDAwIDkwIGYzIDBmIDFlIGZhIDQ4IDg5IGY4IDQ4IDg5IGY3
IDQ4IDg5IGQ2IDQ4IDg5IGNhIDRkIDg5IGMyIDRkIDg5IGM4IDRjIDhiIDRjIDI0IDA4IDBm
IDA1IDw0OD4gM2QgMDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgZmIgYmYgMGMgMDAg
ZjcgZDggNjQgODkgMDEgNDgKWyAgICA2LjU2NzA3M10gUlNQOiAwMDJiOjAwMDA3ZmZmNWU4
YmFiNjggRUZMQUdTOiAwMDAwMDI0NiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDEzOQpbICAg
IDYuNTY3MjY4XSBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAwMDAwNTVhM2NlODJiZjcw
IFJDWDogMDAwMDdmOTk0MjBjMmNkZApbICAgIDYuNTY3NDY1XSBSRFg6IDAwMDAwMDAwMDAw
MDAwMDQgUlNJOiAwMDAwNTVhM2NlODJhOTQwIFJESTogMDAwMDAwMDAwMDAwMDAxZgpbICAg
IDYuNTY3NjYyXSBSQlA6IDAwMDA3ZmZmNWU4YmFjMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAw
IFIwOTogMDAwMDU1YTNjZTgyZWRhMApbICAgIDYuNTY3ODYwXSBSMTA6IDAwMDAwMDAwMDAw
MDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMjQ2IFIxMjogMDAwMDU1YTNjZTgyYTk0MApbICAg
IDYuNTY4MDU4XSBSMTM6IDAwMDAwMDAwMDAwMjAwMDAgUjE0OiAwMDAwNTVhM2NlODI5ZTAw
IFIxNTogMDAwMDU1YTNjZTgyYmY3MApbICAgIDYuNTY4MjU2XSAgPC9UQVNLPgpbICAgIDYu
NTY4NDQ2XSBNb2R1bGVzIGxpbmtlZCBpbjogYW1kZ3B1KCspIGFtZHhjcCBpMmNfYWxnb19i
aXQgZHJtX2V4ZWMgZ3B1X3NjaGVkIHNkaGNpX3BjaSBkcm1fc3ViYWxsb2NfaGVscGVyIHNk
aGNpX3VoczIgZHJtX3BhbmVsX2JhY2tsaWdodF9xdWlya3Mgc2RoY2kgZHJtX2J1ZGR5IG52
bWUgY3FoY2kgZHJtX2Rpc3BsYXlfaGVscGVyIG52bWVfY29yZSBtbWNfY29yZSBjZWMgbnZt
ZV9hdXRoIGhpZF9hc3VzIGFzdXNfd21pIHNwYXJzZV9rZXltYXAgaTgwNDIgc2VyaW8gcGxh
dGZvcm1fcHJvZmlsZSByZmtpbGwgaGlkX2dlbmVyaWMgbnZpZGlhX2RybShPRSkgZHJtX3R0
bV9oZWxwZXIgdHRtIHVzYmhpZCBudmlkaWFfdXZtKE9FKSBudmlkaWFfbW9kZXNldChPRSkg
dmlkZW8gd21pIG52aWRpYShPRSkKWyAgICA2LjU2OTMzN10gQ1IyOiAwMDAwMDAwMDAwMDAw
MDA0

--------------49kDrCDt7nAYG2hh0k9TvVBb--
