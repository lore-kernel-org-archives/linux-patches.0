Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621764;
	b=WjJQ3Fv1h4YB1ecD21FPtvdKNuPS9+gSEXX9llW69pw3CfbjSc1QVf93bcO23WNAykDD
	 GkZa7jgdU20jAQ3WCb/bOy3Yx5rf8ATqaaPKYOTr0s7TBePEvewfhIB6nNAEs2Nz9wkgM
	 cx5XEgw5cR/RJWQBrzeGaWhKfE+ie+g5ihTPVLKsu0khXBh/ODSaH2q8IJ8oI5OpCcWOB
	 RKpntGVC7PmTWoFHh2dQV1Dxw4qTXkvsBls0ES2ZqFS2C12ej0I7zI+Gp5JrK7M+qI5Mj
	 i5vXG7UrLRD2vGWT82q0UI8RWhUxGk1G5+6q2p1A5+cDyMTg7KnnilcLh3lYRXi95qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VP969/KizEWzhmxWNKd2+Zyf16KN3hU0H2Q9Kn3wX0M=;
	b=Ijh+BvigJL5mSwTaRdZtNNBidCOjbJeqMPSAnD6Z2qARHtd6hmDC/NGkXiobvvTEOQvH
	 6bXOq49ol6Bc2gFUkmO+mEcsm0mllMX7y0o9jaor/vTTevYyfdfNMwWUFAyro6bdPFN/Z
	 clioS8T9plO+7Xss/eW+9xGHLst9Bcc8RLY5HN7sxTy2rgXtQOYb96oVsOjfsGgDFu6pF
	 /iRIieQk0eRtJ2891pj2IDZaybWpLPhURpsSsjFWhoFr9oSCQd9/r+vbqkDyC1QzYg3FW
	 5wzK+uggdUU0bfJIJpjfTtMi6CswUBrrN3wm5G0zIGvO+Crq946RR03YQMXPbNeuC/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqzYcEfF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FB1606A335;
	Wed, 25 Nov 2026 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqzYcEfF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358C21F000E6;
	Wed, 25 Nov 2026 15:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621763;
	bh=VP969/KizEWzhmxWNKd2+Zyf16KN3hU0H2Q9Kn3wX0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqzYcEfFCxfwM4L5ZU7iK2gUZ5QK4LW5Qi/8hY6fOC9qxOl8cGTdSeJD/VSB4An5w
	 KbuJvS9nHKe+CML2J+6+izOl1bJHuGcX7AudwcTHZ8HO9vSbbDZ6rrxQ4/jmtS42Xe
	 vLLMY9fquwCiFf20+TLFqKiqvDEETJ9DMTatd0EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 329/990] net/mlx5e: Add missing Ethernet multicast octets to vport_rx_bytes sum
Date: Wed, 25 Nov 2026 15:28:16 +0100
Message-ID: <20261125143829.794433381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index a47fef49ada97..8e2ee08907a95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -239,6 +239,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 		MLX5_GET_CTR(out, transmitted_ib_unicast.octets) +
 		MLX5_GET_CTR(out, transmitted_eth_unicast.octets) +
 		MLX5_GET_CTR(out, transmitted_ib_multicast.octets) +
+		MLX5_GET_CTR(out, transmitted_eth_multicast.octets) +
 		MLX5_GET_CTR(out, transmitted_eth_broadcast.octets);
 
 	rep_stats->vport_tx_bytes =
-- 
2.53.0



