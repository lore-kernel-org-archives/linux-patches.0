Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4B716DEC3;
	Wed,  3 Jul 2024 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005242; cv=none; b=sCIIpc9zvBZvGSmHCxCoECppuZ8LtKILZpyME2RtREe2yYBlnU/jZiQOR1vsa0Wa7FGdR7urMStGDGLHtmsEvJMNP1McQXiac/jG6lUONs6fVJi5wDQaRbJ5vCvCrRmmPY8KcfRzltz60c3CrBObUwcd5Z8rKVPCA/3A8oOi8F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005242; c=relaxed/simple;
	bh=rf/8ChVrXFF1i6q7Rd6PvoftmG2WBQXGOajB8ZZelH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O9ZzYgAC+RhquVgy6xiGHs1RsAt+swG7NtD/Aw8MnClqGmq4u9Dj7hQPPoKVtqNIOrf07eyZcDocWvPMzxSp5Ih6HGdfiXkpkS+sajBHGcLmipO9miDmXhlOAgPC7CWQM9PoTdcRmWXNhBw8rYpkgFrl2VE8D6ZVplvb6OsND78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax6vBGe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax6vBGe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3D8C2BD10;
	Wed,  3 Jul 2024 11:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005242;
	bh=rf/8ChVrXFF1i6q7Rd6PvoftmG2WBQXGOajB8ZZelH4=;
	h=From:To:Cc:Subject:Date:From;
	b=Ax6vBGe2U5ydP344NJOOp41gPH4dpyVgCNCMdnaQ62LKcTN4zeW3RMjvIsdOKfBD9
	 NEzyFdojwVhExS9Me1xudwuaU6SJ2bdKgaUQTOvY4fNWi9aVm1wel1Po+ZIYlNE7mQ
	 4vOiM5UpfVdCfp+xFsI8CjeL0DkxO8d7aUIGLEK4=
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
Subject: [PATCH 5.15 000/356] 5.15.162-rc1 review
Date: Wed,  3 Jul 2024 12:35:36 +0200
Message-ID: <20240703102913.093882413@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.162-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.162-rc1
X-KernelTest-Deadline: 2024-07-05T10:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.162 release.
There are 356 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 05 Jul 2024 10:28:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.162-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.162-rc1

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Add sound-dai-cells for RK3368

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E

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

Arnd Bergmann <arnd@arndb.de>
    syscalls: fix sys_fanotify_mark prototype

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

Julia Zhang <julia.zhang@amd.com>
    drm/amdgpu: avoid using null object of framebuffer

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

Yuntao Wang <ytcoode@gmail.com>
    cpu/hotplug: Fix dynstate assignment in __cpuhp_setup_state_cpuslocked()

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

Meng Li <Meng.Li@windriver.com>
    usb: dwc3: core: remove lock of otg mode during gadget suspend/resume to avoid deadlock

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

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    iio: accel: fxls8962af: select IIO_BUFFER & IIO_KFIFO_BUF

Fernando Yang <hagisf@usp.br>
    iio: adc: ad7266: Fix variable checking bug

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: discard write requests while old command is running

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: don't erase registers after STOP

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Do not invert write-protect twice

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mmc: sdhci-pci: Convert PCIBIOS_* return codes to errnos

Jan Kara <jack@suse.cz>
    ocfs2: fix DIO failure due to insufficient transaction credits

Arnd Bergmann <arnd@arndb.de>
    parisc: use generic sys_fanotify_mark implementation

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

Joachim Vandersmissen <git@jvdsn.com>
    crypto: ecdh - explicitly zeroize private_key

Dawei Li <dawei.li@shingroup.cn>
    net/dpaa2: Avoid explicit cpumask var allocation on stack

Dawei Li <dawei.li@shingroup.cn>
    net/iucv: Avoid explicit cpumask var allocation on stack

Wenchao Hao <haowenchao2@huawei.com>
    RDMA/restrack: Fix potential invalid address access

Anton Protopopov <aspsk@isovalent.com>
    bpf: Add a check for struct bpf_fib_lookup size

Denis Arefev <arefev@swemel.ru>
    mtd: partitions: redboot: Added conversion of operands to a larger type

