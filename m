Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617947;
	b=ZZX8dDx7jdkIGP/CIXfVIMkj4CsPw9QZsWQbr3KOZGGTEgxQ1UMCSL383dwqdvS945MQ
	 38BZkMbCRrQHunNR9hAF5LFqkbj30ajqT15LBBjCVyx7ltZxuLvZvKbpsxq4R2kQF52R9
	 XHuIxyzl9Ys9PaywIX5PKBiYCMGNa79P944nNYCK7itRsJJqIrJXqbyXmRWWHq0h7bgU0
	 BYSuRSxZFvRMtsWrANkTCf0whFIoV1PB0+KvLOmlbpn/UQ6dDEBIJVcGc3jExRSrqYgi4
	 W5hObsU0P4qZbuMG62awVZLIIMlums6lguZuRl7PTvy7yU2KSGu6aAqz0xhkeI/ltlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KqWUfGYkhOWZ97g7LM2CsCOGaNM/T/qSeplZ8fzh/aI=;
	b=phmWA828nfJ+APT/SjkNEktq6AvEsi3Q7vwflMOM4fHd2B+n0Q7hqcitb5iGcoyNUvSM
	 ocy/Ab9kD2Sc3p5UWa0XgUcXEErdB9TlOBrALc9wobDcOGU1lazn/O7y2rI/kw2+GOgC/
	 O2zI/a3XOFDMmeEPCw07MGAKOfPjSEms8VkefnDDemhRab9l1odGFrzGpSQq9uic0Rp2E
	 Cmy2A5OoNxJSqyRM/pS+k1ETba4OSWPOxTMbHd2F/7uLIIB9cR3DD47Ph51XahdiY3ZEI
	 r1zZT0QhONaVB+8eVOG8bb3xa7W4+acrioQ6XFkXd4r9OyGhG7th7J4qBiMLB1YG0CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUhL9fW6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851FC606A327;
	Wed, 25 Nov 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUhL9fW6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620031F000F0;
	Wed, 25 Nov 2026 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617946;
	bh=KqWUfGYkhOWZ97g7LM2CsCOGaNM/T/qSeplZ8fzh/aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUhL9fW6ICjzrwFXyu17TEPjSgzoXec/QcNW9JXqmh2zre0BxMra7leBTs31mA9Y4
	 nb/+bMQ80uwpaGJBsiG+NASuv10+OfBs3kDD6cNm2/3rJPnLjFClFcAFWs81UZICts
	 gCntvsnDZpn7NRNaceufKuEHjEBc9f4rlw37v8sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0126/1005] net/mlx5: macsec: free struct mlx5_fs_id after an RCU grace period
Date: Wed, 25 Nov 2026 15:24:24 +0100
Message-ID: <20261125143824.690105590@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit 902407bc588575af0ceae5de4f635fe1e024f258 ]

macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable with
rhashtable_remove_fast() and then frees it with kfree() right away.

The TX (SCI) table is read locklessly from the transmit path:
mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
rhashtable_lookup() under rcu_read_lock() and then reads
mlx5_fs_id->id. A transmit that looked the entry up just before it was
removed reads freed memory.

Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
device inside macsec steering") the SCI table held struct
mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
with the new struct mlx5_fs_id, but frees it with a plain kfree().

Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().

The same issue was flagged by the Sashiko AI review as a pre-existing
problem while reviewing the HW-GRO for PSP series.

Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
Link: https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
index efc5167493c12..7d785c937d43d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -94,6 +94,7 @@ struct mlx5_fs_id {
 	refcount_t refcnt;
 	sci_t sci;
 	struct rhash_head hash;
+	struct rcu_head rcu;
 };
 
 struct mlx5_macsec_device {
@@ -684,7 +685,7 @@ static void macsec_fs_id_del(struct list_head *macsec_devices_list, u32 fs_id,
 
 	xa_erase(fs_id_xa, fs_id);
 
-	kfree(fs_id_found);
+	kfree_rcu(fs_id_found, rcu);
 
 	if (macsec_fs_is_macsec_device_empty(macsec_device)) {
 		list_del(&macsec_device->macsec_devices_list_entry);
-- 
2.53.0



