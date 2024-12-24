Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2319D074
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 12:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735043125; cv=none; b=I8pbPNpPeN2SFF2GAyZlkClpghJJCUxZDv9IOeXv+VyXEhfmWykyR9pJRdfKv0Yxz0ZDegdv+Na61SKZF4gAA1wNLTaShO5of4a8kNvOcsAnmdBzCaLgFo3EO45S9HyWPBUQjyoukuJRt4593vj7L4E59WBkyn0R/G+XnXCyJ1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735043125; c=relaxed/simple;
	bh=2aLJNU+5xghvnLAhZvE29TCWx+lIoPFTEjkD6x2zhes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bzH5g1UrnMVBLlOLMV47Q625b6wTnJoQvm5KCy3V2jyxfPY2Z3dRHHNQ7mNf9JT4eMyfzPHMJyVXDvKLoEX1DJufma/FvOwKHg9gY2VYuLVj8SO7dpxA9Fm65vYllrQpnVeM46qhbWlXM9bBxCKxlcrOWnZBCRyjgyV8zZjbkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mk5Somja; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mk5Somja"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f441791e40so4490075a91.3
        for <patches@lists.linux.dev>; Tue, 24 Dec 2024 04:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735043122; x=1735647922; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2I7isWHcR2yTMcQX+2cVvXFndCbXWvOMDAYmwt374Tc=;
        b=Mk5SomjabEGDu/YDgLrcGLzKPFZ2qmzbPNoZ5liOFTH7e8yc6redfbFklUWqFyHf/g
         AEg0SmASlJvyt+gJjN+zaXo0PM41LjJgMX+78F9ItCRNE9fmkClnB2NFP6xOzocU2bhY
         hjpP4wdspOu/OvbEi8TeHUbByq3WOlC5Yc3HBAaRQGNYrLInc+Xbu7C+GLnjUSJJkAYA
         SRjYr12C1nMyr9xFOHB6xUYOpitHx7wwThCSguNc44vuQrHozoGqSJKD5HIbf6k/rpKY
         V7TrPv4YpSAYNYbBz9CBnZNwSm24InwQA4EVyOarCFJ4UZIXlWeJ67lu45i535mz1XfT
         KTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735043122; x=1735647922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2I7isWHcR2yTMcQX+2cVvXFndCbXWvOMDAYmwt374Tc=;
        b=bXoCDou/5J3T62yG4jALZ9AmhfEupxfTCOXPW1KghMw0ymCfPKXrxPgRbET0iVfwje
         tUb04saZPtn9JQN0h4f/c65OXfrzB77fc0eCAKVepvcSrQUIrq0B7Zy7rMlKzKkjbbDY
         cuaqQwLK89UEz1OYfvRXF1nVmCXI1buEqgzEhl6Xz7dtLqta661QPXf7t9J6bEE+P9xo
         pSAiosq2EwnuX3s4bxGYQohKFRgS0s/FbLG+9G9EwKd2oUTiN70EHXsmx/ZhXr3TkhTM
         nbeI0DZiEJIQ/8zWy8OzHV8yzlU9T5EztfXvDQoQuzEaprd2ifeT73zc8fe9S9NzTeij
         9LJA==
X-Forwarded-Encrypted: i=1; AJvYcCV9aLvVwbbm323ZjOQ9H86vDr3X8lp1h6GGfSjtfvV68GH5BZqhzhf/tYhqempy4EPEUifw4FKe@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm5amR/HIgjy/mQcsZNyhImqZR0rEaEt/2/zuiHteQ1/ftNiHI
	XtCzRSBhIe1aQZ5CzvJJHRBF9ZNSxvWdfrgBzSKMDzFXSW+Sd363ZktpmxLfhGDw94AD9FDPxPc
	QmWdBzhQx3KM66ZICAKNIuhNZoCc=
X-Gm-Gg: ASbGncuvwjJ0JABdqtSwj2gczrqXHSSsYxcWep3/rknfz9gUSIUIvJzhtWkmHVaxFeR
	/Q4BrRblF2IF8Z65VRbiY2Addcva52Y+RsJdkfapFGwnip4XviXqQ
