Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA02E719E;
	Tue, 15 Jul 2025 13:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587495; cv=none; b=c+5dHdlyRodSJXQ+yR9a+8Kz9u3dvi5Kj+GjqyOHYIktVlj+a+AH5EcXDzObQOZUcVqwX8DKE7E2WJe4rjuEu3FLBPYqQzItZrCdG5IlRIHvgd5uo4Dx8e4zV/HFeh8Cywhi0PGykBsSNXHlK7IXjg+0LJbd8PVp1VsiltzL1kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587495; c=relaxed/simple;
	bh=/h1kCSMCh8rn01uACQJT7XSjQAKf2dHSMGSL/1LwlUY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h2u/GgREBfEtkNKwAYVRFmbWnKKYSO9v8yCD1yZ7wCsGvblIZh+3k0ABIaSNkb+0PIv+JDulXHlFskXjI0gYPILtHfWJf3EFC20DQzMtWgYKbIexW4H2OxPjDA+l8uq7FNtSnSFGEAcgUdggpj+2HmBV1JKiG5+Nqoyke1jI0yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8/H0P5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8/H0P5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4867C4CEF1;
	Tue, 15 Jul 2025 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587495;
	bh=/h1kCSMCh8rn01uACQJT7XSjQAKf2dHSMGSL/1LwlUY=;
	h=From:To:Cc:Subject:Date:From;
	b=R8/H0P5+T1nqlpkTl7cQSS/QqBRHFFPiQKZ3Yh4R+EmTNi8XA6i9UcksqsSAq6WhG
	 93LnTd+u4Pixzw/bH80oNbXZRHG11bB2UlQUC8qdbNZMo8jrmj/qzbyDrga1Gjw1lW
	 764pB0fHRVDnUi7bUowQNBKOPcgCY8bXT95kJFCo=
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
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 5.10 000/208] 5.10.240-rc1 review
Date: Tue, 15 Jul 2025 15:11:49 +0200
Message-ID: <20250715130810.830580412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.240-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.240-rc1
X-KernelTest-Deadline: 2025-07-17T13:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.240 release.
There are 208 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.240-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.240-rc1

Borislav Petkov <bp@kernel.org>
    x86/process: Move the buffer clearing before MONITOR

Borislav Petkov <bp@kernel.org>
    KVM: SVM: Advertise TSA CPUID bits to guests

Borislav Petkov <bp@kernel.org>
    KVM: x86: add support for CPUID leaf 0x80000021

Borislav Petkov <bp@kernel.org>
    x86/bugs: Add a Transient Scheduler Attacks mitigation

Borislav Petkov <bp@kernel.org>
    x86/bugs: Rename MDS machinery to something more generic

Jann Horn <jannh@google.com>
    x86/mm: Disable hugetlb page table sharing on 32-bit

Dongli Zhang <dongli.zhang@oracle.com>
    vhost-scsi: protect vq->log_used with vq->mutex

Hans de Goede <hdegoede@redhat.com>
    Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: quirks: Add quirk for 2 Chicony Electronics HP 5MP Cameras

Zhang Heng <zhangheng@kylinos.cn>
    HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY

Nicolas Pitre <npitre@baylibre.com>
    vt: add missing notification when switching back to text mode

Xiaowei Li <xiaowei.li@simcom.com>
    net: usb: qmi_wwan: add SIMCom 8230C composition

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Reduce stack usage in vector_eth_configure()

Thomas Fourier <fourier.thomas@gmail.com>
    atm: idt77252: Add missing `dma_map_error()`

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Set DMA unmap len correctly for XDP_REDIRECT

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Fix DCB ETS validation

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: ll_temac: Fix missing tx_pending check in ethtools_set_ringparam()

Sean Nyekjaer <sean@geanix.com>
    can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: microchip: limit 100M workaround to link-down events on LAN88xx

Kito Xu <veritas501@foxmail.com>
    net: appletalk: Fix device refcount leak in atrtr_create()

Wang Jinchao <wangjinchao600@gmail.com>
    md/raid1: Fix stack memory use after return in raid1_reshape

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_to_dev()

Christian König <christian.koenig@amd.com>
    dma-buf: fix timeout handling in dma_resv_wait_timeout v2

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - support Acer NGR 200 Controller

