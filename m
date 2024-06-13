Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4BF144317;
	Thu, 13 Jun 2024 12:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282884; cv=none; b=csap6SsCW2KB3hGPFO2jxybLRg+sjLnR3l3gvewN5FbQJwS0w9B53TeM9wZzlUBstzndPiC6zyg5M5+7gyi7lN56n+nAQeTrHd6a0AvX/5R6mrvlmtxeYho6cW/tkzC3tYHVAhpRVwMl/ar+qQOINYV3ARoCNmetIxeOkM2M9UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282884; c=relaxed/simple;
	bh=Mm9Cqd976+Fc+yB2QKh/47/E/7DI3LXSARw6HJWIqQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rrl06n4GsZVYqvOE8Fqim4Gpc9HovYt9HcbuJBZlndKIaiQDENn9LmdmG/pXeiwZK5hUk7mRtFAhUjqmLlt6em/KVzLQRYAX1SJFUD6tezRZBDyAcl8Pv+LwEFqa+ufmZo/0M5PUx+m3odpyXrnlOHwfeYovybDRhgrVl37B/c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfFFB0y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfFFB0y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91D0C2BBFC;
	Thu, 13 Jun 2024 12:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282884;
	bh=Mm9Cqd976+Fc+yB2QKh/47/E/7DI3LXSARw6HJWIqQE=;
	h=From:To:Cc:Subject:Date:From;
	b=EfFFB0y/y2PdP9ldjdhVUTTha6jlAWwKfNkFnOKFzrZrHQd7KvFdsrW0/v15nHKtn
	 +Q97DKELE1a8NfGjWbBfaeUuOGH8ny3JIMfX75xwoIgq3pN3ioDyDNcWWrGH2FMrUr
	 ThEKRNqFH/NezhGJ1J1xwKSnDM7lRxeLLHbJO4L4=
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
Subject: [PATCH 6.1 00/85] 6.1.94-rc1 review
Date: Thu, 13 Jun 2024 13:34:58 +0200
Message-ID: <20240613113214.134806994@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.94-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.94-rc1
X-KernelTest-Deadline: 2024-06-15T11:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.94 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.94-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.94-rc1

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix deadlock in smb2_find_smb_tcon()

Puranjay Mohan <puranjay@kernel.org>
    powerpc/bpf: enforce full ordering for ATOMIC operations with BPF_FETCH

Omar Sandoval <osandov@fb.com>
    btrfs: fix crash on racing fsync and size-extending write into prealloc

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Fix READ_PLUS when server doesn't support OP_READ_PLUS

Sergey Shtylyov <s.shtylyov@omp.ru>
    nfs: fix undefined behavior in nfs_block_bits()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    EDAC/igen6: Convert PCIBIOS_* return codes to errnos

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: fix invalidate IBI type and miss call client IBI handler

Harald Freudenberger <freude@linux.ibm.com>
    s390/cpacf: Make use of invalid opcode produce a link error

Harald Freudenberger <freude@linux.ibm.com>
    s390/cpacf: Split and rework cpacf query functions

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix crash in AP internal function modify_bitmap()

Helge Deller <deller@kernel.org>
    parisc: Define sigset_t in parisc uapi header

Helge Deller <deller@gmx.de>
    parisc: Define HAVE_ARCH_HUGETLB_UNMAPPED_AREA

Baokun Li <libaokun1@huawei.com>
    ext4: fix mb_cache_entry's e_refcnt leak in ext4_xattr_block_cache_find()

Baokun Li <libaokun1@huawei.com>
    ext4: set type of ac_groups_linear_remaining to __u32 to avoid overflow

Mike Gilbert <floppym@gentoo.org>
    sparc: move struct termio to asm/termios.h

Eric Dumazet <edumazet@google.com>
    net: fix __dst_negative_advice() race

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-specifiers rather than memset() for padding in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Merge identical case statements in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix console handling when editing and tab-completing commands

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-strings rather than '\0' injection in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix buffer overflow during tab-complete

Judith Mendez <jm@ti.com>
    watchdog: rti_wdt: Set min_hw_heartbeat_ms to accommodate a safety margin

Frank van der Linden <fvdl@google.com>
    mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid

Frank van der Linden <fvdl@google.com>
    mm/cma: drop incorrect alignment check in cma_init_reserved_mem

Sam Ravnborg <sam@ravnborg.org>
    sparc64: Fix number of online CPUs

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-S CPU support

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq: amd-pstate: Fix the inconsistency in max frequency units

Alexander Potapenko <glider@google.com>
    kmsan: do not wipe out origin when doing partial unpoisoning

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net/9p: fix uninit-value in p9_client_rpc()

xu xin <xu.xin16@zte.com.cn>
    net/ipv6: Fix route deleting failure when metric equals 0

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: core: Handle devices which return an unusually large VPD page count

Ryan Roberts <ryan.roberts@arm.com>
    mm: fix race between __split_huge_pmd_locked() and GUP-fast

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecrdsa - Fix module auto-load on add_key

