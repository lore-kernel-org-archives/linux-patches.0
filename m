Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519681F8909;
	Wed,  6 Nov 2024 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896673; cv=none; b=LIepOGR4vEdNe4pdP28FXHE4TEgWRJizj5DVzX7UtNgO+0GonavQa7SBgkKcCKb//SknKwRERWqeIHDyUR6dzcdi/Ajw54TFpDTyFgdIY6+OhCt/HCvT06bW9FO3V6wWT/6bbS4qnkicgeCcUmJX1r6LanttPyKBsIT/v0TkHn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896673; c=relaxed/simple;
	bh=pesJjkQL53MlxN5vdKkvk5V5SldOYcGphJ0XqljjuY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bxfnS6o3WUXP1ss73QWrhEjx2UiJwjvlAagUsGITNbxElf8/BGLf1XFSv66xgASo3linxp3oJkRj92KWv9XGHzXtd/8ksnYLigh7SD371HA0TZp61ZUgkjeAT6lBZG3QfSrQ6mNvEQTf6wpD5XvOJLyl3EjQWTqxRp21vxzY+zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNR60o32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNR60o32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569DDC4CECD;
	Wed,  6 Nov 2024 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896672;
	bh=pesJjkQL53MlxN5vdKkvk5V5SldOYcGphJ0XqljjuY0=;
	h=From:To:Cc:Subject:Date:From;
	b=kNR60o32eKCtLB3+J69ONXV/kyzyehoEgY1r+P434yLUgEKy3HvhBVoyuAN+O7Hkn
	 FdClKxXRjynlR5rp8Sl5vySGsEOu2xd+hzuRVq4WAG5j30FiQHon7O4KpnwikjLaB5
	 TdornwjtER9b4uHDmTVktpeVmsGjlR7/SeU4g1zY=
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
	hagar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 5.10 000/110] 5.10.229-rc1 review
Date: Wed,  6 Nov 2024 13:03:26 +0100
Message-ID: <20241106120303.135636370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.229-rc1
X-KernelTest-Deadline: 2024-11-08T12:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.229 release.
There are 110 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.229-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.229-rc1

Johannes Berg <johannes.berg@intel.com>
    mac80211: always have ieee80211_sta_restart()

Jeongjun Park <aha310510@gmail.com>
    vt: prevent kernel-infoleak in con_font_get()

Wachowski, Karol <karol.wachowski@intel.com>
    drm/shmem-helper: Fix BUG_ON() on mmap(PROT_WRITE, MAP_PRIVATE)

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    Revert "drm/mipi-dsi: Set the fwnode for mipi_dsi_device"

Jeongjun Park <aha310510@gmail.com>
    mm: shmem: fix data-race in shmem_getattr()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of checked flag

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Use code segment selector for VERW operand

Edward Adam Davis <eadavis@qq.com>
    ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove duplicated GET_RM

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove unused GENERATING_ASM_OFFSETS

WangYuli <wangyuli@uniontech.com>
    riscv: Use '%u' to format the output of 'cpu'

Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
    riscv: efi: Set NX compat flag in PE/COFF header

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: vdso: Prevent the compiler from inserting calls to memset()

Linus Torvalds <torvalds@linux-foundation.org>
    mm: avoid leaving partial pfn mappings around in error case

Christoph Hellwig <hch@lst.de>
    mm: add remap_pfn_range_notrack

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential deadlock with newly created symlinks

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: veml6030: fix microlux value calculation

Zicheng Qu <quzicheng@huawei.com>
    staging: iio: frequency: ad9832: fix division by zero in ad9832_calc_freqreg()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    wifi: iwlegacy: Clear stale interrupts before resuming device

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    wifi: ath10k: Fix memory leak in management tx

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "driver core: Fix uevent_show() vs driver detach race"

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    xhci: Use pm_runtime_get to prevent RPM on unsupported systems

Faisal Hassan <quic_faisalh@quicinc.com>
    xhci: Fix Link TRB DMA in command ring stopped completion event

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: phy: Fix API devm_usb_put_phy() can not release the phy

Zongmin Zhou <zhouzongmin@kylinos.cn>
    usbip: tools: Fix detach_port() invalid port error path

