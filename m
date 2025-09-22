Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6989C27FB2D;
	Mon, 22 Sep 2025 19:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569666; cv=none; b=JF5geNSWS8C9lGk6ZiJCLR9SdugK1hh22sJoNxfeQEHkhofic63T19LWFpQij0+eixAiLmjZgVY1LGtt3UKKU7YJV9QHOWM3haVGyzo/jn/tnklrqbXKfUGKGyku1ClLtQvLjjxkffUpYsnsqypBkiZQ1mk6nI8L0SMi2DCyI4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569666; c=relaxed/simple;
	bh=V36PHP8pI4Fc6CvqaqqeCLqHuhprRf/NCpWeuG0r3+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Clt6tuzWGTvjnc2S0A+pMytbTLvljdBnxrDaeKInMkLQ9w8jAJs4OjaJNFQnE456xMU/gaFewe25v+jqxDPw4SkKCmMid32Oo1oASLLOr6oTRSQ8oe4U54NoUXWnKHggTc5F1XunXd/oo6hYjeXshEHjTXFkD569kwhtuy3g/10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2TMpoRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2TMpoRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2831C4CEF0;
	Mon, 22 Sep 2025 19:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569666;
	bh=V36PHP8pI4Fc6CvqaqqeCLqHuhprRf/NCpWeuG0r3+8=;
	h=From:To:Cc:Subject:Date:From;
	b=r2TMpoRuuPvZGWQZp+btqWK6kqMQabViwUeWsmGMRRXgJPv9rb+1sn3q6+xAw9CKm
	 8MPync0lx9ObWuBNN/Hr0ArTdJbuLRpElOinBqrdLdG0RhHT4K3axjjMZN1EHqB+qt
	 vMQsyD7oMh6OwAv4X61iL1f9aJREy7RfASJOMq4A=
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
Subject: [PATCH 6.6 00/70] 6.6.108-rc1 review
Date: Mon, 22 Sep 2025 21:29:00 +0200
Message-ID: <20250922192404.455120315@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.108-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.108-rc1
X-KernelTest-Deadline: 2025-09-24T19:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.108 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.108-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.108-rc1

Eric Hagberg <ehagberg@janestreet.com>
    Revert "loop: Avoid updating block size under exclusive owner"

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: add a few more MIN_T/MAX_T users

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: simplify and clarify min_t()/max_t() implementation

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: avoid overly complicated constant expressions in VM code

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: propagate shutdown to subflows when possible

Bruno Thomsen <bruno.thomsen@gmail.com>
    rtc: pcf2127: fix SPI command byte for PCF2131 backport

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd/pgtbl: Fix possible race while increase page table level

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix full DbC transfer ring after several reconnects

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: decouple endpoint allocation from initialization

Johan Hovold <johan@kernel.org>
    phy: ti: omap-usb2: fix device leak at unbind

Rob Herring <robh@kernel.org>
    phy: Use device_get_match_data()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: userspace pm: validate deny-join-id0 flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: nl: announce deny-join-id0 flag

Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
    vmxnet3: unregister xdp rxq info in the reset path

Stefan Metzmacher <metze@samba.org>
    smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Set merge to zero early in af_alg_sendmsg

Qi Xi <xiqi2@huawei.com>
    drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path

Loic Poulain <loic.poulain@oss.qualcomm.com>
    drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ

Colin Ian King <colin.i.king@gmail.com>
    ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8974: Correct PLL rate rounding

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct typo in control name

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct PLL rate rounding

Jens Axboe <axboe@kernel.dk>
    io_uring: include dying ring in task_work "should cancel" state

Jens Axboe <axboe@kernel.dk>
    io_uring: backport io_should_terminate_tw()

Praful Adiga <praful.adiga@gmail.com>
    ALSA: hda/realtek: Fix mute led for HP Laptop 15-dw4xx

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: avoid spurious errors on TCP disconnect

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: catch IO errors on listen side

Håkon Bugge <haakon.bugge@oracle.com>
    rds: ib: Increment i_fastreg_wrs before bailing out

Hans de Goede <hansg@kernel.org>
    net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer

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

Eugene Koira <eugkoira@amazon.com>
    iommu/vt-d: Fix __domain_mapping()'s usage of switch_to_super_page()

Tao Cui <cuitao@kylinos.cn>
    LoongArch: Check the return value when creating kobj

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Align ACPI structures if ARCH_STRICT_ALIGN enabled

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Update help info of ARCH_STRICT_ALIGN

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

Hangbin Liu <liuhangbin@gmail.com>
    bonding: don't set oif to bond dev when getting NS target destination

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Harden uplink netdev access against device unbind

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Consider aggregated port speed during rate configuration

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    i40e: remove redundant memory barrier when cleaning Tx descs

Yeounsu Moon <yyyynoom@gmail.com>
    net: natsemi: fix `rx_dropped` double accounting on `netif_rx()` failure

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: sockopt: fix error messages

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: tfo: record 'deny join id0' info

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: set remote_deny_join_id0 on SYN recv