X-Google-Smtp-Source: AGHT+IHpijoR8a67tpmyGVLBIVxScnKfAq3qec7GLPUQLHdsFr9CJ3e4WQXxVHVXrEWL/Ditk4+k2rUFWTFDKXapKQE=
X-Received: by 2002:a17:90b:5347:b0:2ee:3fa7:ef4d with SMTP id
 98e67ed59e1d1-2f452ec37bamr24840526a91.24.1735043122184; Tue, 24 Dec 2024
 04:25:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241223155408.598780301@linuxfoundation.org>
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 24 Dec 2024 13:25:09 +0100
Message-ID: <CADo9pHg3F=tTR6X-udAELorHYSOC3hA61RzGaWFBFQjSLCR0Mg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Works as it should

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

and merry xmas here from Sweden :)

Den m=C3=A5n 23 dec. 2024 kl 17:00 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
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
>     Linux 6.12.7-rc1
>
> Xuewen Yan <xuewen.yan@unisoc.com>
>     epoll: Add synchronous wakeup support for ep_poll_callback
>
> Usama Arif <usamaarif642@gmail.com>
>     mm: convert partially_mapped set/clear operations to be atomic
>
> Hugh Dickins <hughd@google.com>
>     mm: shmem: fix ShmemHugePages at swapout
>
> Kefeng Wang <wangkefeng.wang@huawei.com>
>     mm: use aligned address in copy_user_gigantic_page()
>
> Kefeng Wang <wangkefeng.wang@huawei.com>
>     mm: use aligned address in clear_gigantic_page()
>
> Ilya Dryomov <idryomov@gmail.com>
>     ceph: fix memory leak in ceph_direct_read_write()
>
> Max Kellermann <max.kellermann@ionos.com>
>     ceph: fix memory leaks in __ceph_sync_read()
>
> Alex Markuze <amarkuze@redhat.com>
>     ceph: improve error handling and short/overflow-read logic in __ceph_=
sync_read()
>
> Ilya Dryomov <idryomov@gmail.com>
>     ceph: validate snapdirname option length when mounting
>
> Max Kellermann <max.kellermann@ionos.com>
>     ceph: give up on paths longer than PATH_MAX
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     of: Fix refcount leakage for OF node returned by __of_get_dma_parent(=
)
>
> Herve Codina <herve.codina@bootlin.com>
>     of: Fix error path in of_parse_phandle_with_args_map()
>
> Andrea della Porta <andrea.porta@suse.com>
>     of: address: Preserve the flags portion on 1:1 dma-ranges mapping
>
> Samuel Holland <samuel.holland@sifive.com>
>     of: property: fw_devlink: Do not use interrupt-parent directly
>
> Jann Horn <jannh@google.com>
>     udmabuf: also check for F_SEAL_FUTURE_WRITE
>
> Jann Horn <jannh@google.com>
>     udmabuf: fix racy memfd sealing check
>
> Edward Adam Davis <eadavis@qq.com>
>     nilfs2: prevent use of deleted inode
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix buffer head leaks in calls to truncate_inode_pages()
>
> Heming Zhao <heming.zhao@suse.com>
>     ocfs2: fix the space leak in LA when releasing LA
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     of/irq: Fix using uninitialized variable @addr_len in API of_irq_pars=
e_one()
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     of/irq: Fix interrupt-map cell length check in of_irq_parse_imap_pare=
nt()
>
> Sean Christopherson <seanjc@google.com>
>     KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS/pnfs: Fix a live lock between recalled layouts and layoutget
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: check if iowq is killed before queuing
>
> Jann Horn <jannh@google.com>
>     io_uring: Fix registered ring file refcount leak
>
> Tiezhu Yang <yangtiezhu@loongson.cn>
>     selftests/bpf: Use asm constraint "m" for LoongArch
>
> Isaac J. Manjarres <isaacmanjarres@google.com>
>     selftests/memfd: run sysctl tests when PID namespace support is enabl=
ed
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Check "%s" dereference via the field and not the TP_printk f=
ormat
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Add "%s" check in test_event_printk()
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Add missing helper functions in event pointer dereference ch=
eck
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Fix test_event_printk() to process entire print argument
>
> Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
>     accel/ivpu: Fix WARN in ivpu_ipc_send_receive_internal()
>
> Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
>     accel/ivpu: Fix general protection fault in ivpu_bo_list()
>
> Enzo Matsumiya <ematsumiya@suse.de>
>     smb: client: fix TCP timers deadlock after rmmod
>
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Play nice with protected guests in complete_hypercall_exit(=
)
>
> Naman Jain <namjain@linux.microsoft.com>
>     x86/hyperv: Fix hv tsc page based sched_clock for hibernation
>
> Dexuan Cui <decui@microsoft.com>
>     tools: hv: Fix a complier warning in the fcopy uio daemon
>
> Michael Kelley <mhklinux@outlook.com>
>     Drivers: hv: util: Avoid accessing a ringbuffer not initialized yet
>
> Steven Rostedt <rostedt@goodmis.org>
>     fgraph: Still initialize idle shadow stacks when starting
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/mmhub4.1: fix IP version check
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/gfx12: fix IP version check
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/nbio7.0: fix IP version check
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/mm: Fix DirectMap accounting
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: tree-checker: reject inline extent items with 0 ref count
>
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fix improper generation check in snapshot delete
>
> Christoph Hellwig <hch@lst.de>
>     btrfs: split bios to the fs sector size boundary
>
> Suren Baghdasaryan <surenb@google.com>
>     alloc_tag: fix set_codetag_empty() when !CONFIG_MEM_ALLOC_PROFILING_D=
EBUG
>
> Edward Adam Davis <eadavis@qq.com>
>     ring-buffer: Fix overflow in __rb_map_vma
>
> David Hildenbrand <david@redhat.com>
>     mm/page_alloc: don't call pfn_to_page() on possibly non-existent PFN =
in split_large_buddy()
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     vmalloc: fix accounting with i915
>
> Kairui Song <kasong@tencent.com>
>     zram: fix uninitialized ZRAM not releasing backing device
>
> Kairui Song <kasong@tencent.com>
>     zram: refuse to use zero sized block device as backing device
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/smu14.0.2: fix IP version check
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/nbio7.7: fix IP version check
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/nbio7.11: fix IP version check
>
> Steven Rostedt <rostedt@goodmis.org>
>     trace/ring-buffer: Do not use TP_printk() formatting for boot mapped =
buffers
>
> Ming Lei <ming.lei@redhat.com>
>     block: avoid to reuse `hctx` not removed from cpuhp callback list
>
> Murad Masimov <m.masimov@maxima.ru>
>     hwmon: (tmp513) Fix interpretation of values of Temperature Result an=
d Limit Registers
>
> Murad Masimov <m.masimov@maxima.ru>
>     hwmon: (tmp513) Fix Current Register value interpretation
>
> Murad Masimov <m.masimov@maxima.ru>
>     hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Lim=
it Registers
>
> Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
>     drm/amdgpu: don't access invalid sched
>
> Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
>     i915/guc: Accumulate active runtime on gt reset
>
> Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
>     i915/guc: Ensure busyness counter increases motonically
>
> Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
>     i915/guc: Reset engine utilization buffer before registration
>
> Michael Trimarchi <michael@amarulasolutions.com>
>     drm/panel: synaptics-r63353: Fix regulator unbalance
>
> Marek Vasut <marex@denx.de>
>     drm/panel: st7701: Add prepare_prev_first flag to drm_panel
>
> Yang Yingliang <yangyingliang@huawei.com>
>     drm/panel: novatek-nt35950: fix return value check in nt35950_probe()
>
> Zhang Zekun <zhangzekun11@huawei.com>
>     drm/panel: himax-hx83102: Add a check to prevent NULL pointer derefer=
ence
>
> T.J. Mercier <tjmercier@google.com>
>     dma-buf: Fix __dma_buf_debugfs_list_del argument for !CONFIG_DEBUG_FS
>
> Jann Horn <jannh@google.com>
>     udmabuf: fix memory leak on last export_udmabuf() error path
>
> Huan Yang <link@vivo.com>
>     udmabuf: udmabuf_create pin folio codestyle cleanup
>
> Michel D=C3=A4nzer <mdaenzer@redhat.com>
>     drm/amdgpu: Handle NULL bo->tbo.resource (again) in amdgpu_vm_bo_upda=
te
>
> Christian K=C3=B6nig <christian.koenig@amd.com>
>     drm/amdgpu: fix amdgpu_coredump
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     drm/modes: Avoid divide by zero harder in drm_mode_vrefresh()
>
> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amd: Update strapping for NBIO 2.5.0
>
> Krzysztof Karas <krzysztof.karas@intel.com>
>     drm/display: use ERR_PTR on DP tunnel manager creation fail
>
> Mario Limonciello <mario.limonciello@amd.com>
>     thunderbolt: Don't display nvm_version unless upgrade supported
>
> Mika Westerberg <mika.westerberg@linux.intel.com>
>     thunderbolt: Improve redrive mode handling
>
> Mika Westerberg <mika.westerberg@linux.intel.com>
>     thunderbolt: Add support for Intel Panther Lake-M/P
>
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: Turn NEC specific quirk for handling Stop Endpoint errors gener=
ic
>
> Daniele Palmas <dnlplm@gmail.com>
>     USB: serial: option: add Telit FE910C04 rmnet compositions
>
> Jack Wu <wojackbb@gmail.com>
>     USB: serial: option: add MediaTek T7XX compositions
>
> Mank Wang <mank.wang@netprisma.com>
>     USB: serial: option: add Netprisma LCUK54 modules for WWAN Ready
>
> Michal Hrusecky <michal.hrusecky@turris.com>
>     USB: serial: option: add MeiG Smart SLM770A
>
> Daniel Swanemar <d.swanemar@gmail.com>
>     USB: serial: option: add TCL IK512 MBIM & ECM
>
> Nathan Chancellor <nathan@kernel.org>
>     hexagon: Disable constant extender optimization for LLVM prior to 19.=
1.0
>
> James Bottomley <James.Bottomley@HansenPartnership.com>
>     efivarfs: Fix error on non-existent file
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     i2c: riic: Always round-up when calculating bus period
>
> Ming Lei <ming.lei@redhat.com>
>     block: Revert "block: Fix potential deadlock while freezing queue and=
 acquiring sysfs_lock"
