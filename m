Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5E4174EFE;
	Wed,  3 Jul 2024 10:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004387; cv=none; b=H/PzvBEPmzvvsZ2m0ySNSuTbx3SRiuDIbQllze2ViTPI7P6EIkxIo947ZEgNcrK5Hh2/+vhCUejgvN6h3rpsWNoV+cSBM4n2vpnq+WQdpQVyFBIDo/3PdvDEy5xRrVEQ3siSTYrXTdQUCk3mu4bfnNBtDd9b+zrz1bgz6XeHiDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004387; c=relaxed/simple;
	bh=1OjzLUtscXQ1BW6QW6e4wPfKmXieyq/2NW3t0+P1X5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EK8MHk/qqP6mHbAMfgfQI09oJ5jYiEDwgNCU2mWdc1ntiV0LXyxpJ65nGol7nKW4uQ8KjtWYWp/i+gzG6JpeGpniFOLJGK34gKxjzEgtV954w5NVhL1qXqGelgqabkMJu3TkwkBsmM+8tGJQ9nQ+sC05pvA6kz28K4TzDfbFmLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFVCplaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFVCplaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77377C32781;
	Wed,  3 Jul 2024 10:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004387;
	bh=1OjzLUtscXQ1BW6QW6e4wPfKmXieyq/2NW3t0+P1X5w=;
	h=From:To:Cc:Subject:Date:From;
	b=TFVCplaT1PGNK8Wj55+N2Yuz2p08bfE/SAahjsFlbRKX/Q3OQOL5aajT7H2eFLRp0
	 4E6DdUWoidMdlrjn9VNrSzAmM4L/IX8Lu30ahH3bh+FpgqPzwk8tLu7DwOnTurTm7H
	 pdGj8r44FL6w9ikG8cbIi88zzaf5tZEhM1TymHZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 5.10 000/290] 5.10.221-rc1 review
Date: Wed,  3 Jul 2024 12:36:21 +0200
Message-ID: <20240703102904.170852981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.221-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.221-rc1
X-KernelTest-Deadline: 2024-07-05T10:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.221 release.
There are 290 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 05 Jul 2024 10:28:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.221-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.221-rc1

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    xdp: xdp_mem_allocator can be NULL in trace_mem_connect().

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Add sound-dai-cells for RK3368

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preemption

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Free EFI memory map only when installing a new one.

Ard Biesheuvel <ardb@kernel.org>
    efi: xen: Set EFI_PARAVIRT for Xen dom0 boot on all architectures

Ard Biesheuvel <ardb@kernel.org>
    efi: memmap: Move manipulation routines into x86 arch tree

Liu Zixian <liuzixian4@huawei.com>
    efi: Correct comment on efi_memmap_alloc

Zheng Zhi Yuan <kevinjone25@g.ncu.edu.tw>
    drivers: fix typo in firmware/efi/memmap.c

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data races around icsk->icsk_af_ops.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Fix data races around sk->sk_prot.

Eric Dumazet <edumazet@google.com>
    ipv6: annotate some data-races around sk->sk_prot

Matthew Wilcox (Oracle) <willy@infradead.org>
    nfs: Leave pages in the pagecache if readpage failed

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Refuse too small period requests

Jaime Liao <jaimeliao@mxic.com.tw>
    mtd: spinand: macronix: Add support for serial NAND flash

Arnd Bergmann <arnd@arndb.de>
    syscalls: fix compat_sys_io_pgetevents_time64 usage

Arnd Bergmann <arnd@arndb.de>
    ftruncate: pass a signed offset

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix double free on error

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Clean up sysfs file on error

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't accept TT entries for out-of-spec VIDs

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix potential UAF by revoke of fence registers

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes

Arnd Bergmann <arnd@arndb.de>
    hexagon: fix fadvise64_64 calling conventions

Arnd Bergmann <arnd@arndb.de>
    csky, hexagon: fix broken sys_sync_file_range

Arnd Bergmann <arnd@arndb.de>
    sh: rework sync_file_range ABI

Dragan Simic <dsimic@manjaro.org>
    kbuild: Install dtb files as 0644 in Makefile.dtbinst

Oleksij Rempel <linux@rempel-privat.de>
    net: can: j1939: enhanced error handling for tightly received RTS messages in xtp_rx_rts_session_new

Oleksij Rempel <linux@rempel-privat.de>
    net: can: j1939: recover socket queue on CAN bus error during BAM transmission

Shigeru Yoshida <syoshida@redhat.com>
    net: can: j1939: Initialize unused data in j1939_send_one()

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    tty: mcf: MCF54418 has 10 UARTS

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    serial: imx: set receiver level before starting uart

Udit Kumar <u-kumar1@ti.com>
    serial: 8250_omap: Implementation of Errata i2310

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usb: atm: cxacru: fix endpoint checking in cxacru_bind()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: musb: da8xx: fix a resource leak in probe()