Uros Bizjak <ubizjak@gmail.com>
    x86/fpu: Fix AMD X86_BUG_FXSAVE_LEAK fixup

Maxime Coquelin <maxime.coquelin@redhat.com>
    vduse: Temporarily fail if control queue feature requested

Maxime Coquelin <maxime.coquelin@redhat.com>
    vduse: validate block features only with block devices

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep

Christophe Leroy <christophe.leroy@csgroup.eu>
    bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()

Yunseong Kim <yskelg@gmail.com>
    tracing/net_sched: NULL pointer dereference in perf_trace_qdisc_reset()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_rcv_fastopen_synack() to enter TCP_CA_Loss for failed TFO

Arnd Bergmann <arnd@arndb.de>
    parisc: use correct compat recv/recvfrom syscalls

Arnd Bergmann <arnd@arndb.de>
    sparc: fix compat recv/recvfrom syscalls

Arnd Bergmann <arnd@arndb.de>
    sparc: fix old compat_sys_select()

luoxuanqiang <luoxuanqiang@kylinos.cn>
    Fix race for duplicate reqsk on identical SYN

Akhmat Karakotov <hmukos@yandex-team.ru>
    tcp: Use BPF timeout setting for SYN ACK RTO

Daniil Dulov <d.dulov@aladdin.ru>
    xdp: Remove WARN() from __xdp_reg_mem_model()

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: phy: micrel: add Microchip KSZ 9477 to the device table

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Free any outstanding tx skbs during scrq reset

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix initial port flush problem

Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>
    ASoC: fsl-asoc-card: set priv->pdev before using it

Oleksij Rempel <linux@rempel-privat.de>
    net: stmmac: Assign configured channel value to EXTTS event

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: mdio: add helpers to extract clause 45 regad and devad fields

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix UBSAN warning in kv_dpm.c

Steve French <stfrench@microsoft.com>
    cifs: fix typo in module parameter enable_gcm_256

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: use dedicated pinctrl type for RK3328

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO3-B pins

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO2-B pins

Hagar Hemdan <hagarhem@amazon.com>
    pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER

John Keeping <jkeeping@inmusicbrands.com>
    Input: ili210x - fix ili251x_read_touch_data() return value

Ziwei Xiao <ziweixiao@google.com>
    gve: Clear napi->skb before dev_kfree_skb_any()

David Awogbemila <awogbemila@google.com>
    gve: Add RX context.

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Force StorageD3Enable on more products

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: utils: Add Picasso to the list for forcing StorageD3Enable

Jan Beulich <jbeulich@suse.com>
    x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix deadlock in smb2_find_smb_tcon()

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Check for invalid SMN reads

Naveen Naidu <naveennaidu479@gmail.com>
    PCI: Add PCI_ERROR_RESPONSE and related definitions

Haifeng Xu <haifeng.xu@shopee.com>
    perf/core: Fix missing wakeup when waiting for context reference

Nam Cao <namcao@linutronix.de>
    riscv: fix overlap of allocated page and PTR_ERR

Jisheng Zhang <jszhang@kernel.org>
    riscv: mm: init: try best to use IS_ENABLED(CONFIG_64BIT) instead of #ifdef

Matthias Maennich <maennich@google.com>
    kheaders: explicitly define file modes for archived headers

Masahiro Yamada <masahiroy@kernel.org>
    Revert "kheaders: substituting --sort in archive creation"

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Disarm breadcrumbs if engines are already idle

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Only kick the signal worker if there's been an update

Nandor Kracser <bonifaido@gmail.com>
    ksmbd: ignore trailing slashes in share paths

Tony Luck <tony.luck@intel.com>
    x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL

Tony Luck <tony.luck@intel.com>
    x86/cpu/vfm: Add new macros to work with (vendor/family/model) values

Jeff Johnson <quic_jjohnson@quicinc.com>
    tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test

Matthew Mirvish <matthew@mm12.xyz>
    bcache: fix variable length array abuse in btree_iter

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

Adrian Hunter <adrian.hunter@intel.com>
    perf script: Show also errors for --insn-trace option

