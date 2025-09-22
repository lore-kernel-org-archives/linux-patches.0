Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A9C8E6;
	Mon, 22 Sep 2025 19:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569509; cv=none; b=lFj3TfDPMJLHo5g/oH2NsFRsLgLC0bD0jBVyHTh5EYzDLToEEWxpjtVjobPyeAz8DKJPcFXaUBG25RXrO/O9uEAEM5qpxRsltV9B9Nc+pcXc5ai6wXh2undpxZL5S85GKoyF5sQG3hmJU6vx0lBn8XActOVnUVPLidcgCsz6tSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569509; c=relaxed/simple;
	bh=BD0IuY8FRmdtzTgxCBKBWOqlX5hJPdTU19dZar9fuws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D66RdcUm/lkZOKXesHkHrm3jEoH6Y+1gTJ813ytcT2z7YuukzgYCEVgYgWucze3jjM8fl23V2KAUnRniWmh6yAC0iyHTDNC5RPP9vWILWvl7H45Q2VLOs6Lp5hxCZfmNKEAnWQHflY33Ny3eSfREg5tZ36P8qAMOMQgToBLs22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkHAqlaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkHAqlaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9776EC4CEF7;
	Mon, 22 Sep 2025 19:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569509;
	bh=BD0IuY8FRmdtzTgxCBKBWOqlX5hJPdTU19dZar9fuws=;
	h=From:To:Cc:Subject:Date:From;
	b=jkHAqlaz+a38fdPq3uVTOsC+AMBjGNfdt7hs4pmDL60plG8gZuvX5qx4nGMGotxOW
	 YVo3mmhIHf1X49Qb2OpeYRGhDiGKCO9ncZA7CeX7IthSqWEB4j8rfKuJAjuU+oJI3q
	 jG6QDWGv8+aa9UHnmnGMy4LDmMte/SumEm607Qig=
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
Subject: [PATCH 6.1 00/61] 6.1.154-rc1 review
Date: Mon, 22 Sep 2025 21:28:53 +0200
Message-ID: <20250922192403.524848428@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.154-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.154-rc1
X-KernelTest-Deadline: 2025-09-24T19:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.154 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.154-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.154-rc1

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg

David Howells <dhowells@redhat.com>
    crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: q6apm-lpass-dais: Fix NULL pointer dereference if source graph failed

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm-lpass-dai: close graph on prepare errors

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: q6apm-lpass-dai: close graphs before opening a new one

Hans de Goede <hansg@kernel.org>
    net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer

Philipp Zabel <p.zabel@pengutronix.de>
    net: rfkill: gpio: add DT support

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: catch IO errors on listen side

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: propagate shutdown to subflows when possible

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix full DbC transfer ring after several reconnects

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: decouple endpoint allocation from initialization

Johan Hovold <johan@kernel.org>
    phy: ti: omap-usb2: fix device leak at unbind

Rob Herring <robh@kernel.org>
    phy: Use device_get_match_data()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    phy: broadcom: ns-usb3: fix Wvoid-pointer-to-enum-cast warning

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: userspace pm: validate deny-join-id0 flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: nl: announce deny-join-id0 flag

Stefan Metzmacher <metze@samba.org>
    smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Set merge to zero early in af_alg_sendmsg

David Howells <dhowells@redhat.com>
    crypto: af_alg: Indent the loop in af_alg_sendmsg()

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

Jens Axboe <axboe@kernel.dk>
    io_uring: include dying ring in task_work "should cancel" state

Jens Axboe <axboe@kernel.dk>
    io_uring: backport io_should_terminate_tw()

Praful Adiga <praful.adiga@gmail.com>
    ALSA: hda/realtek: Fix mute led for HP Laptop 15-dw4xx

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: avoid spurious errors on TCP disconnect

Håkon Bugge <haakon.bugge@oracle.com>
    rds: ib: Increment i_fastreg_wrs before bailing out

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active

