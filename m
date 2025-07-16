Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFE11A3177
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 05:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752644657; cv=none; b=bM/Kmf5OhpTD5Tkc1AsYwkQ7/hZxYvXk6WiZsBsHfryarCWVkaR/PDtZe3ttWOzd/ZZwdaks37bMflW1CcWH1uBges6OE+JnWPNOqMXxpYeFAjTb1GvvHnDf6UWzIMQ8xrDW+vVyPR2jr26xpauDWbRfBNNY73TCuLoJxx5WD9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752644657; c=relaxed/simple;
	bh=r3ZdKWzpOr4SE99ok7kUtjYd2fKzcivF8sS2a75WSC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vAZ72oYw+aHBOQ7iBhb/HKemtGbZDE1igAjM/466Nuc5HBFPy6SjMTaa98+LMIww2QOhFiOeUy1WSe1VJ8rB0SPsKFPssXeXh39wbOTOiA5SIVE3wYA+fFYJ+CO5/1skgK9BCWS0Qh7z0pzcP1hxB0t0dABJ6T5gY6lp7aiaO+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnEFMWXG; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnEFMWXG"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-31393526d0dso4529788a91.0
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 22:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752644654; x=1753249454; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmKktHgGggUGZITXpiKZ7GZeRf5JRBB5qKsvWccva+g=;
        b=CnEFMWXG5deiZObzTdAqEArB4EKZ75tilFCYLvs2FYguAjvXr82sHXKbmm0eEj059r
         6ttD8s3BnSXeJXyIG/x7zmjgrdNn/wMAsv4GVoJYi48A+p2eomOE+QNK2IVkR6NcJkUY
         Qp5A0FkUVLnVTmaFlclUwt6jE9FmUvaVySquSwVOM8v7gX6ch1ynwnj4PMsrc+4CIrOE
         cN4pT0YVFM6IfaL0axxM5JQVkwN/Y0k0gwu5zyI63yygTs+NumI9FSNRwJRFeKOa9Kk6
         t311XMnBXvWfhsjqOleGmrbZvi5Npo0F/J3RcsoDrk10vQU4D84/j+dvzpjUEyiYe2NQ
         yWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752644654; x=1753249454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TmKktHgGggUGZITXpiKZ7GZeRf5JRBB5qKsvWccva+g=;
        b=PQ8PgLX1g6k9DBmevbmKXLu5YL+SZf6/JycMPcWQyELDnsY7fEO5znsTJF4OVqQxdq
         NaDR07BrKCuglsxWJpxCCf/hkiXIcZsBJndSGWP2+ZROAbuptmXFUJR5X/ihvZsuOYWc
         06s+S/kM1n/4L/qLpyTlOuR0xB2wYNH5TytoyIY11fwTy6UxQ12yssdUCXsnKybphuBH
         NrqHxZJrNy8eWcPQn4gWf4eKP/GDLinCniHNktn6plWhROG4aj7aYosIDcN/iI1r6TI3
         D+XV9SlmlL68AcX9HjWuQiyefOiEHDJkHcjhiew5qVDuOdmqX7FAMd/XSpI0sS3CaE7x
         oVVw==
X-Forwarded-Encrypted: i=1; AJvYcCWKY2TFtniLVsYp5pqVI3QfFw1MbqcDtidGk3aqiMIzv5r2rOUpqJi2vf1JAIWbfGo+dvYX0gOq@lists.linux.dev
X-Gm-Message-State: AOJu0YzlNxmYQs8CTzOckoKnlxEqZ40L0yON94dl0Ifs9DVhPnIFuinX
	0CgEWeQbxnbUm4cA0XVmG94inLVVJPAGtsVzPY4cPFtfu1eqtX91xacD3lzhKZgkj0ErSud3VtN
	n3EMUm2z5EEWUQZeXoTpvCzQHxyFzPcA=
X-Gm-Gg: ASbGncuqnHsToh0aFTJfSAcA6lodrKPwujRNa+YOnU5toE3eVeLwBIew69gTq3/Gc/Z
	hhuuwyexNPRqNdP1ygboWQyvtaUiu7NUWlADNixTzFtA+8+FdClk6pDr9YxjrAoPY2khmtEN5RX
	Qv5fRDdGNJ6BbRv+/yBn8FpJXkqsalMTOdbAh3llbcWCCZCSUVl9lESDqXZKJXpkKkl+AcLL5ii
	CswfRJhDDxK884EtIxvKw==
X-Google-Smtp-Source: AGHT+IHF2aHY2D4LnhPVZU1Av2kWDUiwJBYxI7J1i6IaZwlaYR4Y2HoSzm9oBKojPPjK3O20yeYdSkOhIBgS1sO/mIc=
X-Received: by 2002:a17:90b:2d46:b0:313:d346:f347 with SMTP id
 98e67ed59e1d1-31c9e793066mr2808601a91.35.1752644653692; Tue, 15 Jul 2025
 22:44:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715130814.854109770@linuxfoundation.org>
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 16 Jul 2025 07:43:57 +0200
X-Gm-Features: Ac12FXz5P8gO5MnvYJgS8_ymQn_FMph1VLaM7LwVpVj3hfvAFzkc9k9NTGviumE
Message-ID: <CADo9pHhN80Odz+02SkKrBYJ=VJUtD3LFmtYLZzL5qvVQYpDGbg@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
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