Changbin Du <changbin.du@huawei.com>
    perf: script: add raw|disasm arguments to --insn-trace option

Martin Leung <martin.leung@amd.com>
    drm/amd/display: revert Exit idle optimizations before HDCP execution

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8qm-mek: fix gpio number for reg_usdhc2_vmmc

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema

Grygorii Tertychnyi <grembeter@gmail.com>
    i2c: ocores: set IACK bit after core is enabled

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->retrans_stamp in tcp_rcv_fastopen_synack()

Aleksandr Nogikh <nogikh@google.com>
    kcov: don't lose track of remote references during softirqs

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 14

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix UBSAN warning in kv_dpm.c

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mso: using joiner is not possible with eDP MSO

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on N14AP7

Sean Christopherson <seanjc@google.com>
    KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes

Boris Burkov <boris@bur.io>
    btrfs: retry block group reclaim without infinite loop

Ignat Korchagin <ignat@cloudflare.com>
    net: do not leave a dangling sk pointer, when socket creation fails

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: rework RX over DMA

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Add check for srq max_sge attribute

Raju Rangoju <Raju.Rangoju@amd.com>
    ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."

Kalle Niemi <kaleposti@gmail.com>
    regulator: bd71815: fix ramp values

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

Li RongQing <lirongqing@baidu.com>
    dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list

Biju Das <biju.das.jz@bp.renesas.com>
    regulator: core: Fix modpost error "regulator_get_regmap" undefined

Oliver Neukum <oneukum@suse.com>
    net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Restore PTP tx_avail count in case of skb_pad() error

Jianguo Wu <wujianguo@chinatelecom.cn>
    seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix suspicious rcu_dereference_protected()

Simon Horman <horms@kernel.org>
    octeontx2-pf: Add error handling to VLAN unoffload handling

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: checksum offloading handling fix

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: No need to calculate speed divider when offload is disabled

Dan Carpenter <dan.carpenter@linaro.org>
    ptp: fix integer overflow in max_vclocks_store

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

Esben Haabendal <esben@geanix.com>
    serial: imx: Introduce timeout when waiting on transmitter empty

Songyang Li <leesongyang@outlook.com>
    MIPS: Octeon: Add PCIe link status check

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Avoid D3cold for HP Pavilion 17 PC/1972 PCIe Ports

Roman Smirnov <r.smirnov@omp.ru>
    udf: udftime: prevent overflow in udf_disk_stamp_to_time()

Joao Pinto <Joao.Pinto@synopsys.com>
    Avoid hw_desc array overrun in dw-axi-dmac

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

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Make stall-tasks directly exit when rcutorture tests end

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sec - Fix memory leak for sec resource release

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Disable BH when taking works lock on MT path

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix info leak when fetching board id

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: qca: Fix error code in qca_read_fw_build_info()

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

Nathan Chancellor <nathan@kernel.org>
    kbuild: Remove support for Clang's ThinLTO caching

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: update add_addr counters after connect

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID

Matthias Goergens <matthias.goergens@gmail.com>
    hugetlb_encode.h: fix undefined behaviour (34 << 26)

Doug Brown <doug@schmorgal.com>
    serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory: don't unpoison huge_zero_folio

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Fix ATA NCQ priority support

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    knfsd: LOOKUP can return an illegal error value

Vamshi Gajjela <vamshigajjela@google.com>
    spmi: hisi-spmi-controller: Do not override device identifier

Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
    vmci: prevent speculation leaks by sanitizing event in event_deliver()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    sock_map: avoid race between sock_map_close and sk_psock_put

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Print correct max open zones limit in null_init_zoned_dev()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/selftests: Fix kprobe event name test for .isra. functions

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure snd_una is properly initialized on connect

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

Rao Shoaib <Rao.Shoaib@oracle.com>
    af_unix: Read with MSG_PEEK loops if the first unread byte is OOB

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

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix kernel crash problem in concurrent scenario

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

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    HID: core: remove unnecessary WARN_ON() in implement()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: store IRQ trigger type and unmask status separately

Gregor Herburger <gregor.herburger@tq-group.com>
    gpio: tqmx86: fix typo in Kconfig label

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-smbios: Fix wrong token data in sysfs

