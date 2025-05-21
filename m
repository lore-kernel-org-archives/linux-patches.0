Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB98422F757
	for <patches@lists.linux.dev>; Wed, 21 May 2025 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.61.224.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846765; cv=none; b=VYypnGcxb+tyo9rp2f5ruJzUz2qsG0p/xRfvSZM5nyZ5gxenzzwswmXKLYw14qivu0Q0jLghh9w19l0cF7CUQs/bh8vrvUan/ocGdUyCJnoK9hMbVhGC8X2xLl65ZdpbkcVAHUT+q6Zrt6U2wu9py8/bvoHUya97zbcJcfjMFBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846765; c=relaxed/simple;
	bh=fUs56gIHyl7T41zGIWoWeItrG0BCP4rFnoxj1iUak88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dbyevmJMwjRlg8icFi61PKn5Devj189vAiKn9Sxs/fOqqeocxj8wXDOiGpB12HtNeIUOg8Hb7ta5kiMT/emUCC0uOKsSt6M1CVIECEvgkhTra9a/YTqTAcM8Jw+0wGXwWU57khyr8ahTxJoPlCqqJOVEPQTklFdUKrhWG5TrJIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org; spf=pass smtp.mailfrom=cachyos.org; dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b=a3zaL1Ff; arc=none smtp.client-ip=202.61.224.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cachyos.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b="a3zaL1Ff"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BB02C2839B1;
	Wed, 21 May 2025 18:59:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1747846760; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=Yg4CY3X+MCsvOOgJ+FgICl+zXgCt3eAS4ykoC+zW+jE=;
	b=a3zaL1FfzrWlSs7/n3FPmlb5h42me63ojVzltzxLKqqjl79quEAZ6rA6Lkp6mKuXheSYls
	vE0K2d6OVi9LmIIsEMXjB/IpfkSyBQEPff5wqrirOpkZfqVEJCRUo8n8ccGBwoz858zXVX
	GQAq1uqv0hwlK8/iP45Kkn/Y5iTrmXLMaY+gpanyzXqDNcyIFQPjNPXc9/JZ4pXK9UpWDO
	zQE64+RJnHd5Bq86di3njadYvWi5KUpa3gGwL/ukddlA8aW5i6nHzYRVKa3AoSjTY5dx+5
	WDPs7gCZTXwEn3XtQFSDoU41yV1GrAPBJtERi/Rc6pv70cwkj81IrKNn8W45Tg==
Message-ID: <b08348c1-701f-4936-9c82-5d6e91cc701b@cachyos.org>
Date: Thu, 22 May 2025 00:59:10 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 David.Wu3@amd.com, alexander.deucher@amd.com
References: <20250520125810.535475500@linuxfoundation.org>
 <8db9b7cb-03ff-4aca-aafa-bcab4d1b5d82@cachyos.org>
 <c364e0d7-f3b2-484d-869b-095140e2537b@amd.com>
 <2025052153-bleach-ouch-0e59@gregkh>
 <a5376c47-156d-4841-85ab-615f2c942960@cachyos.org>
 <2025052144-lid-resource-2461@gregkh>
