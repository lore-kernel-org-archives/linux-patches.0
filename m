Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78D94697
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C97C433D6
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933039;
	bh=IIK2U2hT2O8feFv59O+AeXiuPU6ogtB3I1hBretmk/U=;
	h=Subject:From:Date:To:Reply-To:From;
	b=qn73SMO/03rxqrE5aRTTa3MmBiolmBhmJicTkn28ygPkoHq1TQn1jz7fCgLpmUsbV
	 xw5ED7SfWDaY4wKD18j4A1WZIoJNE2nuXtJTx74e24OYVrMGAubXxVOQkzn06PIYTY
	 chFkrPStuMm8OzAbin+mBSoR1nbdKrRkI6GVw6t9JTke/L242EVvBMHZ0McL55iLSA
	 612/lObvK6KKrJXaP1j4oKn9+X9iGSfsqJK1ap3iCpRF1ydsjRzWMe5mPzp4JSP217
	 CnpLBRoMFNGWYIkdSUcAok1LRcsnlz3yXtgXhvXrQ0mCvu+SpIIR9+8cNxAGxBPkpr
	 mRgrDjN1WiN1Q==
Subject: [PATCH v1 0/9] This is a fake series to test web-endpoint-send
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:14 -0400
Message-Id: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
X-b4-tracking: H4sIAK3T/2IC/w3LSwqAMAwA0atI1gbagp96m1qjBiRKU92Idze7eYt5QakwKUzNC4UeVj7F4NsG8p
 5kI+TFDMGF4EYfsZJWJFmuk6WiWuGafO+Gro8hdmDjnJRwLknybqvcx/F9P9B7GtBpAAAA
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5884;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=pUEKh+jiOj/KhB+XyhfcgEdAQGrAzn6MdG73Y50O7D0=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X17rvPQ1r7j58i6OH4euK+1+7yWy5Om7az9Vm5b9/mSz
 g//flI5SFgYxLgZZMUWWsn2xm4IKH3rIpfeYwsxhZQIZwsDFKQATuVrAyPDpx66/i+8Yyf1+/Srqp/
 JDtwd/LnYZHVvQtEJ4v2P5TV42RoYtpj+t59eK6T5a6n1gzyeO/TkT75Td/X351BwrZsf+84+4AQ==
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

This is not a real series. Please ignore everything about it.
I'm using this random set of patches to test b4 web submission.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

---
Thomas Gleixner (9):
      slub: Make PREEMPT_RT support less convoluted
      preempt: Provide preempt_[dis|en]able_nested()
      dentry: Use preempt_[dis|en]able_nested()
      mm/vmstat: Use preempt_[dis|en]able_nested()
      mm/debug: Provide VM_WARN_ON_IRQS_ENABLED()
      mm/memcontrol: Replace the PREEMPT_RT conditionals
      mm/compaction: Get rid of RT ifdeffery
      u64_stats: Streamline the implementation
      u64_stat: Remove the obsolete fetch_irq() variants

 drivers/net/ethernet/alacritech/slic.h             |  12 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  12 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |   8 +-
 drivers/net/ethernet/asix/ax88796c_main.c          |   4 +-
 drivers/net/ethernet/broadcom/b44.c                |   8 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  12 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  12 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |  16 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c    |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  20 +--
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   4 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |  12 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   8 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  12 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   8 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |  12 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   8 +-
 drivers/net/ethernet/marvell/mvneta.c              |   8 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   8 +-
 drivers/net/ethernet/marvell/sky2.c                |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   8 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |   8 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c  |   4 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   8 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   4 +-
 drivers/net/ethernet/realtek/8139too.c             |   8 +-
 drivers/net/ethernet/socionext/sni_ave.c           |   8 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   4 +-
 drivers/net/ethernet/ti/netcp_core.c               |   8 +-
 drivers/net/ethernet/via/via-rhine.c               |   8 +-
 drivers/net/hyperv/netvsc_drv.c                    |  32 ++---
 drivers/net/ifb.c                                  |  12 +-
 drivers/net/ipvlan/ipvlan_main.c                   |   4 +-
 drivers/net/loopback.c                             |   4 +-
 drivers/net/macsec.c                               |  12 +-
 drivers/net/macvlan.c                              |   4 +-
 drivers/net/mhi_net.c                              |   8 +-
 drivers/net/team/team.c                            |   4 +-
 drivers/net/team/team_mode_loadbalance.c           |   4 +-
 drivers/net/veth.c                                 |  12 +-
 drivers/net/virtio_net.c                           |  16 +--
 drivers/net/vrf.c                                  |   4 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   4 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   8 +-
 drivers/net/xen-netfront.c                         |   8 +-
 drivers/spi/spi.c                                  |   4 +-
 fs/dcache.c                                        |  13 +-
 include/linux/mmdebug.h                            |   6 +
 include/linux/preempt.h                            |  42 ++++++
 include/linux/u64_stats_sync.h                     | 141 ++++++++-------------
 kernel/bpf/syscall.c                               |   4 +-
 lib/Kconfig.debug                                  |   3 +
 mm/Kconfig                                         |   5 +
 mm/compaction.c                                    |   6 +-
 mm/memcontrol.c                                    |  19 +--
 mm/slub.c                                          |  66 +++++-----
 mm/vmstat.c                                        |  36 ++----
 net/8021q/vlan_dev.c                               |   4 +-
 net/bridge/br_multicast.c                          |   4 +-
 net/bridge/br_vlan.c                               |   4 +-
 net/core/dev.c                                     |   4 +-
 net/core/devlink.c                                 |   4 +-
 net/core/drop_monitor.c                            |   8 +-
 net/core/gen_stats.c                               |  16 +--
 net/dsa/slave.c                                    |   4 +-
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv6/seg6_local.c                              |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   4 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/openvswitch/datapath.c                         |   4 +-
 net/openvswitch/flow_table.c                       |   9 +-
 79 files changed, 433 insertions(+), 445 deletions(-)
---
base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
change-id: 20220819-test-endpoint-send-fa1607569295

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>