Stefan Berger <stefanb@linux.ibm.com>
    crypto: ecdsa - Fix module auto-load on add-key

Marc Zyngier <maz@kernel.org>
    KVM: arm64: AArch32: Fix spurious trapping of conditional instructions

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix AArch32 register narrowing on userspace write

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix shutdown (again) on some SMU v13.0.4/11 platforms

Dominique Martinet <asmadeus@codewreck.org>
    9p: add missing locking around taking dentry fid list

Li Ma <li.ma@amd.com>
    drm/amdgpu/atomfirmware: add intergrated info v2.3 table

Cai Xinchen <caixinchen1@huawei.com>
    fbdev: savage: Handle err return when savagefb_check_var failed

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Add quirk to enable pull-up on the card-detect GPIO on Asus T100TA

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Disable write protect detection on Toshiba WT10-A

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Fix Lenovo Yoga Tablet 2 Pro 1380 sdcard slot not working

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Sort DMI quirks alphabetically

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Add support for "Tuning Error" interrupts

Hans de Goede <hdegoede@redhat.com>
    mmc: core: Add mmc_gpiod_set_cd_config() function

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-core: hold videodev_lock until dev reg, finishes

Nathan Chancellor <nathan@kernel.org>
    media: mxl5xx: Move xpt structures off stack

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: mc: mark the media devnode as registered from the, start

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: mc: Fix graph walk in media_pipeline_start

Yang Xiwen <forbidden405@outlook.com>
    arm64: dts: hi3798cv200: fix the size of GICR

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix endianness issue in RX path

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix low speed with WPA3-SAE

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix the TX power of RTL8192CU, RTL8723AU

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: correct TX resource checking for PCI DMA channel of firmware command

Yu Kuai <yukuai3@huawei.com>
    md/raid5: fix deadlock that raid5d() wait for itself to clear MD_SB_CHANGE_PENDING

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: qcs404: fix bluetooth device address

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: tegra: Correct Tegra132 I2C alias

Christoffer Sandberg <cs@tuxedo.de>
    ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx

Maulik Shah <quic_mkshah@quicinc.com>
    soc: qcom: rpmh-rsc: Enhance check for VRM in-flight request

Konrad Dybcio <konrad.dybcio@linaro.org>
    thermal/drivers/qcom/lmh: Check for SCM availability at probe

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_legacy: make legacy_exit() work again

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: correct aSIFSTime for 6GHz band

Matthew Mirvish <matthew@mm12.xyz>
    bcache: fix variable length array abuse in btree_iter

Bob Zhou <bob.zhou@amd.com>
    drm/amdgpu: add error handle to avoid out-of-bounds

Zheyu Ma <zheyuma97@gmail.com>
    media: lgdt3306a: Add a check against null-pointer-def

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on i_xattr_nid in sanity_check_inode()

Florian Fainelli <florian.fainelli@broadcom.com>
    scripts/gdb: fix SB_* constants parsing

Daniel Borkmann <daniel@iogearbox.net>
    vxlan: Fix regression when dropping packets due to invalid src addresses

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fix full TCP keep-alive support

Paolo Abeni <pabeni@redhat.com>
    mptcp: cleanup SOL_TCP handling

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid some duplicate code in socket option handling

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/i915/audio: Fix audio time stamp programming for DP

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free of timer for log writer thread

Haorong Lu <ancientmodern4@gmail.com>
    riscv: signal: handle syscall restart before get_signal

Marc Dionne <marc.dionne@auristor.com>
    afs: Don't cross .backup mountpoint from backup volume

Jorge Ramirez-Ortiz <jorge@foundries.io>
    mmc: core: Do not force a retune before RPMB switch

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix mas_empty_area_rev() null pointer dereference

Peng Zhang <zhangpeng.00@bytedance.com>
    maple_tree: fix allocation in mas_sparse_area()

Dan Gora <dan.gora@gmail.com>
    Bluetooth: btrtl: Add missing MODULE_FIRMWARE declarations

Shradha Gupta <shradhagupta@linux.microsoft.com>
    drm: Check polling initialized before enabling in drm_helper_probe_single_connector_modes

Shradha Gupta <shradhagupta@linux.microsoft.com>
    drm: Check output polling initialized before disabling


-------------