Oliver Neukum <oneukum@suse.com>
    usb: gadget: printer: fix races against disable

Oliver Neukum <oneukum@suse.com>
    usb: gadget: printer: SS+ support

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: improve link status logs

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix sensor data read operation

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix overflows in compensate() functions

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix calibration data variable

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix pressure value output

Fernando Yang <hagisf@usp.br>
    iio: adc: ad7266: Fix variable checking bug

David Lechner <dlechner@baylibre.com>
    counter: ti-eqep: enable clock at probe

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Do not invert write-protect twice

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mmc: sdhci-pci: Convert PCIBIOS_* return codes to errnos

Jan Kara <jack@suse.cz>
    ocfs2: fix DIO failure due to insufficient transaction credits

Linus Torvalds <torvalds@linux-foundation.org>
    x86: stop playing stack games in profile_pc()

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: Disallow reconfiguration without direction (uAPI v1)

Aleksandr Mishin <amishin@t-argos.ru>
    gpio: davinci: Validate the obtained number of IRQs

Liu Ying <victor.liu@nxp.com>
    drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA

Hannes Reinecke <hare@suse.de>
    nvme: fixup comment for nvme RDMA Provider Type

Erick Archer <erick.archer@outlook.com>
    drm/radeon/radeon_display: Decrease the size of allocated memory

Andrew Davis <afd@ti.com>
    soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message

Ricardo Ribalda <ribalda@chromium.org>
    media: dvbdev: Initialize sbuf

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emux: improve patch ioctl data validation

Dawei Li <dawei.li@shingroup.cn>
    net/dpaa2: Avoid explicit cpumask var allocation on stack

Dawei Li <dawei.li@shingroup.cn>
    net/iucv: Avoid explicit cpumask var allocation on stack

Anton Protopopov <aspsk@isovalent.com>
    bpf: Add a check for struct bpf_fib_lookup size

Denis Arefev <arefev@swemel.ru>
    mtd: partitions: redboot: Added conversion of operands to a larger type

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep

Yunseong Kim <yskelg@gmail.com>
    tracing/net_sched: NULL pointer dereference in perf_trace_qdisc_reset()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers

Arnd Bergmann <arnd@arndb.de>
    parisc: use correct compat recv/recvfrom syscalls

Arnd Bergmann <arnd@arndb.de>
    sparc: fix compat recv/recvfrom syscalls

Arnd Bergmann <arnd@arndb.de>
    sparc: fix old compat_sys_select()

Daniil Dulov <d.dulov@aladdin.ru>
    xdp: Remove WARN() from __xdp_reg_mem_model()

Toke Høiland-Jørgensen <toke@redhat.com>
    xdp: Allow registering memory model without rxq reference

Jakub Kicinski <kuba@kernel.org>
    xdp: Move the rxq_info.mem clearing to unreg_mem_model()

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: phy: micrel: add Microchip KSZ 9477 to the device table

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix initial port flush problem

Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>
    ASoC: fsl-asoc-card: set priv->pdev before using it

Jeff Layton <jlayton@kernel.org>
    nfsd: hold a lighter-weight client reference over CB_RECALL_ANY

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix svcxdr_init_encode's buflen calculation

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix a NULL pointer deref in trace_svc_stats_latency()

Yunjian Wang <wangyunjian@huawei.com>
    SUNRPC: Fix null pointer dereference in svc_rqst_free()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate family when identifying table via handle

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix UBSAN warning in kv_dpm.c

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: use dedicated pinctrl type for RK3328

Jianqun Xu <jay.xu@rock-chips.com>
    pinctrl/rockchip: separate struct rockchip_pin_bank to a head file

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO3-B pins

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO2-B pins

Hagar Hemdan <hagarhem@amazon.com>
    pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER

John Keeping <jkeeping@inmusicbrands.com>
    Input: ili210x - fix ili251x_read_touch_data() return value

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Force StorageD3Enable on more products

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: utils: Add Picasso to the list for forcing StorageD3Enable

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: utils: Add Cezanne to the list for forcing StorageD3Enable

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Add another system to quirk list for forcing StorageD3Enable

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1 for StorageD3Enable

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: Add quirks for AMD Renoir/Lucienne CPUs to force the D3 hint

Jan Beulich <jbeulich@suse.com>
    x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix deadlock in smb2_find_smb_tcon()

Shyam Prasad N <sprasad@microsoft.com>
    cifs: missed ref-counting smb session in find

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Check for invalid SMN reads

Naveen Naidu <naveennaidu479@gmail.com>
    PCI: Add PCI_ERROR_RESPONSE and related definitions

Haifeng Xu <haifeng.xu@shopee.com>
    perf/core: Fix missing wakeup when waiting for context reference

