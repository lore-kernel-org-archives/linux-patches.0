Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021642;
	b=oZF4B46FD7tImb7dp9NwMfxy0S5JPFTSuywW7qdq+5JDomSVl9jzQw5x9pIhoHh4dzwD
	 xAip+t6cuYFOvod8RavtCnPhll8lL7SaKTlfgi6jmA05o/J8euc2+XslhBR2ulFYl4FrT
	 /VDnN4dXa/7epAH2cylfSBTjpRN/80KBM5ed3olWt2wa7YG7p6gwJarLBjM6nUZbK0MaD
	 3DceDP4D2d5KY7BZLhH5X6WGW4Yk/n3L/rtRKo3k37TYqpBs+7f7ZuDMiA3qIOnz8RiD3
	 4tq9NnyqHJW053WY6YEzgPvJlhvxA2UJ3MM0VUxR8sfqs/aYrTnWpbTtW7Ld+BkxSKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9LXPcbocS90t6xfSDmDngqLKKChzTpWBZKSWxStF0g=;
	b=4412+e4oRG+b4YH/ixmkwh2mnlfi0I4sHI3XgMyC9Mruc6ohoilZKOMfZjhhDSYtYneI
	 nK6+610H/4MPL9HsxC9aAsqLm1ubV5WCE8Ht9NHQH6DOI5cDDUyqkAuDzp+HOUCZvM5in
	 pKUcDk28j9o72zwOL3iCdjjU0DcoiwYiC7mPwOC+FkXzsaNAlLzc13HEWZZt1kQReeBCi
	 m//5QCFKeZRe0rgAODXEomWsMsEJUEhNQzEhADaLhlnEoMT0F7J+2ySA6MkHwZ6SgPJSe
	 S0cSFsMsBL8yspxNDENsBlfqo/Rf0abCDBYMwagFMskKzGWavTG03L8+L4puGsO/MSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+pfJAOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5106606A31C;
	Wed, 18 Nov 2026 17:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+pfJAOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF41F000C4;
	Wed, 18 Nov 2026 17:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021642;
	bh=D9LXPcbocS90t6xfSDmDngqLKKChzTpWBZKSWxStF0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+pfJAOtFHiUuZCqYvXxG2t0hNmgOkoNfbxy9TzCXXL8rX6QZaUraRbyQ+TF8cHmy
	 XGt/fglneQSEIURxAqPT2Ky6w6luzCH4uQ1xkNlfCDbG5YY8M5AhxUiWg8+GgGZJOW
	 ch5JlMTL4/FuU1Btn5UAv4l7pQ56Esabgc+XS2co=
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
Subject: [PATCH 7.3 2380/2651] net/mlx5e: SHAMPO: Do not merge PSP packets
Date: Wed, 18 Nov 2026 16:00:20 +0100
Message-ID: <20261118150411.139423026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3f212e46fc2f9..5a340f1435e6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -218,6 +218,12 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
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
 	return mlx5e_ktls_init_rx(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
index 2b080c39cc37e..9fd1ee789de02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
@@ -85,6 +85,13 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
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
@@ -110,6 +117,12 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
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
index 903af3b3e7794..d49f26323b1e2 100644
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
@@ -2268,8 +2269,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
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