Vicki Pfau <vi@endrift.com>
    Input: xpad - add VID for Turtle Beach controllers

Matt Reynolds <mattreynolds@chromium.org>
    Input: xpad - add support for Amazon Game Controller

Jakub Kicinski <kuba@kernel.org>
    netlink: make sure we allow at least one dump skb

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix rmem check in netlink_broadcast_deliver().

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Ensure to disable clocks in error path

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: lib_test: add MODULE_LICENSE

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: atl1: Add missing DMA mapping error checks and count errors

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: battery: negate current when discharging"

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_serial: Fix race condition in TTY wakeup

Matthew Brost <matthew.brost@intel.com>
    drm/sched: Increment job count before swapping tail spsc queue

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: qcom: msm: mark certain pins as invalid for interrupts

JP Kobryn <inwardvessel@gmail.com>
    x86/mce: Make sure CMCI banks are cleared during shutdown on Intel

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Don't remove sysfs if thresholding sysfs init fails

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce/amd: Fix threshold limit reset

Peter Zijlstra <peterz@infradead.org>
    x86/its: FineIBT-paranoid vs ITS

Eric Biggers <ebiggers@google.com>
    x86/its: Fix build errors when CONFIG_MODULES=n

Peter Zijlstra <peterz@infradead.org>
    x86/its: Use dynamic thunks for indirect branches

Thomas Gleixner <tglx@linutronix.de>
    x86/modules: Set VM_FLUSH_RESET_PERMS in module_alloc()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Add "vmexit" option to skip mitigation on some CPUs

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Enable Indirect Target Selection mitigation

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Fix undefined reference to cpu_wants_rethunk_at()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Add support for ITS-safe return thunk

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/alternatives: Remove faulty optimization

Borislav Petkov (AMD) <bp@alien8.de>
    x86/alternative: Optimize returns patching

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Add support for ITS-safe indirect thunk

Peter Zijlstra <peterz@infradead.org>
    x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions

Peter Zijlstra <peterz@infradead.org>
    x86/alternatives: Introduce int3_emulate_jcc()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Enumerate Indirect Target Selection (ITS) bug

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/bhi: Define SPEC_CTRL_BHI_DIS_S

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    Documentation: x86/bugs/its: Add ITS documentation

David Howells <dhowells@redhat.com>
    rxrpc: Fix oops due to non-existence of prealloc backlog struct

Oleg Nesterov <oleg@redhat.com>
    fs/proc: do_task_stat: use __for_each_thread()

Victor Nogueira <victor@mojatatu.com>
    net/sched: Abort __tc_modify_qdisc if parent class does not exist

Yue Haibing <yuehaibing@huawei.com>
    atm: clip: Fix NULL pointer dereference in vcc_sendmsg()

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix infinite recursive call of clip_push().

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix memory leak of struct clip_vcc.

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix potential null-ptr-deref in to_atmarpd().

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: smsc: Fix link failure in forced mode with Auto-MDIX

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap

Michal Luczaj <mhal@rbox.co>
    vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_local`

Michal Luczaj <mhal@rbox.co>
    vsock: Fix transport_* TOCTOU

Andra Paraschiv <andraprs@amazon.com>
    af_vsock: Assign the vsock transport considering the vsock address flags

Andra Paraschiv <andraprs@amazon.com>
    af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path

Andra Paraschiv <andraprs@amazon.com>
    vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag

Andra Paraschiv <andraprs@amazon.com>
    vm_sockets: Add flags field in the vsock address data structure

Michal Luczaj <mhal@rbox.co>
    vsock: Fix transport_{g2h,h2g} TOCTOU

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_conn_close().

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix wraparounds of sk->sk_rmem_alloc.

Al Viro <viro@zeniv.linux.org.uk>
    fix proc_sys_compare() handling of in-lookup dentries

Peter Zijlstra <peterz@infradead.org>
    perf: Revert to requiring CAP_SYS_ADMIN for uprobes

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: add vblank check in IRQ handling

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8723bs: Avoid memset() in aes_cipher() and aes_decipher()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Rollback non processed entities on error

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Send control events for partial succeeds

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Return the number of processed controls

Seiji Nishikawa <snishika@redhat.com>
    ACPI: PAD: fix crash in exit_round_robin()

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: displayport: Fix potential deadlock

Oliver Neukum <oneukum@suse.com>
    Logitech C-270 even more broken

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Flush queued requests before stopping dbc

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbctty: disable ECHO flag by default

Fushuai Wang <wangfushuai@baidu.com>
    dpaa2-eth: fix xdp_rxq_info leak

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats

Radu Bulie <radu-andrei.bulie@nxp.com>
    dpaa2-eth: Update SINGLE_STEP register access

Radu Bulie <radu-andrei.bulie@nxp.com>
    dpaa2-eth: Update dpni_get_single_step_cfg command

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: rename dpaa2_eth_xdp_release_buf into dpaa2_eth_recycle_buf

Filipe Manana <fdmanana@suse.com>
    btrfs: use btrfs_record_snapshot_destroy() during rmdir

Filipe Manana <fdmanana@suse.com>
    btrfs: propagate last_unlink_trans earlier when doing a rmdir

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix handling of NFS level errors in I/O

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: update stats on NFS4ERR_DELAY for v4.1 DSes

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix vport loopback for MPV device

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Disable interrupts before resetting the GPU

Sergey Senozhatsky <senozhatsky@chromium.org>
    mtk-sd: reset host->mrq on prepare_data() error

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Prevent memory corruption from DMA map failure

Yue Hu <huyue2@yulong.com>
    mmc: mediatek: use data instead of mrq parameter from msdc_{un}prepare_data()

Manivannan Sadhasivam <mani@kernel.org>
    regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu: Return early if callback is not specified

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Refuse to evaluate a method if arguments are missing

Johannes Berg <johannes.berg@intel.com>
    wifi: ath6kl: remove WARN on bad firmware input

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: drop invalid source address OCB frames

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port()

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc: Fix struct termio related ioctl macros

Johannes Berg <johannes.berg@intel.com>
    ata: pata_cs5536: fix build on 32-bit UML

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Force to disable DMAs once when DMA mode is changed

Lion Ackermann <nnamrec@gmail.com>
    net/sched: Always pass notifications when child class becomes empty

Thomas Fourier <fourier.thomas@gmail.com>
    nui: Fix dma_mapping_error() check

Kohei Enju <enjuk@amazon.com>
    rose: fix dangling neighbour pointers in rose_rt_device_down()

Gustavo A. R. Silva <gustavoars@kernel.org>
    net: rose: Fix fall-through warnings for Clang

Alok Tiwari <alok.a.tiwari@oracle.com>
    enic: fix incorrect MTU comparison in enic_change_mtu()

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: align CL37 AN sequence as per databook

Dan Carpenter <dan.carpenter@linaro.org>
    lib: test_objagg: Set error message in check_expect_hints_stats()

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix timeline left held on VMA alloc error

Dan Carpenter <dan.carpenter@linaro.org>
    drm/i915/selftests: Change mock_request() to return error pointers

James Clark <james.clark@linaro.org>
    spi: spi-fsl-dspi: Clear completion counter before initiating transfer

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: fimd: Guard display clock control with runtime PM calls

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing error handling when searching for inode refs during log replay

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix CC counters query for MPV

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix spelling of a sysfs attribute name

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla2xxx: Fix DMA mapping test in qla24xx_get_port_database()

Benjamin Coddington <bcodding@redhat.com>
    NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN

Kuniyuki Iwashima <kuniyu@google.com>
    nfs: Clean up /proc/net/rpc/nfs when nfs_fs_proc_net_init() fails.

Mark Zhang <markzhang@nvidia.com>
    RDMA/mlx5: Initialize obj_event->obj_sub_list before xa_insert

David Thompson <davthompson@nvidia.com>
    platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Fix a pagefault in dma_unmap_sg() for not prepared data

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: do not index invalid pin_assignments

Ulf Hansson <ulf.hansson@linaro.org>
    Revert "mmc: sdhci: Disable SD card clock before changing parameters"

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci: Add a helper function for dump register in dynamic debug mode

HarshaVardhana S A <harshavardhana.sa@broadcom.com>
    vsock/vmci: Clear the vmci transport packet properly when initializing it

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: use spin_lock_irqsave in cmos_interrupt

Dev Jain <dev.jain@arm.com>
    arm64: Restrict pagetable teardown to avoid false warning

Brett A C Sheffield (Librecast) <bacs@librecast.net>
    Revert "ipv6: save dontfrag in cork"

Nathan Chancellor <nathan@kernel.org>
    s390: Add '-std=gnu11' to decompressor and purgatory CFLAGS

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot time

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Wait for Clk and Data Lanes to be ready

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Check return value when getting default PHY config

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix connecting to next bridge

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Fix race in GWS queue scheduling

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Unregister device before cleaning up on disconnect

Qiu-ji Chen <chenqiuji666@gmail.com>
    drm/tegra: Fix a possible null pointer dereference

Thierry Reding <treding@nvidia.com>
    drm/tegra: Assign plane type before registration

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix kobject reference count leak

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on sysfs attribute creation failure

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on kobject creation failure

Mark Harmstone <maharmstone@fb.com>
    btrfs: update superblock's device bytes_used when dropping chunk

Heinz Mauelshagen <heinzm@redhat.com>
    dm-raid: fix variable in journal device check

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: L2CAP: Fix L2CAP MTU negotiation

Yao Zi <ziyao@disroot.org>
    dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Release atm_dev_mutex after removing procfs in atm_dev_deregister().

Simon Horman <horms@kernel.org>
    net: enetc: Correct endianness handling in _enetc_rd_reg64

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Add missing error check in start_io_thread()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/uapi: fix linux/vm_sockets.h userspace compilation errors

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: fix beacon interval calculation overflow

Yuan Chen <chenyuan@kylinos.cn>
    libbpf: Fix null pointer dereference in btf_dump__free on allocation failure

Al Viro <viro@zeniv.linux.org.uk>
    attach_recursive_mnt(): do not lock the covering tree when sliding something under it

Youngjun Lee <yjjuny.lee@samsung.com>
    ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()

Eric Dumazet <edumazet@google.com>
    atm: clip: prevent NULL deref in clip_push()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: robotfuzz-osif: disable zero-length read messages

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: tiny-usb: disable zero-length read messages

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: reject invalid perturb period

Niklas Cassel <cassel@kernel.org>
    PCI: cadence-ep: Correct PBA offset in .set_msix() callback

Long Li <longli@microsoft.com>
    uio_hv_generic: Align ring size to system page

Saurabh Sengar <ssengar@linux.microsoft.com>
    uio_hv_generic: Query the ringbuffer size for device

Saurabh Sengar <ssengar@linux.microsoft.com>
    Drivers: hv: vmbus: Add utility function for querying ring size

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: Rename 'alloced' to 'allocated'

Haiyang Zhang <haiyangz@microsoft.com>
    Drivers: hv: vmbus: Fix duplicate CPU assignments within a device

Alexandru Ardelean <alexandru.ardelean@analog.com>
    uio: uio_hv_generic: use devm_kzalloc() for private data alloc

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    RDMA/iwcm: Fix use-after-free of work objects after cm_id destruction

Weihang Li <liweihang@huawei.com>
    RDMA/core: Use refcount_t instead of atomic_t on refcount of iwcm_id_private

Chao Yu <chao@kernel.org>
    f2fs: don't over-report free space or inodes in statvfs

Brett Werling <brett.werling@garmin.com>
    can: tcan4x5x: fix power regulator retrieval during probe

Marek Szyprowski <m.szyprowski@samsung.com>
    media: omap3isp: use sgtable-based scatterlist wrappers

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: validate AG parameters in dbMount() to prevent crashes

Dave Kleikamp <dave.kleikamp@oracle.com>
    fs/jfs: consolidate sanity checking in dbMount

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()

Junlin Yang <yangjunlin@yulong.com>
    usb: typec: tcpci_maxim: add terminating newlines to logging

Junlin Yang <yangjunlin@yulong.com>
    usb: typec: tcpci_maxim: remove redundant assignment

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpci_maxim: Fix uninitialized return variable

Wupeng Ma <mawupeng1@huawei.com>
    VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify

George Kennedy <george.kennedy@oracle.com>
    VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix read_stb function and get_stb ioctl

Dave Penkler <dpenkler@gmail.com>
    USB: usbtmc: Add USBTMC_IOCTL_GET_STB

Dave Penkler <dpenkler@gmail.com>
    USB: usbtmc: Fix reading stale status byte

Kees Cook <kees@kernel.org>
    ovl: Check for NULL d_inode() in ovl_dentry_upper()

Dmitry Kandybka <d.kandybka@gmail.com>
    ceph: fix possible integer overflow in ceph_zero_objects()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ALSA: hda: Add new pci id for AMD GPU display HD audio controller

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Ignore unsol events for cards being shut down

Jos Wang <joswang@lenovo.com>
    usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode

Robert Hodaszi <robert.hodaszi@digi.com>
    usb: cdc-wdm: avoid setting WDM_READ for ZLP-s

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: Add checks for snprintf() calls in usb_alloc_dev()

Chance Yang <chance.yang@kneron.us>
    usb: common: usb-conn-gpio: use a unique name for usb connector device

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: potential integer overflow in usbg_make_tpg()

Sami Tolvanen <samitolvanen@google.com>
    um: Add cmpxchg8b_emu and checksum functions to asm-prototypes.h

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: pressure: zpa2326: Use aligned_s64 for the timestamp

Linggang Zeng <linggang.zeng@easystack.cn>
    bcache: fix NULL pointer in cache_set_flush()

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: fix dm-raid max_write_behind setting

Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
    dmaengine: xilinx_dma: Set dma_device directions

Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
    hwmon: (pmbus/max34440) Fix support for max34451

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    leds: multicolor: Fix intensity setting while SW blinking

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max14577: Fix wakeup source leaks on device unbind

Peng Fan <peng.fan@nxp.com>
    mailbox: Not protect module_put with spin_lock_irqsave

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: fix listxattr to return selinux security label

Pali Rohár <pali@kernel.org>
    cifs: Fix cifs_query_path_info() for Windows NT servers


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/ABI/testing/sysfs-driver-ufs         |   2 +-
 Documentation/admin-guide/hw-vuln/index.rst        |   1 +
 .../hw-vuln/indirect-target-selection.rst          | 156 +++++++++++
 .../hw-vuln/processor_mmio_stale_data.rst          |   4 +-
 Documentation/admin-guide/kernel-parameters.txt    |  28 ++
 Documentation/devicetree/bindings/serial/8250.yaml |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/powerpc/include/uapi/asm/ioctls.h             |   8 +-
 arch/s390/Makefile                                 |   2 +-
 arch/s390/purgatory/Makefile                       |   2 +-
 arch/um/drivers/ubd_user.c                         |   2 +-
 arch/um/drivers/vector_kern.c                      |  42 +--
 arch/um/include/asm/asm-prototypes.h               |   5 +
 arch/x86/Kconfig                                   |  22 +-
 arch/x86/entry/entry.S                             |   8 +-
 arch/x86/include/asm/alternative.h                 |  26 ++
 arch/x86/include/asm/cpu.h                         |  13 +
 arch/x86/include/asm/cpufeature.h                  |   5 +-
 arch/x86/include/asm/cpufeatures.h                 |  14 +-
 arch/x86/include/asm/disabled-features.h           |   2 +-
 arch/x86/include/asm/irqflags.h                    |   4 +-
 arch/x86/include/asm/msr-index.h                   |  13 +-
 arch/x86/include/asm/mwait.h                       |  19 +-
 arch/x86/include/asm/nospec-branch.h               |  50 ++--
 arch/x86/include/asm/required-features.h           |   2 +-
 arch/x86/include/asm/text-patching.h               |  31 +++
 arch/x86/kernel/alternative.c                      | 308 ++++++++++++++++++++-
 arch/x86/kernel/cpu/amd.c                          |  58 ++++
 arch/x86/kernel/cpu/bugs.c                         | 272 +++++++++++++++++-
 arch/x86/kernel/cpu/common.c                       |  77 +++++-
 arch/x86/kernel/cpu/mce/amd.c                      |  15 +-
 arch/x86/kernel/cpu/mce/core.c                     |   8 +-
 arch/x86/kernel/cpu/mce/intel.c                    |   1 +
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kernel/ftrace.c                           |   4 +-
 arch/x86/kernel/kprobes/core.c                     |  39 +--
 arch/x86/kernel/module.c                           |  14 +-
 arch/x86/kernel/process.c                          |  15 +-
 arch/x86/kernel/static_call.c                      |   2 +-
 arch/x86/kernel/vmlinux.lds.S                      |   8 +
 arch/x86/kvm/cpuid.c                               |  31 ++-
 arch/x86/kvm/cpuid.h                               |   1 +
 arch/x86/kvm/svm/vmenter.S                         |   3 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/lib/retpoline.S                           |  39 +++
 arch/x86/net/bpf_jit_comp.c                        |   8 +-
 arch/x86/um/asm/checksum.h                         |   3 +
 drivers/acpi/acpi_pad.c                            |   7 +-
 drivers/acpi/acpica/dsmethod.c                     |   7 +
 drivers/acpi/battery.c                             |  19 +-
 drivers/ata/pata_cs5536.c                          |   2 +-
 drivers/atm/idt77252.c                             |   5 +
 drivers/base/cpu.c                                 |  10 +
 drivers/dma-buf/dma-resv.c                         |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   2 +
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |   2 +-
 drivers/gpu/drm/bridge/cdns-dsi.c                  |  27 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |   4 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  12 +
 drivers/gpu/drm/i915/gt/intel_ring_submission.c    |   3 +-
 drivers/gpu/drm/i915/selftests/i915_request.c      |  20 +-
 drivers/gpu/drm/i915/selftests/mock_request.c      |   2 +-
 drivers/gpu/drm/tegra/dc.c                         |  17 +-
 drivers/gpu/drm/tegra/hub.c                        |   4 +-
 drivers/gpu/drm/tegra/hub.h                        |   3 +-
 drivers/gpu/drm/udl/udl_drv.c                      |   2 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   7 +
 drivers/gpu/drm/v3d/v3d_gem.c                      |   2 +
 drivers/gpu/drm/v3d/v3d_irq.c                      |  38 ++-
 drivers/hid/hid-ids.h                              |   5 +
 drivers/hid/hid-quirks.c                           |   3 +
 drivers/hid/wacom_sys.c                            |   6 +-
 drivers/hv/channel_mgmt.c                          | 121 +++++---
 drivers/hv/hyperv_vmbus.h                          |  19 +-
 drivers/hv/vmbus_drv.c                             |   2 +-
 drivers/hwmon/pmbus/max34440.c                     |  48 +++-
 drivers/i2c/busses/i2c-robotfuzz-osif.c            |   6 +
 drivers/i2c/busses/i2c-tiny-usb.c                  |   6 +
 drivers/iio/pressure/zpa2326.c                     |   2 +-
 drivers/infiniband/core/iwcm.c                     |  38 +--
 drivers/infiniband/core/iwcm.h                     |   2 +-
 drivers/infiniband/hw/mlx5/counters.c              |   2 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |  33 +++
 drivers/input/joystick/xpad.c                      |   5 +
 drivers/input/keyboard/atkbd.c                     |   3 +-
 drivers/leds/led-class-multicolor.c                |   3 +-
 drivers/mailbox/mailbox.c                          |   2 +-
 drivers/md/bcache/super.c                          |   7 +-
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/md/raid1.c                                 |   1 +
 drivers/media/platform/omap3isp/ispccdc.c          |   8 +-
 drivers/media/platform/omap3isp/ispstat.c          |   6 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  61 ++--
 drivers/mfd/max14577.c                             |   1 +
 drivers/misc/vmw_vmci/vmci_host.c                  |   9 +-
 drivers/mmc/host/mtk-sd.c                          |  39 ++-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mmc/host/sdhci.h                           |  16 ++
 drivers/net/can/m_can/m_can.c                      |   2 +-
 drivers/net/can/m_can/tcan4x5x.c                   |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   2 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   9 +
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |  78 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 141 ++++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  20 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  18 +-
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |   6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |   2 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |   6 +
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +-
 drivers/net/ethernet/sun/niu.c                     |  31 ++-
 drivers/net/ethernet/sun/niu.h                     |   4 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   2 +-
 drivers/net/phy/microchip.c                        |   2 +-
 drivers/net/phy/smsc.c                             |  28 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath6kl/bmi.c              |   4 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   6 +-
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   5 +-
 drivers/pci/controller/pci-hyperv.c                |  17 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  20 ++
 drivers/platform/mellanox/mlxbf-tmfifo.c           |   3 +-
 drivers/pwm/pwm-mediatek.c                         |  15 +-
 drivers/regulator/gpio-regulator.c                 |   4 +-
 drivers/rtc/lib_test.c                             |   2 +
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/ufs/ufs-sysfs.c                       |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |  11 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |  46 +--
 drivers/target/target_core_pr.c                    |   4 +-
 drivers/tty/vt/vt.c                                |   1 +
 drivers/uio/uio_hv_generic.c                       |  18 +-
 drivers/usb/class/cdc-wdm.c                        |  23 +-
 drivers/usb/class/usbtmc.c                         |  53 ++--
 drivers/usb/common/usb-conn-gpio.c                 |  25 +-
 drivers/usb/core/quirks.c                          |   3 +-
 drivers/usb/core/usb.c                             |  14 +-
 drivers/usb/gadget/function/f_tcm.c                |   4 +-
 drivers/usb/gadget/function/u_serial.c             |   6 +-
 drivers/usb/host/xhci-dbgcap.c                     |   4 +
 drivers/usb/host/xhci-dbgtty.c                     |   1 +
 drivers/usb/typec/altmodes/displayport.c           |   5 +-
 drivers/usb/typec/tcpm/tcpci_maxim.c               |  20 +-
 drivers/vhost/scsi.c                               |   7 +-
 fs/btrfs/inode.c                                   |  36 +--
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/volumes.c                                 |   6 +
 fs/ceph/file.c                                     |   2 +-
 fs/cifs/misc.c                                     |   8 +
 fs/f2fs/super.c                                    |  30 +-
 fs/jfs/jfs_dmap.c                                  |  41 +--
 fs/namespace.c                                     |   8 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             | 121 +++++---
 fs/nfs/inode.c                                     |  17 +-
 fs/nfs/nfs4proc.c                                  |  12 +-
 fs/nfs/pnfs.c                                      |   4 +-
 fs/overlayfs/util.c                                |   4 +-
 fs/proc/array.c                                    |   6 +-
 fs/proc/inode.c                                    |   2 +-
 fs/proc/proc_sysctl.c                              |  18 +-
 include/drm/spsc_queue.h                           |   4 +-
 include/linux/cpu.h                                |   3 +
 include/linux/hyperv.h                             |   2 +
 include/linux/ipv6.h                               |   1 -
 include/linux/module.h                             |   5 +
 include/linux/usb/typec_dp.h                       |   1 +
 include/uapi/linux/usb/tmc.h                       |   2 +
 include/uapi/linux/vm_sockets.h                    |  30 +-
 kernel/events/core.c                               |   2 +-
 kernel/rcu/tree.c                                  |   4 +
 lib/test_objagg.c                                  |   4 +-
 net/appletalk/ddp.c                                |   1 +
 net/atm/clip.c                                     |  75 +++--
 net/atm/resources.c                                |   3 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/ipv6/ip6_output.c                              |   9 +-
 net/mac80211/rx.c                                  |   4 +
 net/mac80211/util.c                                |   2 +-
 net/netlink/af_netlink.c                           |  90 +++---
 net/rose/rose_route.c                              |  15 +-
 net/rxrpc/call_accept.c                            |   3 +
 net/sched/sch_api.c                                |  42 +--
 net/sched/sch_sfq.c                                |  10 +-
 net/tipc/topsrv.c                                  |   2 +
 net/vmw_vsock/af_vsock.c                           |  78 +++++-
 net/vmw_vsock/vmci_transport.c                     |   4 +-
 sound/isa/sb/sb16_main.c                           |   4 +
 sound/pci/hda/hda_bind.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/soc/fsl/fsl_asrc.c                           |   3 +-
 sound/usb/stream.c                                 |   2 +
 tools/lib/bpf/btf_dump.c                           |   3 +
 203 files changed, 2697 insertions(+), 809 deletions(-)


