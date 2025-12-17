Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013962D6630
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 06:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765952324; cv=none; b=ciquSf2k/Bhdv2Dpx1p8d1yVHKFsIHf8LPCOBPWifV/7TA1DIEUmenQCvCi6f/loUlhmg+xemGrFnLUDTJkcDk0e5ruR4aNbZNXgUUTutqF3cjUzo8HSWwFYzspNoAupYOCR5HLUBoE1S0GIKwCknBZWMHzI+q5MTqBQ7kMTcpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765952324; c=relaxed/simple;
	bh=5E1K9C9kMeHgrRGvXrccHUBPamEjlYpdGdFfITwpnsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xb99OpzDXoRQsXymMKDqVRiZu7mnF36626PtxadgpMcJhYBeSOHpu1ZBphf7NMYh8xxIN6iPhTwKOuXVfHhLT+l1xl9EpjDgF3BNynxl7BNN1s9nsrMwCSlcnqfTo+OJw+kEuZB+SjIxpimwtD+WGQxiSl2WtSvzG+k2wWtS670=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=Pl48x2pf; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="Pl48x2pf"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-649728a2228so7225814a12.3
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 22:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765952317; x=1766557117; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrSlAe7WWUo/2vXHbMf9FsTjgVv0tt/x0XqJ/n/+S1A=;
        b=Pl48x2pfbRRUxKURirSRqZSCUREkXTk1dReZMAnQWYdrssmyGQlOOGg0NWq+qNIm5P
         Lkpcy868UCC7VazL7ZC3gBZLPcnyZqO02NwT88vDi9/ZaDtxsW6dOsQNPDRo37APR953
         bBa8p0XRaPA4KHWz1mqPRBKxxQlHnz5xjg4GD7rrx1765SRyagUqRuY9ppDSJqRGd1VQ
         1Nl0QyDfeYIj8B7zI0AZBKrpHPOdYN0f3jr+ZqxmfVe6jIGp5PGAj1Uc9cCn5jvvcLYP
         Hlr8hqtdHqgXpNb8a0+dp3BxikySmlO3MMQ065wDfQyepP2xEUGKMdxXV2bh7Q1+ueiL
         /sZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765952317; x=1766557117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IrSlAe7WWUo/2vXHbMf9FsTjgVv0tt/x0XqJ/n/+S1A=;
        b=lkfyjK8eC17VvsSCfaAwAEInPY2uZ/Y1AwUV5QLBzbSkpGqzmpqsELQ9Dk759GbV2A
         lvCZVHZVLYnZzN+OqjoW32iW7n1i7IBKzHcWiAkqekyDZ78DdL8BdFy1yaKY/RQ4o5w5
         wlVic0YxZDJcksy4v0YlmAPz4HLANqlQPExHgJ9R4Ah1MRN52KpBcbuPjnY8sH3Vswlh
         lDobPJvK/6oYsqiIQ37i2eJ5BC9iqwh2euyEwUzvFpffeGx7NFU2e1aLMwEsNSdV3k3W
         XawphIRric2fErnRK35hX5TSt/9wQudakCTcNqHtK9rd86uRFxbGm4xgeUAoV6f8bbzp
         VXWg==
X-Forwarded-Encrypted: i=1; AJvYcCUTVeMUQ6R6gceN1tW7CtCu8TGlxDcxwZRU7cv2AluyUoSLtQlzto6eyAVPXDehRJcNCJrR+WJv@lists.linux.dev
X-Gm-Message-State: AOJu0YzKYlkOmPxDRgA53eVL4u3VcZDQnzch4pal+s5DM6TTbb2ar/oP
	goadds0fiHo6Ulb5jOgje6pkHQfaA4c7nVT2fXxzO9tF85ef/umV/T2Vi25qM8wm5n27/6pVSyq
	6P9og7NWMbv/1CxUisrw+pnZmqisv3p4t3iiojXuxLQ==
X-Gm-Gg: AY/fxX4P6La9CC6JuxvOWnoaEDtkxzv5Fxpr7hx8CLX1EefU9be8Psi1P0KHQZ+3iku
	5wLAa6cSv3fVGczsxizJ5fJnpnjZzPSYme4I4hCQqR9XcEmsavda5c1bosV/tGNHw72nKMW3Cwu
	ps696k+lyiyr3HV5inZ024hlg1E+lXkfn5AutpXmIupdz+HdFmY7Hf5coPQAzXX5n/Nfgp2ND6R
	RujBlu3jCBr0JMQvfY2nvDANofFxaJFOw1NcHZUGC68xhk2t107GtHq5v5upXjMtByupKA=
X-Google-Smtp-Source: AGHT+IHv04nlHUjTEvD2MgOcCugXbQZWggJwvbxYm+wXtuffuH5j8gw1hNPlHbJdzhzqHB3NDVD9h3AK1PnG73WjBc0=
X-Received: by 2002:a17:907:9451:b0:b77:1a42:d5c0 with SMTP id
 a640c23a62f3a-b7d23a22b69mr1977813166b.43.1765952315754; Tue, 16 Dec 2025
 22:18:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111401.280873349@linuxfoundation.org>
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 17 Dec 2025 11:47:58 +0530
X-Gm-Features: AQt7F2p1Q5ghRkT3weZTQ_zvqpvtHvgBd6nmPKMj8X4OZcAurN0XZi5wNFXJljM
Message-ID: <CAG=yYwkzRwFezEUw6Lh6LfYqvSUw6DiYQcYXCQ4ic1WvUW8eeQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
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

hello

Compiled and booted  6.18.2-rc1+

No typical new regressions   from dmesg.

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology

On Tue, Dec 16, 2025 at 9:53=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
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
>     Linux 6.18.2-rc1
>
> Junrui Luo <moonafterrain@outlook.com>
>     ALSA: wavefront: Fix integer overflow in sample size validation
>
> Junrui Luo <moonafterrain@outlook.com>
>     ALSA: wavefront: Clear substream pointers on close
>
> Denis Arefev <arefev@swemel.ru>
>     ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_=
acpi()
>
> Antheas Kapenekakis <lkml@antheas.dev>
>     ALSA: hda/tas2781: fix speaker id retrieval for multiple probes
>
> Antheas Kapenekakis <lkml@antheas.dev>
>     ALSA: hda/realtek: Add match for ASUS Xbox Ally projects
>
> Junrui Luo <moonafterrain@outlook.com>
>     ALSA: dice: fix buffer overflow in detect_stream_formats()
>
> Sven Peter <sven@kernel.org>
>     usb: dwc3: dwc3_power_off_all_roothub_ports: Use ioremap_np when requ=
ired
>
> Duoming Zhou <duoming@zju.edu.cn>
>     usb: typec: ucsi: fix use-after-free caused by uec->work
>
> Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
>     usb: phy: Initialize struct usb_phy list_head
>
> Duoming Zhou <duoming@zju.edu.cn>
>     usb: typec: ucsi: fix probe failure in gaokun_ucsi_probe()
>
> Haotien Hsu <haotienh@nvidia.com>
>     usb: gadget: tegra-xudc: Always reinitialize data toggle when clear h=
alt
>
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     efi/cper: align ARM CPER type with UEFI 2.9A/2.10 specs
>
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     efi/cper: Adjust infopfx size to accept an extra space
>
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     efi/cper: Add a new helper function to print bitmasks
>
> Evan Li <evan.li@linux.alibaba.com>
>     perf/x86/intel: Fix NULL event dereference crash in handle_pmi_common=
()
>
> Dmitry Antipov <dmantipov@yandex.ru>
>     ocfs2: fix memory leak in ocfs2_merge_rec_left()
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>     cpu: Make atomic hotplug callbacks run with interrupts disabled on UP
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     irqchip/mchp-eic: Fix error code in mchp_eic_domain_alloc()
>
> Thaumy Cheng <thaumy.love@gmail.com>
>     perf/core: Fix missing read event generation on task exit
>
> Bart Van Assche <bvanassche@acm.org>
>     scsi: ufs: core: Fix an error handler crash
>
> Duoming Zhou <duoming@zju.edu.cn>
>     scsi: imm: Fix use-after-free bug caused by unfinished delayed work
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     dm log-writes: Add missing set_freezable() for freezable kthread
>
> Alexey Simakov <bigalex934@gmail.com>
>     dm-raid: fix possible NULL dereference with undefined raid type
>
> Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>
>     ASoC: amd: acp: update tdm channels for specific DAI
>
> Mohamed Khalfella <mkhalfella@purestorage.com>
>     block: Use RCU in blk_mq_[un]quiesce_tagset() instead of set->tag_lis=
t_lock
>
> Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
>     drm/i915/fbdev: Hold runtime PM ref during fbdev BO creation
>
> Jani Nikula <jani.nikula@intel.com>
>     drm/{i915, xe}/fbdev: deduplicate struct drm_mode_fb_cmd2 init
>
> Jani Nikula <jani.nikula@intel.com>
>     drm/{i915, xe}/fbdev: pass struct drm_device to intel_fbdev_fb_alloc(=
)
>
> Jani Nikula <jani.nikula@intel.com>
>     drm/i915/fbdev: make intel_framebuffer_create() error return handling=
 explicit
>
> Jani Nikula <jani.nikula@intel.com>
>     drm/xe/fbdev: use the same 64-byte stride alignment as i915
>
> Liyuan Pang <pangliyuan1@huawei.com>
>     ARM: 9464/1: fix input-only operand modification in load_unaligned_ze=
ropad()
>
> Junrui Luo <moonafterrain@outlook.com>
>     ALSA: firewire-motu: add bounds check in put_user loop for DSP events
>
> Javier Martinez Canillas <javierm@redhat.com>
>     regulator: spacemit: Align input supply name with the DT binding
>
> Nuno S=C3=A1 <nuno.sa@analog.com>
>     rtc: max31335: Fix ignored return value in set_alarm
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     rtc: gamecube: Check the return value of ioremap()
>
> Xiaogang Chen <xiaogang.chen@amd.com>
>     drm/amdkfd: Use huge page size to check split svm range alignment
>
> Andres J Rosa <andyrosa@gmail.com>
>     ALSA: uapi: Fix typo in asound.h comment
>
> Dave Kleikamp <dave.kleikamp@oracle.com>
>     dma/pool: eliminate alloc_pages warning in atomic_pool_expand
>
> Troy Mitchell <troy.mitchell@linux.spacemit.com>
>     i2c: spacemit: fix detect issue
>
> Kathara Sasikumar <katharasasikumar007@gmail.com>
>     docs: hwmon: fix link to g762 devicetree binding
>
> Arnd Bergmann <arnd@arndb.de>
>     gpio: tb10x: fix OF_GPIO dependency
>
> Mike Snitzer <snitzer@kernel.org>
>     nfs/localio: remove 61 byte hole from needless ____cacheline_aligned
>
> Mike Snitzer <snitzer@hammerspace.com>
>     nfs/localio: remove alignment size checking in nfs_is_local_dio_possi=
ble
>
> David Howells <dhowells@redhat.com>
>     cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB2
>
> David Howells <dhowells@redhat.com>
>     cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB1
>
> Ren=C3=A9 Rebe <rene@exactco.de>
>     drm/nouveau: fix circular dep oops from vendored i2c encoder
>
> Madhur Kumar <madhurkumar004@gmail.com>
>     drm/nouveau: refactor deprecated strcpy
>
> Junrui Luo <moonafterrain@outlook.com>
>     ALSA: firewire-motu: fix buffer overflow in hwdep read for DSP events
>
> Mark Brown <broonie@kernel.org>
>     regulator: fixed: Rely on the core freeing the enable GPIO
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     drm/plane: Fix IS_ERR() vs NULL check in drm_plane_create_hotspot_pro=
perties()
>
> Caleb Sander Mateos <csander@purestorage.com>
>     io_uring/kbuf: use READ_ONCE() for userspace-mapped memory
>
> Israel Rukshin <israelr@nvidia.com>
>     nvme-auth: use kvfree() for memory allocated with kvcalloc()
>
> Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
>     block: fix memory leak in __blkdev_issue_zero_pages
>
> shechenglong <shechenglong@xfusion.com>
>     block: fix comment for op_is_zone_mgmt() to include RESET_ALL
>
> Arnd Bergmann <arnd@arndb.de>
>     drm/panel: novatek-nt35560: avoid on-stack device structure
>
> Cong Zhang <cong.zhang@oss.qualcomm.com>
>     blk-mq: Abort suspend when wakeup events are pending
>
> Daeho Jeong <daehojeong@google.com>
>     f2fs: revert summary entry count from 2048 to 512 in 16kb block suppo=
rt
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Disable regulator when error happens
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Disable regulator when error happens
>
> Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>
>     ASoC: amd: acp: Audio is not resuming after s0ix
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configu=
re()
>
> Anton Khirnov <anton@khirnov.net>
>     platform/x86: asus-wmi: use brightness_set_blocking() for kbd led
>
> Armin Wolf <W_Armin@gmx.de>
>     fs/nls: Fix inconsistency between utf8_to_utf32() and utf32_to_utf8()
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Fix inheritance of the block sizes when automounting
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flag=
s
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     Revert "nfs: ignore SB_RDONLY when mounting nfs"
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     Revert "nfs: clear SB_RDONLY before getting superblock"
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     Revert "nfs: ignore SB_RDONLY when remounting nfs"
>
> Akash Goel <akash.goel@arm.com>
>     drm/panthor: Prevent potential UAF in group creation
>
> Jonathan Curley <jcurley@purestorage.com>
>     NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_in=
valid
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Initialise verifiers for visible dentries in _nfs4_open_and_get_=
state
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Initialise verifiers for visible dentries in nfs_atomic_open()
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Initialise verifiers for visible dentries in readdir and lookup
>
> Armin Wolf <W_Armin@gmx.de>
>     fs/nls: Fix utf16 to utf8 conversion
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Avoid changing nlink when file removes and attribute updates rac=
e
>
> Abel Vesa <abel.vesa@linaro.org>
>     kbuild: install-extmod-build: Properly fix CC expansion when ccache i=
s used
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     rtc: amlogic-a4: fix double free caused by devm
>
> Daeho Jeong <daehojeong@google.com>
>     f2fs: maintain one time GC mode is enabled during whole zoned GC cycl=
e
>
> Xi Pardee <xi.pardee@linux.intel.com>
>     platform/x86:intel/pmc: Update Arrow Lake telemetry GUID
>
> John Stultz <jstultz@google.com>
>     sched/core: Fix psi_dequeue() for Proxy Execution
>
> xupengbo <xupengbo@oppo.com>
>     sched/fair: Fix unfairness caused by stalled tg_load_avg_contrib when=
 the last task migrates out