Den tis 15 juli 2025 kl 23:09 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
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
>     Linux 6.15.7-rc1
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix potential use-after-free in oplock/lease break ack
>
> Nikunj A Dadhania <nikunj@amd.com>
>     x86/sev: Use TSC_FACTOR for Secure TSC frequency calculation
>
> Jiawen Wu <jiawenwu@trustnetic.com>
>     net: wangxun: revert the adjustment of the IRQ vector sequence
>
> Willem de Bruijn <willemb@google.com>
>     selftests/bpf: adapt one more case in test_lru_map to the new target_=
free
>
> Daniel J. Ogorchock <djogorchock@gmail.com>
>     HID: nintendo: avoid bluetooth suspend/resume stalls
>
> Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
>     HID: quirks: Add quirk for 2 Chicony Electronics HP 5MP Cameras
>
> Zhang Heng <zhangheng@kylinos.cn>
>     HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY
>
> Fangrui Song <i@maskray.me>
>     riscv: vdso: Exclude .rodata from the PT_DYNAMIC segment
>
> Willem de Bruijn <willemb@google.com>
>     bpf: Adjust free target to avoid global starvation of LRU map
>
> Nicolas Pitre <npitre@baylibre.com>
>     vt: add missing notification when switching back to text mode
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix assertion when building free space tree
>
> Long Li <longli@microsoft.com>
>     net: mana: Record doorbell physical address in PF mode
>
> Akira Inoue <niyarium@gmail.com>
>     HID: lenovo: Add support for ThinkPad X1 Tablet Thin Keyboard Gen2
>
> Shuai Zhang <quic_shuaz@quicinc.com>
>     driver: bluetooth: hci_qca:fix unable to load the BT driver
>
> Xiaowei Li <xiaowei.li@simcom.com>
>     net: usb: qmi_wwan: add SIMCom 8230C composition
>
> Tim Crawford <tcrawford@system76.com>
>     ALSA: hda/realtek: Add quirks for some Clevo laptops
>
> Yasmin Fitzgerald <sunoflife1.git@gmail.com>
>     ALSA: hda/realtek - Enable mute LED on HP Pavilion Laptop 15-eg100
>
> Yuzuru10 <yuzuru_10@proton.me>
>     ASoC: amd: yc: add quirk for Acer Nitro ANV15-41 internal mic
>
> Fengnan Chang <changfengnan@bytedance.com>
>     io_uring: make fallocate be hashed work
>
> Chris Chiu <chris.chiu@canonical.com>
>     ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook 6 G1a
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Add mic-mute LED setup for ASUS UM5606
>
> Jack Yu <jack.yu@realtek.com>
>     ASoC: rt721-sdca: fix boost gain calculation error
>
> Tamura Dai <kirinode0@gmail.com>
>     ASoC: SOF: Intel: hda: Use devm_kstrdup() to avoid memleak.
>
> Tiwei Bie <tiwei.btw@antgroup.com>
>     um: vector: Reduce stack usage in vector_eth_configure()
>
> Thomas Fourier <fourier.thomas@gmail.com>
>     atm: idt77252: Add missing `dma_map_error()`
>
> Ronnie Sahlberg <rsahlberg@whamcloud.com>
>     ublk: sanity check add_dev input for underflow
>
> Somnath Kotur <somnath.kotur@broadcom.com>
>     bnxt_en: Set DMA unmap len correctly for XDP_REDIRECT
>
> Shruti Parab <shruti.parab@broadcom.com>
>     bnxt_en: Flush FW trace before copying to the coredump
>
> Shravya KN <shravya.k-n@broadcom.com>
>     bnxt_en: Fix DCB ETS validation
>
> Alok Tiwari <alok.a.tiwari@oracle.com>
>     net: ll_temac: Fix missing tx_pending check in ethtools_set_ringparam=
()
>
> Jianbo Liu <jianbol@nvidia.com>
>     net/mlx5e: Add new prio for promiscuous mode
>
> Carolina Jubran <cjubran@nvidia.com>
>     net/mlx5e: Fix race between DIM disable and net_dim()
>
> Carolina Jubran <cjubran@nvidia.com>
>     net/mlx5: Reset bw_share field when changing a node's parent
>
> Sean Nyekjaer <sean@geanix.com>
>     can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message=
 to debug level
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe/pm: Correct comment of xe_pm_set_vram_threshold()
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe/pm: Restore display pm if there is error after display suspend
>
> Hangbin Liu <liuhangbin@gmail.com>
>     selftests: net: lib: fix shift count out of range
>
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: phy: microchip: limit 100M workaround to link-down events on LAN=
88xx
>
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: phy: microchip: Use genphy_soft_reset() to purge stale LPA bits
>
> Mingming Cao <mmc@linux.ibm.com>
>     ibmvnic: Fix hardcoded NUM_RX_STATS/NUM_TX_STATS with dynamic sizeof
>
> Kito Xu <veritas501@foxmail.com>
>     net: appletalk: Fix device refcount leak in atrtr_create()
>
> Eric Dumazet <edumazet@google.com>
>     netfilter: flowtable: account for Ethernet header in nf_flow_pppoe_pr=
oto()
>
> Miri Korenblit <miriam.rachel.korenblit@intel.com>
>     wifi: mac80211: add the virtual monitor after reconfig complete
>
> Chao Yu <chao@kernel.org>
>     erofs: fix to add missing tracepoint in erofs_readahead()
>
> Gao Xiang <xiang@kernel.org>
>     erofs: refine readahead tracepoint
>
> Michal Wajdeczko <michal.wajdeczko@intel.com>
>     drm/xe/pf: Clear all LMTT pages on alloc
>
> Pankaj Raghav <p.raghav@samsung.com>
>     block: reject bs > ps block devices when THP is disabled
>
> Zheng Qixing <zhengqixing@huawei.com>
>     nbd: fix uaf in nbd_genl_connect() error path
>
> Henry Martin <bsdhenrymartin@gmail.com>
>     wifi: mt76: mt7925: Fix null-ptr-deref in mt7925_thermal_init()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: Remove RCU section in mt7996_mac_sta_rc_work()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: Move RCU section in mt7996_mcu_add_rate_ctrl()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: Move RCU section in mt7996_mcu_add_rate_ctrl_fixed()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: Move RCU section in mt7996_mcu_set_fixed_field()
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     wifi: mt76: Assume __mt76_connac_mcu_alloc_sta_req runs in atomic con=
text
>
> Ben Skeggs <bskeggs@nvidia.com>
>     drm/nouveau/gsp: fix potential leak of memory used during acpi init
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring/zcrx: fix pp destruction warnings
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: rt2x00: fix remove callback type mismatch
>
> Moon Hee Lee <moonhee.lee.ca@gmail.com>
>     wifi: mac80211: reject VHT opmode for unsupported channel widths
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix non-transmitted BSSID profile search
>
> Lachlan Hodges <lachlan.hodges@morsemicro.com>
>     wifi: mac80211: correctly identify S1G short beacon
>
> Zheng Qixing <zhengqixing@huawei.com>
>     md/raid1,raid10: strip REQ_NOWAIT from member bios
>
> Nigel Croxon <ncroxon@redhat.com>
>     raid10: cleanup memleak at raid10_make_request
>
> Wang Jinchao <wangjinchao600@gmail.com>
>     md/raid1: Fix stack memory use after return in raid1_reshape
>
> Mikko Perttunen <mperttunen@nvidia.com>
>     drm/tegra: nvdec: Fix dma_alloc_coherent error check
>
> Daniil Dulov <d.dulov@aladdin.ru>
>     wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_t=
o_dev()
>
> Lachlan Hodges <lachlan.hodges@morsemicro.com>
>     wifi: cfg80211: fix S1G beacon head validation in nl80211
>
> Jakub Kicinski <kuba@kernel.org>
>     netlink: make sure we allow at least one dump skb
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     netlink: Fix rmem check in netlink_broadcast_deliver().
>
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: Intel: sof-function-topology-lib: Print out the unsupported dmi=
c count
>
> Gao Xiang <xiang@kernel.org>
>     erofs: fix large fragment handling
>
> Gao Xiang <xiang@kernel.org>
>     erofs: address D-cache aliasing
>
> Chao Yu <chao@kernel.org>
>     erofs: fix to add missing tracepoint in erofs_read_folio()
>
> Al Viro <viro@zeniv.linux.org.uk>
>     ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: server: make use of rdma_destroy_qp()
>
> Sascha Hauer <s.hauer@pengutronix.de>
>     clk: scmi: Handle case where child clocks are initialized before thei=
r parents
>
> Julien Massot <julien.massot@collabora.com>
>     dt-bindings: clock: mediatek: Add #reset-cells property for MT8188
>
> Mikhail Paulyshka <me@mixaill.net>
>     x86/CPU/AMD: Disable INVLPGB on Zen2
>
> Jann Horn <jannh@google.com>
>     x86/mm: Disable hugetlb page table sharing on 32-bit
>
> Mikhail Paulyshka <me@mixaill.net>
>     x86/rdrand: Disable RDSEED on AMD Cyan Skillfish
>
> Xiaolei Wang <xiaolei.wang@windriver.com>
>     clk: imx: Fix an out-of-bounds access in dispmix_csr_clk_dev_data
>
> Harry Yoo <harry.yoo@oracle.com>
>     lib/alloc_tag: do not acquire non-existent lock in alloc_tag_top_user=
s()
>
> Honggyu Kim <honggyu.kim@sk.com>
>     samples/damon: fix damon sample wsse for start failure
>
> Honggyu Kim <honggyu.kim@sk.com>
>     samples/damon: fix damon sample prcl for start failure
>
> Honggyu Kim <honggyu.kim@sk.com>
>     mm/damon: fix divide by zero in damon_get_intervals_score()
>
> SeongJae Park <sj@kernel.org>
>     mm/damon/core: handle damon_call_control as normal under kdmond deact=
ivation
>
> Lance Yang <lance.yang@linux.dev>
>     mm/rmap: fix potential out-of-bounds page table access during batched=
 unmap
