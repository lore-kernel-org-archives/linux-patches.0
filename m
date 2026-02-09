Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A3936828A;
	Mon,  9 Feb 2026 14:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648220; cv=none; b=GbcKvfFGA7bCnuhsVeuJxk2zoRq5eEyWrZIt84KxzGVuYWA/ixIA3St3bA/VUghzMo5BnhWxZgnibuar+0raLYzTHn5qWFbS3hHsyw6BbR3dm+lUabo3wQcc2MSUIaC7VxyRxbSpZrc/6KbH7qs9iZwvNwLaRxysufRlNu7JU1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648220; c=relaxed/simple;
	bh=+wlE6FeN0dq1Hq2AzHvz/ZqJJsIEaAWAWq8ATOMA5E8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JxRYaJa2zZVN5cwx/gplb/kT1gtrnxURavAD6QucP8rGTbhfjlC5+yb95dDArwTAz18XhaFTam72jmoVwEs1P8aUJMCDZOlwOR/HbMGorOQ7HEs6vPlgxZMvyf/WlXgImP1F6frBKV6yZ7H2R74mSaeYjIIF+RfgsAgGlnj2CrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJCmfVeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJCmfVeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C42AC116C6;
	Mon,  9 Feb 2026 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648220;
	bh=+wlE6FeN0dq1Hq2AzHvz/ZqJJsIEaAWAWq8ATOMA5E8=;
	h=From:To:Cc:Subject:Date:From;
	b=JJCmfVeEsJxQykYcTvRr6fYG1iFjJvZqsHo24l4o/ymEgp0X82Fp9+sWz96Cqvnul
	 14Zr3C3mqMBdSqfxhDnEvb1UQsPLwgRT7i2Av0aFvL1CvNq8Oa2gg93eshAHcIBeFa
	 t8MmEtPRTqbYzg0aNysEEbrsv2cD0WpYFm9rmbC4=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.1 00/69] 6.1.163-rc1 review
Date: Mon,  9 Feb 2026 15:23:28 +0100
Message-ID: <20260209142301.913348974@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.163-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.163-rc1
X-KernelTest-Deadline: 2026-02-11T14:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.163 release.
There are 69 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.163-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.163-rc1

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Really fix headset mic for TongFang X6AR55xU.

Felix Gu <ustc.gu@gmail.com>
    spi: tegra: Fix a memory leak in tegra_slink_probe()

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer clearing in tegra_qspi_non_combined_seq_xfer

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer in tegra_qspi_combined_seq_xfer

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer assignment in tegra_qspi_setup_transfer_one

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Move curr_xfer read inside spinlock

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Return IRQ_HANDLED when timeout already processed transfer

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: disable SVA when CONFIG_X86 is set

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Kang Chen <k.chen@smail.nju.edu.cn>
    hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()

Chris Bainbridge <chris.bainbridge@gmail.com>
    ASoC: amd: fix memory leak in acp3x pdm dma ops

Andrew Fasano <andrew.fasano@nist.gov>
    netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate()

Arnd Bergmann <arnd@arndb.de>
    hwmon: (occ) Mark occ_init_attribute() as __printf

Jacob Keller <jacob.e.keller@intel.com>
    drm/mgag200: fix mgag200_bmc_stop_scanout()

Daniel Hodges <hodgesd@meta.com>
    tipc: use kfree_sensitive() for session key material

Jakub Kicinski <kuba@kernel.org>
    net: don't touch dev->stats in BPF redirect paths

Eric Dumazet <edumazet@google.com>
    macvlan: fix error recovery in macvlan_common_newlink()

Junrui Luo <moonafterrain@outlook.com>
    dpaa2-switch: add bounds check for if_id in IRQ handler

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Fix off-by-one error in VF setup_nic_devices() cleanup

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Fix off-by-one error in PF setup_nic_devices() cleanup

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Initialize netdev pointer before queue setup

Junrui Luo <moonafterrain@outlook.com>
    dpaa2-switch: prevent ZERO_SIZE_PTR dereference when num_ifs is zero

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix memory leak in smb2_open_file()

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix PSS event register mask

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: toshiba_haps: Fix memory leaks in add/remove routines

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't increment crypto_tx_tailroom_needed_cnt twice

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_count()

