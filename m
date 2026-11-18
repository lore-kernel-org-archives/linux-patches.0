Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025093;
	b=RgsbuPplyMi2VB6omc1SqfZqXXzyKzPA3rytIRrqLBcrSdgFbVjutq9fRKLgpwb6j/HL
	 /5UvkHG84f6VSVGu3WvSAQWiZLDe8FLiidR49i4kMVijnLio8ziSGXiKo0ekODRPMc+ST
	 LwYt8D5NHShEryq8EVxIgMVMBlGH7XGEsj8jD63cehBnUxTnQXxs4d9EbLvxop2idvG7Z
	 x6LTQTGUFVdegIrr4dpiOhd+jR8VL98LUMKDsK+YBjIhsXqnSPvsv6gcs9T5iBIX+9HFN
	 fECoAOmWI21JBzBZmsg0+Z784v/bd66lNPDMjYlzWkbrOP9RWi+Q1mTeMpAJ6HG/q/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7fVYBBYRQqVmDrIXXkB2ArMhEtBLDtZYIachO4R2or4=;
	b=yxfj0uEzSWju3rU5+A7dGRiYml+/q7tY4WLERDz/dYQMHTzXS0p9u+Ld1ocdcjpvWOJR
	 jDoSH3p4eKFxOG44eaTb4dNJXVYmutCXXrP0q/QdC2698OtQlISWSanQNppanL+Ihhecc
	 h9yejogWPPG5lhwkzAbJ7UNgraPbQ7M1xvUBHMvSgyrET2ecMZL4xeiXV9UP/HuB5SlGD
	 ucaKqJxjBa9YyDVNNUw5nHQHB0mkFo9XuT/dVgBjGACddumHrE5DQpd/CPxAyuG1JzbV8
	 KJEbz1zSC8fwODxh5mYdmchTz12UXdhR4YLgYrmUJD/cUjqEE5h4z5lQvx/dsFxzxnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ggUzJV6E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FBE606A31C;
	Wed, 18 Nov 2026 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ggUzJV6E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C08A1F000C4;
	Wed, 18 Nov 2026 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025092;
	bh=7fVYBBYRQqVmDrIXXkB2ArMhEtBLDtZYIachO4R2or4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggUzJV6Eoo8C9dUZhb615mzhYq/NxxHJG/VyeUb8QgSSIZwwQGvn3CsoLAiVMCG5v
	 CFrWTZC7rQO0PhExDFY1vunQxMRh+NWFdCdGljINsTZRS5ESt2+NTr1orHtsMP2V2j
	 PyAfFTUrzra0qEKutqn9FAecp/LwecoHfqSJLpiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	kernel-team@meta.com,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0957/2151] fbnic: convert to ndo_set_rx_mode_async
Date: Wed, 18 Nov 2026 15:44:52 +0100
Message-ID: <20261118150157.320646239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit 60dd9781e9b890fa4de3e8ab01f63f0fd4e332e7 ]

Convert fbnic from ndo_set_rx_mode to ndo_set_rx_mode_async. The
driver's __fbnic_set_rx_mode() now takes explicit uc/mc list
parameters and uses __hw_addr_sync_dev() on the snapshots instead
of __dev_uc_sync/__dev_mc_sync on the netdev directly.

Update callers in fbnic_up, fbnic_fw_config_after_crash,
fbnic_bmc_rpc_check and fbnic_set_mac to pass the real address
lists calling __fbnic_set_rx_mode outside the async work path.

Cc: Alexander Duyck <alexanderduyck@fb.com>
Cc: kernel-team@meta.com
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260416185712.2155425-6-sdf@fomichev.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: d261a371e3b7 ("fbnic: Rework the BMC state pulled from the capabilities message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/meta/fbnic/fbnic_netdev.c    | 20 ++++++++++++-------
 .../net/ethernet/meta/fbnic/fbnic_netdev.h    |  4 +++-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c   |  4 ++--
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c   |  2 +-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index cbedaa037cfa8..d6100ce2bdc1c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -183,7 +183,9 @@ static int fbnic_mc_unsync(struct net_device *netdev, const unsigned char *addr)
 	return ret;
 }
 
-void __fbnic_set_rx_mode(struct fbnic_dev *fbd)
+void __fbnic_set_rx_mode(struct fbnic_dev *fbd,
+			 struct netdev_hw_addr_list *uc,
+			 struct netdev_hw_addr_list *mc)
 {
 	bool uc_promisc = false, mc_promisc = false;
 	struct net_device *netdev = fbd->netdev;
@@ -213,10 +215,10 @@ void __fbnic_set_rx_mode(struct fbnic_dev *fbd)
 	}
 
 	/* Synchronize unicast and multicast address lists */
