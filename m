Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE43285C92;
	Mon, 22 Sep 2025 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569832; cv=none; b=czih0xqFqRsrgl9/TbdYiQFGBE12DbJo4zEowrLwDkJX9acPbgntHyh4OsljPf07Hzwp7rewK1i0kGLAslJRhX3k/aLQjiVpQC2PZB5QXKhhmJxuNjsmp+bfKADh2or9dfGE/QD7Z487oxTs6wG3dTLcBnhjdboHqadCaGlvo98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569832; c=relaxed/simple;
	bh=fZrp36/wy4kdwdHfLWNdIWjaAIiZ4HG8bwWPNPyAnUs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LaQ+4Rbr+zaFUneyNrJJcT3zsloSFVJqshbINhZuVmPf1Z84RbNRTCfypt89xqryj35Y84elh6bfd+RdBSw8f662PLWs6Ef184bHQgYZN9jphk+uGmJN1EEndqTkbhpXLEsKchz12tRsQJp0wOe0t5BwWKzJL3PPMfYZWF5ex/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs1aagzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs1aagzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966E3C4CEF0;
	Mon, 22 Sep 2025 19:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569832;
	bh=fZrp36/wy4kdwdHfLWNdIWjaAIiZ4HG8bwWPNPyAnUs=;
	h=From:To:Cc:Subject:Date:From;
	b=rs1aagzTs5DZnMPceyp/CO6L2Vy56Ni7svC3HwhNBddLaNDlYRrNBNBqcDbfcVaby
	 AHG0dtMP2BATKxMG7bp+usO/iaVY0EvBAEMh1jtBDUzAe0qdM249sEZYKexAEqaJlG
	 1ub2j74qj9b7bPz8Cd3V3AWNajaYn7TTmp0QYnvk=
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
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.12 000/105] 6.12.49-rc1 review
Date: Mon, 22 Sep 2025 21:28:43 +0200
Message-ID: <20250922192408.913556629@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.49-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.49-rc1
X-KernelTest-Deadline: 2025-09-24T19:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.49 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.49-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.49-rc1

David Laight <David.Laight@ACULAB.COM>
    minmax.h: remove some #defines that are only expanded once

David Laight <David.Laight@ACULAB.COM>
    minmax.h: simplify the variants of clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: move all the clamp() definitions after the min/max() ones

David Laight <David.Laight@ACULAB.COM>
    minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: reduce the #define expansion of min(), max() and clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: update some comments

David Laight <David.Laight@ACULAB.COM>
    minmax.h: add whitespace around operators and after commas

Bruno Thomsen <bruno.thomsen@gmail.com>
    rtc: pcf2127: fix SPI command byte for PCF2131 backport

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix full DbC transfer ring after several reconnects

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: decouple endpoint allocation from initialization

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: remove option to change a default ring's TRB cycle bit

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: introduce macro for ring segment list iteration

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: nl: announce deny-join-id0 flag

Hugh Dickins <hughd@google.com>
    mm/gup: check ref_count instead of lru before migration

Shivank Garg <shivankg@amd.com>
    mm: add folio_expected_ref_count() for reference count calculation

Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
    vmxnet3: unregister xdp rxq info in the reset path

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count transitions

Borislav Petkov <bp@alien8.de>
    x86/bugs: KVM: Add support for SRSO_MSR_FIX

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Add SRSO_USER_KERNEL_NO support

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: asus-wmi: Re-add extra keys to ignore_key_wlan quirk

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: asus-wmi: Fix ROG button mapping, tablet mode on ASUS ROG Z13

Yang Xiuwei <yangxiuwei@kylinos.cn>
    io_uring: fix incorrect io_kiocb reference in io_link_skb

Stefan Metzmacher <metze@samba.org>
    smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Set merge to zero early in af_alg_sendmsg

Stefan Metzmacher <metze@samba.org>
    smb: client: let smbd_destroy() call disable_work_sync(&info->post_send_credits_work)

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix filename matching of deferred files

