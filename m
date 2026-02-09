Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9554928312F;
	Mon,  9 Feb 2026 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648835; cv=none; b=JLtPmTa7YBhxpVRoo7mp7zU7XK9x9S5D+51JI6ezpatp037F5U3lfTpUfInuLw1CD/DHeAJ/ujf1qlvRSVFWDch/glNnEdFxIXGZanZTZdmtvcjmN+CO3anPBWN5vTvxd3j/ApctvqOTb5kZ7ExNVqC2Y8mPB4pIbrAlWh8aKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648835; c=relaxed/simple;
	bh=O2jc6j03v2iDM8EIKPEgYzyiR6cuhW3xucZNuhcdOyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GIlw7LTI8Lae0NpGDwHY6EWnKbXCqVV/MRmau9lfNFmjZ/ySiusVbpW+MtvCKZ9JcDUAM3qii2xbCIKy3MdBtrLHGQv5Hc7Zxq7u2b5xqoDOvum9aJtQp0bBRWqgv07u3pS2orEx3yEisjW0yv1VT9vLU9/Cc4dguei6KCX1f9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gluuFYjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gluuFYjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5605C116C6;
	Mon,  9 Feb 2026 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648835;
	bh=O2jc6j03v2iDM8EIKPEgYzyiR6cuhW3xucZNuhcdOyo=;
	h=From:To:Cc:Subject:Date:From;
	b=gluuFYjxabEDGBkM3WoygWzTYRCcEMphGd5cMQa/j50HwuHp/RVu7JL9O3zHdgE3H
	 /9bpddIOLZg9/igeBt1lR84FDxhC7u8D84KCcjvF/BbaSQCR98IcCD8leQW6MOzURC
	 5kGTk4uJoTrxtwh/PXgQflsRDzUG5i0n4vZB0K1U=
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
Subject: [PATCH 5.15 00/75] 5.15.200-rc1 review
Date: Mon,  9 Feb 2026 15:23:57 +0100
Message-ID: <20260209142301.830618238@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.200-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.200-rc1
X-KernelTest-Deadline: 2026-02-11T14:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.200 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.200-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.200-rc1

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: pass iov_len instead of sg->length to bvec_set_page()

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

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_event: call disconnect callback before deleting conn

Max Yuan <maxyuan@google.com>
    gve: Correct ethtool rx_dropped calculation

Debarghya Kundu <debarghyak@google.com>
    gve: Fix stats report corruption on queue count change

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix ftrace event field alignments

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix NULL pointer dereference in gfs2_log_flush

Kang Chen <k.chen@smail.nju.edu.cn>
    hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Chris Bainbridge <chris.bainbridge@gmail.com>
    ASoC: amd: fix memory leak in acp3x pdm dma ops

YunJe Shin <yjshin0438@gmail.com>
    nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    nvmet-tcp: don't map pages which can't come from HIGHMEM

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix regression in data_digest calculation

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix memory leak when performing a controller reset

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: add an helper to free the cmd buffers

Andrew Fasano <andrew.fasano@nist.gov>
    netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate()

Arnd Bergmann <arnd@arndb.de>
    hwmon: (occ) Mark occ_init_attribute() as __printf

Daniel Hodges <hodgesd@meta.com>
    tipc: use kfree_sensitive() for session key material

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

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix PSS event register mask

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: toshiba_haps: Fix memory leaks in add/remove routines

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't increment crypto_tx_tailroom_needed_cnt twice

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_count()

Veerendranath Jakkam <veerendranath.jakkam@oss.qualcomm.com>
    wifi: cfg80211: Fix bitrate calculation overflow for HE rates

Dimitrios Katsaros <patcherwork@gmail.com>
    ASoC: tlv320adcx140: Propagate error codes during probe

Kery Qi <qikeyu2017@gmail.com>
    ASoC: davinci-evm: Fix reference leak in davinci_evm_probe

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: mac80211: collect station statistics earlier when disconnect

Wupeng Ma <mawupeng1@huawei.com>
    ring-buffer: Avoid softlockup in ring_buffer_resize() during memory free

Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
    HID: Apply quirk HID_QUIRK_ALWAYS_POLL to Edifier QR30 (2d99:a101)

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

DaytonCL <artem749507@gmail.com>
    HID: multitouch: add MT_QUIRK_STICKY_FINGERS to MT_CLS_VTL

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

Carlos Llamas <cmllamas@google.com>
    binderfs: fix ida_alloc_max() upper bound

Yipeng Zou <zouyipeng@huawei.com>
    timers: Fix NULL function pointer race in timer_shutdown_sync()

Thomas Gleixner <tglx@linutronix.de>
    Bluetooth: hci_qca: Fix the teardown problem for real

Steven Rostedt (Google) <rostedt@goodmis.org>
    timers: Update the documentation to reflect on the new timer_shutdown() API

Thomas Gleixner <tglx@linutronix.de>
    timers: Provide timer_shutdown[_sync]()

Thomas Gleixner <tglx@linutronix.de>
    timers: Add shutdown mechanism to the internal functions

Thomas Gleixner <tglx@linutronix.de>
    timers: Split [try_to_]del_timer[_sync]() to prepare for shutdown mode

Thomas Gleixner <tglx@linutronix.de>
    timers: Silently ignore timers with a NULL function

Thomas Gleixner <tglx@linutronix.de>
    Documentation: Replace del_timer/del_timer_sync()

