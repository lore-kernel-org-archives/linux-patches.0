Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214198;
	b=0o2orPDsPdvyagq4MIhexd+JgVQ/WZEtHYalUaAB6n9X3MnLwoTj8YUZ5+kFkw2ipXIN
	 qJ6lYs39/yb3tGnm7cdtP9V++mKF+pp0HTSm19qAHgQZJrXE218uFXq53eGKpUPoVU+SD
	 2dvnFyzPl8XQBi9HLjdvyz4IWhpUvtd7r+10f4b+jd8iaFzWNhL0/quO8DtKo4xFxnqIK
	 heAi43xupHYzVjWp5yUHSdSKLChwiVZss8ATu1s8VDN2tUaJLC7RPn2mDJkiGZZxd649g
	 57z64Q1FpzEtuR0eEqLgk9TGrw4URjy7K6ZB/IxmonnoUvsKlzhTkqmk3F2QKbWIj7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yFcxbGlBkH1yKn6lZl2pRY2SmXAu0vxDQYHWXvlzvGM=;
	b=fKy9Tu9Pjx7VzFHKvFLIje1Jm4D60UtkNrcJcImYd8HTbytp3bsieeuHxNYqzwXY3f9r
	 3kO934K9977uvgR5hSz+uaso4sHKZ/MGSGhBm6o7ehyqvVW9s2xZxYieKUkBlGPavB3OO
	 2N/fSf2sLvWHqiF+yYPTEswfnNTyCn2pbz9vK32fObluDKit8CpkfpuQJf1bKxRtey/Vt
	 y0FDt9SW1/0rKzXb1bXFiqTdg1ZPEpPoG9XaZynAq/PEV6NKCFJFsgyi/4TOIkGnXS0sm
	 Ra0L43I8bf/aBeveSZjkby01yPW3gKNklAffEpW7bmVIO+lvk3Qqz7MDQmwNqB+umSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7sce28Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90009606A33C;
	Wed, 28 Oct 2026 19:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7sce28Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E078E1F013C7;
	Wed, 28 Oct 2026 19:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214198;
	bh=yFcxbGlBkH1yKn6lZl2pRY2SmXAu0vxDQYHWXvlzvGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7sce28YZl6Y1X+DYD5kFKqFu9P7X2GNEoRjVDQ96EDfNvdKXZUo2NvdJnd6WbN+D
	 G2wAzoXaqntw02hsbKcTTTZweXMTBfNgxtSrXDmKhUHZqiuLUzliJs2dlHh6f8ddJ0
	 yySGDkhggPn5HxY4l0OUHXB/3PgGU3Re8uQlLgEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0775/1887] sfc: fix NULL dereferences in ef100_process_design_param()
Date: Wed, 28 Oct 2026 17:47:51 +0100
Message-ID: <20261028170517.075098241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit 8241ecec1cdc6699ae197d52d58e76bddd995fa5 ]

Since cited commit, ef100_probe_main() and hence also
 ef100_check_design_params() run before efx->net_dev is created;
 consequently, we cannot netif_set_tso_max_size() or _segs() at this
 point.
Move those netif calls to ef100_probe_netdev(), and also replace
 netif_err within the design params code with pci_err.

Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Fixes: 98ff4c7c8ac7 ("sfc: Separate netdev probe/remove from PCI probe/remove")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250401225439.2401047-1-edward.cree@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  6 ++--
 drivers/net/ethernet/sfc/ef100_nic.c    | 47 +++++++++++--------------
 2 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index c6b9ba6803c8d..258e31ef7f2ce 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -354,6 +354,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
 	struct efx_probe_data **probe_ptr;
+	struct ef100_nic_data *nic_data;
 	struct net_device *net_dev;
 	int rc;
 
@@ -379,8 +380,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	net_dev->hw_enc_features |= efx->type->offload_features;
 	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
 				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