>
> Alexander Gordeev <agordeev@linux.ibm.com>
>     mm/vmalloc: leave lazy MMU mode on PTE mapping error
>
> Illia Ostapyshyn <illia@yshyn.com>
>     scripts: gdb: vfs: support external dentry names
>
> Florian Fainelli <florian.fainelli@broadcom.com>
>     scripts/gdb: fix interrupts.py after maple tree conversion
>
> Florian Fainelli <florian.fainelli@broadcom.com>
>     scripts/gdb: de-reference per-CPU MCE interrupts
>
> Florian Fainelli <florian.fainelli@broadcom.com>
>     scripts/gdb: fix interrupts display after MCP on x86
>
> Baolin Wang <baolin.wang@linux.alibaba.com>
>     mm: fix the inaccurate memory statistics issue for users
>
> Wei Yang <richard.weiyang@gmail.com>
>     maple_tree: fix mt_destroy_walk() on root leaf node
>
> Yeoreum Yun <yeoreum.yun@arm.com>
>     kasan: remove kasan_find_vm_area() to prevent possible deadlock
>
> Achill Gilgenast <fossdd@pwned.life>
>     kallsyms: fix build without execinfo
>
> Zhe Qiao <qiaozhe@iscas.ac.cn>
>     Revert "PCI/ACPI: Fix allocated memory release on error in pci_acpi_s=
can_root()"
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     Revert "ACPI: battery: negate current when discharging"
>
> Matthew Brost <matthew.brost@intel.com>
>     drm/xe: Allocate PF queue size on pow2 boundary
>
> Thomas Zimmermann <tzimmermann@suse.de>
>     drm/framebuffer: Acquire internal references on GEM handles
>
> Kuen-Han Tsai <khtsai@google.com>
>     Revert "usb: gadget: u_serial: Add null pointer check in gs_start_io"
>
> Kuen-Han Tsai <khtsai@google.com>
>     usb: gadget: u_serial: Fix race condition in TTY wakeup
>
> Aaron Thompson <dev@aaront.org>
>     drm/nouveau: Do not fail module init on debugfs errors
>
> Matthew Brost <matthew.brost@intel.com>
>     Revert "drm/xe/xe2: Enable Indirect Ring State support for Xe2"
>
> Matthew Auld <matthew.auld@intel.com>
>     drm/xe/bmg: fix compressed VRAM handling
>
> Simona Vetter <simona.vetter@ffwll.ch>
>     drm/gem: Fix race in drm_gem_handle_create_tail()
>
> Christian K=C3=B6nig <christian.koenig@amd.com>
>     drm/ttm: fix error handling in ttm_buffer_object_transfer
>
> Matthew Brost <matthew.brost@intel.com>
>     drm/sched: Increment job count before swapping tail spsc queue
>
> Thomas Zimmermann <tzimmermann@suse.de>
>     drm/gem: Acquire references on GEM handles for framebuffers
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdkfd: add hqd_sdma_get_doorbell callbacks for gfx7/8
>
> Kent Russell <kent.russell@amd.com>
>     drm/amdgpu: Include sdma_4_4_4.bin
>
> Philip Yang <Philip.Yang@amd.com>
>     drm/amdkfd: Don't call mmput from MMU notifier callback
>
> Alessio Belle <alessio.belle@imgtec.com>
>     drm/imagination: Fix kernel crash when hard resetting the GPU
>
> Michael Lo <michael.lo@mediatek.com>
>     wifi: mt76: mt7925: fix invalid array index in ssid assignment during=
 hw scan
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: fix the wrong config for tx interrupt
>
> Deren Wu <deren.wu@mediatek.com>
>     wifi: mt76: mt7925: prevent NULL pointer dereference in mt7925_sta_se=
t_decap_offload()
>
> Deren Wu <deren.wu@mediatek.com>
>     wifi: mt76: mt7921: prevent decap offload config before STA initializ=
ation
>
> Vitor Soares <vitor.soares@toradex.com>
>     wifi: mwifiex: discard erroneous disassoc frames on STA interface
>
> Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
>     wifi: prevent A-MSDU attacks in mesh networks
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     pwm: mediatek: Ensure to disable clocks in error path
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     pwm: Fix invalid state detection
>
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>     pinctrl: qcom: msm: mark certain pins as invalid for interrupts
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     pinctrl: nuvoton: Fix boot on ma35dx platforms
>
> H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>     md/md-bitmap: fix GPF in bitmap_get_stats()
>
> Hugo Villeneuve <hvilleneuve@dimonoff.com>
>     gpiolib: fix performance regression when using gpio_chip_get_multiple=
()
>
> Haoxiang Li <haoxiang_li2024@163.com>
>     net: ethernet: rtsn: Fix a null pointer dereference in rtsn_probe()
>
> Guillaume Nault <gnault@redhat.com>
>     gre: Fix IPv6 multicast route creation.
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU
>
> Arun Raghavan <arun@asymptotic.io>
>     ASoC: fsl_sai: Force a software reset when starting in consumer mode
>
> Mark Brown <broonie@kernel.org>
>     arm64: Filter out SME hwcaps when FEAT_SME isn't implemented
>
> Edip Hazuri <edip@medip.dev>
>     ALSA: hda/realtek - Add mute LED support for HP Victus 15-fb2xxx
>
> Thorsten Blum <thorsten.blum@linux.dev>
>     ALSA: ad1816a: Fix potential NULL pointer deref in snd_card_ad1816a_p=
np()
>
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>     sched: Fix preemption string of preempt_dynamic_none
>
> Liam Merwick <liam.merwick@oracle.com>
>     KVM: Allow CPU to reschedule while setting per-page memory attributes
>
> Sean Christopherson <seanjc@google.com>
>     KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation is in=
-flight
>
> Nikunj A Dadhania <nikunj@amd.com>
>     KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
>
> Manuel Andreas <manuel.andreas@tum.de>
>     KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush
>
> David Woodhouse <dwmw@amazon.co.uk>
>     KVM: x86/xen: Allow 'out of range' event channel ports in IRQ routing=
 table.