Diffstat:

 Documentation/mm/arch_pgtable_helpers.rst          |   6 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   2 +-
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts     |   4 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi           |   2 +-
 arch/arm64/kvm/guest.c                             |   3 +-
 arch/arm64/kvm/hyp/aarch32.c                       |  18 ++-
 arch/parisc/include/asm/page.h                     |   1 +
 arch/parisc/include/asm/signal.h                   |  12 --
 arch/parisc/include/uapi/asm/signal.h              |  10 ++
 arch/powerpc/mm/book3s64/pgtable.c                 |   1 +
 arch/powerpc/net/bpf_jit_comp32.c                  |  12 ++
 arch/powerpc/net/bpf_jit_comp64.c                  |  12 ++
 arch/riscv/kernel/signal.c                         |  95 +++++++-------
 arch/s390/include/asm/cpacf.h                      | 109 +++++++++++++---
 arch/s390/include/asm/pgtable.h                    |   4 +-
 arch/sparc/include/asm/smp_64.h                    |   2 -
 arch/sparc/include/uapi/asm/termbits.h             |  10 --
 arch/sparc/include/uapi/asm/termios.h              |   9 ++
 arch/sparc/kernel/prom_64.c                        |   4 +-
 arch/sparc/kernel/setup_64.c                       |   1 -
 arch/sparc/kernel/smp_64.c                         |  14 --
 arch/sparc/mm/tlb.c                                |   1 +
 arch/x86/mm/pgtable.c                              |   2 +
 crypto/ecdsa.c                                     |   3 +
 crypto/ecrdsa.c                                    |   1 +
 drivers/acpi/resource.c                            |  12 ++
 drivers/ata/pata_legacy.c                          |   8 +-
 drivers/bluetooth/btrtl.c                          |  18 ++-
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |  19 +--
 drivers/edac/igen6_edac.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |  15 +++
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   3 +
 drivers/gpu/drm/amd/include/atomfirmware.h         |  43 ++++++
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c   |  20 +--
 drivers/gpu/drm/drm_modeset_helper.c               |  19 ++-
 drivers/gpu/drm/drm_probe_helper.c                 |  15 ++-
 drivers/gpu/drm/i915/display/intel_audio.c         | 116 ++---------------
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/i3c/master/svc-i3c-master.c                |  16 ++-
 drivers/md/bcache/bset.c                           |  44 +++----
 drivers/md/bcache/bset.h                           |  28 ++--
 drivers/md/bcache/btree.c                          |  40 +++---
 drivers/md/bcache/super.c                          |   5 +-
 drivers/md/bcache/sysfs.c                          |   2 +-
 drivers/md/bcache/writeback.c                      |  10 +-
 drivers/md/raid5.c                                 |  15 +--
 drivers/media/dvb-frontends/lgdt3306a.c            |   5 +
 drivers/media/dvb-frontends/mxl5xx.c               |  22 ++--
 drivers/media/mc/mc-devnode.c                      |   5 +-
 drivers/media/mc/mc-entity.c                       |   6 +
 drivers/media/v4l2-core/v4l2-dev.c                 |   3 +
 drivers/mmc/core/host.c                            |   3 +-
 drivers/mmc/core/slot-gpio.c                       |  20 +++
 drivers/mmc/host/sdhci-acpi.c                      |  61 ++++++++-
 drivers/mmc/host/sdhci.c                           |  10 +-
 drivers/mmc/host/sdhci.h                           |   3 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  25 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  21 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |  79 +++--------
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   3 +-
 drivers/s390/crypto/ap_bus.c                       |   2 +-
 drivers/scsi/scsi.c                                |   7 +
 drivers/soc/qcom/cmd-db.c                          |  32 ++++-
 drivers/soc/qcom/rpmh-rsc.c                        |   3 +-
 drivers/thermal/qcom/lmh.c                         |   3 +
 drivers/video/fbdev/savage/savagefb_driver.c       |   5 +-
 drivers/watchdog/rti_wdt.c                         |  34 +++--
 fs/9p/vfs_dentry.c                                 |   9 +-
 fs/afs/mntpt.c                                     |   5 +
 fs/btrfs/tree-log.c                                |  17 ++-
 fs/ext4/mballoc.h                                  |   2 +-
 fs/ext4/xattr.c                                    |   4 +-
 fs/f2fs/inode.c                                    |   6 +
 fs/nfs/internal.h                                  |   4 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nilfs2/segment.c                                |  25 +++-
 fs/smb/client/smb2transport.c                      |   2 +-
 include/linux/mmc/slot-gpio.h                      |   1 +
 include/net/dst_ops.h                              |   2 +-
 include/net/sock.h                                 |  13 +-
 include/soc/qcom/cmd-db.h                          |  10 +-
 kernel/debug/kdb/kdb_io.c                          |  99 ++++++++------
 lib/maple_tree.c                                   |  55 ++++----
 mm/cma.c                                           |   4 -
 mm/huge_memory.c                                   |  49 +++----
 mm/hugetlb.c                                       |   6 +-
 mm/kmsan/core.c                                    |  15 ++-
 mm/pgtable-generic.c                               |   2 +
 net/9p/client.c                                    |   2 +
 net/ipv4/route.c                                   |  22 ++--
 net/ipv6/route.c                                   |  34 ++---
 net/mptcp/protocol.h                               |   3 +
 net/mptcp/sockopt.c                                | 144 +++++++++++++++------
 net/xfrm/xfrm_policy.c                             |  11 +-
 scripts/gdb/linux/constants.py.in                  |  12 +-
 101 files changed, 1030 insertions(+), 695 deletions(-)


