Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6631E846
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773236391; cv=pass; b=mCcRKgjvxbPfOG8g9E/sCMI2F1yJIvlBUh16/SyZnjRzw7Oz8kvd7YrcWymO0/chxLV1eyZz1BisoOlkrHcpEOBJJW7FlqVmv7vW5+C1IjJN1B0bmzdKBq0QGbI6/Z2S40mHigUSJT2a5TcRxuS+A9tQmqdOLxAA8onKWCUScAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773236391; c=relaxed/simple;
	bh=FMXy70t7q9cZK24miZtKXmam9RmMxPxCEgIeXP9FaHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WYUKK1gXbReGKdYL2OICTmFZmp4Ugf8g0zvaPbv9HEGoOgyCt+IeTNPjclTH5jFnw7qPf2Q13sWNIk8WAdEOEw2imvP5fSqTq4rbkDiYcf2MO5O6xB8afkrHP3inC7eTtB2mslTB5fzDW2jJixsVF+NCCHmiH1hxLp4WPkeKYYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUSpI9wv; arc=pass smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUSpI9wv"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2be26842fd5so628632eec.1
        for <patches@lists.linux.dev>; Wed, 11 Mar 2026 06:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773236387; cv=none;
        d=google.com; s=arc-20240605;
        b=DMUUZ7+fBhXGgMlkT2FQUr9XbIaVFce5GdW31eBLcYUPHYekBbyY+d2znhpwPTfoCd
         PF3KYllKxDHu3D/x2k9wMGoGZMrnWAhrfVaJh2z1HO+OEeQuDdzzfxW/nptuZjI83mm4
         evHg1/+wgXOpJFRbPUwQ5/Qzyo4rVlEXm7ZITcleQS1apAqhROYscV87gvHqAN8sjCe+
         8GS1t3YIl5ogfOJOVRwvfQBsg5Zzt9sMlszGUpo8igQxLn/dZ/FwHyGUiZFyqU9X3RP+
         LXX4W+4++8iyAdx6c3nltPhVKC6NkyubfaFCXJldWs9s6JC1xh3HeK8Uu686ghBYFr0p
         oALg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7la4nTaWsqRkJmU7PTFgGsb2/pquMp8Ih2q4c7lSRvE=;
        fh=9KSwyCTkOdBJ8oF90JyPDVDWDWO1+pxbzDk3Z7gXGk0=;
        b=PI/XO4Ybgl21Bzm8le++0XSk0pXWrMmr77YTblAau6WUpWO87U9oMBOEt3R6+EsdEr
         JQvOLg9KpAr+Xs/L4gs8osXYXBZzCsjpxrwzZDdbpTVQPHO07V0IC669Gz6iIszD27WJ
         3+5Es9b8WzLE+2CiYKo3CtN3cgqX2/VyCYszBNAw+aovcCRsH4m2svhK5Y5Ce+LHlti0
         yiwoML0CGgn8E8V+t8dbT4g6WUkt6vXFfFiv1jq+ZlJLWpllOYHUU4tIO5pMipl/MQmj
         W42NrPPckGu7e6+MGiofD7GaySlmzCNowFXYREwQbkFaq9OvxrXJ0da3uLJew/45yLBe
         itIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773236387; x=1773841187; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7la4nTaWsqRkJmU7PTFgGsb2/pquMp8Ih2q4c7lSRvE=;
        b=LUSpI9wvAAhMNC5mMapxU4Wvblqqa7eCNUYhK6XnvYEvtxiDh0sEYW/MxK0VFn0R0g
         VfmgbycQOOGGFEKn0rNAdgfoccCqd+JdE+k6RL2coIp6stwolUWmI0633y7mAzo7pjnC
         t02SgE9Adt6JOCwyYhhu0REwRFR0LadWevC5l79NGGPVKNX/Brk70NjS7wBlraL6qLmB
         aA+2lOs11YmGWBlTSnAQNwt8TIDp4j+X6iE/63q5/ds6A0GcZkKjxyOmQAcpw6r16OTM
         kyiDaV81lh1szlLobw2rh2YX9B0JEnf5Sv6e7ddO08SyU9mff77LvSXfR8qb0Ua7DFEZ
         e3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773236387; x=1773841187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7la4nTaWsqRkJmU7PTFgGsb2/pquMp8Ih2q4c7lSRvE=;
        b=PTEN/OSOR4ScZHExWBeOWw8ariA3DINlXcImo+hSMo+92DhNx5ctKC2by97efmYgVZ
         5EZ8x7S6UHAKEwOhlrttf5H7a/oLVJHAnFnI8VoY3Bvfv0OszERXENZR+S/hlINzOsE4
         znAjbIuPjii00F5JC0OziYPJaZuakGO83ez+gz1v1zxEwFQX5wzhs8VAH3OK5/R4layf
         WsSy6fRGXtpmtxWIwZzLKTOD2nYAjrvkQfSuwkeUxbcNGDwPy2vHH/bNCfuOV6PmZjnt
         9HHOAsa0G5GvT0Ha96fGh6yXHn15Qm027peEwEyNso+voTxiovsNQqzNltHnPgIY6gbG
         Srig==
X-Forwarded-Encrypted: i=1; AJvYcCXnZ4K1h/umOZ7jCJBJ9Jm2wyRzkfAmOq4nRd2JCEn0ZiC4f18EskqPV2YsAD0eN6rIeMWyt9a2@lists.linux.dev
X-Gm-Message-State: AOJu0YxyYTLafS/YATob/ZoKWtmMnoknqWyHs4L87kCAyHLbKaDbkpQX
	3jfxQGTzXgaqiHHP+WwrgAw+XOR7O4e8JTOi/vB0j9g1SHjKdI4x/TjIC/07xBvxWA5STxg57ur
	PzTlu0WSGnf+WzkQc2rrpx1nYgWVxbBs=
X-Gm-Gg: ATEYQzxHwqKfKbB6YvA4NjVI3um1B4SPvlR/qcpEpSGgq3y6jZmLGiiegWdmdt4aMZR
	gHI1anPnnNb5PAefyGaXcl0ujAve9e2C0cw8R7Ki8spCk3S/JzVzgC0cGJpXhkhkXycNr9iehrF
	B3v9C4IbmEKNkuiBWVfeMK8kxWe1KbiXPcv1zDr/xTbXR/XAkaDQv4MZ0kZ96jxMV7R3RuIVK/f
	XrUE1HO70MOnE0oy0QvgyEPVarqS6RVe7KIUxMeVYUakbpfYLEmDG72XeHpMKc4E/YEf9tt9JuK
	lZKT5GR42HkMTgJvz8NKfBDzomaPAcwtkwcE4ohaNYoAw5+x6KgDh91z1AYIUsWct7eNemyq/AF
	CgznGgquanVvac/7DWmcT+2hVRRkpzFMEJ+bPakXOxsYrpZ2f0hT77/prOYQRa5sbaiY4hZ3zG7
	WtdH9SiOunoTm5ubhhBM0=
X-Received: by 2002:a05:7300:f187:b0:2ba:7046:b6b5 with SMTP id
 5a478bee46e88-2be8a1f7d46mr922579eec.15.1773236386468; Wed, 11 Mar 2026
 06:39:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1773140654.git.sashal@kernel.org>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 11 Mar 2026 14:39:32 +0100