Matthias Maennich <maennich@google.com>
    kheaders: explicitly define file modes for archived headers

Masahiro Yamada <masahiroy@kernel.org>
    Revert "kheaders: substituting --sort in archive creation"

Ken Milmore <ken.milmore@gmail.com>
    r8169: Fix possible ring buffer corruption on fragmented Tx packets.

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: remove not needed check in rtl8169_start_xmit

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: remove nr_frags argument from rtl_tx_slots_avail

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: improve rtl8169_start_xmit

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: improve rtl_tx

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: remove unneeded memory barrier in rtl_tx

Tony Luck <tony.luck@intel.com>
    x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL

Tony Luck <tony.luck@intel.com>
    x86/cpu/vfm: Add new macros to work with (vendor/family/model) values

Jeff Johnson <quic_jjohnson@quicinc.com>
    tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test

Harald Freudenberger <freude@linux.ibm.com>
    s390/cpacf: Make use of invalid opcode produce a link error

Matthew Mirvish <matthew@mm12.xyz>
    bcache: fix variable length array abuse in btree_iter

Vamshi Gajjela <vamshigajjela@google.com>
    spmi: hisi-spmi-controller: Do not override device identifier

Trond Myklebust <trond.myklebust@hammerspace.com>
    knfsd: LOOKUP can return an illegal error value

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    pmdomain: ti-sci: Fix duplicate PD referrals

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power

Kees Cook <keescook@chromium.org>
    rtlwifi: rtl8192de: Style clean-ups

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdk4412: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdkv310: fix keypad no-autorepeat

Martin Leung <martin.leung@amd.com>
    drm/amd/display: revert Exit idle optimizations before HDCP execution

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema

Grygorii Tertychnyi <grembeter@gmail.com>
    i2c: ocores: set IACK bit after core is enabled

Aleksandr Nogikh <nogikh@google.com>
    kcov: don't lose track of remote references during softirqs

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 14

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix UBSAN warning in kv_dpm.c

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on N14AP7

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Add check for srq max_sge attribute

Raju Rangoju <Raju.Rangoju@amd.com>
    ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix missing kmem_cache_destroy()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix kmemleak in ioat_pci_probe()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix error path in ioat3_dma_probe()

Bjorn Helgaas <bhelgaas@google.com>
    dmaengine: ioat: use PCI core macros for PCIe Capability

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix leaking on version mismatch

Bjorn Helgaas <bhelgaas@google.com>
    dmaengine: ioat: Drop redundant pci_enable_pcie_error_reporting()

Qing Wang <wangqing@vivo.com>
    dmaengine: ioat: switch from 'pci_' to 'dma_' API

Biju Das <biju.das.jz@bp.renesas.com>
    regulator: core: Fix modpost error "regulator_get_regmap" undefined

Oliver Neukum <oneukum@suse.com>
    net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix suspicious rcu_dereference_protected()

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: checksum offloading handling fix

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: No need to calculate speed divider when offload is disabled

Xin Long <lucien.xin@gmail.com>
    sched: act_ct: add netns into the key of tcf_ct_flow_table

Vlad Buslov <vladbu@nvidia.com>
    net/sched: act_ct: set 'net' pointer when creating new nf_flow_table

Xin Long <lucien.xin@gmail.com>
    tipc: force a dst refcount before doing decryption

David Ruth <druth@chromium.org>
    net/sched: act_api: fix possible infinite loop in tcf_idr_check_alloc()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_api: rely on rcu in tcf_idr_check_alloc

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make interrupt remembering atomic

Yue Haibing <yuehaibing@huawei.com>
    netns: Make get_net_ns() handle zero refcount net

Eric Dumazet <edumazet@google.com>
    xfrm6: check ip6_dst_idev() return value in xfrm6_get_saddr()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL dereference in rt6_probe()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL deref in fib6_nh_init()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netrom: Fix a memory leak in nr_heartbeat_expiry()

Ondrej Mosnacek <omosnace@redhat.com>
    cipso: fix total option length computation

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Build event generation tests only as modules

Christian Marangi <ansuelsmth@gmail.com>
    mips: bmips: BCM6358: make sure CBR is correctly set

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    MIPS: Routerboard 532: Fix vendor retry check code

Parker Newman <pnewman@connecttech.com>
    serial: exar: adding missing CTI and Exar PCI ids

Songyang Li <leesongyang@outlook.com>
    MIPS: Octeon: Add PCIe link status check

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Avoid D3cold for HP Pavilion 17 PC/1972 PCIe Ports

Roman Smirnov <r.smirnov@omp.ru>
    udf: udftime: prevent overflow in udf_disk_stamp_to_time()

Alex Henrie <alexhenrie24@gmail.com>
    usb: misc: uss720: check for incompatible versions of the Belkin F5U002