>
> Eric Sandeen <sandeen@redhat.com>
>     9p: fix cache/debug options printing in v9fs_show_options
>
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()
>
> Ian Rogers <irogers@google.com>
>     perf stat: Allow no events to open if this is a "--null" run
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     pinctrl: single: Fix incorrect type for error return variable
>
> Ian Rogers <irogers@google.com>
>     perf hist: In init, ensure mem_info is put on error paths
>
> Ian Rogers <irogers@google.com>
>     perf kvm: Fix debug assertion
>
> Namhyung Kim <namhyung@kernel.org>
>     perf tools: Fix split kallsyms DSO counting
>
> Namhyung Kim <namhyung@kernel.org>
>     perf tools: Mark split kallsyms DSOs as loaded
>
> Namjae Jeon <linkinjeon@kernel.org>
>     exfat: fix divide-by-zero in exfat_allocate_bitmap
>
> Shuhao Fu <sfual@cse.ust.hk>
>     exfat: fix refcount leak in exfat_find
>
> Namhyung Kim <namhyung@kernel.org>
>     perf jitdump: Add sym/str-tables to build-ID generation
>
> Xiang Mei <xmei5@asu.edu>
>     net/sched: sch_cake: Fix incorrect qlen reduction in cake_drop
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: dsa: xrs700x: reject unsupported HSR configurations
>
> Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
>     net: hsr: create an API to get hsr port type
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: fix BCM5325/65 ARL entry VIDs
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: fix BCM5325/65 ARL entry multicast port masks
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: add support for bcm63xx ARL entry format
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: fix CPU port unicast ARL entries for BCM5325/65
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: use same ARL search result offset for BCM5325/65
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: add support for 5389/5397/5398 ARL entry format
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: move ARL entry functions into ops struct
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: split reading search entry into their own functions
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: provide accessors for accessing ARL_SRCH_CTL
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: move writing ARL entries into their own functions
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: move reading ARL entries into their own function
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: b53_arl_read{,25}(): use the entry for comparision
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: fix extracting VID from entry for BCM5325/65
>
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: fix VLAN_ID_IDX write size for BCM5325/65
>
> Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>     um: Disable KASAN_INLINE when STATIC_LINK is selected
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_do=
ne() and smbd_conn_upcall()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_do=
ne() and smb_direct_cm_handler()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
>
> Johan Hovold <johan@kernel.org>
>     clk: keystone: fix compile testing
>
> Yu Kuai <yukuai@fnnas.com>
>     md/raid5: fix IO hang when array is broken with IO inflight
>
> Alexandru Gagniuc <mr.nuke.me@gmail.com>
>     remoteproc: qcom_q6v5_wcss: fix parsing of qcom,halt-regs
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>     rqspinlock: Use trylock fallback when per-CPU rqnode is busy
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>     rqspinlock: Enclose lock/unlock within lock entry acquisitions
>
> Ivan Stepchenko <sid@itb.spb.ru>
>     mtd: lpddr_cmds: fix signed shifts in lpddr_cmds
>
> Breno Leitao <leitao@debian.org>
>     net: netpoll: initialize work queue before error checks
>
> Hangbin Liu <liuhangbin@gmail.com>
>     selftests: bonding: add delay before each xvlan_over_bond connectivit=
y check
>
> Robert Marko <robimarko@gmail.com>
>     net: phy: aquantia: check for NVMEM deferral
>
> Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>     landlock: Fix handling of disconnected directories
>
> Alex Williamson <alex.williamson@nvidia.com>
>     vfio/pci: Use RCU for error/request triggers to avoid circular lockin=
g
>
> Dev Jain <dev.jain@arm.com>
>     arm64/pageattr: Propagate return value from __change_memory_common
>
> Tianchu Chen <flynnnchen@tencent.com>
>     spi: ch341: fix out-of-bounds memory access in ch341_transfer_one
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     mtd: rawnand: renesas: Handle devm_pm_runtime_enable() errors
>
> Alexey Kodanev <aleksei.kodanev@bell-sw.com>
>     net: stmmac: fix rx limit check in stmmac_rx_zc()
>
> Antoine Tenart <atenart@kernel.org>
>     net: vxlan: prevent NULL deref in vxlan_xmit_one
>
> Michal Schmidt <mschmidt@redhat.com>
>     iavf: Implement settime64 with -EOPNOTSUPP
>
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: nft_connlimit: update the count if add was skipped
>
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: nf_conncount: rework API to use sk_buff directly
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: flowtable: check for maximum number of encapsulations in b=
ridge vlan
>
> Ilias Stamatis <ilstam@amazon.com>
>     Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res=
()"
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8195: Fix address range for JPEG decoder core=
 1
>
> sparkhuang <huangshaobo3@xiaomi.com>
>     regulator: core: Protect regulator_supply_alias_list with regulator_l=
ist_mutex
>
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ARM: dts: samsung: exynos4412-midas: turn off SDIO WLAN chip during s=
ystem suspend
>
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ARM: dts: samsung: exynos4210-trats: turn off SDIO WLAN chip during s=
ystem suspend
>
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ARM: dts: samsung: exynos4210-i9100: turn off SDIO WLAN chip during s=
ystem suspend
>
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ARM: dts: samsung: universal_c210: turn off SDIO WLAN chip during sys=
tem suspend
>
> Marek Szyprowski <m.szyprowski@samsung.com>
>     soc: samsung: exynos-pmu: Fix structure initialization
>
> Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
>     spi: airoha-snfi: en7523: workaround flash damaging if UART_TXD was s=
hort to GND
>
> Cezary Rojewski <cezary.rojewski@intel.com>
>     ASoC: Intel: catpt: Fix error path in hw_params()
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: clean up features qword/dword terms
>
> Alok Tiwari <alok.a.tiwari@oracle.com>
>     vdpa/pds: use %pe for ERR_PTR() in event handler registration
>
> Mike Christie <michael.christie@oracle.com>
>     vhost: Fix kthread worker cgroup failure handling
>
> Alok Tiwari <alok.a.tiwari@oracle.com>
>     vdpa/mlx5: Fix incorrect error code reporting in query_virtqueues
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: fix map ops comment
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: fix virtqueue_set_affinity() docs
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: standardize Returns documentation style
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: fix grammar in virtio_map_ops docs
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: fix grammar in virtio_queue_info docs
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: fix whitespace in virtio_config_ops
>
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: fix typo in virtio_device_ready() comment
>
> Kriish Sharma <kriish.sharma2006@gmail.com>
>     virtio: fix kernel-doc for mapping/free_coherent functions
>
> Alok Tiwari <alok.a.tiwari@oracle.com>
>     virtio_vdpa: fix misleading return in void function
>
> Guenter Roeck <linux@roeck-us.net>
>     of: Skip devicetree kunit tests when RISCV+ACPI doesn't populate root=
 node