ye xingchen <ye.xingchen@zte.com.cn>
    platform/x86: dell-smbios-base: Use sysfs_emit()

Chen Hanxiao <chenhx.fnst@fujitsu.com>
    SUNRPC: return proper error from gss_wrap_req_priv

Samuel Holland <samuel.holland@sifive.com>
    clk: sifive: Do not register clkdevs for PRCI clocks

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: try trimming too long modalias strings

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/uaccess: Fix build errors seen with GCC 13/14

Breno Leitao <leitao@debian.org>
    scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply broken streams quirk to Etron EJ188 xHCI host

Hector Martin <marcan@marcan.st>
    xhci: Handle TD clearing for multiple streams case

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply reset resume quirk to Etron EJ188 xHCI host

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Set correct transferred length for cancelled bulk transfers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    jfs: xattr: fix buffer overflow for invalid xattr

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: release irq in mei_me_pci_resume error path

Kyle Tso <kyletso@google.com>
    usb: typec: tcpm: Ignore received Hard Reset in TOGGLING state

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

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: fix QCOM_RPROC_COMMON dependency

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix bogus test success on Aarch64

Mark Brown <broonie@kernel.org>
    selftests/mm: log a consistent test name for check_compaction

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/mm: conform test to TAP format output

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages

Frank van der Linden <fvdl@google.com>
    mm/cma: drop incorrect alignment check in cma_init_reserved_mem

David Hildenbrand <david@redhat.com>
    cma: factor out minimum alignment requirement

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    i2c: acpi: Unbind mux adapters before delete

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    i2c: add fwnode APIs

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mmc: davinci: Don't strip remove function when driver is builtin

Yangtao Li <frank.li@vivo.com>
    mmc: davinci_mmc: Convert to platform remove callback returning void

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix possible use-after-free issue in ftrace_location()

Peter Zijlstra <peterz@infradead.org>
    x86/ibt,ftrace: Search for __fentry__ location

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: replace hardcoded divisor value with BIT() macro

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix info leak when fetching fw build id

Tim Jiang <quic_tjiang@quicinc.com>
    Bluetooth: qca: add support for QCA2066

Neil Armstrong <neil.armstrong@linaro.org>
    Bluetooth: qca: use switch case for soc type behavior

Luca Weiss <luca.weiss@fairphone.com>
    Bluetooth: btqca: Add WCN3988 support

Min-Hua Chen <minhuadotchen@gmail.com>
    Bluetooth: btqca: use le32_to_cpu for ver.soc_id

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    Bluetooth: hci_qca: mark OF related data as maybe unused

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    skbuff: introduce skb_pull_data

Thomas Weißschuh <linux@weissschuh.net>
    misc/pvpanic-pci: register attributes via pci_driver

Thomas Weißschuh <linux@weissschuh.net>
    misc/pvpanic: deduplicate common code

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pvpanic: Indentation fixes here and there

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pvpanic: Keep single style across modules

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix incorrect DSC instance for MST

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    drm/amd/display: drop unnecessary NULL checks in debugfs

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    drm/amd/display: Clean up some inconsistent indenting

George Shen <george.shen@amd.com>
    drm/amd/display: Handle Y carry-over in VCP X.Y calculation

Hans de Goede <hdegoede@redhat.com>
    iio: accel: mxc4005: Reset chip on probe() and resume()

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete

John Keeping <john@metanate.com>
    usb: gadget: f_fs: use io_data->status consistently

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible race in __fib6_drop_pcpu_from()

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_empty_lockless() in unix_release_sock().

Eric Dumazet <edumazet@google.com>
    af_unix: annotate lockless accesses to sk->sk_err

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_stream_read_skb().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_stream_connect().

Eric Dumazet <edumazet@google.com>
    net: drop nopreempt requirement on sock_prot_inuse_add()

Eric Dumazet <edumazet@google.com>
    net: inline sock_prot_inuse_add()

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in unix_write_space() and poll().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_inq_len().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annodate data-races around sk->sk_state for writers.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Set sk->sk_state under unix_state_lock() for truly disconencted peer.

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

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Always allocate PF entries from low prioriy zone