-	err = __dev_uc_sync(netdev, fbnic_uc_sync, fbnic_uc_unsync);
+	err = __hw_addr_sync_dev(uc, netdev, fbnic_uc_sync, fbnic_uc_unsync);
 	if (err == -ENOSPC)
 		uc_promisc = true;
-	err = __dev_mc_sync(netdev, fbnic_mc_sync, fbnic_mc_unsync);
+	err = __hw_addr_sync_dev(mc, netdev, fbnic_mc_sync, fbnic_mc_unsync);
 	if (err == -ENOSPC)
 		mc_promisc = true;
 
@@ -238,18 +240,21 @@ void __fbnic_set_rx_mode(struct fbnic_dev *fbd)
 	fbnic_write_tce_tcam(fbd);
 }
 
-static void fbnic_set_rx_mode(struct net_device *netdev)
+static void fbnic_set_rx_mode(struct net_device *netdev,
+			      struct netdev_hw_addr_list *uc,
+			      struct netdev_hw_addr_list *mc)
 {
 	struct fbnic_net *fbn = netdev_priv(netdev);
 	struct fbnic_dev *fbd = fbn->fbd;
 
 	/* No need to update the hardware if we are not running */
 	if (netif_running(netdev))
-		__fbnic_set_rx_mode(fbd);
+		__fbnic_set_rx_mode(fbd, uc, mc);
 }
 
 static int fbnic_set_mac(struct net_device *netdev, void *p)
 {
+	struct fbnic_net *fbn = netdev_priv(netdev);
 	struct sockaddr *addr = p;
 
 	if (!is_valid_ether_addr(addr->sa_data))
@@ -257,7 +262,8 @@ static int fbnic_set_mac(struct net_device *netdev, void *p)
 
 	eth_hw_addr_set(netdev, addr->sa_data);
 
-	fbnic_set_rx_mode(netdev);
+	if (netif_running(netdev))
+		__fbnic_set_rx_mode(fbn->fbd, &netdev->uc, &netdev->mc);
 
 	return 0;
 }
@@ -551,7 +557,7 @@ static const struct net_device_ops fbnic_netdev_ops = {
 	.ndo_features_check	= fbnic_features_check,
 	.ndo_set_mac_address	= fbnic_set_mac,
 	.ndo_change_mtu		= fbnic_change_mtu,
-	.ndo_set_rx_mode	= fbnic_set_rx_mode,
+	.ndo_set_rx_mode_async	= fbnic_set_rx_mode,
 	.ndo_get_stats64	= fbnic_get_stats64,
 	.ndo_bpf		= fbnic_bpf,
 	.ndo_hwtstamp_get	= fbnic_hwtstamp_get,
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h
index e6ca23a9957d9..a05fc55221abd 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.h
@@ -97,7 +97,9 @@ void fbnic_time_init(struct fbnic_net *fbn);
 int fbnic_time_start(struct fbnic_net *fbn);
 void fbnic_time_stop(struct fbnic_net *fbn);
 
-void __fbnic_set_rx_mode(struct fbnic_dev *fbd);
+void __fbnic_set_rx_mode(struct fbnic_dev *fbd,
+			 struct netdev_hw_addr_list *uc,
+			 struct netdev_hw_addr_list *mc);
 void fbnic_clear_rx_mode(struct fbnic_dev *fbd);
 
 void fbnic_phylink_get_pauseparam(struct net_device *netdev,
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index cabbc88bb92db..74bd390026e4c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -135,7 +135,7 @@ void fbnic_up(struct fbnic_net *fbn)
 
 	fbnic_rss_reinit_hw(fbn->fbd, fbn);
 
-	__fbnic_set_rx_mode(fbn->fbd);
+	__fbnic_set_rx_mode(fbn->fbd, &fbn->netdev->uc, &fbn->netdev->mc);
 
 	/* Enable Tx/Rx processing */
 	fbnic_napi_enable(fbn);
@@ -176,7 +176,7 @@ static int fbnic_fw_config_after_crash(struct fbnic_dev *fbd)
 	}
 
 	fbnic_rpc_reset_valid_entries(fbd);
-	__fbnic_set_rx_mode(fbd);
+	__fbnic_set_rx_mode(fbd, &fbd->netdev->uc, &fbd->netdev->mc);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
index 42a186db43ea9..fe95b6f696463 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
@@ -244,7 +244,7 @@ void fbnic_bmc_rpc_check(struct fbnic_dev *fbd)
 
 	if (fbd->fw_cap.need_bmc_tcam_reinit) {
 		fbnic_bmc_rpc_init(fbd);
-		__fbnic_set_rx_mode(fbd);
+		__fbnic_set_rx_mode(fbd, &fbd->netdev->uc, &fbd->netdev->mc);
 		fbd->fw_cap.need_bmc_tcam_reinit = false;
 	}
 
-- 
2.53.0



