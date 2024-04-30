Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9563128816;
	Tue, 30 Apr 2024 11:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476685; cv=none; b=ZQDyuXQ2uXXufrhy0pvHJfvrLQQATohiu0tNMRZl/6Fua58NRYNitWjav9/zoRIYdKJILF1d86oAlCyZT7YuK9+Kp8t7tf9RQZclDeKD/N6wa4yVHZy4D5aJF7DEUmzgF2Mcl7c5LSEVBmDJeppUT9V38UriciPABObHjRyljds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476685; c=relaxed/simple;
	bh=L3Ez2HMf50wIoFbdBtUaQc1kZBJK2I+wiZP0+X5YdVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bReAScIcMAiBvhW07ZxPYlCN0SB8sKnQ2UVbwEJgEZNJrbSBY8W6jnj9ClvLlHUTxU8hi/z2XaE76yXMiIupjfxVtV6kV5w5cwyzKDAIugYV622f+Ku/VhlXSRzy+/bET3jHkl9H0RRjUzi0rI2Zau0j9W6pH+XMxTYl7qTN6gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVGYHqQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVGYHqQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260EAC2BBFC;
	Tue, 30 Apr 2024 11:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476685;
	bh=L3Ez2HMf50wIoFbdBtUaQc1kZBJK2I+wiZP0+X5YdVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVGYHqQyZe5oDIB+CSsp1PO+0+byMnO+J8/TyMHbi2pEGaUqIRg5OjTibLiBV85Bu
	 TTboP6KvL9Lu9JMC1k6WAvcGuzO4grx3l4oIilocVRYhdh9fDn6QbgijtVh5Drn8Oz
	 Y6YgqUiIIDCZvganY259L+nN0WuqVYzkYKSy0i6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 110/110] net/mlx5e: Advertise mlx5 ethernet driver updates sk_buff md_dst for MACsec
Date: Tue, 30 Apr 2024 12:41:19 +0200
Message-ID: <20240430103050.822626711@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

commit 39d26a8f2efcb8b5665fe7d54a7dba306a8f1dff upstream.

mlx5 Rx flow steering and CQE handling enable the driver to be able to
update an skb's md_dst attribute as MACsec when MACsec traffic arrives when
a device is configured for offloading. Advertise this to the core stack to
take advantage of this capability.

Cc: stable@vger.kernel.org
Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20240423181319.115860-5-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1703,6 +1703,7 @@ static const struct macsec_ops macsec_of
 	.mdo_add_secy = mlx5e_macsec_add_secy,
 	.mdo_upd_secy = mlx5e_macsec_upd_secy,
 	.mdo_del_secy = mlx5e_macsec_del_secy,
+	.rx_uses_md_dst = true,
 };
 
 bool mlx5e_macsec_handle_tx_skb(struct mlx5e_macsec *macsec, struct sk_buff *skb)


