Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618860;
	b=HhhQqx7N6m+f6sfRU1bPHSdrROq1TiQN2bXqiI6GO+e+/rY/boCsVX/Aphcxp8rMa7Yw
	 TuYqP0xjE/iOZCpCprAHQtE+WSgJkH1LCSe1ZD58gobHBWWkoW+YhaW+TnswqwfVvijuG
	 8zUG4/FOBdFl3QIBFXWZB57gNWYIi6YfQ2XzhHgq9cZQv8muZBXVva/Z3ocUCN9tTTVGN
	 7PLEPle5BWS9BpayAgQwlb8DUl2p9nkzW8qcwvf8c8eRJxJkv88LdlnsIUO3AxdqarSfM
	 PnlCFk43zy8Abe3AQZbIYwRj5DepFBhDtWy/eCK0ou+KbzIGSRHFQuDLBHYDhbw0GGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iZ0oCcjsHYN77crJNPhVhFamAfG8b7ZU292V9MvQ69k=;
	b=BPEDZIbmXQANwamcWEYa30eFM6MpyZZvDC259cS79qaO7nr/t2z3u6WbIXv6oADV02q1
	 /BGDdBOCV4+o+tyVxrk4saKD1n5vO837HNHNY+JenQJxt4Gmb2p3eSedCAZZzogf5X8Ra
	 BBh2D85x3qFe0iMfz6FejEt7tD/gfC3UjLjEX3zEgaaoZhJcv/LbKATz4XNsE4BP7AoKX
	 no2xBpy7W7b8/0iic08/AIT2p6QG4S4aLny293GY9eRb2fnB2Bx3xEKn0ehFKlGTHXlKK
	 LmlJ/V9Fl6uDoM7/0FfU2uZSUn+WNkXOVRVWOYybA0513H6uBKEGnynt5jk8kO5dw+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ksiS/wvy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB65606A326;
	Wed, 25 Nov 2026 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksiS/wvy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D661F000C0;
	Wed, 25 Nov 2026 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618859;
	bh=iZ0oCcjsHYN77crJNPhVhFamAfG8b7ZU292V9MvQ69k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksiS/wvydqa2lEAdGcv5Ah/5inPsIkRZKoN5APiUEA+5WZ4RRNCjASbWbwr3LgSGl
	 0a7is/5n/L+IpfmA7tKqnV/aKSEjNZsiFP00U/LjDfVFGfGXH9eZu6FGo8nJ3JDDVT
	 8NABxhxkFDPm675iyGyEKUtqI3rbrdPmX5C8+9uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0366/1005] net/mlx5e: Add missing Ethernet multicast octets to vport_rx_bytes sum
Date: Wed, 25 Nov 2026 15:28:24 +0100
Message-ID: <20261125143830.306257354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 88a170e40bd93..a50a42581528a 100644
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