Yunlei He <heyunlei@oppo.com>
    f2fs: remove clear SB_INLINECRYPT flag in default_options

Aleksandr Aprelkov <aaprelkov@usergate.com>
    iommu/arm-smmu-v3: Free MSIs in case of ENOMEM

Tzung-Bi Shih <tzungbi@kernel.org>
    power: supply: cros_usbpd: provide ID table for avoiding fallback match

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/io: Avoid clang null pointer arithmetic warnings

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: Enforce hcall result buffer validity and size

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: mask irqs in timeout path before hard reset

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: add mask irq callback to gp and pp

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Exit idle optimizations before HDCP execution

Uri Arev <me@wantyapps.xyz>
    Bluetooth: ath3k: Fix multiple issues reported by checkpatch.pl

Takashi Iwai <tiwai@suse.de>
    ACPI: video: Add backlight=native quirk for Lenovo Slim 7 16ARH7

Sean O'Brien <seobrien@chromium.org>
    HID: Add quirk for Logitech Casa touchpad

Breno Leitao <leitao@debian.org>
    netpoll: Fix race condition in netpoll_owner_active

Kunwu Chan <chentao@kylinos.cn>
    kselftest: arm64: Add a null pointer check

Manish Rangankar <mrangankar@marvell.com>
    scsi: qedi: Fix crash while reading debugfs attribute

Wander Lairson Costa <wander@redhat.com>
    drop_monitor: replace spin_lock by raw_spin_lock

Eric Dumazet <edumazet@google.com>
    af_packet: avoid a false positive warning in packet_setsockopt()

Arnd Bergmann <arnd@arndb.de>
    wifi: ath9k: work around memset overflow warning

Eric Dumazet <edumazet@google.com>
    batman-adv: bypass empty buckets in batadv_purge_orig_ref()

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix flaky test btf_map_in_map/lookup_update

Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
    selftests/bpf: Prevent client connect before server bind in test_tc_tunnel.sh

Justin Stitt <justinstitt@google.com>
    block/ioctl: prefer different overflow check

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Fix invalid context warning when enable srcu barrier testing

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Disable BH when taking works lock on MT path

Oleg Nesterov <oleg@redhat.com>
    zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING

Jean Delvare <jdelvare@suse.de>
    i2c: designware: Fix the functionality flags of the slave-only interface

Jean Delvare <jdelvare@suse.de>
    i2c: at91: Fix the functionality flags of the slave-only interface

Shichao Lai <shichaorai@gmail.com>
    usb-storage: alauda: Check whether the media is initialized

Sicong Huang <congei42@163.com>
    greybus: Fix use-after-free bug in gb_interface_release due to race condition.

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Jump to error handling labels in start/stop errors

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: update add_addr counters after connect

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure snd_una is properly initialized on connect

Matthias Goergens <matthias.goergens@gmail.com>
    hugetlb_encode.h: fix undefined behaviour (34 << 26)

Doug Brown <doug@schmorgal.com>
    serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level

Oleg Nesterov <oleg@redhat.com>
    tick/nohz_full: Don't abuse smp_call_function_single() in tick_setup_device()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential kernel bug due to lack of writeback flag waiting

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Lunar Lake support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-S support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Sapphire Rapids SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Granite Rapids SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Granite Rapids support

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Do not allow core1 to power up before core0 via sysfs

Nuno Sa <nuno.sa@analog.com>
    dmaengine: axi-dmac: fix possible race in remove()

Rick Wertenbroek <rick.wertenbroek@gmail.com>
    PCI: rockchip-ep: Remove wrong mask on subsys_vendor_id

Su Yue <glass.su@suse.com>
    ocfs2: fix races between hole punching and AIO+DIO

Su Yue <glass.su@suse.com>
    ocfs2: use coarse time for new created files

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore

Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
    vmci: prevent speculation leaks by sanitizing event in event_deliver()

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: hdmi: report safe 640x480 mode as a fallback when no EDID found

Jani Nikula <jani.nikula@intel.com>
    drm/exynos/vidi: fix memory leak in .get_modes()

Dirk Behme <dirk.behme@de.bosch.com>
    drivers: core: synchronize really_probe() and dev_uevent()

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: delete unneeded update watermark call

Marc Ferland <marc.ferland@sonatest.com>
    iio: dac: ad5592r: fix temperature channel scaling value

David Lechner <dlechner@baylibre.com>
    iio: adc: ad9467: fix scan type sign

Taehee Yoo <ap420073@gmail.com>
    ionic: fix use after netif_napi_del()

Petr Pavlu <petr.pavlu@suse.com>
    net/ipv6: Fix the RT cache flush via sysctl using a previous delay

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: replace priv->speed with the portTransmitRate from the tc-cbs parameters

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix rejecting L2CAP_CONN_PARAM_UPDATE_REQ

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix features validation check for tunneled UDP (non-VXLAN) packets