-	netif_set_tso_max_segs(net_dev,
-			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
+	nic_data = efx->nic_data;
+	netif_set_tso_max_size(efx->net_dev, nic_data->tso_max_payload_len);
+	netif_set_tso_max_segs(efx->net_dev, nic_data->tso_max_payload_num_segs);
 	efx->mdio.dev = net_dev;
 
 	rc = efx_ef100_init_datapath_caps(efx);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index fa1f7039a8e28..5bf264414b9e0 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -866,8 +866,7 @@ static int ef100_process_design_param(struct efx_nic *efx,
 	case ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS:
 		/* We always put HDR_NUM_SEGS=1 in our TSO descriptors */
 		if (!reader->value) {
-			netif_err(efx, probe, efx->net_dev,
-				  "TSO_MAX_HDR_NUM_SEGS < 1\n");
+			pci_err(efx->pci_dev, "TSO_MAX_HDR_NUM_SEGS < 1\n");
 			return -EOPNOTSUPP;
 		}
 		return 0;
@@ -880,32 +879,28 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		 */
 		if (!reader->value || reader->value > EFX_MIN_DMAQ_SIZE ||
 		    EFX_MIN_DMAQ_SIZE % (u32)reader->value) {
-			netif_err(efx, probe, efx->net_dev,
-				  "%s size granularity is %llu, can't guarantee safety\n",
-				  reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
-				  reader->value);
+			pci_err(efx->pci_dev,
+				"%s size granularity is %llu, can't guarantee safety\n",
+				reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
+				reader->value);
 			return -EOPNOTSUPP;
 		}
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN:
 		nic_data->tso_max_payload_len = min_t(u64, reader->value,
 						      GSO_LEGACY_MAX_SIZE);
-		netif_set_tso_max_size(efx->net_dev,
-				       nic_data->tso_max_payload_len);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS:
 		nic_data->tso_max_payload_num_segs = min_t(u64, reader->value, 0xffff);
-		netif_set_tso_max_segs(efx->net_dev,
-				       nic_data->tso_max_payload_num_segs);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES:
 		nic_data->tso_max_frames = min_t(u64, reader->value, 0xffff);
 		return 0;
 	case ESE_EF100_DP_GZ_COMPAT:
 		if (reader->value) {
-			netif_err(efx, probe, efx->net_dev,
-				  "DP_COMPAT has unknown bits %#llx, driver not compatible with this hw\n",
-				  reader->value);
+			pci_err(efx->pci_dev,
+				"DP_COMPAT has unknown bits %#llx, driver not compatible with this hw\n",
+				reader->value);
 			return -EOPNOTSUPP;
 		}
 		return 0;
@@ -925,10 +920,10 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		 * So the value of this shouldn't matter.
 		 */
 		if (reader->value != ESE_EF100_DP_GZ_VI_STRIDES_DEFAULT)
-			netif_dbg(efx, probe, efx->net_dev,
-				  "NIC has other than default VI_STRIDES (mask "
-				  "%#llx), early probing might use wrong one\n",
-				  reader->value);
+			pci_dbg(efx->pci_dev,
+				"NIC has other than default VI_STRIDES (mask "
+				"%#llx), early probing might use wrong one\n",
+				reader->value);
 		return 0;
 	case ESE_EF100_DP_GZ_RX_MAX_RUNT:
 		/* Driver doesn't look at L2_STATUS:LEN_ERR bit, so we don't
@@ -940,9 +935,9 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		/* Host interface says "Drivers should ignore design parameters
 		 * that they do not recognise."
 		 */
-		netif_dbg(efx, probe, efx->net_dev,
-			  "Ignoring unrecognised design parameter %u\n",
-			  reader->type);
+		pci_dbg(efx->pci_dev,
+			"Ignoring unrecognised design parameter %u\n",
+			reader->type);
 		return 0;
 	}
 }
@@ -978,13 +973,13 @@ static int ef100_check_design_params(struct efx_nic *efx)
 	 */
 	if (reader.state != EF100_TLV_TYPE) {
 		if (reader.state == EF100_TLV_TYPE_CONT)
-			netif_err(efx, probe, efx->net_dev,
-				  "truncated design parameter (incomplete type %u)\n",
-				  reader.type);
+			pci_err(efx->pci_dev,
+				"truncated design parameter (incomplete type %u)\n",
+				reader.type);
 		else
-			netif_err(efx, probe, efx->net_dev,
-				  "truncated design parameter %u\n",
-				  reader.type);
+			pci_err(efx->pci_dev,
+				"truncated design parameter %u\n",
+				reader.type);
 		rc = -EIO;
 	}
 out:
-- 
2.53.0