Dimitri Sivanich <sivanich@hpe.com>
    misc: sgi-gru: Don't disable preemption in GRU driver

Dai Ngo <dai.ngo@oracle.com>
    NFS: remove revoked delegation from server's delegation list

Daniel Palmer <daniel@0x0f.com>
    net: amd: mvme147: Fix probe banner message

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()

Marco Elver <elver@google.com>
    kasan: Fix Software Tag-Based KASAN with GCC

Miguel Ojeda <ojeda@kernel.org>
    compiler-gcc: remove attribute support check for `__no_sanitize_address__`

Miguel Ojeda <ojeda@kernel.org>
    compiler-gcc: be consistent with underscores use for `no_sanitize`

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: sanitize offset and length before calling skb_checksum()

Benoît Monin <benoit.monin@gmx.fr>
    net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension

Xin Long <lucien.xin@gmail.com>
    net: support ip generic csum processing in skb_csum_hwoffload_help

Byeonguk Jeong <jungbu2855@gmail.com>
    bpf: Fix out-of-bounds write in trie_get_next_key()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT

Pablo Neira Ayuso <pablo@netfilter.org>
    gtp: allow -1 to be specified as file description from userspace

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_flow()

Wander Lairson Costa <wander@redhat.com>
    igb: Disable threaded IRQ for igb_msix_other

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: disconnect station vifs if recovery failed

Youghandhar Chintala <youghand@codeaurora.org>
    mac80211: Add support to trigger sta disconnect on hardware restart

Johannes Berg <johannes.berg@intel.com>
    mac80211: do drv_reconfig_complete() before restarting all

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: synchronize the qp-handle table array

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Dump vendor specific QP details

Geert Uytterhoeven <geert@linux-m68k.org>
    wifi: brcm80211: BRCM_TRACING should depend on TRACING

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys

Geert Uytterhoeven <geert@linux-m68k.org>
    mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING

Xiu Jianfeng <xiujianfeng@huawei.com>
    cgroup: Fix potential overflow issue when checking max_depth

Donet Tom <donettom@linux.ibm.com>
    selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: validate new SA's prefixlen using SA family when sel.family is unset

junhua huang <huang.junhua@zte.com.cn>
    arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning

Zichen Xie <zichenxie0106@gmail.com>
    ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()

Michel Alex <Alex.Michel@wiedemann-group.com>
    net: phy: dp83822: Fix reset pin definitions

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: protect uart_port_dtr_rts() in uart_shutdown() too

Paul Moore <paul@paul-moore.com>
    selinux: improve error checking in sel_write_load()

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event

José Relvas <josemonsantorelvas@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Acer Predator G9-593

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory

Aleksa Sarai <cyphar@cyphar.com>
    openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of buffer delay flag

Shubham Panwar <shubiisp8@gmail.com>
    ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue

Christian Heusel <christian@heusel.eu>
    ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Guard against bad data for ATIF ACPI method

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update default depop procedure

Andrey Shumilin <shum.sdl@nppct.ru>
    ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()

Jinjie Ruan <ruanjinjie@huawei.com>
    posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: avoid unsolicited interrupts

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: fix use-after-free in taprio_change()

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix name regression

Wang Hai <wanghai38@huawei.com>
    be2net: fix potential memory leak in be_xmit()

Wang Hai <wanghai38@huawei.com>
    net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()

Eyal Birger <eyal.birger@gmail.com>
    xfrm: respect ip protocols rules criteria when performing dst lookups

Eyal Birger <eyal.birger@gmail.com>
    xfrm: extract dst lookup parameters into a struct

Leo Yan <leo.yan@arm.com>
    tracing: Consider the NULL character when validating the event length

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: Fix sanity check in dbMount

Mark Rutland <mark.rutland@arm.com>
    arm64: Force position-independent veneers

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Enable 'FIFO continue on error' FCONT bit

Hans de Goede <hdegoede@redhat.com>
    drm/vboxvideo: Replace fake VLA at end of vbva_mouse_pointer_shape with real VLA

Christoph Hellwig <hch@lst.de>
    iomap: update ki_pos a little later in iomap_dio_complete