>
> JP Kobryn <inwardvessel@gmail.com>
>     x86/mce: Make sure CMCI banks are cleared during shutdown on Intel
>
> Yazen Ghannam <yazen.ghannam@amd.com>
>     x86/mce: Ensure user polling settings are honored when restarting tim=
er
>
> Yazen Ghannam <yazen.ghannam@amd.com>
>     x86/mce: Don't remove sysfs if thresholding sysfs init fails
>
> Yazen Ghannam <yazen.ghannam@amd.com>
>     x86/mce/amd: Fix threshold limit reset
>
> Yazen Ghannam <yazen.ghannam@amd.com>
>     x86/mce/amd: Add default names for MCA banks and blocks
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     ipmi:msghandler: Fix potential memory corruption in ipmi_create_user(=
)
>
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix oops due to non-existence of prealloc backlog struct
>
> Eric Biggers <ebiggers@kernel.org>
>     crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2
>
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix bug due to prealloc collision
>
> Victor Nogueira <victor@mojatatu.com>
>     net/sched: Abort __tc_modify_qdisc if parent class does not exist
>
> Chintan Vankar <c-vankar@ti.com>
>     net: ethernet: ti: am65-cpsw-nuss: Fix skb size by accounting for skb=
_shared_info
>
> Yue Haibing <yuehaibing@huawei.com>
>     atm: clip: Fix NULL pointer dereference in vcc_sendmsg()
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     atm: clip: Fix infinite recursive call of clip_push().
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     atm: clip: Fix memory leak of struct clip_vcc.
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     atm: clip: Fix potential null-ptr-deref in to_atmarpd().
>
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: phy: smsc: Fix link failure in forced mode with Auto-MDIX
>
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: phy: smsc: Force predictable MDI-X state on LAN87xx
>
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap
>
> EricChan <chenchuangyu@xiaomi.com>
>     net: stmmac: Fix interrupt handling for level-triggered mode in DWC_X=
GMAC2
>
> Petr Pavlu <petr.pavlu@suse.com>
>     module: Fix memory deallocation on error path in move_module()
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     net: airoha: Fix an error handling path in airoha_probe()
>
> Michal Luczaj <mhal@rbox.co>
>     vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_lo=
cal`
>
> Michal Luczaj <mhal@rbox.co>
>     vsock: Fix transport_* TOCTOU
>
> Michal Luczaj <mhal@rbox.co>
>     vsock: Fix transport_{g2h,h2g} TOCTOU
>
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     tcp: Correct signedness in skb remaining space calculation
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     tipc: Fix use-after-free in tipc_conn_close().
>
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock: fix `vsock_proto` declaration
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     netlink: Fix wraparounds of sk->sk_rmem_alloc.
>
> Luo Jie <quic_luoj@quicinc.com>
>     net: phy: qcom: qca808x: Fix WoL issue by utilizing at8031_set_wol()
>
> Luo Jie <quic_luoj@quicinc.com>
>     net: phy: qcom: move the WoL function to shared library
>
> Anshuman Khandual <anshuman.khandual@arm.com>
>     arm64/mm: Drop wrong writes into TCR2_EL1
>
> Kevin Brodsky <kevin.brodsky@arm.com>
>     arm64: poe: Handle spurious Overlay faults
>
> Jason Xing <kernelxing@tencent.com>
>     bnxt_en: eliminate the compile warning in bnxt_request_irq due to CON=
FIG_RFS_ACCEL
>
> kuyo chang <kuyo.chang@mediatek.com>
>     sched/deadline: Fix dl_server runtime calculation formula
>
> Al Viro <viro@zeniv.linux.org.uk>
>     fix proc_sys_compare() handling of in-lookup dentries
>
> Mario Limonciello <mario.limonciello@amd.com>
>     pinctrl: amd: Clear GPIO debounce for suspend
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_event: Fix not marking Broadcast Sink BIS as connected
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_sync: Fix attempting to send HCI_Disconnect to BIS han=
dle
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_core: Remove check of BDADDR_ANY in hci_conn_hash_look=
up_big_state
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_sync: Fix not disabling advertising instance
>
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs35l56: probe() should fail if the device ID is not recognized
>
> Peter Zijlstra <peterz@infradead.org>
>     perf: Revert to requiring CAP_SYS_ADMIN for uprobes
>
> Heiko Carstens <hca@linux.ibm.com>
>     objtool: Add missing endian conversion to read_annotate()
>
> Peter Zijlstra <peterz@infradead.org>
>     sched/core: Fix migrate_swap() vs. hotplug
>
> Nam Cao <namcao@linutronix.de>
>     irqchip/irq-msi-lib: Select CONFIG_GENERIC_MSI_IRQ
>
> Shiju Jose <shiju.jose@huawei.com>
>     EDAC: Initialize EDAC features sysfs attributes
>
> Luo Gengkun <luogengkun@huaweicloud.com>
>     perf/core: Fix the WARN_ON_ONCE is out of lock protected region
>
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: Intel: soc-acpi: arl: Correct order of cs42l43 matches
>
> Bard Liao <yung-chuan.liao@linux.intel.com>
>     ASoC: Intel: soc-acpi-intel-arl-match: set get_function_tplg_files op=
s
>
> Bard Liao <yung-chuan.liao@linux.intel.com>
>     ASoC: Intel: add sof_sdw_get_tplg_files ops
>
> Bard Liao <yung-chuan.liao@linux.intel.com>
>     ASoC: soc-acpi: add get_function_tplg_files ops
>
> Bard Liao <yung-chuan.liao@linux.intel.com>
>     ASoC: Intel: SND_SOC_INTEL_SOF_BOARD_HELPERS select SND_SOC_ACPI_INTE=
L_MATCH
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode
>
> Kaustabh Chakraborty <kauschluss@disroot.org>
>     drm/exynos: exynos7_drm_decon: add vblank check in IRQ handling
>
> Linus Torvalds <torvalds@linux-foundation.org>
>     eventpoll: don't decrement ep refcount while still holding the ep mut=
ex
>
>
> -------------
>
> Diffstat:
>
>  Documentation/bpf/map_hash.rst                     |   8 +-
>  Documentation/bpf/map_lru_hash_update.dot          |   6 +-
>  .../bindings/clock/mediatek,mt8188-clock.yaml      |   3 +
>  Makefile                                           |   4 +-
>  arch/arm64/kernel/cpufeature.c                     |  57 +++--
>  arch/arm64/kernel/process.c                        |   5 +
>  arch/arm64/mm/fault.c                              |  30 ++-
>  arch/arm64/mm/proc.S                               |   1 -
>  arch/riscv/kernel/vdso/vdso.lds.S                  |   2 +-
>  arch/s390/crypto/sha1_s390.c                       |   2 +
>  arch/s390/crypto/sha256_s390.c                     |   3 +
>  arch/s390/crypto/sha512_s390.c                     |   3 +
>  arch/um/drivers/vector_kern.c                      |  42 ++--
>  arch/x86/Kconfig                                   |   2 +-
>  arch/x86/coco/sev/core.c                           |  22 +-
>  arch/x86/include/asm/msr-index.h                   |   1 +
>  arch/x86/include/asm/sev.h                         |  17 +-
>  arch/x86/kernel/cpu/amd.c                          |  10 +
>  arch/x86/kernel/cpu/mce/amd.c                      |  28 ++-
>  arch/x86/kernel/cpu/mce/core.c                     |  24 +-
>  arch/x86/kernel/cpu/mce/intel.c                    |   1 +
>  arch/x86/kvm/hyperv.c                              |   3 +
>  arch/x86/kvm/svm/sev.c                             |   4 +
>  arch/x86/kvm/xen.c                                 |  15 +-
>  drivers/acpi/battery.c                             |  19 +-
>  drivers/atm/idt77252.c                             |   5 +
>  drivers/block/nbd.c                                |   6 +-
>  drivers/block/ublk_drv.c                           |   3 +-
>  drivers/bluetooth/hci_qca.c                        |  13 +-
>  drivers/char/ipmi/ipmi_msghandler.c                |   3 +-
>  drivers/clk/clk-scmi.c                             |  20 +-
>  drivers/clk/imx/clk-imx95-blk-ctl.c                |  12 +-
>  drivers/edac/ecs.c                                 |   4 +-
>  drivers/edac/mem_repair.c                          |   1 +
>  drivers/edac/scrub.c                               |   1 +
>  drivers/gpio/gpiolib.c                             |   5 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c  |   8 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c  |   8 +
>  drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |   1 +
>  drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  43 ++--
>  drivers/gpu/drm/drm_framebuffer.c                  |  31 ++-
>  drivers/gpu/drm/drm_gem.c                          |  74 +++++-
>  drivers/gpu/drm/drm_internal.h                     |   2 +
>  drivers/gpu/drm/exynos/exynos7_drm_decon.c         |   4 +
>  drivers/gpu/drm/imagination/pvr_power.c            |   4 +-
>  drivers/gpu/drm/nouveau/nouveau_debugfs.c          |   6 +-
>  drivers/gpu/drm/nouveau/nouveau_debugfs.h          |   5 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.c              |   4 +-
>  drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c     |  20 +-
>  drivers/gpu/drm/tegra/nvdec.c                      |   6 +-
>  drivers/gpu/drm/ttm/ttm_bo_util.c                  |  13 +-
>  drivers/gpu/drm/xe/xe_gt_pagefault.c               |   1 +
>  drivers/gpu/drm/xe/xe_lmtt.c                       |  11 +
>  drivers/gpu/drm/xe/xe_migrate.c                    |   2 +-
>  drivers/gpu/drm/xe/xe_pci.c                        |   1 -
>  drivers/gpu/drm/xe/xe_pm.c                         |  11 +-
>  drivers/hid/hid-ids.h                              |   6 +
>  drivers/hid/hid-lenovo.c                           |   8 +
>  drivers/hid/hid-multitouch.c                       |   8 +-
>  drivers/hid/hid-nintendo.c                         |  38 +++-
>  drivers/hid/hid-quirks.c                           |   3 +
>  drivers/irqchip/Kconfig                            |   1 +
>  drivers/md/md-bitmap.c                             |   3 +-
>  drivers/md/raid1.c                                 |   4 +-
>  drivers/md/raid10.c                                |  12 +-
>  drivers/net/can/m_can/m_can.c                      |   2 +-
>  drivers/net/ethernet/airoha/airoha_eth.c           |   1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |  18 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |   2 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   2 +-
>  drivers/net/ethernet/ibm/ibmvnic.h                 |   8 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   9 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_dim.c   |   4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   1 +
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  13 +-
>  drivers/net/ethernet/microsoft/mana/gdma_main.c    |   3 +
>  drivers/net/ethernet/renesas/rtsn.c                |   5 +
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  24 +-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   4 +-
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c        |  16 +-
>  drivers/net/ethernet/wangxun/libwx/wx_type.h       |   2 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   2 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h      |   2 +-
>  drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c     |   4 +-
>  drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |   4 +-
>  drivers/net/ethernet/xilinx/ll_temac_main.c        |   2 +-
>  drivers/net/phy/microchip.c                        |   3 +-
>  drivers/net/phy/qcom/at803x.c                      |  27 ---
>  drivers/net/phy/qcom/qca808x.c                     |   2 +-
>  drivers/net/phy/qcom/qcom-phy-lib.c                |  25 ++
>  drivers/net/phy/qcom/qcom.h                        |   5 +
>  drivers/net/phy/smsc.c                             |  57 ++++-
>  drivers/net/usb/qmi_wwan.c                         |   1 +
>  drivers/net/wireless/marvell/mwifiex/util.c        |   4 +-
>  .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   6 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   3 +
>  drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   2 +
>  drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   6 +
>  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/regs.h   |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  40 +---
>  drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   5 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 188 ++++++++++-----
>  drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  16 +-
>  drivers/net/wireless/ralink/rt2x00/rt2x00soc.c     |   4 +-
>  drivers/net/wireless/ralink/rt2x00/rt2x00soc.h     |   2 +-
>  drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   6 +-
>  drivers/pci/pci-acpi.c                             |  23 +-
>  drivers/pinctrl/nuvoton/pinctrl-ma35.c             |  10 +-
>  drivers/pinctrl/pinctrl-amd.c                      |  11 +
>  drivers/pinctrl/qcom/pinctrl-msm.c                 |  20 ++
>  drivers/pwm/core.c                                 |   2 +-
>  drivers/pwm/pwm-mediatek.c                         |  13 +-
>  drivers/tty/vt/vt.c                                |   1 +
>  drivers/usb/gadget/function/u_serial.c             |  12 +-
>  fs/btrfs/free-space-tree.c                         |  16 +-
>  fs/erofs/data.c                                    |  21 +-
>  fs/erofs/decompressor.c                            |  12 +-
>  fs/erofs/fileio.c                                  |   6 +-
>  fs/erofs/internal.h                                |   6 +-
>  fs/erofs/zdata.c                                   |  13 +-
>  fs/erofs/zmap.c                                    |   9 +-
>  fs/eventpoll.c                                     |  12 +-
>  fs/proc/inode.c                                    |   2 +-
>  fs/proc/proc_sysctl.c                              |  18 +-
>  fs/proc/task_mmu.c                                 |  14 +-
>  fs/smb/server/smb2pdu.c                            |  29 +--
>  fs/smb/server/transport_rdma.c                     |   5 +-
>  fs/smb/server/vfs.c                                |   1 +
>  include/drm/drm_file.h                             |   3 +
>  include/drm/drm_framebuffer.h                      |   7 +
>  include/drm/spsc_queue.h                           |   4 +-
>  include/linux/blkdev.h                             |   5 +
>  include/linux/ieee80211.h                          |  45 +++-
>  include/linux/io_uring_types.h                     |   2 +
>  include/linux/mm.h                                 |   5 +
>  include/linux/psp-sev.h                            |   2 +
>  include/net/af_vsock.h                             |   2 +-
>  include/net/bluetooth/hci_core.h                   |   3 +-
>  include/net/netfilter/nf_flow_table.h              |   2 +-
>  include/sound/soc-acpi.h                           |  13 ++
>  include/trace/events/erofs.h                       |   2 +-
>  io_uring/msg_ring.c                                |   4 +-
>  io_uring/opdef.c                                   |   1 +
>  io_uring/zcrx.c                                    |   3 -
>  kernel/bpf/bpf_lru_list.c                          |   9 +-
>  kernel/bpf/bpf_lru_list.h                          |   1 +
>  kernel/events/core.c                               |   6 +-
>  kernel/module/main.c                               |   4 +-
>  kernel/sched/core.c                                |   7 +-
>  kernel/sched/deadline.c                            |  10 +-
>  kernel/stop_machine.c                              |  20 +-
>  lib/alloc_tag.c                                    |   3 +
>  lib/maple_tree.c                                   |   1 +
>  mm/damon/core.c                                    |   8 +-
>  mm/kasan/report.c                                  |  45 +---
>  mm/rmap.c                                          |  46 ++--
>  mm/vmalloc.c                                       |  22 +-
>  net/appletalk/ddp.c                                |   1 +
>  net/atm/clip.c                                     |  64 ++++--
>  net/bluetooth/hci_event.c                          |   3 +
>  net/bluetooth/hci_sync.c                           |   4 +-
>  net/ipv4/tcp.c                                     |   2 +-
>  net/ipv6/addrconf.c                                |   9 +-
>  net/mac80211/cfg.c                                 |  14 ++
>  net/mac80211/mlme.c                                |   7 +-
>  net/mac80211/parse.c                               |   6 +-
>  net/mac80211/util.c                                |   9 +-
>  net/netlink/af_netlink.c                           |  90 +++++---
>  net/rxrpc/call_accept.c                            |   4 +
>  net/sched/sch_api.c                                |  23 +-
>  net/tipc/topsrv.c                                  |   2 +
>  net/vmw_vsock/af_vsock.c                           |  57 ++++-
>  net/wireless/nl80211.c                             |   7 +-
>  net/wireless/util.c                                |  52 ++++-
>  samples/damon/prcl.c                               |   8 +-
>  samples/damon/wsse.c                               |   8 +-
>  scripts/gdb/linux/constants.py.in                  |   7 +
>  scripts/gdb/linux/interrupts.py                    |  16 +-
>  scripts/gdb/linux/mapletree.py                     | 252 +++++++++++++++=
++++++
>  scripts/gdb/linux/vfs.py                           |   2 +-
>  scripts/gdb/linux/xarray.py                        |  28 +++
>  sound/isa/ad1816a/ad1816a.c                        |   2 +-
>  sound/pci/hda/patch_realtek.c                      |  10 +
>  sound/soc/amd/yc/acp6x-mach.c                      |   7 +
>  sound/soc/codecs/cs35l56-shared.c                  |   2 +-
>  sound/soc/codecs/rt721-sdca.c                      |  23 +-
>  sound/soc/fsl/fsl_asrc.c                           |   3 +-
>  sound/soc/fsl/fsl_sai.c                            |  14 +-
>  sound/soc/intel/boards/Kconfig                     |   1 +
>  sound/soc/intel/common/Makefile                    |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-arl-match.c  |  21 +-
>  sound/soc/intel/common/sof-function-topology-lib.c | 136 +++++++++++
>  sound/soc/intel/common/sof-function-topology-lib.h |  15 ++
>  sound/soc/sof/intel/hda.c                          |   6 +-
>  tools/arch/x86/include/asm/msr-index.h             |   1 +
>  tools/include/linux/kallsyms.h                     |   4 +
>  tools/objtool/check.c                              |   1 +
>  tools/testing/selftests/bpf/test_lru_map.c         | 105 ++++-----
>  tools/testing/selftests/net/lib.sh                 |   2 +-
>  virt/kvm/kvm_main.c                                |   3 +
>  203 files changed, 2012 insertions(+), 833 deletions(-)
>
>
>