Jiri Olsa <jolsa@kernel.org>
    bpf: Set run context for rawtp test_run callback

Eric Dumazet <edumazet@google.com>
    ipv6: sr: block BH in seg6_output_core() and seg6_input_core()

DelphineCCChiu <delphine_cc_chiu@wiwynn.com>
    net/ncsi: Fix the multi thread manner of NCSI driver

Peter Delevoryas <peter@pjd.dev>
    net/ncsi: Simplify Kconfig/dts control flow

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
    wifi: cfg80211: Lock wiphy in cfg80211_get_station

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Fix deadlock in ieee80211_sta_ps_deliver_wakeup()

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: mesh: Fix leak of mesh_preq_queue objects


-------------

Diffstat:

 .../bindings/i2c/google,cros-ec-i2c-tunnel.yaml    |   2 +-
 Makefile                                           |   9 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   2 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   2 +-
 arch/arm/boot/dts/rk3066a.dtsi                     |   1 +
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |   2 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |   4 +-
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
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/kernel/sys_parisc32.c                  |   9 -
 arch/parisc/kernel/syscalls/syscall.tbl            |   6 +-
 arch/powerpc/include/asm/fadump-internal.h         |   5 -
 arch/powerpc/include/asm/hvcall.h                  |   8 +-
 arch/powerpc/include/asm/io.h                      |  24 +-
 arch/powerpc/include/asm/uaccess.h                 |  15 +-
 arch/powerpc/kernel/fadump.c                       |   2 +-
 arch/powerpc/kernel/syscalls/syscall.tbl           |   2 +-
 arch/riscv/mm/init.c                               |  58 ++---
 arch/s390/kernel/syscalls/syscall.tbl              |   2 +-
 arch/sh/kernel/sys_sh32.c                          |  11 +
 arch/sh/kernel/syscalls/syscall.tbl                |   3 +-
 arch/sparc/kernel/sys32.S                          | 221 -----------------
 arch/sparc/kernel/syscalls/syscall.tbl             |   8 +-
 arch/x86/entry/syscalls/syscall_32.tbl             |   2 +-
 arch/x86/include/asm/cpu_device_id.h               |  98 ++++++++
 arch/x86/include/asm/efi.h                         |  11 +
 arch/x86/kernel/amd_nb.c                           |   9 +-
 arch/x86/kernel/cpu/match.c                        |   4 +-
 arch/x86/kernel/fpu/core.c                         |   4 +-
 arch/x86/kernel/kprobes/core.c                     |  11 +-
 arch/x86/kernel/time.c                             |  20 +-
 arch/x86/kvm/x86.c                                 |   9 +-
 arch/x86/mm/numa.c                                 |   6 +-
 arch/x86/platform/efi/Makefile                     |   3 +-
 arch/x86/platform/efi/efi.c                        |   8 +-
 arch/x86/platform/efi/memmap.c                     | 249 +++++++++++++++++++
 block/ioctl.c                                      |   2 +-
 crypto/ecdh.c                                      |   2 +
 drivers/acpi/acpica/exregion.c                     |  23 +-
 drivers/acpi/video_detect.c                        |   8 +
 drivers/acpi/x86/utils.c                           |  23 +-
 drivers/ata/ahci.c                                 |  17 +-
 drivers/ata/libata-core.c                          |   8 +-
 drivers/base/core.c                                |   3 +
 drivers/block/null_blk/zoned.c                     |   2 +-
 drivers/bluetooth/ath3k.c                          |  25 +-
 drivers/bluetooth/btqca.c                          | 186 +++++++++++---
 drivers/bluetooth/btqca.h                          |  36 +--
 drivers/bluetooth/hci_qca.c                        | 266 ++++++++++++++++-----
 drivers/clk/sifive/sifive-prci.c                   |   8 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   4 +-
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   6 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h              |   1 +
 drivers/dma/idxd/irq.c                             |   4 +-
 drivers/dma/ioat/init.c                            |  73 +++---
 drivers/dma/ioat/registers.h                       |   7 -
 drivers/firmware/efi/fdtparams.c                   |   4 +
 drivers/firmware/efi/memmap.c                      | 239 +-----------------
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-davinci.c                        |   5 +
 drivers/gpio/gpio-tqmx86.c                         |  46 ++--
 drivers/gpio/gpiolib-cdev.c                        |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |  18 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  | 144 +++++------
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |   6 +
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c          |   2 +
 .../drm/arm/display/komeda/komeda_pipeline_state.c |   2 +-
 drivers/gpu/drm/bridge/panel.c                     |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   7 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   7 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  16 +-
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
 drivers/i2c/i2c-core-acpi.c                        |  30 +--
 drivers/i2c/i2c-core-base.c                        |  98 ++++++++
 drivers/i2c/i2c-core-of.c                          |  66 -----
 drivers/i2c/i2c-slave-testunit.c                   |   5 +-
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/accel/mxc4005.c                        |  68 ++++++
 drivers/iio/adc/ad7266.c                           |   2 +
 drivers/iio/adc/ad9467.c                           |   4 +-
 drivers/iio/chemical/bme680.h                      |   2 +
 drivers/iio/chemical/bme680_core.c                 |  62 ++++-
 drivers/iio/dac/ad5592r-base.c                     |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   4 -
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   4 -
 drivers/infiniband/core/restrack.c                 |  51 +---
 drivers/infiniband/hw/mlx5/srq.c                   |  13 +-
 drivers/input/input.c                              | 105 ++++++--
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/iommu/amd/amd_iommu_types.h                |  24 +-
 drivers/iommu/amd/init.c                           |  55 ++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/md/bcache/bset.c                           |  44 ++--
 drivers/md/bcache/bset.h                           |  28 ++-
 drivers/md/bcache/btree.c                          |  40 ++--
 drivers/md/bcache/super.c                          |   5 +-
 drivers/md/bcache/sysfs.c                          |   2 +-
 drivers/md/bcache/writeback.c                      |  10 +-
 drivers/media/dvb-core/dvbdev.c                    |   2 +-
 drivers/misc/mei/pci-me.c                          |   4 +-
 drivers/misc/pvpanic/pvpanic-mmio.c                |  59 +----
 drivers/misc/pvpanic/pvpanic-pci.c                 |  80 +------
 drivers/misc/pvpanic/pvpanic.c                     |  90 ++++++-
 drivers/misc/pvpanic/pvpanic.h                     |  10 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   6 +-
 drivers/mmc/host/davinci_mmc.c                     |   6 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  11 +-
 drivers/mmc/host/sdhci.c                           |  25 +-
 drivers/mtd/parsers/redboot.c                      |   2 +-
 drivers/net/dsa/microchip/ksz9477.c                |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  |  11 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  14 +-
 drivers/net/ethernet/google/gve/gve.h              |  13 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  76 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  21 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  33 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
 drivers/net/ethernet/qualcomm/qca_debug.c          |   6 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |  16 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  55 ++---
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/net/usb/rtl8150.c                          |   3 +-
 drivers/net/virtio_net.c                           |  12 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 +
 drivers/net/wireless/ath/ath.h                     |   6 +-
 drivers/net/wireless/ath/ath10k/Kconfig            |   1 +
 drivers/net/wireless/ath/ath9k/main.c              |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  10 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |  19 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   1 -
 drivers/of/of_reserved_mem.c                       |   9 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   6 +-
 drivers/pci/pci.c                                  |  12 +
 drivers/pinctrl/core.c                             |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  68 +++++-
 drivers/pinctrl/pinctrl-rockchip.h                 |   1 +
 drivers/platform/x86/dell/dell-smbios-base.c       |  91 +++----
 drivers/power/supply/cros_usbpd-charger.c          |  11 +-
 drivers/ptp/ptp_chardev.c                          |   3 +-
 drivers/ptp/ptp_sysfs.c                            |   3 +-
 drivers/pwm/pwm-stm32.c                            |   3 +
 drivers/regulator/bd71815-regulator.c              |   2 +-
 drivers/regulator/core.c                           |   1 +
 drivers/scsi/mpi3mr/mpi3mr.h                       |   1 +
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  67 ++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  19 ++
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   3 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  25 --
 drivers/scsi/qedi/qedi_debugfs.c                   |  12 +-
 drivers/scsi/scsi_transport_sas.c                  |  29 +++
 drivers/soc/ti/ti_sci_pm_domains.c                 |  20 +-
 drivers/soc/ti/wkup_m3_ipc.c                       |   7 +-
 drivers/spmi/hisi-spmi-controller.c                |   1 -
 drivers/tty/serial/8250/8250_exar.c                |  42 ++++
 drivers/tty/serial/8250/8250_omap.c                |  25 +-
 drivers/tty/serial/8250/8250_pxa.c                 |   1 +
 drivers/tty/serial/imx.c                           |  11 +-
 drivers/tty/serial/mcf.c                           |   2 +-
 drivers/tty/serial/sc16is7xx.c                     |  25 +-
 drivers/tty/serial/stm32-usart.c                   | 208 ++++++++++++----
 drivers/tty/serial/stm32-usart.h                   |  12 +-
 drivers/usb/atm/cxacru.c                           |  14 ++
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/dwc3/core.c                            |   6 -
 drivers/usb/gadget/function/f_fs.c                 |   9 +-
 drivers/usb/gadget/function/f_printer.c            |  40 +++-
 drivers/usb/host/xhci-pci.c                        |   7 +
 drivers/usb/host/xhci-ring.c                       |  59 +++--
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/misc/uss720.c                          |  22 +-
 drivers/usb/musb/da8xx.c                           |   8 +-
 drivers/usb/storage/alauda.c                       |   9 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   1 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  14 +-
 fs/btrfs/block-group.c                             |  11 +-
 fs/btrfs/disk-io.c                                 |  10 +-
 fs/cifs/cifsfs.c                                   |   2 +-
 fs/cifs/smb2transport.c                            |   2 +-
 fs/f2fs/super.c                                    |   2 -
 fs/jfs/xattr.c                                     |   4 +-
 fs/ksmbd/mgmt/share_config.c                       |   6 +-
 fs/nfs/read.c                                      |   4 -
 fs/nfsd/nfsfh.c                                    |   4 +-
 fs/nilfs2/dir.c                                    |  59 +++--
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
 include/linux/cma.h                                |   9 +
 include/linux/compat.h                             |   2 +-
 include/linux/efi.h                                |  10 +-
 include/linux/filter.h                             |   5 +-
 include/linux/i2c.h                                |  26 +-
 include/linux/iommu.h                              |   2 +-
 include/linux/kcov.h                               |   2 +
 include/linux/mdio.h                               |  12 +
 include/linux/mod_devicetable.h                    |   2 +
 include/linux/nvme.h                               |   4 +-
 include/linux/pci.h                                |   9 +
 include/linux/skbuff.h                             |   2 +
 include/linux/syscalls.h                           |   8 +-
 include/net/bluetooth/hci_core.h                   |  36 ++-
 include/net/inet_connection_sock.h                 |  10 +-
 include/net/netfilter/nf_tables.h                  |   5 +
 include/net/request_sock.h                         |   2 +
 include/net/sock.h                                 |  16 +-
 include/net/tcp.h                                  |   2 +-
 include/scsi/scsi_transport_sas.h                  |   2 +
 include/trace/events/qdisc.h                       |   2 +-
 include/uapi/asm-generic/hugetlb_encode.h          |  26 +-
 include/uapi/asm-generic/unistd.h                  |   2 +-
 kernel/bpf/core.c                                  |   4 +-
 kernel/bpf/trampoline.c                            |  20 +-
 kernel/bpf/verifier.c                              |   8 +-
 kernel/cpu.c                                       |   8 +-
 kernel/dma/contiguous.c                            |   4 +-
 kernel/events/core.c                               |  13 +
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/gen_kheaders.sh                             |   9 +-
 kernel/kcov.c                                      |   1 +
 kernel/kprobes.c                                   |   8 +-
 kernel/padata.c                                    |   8 +-
 kernel/pid_namespace.c                             |   1 +
 kernel/rcu/rcutorture.c                            |  16 +-
 kernel/sys_ni.c                                    |   2 +-
 kernel/time/tick-common.c                          |  42 ++--
 kernel/trace/Kconfig                               |   4 +-
 kernel/trace/ftrace.c                              |  71 ++++--
 kernel/trace/preemptirq_delay_test.c               |   1 +
 mm/cma.c                                           |  20 +-
 mm/memory-failure.c                                |   7 +
 net/batman-adv/originator.c                        |  29 +++
 net/bluetooth/l2cap_core.c                         |   8 +-
 net/bpf/test_run.c                                 |   6 +
 net/can/j1939/main.c                               |   6 +-
 net/can/j1939/transport.c                          |  21 +-
 net/core/drop_monitor.c                            |  20 +-
 net/core/filter.c                                  |   3 +
 net/core/net_namespace.c                           |   9 +-
 net/core/netpoll.c                                 |   2 +-
 net/core/skbuff.c                                  |  24 ++
 net/core/sock.c                                    |  20 +-
 net/core/sock_map.c                                |  16 +-
 net/core/xdp.c                                     |   4 +-
 net/dccp/ipv4.c                                    |   7 +-
 net/dccp/ipv6.c                                    |   7 +-
 net/ieee802154/socket.c                            |   4 +-
 net/ipv4/af_inet.c                                 |  23 +-
 net/ipv4/cipso_ipv4.c                              |  12 +-
 net/ipv4/inet_connection_sock.c                    |  22 +-
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/tcp.c                                     |  16 +-
 net/ipv4/tcp_input.c                               |  50 +++-
 net/ipv4/tcp_minisocks.c                           |   5 +-
 net/ipv6/af_inet6.c                                |  24 +-
 net/ipv6/ip6_fib.c                                 |   6 +-
 net/ipv6/ipv6_sockglue.c                           |  17 +-
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/seg6_iptunnel.c                           |  14 +-
 net/ipv6/seg6_local.c                              |   8 +-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/xfrm6_policy.c                            |   8 +-
 net/iucv/iucv.c                                    |  26 +-
 net/mac80211/he.c                                  |  10 +-
 net/mac80211/mesh_pathtbl.c                        |  13 +
 net/mac80211/sta_info.c                            |   4 +-
 net/mptcp/pm_netlink.c                             |  21 +-
 net/mptcp/protocol.c                               |   1 +
 net/ncsi/internal.h                                |   2 +
 net/ncsi/ncsi-manage.c                             |  95 ++++----
 net/ncsi/ncsi-rsp.c                                |   4 +-
 net/netfilter/ipset/ip_set_core.c                  | 104 ++++----
 net/netfilter/ipset/ip_set_list_set.c              |  30 ++-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nft_lookup.c                         |   3 +-
 net/netlink/af_netlink.c                           |   4 -
 net/netrom/nr_timer.c                              |   3 +-
 net/packet/af_packet.c                             |  30 ++-
 net/sched/act_api.c                                |  66 +++--
 net/sched/act_ct.c                                 |  21 +-
 net/sched/sch_multiq.c                             |   2 +-
 net/sched/sch_taprio.c                             |  15 +-
 net/sctp/socket.c                                  |   5 -
 net/smc/af_smc.c                                   |   2 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   4 +-
 net/tipc/node.c                                    |   1 +
 net/unix/af_unix.c                                 | 113 +++++----
 net/unix/diag.c                                    |  12 +-
 net/wireless/pmsr.c                                |   8 +-
 net/wireless/util.c                                |   7 +-
 net/xdp/xsk.c                                      |   4 -
 scripts/Makefile.dtbinst                           |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/fsl/fsl-asoc-card.c                      |   3 +-
 sound/synth/emux/soundfont.c                       |  17 +-
 tools/include/asm-generic/hugetlb_encode.h         |  26 +-
 tools/perf/Documentation/perf-script.txt           |   7 +-
 tools/perf/builtin-script.c                        |  24 +-
 tools/testing/selftests/arm64/tags/tags_test.c     |   4 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |  26 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |  13 +-
 .../ftrace/test.d/kprobe/kprobe_eventname.tc       |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   5 +-
 tools/testing/selftests/vm/compaction_test.c       | 108 +++++----
 364 files changed, 3886 insertions(+), 2550 deletions(-)


