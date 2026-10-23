Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774446;
	b=RzfXxSF/t08VCoNuwxwBUdk1uwLOeE+PVieetvq2FeZHNt2vuh2AR+8PYbYgg5bJJJ5X
	 Aj749o5tO/CwmuhD3cfhDWIn5etVOHF+4pBtSkz0ofvj/smaAA2xSFGNfNNqshZc6Rd3O
	 P82/ebg0efFZc4y+Gos/NgzHgJuiuVfiebouGfICq1joEGXmj30A56yyAkfCeeDHkvr5e
	 uu35upFu4jCSImj180+KFeTcfNzinWWDCdOt7QJQFlRdfnG0EwNsMWuFTGZxzqmqxTd3F
	 dYKnwm5mFanK/nn1vz71Ztm5ceQMhAkSIuZ5sRXs+p3650YovidMfwzC24KLhbQwXMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fLLVjCAIgHqJQIdndWYgU5QOfppmQYc0WCFBaA0SRQA=;
	b=Nvw1Qe5qBlr90IJAc0A6SqkXiv7dROD/4SXLwojxXEhH8e0XJG52NjdiY4gUemkM5AqA
	 pyL3kRbL20iZGKkWYB6yM0018O3YALrDbRsY1M02G82w7Mi/y0FU2MLjhFqyTht1DkKpO
	 Sx5VDmQTjBwV1YApnJK4YiFZ4tgj0vN+EUcxd8qO+X0xEGZ8AN+cuC7KfND7tnNS47QIK
	 NgDpE6pT3TRy/xaP9DoTwY5vYJCEMi1KYud+D1f2I/7yjmWXzuMZGALHUI9ymit5twNnX
	 G48xDcYswYaoVVLIoztYsa+H3GCREL/d20M9wx30le83zQUp/yIXD+BHNteYtUatn7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA6noDyc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C43606A31A;
	Fri, 23 Oct 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA6noDyc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C991F01825;
	Fri, 23 Oct 2026 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774445;
	bh=fLLVjCAIgHqJQIdndWYgU5QOfppmQYc0WCFBaA0SRQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA6noDycLNVq0/Iv2wYbbjV6RMRTtHlxUtEye6Ye0SO6Lf2K6Zn1m4epxmbBCTLkh
	 OVbgpchyKsbGlV5qY83UDX/6qzsRqSAtmDnKvMPsQt7F5jJwprsUI9LZYqezgHLsrF
	 QX1GlH6yf11AWDB/cgMqb6D0lUSHe57yfDi3zFZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 042/242] net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool
Date: Fri, 23 Oct 2026 18:38:04 +0200
Message-ID: <20261023163714.773300340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Cassen <acassen@corp.free.fr>

[ Upstream commit 39e02ddf74bbe9c9080555232ba8100462cba2ad ]

L2 to L3 tunnel reformats are now released to the el2tol3tnl pools.

Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261007143830.1733583-2-acassen@corp.free.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 5a172c572a68f..44b311b4532d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -1398,8 +1398,8 @@ static void mlx5_cmd_hws_packet_reformat_dealloc(struct mlx5_flow_root_namespace
 						    pr_data->data_size);
 		break;
 	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
-		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol2tnl_pools,
-						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L2,
+		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol3tnl_pools,
+						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3,
 						    pr_data->data_size);
 		break;
 	case MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2:
-- 
2.53.0