Thomas Gleixner <tglx@linutronix.de>
    timers: Rename del_timer() to timer_delete()

Thomas Gleixner <tglx@linutronix.de>
    timers: Replace BUG_ON()s

Thomas Gleixner <tglx@linutronix.de>
    timers: Get rid of del_singleshot_timer_sync()

Steven Rostedt (Google) <rostedt@goodmis.org>
    clocksource/drivers/sp804: Do not use timer namespace for timer_shutdown() function

Steven Rostedt (Google) <rostedt@goodmis.org>
    clocksource/drivers/arm_arch_timer: Do not use timer namespace for timer_shutdown() function

Steven Rostedt (Google) <rostedt@goodmis.org>
    ARM: spear: Do not use timer namespace for timer_shutdown() function

Thomas Gleixner <tglx@linutronix.de>
    Documentation: Remove bogus claim about del_timer_sync()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX

Pimyn Girgis <pimyn@google.com>
    mm/kfence: randomize the freelist on initialization

Sean Christopherson <seanjc@google.com>
    KVM: Don't clobber irqfd routing type when deassigning irqfd

Thomas Weissschuh <thomas.weissschuh@linutronix.de>
    ARM: 9468/1: fix memset64() on big-endian

Ilya Dryomov <idryomov@gmail.com>
    rbd: check for EOD after exclusive lock is ensured to be held

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix swapped arrays in PSS output

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/kfence: fix booting on 32bit non-PAE systems


-------------

Diffstat:

 .../RCU/Design/Requirements/Requirements.rst       |   2 +-
 Documentation/core-api/local_ops.rst               |   2 +-
 Documentation/kernel-hacking/locking.rst           |  17 +-
 Documentation/timers/hrtimers.rst                  |   2 +-
 .../translations/it_IT/kernel-hacking/locking.rst  |  14 +-
 .../translations/zh_CN/core-api/local_ops.rst      |   2 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/string.h                      |   5 +-
 arch/arm/mach-spear/time.c                         |   8 +-
 arch/riscv/kernel/probes/uprobes.c                 |  10 +-
 arch/x86/include/asm/kfence.h                      |   7 +-
 block/bfq-cgroup.c                                 |   2 +-
 drivers/android/binderfs.c                         |   8 +-
 drivers/block/rbd.c                                |  33 +-
 drivers/bluetooth/hci_qca.c                        |  10 +-
 drivers/char/tpm/tpm-dev-common.c                  |   4 +-
 drivers/clocksource/arm_arch_timer.c               |  12 +-
 drivers/clocksource/timer-sp804.c                  |   6 +-
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-multitouch.c                       |   1 +
 drivers/hid/hid-playstation.c                      |   5 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |   1 +
 drivers/hwmon/occ/common.c                         |   1 +
 drivers/iommu/iommu.c                              |   3 +
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  39 +--
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |   4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  10 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      |  46 ++-
 drivers/net/ethernet/google/gve/gve_main.c         |   4 +-
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/usb/sr9700.c                           |   5 +
 drivers/net/wireless/ti/wlcore/tx.c                |   5 +
 drivers/nvme/target/tcp.c                          | 100 +++---
 drivers/platform/x86/intel/telemetry/debugfs.c     |   4 +-
 drivers/platform/x86/intel/telemetry/pltdrv.c      |   2 +-
 drivers/platform/x86/toshiba_haps.c                |   2 +-
 drivers/spi/spi-tegra20-slink.c                    |   6 +-
 drivers/spi/spi-tegra210-quad.c                    |  36 ++-
 drivers/staging/wlan-ng/hfa384x_usb.c              |   4 +-
 drivers/staging/wlan-ng/prism2usb.c                |   6 +-
 drivers/target/iscsi/iscsi_target_util.c           |  10 +-
 fs/gfs2/log.c                                      |   3 +-
 fs/gfs2/super.c                                    |   4 +
 fs/hfsplus/dir.c                                   |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   8 +-
 fs/hfsplus/unicode.c                               |  24 +-
 fs/hfsplus/xattr.c                                 |   6 +-
 fs/ksmbd/smb2pdu.c                                 |   5 +-
 include/linux/timer.h                              |  17 +-
 kernel/time/timer.c                                | 342 ++++++++++++++++-----
 kernel/trace/ring_buffer.c                         |   2 +
 kernel/trace/trace.h                               |   7 +-
 kernel/trace/trace_entries.h                       |  14 +-
 kernel/trace/trace_export.c                        |  21 +-
 mm/kfence/core.c                                   |  25 +-
 net/bluetooth/hci_event.c                          |   3 +
 net/bridge/netfilter/ebtables.c                    |   2 +-
 net/mac80211/key.c                                 |   3 +-
 net/mac80211/ocb.c                                 |   3 +
 net/mac80211/sta_info.c                            |   7 +-
 net/netfilter/nf_log.c                             |   4 +-
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/netfilter/nft_set_pipapo.c                     |   8 +
 net/netfilter/x_tables.c                           |   2 +-
 net/sunrpc/xprt.c                                  |   2 +-
 net/tipc/crypto.c                                  |   4 +-
 net/wireless/util.c                                |   8 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +
 sound/soc/codecs/tlv320adcx140.c                   |   3 +
 sound/soc/ti/davinci-evm.c                         |  39 ++-
 virt/kvm/eventfd.c                                 |  44 +--
 73 files changed, 746 insertions(+), 324 deletions(-)


