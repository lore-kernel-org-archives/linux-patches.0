Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773872;
	b=DBS2jyBIj2stnaVecAjqxy2WDl/Xkdij1Afd3mSdZaCng7Tb3SY++yK/F0lGkpI0L3fk
	 wYPGZBD9YV3yHS6FZw64PWX0qfFt4fP5N3GFlCLAEtqzDcGVi64h6dOflz1yScdpw28in
	 /CfZwM9E5Dw++Gw/YpscP2VmldfZL/WFqyk8Z1pi+ak7cF7gN1LiAnryya2TXWTw9Tr6K
	 aQ8uEg+dxrJDqfGfstWWF8nbKUWxszkz/sQwFIU3+tnOKZ45GtolZhKpVZ1rUoduXHetL
	 8Mh61DNg8eKUVL44Rpyu+ETz5XKxghKPGEkCoeyACn8hXYR5bqxqlCpzxcyVGfkZCBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9lpGUNLN/LDAL27PeLCkJZVgL8iKWL4RuZArtScuWI=;
	b=yLcdIpU/qw+MEqRbkVN4EeGZMIOp/gKab7isVnr/uKit7ZJ0bggCe0m6IH6evYcPMpaC
	 EazF0B+sqR/yNs9p5X3G98+GxNK2QOplS+iAlhkePgBgyLiMF39e+KezvHm4m4rQclRKt
	 CMpGVHhKoHZJP7Lm9amyCunQNGLiDUX4xioixBAu6Ed9RosFoSnbml2qHvd44pEY702TY
	 c8gJqbPxk0AePr1k9PXLfqtbYFc9V71LdTpMvHAR0A1qhLkxbV53SRCDXDBvuHxb8gQI5
	 9AmwN+g+512586KAK+GxxsXg9Y28F3AqqxFymOswXWekXSA4aHMFDCb2MhoLzPsrc0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpazPDWh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3997D606A31B;
	Fri, 23 Oct 2026 16:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpazPDWh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850441F01825;
	Fri, 23 Oct 2026 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773872;
	bh=E9lpGUNLN/LDAL27PeLCkJZVgL8iKWL4RuZArtScuWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpazPDWhwLc4DHKXl6J1sQgN/hh9Wse0BRMcGfd8dbf5+Pqnu7CKDOS5V0gGvH9pp
	 3whrn8N+53Q010zZTvcLSZBX6gnGXv7+NYZLEz+KMP5MSlOrncaykO30PyJSEU/t1y
	 xnj0U0qA1+0bK3W3iwRVheUzg9X5C+SDA8w9K6vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/193] net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool
Date: Fri, 23 Oct 2026 18:35:20 +0200
Message-ID: <20261023163715.223776725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index c45a7ca66ad8e..9e8dd5241ff4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -1401,8 +1401,8 @@ static void mlx5_cmd_hws_packet_reformat_dealloc(struct mlx5_flow_root_namespace
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