Dan Carpenter <dan.carpenter@linaro.org>
    drm/xe: Fix a NULL vs IS_ERR() in xe_vm_add_compute_exec_queue()

Qi Xi <xiqi2@huawei.com>
    drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path

Loic Poulain <loic.poulain@oss.qualcomm.com>
    drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/tile: Release kobject for the failure path

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: catpt: Expose correct bit depth to userspace

Colin Ian King <colin.i.king@gmail.com>
    ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8974: Correct PLL rate rounding

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct typo in control name

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct PLL rate rounding

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: drop WARN_ON_ONCE() from incremental length check

Jens Axboe <axboe@kernel.dk>
    io_uring/msg_ring: kill alloc_cache for io_kiocb allocations

Jens Axboe <axboe@kernel.dk>
    io_uring: include dying ring in task_work "should cancel" state

Jens Axboe <axboe@kernel.dk>
    io_uring: backport io_should_terminate_tw()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/cmd: let cmds to know about dying task

Praful Adiga <praful.adiga@gmail.com>
    ALSA: hda/realtek: Fix mute led for HP Laptop 15-dw4xx

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: avoid spurious errors on TCP disconnect

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: catch IO errors on listen side

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: propagate shutdown to subflows when possible

Håkon Bugge <haakon.bugge@oracle.com>
    rds: ib: Increment i_fastreg_wrs before bailing out

Hans de Goede <hansg@kernel.org>
    net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Allow RX6xxx & RX7700 to invoke amdgpu_irq_get/put

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active

Thomas Fourier <fourier.thomas@gmail.com>
    mmc: mvsdio: Fix dma_unmap_sg() nents value

Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>
    ASoC: qcom: q6apm-lpass-dais: Fix missing set_fmt DAI op for I2S

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: q6apm-lpass-dais: Fix NULL pointer dereference if source graph failed

Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>
    ASoC: qcom: audioreach: Fix lpaif_type configuration for the I2S interface

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix the incorrect inode ref size check

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd/pgtbl: Fix possible race while increase page table level

Eugene Koira <eugkoira@amazon.com>
    iommu/vt-d: Fix __domain_mapping()'s usage of switch_to_super_page()

Tao Cui <cuitao@kylinos.cn>
    LoongArch: Check the return value when creating kobj

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Align ACPI structures if ARCH_STRICT_ALIGN enabled

Guangshuo Li <202321181@mail.sdu.edu.cn>
    LoongArch: vDSO: Check kcalloc() result in init_vdso()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix unreliable stack for live patching

Tiezhu Yang <yangtiezhu@loongson.cn>
    objtool/LoongArch: Mark special atomic instruction as INSN_BUG type

Tiezhu Yang <yangtiezhu@loongson.cn>
    objtool/LoongArch: Mark types based on break immediate code

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Update help info of ARCH_STRICT_ALIGN

Hugh Dickins <hughd@google.com>
    mm: revert "mm: vmscan.c: fix OOM on swap stress test"

Li Zhe <lizhe.67@bytedance.com>
    gup: optimize longterm pin_user_pages() for large folio

Mikulas Patocka <mpatocka@redhat.com>
    dm-stripe: fix a possible integer overflow

Mikulas Patocka <mpatocka@redhat.com>
    dm-raid: don't set io_min and io_opt for raid1

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: restrict no-battery detection to bq27000

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: fix error return in case of no bq27000 hdq battery

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg

Nathan Chancellor <nathan@kernel.org>
    nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*

Stefan Metzmacher <metze@samba.org>
    ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: smbdirect: validate data_offset and data_length field of smb_direct_data_transfer

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix crash in icl_update_topdown_event()

Duoming Zhou <duoming@zju.edu.cn>
    octeontx2-pf: Fix use-after-free bugs in otx2_sync_tstamp()

Duoming Zhou <duoming@zju.edu.cn>
    cnic: Fix use-after-free bugs in cnic_delete_task

Alexey Nepomnyashih <sdl@nppct.ru>
    net: liquidio: fix overflow in octeon_init_instr_queue()

Tariq Toukan <tariqt@nvidia.com>
    Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"