>
> Willem de Bruijn <willemb@google.com>
>     selftests/net: packetdrill: pass send_omit_free to MSG_ZEROCOPY tests
>
> Yongjian Sun <sunyongjian1@huawei.com>
>     ext4: improve integrity checking in __mb_check_buddy by enhancing ord=
er-0 validation
>
> Edward Adam Davis <eadavis@qq.com>
>     bpf: Fix exclusive map memory leak
>
> Matthieu Buffet <matthieu@buffet.re>
>     selftests/landlock: Fix makefile header list
>
> Kevin Brodsky <kevin.brodsky@arm.com>
>     ublk: prevent invalid access with DEBUG
>
> Ren=C3=A9 Rebe <rene@exactco.de>
>     ACPI: processor_core: fix map_x2apic_id for amd-pstate on am4
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     hwmon: sy7636a: Fix regulator_enable resource leak on error path
>
> Eric Huang <jinhuieric.huang@amd.com>
>     drm/amdkfd: assign AID to uuid in topology for SPX mode
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     drm/amd/display: Fix logical vs bitwise bug in get_embedded_panel_inf=
o_v2_1()
>
> Will Rosenberg <whrosenb@asu.edu>
>     kernfs: fix memory leak of kernfs_iattrs in __kernfs_new_node
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     misc: rp1: Fix an error handling path in rp1_probe()
>
> Christoph Hellwig <hch@lst.de>
>     fs: lift the FMODE_NOCMTIME check into file_update_time_flags
>
> Christoph Hellwig <hch@lst.de>
>     fs: refactor file timestamp update logic
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     greybus: gb-beagleplay: Fix timeout handling in bootloader functions
>
> Alexandre Courbot <acourbot@nvidia.com>
>     firmware_loader: make RUST_FW_LOADER_ABSTRACTIONS select FW_LOADER
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_xcvr: clear the channel status control memory
>
> Andreas Gruenbacher <agruenba@redhat.com>
>     gfs2: Prevent recursive memory reclaim
>
> Jaroslav Kysela <perex@perex.cz>
>     ASoC: nau8325: add missing build config
>
> Jaroslav Kysela <perex@perex.cz>
>     ASoC: nau8325: use simple i2c probe function
>
> Johan Hovold <johan@kernel.org>
>     clocksource/drivers/nxp-stm: Prevent driver unbind
>
> Johan Hovold <johan@kernel.org>
>     clocksource/drivers/nxp-stm: Fix section mismatches
>
> Johan Hovold <johan@kernel.org>
>     clocksource/drivers/nxp-pit: Prevent driver unbind
>
> Johan Hovold <johan@kernel.org>
>     clocksource/drivers/arm_arch_timer_mmio: Prevent driver unbind
>
> Johan Hovold <johan@kernel.org>
>     clocksource/drivers/stm: Fix double deregistration on probe failure
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     clocksource/drivers/ralink: Fix resource leaks in init error path
>
> Akash Goel <akash.goel@arm.com>
>     drm/panthor: Avoid adding of kernel BOs to extobj list
>
> Guillaume La Roque <glaroque@baylibre.com>
>     arm64: dts: amlogic: meson-g12b: Fix L2 cache reference for S922X CPU=
s
>
> Jijun Wang <jijun.wang@intel.com>
>     RDMA/irdma: Fix SRQ shadow area address initialization
>
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Remove doorbell elision logic
>
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Do not set IBK_LOCAL_DMA_LKEY for GEN3+
>
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Do not directly rely on IB_PD_UNSAFE_GLOBAL_RKEY
>
> Anil Samal <anil.samal@intel.com>
>     RDMA/irdma: Add missing mutex destroy
>
> Krzysztof Czurylo <krzysztof.czurylo@intel.com>
>     RDMA/irdma: Fix SIGBUS in AEQ destroy
>
> Tatyana Nikolova <tatyana.e.nikolova@intel.com>
>     RDMA/irdma: Add a missing kfree of struct irdma_pci_f for GEN2
>
> Krzysztof Czurylo <krzysztof.czurylo@intel.com>
>     RDMA/irdma: Fix data race in irdma_free_pble
>
> Krzysztof Czurylo <krzysztof.czurylo@intel.com>
>     RDMA/irdma: Fix data race in irdma_sc_ccq_arm
>
> Stephan Gerhold <stephan.gerhold@linaro.org>
>     iommu/arm-smmu-qcom: Enable use of all SMR groups when running bare-m=
etal
>
> Randy Dunlap <rdunlap@infradead.org>
>     backlight: lp855x: Fix lp855x.h kernel-doc warnings
>
> Luca Ceresoli <luca.ceresoli@bootlin.com>
>     backlight: led-bl: Add devlink to supplier LEDs
>
> Ria Thomas <ria.thomas@morsemicro.com>
>     wifi: ieee80211: correct FILS status codes
>
> Christoph Hellwig <hch@lst.de>
>     iomap: allocate s_dio_done_wq for async reads as well
>
> Christoph Hellwig <hch@lst.de>
>     iomap: always run error completions in user context
>
> David Gow <davidgow@google.com>
>     um: Don't rename vmap to kernel_vmap
>
> Timur Tabi <ttabi@nvidia.com>
>     drm/nouveau: restrict the flush page to a 32-bit address
>
> Shawn Lin <shawn.lin@rock-chips.com>
>     PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix leaf leak in an error path in btrfs_del_items()
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: make sure extent and csum paths are always released in scrub_r=
aid56_parity_stripe()
>
> Boris Burkov <boris@bur.io>
>     btrfs: fix racy bitfield write in btrfs_clear_space_info_full()
>
> Miquel Sabat=C3=A9 Sol=C3=A0 <mssola@mssola.com>
>     btrfs: fix double free of qgroup record after failure to add delayed =
ref head
>
> Alan Maguire <alan.maguire@oracle.com>
>     selftests/bpf: Allow selftests to build with older xxd
>
> Alan Maguire <alan.maguire@oracle.com>
>     bpftool: Allow bpftool to build with openssl < 3
>
> Ryan Huang <tzukui@google.com>
>     iommu/arm-smmu-v3: Fix error check in arm_smmu_alloc_cd_tables
>
> Jianglei Nie <niejianglei2021@163.com>
>     staging: fbtft: core: fix potential memory leak in fbtft_probe_common=
()
>
> Dinh Nguyen <dinguyen@kernel.org>
>     firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc
>
> Zilin Guan <zilin@seu.edu.cn>
>     mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta_add()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: mt7996: Add missing locking in mt7996_mac_sta_rc_work()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: mt7996: skip ieee80211_iter_keys() on scanning link remov=
e
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: mt7996: skip deflink accounting for offchannel links
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: Move mt76_abort_scan out of mt76_reset_device()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: mt7996: grab mt76 mutex in mt7996_mac_sta_event()
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: fix EMI rings for RRO
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: fix using wrong phy to start in mt7996_mac_restar=
t()
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: fix MLO set key and group key issues
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: fix MLD group index assignment
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: set link_valid field when initializing wcid
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: fix teardown command for an MLD peer
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: fix several fields in mt7996_mcu_bss_basic_tlv()
>
> Howard Hsu <howard-yh.hsu@mediatek.com>
>     wifi: mt76: mt7996: fix implicit beamforming support for mt7992
>
> StanleyYP Wang <StanleyYP.Wang@mediatek.com>
>     wifi: mt76: mt7996: fix max nss value when getting rx chainmask
>
> Fedor Pchelkin <pchelkin@ispras.ru>
>     Revert "wifi: mt76: mt792x: improve monitor interface handling"
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: mt7996: Remove useless check in mt7996_msdu_page_get_from=
_cache()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: wed: use proper wed reference in mt76 wed driver callabac=
ks
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: mt7996: Remove unnecessary link_id checks in mt7996_tx
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7996: fix null pointer deref in mt7996_conf_tx()
>
> Shenghao Ding <shenghao-ding@ti.com>
>     ASoC: tas2781: correct the wrong period
>
> Baojun Xu <baojun.xu@ti.com>
>     ASoC: tas2781: Correct the wrong chip ID for reset variable check
>
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: ahash - Zero positive err value in ahash_update_finish
>
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: ahash - Fix crypto_ahash_import with partial block data
>
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Pass correct flag for dma mr creation
>
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Fix the inline size for GenP7 devices
>
> Gao Xiang <xiang@kernel.org>
>     erofs: limit the level of fs stacking for file-backed mounts
>
> Gao Xiang <xiang@kernel.org>
>     erofs: correct FSDAX detection
>
> Fangyu Yu <fangyu.yu@linux.alibaba.com>
>     RISC-V: KVM: Fix guest page fault within HLV* instructions
>
> Pengjie Zhang <zhangpengjie2@huawei.com>
>     PM / devfreq: hisi: Fix potential UAF in OPP handling
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     crypto: ccree - Correctly handle return of sg_nents_for_len
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     crypto: starfive - Correctly handle return of sg_nents_for_len
>
> Martin Teichmann <martin.teichmann@xfel.eu>
>     bpf: properly verify tail call behavior
>
> Xing Guo <higuoxing@gmail.com>
>     selftests/bpf: Update test_tag to use sha256
>
> Matt Bobrowski <mattbobrowski@google.com>
>     selftests/bpf: Improve reliability of test_perf_branches_no_hw()
>
> Matt Bobrowski <mattbobrowski@google.com>
>     selftests/bpf: skip test_perf_branches_hw() on unsupported platforms
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     regulator: pca9450: Fix error code in probe()
>
> Gopi Krishna Menon <krishnagopi487@gmail.com>
>     usb: raw-gadget: cap raw_io transfer length to KMALLOC_MAX_SIZE
>
> Jisheng Zhang <jszhang@kernel.org>
>     usb: dwc2: fix hang during suspend if set as peripheral
>
> Jisheng Zhang <jszhang@kernel.org>
>     usb: dwc2: fix hang during shutdown if set as peripheral
>
> Oliver Neukum <oneukum@suse.com>
>     usb: chaoskey: fix locking for O_NONBLOCK
>
> Zhao Yipeng <zhaoyipeng5@huawei.com>
>     ima: Handle error code returned by ima_filter_rule_match()
>
> Ivan Pravdin <ipravdin.official@gmail.com>
>     rtla: Fix -a overriding -t argument
>
> Tomas Glozar <tglozar@redhat.com>
>     rtla/tests: Fix osnoise test calling timerlat
>
> Tomas Glozar <tglozar@redhat.com>
>     rtla/tests: Extend action tests to 5s
>
> Jason Tian <jason@os.amperecomputing.com>
>     RAS: Report all ARM processor CPER information to userspace
>
> Seungjin Bae <eeodqql09@gmail.com>
>     wifi: rtl818x: rtl8187: Fix potential buffer underflow in rtl8187_rx_=
cb()
>
> Charles Mirabile <cmirabil@redhat.com>
>     clk: spacemit: Set clk_hw_onecell_data::num before using flex array
>
> Chen Ridong <chenridong@huawei.com>
>     cpuset: Treat cpusets in attaching as populated
>
> Alexander Dahl <ada@thorsis.com>
>     net: phy: adin1100: Fix software power-down ready condition
>
> Matt Bobrowski <mattbobrowski@google.com>
>     selftests/bpf: Use ASSERT_STRNEQ to factor in long slab cache names
>
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: SDCA: Fix missing dash in HIDE DisCo property
>
> Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>     phy: rockchip: samsung-hdptx: Prevent Inter-Pair Skew from exceeding =
the limits
>
> Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>     phy: rockchip: samsung-hdptx: Reduce ROPLL loop bandwidth
>
> Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>     phy: rockchip: samsung-hdptx: Fix reported clock rate in high bpc mod=
e
>
> Xiaolei Wang <xiaolei.wang@windriver.com>
>     phy: freescale: Initialize priv->lock
>
> Shawn Lin <shawn.lin@rock-chips.com>
>     phy: rockchip: naneng-combphy: Fix PCIe L1ss support RK3562
>
> Shawn Lin <shawn.lin@rock-chips.com>
>     phy: rockchip: naneng-combphy: Fix PCIe L1ss support RK3528
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     phy: renesas: rcar-gen3-usb2: Fix an error handling path in rcar_gen3=
_phy_usb2_probe()
>
> Fenglin Wu <fenglin.wu@oss.qualcomm.com>
>     leds: rgb: leds-qcom-lpg: Don't enable TRILED when configuring PWM
>
> Yuntao Wang <yuntao.wang@linux.dev>
>     of/fdt: Fix incorrect use of dt_root_addr_cells in early_init_dt_chec=
k_kho()
>
> Yuntao Wang <yuntao.wang@linux.dev>
>     of/fdt: Fix the len check in early_init_dt_check_for_usable_mem_range=
()
>
> Yuntao Wang <yuntao.wang@linux.dev>
>     of/fdt: Fix the len check in early_init_dt_check_for_elfcorehdr()
>
> Yuntao Wang <yuntao.wang@linux.dev>
>     of/fdt: Consolidate duplicate code into helper functions
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     mfd: mt6397-irq: Fix missing irq_domain_remove() in error path
>
> Tomas Glozar <tglozar@redhat.com>
>     tools/rtla: Fix --on-threshold always triggering
>
> Costa Shulyupin <costa.shul@redhat.com>
>     tools/rtla: Fix unassigned nr_cpus
>
> Chien Wong <m@xv97.com>
>     wifi: mac80211: fix CMAC functions not handling errors
>
> Aashish Sharma <aashish@aashishsharma.net>
>     iommu/vt-d: Fix unused invalidation hint in qi_desc_iotlb
>
> Vineeth Pillai (Google) <vineeth@bitbyteword.org>
>     iommu/vt-d: Set INTEL_IOMMU_FLOPPY_WA depend on BLK_DEV_FD
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: phy: realtek: create rtl8211f_config_rgmii_delay()
>
> Zilin Guan <zilin@seu.edu.cn>
>     scsi: qla2xxx: Fix improper freeing of purex item
>
> Shawn Lin <shawn.lin@rock-chips.com>
>     scsi: ufs: rockchip: Reset controller on PRE_CHANGE of hce enable not=
ify
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     pwm: bcm2835: Make sure the channel is enabled after pwm_request()
>
> Leo Yan <leo.yan@arm.com>
>     perf arm_spe: Fix memset subclass in operation
>
> Fernando Fernandez Mancera <fmancera@suse.de>
>     ipv6: clear RA flags when adding a static route
>
> Longbin Li <looong.bin@gmail.com>
>     spi: sophgo: Fix incorrect use of bus width value macros
>
> Akhil P Oommen <akhilpo@oss.qualcomm.com>
>     drm/msm/a6xx: Improve MX rail fallback in RPMH vote init
>
> Akhil P Oommen <akhilpo@oss.qualcomm.com>
>     drm/msm/a6xx: Fix the gemnoc workaround
>
> Akhil P Oommen <akhilpo@oss.qualcomm.com>
>     drm/msm/a6xx: Flush LRZ cache before PT switch
>
> Jay Liu <jay.liu@mediatek.com>
>     drm/mediatek: Fix CCORR mtk_ctm_s31_32_to_s1_n function issue
>
> Edward Adam Davis <eadavis@qq.com>
>     fs/ntfs3: Prevent memory leaks in add sub record
>
> Edward Adam Davis <eadavis@qq.com>
>     fs/ntfs3: out1 also needs to put mi
>
> Ovidiu Panait <ovidiu.panait.rb@renesas.com>
>     net: stmmac: Fix VLAN 0 deletion in vlan_del_hw_rx_fltr()
>
> Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>     powerpc/64s/ptdump: Fix kernel_hash_pagetable dump for ISA v3.00 HPTE=
 format