Eric Dumazet <edumazet@google.com>
    tcp: fix race in tcp_v6_syn_recv_sock()

Adam Miotk <adam.miotk@arm.com>
    drm/bridge/panel: Fix runtime warning on panel bridge release

Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>
    drm/komeda: check for error-valued pointer

Aleksandr Mishin <amishin@t-argos.ru>
    liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet

Jie Wang <wangjie125@huawei.com>
    net: hns3: add cond_resched() to hns3 ring buffer init process

Csókás, Bence <csokas.bence@prolan.hu>
    net: sfp: Always call `sfp_sm_mod_remove()` on remove

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: 3D disabled should not effect STDU memory limits

José Expósito <jose.exposito89@gmail.com>
    HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Return right value in iommu_sva_bind_device()

Kun(llfl) <llfl@linux.alibaba.com>
    iommu/amd: Fix sysfs leak in iommu init

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Introduce pci segment structure

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: store IRQ trigger type and unmask status separately

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    HID: core: remove unnecessary WARN_ON() in implement()

Gregor Herburger <gregor.herburger@tq-group.com>
    gpio: tqmx86: fix typo in Kconfig label

Chen Hanxiao <chenhx.fnst@fujitsu.com>
    SUNRPC: return proper error from gss_wrap_req_priv

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: try trimming too long modalias strings

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/uaccess: Fix build errors seen with GCC 13/14

Breno Leitao <leitao@debian.org>
    scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply broken streams quirk to Etron EJ188 xHCI host

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply reset resume quirk to Etron EJ188 xHCI host

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Set correct transferred length for cancelled bulk transfers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    jfs: xattr: fix buffer overflow for invalid xattr

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: release irq in mei_me_pci_resume error path

Alan Stern <stern@rowland.harvard.edu>
    USB: class: cdc-wdm: Fix CPU lockup caused by excessive log messages

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: return the mapped address from nilfs_get_page()

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: Remove check for PageError

Filipe Manana <fdmanana@suse.com>
    btrfs: fix leak of qgroup extent records after transaction abort

Harald Freudenberger <freude@linux.ibm.com>
    s390/cpacf: Split and rework cpacf query functions

Heiko Carstens <hca@linux.ibm.com>
    s390/cpacf: get rid of register asm

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix bogus test success on Aarch64

Mark Brown <broonie@kernel.org>
    selftests/mm: log a consistent test name for check_compaction

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/mm: conform test to TAP format output

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mmc: davinci: Don't strip remove function when driver is builtin

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: replace hardcoded divisor value with BIT() macro

George Shen <george.shen@amd.com>
    drm/amd/display: Handle Y carry-over in VCP X.Y calculation

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible race in __fib6_drop_pcpu_from()

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in unix_write_space() and poll().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_inq_len().

Karol Kolacinski <karol.kolacinski@intel.com>
    ptp: Fix error message on failed pin verification

Eric Dumazet <edumazet@google.com>
    net/sched: taprio: always validate TCA_TAPRIO_ATTR_PRIOMAP

Jason Xing <kernelxing@tencent.com>
    tcp: count CLOSE-WAIT sockets for TCP_MIB_CURRESTAB

Daniel Borkmann <daniel@iogearbox.net>
    vxlan: Fix regression when dropping packets due to invalid src addresses

Hangyu Hua <hbh25y@gmail.com>
    net: sched: sch_multiq: fix possible OOB write in multiq_tune()

Eric Dumazet <edumazet@google.com>
    ipv6: sr: block BH in seg6_output_core() and seg6_input_core()

DelphineCCChiu <delphine_cc_chiu@wiwynn.com>
    net/ncsi: Fix the multi thread manner of NCSI driver

Peter Delevoryas <peter@pjd.dev>
    net/ncsi: Simplify Kconfig/dts control flow

Ivan Mikhaylov <i.mikhaylov@yadro.com>
    net/ncsi: add NCSI Intel OEM command to keep PHY up

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: mac80211: correctly parse Spatial Reuse Parameter Set element

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't read past the mfuart notifcation

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: check n_ssids before accessing the ssids

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    wifi: iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64

Lin Ma <linma@zju.edu.cn>
    wifi: cfg80211: pmsr: use correct nla_get_uX functions

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Fix deadlock in ieee80211_sta_ps_deliver_wakeup()

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: mesh: Fix leak of mesh_preq_queue objects

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Print correct max open zones limit in null_init_zoned_dev()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/selftests: Fix kprobe event name test for .isra. functions


-------------