X-Gm-Features: AaiRm53knEXlPJLJEqO4ve3D4OAlgiTM6nIyz-4NfwabiKTpcB_jiT2CPuZy1zo
Message-ID: <CADo9pHimpztgSPtq_Q998wX5C-nKyeQ+=fhFp_Q3urtLsFJSZQ@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com, Luna Jernberg <droidbittin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den tis 10 mars 2026 kl 12:11 skrev Sasha Levin <sashal@kernel.org>:
>
>
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/rawdiff/?id=3Dlinux-6.19.y&id2=3Dv6.19.6
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>
> -------------
> Pseudo-Shortlog of commits:
>
> Aaron Ma (1):
>   ice: recap the VSI and QoS info after rebuild
>
> Alain Volmat (1):
>   spi: stm32: fix missing pointer assignment in case of dma chaining
>
> Alban Bedel (1):
>   can: mcp251x: fix deadlock in error path of mcp251x_open
>
> Alex Hung (2):
>   drm/amd/display: Use mpc.preblend flag to indicate 3D LUT
>   drm/amd/display: Enable DEGAMMA and reject COLOR_PIPELINE+DEGAMMA_LUT
>
> Alexandre Courbot (1):
>   rust: kunit: fix warning when !CONFIG_PRINTK
>
> Alexey Charkov (1):
>   scsi: ufs: core: Fix RPMB region size detection for UFS 2.2
>
> Allison Henderson (1):
>   net/rds: Fix circular locking dependency in rds_tcp_tune
>
> Alper Ak (1):
>   crypto: ccp - Fix use-after-free on error path
>
> Andrew Cooper (1):
>   x86/fred: Correct speculative safety in fred_extint()
>
> Andrew Lunn (1):
>   net: phy: register phy led_triggers during probe to avoid AB-BA
>     deadlock
>
> Ankit Garg (1):
>   gve: fix incorrect buffer cleanup in gve_tx_clean_pending_packets for
>     QPL
>
> Ariel Silver (1):
>   wifi: mac80211: bounds-check link_id in ieee80211_ml_reconfiguration
>
> Bart Van Assche (5):
>   drm/amdgpu: Unlock a mutex before destroying it
>   drm/amdgpu: Fix locking bugs in error paths
>   hwmon: (it87) Check the it87_lock() return value
>   wifi: cw1200: Fix locking in error paths
>   wifi: wlcore: Fix a locking bug
>
> Bjorn Helgaas (1):
>   PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value
>
> Bobby Eshleman (1):
>   net: devmem: use READ_ONCE/WRITE_ONCE on binding->dev
>
> Boris Faure (1):
>   ASoC: sdca: Fix missing regmap dependencies in Kconfig
>
> Brad Spengler (1):
>   drm/vmwgfx: Fix invalid kref_put callback in vmw_bo_dirty_release
>
> Brian Vazquez (1):
>   idpf: change IRQ naming to match netdev and ethtool queue numbering
>
> Catalin Marinas (1):
>   arm64: gcs: Do not set PTE_SHARED on GCS mappings if FEAT_LPA2 is
>     enabled
>
> Chaitanya Kulkarni (1):
>   blktrace: fix __this_cpu_read/write in preemptible context
>
> Charles Haithcock (1):
>   i2c: i801: Revert "i2c: i801: replace acpi_lock with I2C bus lock"
>
> Charles Keepax (1):
>   ASoC: SDCA: Add allocation failure check for Entity name
>
> Chen Ni (2):
>   drm/imx: parallel-display: check return value of devm_drm_bridge_add()
>     in imx_pd_probe()
>   drm/bridge: synopsys: dw-dp: Check return value of
>     devm_drm_bridge_add() in dw_dp_bind()
>
> Chintan Vankar (1):
>   net: ethernet: ti: am65-cpsw-nuss/cpsw-ale: Fix multicast entry
>     handling in ALE table
>
> Christian Brauner (1):
>   namespace: fix proc mount iteration
>
> Christoph B=C3=B6hmwalder (1):
>   drbd: fix null-pointer dereference on local read error
>
> Christoph Hellwig (2):
>   zloop: advertise a volatile write cache
>   zloop: check for spurious options passed to remove
>
> Conor Dooley (1):
>   pinctrl: generic: move function to amlogic-am4 driver
>
> Corey Minyard (1):
>   ipmi: Fix use-after-free and list corruption on sender error
>
> Dan Carpenter (1):
>   accel: ethosu: Fix shift overflow in cmd_to_addr()
>
> Daniel Hodges (1):
>   wifi: libertas: fix use-after-free in lbs_free_adapter()
>
> Daniel J Blueman (1):
>   gpio: shared: fix memory leaks
>
> Danielle Ratson (1):
>   bridge: Check relevant per-VLAN options in VLAN range grouping
>
> Daniil Dulov (1):
>   wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()
>
> Danilo Krummrich (1):
>   clk: scu/imx8qxp: do not register driver in probe()
>
> Darrick J. Wong (1):
>   xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
>
> Dave Jiang (2):
>   cxl: Move devm_cxl_add_nvdimm_bridge() to cxl_pmem.ko
>   cxl: Fix race of nvdimm_bus object when creating nvdimm objects
>
> David Carlier (1):
>   sched_ext: Fix SCX_EFLAG_INITIALIZED being a no-op flag
>
> David Howells (1):
>   netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict
>     sequence
>
> David Laight (1):
>   uaccess: Fix scoped_user_read_access() for 'pointer to const'
>
> David Thomson (1):
>   xen/acpi-processor: fix _CST detection using undersized evaluation
>     buffer
>
> Davide Caratti (1):
>   net/sched: ets: fix divide by zero in the offload path
>
> Davidlohr Bueso (1):
>   cxl/mbox: validate payload size before accessing contents in
>     cxl_payload_from_user_allowed()
>
> Deepanshu Kartikey (1):
>   mm: thp: deny THP for files on anonymous inodes
>
> Eduard Zingerman (1):
>   bpf: collect only live registers in linked regs
>
> Eric Biggers (1):
>   ksmbd: Compare MACs in constant time
>
> Eric Dumazet (5):
>   net: annotate data-races around sk->sk_{data_ready,write_space}
>   inet: annotate data-races around isk->inet_num
>   indirect_call_wrapper: do not reevaluate function pointer
>   tcp: secure_seq: add back ports to TS offset
>   net_sched: sch_fq: clear q->band_pkt_count[] in fq_reset()
>
> Ethan Tidmore (2):
>   drm/tiny: sharp-memory: fix pointer error dereference
>   xfs: Fix error pointer dereference
>
> Felix Gu (7):
>   drm/logicvc: Fix device node reference leak in
>     logicvc_drm_config_parse()
>   regulator: fp9931: Fix PM runtime reference leak in
>     fp9931_hwmon_read()
>   regulator: bq257xx: Fix device node reference leak in
>     bq257xx_reg_dt_parse_gpio()
>   pinctrl: pinconf-generic: Fix memory leak in
>     pinconf_generic_parse_dt_config()
>   pinctrl: meson: amlogic-a4: Fix device node reference leak in
>     aml_dt_node_to_map_pinmux()
>   pinctrl: cirrus: cs42l43: Fix double-put in cs42l43_pin_probe()
>   regulator: mt6363: Fix incorrect and redundant IRQ disposal in probe
>
> Fernando Fernandez Mancera (2):
>   net: bridge: fix nd_tbl NULL dereference when IPv6 is disabled
>   net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled
>
> Florian Eckert (2):
>   pinctrl: equilibrium: rename irq_chip function callbacks
>   pinctrl: equilibrium: fix warning trace on load
>
> Florian Westphal (1):
>   netfilter: nft_set_pipapo: split gc into unlink and reclaim phase
>
> Francesco Lavra (1):
>   drm/solomon: Fix page start when updating rectangle in page addressing
>     mode
>
> Fuad Tabba (3):
>   KVM: arm64: Hide S1POE from guests when not supported by the host
>   KVM: arm64: Fix ID register initialization for non-protected pKVM
>     guests
>   bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic
>     tearing
>
> Geoffrey D. Bennett (3):
>   ALSA: scarlett2: Fix DSP filter control array handling
>   ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
>   ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP
>
> Gerd Rausch (1):
>   time/jiffies: Fix sysctl file error on configurations where USER_HZ <
>     HZ
>
> Greg Kroah-Hartman (12):
>   nfc: pn533: properly drop the usb interface reference on disconnect
>   net: usb: kaweth: validate USB endpoints
>   net: usb: kalmia: validate USB endpoints
>   net: usb: pegasus: validate USB endpoints
>   can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of
>     a message
>   can: usb: f81604: correctly anchor the urb in the read bulk callback
>   can: ucan: Fix infinite loop from zero-length messages
>   can: usb: etas_es58x: correctly anchor the urb in the read bulk
>     callback
>   can: usb: f81604: handle short interrupt urb messages properly
>   can: usb: f81604: handle bulk write errors properly
>   HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them
>   Revert "netfilter: nft_set_rbtree: validate open interval overlap"
>
> Guenter Roeck (5):
>   hwmon: (macsmc) Fix regressions in Apple Silicon SMC hwmon driver
>   hwmon: (macsmc) Fix overflows, underflows, and sign extension
>   dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ
>     handler
>   ata: libata-eh: Fix detection of deferred qc timeouts
>   tracing: Add NULL pointer check to trigger_data_free()
>
> Hao Yu (1):
>   hwmon: (aht10) Fix initialization commands for AHT20
>
> Haocheng Yu (1):
>   perf/core: Fix refcount bug and potential UAF in perf_mmap
>
> Harishankar Vishwanathan (1):
>   bpf: Introduce tnum_step to step through tnum's members
>
> Harry Yoo (1):
>   mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback is available
>
> Heiko Carstens (2):
>   s390/idle: Fix cpu idle exit cpu time accounting
>   s390/vtime: Fix virtual timer forwarding
>
> Heitor Alves de Siqueira (1):
>   Bluetooth: purge error queues in socket destructors
>
> Henrique Carvalho (1):
>   smb: client: fix cifs_pick_channel when channels are equally loaded
>
> Hou Wenlong (1):
>   x86/bug: Handle __WARN_printf() trap in early_fixup_exception()
>
> Ian Forbes (1):
>   drm/vmwgfx: Return the correct value in vmw_translate_ptr functions
>
> Ian Ray (2):
>   HID: multitouch: new class MT_CLS_EGALAX_P80H84
>   net: nfc: nci: Fix zero-length proprietary notifications
>
> Ingo Molnar (3):
>   sched/fair: Rename cfs_rq::avg_load to cfs_rq::sum_weight
>   sched/fair: Rename cfs_rq::avg_vruntime to ::sum_w_vruntime, and
>     helper functions
>   sched/fair: Introduce and use the vruntime_cmp() and vruntime_op()
>     wrappers for wrapped-signed aritmetics
>
> Ioana Ciornei (1):
>   irqchip/ls-extirq: Fix devm_of_iomap() error check
>
> Jakub Kicinski (6):
>   tcp: give up on stronger sk_rcvbuf checks (for now)
>   ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()
>   nfc: nci: free skb on nci_transceive early error paths
>   nfc: nci: complete pending data exchange on device close
>   nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback
>   nfc: rawsock: cancel tx_work before socket teardown
>
> Jamal Hadi Salim (1):
>   net/sched: act_ife: Fix metalist update behavior
>
> Jan Stancek (1):
>   x86/boot: Handle relative CONFIG_EFI_SBAT_FILE file paths
>
> Jann Horn (1):
>   eventpoll: Fix integer overflow in ep_loop_check_proc()
>
> Jason Gunthorpe (3):
>   IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()
>   RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()
>   RDMA/ionic: Fix kernel stack leak in ionic_create_cq()
>
> Jens Axboe (2):
>   io_uring/cmd_net: use READ_ONCE() for ->addr3 read
>   media: dvb-core: fix wrong reinitialization of ringbuffer on reopen
>
> Jiayuan Chen (5):
>   bpf: Fix race in cpumap on PREEMPT_RT
>   bpf: Fix race in devmap on PREEMPT_RT
>   atm: lec: fix null-ptr-deref in lec_arp_clear_vccs
>   bpf/bonding: reject vlan+srcmac xmit_hash_policy change when XDP is
>     loaded
>   net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop
>
> Johannes Berg (1):
>   wifi: radiotap: reject radiotap with unknown bits
>
> Jonathan Cavitt (1):
>   drm/client: Do not destroy NULL modes
>
> Jonathan Teh (1):
>   platform/x86: thinkpad_acpi: Fix errors reading battery thresholds
>
> Juhyung Park (2):
>   ALSA: hda/realtek: fix model name typo for Samsung Galaxy Book Flex
>     (NT950QCG-X716)
>   ALSA: hda/realtek: add quirk for Samsung Galaxy Book Flex
>     (NT950QCT-A38A)
>
> Julian Orth (1):
>   drm/syncobj: Fix handle <-> fd ioctls with dirty stack
>
> Jun Seo (1):
>   ALSA: usb-audio: Use correct version for UAC3 header validation
>
> Junxiao Bi (1):
>   scsi: core: Fix refcount leak for tagset_refcnt
>
> Juri Lelli (1):
>   sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting
>
> Justin Tee (1):
>   nvmet-fcloop: Check remoteport port_state before calling done callback
>
> Keith Busch (1):
>   nvme-multipath: fix leak on try_module_get failure
>
> Khushit Shah (1):
>   KVM: x86: Add x2APIC "features" to control EOI broadcast suppression
>
> Kim Phillips (1):
>   x86/sev: Allow IBPB-on-Entry feature for SNP guests
>
> Kohei Enju (2):
>   bpf: Fix stack-out-of-bounds write in devmap
>   iavf: fix netdev->max_mtu to respect actual hardware limit
>
> Koichiro Den (1):
>   net: sched: avoid qdisc_reset_all_tx_gt() vs dequeue race for lockless
>     qdiscs
>
> Kuen-Han Tsai (3):
>   usb: gadget: u_ether: add gether_opts for config caching
>   usb: gadget: u_ether: Add auto-cleanup helper for freeing net_device
>   usb: gadget: f_ncm: align net_device lifecycle with bind/unbind
>
> Kuniyuki Iwashima (2):
>   nfsd: Fix cred ref leak in nfsd_nl_threads_set_doit().
>   udp: Unhash auto-bound connected sk from 4-tuple hash table when
>     disconnected.
>
> Kurt Borja (2):
>   platform/x86: alienware-wmi-wmax: Add G-Mode support to m18 laptops
>   platform/x86: dell-wmi: Add audio/mic mute key codes
>
> Lang Xu (1):
>   bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim
>
> Lars Ellenberg (1):
>   drbd: fix "LOGIC BUG" in drbd_al_begin_io_nonblock()
>
> Larysa Zaremba (9):
>   ice: fix adding AQ LLDP filter for VF
>   xdp: use modulo operation to calculate XDP frag tailroom
>   xsk: introduce helper to determine rxq->frag_size
>   ice: fix rxq info registering in mbuf packets
>   ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz
>   i40e: fix registering XDP RxQ info
>   i40e: use xdp.frame_sz as XDP RxQ info frag_size
>   net: enetc: use truesize as XDP RxQ info frag_size
>   xdp: produce a warning when calculated tailroom is negative
>
> Li Li (1):
>   idpf: increment completion queue next_to_clean in sw marker wait
>     routine
>
> Lijo Lazar (1):
>   drm/amdgpu: Fix error handling in slot reset
>
> Lizhi Hou (11):
>   accel/amdxdna: Remove buffer size check when creating command BO
>   accel/amdxdna: Switch to always use chained command
>   accel/amdxdna: Fix crash when destroying a suspended hardware context
>   accel/amdxdna: Fix dead lock for suspend and resume
>   accel/amdxdna: Fix suspend failure after enabling turbo mode
>   accel/amdxdna: Fix command hang on suspended hardware context
>   accel/amdxdna: Fix out-of-bounds memset in command slot handling
>   accel/amdxdna: Prevent ubuf size overflow
>   accel/amdxdna: Validate command buffer payload count
>   accel/amdxdna: Fill invalid payload for failed command
>   accel/amdxdna: Fix NULL pointer dereference of mgmt_chann
>
> Lorenzo Bianconi (4):
>   wifi: mt76: mt7996: Fix possible oob access in
>     mt7996_mac_write_txwi_80211()
>   wifi: mt76: mt7925: Fix possible oob access in
>     mt7925_mac_write_txwi_80211()
>   wifi: mt76: Fix possible oob access in
>     mt76_connac2_mac_write_txwi_80211()
>   net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of
>     error in mtk_xdp_setup()
>
> MD Danish Anwar (1):
>   net: ti: icssg-prueth: Fix ping failure after offload mode setup when
>     link speed is not 1G
>
> Mario Limonciello (2):
>   accel/amdxdna: Reduce log noise during process termination
>   platform/x86: hp-bioscfg: Support allocations of larger data
>
> Mariusz Skamra (1):
>   Bluetooth: Fix CIS host feature condition
>
> Mark Harmstone (6):
>   btrfs: fix error message order of parameters in
>     btrfs_delete_delayed_dir_index()
>   btrfs: fix incorrect key offset in error message in
>     check_dev_extent_item()
>   btrfs: fix objectid value in error message in check_extent_data_ref()
>   btrfs: fix warning in scrub_verify_one_metadata()
>   btrfs: print correct subvol num if active swapfile prevents deletion
>   btrfs: fix compat mask in error messages in btrfs_check_features()
>
> Mathias Krause (1):
>   scsi: lpfc: Properly set WC for DPP mapping
>
> Mathieu Desnoyers (1):
>   rseq: Clarify rseq registration rseq_size bound check comment
>
> Matt Roper (1):
>   drm/xe/wa: Steer RMW of MCR registers while building default LRC
>
> Matthew Brost (1):
>   drm/xe: Do not preempt fence signaling CS instructions
>
> Matthieu Baerts (NGI0) (4):
>   mptcp: pm: avoid sending RM_ADDR over same subflow
>   mptcp: pm: in-kernel: always mark signal+subflow endp as used
>   selftests: mptcp: join: check RM_ADDR not sent over same subflow
>   selftests: mptcp: join: check removing signal+subflow endp
>
> Maulik Shah (1):
>   pinctrl: qcom: qcs615: Add missing dual edge GPIO IRQ errata flag
>
> Michal Schmidt (1):
>   ice: fix crash in ethtool offline loopback test
>
> Michal Swiatkowski (1):
>   libie: don't unroll if fwlog isn't supported
>
> Mieczyslaw Nalewaj (1):
>   net: dsa: realtek: rtl8365mb: fix rtl8365mb_phy_ocp_write return value
>
> Mike Rapoport (Microsoft) (1):
>   x86/efi: defer freeing of boot services memory
>
> Ming Lei (2):
>   nvme: fix admin queue leak on controller reset
>   block: use trylock to avoid lockdep circular dependency in sysfs
>
> Miquel Sabat=C3=A9 Sol=C3=A0 (1):
>   btrfs: free pages on error in btrfs_uring_read_extent()
>
> Miroslav Lichvar (1):
>   timekeeping: Fix timex status validation for auxiliary clocks
>
> Nam Cao (1):
>   irqchip/sifive-plic: Fix frozen interrupt due to affinity setting
>
> Namhyung Kim (1):
>   perf/core: Fix invalid wait context in ctx_sched_in()
>
> Natalie Vock (1):
>   drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink
>
> Nathan Chancellor (2):
>   kbuild: Split .modinfo out from ELF_DETAILS
>   kbuild: Leave objtool binary around with 'make clean'
>
> Nikhil P. Rao (2):
>   xsk: Fix fragment node deletion to prevent buffer leak
>   xsk: Fix zero-copy AF_XDP fragment drop
>
> Niklas Cassel (3):
>   PCI: dwc: ep: Refresh MSI Message Address cache on change
>   PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry
>   ata: libata: cancel pending work after clearing deferred_qc
>
> Oliver Hartkopp (2):
>   can: bcm: fix locking for bcm_op runtime updates
>   can: dummy_can: dummy_can_init(): fix packet statistics
>
> Olivier Sobrie (1):
>   hwmon: (max6639) fix inverted polarity
>
> Ovidiu Panait (4):
>   net: stmmac: Fix error handling in VLAN add and delete paths
>   net: stmmac: Improve double VLAN handling
>   net: stmmac: Fix VLAN HW state restore
>   net: stmmac: Defer VLAN HW configuration when interface is down
>
> Pablo Neira Ayuso (2):
>   netfilter: nf_tables: unconditionally bump set->nelems before
>     insertion
>   netfilter: nf_tables: clone set on flush only
>
> Panagiotis Foliadis (2):
>   ALSA: hda/intel: increase default bdl_pos_adj for Nvidia controllers
>   ALSA: hda/realtek: Add quirk for Acer Aspire V3-572G
>
> Paolo Abeni (1):
>   selftests: mptcp: more stable simult_flows tests
>
> Paul Chaignon (1):
>   bpf: Improve bounds when tnum has a single possible value
>
> Paulo Alcantara (2):
>   smb: client: fix broken multichannel with krb5+signing
>   smb: client: fix oops due to uninitialised var in smb2_unlink()
>
> Peter Wang (1):
>   scsi: ufs: core: Move link recovery for hibern8 exit failure to
>     wl_resume
>
> Peter Zijlstra (9):
>   x86/cfi: Fix CFI rewrite for odd alignments
>   sched/fair: Fix zero_vruntime tracking
>   sched/fair: Only set slice protection at pick time
>   sched/fair: Fix lag clamp
>   perf: Fix __perf_event_overflow() vs perf_remove_from_context() race
>   x86/numa: Store extra copy of numa_nodes_parsed
>   x86/topo: Add topology_num_nodes_per_package()
>   x86/topo: Replace x86_has_numa_in_package
>   x86/topo: Fix SNC topology mess
>
> Petr Pavlu (1):
>   module: Remove duplicate freeing of lockdep classes
>
> Phillip Lougher (1):
>   Squashfs: check metadata block offset is within range
>
> Prithvi Tambewagh (1):
>   scsi: target: Fix recursive locking in __configfs_open_file()
>
> Qing Wang (1):
>   tracing: Fix WARN_ON in tracing_buffers_mmap_close
>
> Quentin Schulz (2):
>   accel/rocket: fix unwinding in error path in rocket_core_init
>   accel/rocket: fix unwinding in error path in rocket_probe
>
> Raju Rangoju (2):
>   amd-xgbe: fix MAC_TCR_SS register width for 2.5G and 10M speeds
>   amd-xgbe: fix sleep while atomic on suspend/resume
>
> Richard Fitzgerald (1):
>   ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()
>
> Rob Herring (Arm) (2):
>   accel: ethosu: Fix job submit error clean-up refcount underflows
>   accel: ethosu: Fix NPU_OP_ELEMENTWISE validation with scalar
>
> Rong Zhang (1):
>   ALSA: doc: usb-audio: Add doc for QUIRK_FLAG_SKIP_IFACE_SETUP
>
> Russell King (Oracle) (1):
>   net: stmmac: remove support for lpi_intr_o
>
> Salomon Dushimirimana (1):
>   scsi: pm8001: Fix use-after-free in pm8001_queue_command()
>
> Sasha Levin (1):
>   Linux 6.19.7-rc1
>
> Sebastian Andrzej Siewior (1):
>   net: Provide a PREEMPT_RT specific check for netdev_queue::_xmit_lock
>
> Sebastian Krzyszkowiak (1):
>   wifi: rsi: Don't default to -EOPNOTSUPP in rsi_mac80211_config
>
> Shuicheng Lin (2):
>   drm/xe/configfs: Free ctx_restore_mid_bb in release
>   drm/xe/reg_sr: Fix leak on xa_store failure
>
> Shuvam Pandey (1):
>   kunit: tool: copy caller args in run_kernel to prevent mutation
>
> Simon Ser (1):
>   drm/fourcc: fix plane order for 10/12/16-bit YCbCr formats
>
> Sreedevi Joshi (1):
>   idpf: Fix flow rule delete failure due to invalid validation
>
> Srinivas Pandruvada (1):
>   cpufreq: intel_pstate: Fix crash during turbo disable
>
> Sun Jian (1):
>   selftests/harness: order TEST_F and XFAIL_ADD constructors
>
> Sungwoo Kim (1):
>   nvme: fix memory allocation in nvme_pr_read_keys()
>
> T.J. Mercier (1):
>   selftests/bpf: Fix OOB read in dmabuf_collector
>
> Takashi Iwai (4):
>   ALSA: usb-audio: Cap the packet size pre-calculations
>   ALSA: usb-audio: Use inclusive terms
>   ALSA: usb: qcom: Correct parameter comment for
>     uaudio_transfer_buffer_setup()
>   ASoC: SDCA: Fix comments for sdca_irq_request()
>
> Thomas Gleixner (2):
>   debugobject: Make it work with deferred page initialization - again
>   i40e: Fix preempt count leak in napi poll tracepoint
>
> Thomas Wei=C3=9Fschuh (1):
>   ARM: clean up the memset64() C wrapper
>
> Thorsten Blum (2):
>   platform/x86: dell-wmi-sysman: Don't hex dump plaintext password data
>   smb: client: Don't log plaintext credentials in cifs_set_cifscreds
>
> Tianci Cao (1):
>   bpf: Add bitwise tracking for BPF_END
>
> Tom Lendacky (1):
>   x86/boot/sev: Move SEV decompressor variables into the .data section
>
> Tomasz Lis (1):
>   drm/xe/queue: Call fini on exec queue creation fail
>
> Tomasz Paku=C5=82a (1):
>   HID: pidff: Fix condition effect bit clearing
>
> Tvrtko Ursulin (1):
>   drm/amdgpu/userq: Do not allow userspace to trivially triger kernel
>     warnings
>
> Vahagn Vardanian (1):
>   wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()
>
> Vasily Gorbik (1):
>   s390/kexec: Disable stack protector in s390_reset_system()
>
> Vimlesh Kumar (4):
>   octeon_ep: Relocate counter updates before NAPI
>   octeon_ep: avoid compiler and IQ/OQ reordering
>   octeon_ep_vf: Relocate counter updates before NAPI
>   octeon_ep_vf: avoid compiler and IQ/OQ reordering
>
> Vitaly Lifshits (1):
>   e1000e: clear DPG_EN after reset to avoid autonomous power-gating
>
> Vivek Behera (2):
>   igb: Fix trigger of incorrect irq in igb_xsk_wakeup
>   igc: Fix trigger of incorrect irq in igc_xsk_wakeup function
>
> Waiman Long (2):
>   cgroup/cpuset: Fix incorrect change to effective_xcpus in
>     partition_xcpus_del()
>   cgroup/cpuset: Fix incorrect use of cpuset_update_tasks_cpumask() in
>     update_cpumasks_hier()
>
> Wang Tao (1):
>   sched/eevdf: Update se->vprot in reweight_entity()
>
> Werner Sembach (1):
>   HID: multitouch: Keep latency normal on deactivate for reactivation
>     gesture
>
> Will Deacon (2):
>   arm64: io: Rename ioremap_prot() to __ioremap_prot()
>   arm64: io: Extract user memory type in ioremap_prot()
>
> Yifan Wu (1):
>   selftest/arm64: Fix sve2p1_sigill() to hwcap test
>
> Yujie Liu (1):
>   drm/sched: Fix kernel-doc warning for drm_sched_job_done()
>
> Yung Chih Su (1):
>   net: ipv4: fix ARM64 alignment fault in multipath hash seed
>
> Zhang Heng (2):
>   ALSA: hda/realtek: Add quirk for HP Pavilion 15-eh1xxx to enable mute
>     LED
>   ALSA: hda/realtek: add quirk for Acer Nitro ANV15-51
>
> ZhangGuoDong (2):
>   smb/client: fix buffer size for smb311_posix_qinfo in
>     smb2_compound_op()
>   smb/client: fix buffer size for smb311_posix_qinfo in
>     SMB311_posix_query_info()
>
> Zhanjun Dong (1):
>   drm/xe/gsc: Fix GSC proxy cleanup on early initialization failure
>
> Zide Chen (1):
>   perf/x86/intel/uncore: Add per-scheduler IMC CAS count events
>
> Zilin Guan (1):
>   ice: Fix memory leak in ice_set_ringparam()
>
>  Documentation/sound/alsa-configuration.rst    |   4 +
>  Documentation/virt/kvm/api.rst                |  28 ++-
>  Makefile                                      |  12 +-
>  arch/alpha/kernel/vmlinux.lds.S               |   1 +
>  arch/arc/kernel/vmlinux.lds.S                 |   1 +
>  arch/arm/boot/compressed/vmlinux.lds.S        |   1 +
>  arch/arm/include/asm/string.h                 |  14 +-
>  arch/arm/kernel/vmlinux-xip.lds.S             |   1 +
>  arch/arm/kernel/vmlinux.lds.S                 |   1 +
>  arch/arm64/include/asm/io.h                   |  26 +-
>  arch/arm64/include/asm/pgtable-prot.h         |   3 -
>  arch/arm64/kernel/acpi.c                      |   2 +-
>  arch/arm64/kernel/vmlinux.lds.S               |   1 +
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  35 ++-
>  arch/arm64/kvm/sys_regs.c                     |   3 +
>  arch/arm64/mm/ioremap.c                       |   6 +-
>  arch/arm64/mm/mmap.c                          |   8 +-
>  arch/arm64/net/bpf_jit_comp.c                 |   2 +-
>  arch/csky/kernel/vmlinux.lds.S                |   1 +
>  arch/hexagon/kernel/vmlinux.lds.S             |   1 +
>  arch/loongarch/kernel/vmlinux.lds.S           |   1 +
>  arch/m68k/kernel/vmlinux-nommu.lds            |   1 +
>  arch/m68k/kernel/vmlinux-std.lds              |   1 +
>  arch/m68k/kernel/vmlinux-sun3.lds             |   1 +
>  arch/mips/kernel/vmlinux.lds.S                |   1 +
>  arch/nios2/kernel/vmlinux.lds.S               |   1 +
>  arch/openrisc/kernel/vmlinux.lds.S            |   1 +
>  arch/parisc/boot/compressed/vmlinux.lds.S     |   1 +
>  arch/parisc/kernel/vmlinux.lds.S              |   1 +
>  arch/powerpc/kernel/vmlinux.lds.S             |   1 +
>  arch/riscv/kernel/vmlinux.lds.S               |   1 +
>  arch/s390/include/asm/idle.h                  |   1 +
>  arch/s390/kernel/idle.c                       |  13 +-
>  arch/s390/kernel/ipl.c                        |   2 +-
>  arch/s390/kernel/irq.c                        |  10 +-
>  arch/s390/kernel/vmlinux.lds.S                |   1 +
>  arch/s390/kernel/vtime.c                      |  18 +-
>  arch/sh/kernel/vmlinux.lds.S                  |   1 +
>  arch/sparc/kernel/vmlinux.lds.S               |   1 +
>  arch/um/kernel/dyn.lds.S                      |   1 +
>  arch/um/kernel/uml.lds.S                      |   1 +
>  arch/x86/boot/compressed/Makefile             |   1 +
>  arch/x86/boot/compressed/sev.c                |   9 +-
>  arch/x86/boot/compressed/vmlinux.lds.S        |   2 +-
>  arch/x86/boot/startup/sev-shared.c            |   2 +-
>  arch/x86/coco/sev/core.c                      |   1 +
>  arch/x86/entry/entry_fred.c                   |   5 +-
>  arch/x86/events/intel/uncore_snbep.c          |  28 ++-
>  arch/x86/include/asm/cfi.h                    |  12 +-
>  arch/x86/include/asm/efi.h                    |   2 +-
>  arch/x86/include/asm/kvm_host.h               |   7 +
>  arch/x86/include/asm/linkage.h                |   4 +-
>  arch/x86/include/asm/msr-index.h              |   5 +-
>  arch/x86/include/asm/numa.h                   |   6 +
>  arch/x86/include/asm/topology.h               |   6 +
>  arch/x86/include/asm/traps.h                  |   2 +
>  arch/x86/include/uapi/asm/kvm.h               |   6 +-
>  arch/x86/kernel/alternative.c                 |  29 ++-
>  arch/x86/kernel/cpu/common.c                  |   3 +
>  arch/x86/kernel/cpu/topology.c                |  13 +-
>  arch/x86/kernel/smpboot.c                     | 201 ++++++++++-----
>  arch/x86/kernel/traps.c                       |   2 +-
>  arch/x86/kernel/vmlinux.lds.S                 |   1 +
>  arch/x86/kvm/ioapic.c                         |   2 +-
>  arch/x86/kvm/lapic.c                          |  76 +++++-
>  arch/x86/kvm/lapic.h                          |   2 +
>  arch/x86/kvm/x86.c                            |  21 +-
>  arch/x86/mm/extable.c                         |   7 +-
>  arch/x86/mm/numa.c                            |   8 +
>  arch/x86/mm/srat.c                            |   2 +
>  arch/x86/net/bpf_jit_comp.c                   |  13 +-
>  arch/x86/platform/efi/efi.c                   |   2 +-
>  arch/x86/platform/efi/quirks.c                |  55 +++-
>  block/blk-sysfs.c                             |   8 +-
>  block/elevator.c                              |  12 +-
>  drivers/accel/amdxdna/aie2_ctx.c              |  55 ++--
>  drivers/accel/amdxdna/aie2_message.c          |  36 ++-
>  drivers/accel/amdxdna/aie2_pci.c              |  23 +-
>  drivers/accel/amdxdna/aie2_pci.h              |   1 +
>  drivers/accel/amdxdna/aie2_pm.c               |   2 +-
>  drivers/accel/amdxdna/amdxdna_ctx.c           |  51 +++-
>  drivers/accel/amdxdna/amdxdna_ctx.h           |   3 +
>  drivers/accel/amdxdna/amdxdna_gem.c           |  38 +--
>  drivers/accel/amdxdna/amdxdna_pm.c            |   2 +
>  drivers/accel/amdxdna/amdxdna_pm.h            |  11 +
>  drivers/accel/amdxdna/amdxdna_ubuf.c          |   6 +-
>  drivers/accel/ethosu/ethosu_gem.c             |   7 +-
>  drivers/accel/ethosu/ethosu_job.c             |  26 +-
>  drivers/accel/rocket/rocket_core.c            |   7 +-
>  drivers/accel/rocket/rocket_drv.c             |  15 +-
>  drivers/ata/libata-eh.c                       |   3 +-
>  drivers/ata/libata-scsi.c                     |   1 +
>  drivers/block/drbd/drbd_actlog.c              |  53 ++--
>  drivers/block/drbd/drbd_interval.h            |   5 +-
>  drivers/block/drbd/drbd_req.c                 |   3 +-
>  drivers/block/zloop.c                         |  31 ++-
>  drivers/char/ipmi/ipmi_msghandler.c           |  11 +-
>  drivers/clk/imx/clk-imx8qxp.c                 |  24 +-
>  drivers/clk/imx/clk-scu.c                     |  12 +-
>  drivers/clk/imx/clk-scu.h                     |   2 +
>  drivers/cpufreq/intel_pstate.c                |  10 +-
>  drivers/crypto/ccp/sev-dev-tsm.c              |   2 +-
>  drivers/cxl/core/mbox.c                       |  11 +-
>  drivers/cxl/core/pmem.c                       |  42 +++-
>  drivers/cxl/cxl.h                             |   7 +
>  drivers/cxl/pmem.c                            |  22 +-
>  drivers/firmware/efi/mokvar-table.c           |   2 +-
>  drivers/gpio/gpiolib-shared.c                 |   6 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c       |   1 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    |  17 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c    |  12 +-
>  .../gpu/drm/amd/amdgpu/amdgpu_userq_fence.c   |   8 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_color.c   |   6 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_colorop.c |   3 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_crtc.c    |  16 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   |   8 +
>  .../gpu/drm/amd/display/dc/core/dc_stream.c   |   2 +-
>  drivers/gpu/drm/bridge/synopsys/dw-dp.c       |   4 +-
>  drivers/gpu/drm/drm_client_modeset.c          |   3 +-
>  drivers/gpu/drm/drm_syncobj.c                 |   4 +-
>  drivers/gpu/drm/imx/ipuv3/parallel-display.c  |   4 +-
>  drivers/gpu/drm/logicvc/logicvc_drm.c         |   4 +-
>  drivers/gpu/drm/scheduler/sched_main.c        |   1 +
>  drivers/gpu/drm/solomon/ssd130x.c             |   6 +-
>  drivers/gpu/drm/tiny/sharp-memory.c           |   4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c       |   4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c    |   9 +-
>  drivers/gpu/drm/xe/regs/xe_engine_regs.h      |   6 +
>  drivers/gpu/drm/xe/xe_configfs.c              |   1 +
>  drivers/gpu/drm/xe/xe_exec_queue.c            |  23 +-
>  drivers/gpu/drm/xe/xe_gsc_proxy.c             |  43 +++-
>  drivers/gpu/drm/xe/xe_gsc_types.h             |   2 +
>  drivers/gpu/drm/xe/xe_gt.c                    |  66 ++++-
>  drivers/gpu/drm/xe/xe_lrc.h                   |   3 +-
>  drivers/gpu/drm/xe/xe_reg_sr.c                |   4 +-
>  drivers/gpu/drm/xe/xe_ring_ops.c              |   9 +
>  drivers/hid/hid-cmedia.c                      |   2 +-
>  drivers/hid/hid-creative-sb0540.c             |   2 +-
>  drivers/hid/hid-multitouch.c                  |  43 +++-
>  drivers/hid/hid-zydacron.c                    |   2 +-
>  drivers/hid/usbhid/hid-pidff.c                |  11 +-
>  drivers/hwmon/aht10.c                         |   6 +-
>  drivers/hwmon/it87.c                          |   5 +-
>  drivers/hwmon/macsmc-hwmon.c                  |  53 ++--
>  drivers/hwmon/max6639.c                       |   2 +-
>  drivers/i2c/busses/i2c-i801.c                 |  14 +-
>  .../infiniband/hw/ionic/ionic_controlpath.c   |   2 +-
>  drivers/infiniband/hw/irdma/verbs.c           |   2 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c  |   5 +-
>  drivers/irqchip/irq-ls-extirq.c               |   6 +-
>  drivers/irqchip/irq-sifive-plic.c             |   7 +-
>  drivers/media/dvb-core/dmxdev.c               |   4 +-
>  drivers/net/bonding/bond_main.c               |   9 +-
>  drivers/net/bonding/bond_options.c            |   2 +
>  drivers/net/can/dummy_can.c                   |   1 +
>  drivers/net/can/spi/mcp251x.c                 |  15 +-
>  drivers/net/can/usb/ems_usb.c                 |   7 +-
>  drivers/net/can/usb/etas_es58x/es58x_core.c   |   8 +-
>  drivers/net/can/usb/f81604.c                  |  45 +++-
>  drivers/net/can/usb/ucan.c                    |   2 +-
>  drivers/net/dsa/realtek/rtl8365mb.c           |   2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-common.h   |   2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  10 -
>  drivers/net/ethernet/amd/xgbe/xgbe-main.c     |   1 -
>  drivers/net/ethernet/amd/xgbe/xgbe.h          |   3 -
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   3 +-
>  drivers/net/ethernet/freescale/enetc/enetc.c  |   2 +-
>  drivers/net/ethernet/google/gve/gve_tx_dqo.c  |  56 ++---
>  drivers/net/ethernet/intel/e1000e/defines.h   |   1 +
>  drivers/net/ethernet/intel/e1000e/ich8lan.c   |   9 +
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  41 +--
>  drivers/net/ethernet/intel/i40e/i40e_trace.h  |   2 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   5 +-
>  drivers/net/ethernet/intel/iavf/iavf_main.c   |  17 +-
>  drivers/net/ethernet/intel/ice/ice.h          |   1 +
>  drivers/net/ethernet/intel/ice/ice_base.c     |  38 ++-
>  drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  16 +-
>  drivers/net/ethernet/intel/ice/ice_idc.c      |  44 +++-
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  15 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |   7 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |   4 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c      |   3 +
>  .../net/ethernet/intel/idpf/idpf_ethtool.c    |   3 -
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   |   8 +-
>  drivers/net/ethernet/intel/igb/igb_xsk.c      |  38 ++-
>  drivers/net/ethernet/intel/igc/igc_main.c     |  34 ++-
>  drivers/net/ethernet/intel/igc/igc_ptp.c      |   3 +-
>  drivers/net/ethernet/intel/libie/fwlog.c      |   4 +
>  .../ethernet/marvell/octeon_ep/octep_main.c   |  40 ++-
>  .../net/ethernet/marvell/octeon_ep/octep_rx.c |  27 +-
>  .../marvell/octeon_ep_vf/octep_vf_main.c      |  38 ++-
>  .../marvell/octeon_ep_vf/octep_vf_rx.c        |  28 ++-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  15 +-
>  drivers/net/ethernet/stmicro/stmmac/common.h  |   1 -
>  .../net/ethernet/stmicro/stmmac/dwmac-intel.c |   4 -
>  .../ethernet/stmicro/stmmac/dwmac-loongson.c  |   7 -
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   3 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  89 +++----
>  .../ethernet/stmicro/stmmac/stmmac_platform.c |   8 -
>  .../net/ethernet/stmicro/stmmac/stmmac_vlan.c |  60 ++---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   2 +-
>  drivers/net/ethernet/ti/cpsw_ale.c            |   9 +-
>  drivers/net/ethernet/ti/icssg/icssg_prueth.c  |   8 +
>  drivers/net/phy/phy_device.c                  |  25 +-
>  drivers/net/usb/kalmia.c                      |   7 +
>  drivers/net/usb/kaweth.c                      |  13 +
>  drivers/net/usb/pegasus.c                     |  13 +-
>  drivers/net/vxlan/vxlan_core.c                |   5 +
>  drivers/net/wireless/marvell/libertas/main.c  |   4 +-
>  .../wireless/mediatek/mt76/mt76_connac_mac.c  |   1 +
>  .../net/wireless/mediatek/mt76/mt7925/mac.c   |   1 +
>  .../net/wireless/mediatek/mt76/mt7996/mac.c   |   1 +
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c   |   2 +-
>  drivers/net/wireless/st/cw1200/pm.c           |   2 +
>  drivers/net/wireless/ti/wlcore/main.c         |   4 +-
>  drivers/nfc/pn533/usb.c                       |   1 +
>  drivers/nvme/host/core.c                      |   7 +
>  drivers/nvme/host/multipath.c                 |  12 +-
>  drivers/nvme/host/pr.c                        |   4 +-
>  drivers/nvme/target/fcloop.c                  |  15 +-
>  .../pci/controller/dwc/pcie-designware-ep.c   |  25 +-
>  drivers/pinctrl/cirrus/pinctrl-cs42l43.c      |   5 +-
>  drivers/pinctrl/meson/pinctrl-amlogic-a4.c    |  70 +++++-
>  drivers/pinctrl/pinconf-generic.c             |  73 +-----
>  drivers/pinctrl/pinctrl-equilibrium.c         |  31 ++-
>  drivers/pinctrl/qcom/pinctrl-qcs615.c         |   1 +
>  .../platform/x86/dell/alienware-wmi-wmax.c    |   2 +-
>  drivers/platform/x86/dell/dell-wmi-base.c     |   6 +
>  .../dell-wmi-sysman/passwordattr-interface.c  |   1 -
>  .../x86/hp/hp-bioscfg/enum-attributes.c       |   9 +-
>  drivers/platform/x86/lenovo/thinkpad_acpi.c   |   6 +-
>  drivers/regulator/bq257xx-regulator.c         |   3 +-
>  drivers/regulator/fp9931.c                    |   7 +-
>  drivers/regulator/mt6363-regulator.c          |   4 +-
>  drivers/scsi/lpfc/lpfc_init.c                 |   2 +
>  drivers/scsi/lpfc/lpfc_sli.c                  |  36 ++-
>  drivers/scsi/lpfc/lpfc_sli4.h                 |   3 +
>  drivers/scsi/pm8001/pm8001_sas.c              |   5 +-
>  drivers/scsi/scsi_scan.c                      |   1 +
>  drivers/spi/spi-stm32.c                       |   3 +
>  drivers/target/target_core_configfs.c         |  15 +-
>  drivers/ufs/core/ufshcd.c                     |  38 ++-
>  drivers/usb/gadget/function/f_ncm.c           | 128 +++++-----
>  drivers/usb/gadget/function/u_ether.c         |  45 ++++
>  drivers/usb/gadget/function/u_ether.h         |  30 +++
>  .../usb/gadget/function/u_ether_configfs.h    | 176 +++++++++++++
>  drivers/usb/gadget/function/u_ncm.h           |   4 +-
>  drivers/xen/xen-acpi-processor.c              |   7 +-
>  fs/btrfs/delayed-inode.c                      |   2 +-
>  fs/btrfs/disk-io.c                            |   6 +-
>  fs/btrfs/inode.c                              |   2 +-
>  fs/btrfs/ioctl.c                              |   7 +-
>  fs/btrfs/scrub.c                              |   2 +-
>  fs/btrfs/tree-checker.c                       |   4 +-
>  fs/eventpoll.c                                |   5 +-
>  fs/namespace.c                                |  20 +-
>  fs/netfs/direct_write.c                       | 228 +++++++++++++++--
>  fs/netfs/internal.h                           |   4 +-
>  fs/netfs/write_collect.c                      |  21 --
>  fs/netfs/write_issue.c                        |  41 +--
>  fs/nfsd/nfsctl.c                              |   2 +-
>  fs/smb/client/connect.c                       |   1 -
>  fs/smb/client/smb2inode.c                     |   8 +-
>  fs/smb/client/smb2pdu.c                       |  24 +-
>  fs/smb/client/transport.c                     |  21 +-
>  fs/smb/server/Kconfig                         |   1 +
>  fs/smb/server/auth.c                          |   4 +-
>  fs/smb/server/smb2pdu.c                       |   5 +-
>  fs/squashfs/cache.c                           |   3 +
>  fs/xfs/scrub/orphanage.c                      |   7 +-
>  fs/xfs/xfs_notify_failure.c                   |   4 +-
>  include/asm-generic/vmlinux.lds.h             |   4 +-
>  include/linux/indirect_call_wrapper.h         |  18 +-
>  include/linux/netdevice.h                     |  27 +-
>  include/linux/pinctrl/pinconf-generic.h       |   5 -
>  include/linux/ring_buffer.h                   |   1 +
>  include/linux/sched.h                         |   1 +
>  include/linux/stmmac.h                        |   1 -
>  include/linux/tnum.h                          |   8 +
>  include/linux/uaccess.h                       |  54 ++--
>  include/net/bonding.h                         |   1 +
>  include/net/inet6_hashtables.h                |   2 +-
>  include/net/inet_hashtables.h                 |   2 +-
>  include/net/ip.h                              |   2 +-
>  include/net/ip_fib.h                          |   2 +-
>  include/net/netfilter/nf_tables.h             |  11 +-
>  include/net/sch_generic.h                     |  10 +
>  include/net/secure_seq.h                      |  45 +++-
>  include/net/tc_act/tc_ife.h                   |   4 +-
>  include/net/tcp.h                             |   6 +-
>  include/net/xdp_sock_drv.h                    |  16 +-
>  include/trace/events/netfs.h                  |   4 +-
>  include/uapi/drm/drm_fourcc.h                 |  12 +-
>  include/uapi/linux/pci_regs.h                 |   2 +-
>  io_uring/cmd_net.c                            |   2 +-
>  kernel/bpf/cpumap.c                           |  17 +-
>  kernel/bpf/devmap.c                           |  47 +++-
>  kernel/bpf/tnum.c                             |  72 ++++++
>  kernel/bpf/trampoline.c                       |   4 +-
>  kernel/bpf/verifier.c                         | 103 +++++++-
>  kernel/cgroup/cpuset.c                        |   4 +-
>  kernel/events/core.c                          |  83 ++++--
>  kernel/module/main.c                          |   6 -
>  kernel/rseq.c                                 |   5 +-
>  kernel/sched/ext_internal.h                   |   2 +-
>  kernel/sched/fair.c                           | 238 +++++++++++++-----
>  kernel/sched/sched.h                          |   4 +-
>  kernel/sched/syscalls.c                       |  30 +++
>  kernel/time/jiffies.c                         |   2 -
>  kernel/time/timekeeping.c                     |   6 +-
>  kernel/trace/blktrace.c                       |   3 +-
>  kernel/trace/ring_buffer.c                    |  21 ++
>  kernel/trace/trace.c                          |  13 +
>  kernel/trace/trace_events_trigger.c           |   3 +
>  lib/Kconfig.debug                             |   1 +
>  lib/debugobjects.c                            |  19 +-
>  mm/huge_memory.c                              |   3 +
>  mm/slub.c                                     |  13 +-
>  net/atm/lec.c                                 |  26 +-
>  net/bluetooth/hci_sock.c                      |   1 +
>  net/bluetooth/hci_sync.c                      |   2 +-
>  net/bluetooth/iso.c                           |   1 +
>  net/bluetooth/l2cap_sock.c                    |   1 +
>  net/bluetooth/sco.c                           |   1 +
>  net/bridge/br_device.c                        |   2 +-
>  net/bridge/br_input.c                         |   2 +-
>  net/bridge/br_private.h                       |  10 +
>  net/bridge/br_vlan_options.c                  |  26 +-
>  net/can/bcm.c                                 |   1 +
>  net/core/dev.c                                |   7 +-
>  net/core/devmem.c                             |   6 +-
>  net/core/filter.c                             |   6 +-
>  net/core/netpoll.c                            |   2 +-
>  net/core/secure_seq.c                         |  80 +++---
>  net/core/skmsg.c                              |  14 +-
>  net/ipv4/inet_hashtables.c                    |   8 +-
>  net/ipv4/syncookies.c                         |  11 +-
>  net/ipv4/sysctl_net_ipv4.c                    |   5 +-
>  net/ipv4/tcp.c                                |   4 +-
>  net/ipv4/tcp_bpf.c                            |   2 +-
>  net/ipv4/tcp_diag.c                           |   2 +-
>  net/ipv4/tcp_input.c                          |  38 ++-
>  net/ipv4/tcp_ipv4.c                           |  37 ++-
>  net/ipv4/tcp_minisocks.c                      |   2 +-
>  net/ipv4/udp.c                                |  27 +-
>  net/ipv4/udp_bpf.c                            |   2 +-
>  net/ipv6/inet6_hashtables.c                   |   3 +-
>  net/ipv6/route.c                              |  11 +-
>  net/ipv6/syncookies.c                         |  11 +-
>  net/ipv6/tcp_ipv6.c                           |  37 ++-
>  net/mac80211/mesh.c                           |   3 +
>  net/mac80211/mlme.c                           |   3 +
>  net/mptcp/pm.c                                |  55 +++-
>  net/mptcp/pm_kernel.c                         |   9 +
>  net/netfilter/nf_tables_api.c                 |  66 +++--
>  net/netfilter/nft_set_hash.c                  |   1 +
>  net/netfilter/nft_set_pipapo.c                |  62 ++++-
>  net/netfilter/nft_set_pipapo.h                |   2 +
>  net/netfilter/nft_set_rbtree.c                |  79 ++----
>  net/nfc/nci/core.c                            |  30 ++-
>  net/nfc/nci/data.c                            |  12 +-
>  net/nfc/rawsock.c                             |  11 +
>  net/rds/tcp.c                                 |  14 +-
>  net/sched/act_ife.c                           |  93 ++++---
>  net/sched/sch_ets.c                           |  12 +-
>  net/sched/sch_fq.c                            |   1 +
>  net/unix/af_unix.c                            |   8 +-
>  net/wireless/core.c                           |   1 +
>  net/wireless/radiotap.c                       |   4 +-
>  net/xdp/xsk.c                                 |  26 +-
>  rust/kernel/kunit.rs                          |   8 +
>  sound/hda/codecs/realtek/alc269.c             |  13 +-
>  sound/hda/codecs/side-codecs/cs35l56_hda.c    |   2 +-
>  sound/hda/controllers/intel.c                 |   2 +
>  sound/soc/sdca/Kconfig                        |   2 +
>  sound/soc/sdca/sdca_functions.c               |   5 +-
>  sound/soc/sdca/sdca_interrupts.c              |   4 +-
>  sound/usb/endpoint.c                          |   9 +-
>  sound/usb/mixer_scarlett2.c                   |  10 +-
>  sound/usb/qcom/qc_audio_offload.c             |   2 +-
>  sound/usb/quirks.c                            |   3 +-
>  sound/usb/stream.c                            |   3 +
>  sound/usb/usbaudio.h                          |   6 +
>  sound/usb/validate.c                          |   2 +-
>  tools/objtool/Makefile                        |   8 +-
>  tools/testing/kunit/kunit_kernel.py           |   6 +-
>  tools/testing/kunit/kunit_tool_test.py        |  26 ++
>  tools/testing/selftests/arm64/abi/hwcap.c     |   4 +-
>  .../testing/selftests/bpf/progs/dmabuf_iter.c |   2 +-
>  .../selftests/bpf/progs/exceptions_assert.c   |  34 +--
>  .../selftests/bpf/progs/verifier_scalar_ids.c |  56 +++--
>  .../testing/selftests/bpf/verifier/precise.c  |   8 +-
>  tools/testing/selftests/kselftest_harness.h   |   7 +-
>  .../testing/selftests/net/mptcp/mptcp_join.sh |  49 ++++
>  .../selftests/net/mptcp/simult_flows.sh       |  11 +-
>  396 files changed, 4121 insertions(+), 1792 deletions(-)
>
> --
> 2.51.0
>
>