Veerendranath Jakkam <veerendranath.jakkam@oss.qualcomm.com>
    wifi: cfg80211: Fix bitrate calculation overflow for HE rates

Dimitrios Katsaros <patcherwork@gmail.com>
    ASoC: tlv320adcx140: Propagate error codes during probe

Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
    nvme-fc: release admin tagset if init fails

Kery Qi <qikeyu2017@gmail.com>
    ASoC: davinci-evm: Fix reference leak in davinci_evm_probe

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: mac80211: collect station statistics earlier when disconnect

Wupeng Ma <mawupeng1@huawei.com>
    ring-buffer: Avoid softlockup in ring_buffer_resize() during memory free

Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
    HID: Apply quirk HID_QUIRK_ALWAYS_POLL to Edifier QR30 (2d99:a101)

Kwok Kin Ming <kenkinming2002@gmail.com>
    HID: i2c-hid: fix potential buffer overflow in i2c_hid_get_report()

Chris Chiu <chris.chiu@canonical.com>
    HID: quirks: Add another Chicony HP 5MP Cameras to hid_ignore_list

Daniel Gomez <da.gomez@samsung.com>
    netfilter: replace -EEXIST with -EBUSY

Ruslan Krupitsa <krupitsarus@outlook.com>
    ALSA: hda/realtek: add HP Laptop 15s-eq1xxx mute LED quirk

Siarhei Vishniakou <svv@google.com>
    HID: playstation: Center initial joystick axes to prevent spurious events

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Reset enum_devices_done before enumeration

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reservation leak in some error paths when inserting inline extent

DaytonCL <artem749507@gmail.com>
    HID: multitouch: add MT_QUIRK_STICKY_FINGERS to MT_CLS_VTL

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Update ishtp bus match to support device ID table

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: Enable exception fixup for specific ADE subcode

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Set correct protection_map[] for VM_NONE/VM_SHARED

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: call ksmbd_session_rpc_close() on error path in create_smb2_pipe()

shechenglong <shechenglong@xfusion.com>
    block,bfq: fix aux stat accumulation destination

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: sr9700: support devices with virtual driver CD

Peter Åstrand <astrand@lysator.liu.se>
    wifi: wlcore: ensure skb headroom before skb_push

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    wifi: mac80211: ocb: skip rx_no_sta when interface is not joined

Zhiquan Li <zhiquan_li@163.com>
    KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some unpredictable test failures

Max Yuan <maxyuan@google.com>
    gve: Correct ethtool rx_dropped calculation

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix ftrace event field alignments

Debarghya Kundu <debarghyak@google.com>
    gve: Fix stats report corruption on queue count change

Xu Yang <xu.yang_2@nxp.com>
    pmdomain: imx8m-blk-ctrl: fix out-of-range access of bc->domains

Xu Yang <xu.yang_2@nxp.com>
    pmdomain: imx8mp-blk-ctrl: Keep usb phy power domain on for system wakeup

Xu Yang <xu.yang_2@nxp.com>
    pmdomain: imx8mp-blk-ctrl: Keep gpc power domain on for system wakeup

Carlos Llamas <cmllamas@google.com>
    binderfs: fix ida_alloc_max() upper bound

Carlos Llamas <cmllamas@google.com>
    binder: fix BR_FROZEN_REPLY error log

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX

Sean Christopherson <seanjc@google.com>
    KVM: Don't clobber irqfd routing type when deassigning irqfd

Bert Karwatzki <spasswolf@web.de>
    Revert "drm/amd: Check if ASPM is enabled from PCIe subsystem"

Thomas Weissschuh <thomas.weissschuh@linutronix.de>
    ARM: 9468/1: fix memset64() on big-endian

Ilya Dryomov <idryomov@gmail.com>
    rbd: check for EOD after exclusive lock is ensured to be held

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix swapped arrays in PSS output

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/kfence: fix booting on 32bit non-PAE systems