Content-Language: en-US
From: Eric Naim <dnaim@cachyos.org>
In-Reply-To: <2025052144-lid-resource-2461@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 5/22/25 00:25, Greg Kroah-Hartman wrote:
> On Wed, May 21, 2025 at 10:13:45PM +0800, Eric Naim wrote:
>> On 5/21/25 13:35, Greg Kroah-Hartman wrote:
>>> On Tue, May 20, 2025 at 09:42:13PM -0500, Mario Limonciello wrote:
>>>> On 5/20/2025 4:34 PM, Eric Naim wrote:
>>>>> Hi Greg,
>>>>>
>>>>> On 5/20/25 21:49, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 6.14.8 release.
>>>>>> There are 145 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>> The whole patch series can be found in one patch at:
>>>>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.8-rc1.gz
>>>>>> or in the git tree and branch at:
>>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
>>>>>> and the diffstat can be found below.
>>>>>>
>>>>>> thanks,
>>>>>>
>>>>>> greg k-h
>>>>>>
>>>>>> -------------
>>>>>> Pseudo-Shortlog of commits:
>>>>>>
>>>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>>      Linux 6.14.8-rc1
>>>>>>
>>>>>> Dan Carpenter <dan.carpenter@linaro.org>
>>>>>>      phy: tegra: xusb: remove a stray unlock
>>>>>>
>>>>>> Tiezhu Yang <yangtiezhu@loongson.cn>
>>>>>>      perf tools: Fix build error for LoongArch
>>>>>>
>>>>>> Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>>>>>      mm/page_alloc: fix race condition in unaccepted memory handling
>>>>>>
>>>>>> Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>>>>>>      drm/xe/gsc: do not flush the GSC worker from the reset path
>>>>>>
>>>>>> Maciej Falkowski <maciej.falkowski@linux.intel.com>
>>>>>>      accel/ivpu: Flush pending jobs of device's workqueues
>>>>>>
>>>>>> Karol Wachowski <karol.wachowski@intel.com>
>>>>>>      accel/ivpu: Fix missing MMU events if file_priv is unbound
>>>>>>
>>>>>> Karol Wachowski <karol.wachowski@intel.com>
>>>>>>      accel/ivpu: Fix missing MMU events from reserved SSID
>>>>>>
>>>>>> Karol Wachowski <karol.wachowski@intel.com>
>>>>>>      accel/ivpu: Move parts of MMU event IRQ handling to thread handler
>>>>>>
>>>>>> Karol Wachowski <karol.wachowski@intel.com>
>>>>>>      accel/ivpu: Dump only first MMU fault from single context
>>>>>>
>>>>>> Maciej Falkowski <maciej.falkowski@linux.intel.com>
>>>>>>      accel/ivpu: Use workqueue for IRQ handling
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: Refactor remove call with idxd_cleanup() helper
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: fix memory leak in error handling path of idxd_alloc
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: Add missing cleanups in cleanup internals
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: Add missing cleanup for early error out in idxd_setup_internals
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
>>>>>>
>>>>>> Shuai Xue <xueshuai@linux.alibaba.com>
>>>>>>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_wqs
>>>>>>
>>>>>> Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
>>>>>>      dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
>>>>>>
>>>>>> Ronald Wahl <ronald.wahl@legrand.com>
>>>>>>      dmaengine: ti: k3-udma: Add missing locking
>>>>>>
>>>>>> Barry Song <baohua@kernel.org>
>>>>>>      mm: userfaultfd: correct dirty flags set for both present and swap pte
>>>>>>
>>>>>> Wupeng Ma <mawupeng1@huawei.com>
>>>>>>      mm: hugetlb: fix incorrect fallback for subpool
>>>>>>
>>>>>> hexue <xue01.he@samsung.com>
>>>>>>      io_uring/uring_cmd: fix hybrid polling initialization issue
>>>>>>
>>>>>> Jens Axboe <axboe@kernel.dk>
>>>>>>      io_uring/memmap: don't use page_address() on a highmem page
>>>>>>
>>>>>> Nathan Chancellor <nathan@kernel.org>
>>>>>>      net: qede: Initialize qede_ll_ops with designated initializer
>>>>>>
>>>>>> Steven Rostedt <rostedt@goodmis.org>
>>>>>>      ring-buffer: Fix persistent buffer when commit page is the reader page
>>>>>>
>>>>>> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>>>>>>      wifi: mt76: mt7925: fix missing hdr_trans_tlv command for broadcast wtbl
>>>>>>
>>>>>> Fedor Pchelkin <pchelkin@ispras.ru>
>>>>>>      wifi: mt76: disable napi on driver removal
>>>>>>
>>>>>> Jarkko Sakkinen <jarkko@kernel.org>
>>>>>>      tpm: Mask TPM RC in tpm2_start_auth_session()
>>>>>>
>>>>>> Aaron Kling <webgeek1234@gmail.com>
>>>>>>      spi: tegra114: Use value to check for invalid delays
>>>>>>
>>>>>> Jethro Donaldson <devel@jro.nz>
>>>>>>      smb: client: fix memory leak during error handling for POSIX mkdir
>>>>>>
>>>>>> Steve Siwinski <ssiwinski@atto.com>
>>>>>>      scsi: sd_zbc: block: Respect bio vector limits for REPORT ZONES buffer
>>>>>>
>>>>>> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>>>>>>      phy: renesas: rcar-gen3-usb2: Set timing registers only once
>>>>>>
>>>>>> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>>>>>>      phy: renesas: rcar-gen3-usb2: Fix role detection on unbind/bind
>>>>>>
>>>>>> Oleksij Rempel <o.rempel@pengutronix.de>
>>>>>>      net: phy: micrel: remove KSZ9477 EEE quirks now handled by phylink
>>>>>>
>>>>>> Oleksij Rempel <o.rempel@pengutronix.de>
>>>>>>      net: dsa: microchip: let phylink manage PHY EEE configuration on KSZ switches
>>>>>>
>>>>>> Ma Ke <make24@iscas.ac.cn>
>>>>>>      phy: Fix error handling in tegra_xusb_port_init
>>>>>>
>>>>>> Wayne Chang <waynec@nvidia.com>
>>>>>>      phy: tegra: xusb: Use a bitmask for UTMI pad power state tracking
>>>>>>
>>>>>> Steven Rostedt <rostedt@goodmis.org>
>>>>>>      tracing: samples: Initialize trace_array_printk() with the correct function
>>>>>>
>>>>>> Ashish Kalra <ashish.kalra@amd.com>
>>>>>>      x86/sev: Make sure pages are not skipped during kdump
>>>>>>
>>>>>> Ashish Kalra <ashish.kalra@amd.com>
>>>>>>      x86/sev: Do not touch VMSA pages during SNP guest memory kdump
>>>>>>
>>>>>> pengdonglin <pengdonglin@xiaomi.com>
>>>>>>      ftrace: Fix preemption accounting for stacktrace filter command
>>>>>>
>>>>>> pengdonglin <pengdonglin@xiaomi.com>
>>>>>>      ftrace: Fix preemption accounting for stacktrace trigger command
>>>>>>
>>>>>> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>>>>>      i2c: designware: Fix an error handling path in i2c_dw_pci_probe()
>>>>>>
>>>>>> Nathan Chancellor <nathan@kernel.org>
>>>>>>      kbuild: Disable -Wdefault-const-init-unsafe
>>>>>>
>>>>>> Michael Kelley <mhklinux@outlook.com>
>>>>>>      Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()
>>>>>>
>>>>>> Michael Kelley <mhklinux@outlook.com>
>>>>>>      Drivers: hv: Allow vmbus_sendpacket_mpb_desc() to create multiple ranges
>>>>>>
>>>>>> Michael Kelley <mhklinux@outlook.com>
>>>>>>      hv_netvsc: Remove rmsg_pgcnt
>>>>>>
>>>>>> Michael Kelley <mhklinux@outlook.com>
>>>>>>      hv_netvsc: Preserve contiguous PFN grouping in the page buffer array
>>>>>>
>>>>>> Michael Kelley <mhklinux@outlook.com>
>>>>>>      hv_netvsc: Use vmbus_sendpacket_mpb_desc() to send VMBus messages
>>>>>>
>>>>>> Dragan Simic <dsimic@manjaro.org>
>>>>>>      arm64: dts: rockchip: Remove overdrive-mode OPPs from RK3588J SoC dtsi
>>>>>>
>>>>>> Sam Edwards <cfsworks@gmail.com>
>>>>>>      arm64: dts: rockchip: Allow Turing RK1 cooling fan to spin down
>>>>>>
>>>>>> Christian Hewitt <christianshewitt@gmail.com>
>>>>>>      arm64: dts: amlogic: dreambox: fix missing clkc_audio node
>>>>>>
>>>>>> Hyejeong Choi <hjeong.choi@samsung.com>
>>>>>>      dma-buf: insert memory barrier before updating num_fences
>>>>>>
>>>>>> Nicolas Chauvet <kwizart@gmail.com>
>>>>>>      ALSA: usb-audio: Add sample rate quirk for Microdia JP001 USB Camera
>>>>>>
>>>>>> Christian Heusel <christian@heusel.eu>
>>>>>>      ALSA: usb-audio: Add sample rate quirk for Audioengine D1
>>>>>>
>>>>>> Wentao Liang <vulab@iscas.ac.cn>
>>>>>>      ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()
>>>>>>
>>>>>> Jeremy Linton <jeremy.linton@arm.com>
>>>>>>      ACPI: PPTT: Fix processor subtable walk
>>>>>>
>>>>>> Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
>>>>>>      gpio: pca953x: fix IRQ storm on system wake up
>>>>>>
>>>>>> Alexey Makhalov <alexey.makhalov@broadcom.com>
>>>>>>      MAINTAINERS: Update Alexey Makhalov's email address
>>>>>>
>>>>>> Wayne Lin <Wayne.Lin@amd.com>
>>>>>>      drm/amd/display: Avoid flooding unnecessary info messages
>>>>>>
>>>>>> Wayne Lin <Wayne.Lin@amd.com>
>>>>>>      drm/amd/display: Correct the reply value when AUX write incomplete
>>>>>>
>>>>>> Philip Yang <Philip.Yang@amd.com>
>>>>>>      drm/amdgpu: csa unmap use uninterruptible lock
>>>>>>
>>>>>> Tim Huang <tim.huang@amd.com>
>>>>>>      drm/amdgpu: fix incorrect MALL size for GFX1151
>>>>>>
>>>>>> David (Ming Qiang) Wu <David.Wu3@amd.com>
>>>>>>      drm/amdgpu: read back register after written for VCN v4.0.5
>>>>>>
>>>>>
>>>>> This commit seems to breaking a couple of devices with the Phoenix APU, most notably the Ryzen AI chips. Note that this commit in mainline seems to work as intended, and after doing a little bit of digging, [1] landed in 6.15 and so this cherrypick may not be so trivial after all. Attached is a kernel trace highlighting the breakage caused by this commit, along with [2] for the full log.
>>>>>
>>>>> Also adding Alex, David and Mario to Ccs.
>>>>>
>>>>
>>>> Just a minor correction - VCN 4.0.5 is on Strix.  So this report is not
>>>> likely from a Phoenix APU.
>>>>
>>>> Nonetheless I agree; I suspect backporting
>>>> ecc9ab4e924b7eb9e2c4a668162aaa1d9d60d08c will help the issue.
>>>
>>> If it is required, someone is going to need to provide a working
>>> version, as that does not apply cleanly as-is.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hi Greg,
>>
>> I finally got someone to test the mentioned commit, and I (or they) can confirm that ecc9ab4e924b7eb9e2c4a668162aaa1d9d60d08c is indeed the missing commit needed for "drm/amdgpu: read back register after written for VCN v4.0.5".
>>
>> I don't know if this will help, but I got everything to apply cleanly by first applying ecc9ab4e924b7eb9e2c4a668162aaa1d9d60d08c, then cherry-picking the mainline version of "drm/amdgpu: read back register after written for VCN v4.0.5" [1] since the one in stable-rc seems to have been adjusted for the stable tree and made it conflict.
> 
> I don't see the conflict that happened here, as I only apply patches
> "cleanly".  But I trust you that things are odd here.
> 
>> -- 
>> Regards,
>>   Eric
>>
>> [1] ee7360fc27d6045510f8fe459b5649b2af27811a
> 
> Ick.  Ok, let me go drop this commit from the tree now, and then can you
> resubmit both of these as a tested series for them to be included
> properly?
> 
> I'll do the same for both 6.12.y and 6.14.y now.
> 
> thanks,
> 
> greg k-h

Hi,

I've sent it over at [1]. I hope I did it correctly as this is the first time I'm formally sending over a patch (even if it's not mine). Please let me know if I did anything wrong and things that I can do to correct them :). I've also opted to add a `Tested-by` tag in response to "a tested series". Reminder that I only built the kernels, and had another user test that build since I don't have an affected device, so feel free to drop it if its wrong.

-- 
Regards,
  Eric

[1] https://lore.kernel.org/stable/20250521165421.293820-1-dnaim@cachyos.org
