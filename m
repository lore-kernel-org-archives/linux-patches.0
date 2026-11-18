Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027820;
	b=eidX7hqhh6qIRuyD9VvR0Z11ivT+tctn5jTFtSUoRwNb3C/JgxOtZxdMCDuTR+9cDsYy
	 Lv6/KffpBGau1xgySzhvvb/MSrTKO5FfZDdD0DRM8C/ODYlGAHlKhJQd96dtxlWlXROKY
	 ufMTIxzudgw8l9QjUgSWK5hwqBWM9H38s14hLBjXJVOlCReVCgdw8jEdKfxTdfQR8L0rR
	 1bA5ca9nfzsHwV1EzxGT7mrWRQF0oNtByuNA4Wl64TOdzHL52nvHek4a5319MoK5tWzXy
	 LqX6VIhzaX5NzEpNaqacK4//dXie6ynYAFaBp9AFZYU38E+dKBskReRBbgySZsbAh8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9bcVETCY4LVWE+CsOlE9L9Ly8FUdkWbKzX4FPuM6ieQ=;
	b=r/8IhSvX0zWk5X8NmdngnIGXeNBA08p/5s+25aQOKKg7OGsHHII162+QIem1o52N/KlS
	 r018IhPPGVL4b2rs16pthFvotc3iRHGjH70ZeFArp27zBxvBHr4Qn5W3nVhpedQHqUIT2
	 bTk5lUUUr0nIVUX3mX/fSGlTJtHN6k5kCXGbnC8vQAXvaADy6KtOCWQX+0NPrDhoG2ccS
	 Oac1wI6tnvM1HEhvT6LQSzPwIj9KFW2wDR4yVo6cpCpMBe6/ZfJSvyD3cxWsreGVPPKvH
	 LLEjV0m63l356ATpHDtGPpF7lQ8rTPD08jz5Rj/LuEUMPMSs68lOEE3OiItiJdr9oTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycCJpfdB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9428F606A320;
	Wed, 18 Nov 2026 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycCJpfdB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48A31F000C4;
	Wed, 18 Nov 2026 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027820;
	bh=9bcVETCY4LVWE+CsOlE9L9Ly8FUdkWbKzX4FPuM6ieQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycCJpfdBhHo0+V3OPweDKv5mE+FQMoHy67MA7AKM8O9LsRcJoT+dmtVUbQ0tH73Wz
	 ownPSiFc2as99WndLOqd29PxdLllIcI7MDPllRFvyd6SkwTJTSWU7fnavbZeO5fMOW
	 YwksgCo2XzzwGzHNHQwyCyHKum3mQWcV7ey17xAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1926/2151] net/mlx5e: SHAMPO: Do not merge PSP packets
Date: Wed, 18 Nov 2026 16:01:01 +0100
Message-ID: <20261118150231.943040073@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 46bd2bf65b93573f3b73ce8c61f862ac901c076d ]

PSP packets are UDP-encapsulated, and enabling HW GRO (SHAMPO in mlx5)
makes it possible to merge those packets in a silly way:
IP|UDP|PSP1|payload1|PSP2|payload2|...

That happens because the HW GRO machinery doesn't know about PSP and
considers it part of the UDP payload.

Reject merging when the incoming CQE has PSP marker or the pending skb
has the PSP extension.

Fixes: 29d7f433fcec ("net/mlx5e: Add Rx data path offload")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20261021062805.3466208-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_accel/en_accel.h |  6 ++++++
 .../ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  6 ++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 8bef99e8367ef..a276abebfb016 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -235,6 +235,12 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 #endif
 }
 
+static inline bool
+mlx5e_accel_shampo_can_merge(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	return mlx5e_psp_shampo_can_merge(rq->hw_gro_data->skb, cqe);
+}
+
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
index 70289c921bd6b..1a4e115b23160 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
@@ -86,6 +86,13 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
 	return MLX5_PSP_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
 }
 
+static inline bool
+mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+	/* PSP packets cannot be merged. */
+	return !skb_ext_exist(skb, SKB_EXT_PSP) && !mlx5e_psp_is_rx_flow(cqe);
+}
+
 bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 				     struct mlx5_cqe64 *cqe);
 #else
@@ -111,6 +118,12 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
 	return false;
 }
 
+static inline bool
+mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+	return true;
+}
+
 static inline bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev,
 						   struct sk_buff *skb,
 						   struct mlx5_cqe64 *cqe)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6fced90cae604..b651b28dd2ed3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -49,6 +49,7 @@
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
+#include "en_accel/en_accel.h"
 #include "en_accel/ipsec.h"
 #include "en_accel/macsec.h"
 #include "en_accel/psp_rxtx.h"
@@ -2412,8 +2413,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (*skb &&
-	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
-							 page_size))) {
+	    !(match &&
+	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
+	      mlx5e_accel_shampo_can_merge(rq, cqe))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 	}
-- 
2.53.0



