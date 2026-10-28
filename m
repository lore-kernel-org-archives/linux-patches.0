Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214434;
	b=kEtX+CCQQmOG59K3QE8kPOYJranpUW+he4VvQRMRhGw3wi6cG0+mImU0b4nMTrlI7Fj2
	 mcJwikuOR70SVtFn+EsW/pHufCNIMHa3OFzVPa9Q/go8kzOdLj00Jy1Lor4+LaTzfXSrU
	 d2LnMRp63TgQdnemN4i0e+8RdM8/ha3oi+qOBySL0vrmc98Rh+QaayqQrDCSSIOAi6ZF5
	 H2GyLF4pSakQh9KJ/Et7S+tzMUiuoM7xpIfCLw0y3uCVQusAEa59fWIBK1JXHhl5njw1k
	 sDaT5KwvpwC4thaxQ5SX8Yewvci4ukvh4tM2myh0E6aTGPWfs0n/8hLjhkd6r++0byQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=80BZSx/Sa0zTuZ5QSyRMyZN5Ul2iCGn4jt3XpV8XQ/4=;
	b=QJ9vsc6zFMdJQjYgT+su5bK1uKzWGIxEq2+nv8SZnufIDZ5gih25wSBHsFbypqdCY3de
	 rQeIv30pAzDiTrDlGxT8LW9JqtHddGCe12sU7lbSt/HxQs2dNIbDFdGp4zOnG1uxMcHob
	 dgBuHTwviJvUf23Kkj+6DwB5xVY/zPZLcmkomJ1u2Mn7I9c5W77OaGLi65bUySxffKA/q
	 xM+eEB1kaeu3a3mzBydMMfUGq2BZC3QM18LDBcad59QxNDb49MdpqFi1jAHkiSL0Xgcva
	 WFl6QyktZfQxez8AZYslZAwUu4E3bQNxnlrUOp+H8NQH6G1L4TiptL+DGBCS9+BE1Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEJd4qGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB817606BFA1;
	Wed, 28 Oct 2026 19:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEJd4qGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12EB1F01828;
	Wed, 28 Oct 2026 19:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214433;
	bh=80BZSx/Sa0zTuZ5QSyRMyZN5Ul2iCGn4jt3XpV8XQ/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEJd4qGMRPTU5OiNXxeQIuOS6ojldl1gr8t+hwoT/1HC16yAt/SIcUCdSekyf7sv9
	 ujxpQ8LnDfx2cc6SZ4K1VO6uUPXm2v+m5bMoVD+3r47UClVOhvDFKjtmqSDrAYe7jE
	 3WNkAQ4Oe/awtDLSZ5ZBAR1pNxL00gEDm3c6SEwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0814/1887] net/mlx5e: Provide intermediate pointer to access IPsec struct
Date: Wed, 28 Oct 2026 17:48:30 +0100
Message-ID: <20261028170517.949278376@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7bddb659bd0fc4e9022d3a3a2260540c01856e68 ]

Improve readability by providing direct pointer to struct mlx5e_ipsec.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 6d19c44b5c6d ("net/mlx5e: Remove skb secpath if xfrm state is not found")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c         | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index c4a84f0a3b733..318695a6aba2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -314,23 +314,23 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 				       struct mlx5_cqe64 *cqe)
 {
 	u32 ipsec_meta_data = be32_to_cpu(cqe->ft_metadata);
-	struct mlx5e_priv *priv;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_ipsec *ipsec = priv->ipsec;
 	struct xfrm_offload *xo;
 	struct xfrm_state *xs;
 	struct sec_path *sp;
 	u32  sa_handle;
 
 	sa_handle = MLX5_IPSEC_METADATA_HANDLE(ipsec_meta_data);
-	priv = netdev_priv(netdev);
 	sp = secpath_set(skb);
 	if (unlikely(!sp)) {
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sp_alloc);
+		atomic64_inc(&ipsec->sw_stats.ipsec_rx_drop_sp_alloc);
 		return;
 	}
 
-	xs = mlx5e_ipsec_sadb_rx_lookup(priv->ipsec, sa_handle);
+	xs = mlx5e_ipsec_sadb_rx_lookup(ipsec, sa_handle);
 	if (unlikely(!xs)) {
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sadb_miss);
+		atomic64_inc(&ipsec->sw_stats.ipsec_rx_drop_sadb_miss);
 		return;
 	}
 
@@ -351,6 +351,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 		xo->status = CRYPTO_INVALID_PACKET_SYNTAX;
 		break;
 	default:
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_syndrome);
+		atomic64_inc(&ipsec->sw_stats.ipsec_rx_drop_syndrome);
 	}
 }
-- 
2.53.0



