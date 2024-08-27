Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A01A1C462B;
	Tue, 27 Aug 2024 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771338; cv=none; b=NotH5gLE1KjVqcnsTVN/z+kKIaYgoBZ/HGmOfB0TbLQnhrGjcTMV3K0wCdSbU+7nosGsGfYL6rKXs+2r41N7IpTBV4H+GDD2iIrISPcEcKtKPzpS4J2xY1I3niVzkkVbmk+gMLcBriZQB0ZXKRxQG7VAotnUf2rs/WbrAarQtEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771338; c=relaxed/simple;
	bh=9LDnbUESC0BCIgHi520qFhqOgTWeWB8POttH46neyXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EL0gkWLzJPRCrT2yLm4w8YRJDhZS6vm2VchoGA8jtJuNR/SETl7JYcmTjs8wmFpaxiFdi9/rFsR7u4T6bCL/yCyrPpqcAaeDRxK96pFo1nECSHjAIy97PxLyoLExJfSQUjXQZN0Aaj7ZBrE3+xHqT29LEbBkIxRSmr5sWBGPtI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeeuPywE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeeuPywE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDCFC4AF18;
	Tue, 27 Aug 2024 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771338;
	bh=9LDnbUESC0BCIgHi520qFhqOgTWeWB8POttH46neyXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeeuPywEiUEiC0Ha/jY39umUhVUIa+ZwBmJAbrI7xvFbXLtWALDGn/Vs1XYMa/H+E
	 KxfspsTW/Q2w/gify2edjTKTsqrMu1KwVc4r265Zf6ay/WPebRbU/WQqRjbmoFviPo
	 3oT9jQC+6R3J45FIpo2KR8tCnD3Y+RfNevXt9IYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 158/273] net/mlx5: Fix IPsec RoCE MPV trace call
Date: Tue, 27 Aug 2024 16:38:02 +0200
Message-ID: <20240827143839.416899370@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 607e1df7bd47fe91cab85a97f57870a26d066137 ]

Prevent the call trace below from happening, by not allowing IPsec
creation over a slave, if master device doesn't support IPsec.

WARNING: CPU: 44 PID: 16136 at kernel/locking/rwsem.c:240 down_read+0x75/0x94
Modules linked in: esp4_offload esp4 act_mirred act_vlan cls_flower sch_ingress mlx5_vdpa vringh vhost_iotlb vdpa mst_pciconf(OE) nfsv3 nfs_acl nfs lockd grace fscache netfs xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill cuse fuse rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_umad ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_ipoib iw_cm ib_cm ipmi_ssif intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd kvm_amd kvm irqbypass crct10dif_pclmul crc32_pclmul mlx5_ib ghash_clmulni_intel sha1_ssse3 dell_smbios ib_uverbs aesni_intel crypto_simd dcdbas wmi_bmof dell_wmi_descriptor cryptd pcspkr ib_core acpi_ipmi sp5100_tco ccp i2c_piix4 ipmi_si ptdma k10temp ipmi_devintf ipmi_msghandler acpi_power_meter acpi_cpufreq ext4 mbcache jbd2 sd_mod t10_pi sg mgag200 drm_kms_helper syscopyarea sysfillrect mlx5_core sysimgblt fb_sys_fops cec
 ahci libahci mlxfw drm pci_hyperv_intf libata tg3 sha256_ssse3 tls megaraid_sas i2c_algo_bit psample wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded: mst_pci]
CPU: 44 PID: 16136 Comm: kworker/44:3 Kdump: loaded Tainted: GOE 5.15.0-20240509.el8uek.uek7_u3_update_v6.6_ipsec_bf.x86_64 #2
Hardware name: Dell Inc. PowerEdge R7525/074H08, BIOS 2.0.3 01/15/2021
Workqueue: events xfrm_state_gc_task
RIP: 0010:down_read+0x75/0x94
Code: 00 48 8b 45 08 65 48 8b 14 25 80 fc 01 00 83 e0 02 48 09 d0 48 83 c8 01 48 89 45 08 5d 31 c0 89 c2 89 c6 89 c7 e9 cb 88 3b 00 <0f> 0b 48 8b 45 08 a8 01 74 b2 a8 02 75 ae 48 89 c2 48 83 ca 02 f0
RSP: 0018:ffffb26387773da8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffa08b658af900 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ff886bc5e1366f2f RDI: 0000000000000000
RBP: ffffa08b658af940 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffa0a9bfb31540
R13: ffffa0a9bfb37900 R14: 0000000000000000 R15: ffffa0a9bfb37905
FS:  0000000000000000(0000) GS:ffffa0a9bfb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a45ed814e8 CR3: 000000109038a000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 ? show_trace_log_lvl+0x1d6/0x2f9
 ? show_trace_log_lvl+0x1d6/0x2f9
 ? mlx5_devcom_for_each_peer_begin+0x29/0x60 [mlx5_core]
 ? down_read+0x75/0x94
 ? __warn+0x80/0x113
 ? down_read+0x75/0x94
 ? report_bug+0xa4/0x11d
 ? handle_bug+0x35/0x8b
 ? exc_invalid_op+0x14/0x75
 ? asm_exc_invalid_op+0x16/0x1b
 ? down_read+0x75/0x94
 ? down_read+0xe/0x94
 mlx5_devcom_for_each_peer_begin+0x29/0x60 [mlx5_core]
 mlx5_ipsec_fs_roce_tx_destroy+0xb1/0x130 [mlx5_core]
 tx_destroy+0x1b/0xc0 [mlx5_core]
 tx_ft_put+0x53/0xc0 [mlx5_core]
 mlx5e_xfrm_free_state+0x45/0x90 [mlx5_core]
 ___xfrm_state_destroy+0x10f/0x1a2
 xfrm_state_gc_task+0x81/0xa9
 process_one_work+0x1f1/0x3c6
 worker_thread+0x53/0x3e4
 ? process_one_work.cold+0x46/0x3c
 kthread+0x127/0x144
 ? set_kthread_struct+0x60/0x52
 ret_from_fork+0x22/0x2d
 </TASK>
---[ end trace 5ef7896144d398e1 ]---

Fixes: dfbd229abeee ("net/mlx5: Configure IPsec steering for egress RoCEv2 MPV traffic")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20240815071611.2211873-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
index 234cd00f71a1c..b7d4b1a2baf2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
@@ -386,7 +386,8 @@ static int ipsec_fs_roce_tx_mpv_create(struct mlx5_core_dev *mdev,
 		return -EOPNOTSUPP;
 
 	peer_priv = mlx5_devcom_get_next_peer_data(*ipsec_roce->devcom, &tmp);
-	if (!peer_priv) {
+	if (!peer_priv || !peer_priv->ipsec) {
+		mlx5_core_err(mdev, "IPsec not supported on master device\n");
 		err = -EOPNOTSUPP;
 		goto release_peer;
 	}
@@ -455,7 +456,8 @@ static int ipsec_fs_roce_rx_mpv_create(struct mlx5_core_dev *mdev,
 		return -EOPNOTSUPP;
 
 	peer_priv = mlx5_devcom_get_next_peer_data(*ipsec_roce->devcom, &tmp);
-	if (!peer_priv) {
+	if (!peer_priv || !peer_priv->ipsec) {
+		mlx5_core_err(mdev, "IPsec not supported on master device\n");
 		err = -EOPNOTSUPP;
 		goto release_peer;
 	}
-- 
2.43.0