>
> Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>     powerpc/64s/hash: Restrict stress_hpt_struct memblock region to withi=
n RMA limit
>
> Pu Lehui <pulehui@huawei.com>
>     bpf: Fix invalid prog->stats access when update_effective_progs fails
>
> Inochi Amaoto <inochiama@gmail.com>
>     net: stmmac: dwmac-sophgo: Add phy interface filter
>
> Inochi Amaoto <inochiama@gmail.com>
>     net: phy: Add helper for fixing RGMII PHY mode based on internal mac =
delay
>
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     wifi: rtl818x: Fix potential memory leaks in rtl8180_init_rx_ring()
>
> Christian Bruel <christian.bruel@foss.st.com>
>     PCI: stm32: Fix EP page_size alignment
>
> Christian Bruel <christian.bruel@foss.st.com>
>     PCI: stm32: Fix LTSSM EP race with start link
>
> Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>     drm/msm/a2xx: stop over-complaining about the legacy firmware
>
> Huiwen He <hehuiwen@kylinos.cn>
>     drm/msm: fix missing NULL check after kcalloc in crashstate_get_bos()
>
> Huiwen He <hehuiwen@kylinos.cn>
>     drm/msm: Fix NULL pointer dereference in crashstate_get_vm_logs()
>
> Guenter Roeck <linux@roeck-us.net>
>     block/blk-throttle: Fix throttle slice time for SSDs
>
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     arm64: dts: imx95-tqma9596sa: reduce maximum FlexSPI frequency to 66M=
Hz
>
> Markus Niebel <Markus.Niebel@ew.tq-group.com>
>     arm64: dts: imx95-tqma9596sa: fix TPM5 pinctrl node name
>
> Sergey Bashirov <sergeybashirov@gmail.com>
>     NFSD/blocklayout: Fix minlength check in proc_layoutget
>
> Al Viro <viro@zeniv.linux.org.uk>
>     tracefs: fix a leak in eventfs_create_events_dir()
>
> Al Viro <viro@zeniv.linux.org.uk>
>     fuse_ctl_add_conn(): fix nlink breakage in case of early failure
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     iio: core: Clean up device correctly on iio_device_alloc() failure
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     iio: core: add missing mutex_destroy in iio_dev_release()
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     watchdog: starfive: Fix resource leak in probe error path
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     watchdog: wdat_wdt: Fix ACPI table leak in probe function
>
> Nuno Das Neves <nunodasneves@linux.microsoft.com>
>     mshv: Fix create memory region overlap check
>
> Nuno Das Neves <nunodasneves@linux.microsoft.com>
>     mshv: Fix deposit memory in MSHV_ROOT_HVCALL
>
> Martin KaFai Lau <martin.lau@kernel.org>
>     bpf: Check skb->transport_header is set in bpf_skb_check_mtu
>
> Alexei Starovoitov <ast@kernel.org>
>     selftests/bpf: Fix failure paths in send_signal test
>
> Menglong Dong <menglong8.dong@gmail.com>
>     bpf: Handle return value of ftrace_set_filter_ip in register_fentry
>
> Sahil Chandna <chandna.sahil@gmail.com>
>     bpf: Prevent nesting overflow in bpf_try_get_buffers
>
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>     kbuild: don't enable CC_CAN_LINK if the dummy program generates warni=
ngs
>
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     PCI: Prevent resource tree corruption when BAR resize fails
>
> Aaron Kling <webgeek1234@gmail.com>
>     soc/tegra: fuse: speedo-tegra210: Update speedo IDs
>
> Rene Rebe <rene@exactco.de>
>     ps3disk: use memcpy_{from,to}_bvec index
>
> Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>     drm/msm/dpu: drop dpu_hw_dsc_destroy() prototype
>
> Praveen Talari <praveen.talari@oss.qualcomm.com>
>     arm64: dts: qcom: qrb2210-rb1: Fix UART3 wakeup IRQ storm
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     pwm: Use %u to printf unsigned int pwm_chip::npwm and pwm_chip::id
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     pwm: Simplify printf to emit chip->npwm in $debugfs/pwm
>
> Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
>     s390/fpu: Fix false-positive kmsan report in fpu_vstl()
>
> Zilin Guan <zilin@seu.edu.cn>
>     crypto: iaa - Fix incorrect return value in save_iaa_wq()
>
> Ian Rogers <irogers@google.com>
>     perf vendor metrics s390: Avoid has_event(INSTRUCTIONS)
>
> FUKAUMI Naoki <naoki@radxa.com>
>     arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 3C
>
> FUKAUMI Naoki <naoki@radxa.com>
>     arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 5A
>
> FUKAUMI Naoki <naoki@radxa.com>
>     arm64: dts: rockchip: Move the EEPROM to correct I2C bus on Radxa ROC=
K 5A
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     soc: renesas: rz-sysc: Populate readable_reg/writeable_reg in regmap =
config
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     soc: renesas: r9a09g056-sys: Populate max_register
>
> Siddharth Vadapalli <s-vadapalli@ti.com>
>     PCI: keystone: Exit ks_pcie_probe() for invalid mode
>
> Leon Hwang <leon.hwang@linux.dev>
>     bpf: Free special fields when update [lru_,]percpu_hash maps
>
> Lizhi Hou <lizhi.hou@amd.com>
>     accel/amdxdna: Fix deadlock between context destroy and job timeout
>
> Lizhi Hou <lizhi.hou@amd.com>
>     accel/amdxdna: Clear mailbox interrupt register during channel creati=
on
>
> Chaitanya S Prakash <chaitanyas.prakash@arm.com>
>     arm64/mm: Allow __create_pgd_mapping() to propagate pgtable_alloc() e=
rrors
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     leds: netxbig: Fix GPIO descriptor leak in error paths
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     scsi: sim710: Fix resource leak by adding missing ioport_unmap() call=
s
>
> Tony Battersby <tonyb@cybernetics.com>
>     scsi: qla2xxx: Clear cmds after chip reset
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_e=
ndpoint()
>
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: use correct endian in ocfs2_dinode_has_extents
>
> Dmitry Antipov <dmantipov@yandex.ru>
>     ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     lib/vsprintf: Check pointer before dereferencing in time_and_date()
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     clk: renesas: r9a06g032: Fix memory leak in error path
>
> Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>     clk: renesas: r9a09g077: Propagate rate changes to parent clocks
>
> Jayesh Choudhary <j-choudhary@ti.com>
>     drm/tidss: Move OLDI mode validation to OLDI bridge mode_valid hook
>
> Jayesh Choudhary <j-choudhary@ti.com>
>     drm/tidss: Remove max_pclk_khz and min_pclk_khz from tidss display fe=
atures
>
> Namhyung Kim <namhyung@kernel.org>
>     perf tools: Fix missing feature check for inherit + SAMPLE_READ
>
> Leo Yan <leo.yan@arm.com>
>     coresight: etm4x: Properly control filter in CPU idle with FEAT_TRF
>
> Leo Yan <leo.yan@arm.com>
>     coresight: etm4x: Add context synchronization before enabling trace
>
> Leo Yan <leo.yan@arm.com>
>     coresight: etm4x: Correct polling IDLE bit
>
> Leo Yan <leo.yan@arm.com>
>     coresight: etm3x: Always set tracer's device mode on target CPU
>
> Leo Yan <leo.yan@arm.com>
>     coresight: etm4x: Always set tracer's device mode on target CPU
>
> Leo Yan <leo.yan@arm.com>
>     coresight: Change device mode to atomic type
>
> Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
>     fs/ntfs3: Initialize allocated memory before use
>
> David Wei <dw@davidwei.uk>
>     io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
>
> David Wei <dw@davidwei.uk>
>     net: export netdev_get_by_index_lock()
>
> Zheng Qixing <zhengqixing@huawei.com>
>     nbd: defer config unlock in nbd_genl_connect
>
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()
>
> Long Li <leo.lilong@huawei.com>
>     macintosh/mac_hid: fix race condition in mac_hid_toggle_emumouse
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/32: Fix unpaired stwcx. on interrupt exit
>
> Sourabh Jain <sourabhjain@linux.ibm.com>
>     powerpc/kdump: Fix size calculation for hot-removed memory ranges
>
> Gautham R. Shenoy <gautham.shenoy@amd.com>
>     cpufreq/amd-pstate: Call cppc_set_auto_sel() only for online CPUs
>
> Li Nan <linan122@huawei.com>
>     md: init bioset in mddev_init
>
> Li Nan <linan122@huawei.com>
>     md: delete md_redundancy_group when array is becoming inactive
>
> Bean Huo <beanhuo@micron.com>
>     scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_stri=
ng_desc()
>
> Akash Goel <akash.goel@arm.com>
>     drm/panthor: Fix potential memleak of vma structure
>
> Edward Adam Davis <eadavis@qq.com>
>     ntfs3: init run lock for extend inode
>
> Carl Worth <carl@os.amperecomputing.com>
>     coresight: tmc: add the handle of the event to the path
>
> Jihed Chaibi <jihed.chaibi.dev@gmail.com>
>     ARM: dts: stm32: stm32mp157c-phycore: Fix STMPE811 touchscreen node p=
roperties
>
> Ma Ke <make24@iscas.ac.cn>
>     RDMA/rtrs: server: Fix error handling in get_or_create_srv
>
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>     dt-bindings: PCI: amlogic: Fix the register name of the DBI region
>
> Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
>     iio: imu: bmi270: fix dev_err_probe error msg
>
> Johan Hovold <johan@kernel.org>
>     staging: most: remove broken i2c driver
>
> Mike McGowen <mike.mcgowen@microchip.com>
>     scsi: smartpqi: Fix device resources accessed after device removal
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     scsi: stex: Fix reboot_notifier leak in probe error path
>
> Zheng Qixing <zhengqixing@huawei.com>
>     nbd: defer config put in recv_work
>
> Xiao Ni <xni@redhat.com>
>     md: avoid repeated calls to del_gendisk
>
> Yun Zhou <yun.zhou@windriver.com>
>     md: fix rcu protection in md_wakeup_thread
>
> Xiao Ni <xni@redhat.com>
>     md: delete mddev kobj before deleting gendisk kobj
>
> Gabor Juhos <j4g8y7@gmail.com>
>     regulator: core: disable supply if enabling main regulator fails
>
> Dapeng Mi <dapeng1.mi@linux.intel.com>
>     perf/x86/intel: Correct large PEBS flag check
>
> Dapeng Mi <dapeng1.mi@linux.intel.com>
>     perf/x86: Fix NULL event access and potential PEBS record loss
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: use WRITE_ONCE for user shared memory
>
> FUKAUMI Naoki <naoki@radxa.com>
>     arm64: dts: rockchip: Fix USB Type-C host mode for Radxa ROCK 5B+/5T
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     hfs: fix potential use after free in hfs_correct_next_unused_CNID()
>
> Lizhi Hou <lizhi.hou@amd.com>
>     accel/amdxdna: Fix dma_fence leak when job is canceled
>
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: correct the checking of quota files before moving extents
>
> Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
>     wifi: ath12k: Fix timeout error during beacon stats retrieval
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     mfd: da9055: Fix missing regmap_del_irq_chip() in error path
>
> Namhyung Kim <namhyung@kernel.org>
>     perf annotate: Fix build with NO_SLANG=3D1
>
> Fedor Pchelkin <pchelkin@ispras.ru>
>     wifi: rtw89: usb: fix leak in rtw89_usb_write_port()
>
> Fedor Pchelkin <pchelkin@ispras.ru>
>     wifi: rtw89: usb: use common error path for skbs in rtw89_usb_rx_hand=
ler()
>
> Wang Liang <wangliang74@huawei.com>
>     locktorture: Fix memory leak in param_set_cpumask()
>
> Usama Arif <usamaarif642@gmail.com>
>     efi/libstub: Fix page table access in 5-level to 4-level paging trans=
ition
>
> Usama Arif <usamaarif642@gmail.com>
>     x86/boot: Fix page table access in 5-level to 4-level paging transiti=
on
>
> Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>
>     coresight: ETR: Fix ETR buffer use-after-free issue
>
> Niklas Cassel <cassel@kernel.org>
>     arm64: tegra: Add pinctrl definitions for pcie-ep nodes
>
> Peter Zijlstra <peterz@infradead.org>
>     entry,unwind/deferred: Fix unwind_reset_info() placement
>
> Jihed Chaibi <jihed.chaibi.dev@gmail.com>
>     ARM: dts: omap3: n900: Correct obsolete TWL4030 power compatible
>
> Jihed Chaibi <jihed.chaibi.dev@gmail.com>
>     ARM: dts: omap3: beagle-xm: Correct obsolete TWL4030 power compatible
>
> Yegor Yefremov <yegorslists@googlemail.com>
>     ARM: dts: am335x-netcom-plus-2xx: add missing GPIO labels
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     ARM: dts: am33xx: Add missing serial console speed
>
> Alan Maguire <alan.maguire@oracle.com>
>     libbpf: Fix parsing of multi-split BTF
>
> Vishwaroop A <va@nvidia.com>
>     spi: tegra210-quad: Fix timeout handling
>
> Matthew Brost <matthew.brost@intel.com>
>     drm/xe: Enforce correct user fence signaling order using
>
> Christian Brauner <brauner@kernel.org>
>     cleanup: fix scoped_class()
>
> Songtang Liu <liusongtang@bytedance.com>
>     iommu/amd: Fix potential out-of-bounds read in iommu_mmio_show
>
> Christian Brauner <brauner@kernel.org>
>     ns: initialize ns_list_node for initial namespaces
>
> Christian Brauner <brauner@kernel.org>
>     ns: add NS_COMMON_INIT()
>
> Thomas Richard (TI.com) <thomas.richard@bootlin.com>
>     firmware: ti_sci: Set IO Isolation only if the firmware is capable
>
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Fix UAF on kernel BO VA nodes
>
> Ketil Johnsen <ketil.johnsen@arm.com>
>     drm/panthor: Fix race with suspend during unplug
>
> Ketil Johnsen <ketil.johnsen@arm.com>
>     drm/panthor: Fix UAF race between device unplug and FW event processi=
ng
>
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Fix group_free_queue() for partially initialized queues
>
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Handle errors returned by drm_sched_entity_init()
>
> Tingmao Wang <m@maowtm.org>
>     fs/9p: Don't open remote file with APPEND mode when writeback cache i=
s used
>
> Mike Christie <michael.christie@oracle.com>
>     scsi: target: Fix LUN/device R/W and total command stats
>
> Bart Van Assche <bvanassche@acm.org>
>     scsi: target: Do not write NUL characters into ASCII configfs output
>
> Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
>     power: supply: apm_power: only unset own apm_get_power_status
>
> Val Packett <val@packett.cool>
>     power: supply: qcom_battmgr: support disabling charge control
>
> Val Packett <val@packett.cool>
>     power: supply: qcom_battmgr: clamp charge control thresholds
>
> Ivan Abramov <i.abramov@mt-integration.ru>
>     power: supply: wm831x: Check wm831x_set_bits() return value
>
> Murad Masimov <m.masimov@mt-integration.ru>
>     power: supply: rt9467: Prevent using uninitialized local variable in =
rt9467_set_value_from_ranges()
>
> Ivan Abramov <i.abramov@mt-integration.ru>
>     power: supply: rt9467: Return error on failure in rt9467_set_value_fr=
om_ranges()
>
> Ivan Abramov <i.abramov@mt-integration.ru>
>     power: supply: max17040: Check iio_read_channel_processed() return co=
de
>
> Ivan Abramov <i.abramov@mt-integration.ru>
>     power: supply: cw2015: Check devm_delayed_work_autocancel() return co=
de
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     power: supply: rt5033_charger: Fix device node reference leaks
>
> Frederic Weisbecker <frederic@kernel.org>
>     timers/migration: Fix imbalanced NUMA trees
>
> Frederic Weisbecker <frederic@kernel.org>
>     timers/migration: Remove locking on group connection
>
> Frederic Weisbecker <frederic@kernel.org>
>     timers/migration: Convert "while" loops to use "for"
>
> Taniya Das <taniya.das@oss.qualcomm.com>
>     clk: qcom: tcsrcc-glymur: Update register offsets for clock refs
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>     perf record: skip synthesize event when open evsel failed
>
> Namhyung Kim <namhyung@kernel.org>
>     perf lock contention: Load kernel map before lookup
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     drm/imagination: Fix reference to devm_platform_get_and_ioremap_resou=
rce()
>
> Christian Brauner <brauner@kernel.org>
>     cgroup: add cgroup namespace to tree after owner is set
>
> Marek Vasut <marek.vasut+renesas@mailbox.org>
>     arm64: dts: renesas: sparrow-hawk: Fix full-size DP connector node na=
me and labels
>
> Kuan-Wei Chiu <visitorckw@gmail.com>
>     interconnect: debugfs: Fix incorrect error handling for NULL path
>
> Lizhi Hou <lizhi.hou@amd.com>
>     accel/amdxdna: Fix incorrect command state for timed out job
>
> Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>     arm64: dts: qcom: msm8996: add interconnect paths to USB2 controller
>
> Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>     interconnect: qcom: msm8996: add missing link to SLAVE_USB_HS
>
> Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
>     wifi: ath12k: unassign arvif on scan vdev create failure
>
> Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
>     wifi: ath12k: enforce vdev limit in ath12k_mac_vdev_create()
>
> Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>     wifi: ath12k: fix error handling in creating hardware group
>
> Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>     wifi: ath12k: fix reusing m3 memory
>
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     wifi: ath12k: fix potential memory leak in ath12k_wow_arp_ns_offload(=
)
>
> Jacob Keller <jacob.e.keller@intel.com>
>     docs: kdoc: fix duplicate section warning message
>
> Arnd Bergmann <arnd@arndb.de>
>     random: use offstack cpumask when necessary
>
> Stanley Chu <yschu@nuvoton.com>
>     i3c: master: svc: Prevent incomplete IBI transaction
>
> Frank Li <Frank.Li@nxp.com>
>     i3c: fix refcount inconsistency in i3c_master_register
>
> Aniket Limaye <a-limaye@ti.com>
>     arm64: dts: ti: k3-j784s4: Fix I2C pinmux pull configuration
>
> Christian Brauner <brauner@kernel.org>
>     pidfs: add missing BUILD_BUG_ON() assert on struct pidfd_info
>
> Christian Brauner <brauner@kernel.org>
>     pidfs: add missing PIDFD_INFO_SIZE_VER1
>
> Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
>     accel/ivpu: Fix race condition when unbinding BOs
>
> Danilo Krummrich <dakr@kernel.org>
>     drm: nova: select NOVA_CORE
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     pinctrl: stm32: fix hwspinlock resource leak in probe function
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     soc: qcom: smem: fix hwspinlock resource leak in probe error paths
>
> Taniya Das <taniya.das@oss.qualcomm.com>
>     clk: qcom: gcc-qcs615: Update the SDCC clock to use shared_floor_ops
>
> Benjamin Berg <benjamin.berg@intel.com>
>     tools/nolibc/dirent: avoid errno in readdir_r
>
> Benjamin Berg <benjamin.berg@intel.com>
>     tools/nolibc/stdio: let perror work when NOLIBC_IGNORE_ERRNO is set
>
> Maciej Falkowski <maciej.falkowski@linux.intel.com>
>     accel/ivpu: Remove skip of dma unmap for imported buffers
>
> Tengda Wu <wutengda@huaweicloud.com>
>     x86/dumpstack: Prevent KASAN false positive warnings in __show_regs()
>
> Marek Vasut <marek.vasut+renesas@mailbox.org>
>     drm/rcar-du: dsi: Fix missing parameter in RXSETR_...EN macros
>
> Peter Zijlstra <peterz@infradead.org>
>     task_work: Fix NMI race condition
>
> Zhang Rui <rui.zhang@intel.com>
>     perf/x86/intel/cstate: Remove PC3 support from LunarLake
>
> Arnaud Lecomte <contact@arnaud-lcm.com>
>     bpf: Fix stackmap overflow check in __bpf_get_stackid()
>
> Arnaud Lecomte <contact@arnaud-lcm.com>
>     bpf: Refactor stack map trace depth calculation into helper function
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     mtd: rawnand: lpc32xx_slc: fix GPIO descriptor leak on probe error an=
d remove
>
> Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
>     mtd: nand: relax ECC parameter validation check
>
> Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
>     Revert "mtd: rawnand: marvell: fix layouts"
>
> Li Qiang <liqiang01@kylinos.cn>
>     wifi: iwlwifi: mld: add null check for kzalloc() in iwl_mld_send_prot=
o_offload()
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/userq: fix SDMA and compute validation
>
> Prike Liang <Prike.Liang@amd.com>
>     drm/amdgpu: add userq object va track helpers
>
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>     ARM: dts: renesas: r9a06g032-rzn1d400-db: Drop invalid #cells propert=
ies
>
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>     ARM: dts: renesas: gose: Remove superfluous port property
>
> Zhu Yanjun <yanjun.zhu@linux.dev>
>     RDMA/rxe: Fix null deref on srq->rq.queue after resize failure
>
> Loic Poulain <loic.poulain@oss.qualcomm.com>
>     arm64: dts: qcom: qcm2290: Fix camss register prop ordering
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     sctp: Defer SCTP_DBG_OBJCNT_DEC() to sctp_destroy_sock().
>
> Horatiu Vultur <horatiu.vultur@microchip.com>
>     phy: mscc: Fix PTP for VSC8574 and VSC8572
>
> Michal Suchanek <msuchanek@suse.de>
>     perf hwmon_pmu: Fix uninitialized variable warning
>
> Eric Gon=C3=A7alves <ghatto404@gmail.com>
>     arm64: dts: qcom: sm8250-samsung-common: correct reserved pins
>
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     arm64: dts: qcom: sdm845-starqltechn: Fix i2c-gpio node name
>
> Pengyu Luo <mitltlatltl@gmail.com>
>     arm64: dts: qcom: sc8280xp: Fix shifted GPI DMA channels
>
> Val Packett <val@packett.cool>
>     arm64: dts: qcom: x1-dell-thena: remove dp data-lanes
>
> Val Packett <val@packett.cool>
>     arm64: dts: qcom: x1-dell-thena: Add missing pinctrl for eDP HPD
>
> Alexander Martinz <amartinz@shiftphones.com>
>     arm64: dts: qcom: qcm6490-shift-otter: Add missing reserved-memory
>
> Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
>     arm64: dts: qcom: sm8750-mtp: move PCIe GPIOs to pcieport0 node
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     arm64: dts: qcom: sm8650: set ufs as dma coherent
>
> Luca Weiss <luca.weiss@fairphone.com>
>     arm64: dts: qcom: qcm6490-fairphone-fp5: Add supplies to simple-fb no=
de
>
> Gergo Koteles <soyer@irl.hu>
>     arm64: dts: qcom: sdm845-oneplus: Correct gpio used for slider
>
> Dzmitry Sankouski <dsankouski@gmail.com>
>     arm64: dts: qcom: sdm845-starqltechn: fix max77705 interrupts
>
> Dzmitry Sankouski <dsankouski@gmail.com>
>     arm64: dts: qcom: sdm845-starqltechn: remove (address|size)-cells
>
> Willy Tarreau <w@1wt.eu>
>     tools/nolibc: x86: fix section mismatch caused by asm "mem*" function=
s
>
> Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
>     arm64: dts: qcom: lemans: Add missing quirk for HS only USB controlle=
r
>
> Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
>     arm64: dts: qcom: x1e80100: Add missing quirk for HS only USB control=
ler
>
> Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
>     arm64: dts: qcom: x1e80100: Fix compile warnings for USB HS controlle=
r
>
> Peng Fan <peng.fan@nxp.com>
>     firmware: imx: scu-irq: fix OF node leak in
>
> Randolph Sapp <rs@ti.com>
>     arm64: dts: ti: k3-am62p: Fix memory ranges for GPU
>
> Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
>     PCI: endpoint: pci-epf-test: Fix sleeping function being called from =
atomic context
>
> Thomas Richard <thomas.richard@bootlin.com>
>     leds: upboard: Fix module alias
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: remove duplicate call to ice_deinit_hw() on error paths
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: move ice_deinit_dev() to the end of deinit paths
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: extract ice_init_dev() from ice_init()
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: move ice_init_pf() out of ice_init_dev()
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: move udp_tunnel_nic and misc IRQ setup into ice_init_pf()
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: ice_init_pf: destroy mutexes and xarrays on memory alloc failure
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: move ice_init_interrupt_scheme() prior ice_init_pf()
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: move service task start out of ice_init_pf()
>
> Lizhi Hou <lizhi.hou@amd.com>
>     accel/amdxdna: Fix uninitialized return value
>
> Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>     wifi: ath12k: restore register window after global reset
>
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Regression fix Uncore MHz printed in hex
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/ap: Don't leak debug feature files if AP instructions are not av=
ailable
>
> Bart Van Assche <bvanassche@acm.org>
>     scsi: ufs: core: Move the ufshcd_enable_intr() declaration
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/smp: Fix fallback CPU detection
>
> Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>     wifi: ath11k: fix peer HE MCS assignment
>
> Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>     wifi: ath11k: fix VHT MCS assignment
>
> nieweiqiang <nieweiqiang@huawei.com>
>     crypto: hisilicon/qm - restore original qos values
>
> Thorsten Blum <thorsten.blum@linux.dev>
>     crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate=
_id
>
> Haotian Zhang <vulab@iscas.ac.cn>
>     soc: qcom: gsbi: fix double disable caused by devm
>
> Luca Weiss <luca.weiss@fairphone.com>
>     clk: qcom: camcc-sm7150: Fix PLL config of PLL2
>
> Luca Weiss <luca.weiss@fairphone.com>
>     clk: qcom: camcc-sm6350: Fix PLL config of PLL2
>
> Luo Jie <quic_luoj@quicinc.com>
>     clk: qcom: gcc-ipq5424: Correct the icc_first_node_id
>
> Taniya Das <taniya.das@oss.qualcomm.com>
>     clk: qcom: gcc-glymur: Update the halt check flags for pipe clocks
>
> Taniya Das <taniya.das@oss.qualcomm.com>
>     clk: qcom: gcc-sm8750: Add a new frequency for sdcc2 clock
>
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     clk: qcom: rpmh: Define RPMH_IPA_CLK on QCS615
>
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>     clk: qcom: camcc-sm6350: Specify Titan GDSC power domain as a parent =
to other
>
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>     clk: qcom: camcc-sm8550: Specify Titan GDSC power domain as a parent =
to other
>
> Sherry Sun <sherry.sun@nxp.com>
>     tty: serial: imx: Only configure the wake register when device is set=
 as wakeup source