Mateusz Guzik <mjguzik@gmail.com>
    exec: don't WARN for racy path_noexec check

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix procress reference leakage for bfqq in merge chain

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: gaccess: Check if guest address is in memslot

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: gaccess: Cleanup access to guest pages

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: gaccess: Refactor access address range check

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: gaccess: Refactor gpa and length calculation

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Fix uprobes for big-endian kernels

junhua huang <huang.junhua@zte.com.cn>
    arm64:uprobe fix the uprobe SWBP_INSN in big-endian

Ye Bin <yebin10@huawei.com>
    Bluetooth: bnep: fix wild-memory-access in proto_unregister

Heiko Carstens <hca@linux.ibm.com>
    s390: Initialize psw mask in perf_arch_fetch_caller_regs()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    usb: typec: altmode should keep reference to parent

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix OOBs when building SMB2_IOCTL request

Wang Hai <wanghai38@huawei.com>
    scsi: target: core: Fix null-ptr-deref in target_alloc_device()

Eric Dumazet <edumazet@google.com>
    genetlink: hold RCU in genlmsg_mcast()

Wang Hai <wanghai38@huawei.com>
    net: systemport: fix potential memory leak in bcm_sysport_xmit()

Li RongQing <lirongqing@baidu.com>
    net/smc: Fix searching in list of known pnetids in smc_pnet_add_pnetid

Wang Hai <wanghai38@huawei.com>
    net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()

Sabrina Dubroca <sd@queasysnail.net>
    macsec: don't increment counters for an unrelated SA

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation

Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
    RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Return more meaningful error

Xin Long <lucien.xin@gmail.com>
    ipv4: give an IPv4 dev to blackhole_netdev

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP

Florian Klink <flokli@flokli.de>
    ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Add a check for memory allocation

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Fix incorrect AVID type in WQE structure


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts       |   2 +-
 arch/arm64/Makefile                             |   2 +-
 arch/arm64/include/asm/uprobes.h                |  12 +-
 arch/arm64/kernel/probes/uprobes.c              |   4 +-
 arch/riscv/kernel/asm-offsets.c                 |   2 -
 arch/riscv/kernel/cpu-hotplug.c                 |   2 +-
 arch/riscv/kernel/efi-header.S                  |   2 +-
 arch/riscv/kernel/traps_misaligned.c            |   2 -
 arch/riscv/kernel/vdso/Makefile                 |   1 +
 arch/s390/include/asm/perf_event.h              |   1 +
 arch/s390/kvm/gaccess.c                         | 162 ++++++++++++++----------
 arch/s390/kvm/gaccess.h                         |  14 +-
 arch/x86/include/asm/nospec-branch.h            |  11 +-
 arch/x86/kvm/svm/nested.c                       |   6 +-
 block/bfq-iosched.c                             |  33 +++--
 drivers/acpi/button.c                           |  11 ++
 drivers/acpi/resource.c                         |   7 +
 drivers/base/core.c                             |  13 +-
 drivers/base/module.c                           |   4 -
 drivers/firmware/arm_sdei.c                     |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c        |  15 ++-
 drivers/gpu/drm/drm_gem_shmem_helper.c          |   5 +
 drivers/gpu/drm/drm_mipi_dsi.c                  |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c              |   2 +-
 drivers/gpu/drm/vboxvideo/hgsmi_base.c          |  10 +-
 drivers/gpu/drm/vboxvideo/vboxvideo.h           |   4 +-
 drivers/iio/light/veml6030.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c        |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.h        |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c      |  15 ++-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h      |   2 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c       |  21 +--
 drivers/infiniband/hw/cxgb4/cm.c                |   9 +-
 drivers/infiniband/hw/cxgb4/provider.c          |   1 +
 drivers/infiniband/hw/mlx5/qp.c                 |   4 +-
 drivers/misc/sgi-gru/grukservices.c             |   2 -
 drivers/misc/sgi-gru/grumain.c                  |   4 -
 drivers/misc/sgi-gru/grutlbpurge.c              |   2 -
 drivers/net/ethernet/aeroflex/greth.c           |   3 +-
 drivers/net/ethernet/amd/mvme147.c              |   7 +-
 drivers/net/ethernet/broadcom/bcmsysport.c      |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c     |  10 +-
 drivers/net/ethernet/i825xx/sun3_82586.c        |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c       |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c       |   4 +-
 drivers/net/gtp.c                               |  22 ++--
 drivers/net/hyperv/netvsc_drv.c                 |  30 +++++
 drivers/net/macsec.c                            |  18 ---
 drivers/net/phy/dp83822.c                       |   4 +-
 drivers/net/usb/usbnet.c                        |   3 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c       |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c           |   2 +
 drivers/net/wireless/broadcom/brcm80211/Kconfig |   1 +
 drivers/net/wireless/intel/iwlegacy/common.c    |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     |  22 +++-
 drivers/staging/iio/frequency/ad9832.c          |   7 +-
 drivers/target/target_core_device.c             |   2 +-
 drivers/target/target_core_user.c               |   2 +-
 drivers/tty/serial/serial_core.c                |  16 ++-
 drivers/tty/vt/vt.c                             |   2 +-
 drivers/usb/host/xhci-pci.c                     |   6 +-
 drivers/usb/host/xhci-ring.c                    |  16 +--
 drivers/usb/phy/phy.c                           |   2 +-
 drivers/usb/typec/class.c                       |   3 +
 fs/cifs/smb2pdu.c                               |   9 ++
 fs/exec.c                                       |  21 ++-
 fs/iomap/direct-io.c                            |  18 +--
 fs/jfs/jfs_dmap.c                               |   2 +-
 fs/nfs/delegation.c                             |   5 +
 fs/nilfs2/namei.c                               |   3 +
 fs/nilfs2/page.c                                |   7 +-
 fs/ocfs2/file.c                                 |   8 ++
 fs/open.c                                       |   2 +
 include/linux/compiler-gcc.h                    |  12 +-
 include/linux/mm.h                              |   2 +
 include/net/genetlink.h                         |   3 +-
 include/net/ip_tunnels.h                        |   2 +-
 include/net/mac80211.h                          |  10 ++
 include/net/xfrm.h                              |  28 ++--
 kernel/bpf/lpm_trie.c                           |   2 +-
 kernel/cgroup/cgroup.c                          |   4 +-
 kernel/time/posix-clock.c                       |   6 +-
 kernel/trace/trace_probe.c                      |   2 +-
 mm/memory.c                                     |  72 +++++++----
 mm/shmem.c                                      |   2 +
 net/bluetooth/bnep/core.c                       |   3 +-
 net/core/dev.c                                  |  17 ++-
 net/ipv4/devinet.c                              |  35 +++--
 net/ipv4/xfrm4_policy.c                         |  38 +++---
 net/ipv6/xfrm6_policy.c                         |  31 ++---
 net/l2tp/l2tp_netlink.c                         |   4 +-
 net/mac80211/Kconfig                            |   2 +-
 net/mac80211/cfg.c                              |   3 +-
 net/mac80211/ieee80211_i.h                      |   3 +
 net/mac80211/key.c                              |  42 +++---
 net/mac80211/mlme.c                             |  14 +-
 net/mac80211/util.c                             |  45 +++++--
 net/netfilter/nft_payload.c                     |   3 +
 net/netlink/genetlink.c                         |  28 ++--
 net/sched/sch_api.c                             |   2 +-
 net/sched/sch_taprio.c                          |   3 +-
 net/smc/smc_pnet.c                              |   2 +-
 net/wireless/nl80211.c                          |   8 +-
 net/xfrm/xfrm_device.c                          |  11 +-
 net/xfrm/xfrm_policy.c                          |  50 ++++++--
 net/xfrm/xfrm_user.c                            |   6 +-
 security/selinux/selinuxfs.c                    |  27 ++--
 sound/firewire/amdtp-stream.c                   |   3 +
 sound/pci/hda/patch_realtek.c                   |  48 ++++---
 sound/soc/codecs/cs42l51.c                      |   7 +-
 sound/soc/fsl/fsl_sai.c                         |   5 +-
 sound/soc/fsl/fsl_sai.h                         |   1 +
 sound/soc/qcom/lpass-cpu.c                      |   2 +
 tools/testing/selftests/vm/hmm-tests.c          |   2 +-
 tools/usb/usbip/src/usbip_detach.c              |   1 +
 116 files changed, 791 insertions(+), 473 deletions(-)