Hangbin Liu <liuhangbin@gmail.com>
    bonding: set random address only when slaves already exist

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    qed: Don't collect too many protection override GRC elements

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix buffer pool seeding for control traffic

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

Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>
    wifi: wilc1000: avoid buffer overflow in WID string configuration


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/loongarch/Kconfig                             |  8 +-
 arch/loongarch/include/asm/acenv.h                 |  7 +-
 arch/loongarch/kernel/env.c                        |  2 +
 arch/um/drivers/virtio_uml.c                       |  6 +-
 arch/x86/kvm/svm/svm.c                             |  3 +-
 arch/x86/mm/pgtable.c                              |  2 +-
 crypto/af_alg.c                                    | 10 ++-
 drivers/block/loop.c                               | 38 ++-------
 drivers/edac/sb_edac.c                             |  4 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |  6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |  6 +-
 drivers/gpu/drm/drm_color_mgmt.c                   |  2 +-
 drivers/iommu/amd/amd_iommu_types.h                |  1 +
 drivers/iommu/amd/io_pgtable.c                     | 26 +++++-
 drivers/iommu/intel/iommu.c                        |  7 +-
 drivers/md/dm-integrity.c                          |  6 +-
 drivers/mmc/host/mvsdio.c                          |  2 +-
 drivers/net/bonding/bond_main.c                    |  2 +-
 drivers/net/ethernet/broadcom/cnic.c               |  3 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  3 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 27 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  | 85 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h | 15 +++-
 drivers/net/ethernet/natsemi/ns83820.c             | 13 ++-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |  7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  | 10 +--
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c | 39 ++++++---
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.h |  5 +-
 drivers/pcmcia/omap_cf.c                           |  8 +-
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |  9 +--
 drivers/phy/marvell/phy-berlin-usb.c               |  7 +-
 drivers/phy/ralink/phy-ralink-usb.c                | 10 +--
 drivers/phy/rockchip/phy-rockchip-pcie.c           | 11 +--
 drivers/phy/rockchip/phy-rockchip-usb.c            | 10 +--
 drivers/phy/ti/phy-omap-control.c                  |  9 +--
 drivers/phy/ti/phy-omap-usb2.c                     | 24 ++++--
 drivers/phy/ti/phy-ti-pipe3.c                      | 14 +---
 drivers/power/supply/bq27xxx_battery.c             |  4 +-
 drivers/rtc/rtc-pcf2127.c                          | 10 +--
 drivers/usb/host/xhci-dbgcap.c                     | 94 +++++++++++++++-------
 fs/btrfs/tree-checker.c                            |  4 +-
 fs/btrfs/tree-log.c                                |  2 +-
 fs/nilfs2/sysfs.c                                  |  4 +-
 fs/nilfs2/sysfs.h                                  |  8 +-
 fs/smb/client/smbdirect.c                          |  4 +-
 fs/smb/server/transport_rdma.c                     | 26 ++++--
 include/crypto/if_alg.h                            | 10 ++-
 include/linux/minmax.h                             | 26 ++++--
 include/linux/mlx5/driver.h                        |  1 +
 include/linux/pageblock-flags.h                    |  2 +-
 include/uapi/linux/mptcp.h                         |  6 +-
 io_uring/io_uring.c                                |  7 +-
 io_uring/io_uring.h                                | 13 +++
 io_uring/poll.c                                    |  3 +-
 io_uring/timeout.c                                 |  2 +-
 kernel/cgroup/cgroup.c                             | 43 ++++++++--
 net/ipv4/proc.c                                    |  2 +-
 net/ipv4/tcp.c                                     |  5 ++
 net/ipv6/proc.c                                    |  2 +-
 net/mac80211/driver-ops.h                          |  2 +-
 net/mac80211/main.c                                |  7 +-
 net/mptcp/options.c                                |  6 +-
 net/mptcp/pm_netlink.c                             |  7 ++
 net/mptcp/protocol.c                               | 16 ++++
 net/mptcp/subflow.c                                |  4 +
 net/rds/ib_frmr.c                                  | 20 +++--
 net/rfkill/rfkill-gpio.c                           |  4 +-
 net/tls/tls.h                                      |  1 +
 net/tls/tls_strp.c                                 | 14 ++--
 net/tls/tls_sw.c                                   |  3 +-
 sound/firewire/motu/motu-hwdep.c                   |  2 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/codecs/wm8940.c                          |  9 ++-
 sound/soc/codecs/wm8974.c                          |  8 +-
 sound/soc/qcom/qdsp6/audioreach.c                  |  1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |  7 +-
 sound/soc/sof/intel/hda-stream.c                   |  2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  | 11 +--
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  | 16 ++--
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |  7 ++
 tools/testing/selftests/net/mptcp/userspace_pm.sh  | 14 +++-
 87 files changed, 601 insertions(+), 300 deletions(-)