Jakub Kicinski <kuba@kernel.org>
    tls: make sure to abort the stream if headers are bogus

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Clear tcp_sk(sk)->fastopen_rsk in tcp_disconnect().

Sathesh B Edara <sedara@marvell.com>
    octeon_ep: fix VF MAC address lifecycle handling

Hangbin Liu <liuhangbin@gmail.com>
    bonding: don't set oif to bond dev when getting NS target destination

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Harden uplink netdev access against device unbind

Kohei Enju <enjuk@amazon.com>
    igc: don't fail igc_probe() on LED setup error

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    i40e: remove redundant memory barrier when cleaning Tx descs

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix Rx page leak on multi-buffer frames

Jacob Keller <jacob.e.keller@intel.com>
    ice: store max_frame and rx_buf_len only in ice_rx_ring

Yeounsu Moon <yyyynoom@gmail.com>
    net: natsemi: fix `rx_dropped` double accounting on `netif_rx()` failure

Geliang Tang <geliang@kernel.org>
    selftests: mptcp: sockopt: fix error messages

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: tfo: record 'deny join id0' info

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: userspace pm: validate deny-join-id0 flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: set remote_deny_join_id0 on SYN recv

Hangbin Liu <liuhangbin@gmail.com>
    bonding: set random address only when slaves already exist

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    qed: Don't collect too many protection override GRC elements

Anderson Nascimento <anderson@allelesecurity.com>
    net/tcp: Fix a NULL pointer dereference when using TCP-AO with TCP_REPAIR

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix buffer pool seeding for control traffic

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix FD copy size in os_rcv_fd_msg()

Miaoqian Lin <linmq006@gmail.com>
    um: virtio_uml: Fix use-after-free after put_device in probe

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid extref key setup when replaying dentry

Chen Ridong <chenridong@huawei.com>
    cgroup: split cgroup_destroy_wq into 3 workqueues

Geert Uytterhoeven <geert+renesas@glider.be>
    pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch

Liao Yuanhong <liaoyuanhong@vivo.com>
    wifi: mac80211: fix incorrect type for ret

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: increase scan_ies_len for S1G

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported

Christoph Hellwig <hch@lst.de>
    nvme: fix PI insert on write

Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>
    wifi: wilc1000: avoid buffer overflow in WID string configuration


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/srso.rst         |  13 ++
 Documentation/netlink/specs/mptcp_pm.yaml          |   4 +-
 Makefile                                           |   4 +-
 arch/loongarch/Kconfig                             |   8 +-
 arch/loongarch/include/asm/acenv.h                 |   7 +-
 arch/loongarch/kernel/env.c                        |   2 +
 arch/loongarch/kernel/stacktrace.c                 |   3 +-
 arch/loongarch/kernel/vdso.c                       |   3 +
 arch/um/drivers/virtio_uml.c                       |   6 +-
 arch/um/os-Linux/file.c                            |   2 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/cpufeatures.h                 |   5 +
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kernel/cpu/bugs.c                         |  28 ++-
 arch/x86/kvm/svm/svm.c                             |  68 ++++++-
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/lib/msr.c                                 |   2 +
 crypto/af_alg.c                                    |  10 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  39 +++-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   6 +-
 drivers/gpu/drm/xe/xe_tile_sysfs.c                 |  12 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   4 +-
 drivers/iommu/amd/amd_iommu_types.h                |   1 +
 drivers/iommu/amd/io_pgtable.c                     |  25 ++-
 drivers/iommu/intel/iommu.c                        |   7 +-
 drivers/md/dm-raid.c                               |   6 +-
 drivers/md/dm-stripe.c                             |  10 +-
 drivers/mmc/host/mvsdio.c                          |   2 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/ethernet/broadcom/cnic.c               |   3 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 -
 drivers/net/ethernet/intel/ice/ice.h               |   3 -
 drivers/net/ethernet/intel/ice/ice_base.c          |  34 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  80 ++++----
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   7 +-
 drivers/net/ethernet/intel/igc/igc.h               |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  12 +-
 .../ethernet/marvell/octeon_ep/octep_pfvf_mbox.c   |   3 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  27 ++-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  15 +-
 drivers/net/ethernet/natsemi/ns83820.c             |  13 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   7 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  10 +-
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c |  39 ++--
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.h |   5 +-
 drivers/nvme/host/core.c                           |  18 +-
 drivers/pcmcia/omap_cf.c                           |   8 +-
 drivers/platform/x86/asus-nb-wmi.c                 |  25 ++-
 drivers/platform/x86/asus-wmi.h                    |   3 +-
 drivers/power/supply/bq27xxx_battery.c             |   4 +-
 drivers/rtc/rtc-pcf2127.c                          |  10 +-
 drivers/usb/host/xhci-dbgcap.c                     |  94 ++++++---
 drivers/usb/host/xhci-debugfs.c                    |   5 +-
 drivers/usb/host/xhci-mem.c                        |  74 +++----
 drivers/usb/host/xhci.c                            |  22 +--
 drivers/usb/host/xhci.h                            |   9 +-
 fs/btrfs/tree-checker.c                            |   4 +-
 fs/btrfs/tree-log.c                                |   2 +-
 fs/nilfs2/sysfs.c                                  |   4 +-
 fs/nilfs2/sysfs.h                                  |   8 +-
 fs/smb/client/cifsproto.h                          |   4 +-
 fs/smb/client/inode.c                              |   6 +-
 fs/smb/client/misc.c                               |  36 ++--
 fs/smb/client/smbdirect.c                          |   7 +-
 fs/smb/server/transport_rdma.c                     |  26 ++-
 include/crypto/if_alg.h                            |  10 +-
 include/linux/io_uring_types.h                     |   4 +-
 include/linux/minmax.h                             | 219 ++++++++++-----------
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |  55 ++++++
 include/uapi/linux/mptcp.h                         |   2 +
 include/uapi/linux/mptcp_pm.h                      |   4 +-
 io_uring/io_uring.c                                |  12 +-
 io_uring/io_uring.h                                |  13 ++
 io_uring/kbuf.h                                    |   2 +-
 io_uring/msg_ring.c                                |  24 +--
 io_uring/notif.c                                   |   2 +-
 io_uring/poll.c                                    |   3 +-
 io_uring/timeout.c                                 |   2 +-
 io_uring/uring_cmd.c                               |   6 +-
 kernel/cgroup/cgroup.c                             |  43 +++-
 mm/gup.c                                           |  41 +++-
 mm/migrate.c                                       |  22 +--
 mm/vmscan.c                                        |   2 +-
 net/ipv4/tcp.c                                     |   5 +
 net/ipv4/tcp_ao.c                                  |   4 +-
 net/mac80211/driver-ops.h                          |   2 +-
 net/mac80211/main.c                                |   7 +-
 net/mptcp/options.c                                |   6 +-
 net/mptcp/pm_netlink.c                             |   7 +
 net/mptcp/protocol.c                               |  16 ++
 net/mptcp/subflow.c                                |   4 +
 net/rds/ib_frmr.c                                  |  20 +-
 net/rfkill/rfkill-gpio.c                           |   4 +-
 net/tls/tls.h                                      |   1 +
 net/tls/tls_strp.c                                 |  14 +-
 net/tls/tls_sw.c                                   |   3 +-
 sound/firewire/motu/motu-hwdep.c                   |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/wm8940.c                          |   9 +-
 sound/soc/codecs/wm8974.c                          |   8 +-
 sound/soc/intel/catpt/pcm.c                        |  23 ++-
 sound/soc/qcom/qdsp6/audioreach.c                  |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |   7 +-
 sound/soc/sof/intel/hda-stream.c                   |   2 +-
 tools/arch/loongarch/include/asm/inst.h            |  12 ++
 tools/objtool/arch/loongarch/decode.c              |  33 +++-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  11 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |  16 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   7 +
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  14 +-
 118 files changed, 1069 insertions(+), 571 deletions(-)