>
> Li Qiang <liqiang01@kylinos.cn>
>     uio: uio_fsl_elbc_gpcm:: Add null pointer check to uio_fsl_elbc_gpcm_=
probe
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     PCI: rcar-gen2: Drop ARM dependency from PCI_RCAR_GEN2
>
> Peter Griffin <peter.griffin@linaro.org>
>     arm64: dts: exynos: gs101: fix sysreg_apm reg property
>
> Peter Griffin <peter.griffin@linaro.org>
>     arm64: dts: exynos: gs101: fix clock module unit reg sizes
>
> Tianyou Li <tianyou.li@intel.com>
>     perf annotate: Check return value of evsel__get_arch() properly
>
> Joy Zou <joy.zou@nxp.com>
>     arm64: dts: imx95-15x15-evk: add fan-supply property for pwm-fan
>
> Tim Harvey <tharvey@gateworks.com>
>     arm64: dts: imx8mp-venice-gw702x: remove off-board sdhc1
>
> Tim Harvey <tharvey@gateworks.com>
>     arm64: dts: imx8mp-venice-gw702x: remove off-board uart
>
> Tim Harvey <tharvey@gateworks.com>
>     arm64: dts: imx8mm-venice-gw72xx: remove unused sdhc1 pinctrl
>
> Tim Harvey <tharvey@gateworks.com>
>     arm64: dts: freescale: imx8mp-venice-gw7905-2x: remove duplicate usdh=
c1 props
>
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Do not let BPF test infra emit invalid GSO types to stack
>
> Bart Van Assche <bvanassche@acm.org>
>     block/mq-deadline: Switch back to a single dispatch list
>
> Bart Van Assche <bvanassche@acm.org>
>     block/mq-deadline: Introduce dd_start_request()
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     PCI: sg2042: Fix a reference count issue in sg2042_pcie_remove()
>
> T Pratham <t-pratham@ti.com>
>     crypto: aead - Fix reqsize handling
>
> Ian Rogers <irogers@google.com>
>     perf parse-events: Make X modifier more respectful of groups
>
> Randy Dunlap <rdunlap@infradead.org>
>     firmware: qcom: tzmem: fix qcom_tzmem_policy kernel-doc
>
> Francesco Lavra <flavra@baylibre.com>
>     iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member
>
> Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
>     arm64: dts: qcom: ipq5424: correct the TF-A reserved memory to 512K
>
> Sidharth Seela <sidharthseela@gmail.com>
>     ntfs3: Fix uninit buffer allocated by __getname()
>
> Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
>     ntfs3: fix uninit memory after failed mi_read in mi_format_new
>
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: authenc - Correctly pass EINPROGRESS back up to the caller
>
> Johan Hovold <johan@kernel.org>
>     irqchip: Pass platform device to platform drivers
>
> Johan Hovold <johan@kernel.org>
>     irqchip: Drop leftover brackets
>
> Johan Hovold <johan@kernel.org>
>     irqchip/qcom-irq-combiner: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/starfive-jh8100: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/renesas-rzg2l: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/imx-mu-msi: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/irq-brcmstb-l2: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/irq-bcm7120-l2: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/irq-bcm7038-l1: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/bcm2712-mip: Fix section mismatch
>
> Johan Hovold <johan@kernel.org>
>     irqchip/bcm2712-mip: Fix OF node reference imbalance
>
> Fernand Sieber <sieberf@amazon.com>
>     sched/fair: Forfeit vruntime on yield
>
> Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
>     wifi: ath12k: fix TX and RX MCS rate configurations in HE mode
>
> Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>     wifi: ath12k: fix VHT MCS assignment
>
> Sarika Sharma <sarika.sharma@oss.qualcomm.com>
>     wifi: ath12k: Fix MSDU buffer types handling in RX error path
>
> Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>     wifi: ath11k: restore register window after global reset
>
> Kang Yang <kang.yang@oss.qualcomm.com>
>     wifi: ath10k: move recovery check logic into a new work
>
> Danilo Krummrich <dakr@kernel.org>
>     gpu: nova-core: gsp: do not unwrap() SGEntry
>
> Danilo Krummrich <dakr@kernel.org>
>     gpu: nova-core: gsp: remove useless conversion
>
> Ian Rogers <irogers@google.com>
>     perf parse-events: Fix legacy cache events if event is duplicated in =
a PMU
>
> Wludzik, Jozef <jozef.wludzik@intel.com>
>     accel/ivpu: Fix race condition when mapping dmabuf
>
> Josh Poimboeuf <jpoimboe@kernel.org>
>     objtool: Fix weak symbol detection
>
> Dylan Hatch <dylanbhatch@google.com>
>     objtool: Fix standalone --hacks=3Djump_label
>
> Peng Fan <peng.fan@nxp.com>
>     remoteproc: imx_rproc: Fix runtime PM cleanup and improve remove path
>
> Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
>     HID: logitech-hidpp: Do not assume FAP in hidpp_send_message_sync()
>
> Cyrille Pitchen <cyrille.pitchen@microchip.com>
>     drm: atmel-hlcdc: fix atmel_xlcdc_plane_setup_scaler()
>
> Marek Vasut <marek.vasut+renesas@mailbox.org>
>     clk: renesas: cpg-mssr: Read back reset registers to assure values la=
tched
>
> Marek Vasut <marek.vasut+renesas@mailbox.org>
>     clk: renesas: cpg-mssr: Add missing 1ms delay into reset toggle callb=
ack
>
> Biju Das <biju.das.jz@bp.renesas.com>
>     pinctrl: renesas: rzg2l: Fix PMC restore
>
> Roberto Sassu <roberto.sassu@huawei.com>
>     ima: Attach CREDS_CHECK IMA hook to bprm_creds_from_file LSM hook
>
> Abel Vesa <abel.vesa@linaro.org>
>     pinctrl: qcom: glymur: Fix the gpio and egpio pin functions
>
> Abel Vesa <abel.vesa@linaro.org>
>     pinctrl: qcom: glymur: Drop unnecessary platform data from match tabl=
e
>
> Ian Rogers <irogers@google.com>
>     perf bpf_counter: Fix opening of "any"(-1) CPU events
>
> Seungjin Bae <eeodqql09@gmail.com>
>     USB: Fix descriptor count when handling invalid MBIM extended descrip=
tor
>
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>     tools/nolibc: handle NULL wstatus argument to waitpid()
>
> Mykyta Yatsenko <yatsenko@meta.com>
>     bpf: Fix handling maps with no BTF and non-constant offsets for the b=
pf_wq
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>     bpf: Fix sleepable context for async callbacks
>
> Siddharth Chintamaneni <sidchintamaneni@gmail.com>
>     bpf: Cleanup unused func args in rqspinlock implementation
>
> Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
>     drm/vgem-fence: Fix potential deadlock on release
>
> Karol Wachowski <karol.wachowski@linux.intel.com>
>     accel/ivpu: Fix DCT active percent format
>
> Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
>     accel/ivpu: Fix page fault in ivpu_bo_unbind_all_bos_from_context()
>
> Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
>     accel/ivpu: Rework bind/unbind of imported buffers
>
> Guido G=C3=BCnther <agx@sigxcpu.org>
>     drm/panel: visionox-rm69299: Don't clear all mode flags
>
> Guido G=C3=BCnther <agx@sigxcpu.org>
>     drm/panel: visionox-rm69299: Fix clock frequency for SHIFT6mq
>
> Karol Wachowski <karol.wachowski@linux.intel.com>
>     accel/ivpu: Ensure rpm_runtime_put in case of engine reset/resume fai=
l
>
> Lizhi Hou <lizhi.hou@amd.com>
>     accel/amdxdna: Call dma_buf_vmap_unlocked() for imported object
>
> Lizhi Hou <lizhi.hou@amd.com>
>     accel/amdxdna: Fix an integer overflow in aie2_query_ctx_status_array=
()
>
> Mainak Sen <msen@nvidia.com>
>     gpu: host1x: Fix race in syncpt alloc/free
>
> Konstantin Andreev <andreev@swemel.ru>
>     smack: fix bug: setting task label silently ignores input garbage
>
> Konstantin Andreev <andreev@swemel.ru>
>     smack: fix bug: unprivileged task can create labels
>
> Konstantin Andreev <andreev@swemel.ru>
>     smack: fix bug: invalid label of unix socket file
>
> Konstantin Andreev <andreev@swemel.ru>
>     smack: always "instantiate" inode in smack_inode_init_security()
>
> Konstantin Andreev <andreev@swemel.ru>
>     smack: deduplicate xattr setting in smack_inode_init_security()
>
> Konstantin Andreev <andreev@swemel.ru>
>     smack: deduplicate "does access rule request transmutation"
>
> Konstantin Andreev <andreev@swemel.ru>
>     smack: fix bug: SMACK64TRANSMUTE set on non-directory
>
>
> -------------
>
> Diffstat:
>
>  Documentation/admin-guide/LSM/Smack.rst            |  16 +-
>  .../devicetree/bindings/pci/amlogic,axg-pcie.yaml  |   6 +-
>  Documentation/hwmon/g762.rst                       |   2 +-
>  Makefile                                           |   4 +-
>  arch/arm/boot/dts/renesas/r8a7793-gose.dts         |   1 -
>  .../arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts |   2 -
>  arch/arm/boot/dts/samsung/exynos4210-i9100.dts     |   1 +
>  arch/arm/boot/dts/samsung/exynos4210-trats.dts     |   1 +
>  .../boot/dts/samsung/exynos4210-universal_c210.dts |   1 +
>  arch/arm/boot/dts/samsung/exynos4412-midas.dtsi    |   1 +
>  .../dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi  |   8 +-
>  arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi  |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-boneblue.dts      |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-chiliboard.dts    |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-evm.dts           |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-evmsk.dts         |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-guardian.dts      |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-icev2.dts         |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-myirtech-myd.dts  |   2 +-
>  .../boot/dts/ti/omap/am335x-netcom-plus-2xx.dts    |   8 +-
>  .../arm/boot/dts/ti/omap/am335x-osd3358-sm-red.dts |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-pdu001.dts        |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-pocketbeagle.dts  |   2 +-
>  arch/arm/boot/dts/ti/omap/am335x-sl50.dts          |   2 +-
>  arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts      |   2 +-
>  arch/arm/boot/dts/ti/omap/omap3-n900.dts           |   2 +-
>  arch/arm/include/asm/word-at-a-time.h              |  10 +-
>  arch/arm64/boot/dts/amlogic/meson-g12b.dtsi        |   4 +-
>  arch/arm64/boot/dts/exynos/google/gs101.dtsi       |  18 +-
>  .../boot/dts/freescale/imx8mm-venice-gw72xx.dtsi   |  11 -
>  .../boot/dts/freescale/imx8mp-venice-gw702x.dtsi   |  51 ---
>  .../boot/dts/freescale/imx8mp-venice-gw72xx.dtsi   |  11 -
>  arch/arm64/boot/dts/freescale/imx95-15x15-evk.dts  |   1 +
>  .../arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi |   4 +-
>  arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   2 +-
>  arch/arm64/boot/dts/nvidia/tegra234.dtsi           |  61 ++++
>  arch/arm64/boot/dts/qcom/ipq5424.dtsi              |   2 +-
>  arch/arm64/boot/dts/qcom/lemans.dtsi               |   1 +
>  arch/arm64/boot/dts/qcom/msm8996.dtsi              |   3 +
>  arch/arm64/boot/dts/qcom/qcm2290.dtsi              |  10 +-
>  arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts |   2 +
>  arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts   |   5 +
>  arch/arm64/boot/dts/qcom/qrb2210-rb1.dts           |   2 +-
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi             | 170 +++++-----
>  .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |   4 +-
>  .../boot/dts/qcom/sdm845-samsung-starqltechn.dts   |  16 +-
>  .../arm64/boot/dts/qcom/sm8250-samsung-common.dtsi |   3 +-
>  arch/arm64/boot/dts/qcom/sm8650.dtsi               |   2 +
>  arch/arm64/boot/dts/qcom/sm8750-mtp.dts            |   6 +-
>  arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi        |   5 +-
>  arch/arm64/boot/dts/qcom/x1e80100.dtsi             |  12 +-
>  .../boot/dts/renesas/r8a779g3-sparrow-hawk.dts     |   6 +-
>  arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts    |   1 +
>  .../boot/dts/rockchip/rk3588-rock-5b-5bp-5t.dtsi   |   4 +-
>  .../boot/dts/rockchip/rk3588-rock-5b-plus.dts      |   5 +
>  arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts    |   4 +
>  arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dts    |   4 +
>  arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts   |  15 +-
>  arch/arm64/boot/dts/ti/k3-am62p.dtsi               |   2 +-
>  arch/arm64/boot/dts/ti/k3-am69-sk.dts              |   8 +-
>  .../boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi   |   4 +-
>  arch/arm64/mm/mmu.c                                | 214 +++++++-----
>  arch/arm64/mm/pageattr.c                           |   5 +-
>  arch/powerpc/kernel/entry_32.S                     |  10 +-
>  arch/powerpc/kexec/ranges.c                        |   2 +-
>  arch/powerpc/mm/book3s64/hash_utils.c              |  10 +-
>  arch/powerpc/mm/ptdump/hashpagetable.c             |   6 +
>  arch/riscv/kvm/vcpu_insn.c                         |  22 ++
>  arch/s390/include/asm/fpu-insn.h                   |   3 +
>  arch/s390/kernel/smp.c                             |   1 +
>  arch/um/Kconfig                                    |   1 +
>  arch/um/Makefile                                   |  12 +-
>  arch/um/include/asm/kasan.h                        |   4 -
>  arch/x86/boot/compressed/pgtable_64.c              |  11 +-
>  arch/x86/events/core.c                             |   5 +-
>  arch/x86/events/intel/core.c                       |   7 +-
>  arch/x86/events/intel/cstate.c                     |   3 +-
>  arch/x86/kernel/dumpstack.c                        |  23 +-
>  block/blk-lib.c                                    |   6 +-
>  block/blk-mq.c                                     |  35 +-
>  block/blk-throttle.c                               |   9 +-
>  block/mq-deadline.c                                | 129 ++++---
>  crypto/aead.c                                      |   1 +
>  crypto/ahash.c                                     |  18 +-
>  crypto/asymmetric_keys/asymmetric_type.c           |  12 +-
>  crypto/authenc.c                                   |  75 +++--
>  drivers/accel/amdxdna/aie2_ctx.c                   |  22 +-
>  drivers/accel/amdxdna/aie2_pci.c                   |  10 +-
>  drivers/accel/amdxdna/amdxdna_ctx.c                |   1 +
>  drivers/accel/amdxdna/amdxdna_ctx.h                |   1 +
>  drivers/accel/amdxdna/amdxdna_gem.c                |  47 ++-
>  drivers/accel/amdxdna/amdxdna_mailbox.c            |   1 +
>  drivers/accel/ivpu/ivpu_gem.c                      |  97 ++++--
>  drivers/accel/ivpu/ivpu_gem.h                      |   2 +-
>  drivers/accel/ivpu/ivpu_hw_btrs.c                  |   2 +-
>  drivers/accel/ivpu/ivpu_hw_btrs.h                  |   2 +-
>  drivers/accel/ivpu/ivpu_job.c                      |   6 +-
>  drivers/accel/ivpu/ivpu_pm.c                       |   9 +-
>  drivers/acpi/apei/ghes.c                           |  27 +-
>  drivers/acpi/processor_core.c                      |   2 +-
>  drivers/acpi/property.c                            |   1 +
>  drivers/base/firmware_loader/Kconfig               |   2 +-
>  drivers/block/nbd.c                                |   5 +-
>  drivers/block/ps3disk.c                            |   4 +
>  drivers/block/ublk_drv.c                           |   4 +-
>  drivers/char/random.c                              |  19 +-
>  drivers/clk/Makefile                               |   3 +-
>  drivers/clk/qcom/camcc-sm6350.c                    |  13 +-
>  drivers/clk/qcom/camcc-sm7150.c                    |   6 +-
>  drivers/clk/qcom/camcc-sm8550.c                    |  10 +
>  drivers/clk/qcom/clk-rpmh.c                        |   1 +
>  drivers/clk/qcom/gcc-glymur.c                      |  24 +-
>  drivers/clk/qcom/gcc-ipq5424.c                     |   3 +-
>  drivers/clk/qcom/gcc-qcs615.c                      |   6 +-
>  drivers/clk/qcom/gcc-sm8750.c                      |   1 +
>  drivers/clk/qcom/tcsrcc-glymur.c                   |  54 +--
>  drivers/clk/renesas/r9a06g032-clocks.c             |   6 +-
>  drivers/clk/renesas/r9a09g077-cpg.c                |   4 +-
>  drivers/clk/renesas/renesas-cpg-mssr.c             |  57 ++--
>  drivers/clk/spacemit/ccu-k1.c                      |   4 +-
>  drivers/clocksource/arm_arch_timer_mmio.c          |   2 +
>  drivers/clocksource/timer-nxp-pit.c                |   3 +-
>  drivers/clocksource/timer-nxp-stm.c                |  23 +-
>  drivers/clocksource/timer-ralink.c                 |  11 +-
>  drivers/cpufreq/amd-pstate.c                       |   2 +-
>  drivers/crypto/ccree/cc_buffer_mgr.c               |   6 +-
>  drivers/crypto/hisilicon/qm.c                      |  14 +-
>  drivers/crypto/intel/iaa/iaa_crypto_main.c         |   2 +-
>  drivers/crypto/starfive/jh7110-hash.c              |   6 +-
>  drivers/devfreq/hisi_uncore_freq.c                 |   3 +-
>  drivers/firmware/efi/cper-arm.c                    |  52 ++-
>  drivers/firmware/efi/cper.c                        |  60 ++++
>  drivers/firmware/efi/libstub/x86-5lvl.c            |   4 +-
>  drivers/firmware/imx/imx-scu-irq.c                 |   4 +-
>  drivers/firmware/stratix10-svc.c                   |   1 +
>  drivers/firmware/ti_sci.c                          |  21 +-
>  drivers/firmware/ti_sci.h                          |   2 +
>  drivers/gpio/Kconfig                               |   1 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.h         |   1 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |  44 ++-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h          |  12 +-
>  drivers/gpu/drm/amd/amdgpu/mes_userqueue.c         |  31 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  46 ++-
>  drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   4 +-
>  drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   8 +-
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    |  27 +-
>  drivers/gpu/drm/drm_plane.c                        |   8 +-
>  drivers/gpu/drm/i915/display/intel_fbdev.c         |  43 ++-
>  drivers/gpu/drm/i915/display/intel_fbdev_fb.c      |  42 +--
>  drivers/gpu/drm/i915/display/intel_fbdev_fb.h      |   8 +-
>  drivers/gpu/drm/imagination/pvr_device.c           |   2 +-
>  drivers/gpu/drm/mediatek/mtk_disp_ccorr.c          |  23 +-
>  drivers/gpu/drm/msm/adreno/a2xx_gpu.c              |   2 +-
>  drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  34 +-
>  drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  10 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h         |   6 -
>  drivers/gpu/drm/msm/msm_gpu.c                      |  21 +-
>  .../gpu/drm/nouveau/dispnv04/nouveau_i2c_encoder.c |  20 --
>  .../drm/nouveau/include/dispnv04/i2c/encoder_i2c.h |  19 +-
>  drivers/gpu/drm/nouveau/nouveau_fence.c            |   6 +-
>  drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c      |   2 +-
>  drivers/gpu/drm/nova/Kconfig                       |   1 +
>  drivers/gpu/drm/panel/panel-novatek-nt35560.c      |   8 +-
>  drivers/gpu/drm/panel/panel-visionox-rm69299.c     |   4 +-
>  drivers/gpu/drm/panthor/panthor_device.c           |   4 +-
>  drivers/gpu/drm/panthor/panthor_gem.c              |  20 +-
>  drivers/gpu/drm/panthor/panthor_mmu.c              |  18 +-
>  drivers/gpu/drm/panthor/panthor_sched.c            |  25 +-
>  .../gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h   |   4 +-
>  drivers/gpu/drm/tidss/tidss_dispc.c                |  93 +++--
>  drivers/gpu/drm/tidss/tidss_dispc.h                |   3 -
>  drivers/gpu/drm/tidss/tidss_drv.h                  |   2 +
>  drivers/gpu/drm/tidss/tidss_oldi.c                 |  22 ++
>  drivers/gpu/drm/vgem/vgem_fence.c                  |   2 +-
>  drivers/gpu/drm/xe/display/intel_fbdev_fb.c        |  32 +-
>  drivers/gpu/drm/xe/xe_exec_queue.c                 |   3 +
>  drivers/gpu/host1x/syncpt.c                        |   4 +-
>  drivers/gpu/nova-core/firmware/gsp.rs              |   8 +-
>  drivers/greybus/gb-beagleplay.c                    |  12 +-
>  drivers/hid/hid-logitech-hidpp.c                   |   9 +-
>  drivers/hv/mshv_root_main.c                        |  89 +++--
>  drivers/hwmon/sy7636a-hwmon.c                      |   7 +-
>  drivers/hwtracing/coresight/coresight-etm-perf.c   |   1 +
>  drivers/hwtracing/coresight/coresight-etm3x-core.c |  59 ++--
>  drivers/hwtracing/coresight/coresight-etm4x-core.c | 103 ++++--
>  drivers/hwtracing/coresight/coresight-etm4x.h      |   3 -
>  drivers/hwtracing/coresight/coresight-tmc-etr.c    |  10 +-
>  drivers/i2c/busses/i2c-k1.c                        |  19 +-
>  drivers/i3c/master.c                               |   8 +-
>  drivers/i3c/master/svc-i3c-master.c                |  22 +-
>  drivers/iio/imu/bmi270/bmi270_spi.c                |   2 +-
>  drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |   2 +-
>  drivers/iio/industrialio-core.c                    |  17 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   8 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   2 +-
>  drivers/infiniband/hw/irdma/cm.c                   |   2 +-
>  drivers/infiniband/hw/irdma/ctrl.c                 |   6 +-
>  drivers/infiniband/hw/irdma/icrdma_if.c            |   6 +-
>  drivers/infiniband/hw/irdma/ig3rdma_if.c           |   4 +
>  drivers/infiniband/hw/irdma/main.h                 |   2 +-
>  drivers/infiniband/hw/irdma/pble.c                 |   6 +-
>  drivers/infiniband/hw/irdma/puda.c                 |   1 -
>  drivers/infiniband/hw/irdma/uk.c                   |  31 +-
>  drivers/infiniband/hw/irdma/user.h                 |   1 -
>  drivers/infiniband/hw/irdma/verbs.c                |  24 +-
>  drivers/infiniband/hw/irdma/verbs.h                |   3 +-
>  drivers/infiniband/sw/rxe/rxe_srq.c                |   7 +-
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
>  drivers/interconnect/debugfs-client.c              |   7 +-
>  drivers/interconnect/qcom/msm8996.c                |   1 +
>  drivers/iommu/amd/debugfs.c                        |   2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
>  drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  27 +-
>  drivers/iommu/intel/Kconfig                        |   2 +-
>  drivers/iommu/intel/iommu.h                        |   2 +-
>  drivers/irqchip/irq-bcm2712-mip.c                  |  11 +-
>  drivers/irqchip/irq-bcm7038-l1.c                   |  11 +-
>  drivers/irqchip/irq-bcm7120-l2.c                   |  31 +-
>  drivers/irqchip/irq-brcmstb-l2.c                   |  25 +-
>  drivers/irqchip/irq-imx-mu-msi.c                   |  28 +-
>  drivers/irqchip/irq-mchp-eic.c                     |   7 +-
>  drivers/irqchip/irq-meson-gpio.c                   |   5 +-
>  drivers/irqchip/irq-qcom-mpm.c                     |   6 +-
>  drivers/irqchip/irq-renesas-rzg2l.c                |  37 +-
>  drivers/irqchip/irq-renesas-rzv2h.c                |  32 +-
>  drivers/irqchip/irq-starfive-jh8100-intc.c         |   6 +-
>  drivers/irqchip/irqchip.c                          |  10 +-
>  drivers/irqchip/qcom-irq-combiner.c                |   2 +-
>  drivers/irqchip/qcom-pdc.c                         |   5 +-
>  drivers/leds/leds-netxbig.c                        |  36 +-
>  drivers/leds/leds-upboard.c                        |   2 +-
>  drivers/leds/rgb/leds-qcom-lpg.c                   |   4 +-
>  drivers/macintosh/mac_hid.c                        |   3 +-
>  drivers/md/dm-log-writes.c                         |   1 +
>  drivers/md/dm-raid.c                               |   2 +
>  drivers/md/md.c                                    |  92 ++---
>  drivers/md/md.h                                    |   9 +-
>  drivers/md/raid5.c                                 |   6 +-
>  drivers/mfd/da9055-core.c                          |   1 +
>  drivers/mfd/mt6358-irq.c                           |   1 +
>  drivers/mfd/mt6397-irq.c                           |   1 +
>  drivers/misc/rp1/rp1_pci.c                         |   3 +
>  drivers/mtd/lpddr/lpddr_cmds.c                     |   8 +-
>  drivers/mtd/nand/raw/lpc32xx_slc.c                 |   2 +
>  drivers/mtd/nand/raw/marvell_nand.c                |  13 +-
>  drivers/mtd/nand/raw/nand_base.c                   |  13 +-
>  drivers/mtd/nand/raw/renesas-nand-controller.c     |   5 +-
>  drivers/net/dsa/b53/b53_common.c                   | 331 ++++++++++++---=
---
>  drivers/net/dsa/b53/b53_priv.h                     | 111 +++++-
>  drivers/net/dsa/b53/b53_regs.h                     |  41 ++-
>  drivers/net/dsa/xrs700x/xrs700x.c                  |  11 +
>  drivers/net/ethernet/intel/iavf/iavf_ptp.c         |   7 +
>  drivers/net/ethernet/intel/ice/devlink/devlink.c   |  21 +-
>  drivers/net/ethernet/intel/ice/ice.h               |   4 +
>  drivers/net/ethernet/intel/ice/ice_common.c        |   3 +
>  drivers/net/ethernet/intel/ice/ice_main.c          | 169 +++++-----
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sophgo.c |  20 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c  |   3 +-
>  drivers/net/phy/adin1100.c                         |   2 +-
>  drivers/net/phy/aquantia/aquantia_firmware.c       |   2 +-
>  drivers/net/phy/mscc/mscc_main.c                   |   6 +-
>  drivers/net/phy/phy-core.c                         |  43 +++
>  drivers/net/phy/realtek/realtek_main.c             |  65 ++--
>  drivers/net/vxlan/vxlan_core.c                     |  18 +-
>  drivers/net/wireless/ath/ath10k/core.c             |  20 +-
>  drivers/net/wireless/ath/ath10k/core.h             |   2 +-
>  drivers/net/wireless/ath/ath10k/mac.c              |   2 +-
>  drivers/net/wireless/ath/ath11k/mac.c              |   8 +-
>  drivers/net/wireless/ath/ath11k/pci.c              |  20 +-
>  drivers/net/wireless/ath/ath11k/wmi.c              |  20 +-
>  drivers/net/wireless/ath/ath11k/wmi.h              |   2 +
>  drivers/net/wireless/ath/ath12k/core.c             |  24 +-
>  drivers/net/wireless/ath/ath12k/core.h             |   1 -
>  drivers/net/wireless/ath/ath12k/dp_rx.c            |  70 +++-
>  drivers/net/wireless/ath/ath12k/hal_rx.c           |  10 +-
>  drivers/net/wireless/ath/ath12k/mac.c              |  28 +-
>  drivers/net/wireless/ath/ath12k/pci.c              |  20 +-
>  drivers/net/wireless/ath/ath12k/qmi.c              |  11 +-
>  drivers/net/wireless/ath/ath12k/qmi.h              |   5 +-
>  drivers/net/wireless/ath/ath12k/wmi.c              |  23 +-
>  drivers/net/wireless/ath/ath12k/wmi.h              |   2 +
>  drivers/net/wireless/ath/ath12k/wow.c              |   1 +
>  drivers/net/wireless/intel/iwlwifi/mld/d3.c        |   4 +
>  drivers/net/wireless/mediatek/mt76/mac80211.c      |   2 -
>  drivers/net/wireless/mediatek/mt76/mt76.h          |   9 +
>  drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   2 +
>  drivers/net/wireless/mediatek/mt76/mt792x_core.c   |   1 -
>  drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |  15 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  19 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  18 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 115 ++++---
>  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  69 ++--
>  drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   1 +
>  drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  11 +-
>  drivers/net/wireless/mediatek/mt76/wed.c           |  10 +-
>  drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   9 +-
>  drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  27 +-
>  drivers/net/wireless/realtek/rtw89/usb.c           |  13 +-
>  drivers/net/wireless/st/cw1200/bh.c                |   6 +-
>  drivers/nvme/host/auth.c                           |   2 +-
>  drivers/of/fdt.c                                   |  85 +++--
>  drivers/of/of_kunit_helpers.c                      |   5 +-
>  drivers/pci/controller/Kconfig                     |   7 +-
>  drivers/pci/controller/cadence/pcie-sg2042.c       |   3 -
>  drivers/pci/controller/dwc/pci-keystone.c          |   2 +
>  drivers/pci/controller/dwc/pcie-designware.h       |   2 +-
>  drivers/pci/controller/dwc/pcie-stm32-ep.c         |  41 +--
>  drivers/pci/endpoint/functions/pci-epf-test.c      |   5 +-
>  drivers/pci/setup-bus.c                            |   5 +
>  drivers/phy/freescale/phy-fsl-imx8qm-hsio.c        |   5 +-
>  drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  20 +-
>  drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |  15 +
>  drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |  27 +-
>  drivers/pinctrl/pinctrl-single.c                   |   7 +-
>  drivers/pinctrl/qcom/pinctrl-glymur.c              |   6 +-
>  drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   6 +-
>  drivers/pinctrl/stm32/pinctrl-stm32.c              |   2 +-
>  drivers/platform/x86/asus-wmi.c                    |   8 +-
>  drivers/platform/x86/intel/pmc/core.h              |   2 +-
>  drivers/power/supply/apm_power.c                   |   3 +-
>  drivers/power/supply/cw2015_battery.c              |   8 +-
>  drivers/power/supply/max17040_battery.c            |   6 +-
>  drivers/power/supply/qcom_battmgr.c                |  26 +-
>  drivers/power/supply/rt5033_charger.c              |   2 +
>  drivers/power/supply/rt9467-charger.c              |   6 +-
>  drivers/power/supply/wm831x_power.c                |  10 +-
>  drivers/pwm/core.c                                 |   5 +-
>  drivers/pwm/pwm-bcm2835.c                          |  28 +-
>  drivers/ras/ras.c                                  |  40 ++-
>  drivers/regulator/core.c                           |  37 +-
>  drivers/regulator/fixed.c                          |  11 +-
>  drivers/regulator/pca9450-regulator.c              |   7 +-
>  drivers/regulator/spacemit-p1.c                    |   4 +-
>  drivers/remoteproc/imx_rproc.c                     |   9 +-
>  drivers/remoteproc/qcom_q6v5_wcss.c                |   8 +-
>  drivers/rtc/rtc-amlogic-a4.c                       |   4 -
>  drivers/rtc/rtc-gamecube.c                         |   4 +
>  drivers/rtc/rtc-max31335.c                         |   6 +-
>  drivers/s390/crypto/ap_bus.c                       |   8 +-
>  drivers/scsi/imm.c                                 |   1 +
>  drivers/scsi/qla2xxx/qla_nvme.c                    |   2 +-
>  drivers/scsi/qla2xxx/qla_os.c                      |  20 +-
>  drivers/scsi/qla2xxx/qla_target.c                  |   5 +-
>  drivers/scsi/qla2xxx/qla_target.h                  |   1 +
>  drivers/scsi/sim710.c                              |   2 +
>  drivers/scsi/smartpqi/smartpqi_init.c              |  19 ++
>  drivers/scsi/stex.c                                |   1 +
>  drivers/soc/qcom/qcom_gsbi.c                       |   8 -
>  drivers/soc/qcom/smem.c                            |   3 +-
>  drivers/soc/renesas/r9a08g045-sysc.c               |  69 ++++
>  drivers/soc/renesas/r9a09g047-sys.c                |  79 +++++
>  drivers/soc/renesas/r9a09g056-sys.c                |  69 ++++
>  drivers/soc/renesas/r9a09g057-sys.c                | 101 ++++++
>  drivers/soc/renesas/rz-sysc.c                      |   2 +
>  drivers/soc/renesas/rz-sysc.h                      |   4 +
>  drivers/soc/samsung/exynos-pmu.c                   |   7 +-
>  drivers/soc/tegra/fuse/speedo-tegra210.c           |  58 +++-
>  drivers/spi/spi-airoha-snfi.c                      |  25 +-
>  drivers/spi/spi-ch341.c                            |   2 +-
>  drivers/spi/spi-sg2044-nor.c                       |   4 +-
>  drivers/spi/spi-tegra210-quad.c                    |  22 +-
>  drivers/staging/fbtft/fbtft-core.c                 |   4 +-
>  drivers/staging/most/Kconfig                       |   2 -
>  drivers/staging/most/Makefile                      |   1 -
>  drivers/staging/most/i2c/Kconfig                   |  13 -
>  drivers/staging/most/i2c/Makefile                  |   4 -
>  drivers/staging/most/i2c/i2c.c                     | 374 ---------------=
------
>  drivers/target/target_core_configfs.c              |   1 -
>  drivers/target/target_core_stat.c                  |  24 +-
>  drivers/tty/serial/imx.c                           |  14 +
>  drivers/ufs/core/ufshcd-priv.h                     |   2 +
>  drivers/ufs/core/ufshcd.c                          |  27 +-
>  drivers/ufs/host/ufs-rockchip.c                    |  19 +-
>  drivers/uio/uio_fsl_elbc_gpcm.c                    |   7 +
>  drivers/usb/core/message.c                         |   2 +-
>  drivers/usb/dwc2/platform.c                        |  17 +-
>  drivers/usb/dwc3/host.c                            |   5 +-
>  drivers/usb/gadget/legacy/raw_gadget.c             |   3 +
>  drivers/usb/gadget/udc/tegra-xudc.c                |   6 -
>  drivers/usb/misc/chaoskey.c                        |  16 +-
>  drivers/usb/phy/phy.c                              |   4 +
>  drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c        |   2 +
>  drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   2 +-
>  drivers/vdpa/pds/vdpa_dev.c                        |   2 +-
>  drivers/vfio/pci/vfio_pci_core.c                   |  68 ++--
>  drivers/vfio/pci/vfio_pci_intrs.c                  |  52 +--
>  drivers/vfio/pci/vfio_pci_priv.h                   |   4 +
>  drivers/vhost/net.c                                |  12 +-
>  drivers/vhost/vhost.c                              |   4 +-
>  drivers/video/backlight/led_bl.c                   |  13 +
>  drivers/video/fbdev/ssd1307fb.c                    |   4 +-
>  drivers/virtio/virtio.c                            |  12 +-
>  drivers/virtio/virtio_debug.c                      |  10 +-
>  drivers/virtio/virtio_pci_modern_dev.c             |   6 +-
>  drivers/virtio/virtio_ring.c                       |   7 +-
>  drivers/virtio/virtio_vdpa.c                       |   2 +-
>  drivers/watchdog/starfive-wdt.c                    |   4 +-
>  drivers/watchdog/wdat_wdt.c                        |  64 ++--
>  fs/9p/v9fs.c                                       |   4 +-
>  fs/9p/vfs_file.c                                   |  11 +-
>  fs/9p/vfs_inode.c                                  |   3 +-
>  fs/9p/vfs_inode_dotl.c                             |   2 +-
>  fs/btrfs/block-group.c                             |   6 +-
>  fs/btrfs/ctree.c                                   |   2 +-
>  fs/btrfs/delayed-ref.c                             |  43 ++-
>  fs/btrfs/scrub.c                                   |   2 +-
>  fs/btrfs/space-info.c                              |  22 +-
>  fs/btrfs/space-info.h                              |   6 +-
>  fs/erofs/super.c                                   |  38 ++-
>  fs/exfat/balloc.c                                  |   2 +-
>  fs/exfat/namei.c                                   |  20 +-
>  fs/ext4/mballoc.c                                  |  49 ++-
>  fs/ext4/move_extent.c                              |   2 +-
>  fs/f2fs/f2fs.h                                     |   2 +
>  fs/f2fs/gc.c                                       | 132 +++++---
>  fs/f2fs/recovery.c                                 |   2 +-
>  fs/f2fs/segment.c                                  |  38 ++-
>  fs/f2fs/segment.h                                  |   8 +-
>  fs/f2fs/super.c                                    |  14 +
>  fs/f2fs/sysfs.c                                    |   7 +
>  fs/fuse/control.c                                  |  19 +-
>  fs/gfs2/glock.c                                    |   5 +-
>  fs/gfs2/inode.c                                    |  15 +
>  fs/gfs2/inode.h                                    |   1 +
>  fs/gfs2/ops_fstype.c                               |   2 +-
>  fs/hfs/catalog.c                                   |   2 +-
>  fs/inode.c                                         |  58 ++--
>  fs/iomap/direct-io.c                               |  23 +-
>  fs/kernfs/dir.c                                    |   5 +-
>  fs/nfs/client.c                                    |  21 +-
>  fs/nfs/dir.c                                       |  27 +-
>  fs/nfs/internal.h                                  |   3 +-
>  fs/nfs/localio.c                                   |   4 +-
>  fs/nfs/namespace.c                                 |  11 +-
>  fs/nfs/nfs4client.c                                |  18 +-
>  fs/nfs/nfs4proc.c                                  |  27 +-
>  fs/nfs/pnfs.c                                      |   1 +
>  fs/nfs/super.c                                     |  33 +-
>  fs/nfsd/blocklayout.c                              |   4 +-
>  fs/nls/nls_base.c                                  |  27 +-
>  fs/ntfs3/frecord.c                                 |   8 +-
>  fs/ntfs3/fsntfs.c                                  |   9 +-
>  fs/ntfs3/inode.c                                   |   7 +-
>  fs/ocfs2/alloc.c                                   |   1 -
>  fs/ocfs2/inode.c                                   |  10 +-
>  fs/ocfs2/move_extents.c                            |   8 +-
>  fs/pidfs.c                                         |   2 +
>  fs/smb/client/cifssmb.c                            |   2 +-
>  fs/smb/client/smb2pdu.c                            |   2 +-
>  fs/smb/client/smbdirect.c                          |  28 +-
>  fs/smb/common/smbdirect/smbdirect_socket.h         |  51 +++
>  fs/smb/server/transport_rdma.c                     |  40 ++-
>  fs/tracefs/event_inode.c                           |   3 +-
>  include/asm-generic/mshyperv.h                     |  17 +-
>  include/asm-generic/rqspinlock.h                   |  60 ++--
>  include/linux/blk_types.h                          |   5 +-
>  include/linux/cleanup.h                            |  15 +-
>  include/linux/coresight.h                          |  35 +-
>  include/linux/cper.h                               |  12 +-
>  include/linux/f2fs_fs.h                            |   5 +-
>  include/linux/filter.h                             |  12 +-
>  include/linux/firmware/qcom/qcom_tzmem.h           |  15 +-
>  include/linux/ieee80211.h                          |   4 +-
>  include/linux/if_hsr.h                             |   9 +
>  include/linux/irq-entry-common.h                   |   2 +-
>  include/linux/irqchip.h                            |   8 +-
>  include/linux/netdevice.h                          |   1 +
>  include/linux/nfs_fs_sb.h                          |   5 +
>  include/linux/ns_common.h                          |  11 +
>  include/linux/of_fdt.h                             |   9 +
>  include/linux/phy.h                                |   3 +
>  include/linux/platform_data/lp855x.h               |   4 +-
>  include/linux/ras.h                                |  16 +-
>  include/linux/soc/mediatek/mtk_wed.h               |   1 +
>  include/linux/vfio_pci_core.h                      |  10 +-
>  include/linux/virtio.h                             |   2 +-
>  include/linux/virtio_config.h                      |  24 +-
>  include/linux/virtio_features.h                    |  29 +-
>  include/linux/virtio_pci_modern.h                  |   8 +-
>  include/net/netfilter/nf_conntrack_count.h         |  15 +-
>  include/ras/ras_event.h                            |  49 ++-
>  include/sound/tas2781.h                            |   2 +-
>  include/target/target_core_base.h                  |  12 +-
>  include/uapi/linux/pidfd.h                         |   1 +
>  include/uapi/sound/asound.h                        |   2 +-
>  include/ufs/ufshcd.h                               |   1 -
>  io_uring/io_uring.c                                |  10 +-
>  io_uring/kbuf.c                                    |  10 +-
>  io_uring/zcrx.c                                    |  16 +-
>  kernel/bpf/hashtab.c                               |  10 +-
>  kernel/bpf/helpers.c                               |   3 +
>  kernel/bpf/rqspinlock.c                            |  36 +-
>  kernel/bpf/stackmap.c                              |  62 ++--
>  kernel/bpf/syscall.c                               |   6 +-
>  kernel/bpf/trampoline.c                            |   4 +-
>  kernel/bpf/verifier.c                              |  89 +++--
>  kernel/cgroup/cpuset.c                             |  35 +-
>  kernel/cgroup/namespace.c                          |   2 +-
>  kernel/cpu.c                                       |  25 +-
>  kernel/dma/pool.c                                  |   2 +-
>  kernel/events/core.c                               |  22 +-
>  kernel/locking/locktorture.c                       |   8 +-
>  kernel/resource.c                                  |  10 +-
>  kernel/sched/fair.c                                |  17 +-
>  kernel/sched/stats.h                               |   7 +-
>  kernel/task_work.c                                 |   8 +-
>  kernel/time/timer_migration.c                      | 264 ++++++++-------
>  lib/vsprintf.c                                     |   6 +-
>  net/bpf/test_run.c                                 |   5 +
>  net/core/dev.h                                     |   1 -
>  net/core/filter.c                                  |  16 +-
>  net/core/netpoll.c                                 |   2 +-
>  net/hsr/hsr_device.c                               |  20 ++
>  net/hsr/hsr_slave.c                                |   7 +-
>  net/ipv6/ip6_fib.c                                 |   4 +
>  net/mac80211/aes_cmac.c                            |  63 +++-
>  net/mac80211/aes_cmac.h                            |   8 +-
>  net/mac80211/wpa.c                                 |  20 +-
>  net/netfilter/nf_conncount.c                       | 195 +++++++----
>  net/netfilter/nft_connlimit.c                      |  34 +-
>  net/netfilter/nft_flow_offload.c                   |   9 +-
>  net/netfilter/xt_connlimit.c                       |  14 +-
>  net/openvswitch/conntrack.c                        |  16 +-
>  net/sched/sch_cake.c                               |  60 ++--
>  net/sctp/socket.c                                  |   5 +-
>  scripts/cc-can-link.sh                             |   2 +-
>  scripts/lib/kdoc/kdoc_parser.py                    |  16 +-
>  scripts/package/install-extmod-build               |   2 +-
>  security/integrity/ima/ima_main.c                  |  40 ++-
>  security/integrity/ima/ima_policy.c                |   2 +-
>  security/landlock/errata/abi-1.h                   |  16 +
>  security/landlock/fs.c                             |  40 ++-
>  security/smack/smack.h                             |   3 +
>  security/smack/smack_access.c                      |  93 +++--
>  security/smack/smack_lsm.c                         | 277 ++++++++++-----
>  sound/firewire/dice/dice-extension.c               |   4 +-
>  sound/firewire/motu/motu-hwdep.c                   |   7 +-
>  sound/hda/codecs/realtek/alc269.c                  |   2 +
>  sound/hda/codecs/side-codecs/cs35l41_hda.c         |   2 +
>  sound/hda/codecs/side-codecs/tas2781_hda_i2c.c     |  44 +--
>  sound/isa/wavefront/wavefront_midi.c               |   2 +
>  sound/isa/wavefront/wavefront_synth.c              |   4 +-
>  sound/soc/amd/acp/acp-i2s.c                        |   2 +
>  sound/soc/amd/acp/acp-legacy-common.c              |  30 +-
>  sound/soc/bcm/bcm63xx-pcm-whistler.c               |   4 +-
>  sound/soc/codecs/Kconfig                           |   5 +
>  sound/soc/codecs/Makefile                          |   2 +
>  sound/soc/codecs/ak4458.c                          |  10 +-
>  sound/soc/codecs/ak5558.c                          |  10 +-
>  sound/soc/codecs/nau8325.c                         |   3 +-
>  sound/soc/codecs/tas2781-comlib-i2c.c              |   2 +-
>  sound/soc/codecs/tas2781-i2c.c                     |   2 +-
>  sound/soc/fsl/fsl_xcvr.c                           |   2 +-
>  sound/soc/intel/catpt/pcm.c                        |   4 +-
>  sound/soc/sdca/sdca_functions.c                    |   2 +-
>  tools/bpf/bpftool/sign.c                           |   6 +
>  tools/include/nolibc/arch-x86.h                    |   6 +-
>  tools/include/nolibc/dirent.h                      |   6 +-
>  tools/include/nolibc/stdio.h                       |   4 +
>  tools/include/nolibc/sys/wait.h                    |  18 +-
>  tools/lib/bpf/btf.c                                |   4 +-
>  tools/objtool/check.c                              |   3 +-
>  tools/objtool/elf.c                                |   8 +-
>  tools/perf/builtin-kvm.c                           |   2 +-
>  tools/perf/builtin-record.c                        |   2 +-
>  tools/perf/builtin-stat.c                          |  15 +-
>  .../pmu-events/arch/s390/cf_z16/transaction.json   |   8 +-
>  .../pmu-events/arch/s390/cf_z17/transaction.json   |   8 +-
>  tools/perf/util/annotate.c                         |   2 +-
>  .../util/arm-spe-decoder/arm-spe-pkt-decoder.c     |  25 +-
>  .../util/arm-spe-decoder/arm-spe-pkt-decoder.h     |  15 +-
>  tools/perf/util/bpf_counter.c                      |   7 +-
>  tools/perf/util/bpf_lock_contention.c              |   6 +-
>  tools/perf/util/evsel.c                            |   2 +-
>  tools/perf/util/genelf.c                           |  32 +-
>  tools/perf/util/hist.c                             |   6 +-
>  tools/perf/util/hist.h                             |   8 +-
>  tools/perf/util/hwmon_pmu.c                        |   3 +-
>  tools/perf/util/parse-events.c                     |  44 ++-
>  tools/perf/util/parse-events.h                     |   3 +-
>  tools/perf/util/parse-events.y                     |   2 +-
>  tools/perf/util/symbol.c                           |   5 +-
>  tools/power/x86/turbostat/turbostat.c              |  12 +-
>  tools/testing/selftests/bpf/.gitignore             |   1 +
>  tools/testing/selftests/bpf/Makefile               |   6 +-
>  .../selftests/bpf/prog_tests/kmem_cache_iter.c     |   3 +-
>  .../selftests/bpf/prog_tests/perf_branches.c       |  22 +-
>  .../testing/selftests/bpf/prog_tests/send_signal.c |   5 +
>  .../selftests/bpf/progs/test_perf_branches.c       |   3 +
>  tools/testing/selftests/bpf/test_tag.c             |   2 +-
>  .../drivers/net/bonding/bond_macvlan_ipvlan.sh     |   1 +
>  tools/testing/selftests/landlock/Makefile          |   2 +-
>  .../tcp_syscall_bad_arg_sendmsg-empty-iov.pkt      |   4 +
>  .../net/packetdrill/tcp_zerocopy_basic.pkt         |   2 +
>  .../net/packetdrill/tcp_zerocopy_batch.pkt         |   2 +
>  .../net/packetdrill/tcp_zerocopy_client.pkt        |   2 +
>  .../net/packetdrill/tcp_zerocopy_closed.pkt        |   2 +
>  .../net/packetdrill/tcp_zerocopy_epoll_edge.pkt    |   3 +
>  .../packetdrill/tcp_zerocopy_epoll_exclusive.pkt   |   3 +
>  .../net/packetdrill/tcp_zerocopy_epoll_oneshot.pkt |   3 +
>  .../packetdrill/tcp_zerocopy_fastopen-client.pkt   |   2 +
>  .../packetdrill/tcp_zerocopy_fastopen-server.pkt   |   2 +
>  .../net/packetdrill/tcp_zerocopy_maxfrags.pkt      |   2 +
>  .../net/packetdrill/tcp_zerocopy_small.pkt         |   2 +
>  tools/tracing/rtla/Makefile.rtla                   |   2 +-
>  tools/tracing/rtla/src/common.c                    |  24 +-
>  tools/tracing/rtla/src/osnoise_hist.c              |   3 +-
>  tools/tracing/rtla/src/osnoise_top.c               |   3 +-
>  tools/tracing/rtla/src/timerlat.c                  |   3 +-
>  tools/tracing/rtla/src/timerlat_hist.c             |   3 +-
>  tools/tracing/rtla/src/timerlat_top.c              |   3 +-
>  tools/tracing/rtla/tests/osnoise.t                 |   6 +-
>  tools/tracing/rtla/tests/timerlat.t                |   4 +-
>  616 files changed, 6319 insertions(+), 3850 deletions(-)
>
>
>


--=20
software engineer
rajagiri school of engineering and technology