Thomas Fourier <fourier.thomas@gmail.com>
    mmc: mvsdio: Fix dma_unmap_sg() nents value

Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>
    ASoC: qcom: q6apm-lpass-dais: Fix missing set_fmt DAI op for I2S

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

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: restrict no-battery detection to bq27000

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: fix error return in case of no bq27000 hdq battery

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

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    i40e: remove redundant memory barrier when cleaning Tx descs

Yeounsu Moon <yyyynoom@gmail.com>
    net: natsemi: fix `rx_dropped` double accounting on `netif_rx()` failure

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: set remote_deny_join_id0 on SYN recv

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


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/include/asm/acenv.h                 |   7 +-
 arch/loongarch/kernel/env.c                        |   2 +
 arch/um/drivers/virtio_uml.c                       |   6 +-
 arch/x86/kvm/svm/svm.c                             |   3 +-
 crypto/af_alg.c                                    | 112 ++++++++-------------
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   6 +-
 drivers/iommu/intel/iommu.c                        |   7 +-
 drivers/mmc/host/mvsdio.c                          |   2 +-
 drivers/net/bonding/bond_main.c                    |   1 -
 drivers/net/ethernet/broadcom/cnic.c               |   3 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 -
 drivers/net/ethernet/natsemi/ns83820.c             |  13 ++-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   7 +-
 drivers/pcmcia/omap_cf.c                           |   8 +-
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |   9 +-
 drivers/phy/marvell/phy-berlin-usb.c               |   7 +-
 drivers/phy/ralink/phy-ralink-usb.c                |  10 +-
 drivers/phy/rockchip/phy-rockchip-pcie.c           |  11 +-
 drivers/phy/rockchip/phy-rockchip-usb.c            |  10 +-
 drivers/phy/ti/phy-omap-control.c                  |   9 +-
 drivers/phy/ti/phy-omap-usb2.c                     |  24 +++--
 drivers/phy/ti/phy-ti-pipe3.c                      |  14 +--
 drivers/power/supply/bq27xxx_battery.c             |   4 +-
 drivers/usb/host/xhci-dbgcap.c                     |  94 ++++++++++++-----
 fs/btrfs/tree-checker.c                            |   4 +-
 fs/btrfs/tree-log.c                                |   2 +-
 fs/nilfs2/sysfs.c                                  |   4 +-
 fs/nilfs2/sysfs.h                                  |   8 +-
 fs/smb/client/smbdirect.c                          |   4 +-
 fs/smb/server/transport_rdma.c                     |  26 +++--
 include/crypto/if_alg.h                            |  10 +-
 include/uapi/linux/mptcp.h                         |   6 +-
 io_uring/io_uring.c                                |  13 ++-
 io_uring/io_uring.h                                |  13 +++
 io_uring/poll.c                                    |   3 +-
 io_uring/timeout.c                                 |   2 +-
 kernel/cgroup/cgroup.c                             |  43 ++++++--
 net/ipv4/tcp.c                                     |   5 +
 net/mac80211/driver-ops.h                          |   2 +-
 net/mac80211/main.c                                |   7 +-
 net/mptcp/pm_netlink.c                             |   7 ++
 net/mptcp/protocol.c                               |  15 +++
 net/mptcp/subflow.c                                |   4 +
 net/rds/ib_frmr.c                                  |  20 ++--
 net/rfkill/rfkill-gpio.c                           |  22 +++-
 net/tls/tls.h                                      |   1 +
 net/tls/tls_strp.c                                 |  14 ++-
 net/tls/tls_sw.c                                   |   3 +-
 sound/firewire/motu/motu-hwdep.c                   |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/wm8940.c                          |   2 +-
 sound/soc/codecs/wm8974.c                          |   8 +-
 sound/soc/qcom/qdsp6/audioreach.c                  |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |  36 +++++--
 sound/soc/sof/intel/hda-stream.c                   |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  11 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   7 ++
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  14 ++-
 64 files changed, 440 insertions(+), 272 deletions(-)


