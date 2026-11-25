Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624680;
	b=WpSA7Qzc1nQbnANmyiYLamwWPUunh3XV83AklfzF51w2XpQsZhHkFKtHwkLwPnvDPE40
	 CEXRVn5Pny7erdR3Q00WkVwuU4N8EH8v8p70wBIvgbSh+HrBJ5FQa+if4Rxyw+sd1Bt4j
	 1/93mq5NCoNaSYsIzqvpBOstPa5TPsopBR0e2w8la6fI1mNFKJpTmoLwUt0IwHVCEh/ry
	 kXpMbzjeu6nEJ1aoGkgU9KDhiPO+/NmYKYDJwmBjEsIPyJMIDD4D/4HmQoajjqUdwgdi4
	 z3xCvl2e06E8rXKFuMUy7YwBYK7WtQKE4tQ2LaEUQLxNUtvBM80UxPplNpzAvDtYBcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OTsxses0cUZqv3NlTYISD37VTzPNNCseXzFokBpWDFc=;
	b=t6z+Jjp+vWFsDONuLC/VeBeuFsIMjA0fjVpQDq/W2aX8Luf06+cEuR6ueBmXub73UTBl
	 X95IoZjuUeYIZQvnAuN+w/0SB/JqQd4ArF48cODv5eIeelS6RQiqD6xxL8tRAnTlAjAtl
	 rccwgrg8xyp1wCB5Wt+M9p2UZoOFWSDfXE3zJZxcMf0rXusKcCGCl3QzbfeAlu0Sat1R3
	 MXeKX+GrE4Tz/9mR2r0i78d9Pl4XsMr43duxiIJyxxWGUgEda//rWXUFnzQnRrOi7LW+5
	 A5UKaDOH5um6OH62nl0S1eQcXGyJz9qENhuXMF0nZnI9NjVCh64ES96l1EnQzJn8fsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJ8XKu6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4175606A33B;
	Wed, 25 Nov 2026 16:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJ8XKu6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318061F000C0;
	Wed, 25 Nov 2026 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624680;
	bh=OTsxses0cUZqv3NlTYISD37VTzPNNCseXzFokBpWDFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJ8XKu6b0XAZ5PCS8S0kd5DLxudUqSZOzSqR5R6NTvwvgU2wSKmHjqy7H0DcmYfoU
	 nlK9cP3Atv2yVo4+rthwZFGLs7Cew8F3HMwfwgOa6SjHxIK7qfcAj0vygHn0FWPE3h
	 mV8Za3+FlEheAtu6JZWAd3n3RaOPTYvnpDh/0yHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/816] net/mlx5e: Add missing Ethernet multicast octets to vport_rx_bytes sum
Date: Wed, 25 Nov 2026 15:30:18 +0100
Message-ID: <20261125143855.459735219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 9c1adbe7fa6cbc02c25db2039532918acf846400 ]

mlx5e_rep_update_hw_counters() adds transmitted_eth_multicast.packets
to vport_rx_packets but does not add transmitted_eth_multicast.octets
to vport_rx_bytes. As a result, Ethernet multicast sent by a VF/SF is
counted in its representor's rx_packets but not in rx_bytes.

Fix by adding transmitted_eth_multicast.octets to the vport_rx_bytes
sum.

Fixes: 64b68e369649 ("net/mlx5: Refactor and expand rep vport stat group")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261101065833.282261-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e07e2f5f84435..070a809dfa609 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -238,6 +238,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 		MLX5_GET_CTR(out, transmitted_ib_unicast.octets) +
 		MLX5_GET_CTR(out, transmitted_eth_unicast.octets) +
 		MLX5_GET_CTR(out, transmitted_ib_multicast.octets) +
+		MLX5_GET_CTR(out, transmitted_eth_multicast.octets) +
 		MLX5_GET_CTR(out, transmitted_eth_broadcast.octets);
 
 	rep_stats->vport_tx_bytes =
-- 
2.53.0