Diffstat:

 .../bindings/i2c/google,cros-ec-i2c-tunnel.yaml    |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   2 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   2 +-
 arch/arm/boot/dts/rk3066a.dtsi                     |   1 +
 arch/arm64/boot/dts/rockchip/rk3368.dtsi           |   3 +
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/include/asm/unistd32.h                  |   2 +-
 arch/arm64/kvm/arm.c                               |   6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   2 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |   8 +-
 arch/csky/include/uapi/asm/unistd.h                |   1 +
 arch/hexagon/include/asm/syscalls.h                |   6 +
 arch/hexagon/include/uapi/asm/unistd.h             |   1 +
 arch/hexagon/kernel/syscalltab.c                   |   7 +
 arch/mips/bmips/setup.c                            |   3 +-
 arch/mips/kernel/syscalls/syscall_n32.tbl          |   2 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   2 +-
 arch/mips/pci/ops-rc32434.c                        |   4 +-
 arch/mips/pci/pcie-octeon.c                        |   6 +
 arch/parisc/kernel/syscalls/syscall.tbl            |   4 +-
 arch/powerpc/include/asm/hvcall.h                  |   8 +-
 arch/powerpc/include/asm/io.h                      |  24 +-
 arch/powerpc/include/asm/uaccess.h                 |  15 +-
 arch/powerpc/kernel/syscalls/syscall.tbl           |   2 +-
 arch/s390/include/asm/cpacf.h                      | 307 +++++++++++++--------
 arch/s390/kernel/syscalls/syscall.tbl              |   2 +-
 arch/sh/kernel/sys_sh32.c                          |  11 +
 arch/sh/kernel/syscalls/syscall.tbl                |   3 +-
 arch/sparc/kernel/sys32.S                          | 221 ---------------
 arch/sparc/kernel/syscalls/syscall.tbl             |   8 +-
 arch/x86/entry/syscalls/syscall_32.tbl             |   2 +-
 arch/x86/include/asm/cpu_device_id.h               |  98 +++++++
 arch/x86/include/asm/efi.h                         |  11 +
 arch/x86/kernel/amd_nb.c                           |   9 +-
 arch/x86/kernel/cpu/match.c                        |   4 +-
 arch/x86/kernel/time.c                             |  20 +-
 arch/x86/mm/numa.c                                 |   6 +-
 arch/x86/platform/efi/Makefile                     |   3 +-
 arch/x86/platform/efi/efi.c                        |   8 +-
 arch/x86/platform/efi/memmap.c                     | 249 +++++++++++++++++
 block/ioctl.c                                      |   2 +-
 drivers/acpi/acpica/exregion.c                     |  23 +-
 drivers/acpi/device_pm.c                           |   3 +
 drivers/acpi/internal.h                            |   9 +
 drivers/acpi/video_detect.c                        |   8 +
 drivers/acpi/x86/utils.c                           |  34 +++
 drivers/ata/ahci.c                                 |  17 +-
 drivers/ata/libata-core.c                          |   8 +-
 drivers/base/core.c                                |   3 +
 drivers/block/null_blk/zoned.c                     |   2 +-
 drivers/bluetooth/ath3k.c                          |  25 +-
 drivers/counter/ti-eqep.c                          |   6 +
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/dma/ioat/init.c                            |  73 +++--
 drivers/dma/ioat/registers.h                       |   7 -
 drivers/firmware/efi/fdtparams.c                   |   4 +
 drivers/firmware/efi/memmap.c                      | 239 +---------------
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-davinci.c                        |   5 +
 drivers/gpio/gpio-tqmx86.c                         |  46 +--
 drivers/gpio/gpiolib-cdev.c                        |  16 +-
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |   6 +
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c          |   2 +
 .../drm/arm/display/komeda/komeda_pipeline_state.c |   2 +-
 drivers/gpu/drm/bridge/panel.c                     |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   7 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   7 +-
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c       |   1 +
 drivers/gpu/drm/lima/lima_bcast.c                  |  12 +
 drivers/gpu/drm/lima/lima_bcast.h                  |   3 +
 drivers/gpu/drm/lima/lima_gp.c                     |   8 +
 drivers/gpu/drm/lima/lima_pp.c                     |  18 ++
 drivers/gpu/drm/lima/lima_sched.c                  |   7 +
 drivers/gpu/drm/lima/lima_sched.h                  |   1 +
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c          |   6 +
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c      |   6 +-
 drivers/gpu/drm/panel/panel-simple.c               |   1 +
 drivers/gpu/drm/radeon/radeon.h                    |   1 -
 drivers/gpu/drm/radeon/radeon_display.c            |   8 +-
 drivers/gpu/drm/radeon/sumo_dpm.c                  |   2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   7 -
 drivers/greybus/interface.c                        |   1 +
 drivers/hid/hid-core.c                             |   1 -
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-logitech-dj.c                      |   4 +-
 drivers/hid/hid-multitouch.c                       |   6 +
 drivers/hwtracing/intel_th/pci.c                   |  25 ++
 drivers/i2c/busses/i2c-at91-slave.c                |   3 +-
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +-
 drivers/i2c/busses/i2c-ocores.c                    |   2 +-
 drivers/iio/adc/ad7266.c                           |   2 +
 drivers/iio/adc/ad9467.c                           |   4 +-
 drivers/iio/chemical/bme680.h                      |   2 +
 drivers/iio/chemical/bme680_core.c                 |  62 ++++-
 drivers/iio/dac/ad5592r-base.c                     |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   4 -
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   4 -
 drivers/infiniband/hw/mlx5/srq.c                   |  13 +-
 drivers/input/input.c                              | 105 ++++++-
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/iommu/amd/amd_iommu_types.h                |  24 +-
 drivers/iommu/amd/init.c                           |  55 +++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/md/bcache/bset.c                           |  44 +--
 drivers/md/bcache/bset.h                           |  28 +-
 drivers/md/bcache/btree.c                          |  40 +--
 drivers/md/bcache/super.c                          |   5 +-
 drivers/md/bcache/sysfs.c                          |   2 +-
 drivers/md/bcache/writeback.c                      |  10 +-
 drivers/media/dvb-core/dvbdev.c                    |   2 +-
 drivers/misc/mei/pci-me.c                          |   4 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   6 +-
 drivers/mmc/host/davinci_mmc.c                     |   4 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  11 +-
 drivers/mmc/host/sdhci.c                           |  25 +-
 drivers/mtd/nand/spi/macronix.c                    | 112 ++++++++
 drivers/mtd/parsers/redboot.c                      |   2 +-
 drivers/net/dsa/microchip/ksz9477.c                |   6 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  |  11 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  14 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
 drivers/net/ethernet/qualcomm/qca_debug.c          |   6 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |  16 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   3 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  48 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  55 ++--
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/net/usb/rtl8150.c                          |   3 +-
 drivers/net/virtio_net.c                           |  12 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 +
 drivers/net/wireless/ath/ath.h                     |   6 +-
 drivers/net/wireless/ath/ath9k/main.c              |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  10 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |  19 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   1 -
 drivers/pci/controller/pcie-rockchip-ep.c          |   6 +-
 drivers/pci/pci.c                                  |  12 +
 drivers/pinctrl/core.c                             |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 | 294 ++++----------------
 drivers/pinctrl/pinctrl-rockchip.h                 | 246 +++++++++++++++++
 drivers/power/supply/cros_usbpd-charger.c          |  11 +-
 drivers/ptp/ptp_chardev.c                          |   3 +-
 drivers/pwm/pwm-stm32.c                            |   3 +
 drivers/regulator/core.c                           |   1 +
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |  25 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  19 ++
 drivers/scsi/qedi/qedi_debugfs.c                   |  12 +-
 drivers/soc/ti/ti_sci_pm_domains.c                 |  20 +-
 drivers/soc/ti/wkup_m3_ipc.c                       |   7 +-
 drivers/staging/hikey9xx/hisi-spmi-controller.c    |   1 -
 drivers/tty/serial/8250/8250_exar.c                |  42 +++
 drivers/tty/serial/8250/8250_omap.c                |  25 +-
 drivers/tty/serial/8250/8250_pxa.c                 |   1 +
 drivers/tty/serial/imx.c                           |   4 +-
 drivers/tty/serial/mcf.c                           |   2 +-
 drivers/tty/serial/sc16is7xx.c                     |  25 +-
 drivers/usb/atm/cxacru.c                           |  14 +
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/gadget/function/f_fs.c                 |   4 +
 drivers/usb/gadget/function/f_printer.c            |  40 ++-
 drivers/usb/host/xhci-pci.c                        |   7 +
 drivers/usb/host/xhci-ring.c                       |   5 +-
 drivers/usb/misc/uss720.c                          |  22 +-
 drivers/usb/musb/da8xx.c                           |   8 +-
 drivers/usb/storage/alauda.c                       |   9 +-
 fs/btrfs/disk-io.c                                 |  10 +-
 fs/cifs/smb2transport.c                            |  12 +-
 fs/f2fs/super.c                                    |   2 -
 fs/jfs/xattr.c                                     |   4 +-
 fs/nfs/read.c                                      |   4 -
 fs/nfsd/nfs4state.c                                |   7 +-
 fs/nfsd/nfsfh.c                                    |   4 +-
 fs/nilfs2/dir.c                                    |  59 ++--
 fs/nilfs2/segment.c                                |   3 +
 fs/ocfs2/aops.c                                    |   5 +
 fs/ocfs2/file.c                                    |   2 +
 fs/ocfs2/journal.c                                 |  17 ++
 fs/ocfs2/journal.h                                 |   2 +
 fs/ocfs2/namei.c                                   |   2 +-
 fs/ocfs2/ocfs2_trace.h                             |   2 +
 fs/open.c                                          |   4 +-
 fs/proc/vmcore.c                                   |   2 +
 fs/udf/udftime.c                                   |  11 +-
 include/kvm/arm_vgic.h                             |   2 +-
 include/linux/compat.h                             |   2 +-
 include/linux/efi.h                                |  10 +-
 include/linux/iommu.h                              |   2 +-
 include/linux/kcov.h                               |   2 +
 include/linux/mod_devicetable.h                    |   2 +
 include/linux/nvme.h                               |   4 +-
 include/linux/pci.h                                |   9 +
 include/linux/sunrpc/svc.h                         |  20 +-
 include/linux/syscalls.h                           |   2 +-
 include/net/bluetooth/hci_core.h                   |  36 ++-
 include/net/netfilter/nf_tables.h                  |   5 +
 include/net/xdp.h                                  |   3 +
 include/trace/events/qdisc.h                       |   2 +-
 include/trace/events/sunrpc.h                      |   8 +-
 include/uapi/asm-generic/hugetlb_encode.h          |  26 +-
 include/uapi/asm-generic/unistd.h                  |   2 +-
 kernel/events/core.c                               |  13 +
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/gen_kheaders.sh                             |   9 +-
 kernel/kcov.c                                      |   1 +
 kernel/padata.c                                    |   8 +-
 kernel/pid_namespace.c                             |   1 +
 kernel/rcu/rcutorture.c                            |  12 +-
 kernel/sys_ni.c                                    |   2 +-
 kernel/time/tick-common.c                          |  42 +--
 kernel/trace/Kconfig                               |   4 +-
 kernel/trace/preemptirq_delay_test.c               |   1 +
 net/batman-adv/originator.c                        |  29 ++
 net/bluetooth/l2cap_core.c                         |   8 +-
 net/can/j1939/main.c                               |   6 +-
 net/can/j1939/transport.c                          |  21 +-
 net/core/drop_monitor.c                            |  20 +-
 net/core/filter.c                                  |   3 +
 net/core/net_namespace.c                           |   9 +-
 net/core/netpoll.c                                 |   2 +-
 net/core/sock.c                                    |   6 +-
 net/core/xdp.c                                     | 100 ++++---
 net/ipv4/af_inet.c                                 |  23 +-
 net/ipv4/cipso_ipv4.c                              |  12 +-
 net/ipv4/tcp.c                                     |  16 +-
 net/ipv6/af_inet6.c                                |  24 +-
 net/ipv6/ip6_fib.c                                 |   6 +-
 net/ipv6/ipv6_sockglue.c                           |   9 +-
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/seg6_iptunnel.c                           |  14 +-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/xfrm6_policy.c                            |   8 +-
 net/iucv/iucv.c                                    |  26 +-
 net/mac80211/he.c                                  |  10 +-
 net/mac80211/mesh_pathtbl.c                        |  13 +
 net/mac80211/sta_info.c                            |   4 +-
 net/mptcp/pm_netlink.c                             |  18 +-
 net/mptcp/protocol.c                               |   1 +
 net/ncsi/Kconfig                                   |   6 +
 net/ncsi/internal.h                                |   7 +
 net/ncsi/ncsi-manage.c                             | 112 +++++---
 net/ncsi/ncsi-rsp.c                                |   4 +-
 net/netfilter/ipset/ip_set_core.c                  | 104 ++++---
 net/netfilter/ipset/ip_set_list_set.c              |  30 +-
 net/netfilter/nf_tables_api.c                      |  13 +-
 net/netfilter/nft_lookup.c                         |   3 +-
 net/netrom/nr_timer.c                              |   3 +-
 net/packet/af_packet.c                             |  26 +-
 net/sched/act_api.c                                |  66 +++--
 net/sched/act_ct.c                                 |  21 +-
 net/sched/sch_multiq.c                             |   2 +-
 net/sched/sch_taprio.c                             |  15 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   4 +-
 net/sunrpc/svc.c                                   |  18 +-
 net/tipc/node.c                                    |   1 +
 net/unix/af_unix.c                                 |  47 ++--
 net/unix/diag.c                                    |  12 +-
 net/wireless/pmsr.c                                |   8 +-
 scripts/Makefile.dtbinst                           |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/fsl/fsl-asoc-card.c                      |   3 +-
 sound/soc/intel/boards/sof_sdw.c                   |   9 +
 sound/synth/emux/soundfont.c                       |  17 +-
 tools/include/asm-generic/hugetlb_encode.h         |  20 +-
 tools/testing/selftests/arm64/tags/tags_test.c     |   4 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |  26 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |  13 +-
 .../ftrace/test.d/kprobe/kprobe_eventname.tc       |   3 +-
 tools/testing/selftests/vm/compaction_test.c       | 108 ++++----
 278 files changed, 3057 insertions(+), 1923 deletions(-)