>
> Jeremy Kerr <jk@codeconstruct.com.au>
>     net: mctp: handle skb cleanup on sock_queue failures
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     chelsio/chtls: prevent potential integer overflow on 32bit
>
> Eric Dumazet <edumazet@google.com>
>     net: tun: fix tun_napi_alloc_frags()
>
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Cache CPUID.0xD XSTATE offsets+sizes during module init
>
> Marc Zyngier <maz@kernel.org>
>     KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden
>
> Borislav Petkov (AMD) <bp@alien8.de>
>     EDAC/amd64: Simplify ECC check on unified memory controllers
>
> Marc Zyngier <maz@kernel.org>
>     irqchip/gic-v3: Work around insecure GIC integrations
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     mmc: mtk-sd: disable wakeup in .remove() and in the error path of .pr=
obe()
>
> Prathamesh Shete <pshete@nvidia.com>
>     mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     net: mdiobus: fix an OF node reference leak
>
> Adrian Moreno <amorenoz@redhat.com>
>     psample: adjust size if rate_as_probability is set
>
> Jakub Kicinski <kuba@kernel.org>
>     netdev-genl: avoid empty messages in queue dump
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: dsa: restore dsa_software_vlan_untag() ability to operate on VLA=
N-untagged traffic
>
> Adrian Moreno <amorenoz@redhat.com>
>     selftests: openvswitch: fix tcpdump execution
>
> Phil Sutter <phil@nwl.cc>
>     netfilter: ipset: Fix for recursive locking warning
>
> David Laight <David.Laight@ACULAB.COM>
>     ipvs: Fix clamp() of ip_vs_conn_tab on small memory systems
>
> Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
>     can: m_can: fix missed interrupts with m_can_pci
>
> Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
>     can: m_can: set init flag earlier in probe
>
> Eric Dumazet <edumazet@google.com>
>     net: netdevsim: fix nsim_pp_hold_write()
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     net: ethernet: bgmac-platform: fix an OF node reference leak
>
> Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
>     net: ethernet: oa_tc6: fix tx skb race condition between reference po=
inters
>
> Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
>     net: ethernet: oa_tc6: fix infinite loop error when tx credits become=
s 0
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     net: hinic: Fix cleanup in create_rxqs/txqs()
>
> Daniel Borkmann <daniel@iogearbox.net>
>     team: Fix feature exposure when no ports are present
>
> Jakub Kicinski <kuba@kernel.org>
>     netdev: fix repeated netlink messages in queue stats
>
> Jakub Kicinski <kuba@kernel.org>
>     netdev: fix repeated netlink messages in queue dump
>
> Marios Makassikis <mmakassikis@freebox.fr>
>     ksmbd: fix broken transfers when exceeding max simultaneous operation=
s
>
> Marios Makassikis <mmakassikis@freebox.fr>
>     ksmbd: count all requests in req_running counter
>
> Nikita Yushchenko <nikita.yoush@cogentembedded.com>
>     net: renesas: rswitch: rework ts tags management
>
> Shannon Nelson <shannon.nelson@amd.com>
>     ionic: use ee->offset when returning sprom data
>
> Shannon Nelson <shannon.nelson@amd.com>
>     ionic: no double destroy workqueue
>
> Brett Creeley <brett.creeley@amd.com>
>     ionic: Fix netdev notifier unregister on failure
>
> Donald Hunter <donald.hunter@gmail.com>
>     tools/net/ynl: fix sub-message key lookup for nested attributes
>
> Eric Dumazet <edumazet@google.com>
>     netdevsim: prevent bad user input in nsim_dev_health_break_write()
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: mscc: ocelot: fix incorrect IFH SRC_PORT field in ocelot_ifh_set=
_basic()
>
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>     net/smc: check return value of sock_recvmsg when draining clc data
>
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>     net/smc: check smcd_v2_ext_offset when receiving proposal msg
>
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>     net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving propo=
sal msg
>
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>     net/smc: check iparea_offset and ipv6_prefixes_cnt when receiving pro=
posal msg
>
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>     net/smc: check sndbuf_space again after NOSPACE flag is set in smc_po=
ll
>
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>     net/smc: protect link down work from execute after lgr freed
>
> Huaisheng Ye <huaisheng.ye@intel.com>
>     cxl/region: Fix region creation for greater than x2 switches
>
> Davidlohr Bueso <dave@stgolabs.net>
>     cxl/pci: Fix potential bogus return value upon successful probing
>
> Olaf Hering <olaf@aepfle.de>
>     tools: hv: change permissions of NetworkManager configuration file
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: fix zero byte checking in the superblock scrubber
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: fix sb_spino_align checks for large fsblock sizes
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: fix off-by-one error in fsmap's end_daddr usage
>
> Dave Chinner <dchinner@redhat.com>
>     xfs: fix sparse inode limits on runt AG
>
> Dave Chinner <dchinner@redhat.com>
>     xfs: sb_spino_align is not verified
>
> Gao Xiang <xiang@kernel.org>
>     erofs: use buffered I/O for file-backed mounts by default
>
> Gao Xiang <xiang@kernel.org>
>     erofs: reference `struct erofs_device_info` for erofs_map_dev
>
> Gao Xiang <xiang@kernel.org>
>     erofs: use `struct erofs_device_info` for the primary device
>
> Gao Xiang <xiang@kernel.org>
>     erofs: add erofs_sb_free() helper
>
> Vasily Gorbik <gor@linux.ibm.com>
>     s390/mm: Consider KMSAN modules metadata for paging levels
>
> Vineeth Pillai (Google) <vineeth@bitbyteword.org>
>     sched/dlserver: Fix dlserver time accounting
>
> Vineeth Pillai (Google) <vineeth@bitbyteword.org>
>     sched/dlserver: Fix dlserver double enqueue
>
> Gao Xiang <xiang@kernel.org>
>     erofs: fix PSI memstall accounting
>
> Alexander Gordeev <agordeev@linux.ibm.com>
>     s390/ipl: Fix never less than zero warning
>
> Vladimir Riabchun <ferr.lambarginio@gmail.com>
>     i2c: pnx: Fix timeout in wait functions
>
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>     p2sb: Do not scan and remove the P2SB device when it is unhidden
>
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>     p2sb: Move P2SB hide and unhide code to p2sb_scan_and_cache()
>
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>     p2sb: Introduce the global flag p2sb_hidden_by_bios
>
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>     p2sb: Factor out p2sb_read_from_cache()
>
> Peter Zijlstra <peterz@infradead.org>
>     sched/eevdf: More PELT vs DELAYED_DEQUEUE
>
> Vincent Guittot <vincent.guittot@linaro.org>
>     sched/fair: Fix sched_can_stop_tick() for fair tasks
>
> K Prateek Nayak <kprateek.nayak@amd.com>
>     sched/fair: Fix NEXT_BUDDY
>
> Michael Neuling <michaelneuling@tenstorrent.com>
>     RISC-V: KVM: Fix csr_write -> csr_set for HVIEN PMU overflow bit
>
> Levi Yun <yeoreum.yun@arm.com>
>     firmware: arm_ffa: Fix the race around setting ffa_dev->properties
>
> Arnd Bergmann <arnd@arndb.de>
>     firmware: arm_scmi: Fix i.MX build dependency
>
> Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>     net: stmmac: fix TSO DMA API usage causing oops
>
> Lion Ackermann <nnamrec@gmail.com>
>     net: sched: fix ordering of qlen adjustment
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  arch/arm64/kvm/sys_regs.c                          |   3 +-
>  arch/hexagon/Makefile                              |   6 +
>  arch/riscv/kvm/aia.c                               |   2 +-
>  arch/s390/boot/startup.c                           |   2 +
>  arch/s390/boot/vmem.c                              |   6 +-
>  arch/s390/kernel/ipl.c                             |   2 +-
>  arch/x86/kernel/cpu/mshyperv.c                     |  58 +++++
>  arch/x86/kvm/cpuid.c                               |  31 ++-
>  arch/x86/kvm/cpuid.h                               |   1 +
>  arch/x86/kvm/svm/svm.c                             |   9 -
>  arch/x86/kvm/x86.c                                 |   4 +-
>  block/blk-mq-sysfs.c                               |  16 +-
>  block/blk-mq.c                                     |  40 ++--
>  block/blk-sysfs.c                                  |   4 +-
>  drivers/accel/ivpu/ivpu_gem.c                      |   2 +-
>  drivers/accel/ivpu/ivpu_pm.c                       |   2 +-
>  drivers/block/zram/zram_drv.c                      |  15 +-
>  drivers/clocksource/hyperv_timer.c                 |  14 +-
>  drivers/cxl/core/region.c                          |  25 +-
>  drivers/cxl/pci.c                                  |   3 +-
>  drivers/dma-buf/dma-buf.c                          |   2 +-
>  drivers/dma-buf/udmabuf.c                          | 180 ++++++++------
>  drivers/edac/amd64_edac.c                          |  32 +--
>  drivers/firmware/arm_ffa/bus.c                     |  15 +-
>  drivers/firmware/arm_ffa/driver.c                  |   7 +-
>  drivers/firmware/arm_scmi/vendors/imx/Kconfig      |   1 +
>  drivers/firmware/imx/Kconfig                       |   1 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c   |   5 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   3 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   7 +-
>  drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 +-
>  drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c          |   2 +-
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c             |  11 +
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c            |   2 +-
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c             |   2 +-
>  .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   2 +-
>  drivers/gpu/drm/display/drm_dp_tunnel.c            |  10 +-
>  drivers/gpu/drm/drm_modes.c                        |  11 +-
>  drivers/gpu/drm/i915/gt/intel_engine_types.h       |   5 +
>  drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  41 +++-
>  drivers/gpu/drm/panel/panel-himax-hx83102.c        |   2 +
>  drivers/gpu/drm/panel/panel-novatek-nt35950.c      |   4 +-
>  drivers/gpu/drm/panel/panel-sitronix-st7701.c      |   1 +
>  drivers/gpu/drm/panel/panel-synaptics-r63353.c     |   2 +-
>  drivers/hv/hv_kvp.c                                |   6 +
>  drivers/hv/hv_snapshot.c                           |   6 +
>  drivers/hv/hv_util.c                               |   9 +
>  drivers/hv/hyperv_vmbus.h                          |   2 +
>  drivers/hwmon/tmp513.c                             |  10 +-
>  drivers/i2c/busses/i2c-pnx.c                       |   4 +-
>  drivers/i2c/busses/i2c-riic.c                      |   2 +-
>  drivers/irqchip/irq-gic-v3.c                       |  17 +-
>  drivers/mmc/host/mtk-sd.c                          |   2 +
>  drivers/mmc/host/sdhci-tegra.c                     |   1 -
>  drivers/net/can/m_can/m_can.c                      |  36 ++-
>  drivers/net/can/m_can/m_can.h                      |   1 +
>  drivers/net/can/m_can/m_can_pci.c                  |   1 +
>  drivers/net/ethernet/broadcom/bgmac-platform.c     |   5 +-
>  .../chelsio/inline_crypto/chtls/chtls_main.c       |   5 +-
>  drivers/net/ethernet/huawei/hinic/hinic_main.c     |   2 +
>  drivers/net/ethernet/mscc/ocelot.c                 |   2 +-
>  drivers/net/ethernet/oa_tc6.c                      |  11 +-
>  drivers/net/ethernet/pensando/ionic/ionic_dev.c    |   5 +-
>  .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   4 +-
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
>  drivers/net/ethernet/renesas/rswitch.c             |  68 +++---
>  drivers/net/ethernet/renesas/rswitch.h             |  13 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
>  drivers/net/mdio/fwnode_mdio.c                     |  13 +-
>  drivers/net/netdevsim/health.c                     |   2 +
>  drivers/net/netdevsim/netdev.c                     |   4 +-
>  drivers/net/team/team_core.c                       |  10 +-
>  drivers/net/tun.c                                  |   2 +-
>  drivers/of/address.c                               |   5 +-
>  drivers/of/base.c                                  |  15 +-
>  drivers/of/irq.c                                   |   2 +
>  drivers/of/property.c                              |   2 -
>  drivers/platform/x86/p2sb.c                        |  79 ++++--
>  drivers/thunderbolt/nhi.c                          |   8 +
>  drivers/thunderbolt/nhi.h                          |   4 +
>  drivers/thunderbolt/retimer.c                      |  19 +-
>  drivers/thunderbolt/tb.c                           |  41 ++++
>  drivers/usb/host/xhci-ring.c                       |   2 -
>  drivers/usb/serial/option.c                        |  27 +++
>  fs/btrfs/bio.c                                     |  10 +-
>  fs/btrfs/ctree.h                                   |  19 ++
>  fs/btrfs/extent-tree.c                             |   6 +-
>  fs/btrfs/tree-checker.c                            |  27 ++-
>  fs/ceph/file.c                                     |  77 +++---
>  fs/ceph/mds_client.c                               |   9 +-
>  fs/ceph/super.c                                    |   2 +
>  fs/efivarfs/inode.c                                |   2 +-
>  fs/efivarfs/internal.h                             |   1 -
>  fs/efivarfs/super.c                                |   3 -
>  fs/erofs/data.c                                    |  36 +--
>  fs/erofs/fileio.c                                  |   9 +-
>  fs/erofs/fscache.c                                 |  10 +-
>  fs/erofs/internal.h                                |  15 +-
>  fs/erofs/super.c                                   |  80 ++++---
>  fs/erofs/zdata.c                                   |   4 +-
>  fs/eventpoll.c                                     |   5 +-
>  fs/hugetlbfs/inode.c                               |   2 +-
>  fs/nfs/pnfs.c                                      |   2 +-
>  fs/nilfs2/btnode.c                                 |   1 +
>  fs/nilfs2/gcinode.c                                |   2 +-
>  fs/nilfs2/inode.c                                  |  13 +-
>  fs/nilfs2/namei.c                                  |   5 +
>  fs/nilfs2/nilfs.h                                  |   1 +
>  fs/ocfs2/localalloc.c                              |   8 +-
>  fs/smb/client/connect.c                            |  36 ++-
>  fs/smb/server/connection.c                         |  18 +-
>  fs/smb/server/connection.h                         |   1 -
>  fs/smb/server/server.c                             |   7 +-
>  fs/smb/server/server.h                             |   1 +
>  fs/smb/server/transport_ipc.c                      |   5 +-
>  fs/xfs/libxfs/xfs_ialloc.c                         |  16 +-
>  fs/xfs/libxfs/xfs_sb.c                             |  15 ++
>  fs/xfs/scrub/agheader.c                            |  29 ++-
>  fs/xfs/xfs_fsmap.c                                 |  29 ++-
>  include/clocksource/hyperv_timer.h                 |   2 +
>  include/linux/alloc_tag.h                          |   7 +-
>  include/linux/arm_ffa.h                            |  13 +-
>  include/linux/hyperv.h                             |   1 +
>  include/linux/io_uring.h                           |   4 +-
>  include/linux/page-flags.h                         |  12 +-
>  include/linux/sched.h                              |   7 +
>  include/linux/trace_events.h                       |   6 +-
>  include/linux/wait.h                               |   1 +
>  io_uring/io_uring.c                                |   7 +-
>  kernel/sched/core.c                                |   2 +-
>  kernel/sched/deadline.c                            |   8 +-
>  kernel/sched/debug.c                               |   1 +
>  kernel/sched/fair.c                                |  73 ++++--
>  kernel/sched/pelt.c                                |   2 +-
>  kernel/sched/sched.h                               |  13 +-
>  kernel/trace/fgraph.c                              |   8 +-
>  kernel/trace/ring_buffer.c                         |   6 +-
>  kernel/trace/trace.c                               | 264 +++++----------=
------
>  kernel/trace/trace.h                               |   6 +-
>  kernel/trace/trace_events.c                        | 227 ++++++++++++++-=
---
>  kernel/trace/trace_output.c                        |   6 +-
>  mm/huge_memory.c                                   |   8 +-
>  mm/hugetlb.c                                       |   5 +-
>  mm/memory.c                                        |   8 +-
>  mm/page_alloc.c                                    |   6 +-
>  mm/shmem.c                                         |  22 +-
>  mm/vmalloc.c                                       |   6 +-
>  net/core/netdev-genl.c                             |  19 +-
>  net/dsa/tag.h                                      |  16 +-
>  net/mctp/route.c                                   |  36 ++-
>  net/mctp/test/route-test.c                         |  86 +++++++
>  net/netfilter/ipset/ip_set_list_set.c              |   3 +
>  net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
>  net/psample/psample.c                              |   9 +-
>  net/sched/sch_cake.c                               |   2 +-
>  net/sched/sch_choke.c                              |   2 +-
>  net/smc/af_smc.c                                   |  18 +-
>  net/smc/smc_clc.c                                  |  17 +-
>  net/smc/smc_clc.h                                  |  22 +-
>  net/smc/smc_core.c                                 |   9 +-
>  sound/soc/fsl/Kconfig                              |   1 +
>  tools/hv/hv_fcopy_uio_daemon.c                     |   8 +-
>  tools/hv/hv_set_ifconfig.sh                        |   2 +-
>  tools/net/ynl/lib/ynl.py                           |   6 +-
>  tools/testing/selftests/bpf/sdt.h                  |   2 +
>  tools/testing/selftests/memfd/memfd_test.c         |  14 +-
>  .../selftests/net/openvswitch/openvswitch.sh       |   6 +-
>  168 files changed, 1685 insertions(+), 891 deletions(-)
>
>
>