YunJe Shin <yjshin0438@gmail.com>
    nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/include/asm/string.h                      |  5 ++-
 arch/loongarch/kernel/traps.c                      |  5 +++
 arch/loongarch/mm/cache.c                          |  8 ++--
 arch/riscv/kernel/probes/uprobes.c                 | 10 +----
 arch/x86/include/asm/kfence.h                      |  7 ++--
 block/bfq-cgroup.c                                 |  2 +-
 drivers/android/binder.c                           |  5 ++-
 drivers/android/binderfs.c                         |  8 ++--
 drivers/block/rbd.c                                | 33 ++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  3 --
 drivers/gpu/drm/mgag200/mgag200_bmc.c              | 31 ++++++---------
 drivers/gpu/drm/mgag200/mgag200_drv.h              |  6 +++
 drivers/hid/hid-ids.h                              |  4 ++
 drivers/hid/hid-multitouch.c                       |  1 +
 drivers/hid/hid-playstation.c                      |  5 +++
 drivers/hid/hid-quirks.c                           |  2 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  1 +
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |  1 +
 drivers/hid/intel-ish-hid/ishtp/bus.c              | 12 +++++-
 drivers/hwmon/occ/common.c                         |  1 +
 drivers/iommu/iommu.c                              |  3 ++
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 39 +++++++++---------
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |  4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    | 10 +++++
 drivers/net/ethernet/google/gve/gve_ethtool.c      | 46 ++++++++++++++--------
 drivers/net/ethernet/google/gve/gve_main.c         |  4 +-
 drivers/net/macvlan.c                              |  5 ++-
 drivers/net/usb/sr9700.c                           |  5 +++
 drivers/net/wireless/ti/wlcore/tx.c                |  5 +++
 drivers/nvme/host/fc.c                             |  2 +
 drivers/nvme/target/tcp.c                          | 17 ++++++++
 drivers/platform/x86/intel/telemetry/debugfs.c     |  4 +-
 drivers/platform/x86/intel/telemetry/pltdrv.c      |  2 +-
 drivers/platform/x86/toshiba_haps.c                |  2 +-
 drivers/soc/imx/imx8m-blk-ctrl.c                   |  2 +-
 drivers/soc/imx/imx8mp-blk-ctrl.c                  | 30 ++++++++++++++
 drivers/spi/spi-tegra20-slink.c                    |  6 ++-
 drivers/spi/spi-tegra210-quad.c                    | 36 +++++++++++++++--
 drivers/target/iscsi/iscsi_target_util.c           | 10 ++++-
 fs/btrfs/inode.c                                   | 16 +++++---
 fs/hfsplus/dir.c                                   |  2 +-
 fs/hfsplus/hfsplus_fs.h                            |  8 +++-
 fs/hfsplus/unicode.c                               | 24 ++++++++---
 fs/hfsplus/xattr.c                                 |  6 +--
 fs/smb/client/smb2file.c                           |  1 +
 fs/smb/server/smb2pdu.c                            |  5 ++-
 kernel/trace/ring_buffer.c                         |  2 +
 kernel/trace/trace.h                               |  7 +++-
 kernel/trace/trace_entries.h                       | 14 +++----
 kernel/trace/trace_export.c                        | 21 +++++++---
 net/bridge/netfilter/ebtables.c                    |  2 +-
 net/core/filter.c                                  |  8 ++--
 net/mac80211/key.c                                 |  3 +-
 net/mac80211/ocb.c                                 |  3 ++
 net/mac80211/sta_info.c                            |  7 ++--
 net/netfilter/nf_log.c                             |  4 +-
 net/netfilter/nf_tables_api.c                      |  2 +-
 net/netfilter/nft_set_pipapo.c                     |  8 ++++
 net/netfilter/x_tables.c                           |  2 +-
 net/tipc/crypto.c                                  |  4 +-
 net/wireless/util.c                                |  8 ++--
 sound/pci/hda/patch_realtek.c                      |  2 +
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |  2 +
 sound/soc/codecs/tlv320adcx140.c                   |  3 ++
 sound/soc/ti/davinci-evm.c                         | 39 ++++++++++++++----
 tools/testing/selftests/kvm/Makefile               |  1 +
 virt/kvm/eventfd.c                                 | 44 +++++++++++----------
 68 files changed, 440 insertions(+), 194 deletions(-)


