Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619227;
	b=eudxkay/lgQrZ3ZYVJYGw3rlWo00ocITsOKFAV1xHaWKNRBIXpqZKJTYABh3w7vPscHT
	 /ZxEUD/sgKsfkvLgwXH9YRsIUfhpH1praax+5+stWVYFTqZ2hXMRmX2oGPNGfC3Ltq3DI
	 UJqAZQkdk5NRkwl6ehTxKYmZTqajdi1YKw8tyI1c26xMm7N3waz/SCymEX9dKeqB9Y5Pa
	 fCHMXKMITfrFjVb/jWaY7rGex/TbUeBEle2KIDV9aAI5zAzRSvrdoZ2RcHhblONmgC4Dw
	 qEh0MdAUShWUi/BXZI8z37TJZpFTPPWdeE2hChvwXToOflQRuVpdtNxb/7XfePXxUyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=34TCPLdI9s9hkl8XQj8SgzBC8ITjauXTGJYsEOhdjWQ=;
	b=Vvff/U1DroShU0snA7+IqrfSAUpbS0/dUQqWZvHknZkCO1CwETQGG7bOMgajla7uHzvj
	 iPcmSuS8Te8lztHbPskAcdeUy+HAeswOuEa4ATIov9SlI+u0zYhgp5osE3znV2MptB7XN
	 Z9KEwhoq4qt3C8TAlCO/7KsU2Ui0VQ+sY5qjPhCGQpIsGE96yWyWO8KJ8TQ1dY5I+fGJc
	 s8rXQm/vYvpWQKb8rzCah5zICZoIs1qI9ztsfbfkTPx1CbsBJgzbcp4Xu22Pj0f1Z926B
	 L8IxkGzouor/R2BHIm8msTvYhNKeNOO72+UvrIH1q8mM+CdISfLjlrXkQE+7VgBDgoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SWOGdo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73180606A321;
	Wed, 25 Nov 2026 15:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SWOGdo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F2F1F000EB;
	Wed, 25 Nov 2026 15:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619227;
	bh=34TCPLdI9s9hkl8XQj8SgzBC8ITjauXTGJYsEOhdjWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SWOGdo5EsyOeb3ZwVBBqKEf+AfRGLUyMxD1PR7C7qZOLTT0BMIgkLMvhHKDPsPOz
	 Z27ZkVjhiZYZc2GliN/HAAMqfblpTi5SQAxGH/FbsOBtbiqJHGRj8egBdmVxMXFu9R
	 9ELc2WR4d+4iV3OoBcoRBra2ojv2E68BGaZ/xOsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0503/1005] net/mlx5e: Block E-Switch mode changes during IPsec state creation
Date: Wed, 25 Nov 2026 15:30:41 +0100
Message-ID: <20261125143833.528129120@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 0d09de8e4f11391e8468219dbbc7af027e39e9b8 ]

mlx5e_xfrm_add_state() reads priv->ipsec before blocking eswitch mode
changes. A concurrent profile change can free the saved IPsec context
and cause use-after-free.

The temporary mode reservation was added in commit 22239eb258bc
("net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed")
after saving priv->ipsec but the race was actually enabled by the
"Fixes" commit.
Extend the reservation to cover obtaining the context as well.

Use mlx5_eswitch_block_mode(mdev, false) for the temporary reservation,
as policy creation does, to check operation ownership under mode_lock
without rejecting existing eswitch users. This allows reusing existing
IPsec tables while TC rules exist on VF representors.

Check the context only after taking the mode reservation, so a
concurrent mode change consistently returns -EBUSY and a missing context
returns -EOPNOTSUPP, preserving software fallback for crypto offload.
Keep the atomic acquire-placeholder path exempt, since it creates no
hardware state and cannot take sleeping locks.

This was found by Sashiko, during review of the last patch in the
series. No reproduction attempted, as it seems quite a tricky race to
successfully trigger.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105211637.1083978-8-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 37 ++++++++++++-------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 09f51f6fa8675..c1ff8f7a056e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -771,6 +771,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 				struct xfrm_state *x,
 				struct netlink_ext_ack *extack)
 {
+	bool is_acq = x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ;
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	bool allow_tunnel_mode = false;
 	struct mlx5_core_dev *mdev;
@@ -787,20 +788,31 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add state");
 		return -EBUSY;
 	}
-	if (!priv->ipsec)
-		return -EOPNOTSUPP;
+
+	if (!is_acq) {
+		err = mlx5_eswitch_block_mode(mdev, false);
+		if (err)
+			return err;
+	}
 
 	ipsec = priv->ipsec;
-	gfp = (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) ? GFP_ATOMIC : GFP_KERNEL;
+	if (!ipsec) {
+		err = -EOPNOTSUPP;
+		goto unblock_mode;
+	}
+
+	gfp = is_acq ? GFP_ATOMIC : GFP_KERNEL;
 	sa_entry = kzalloc_obj(*sa_entry, gfp);
-	if (!sa_entry)
-		return -ENOMEM;
+	if (!sa_entry) {
+		err = -ENOMEM;
+		goto unblock_mode;
+	}
 
 	sa_entry->x = x;
 	sa_entry->dev = dev;
 	sa_entry->ipsec = ipsec;
 	/* Check if this SA is originated from acquire flow temporary SA */
-	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) {
+	if (is_acq) {
 		x->xso.offload_handle = (unsigned long)sa_entry;
 		return 0;
 	}
@@ -814,21 +826,17 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(mdev, true);
-	if (err)
-		goto unblock_ipsec;
-
 	if (x->props.mode == XFRM_MODE_TUNNEL &&
 	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
 		err = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
 		if (err < 0)
-			goto unblock_mode;
+			goto unblock_ipsec;
 		allow_tunnel_mode = err;
 		if (!allow_tunnel_mode) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Packet offload tunnel mode is disabled due to encap settings");
 			err = -EINVAL;
-			goto unblock_mode;
+			goto unblock_ipsec;
 		}
 	}
 
@@ -904,13 +912,14 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 unblock_encap:
 	if (allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(mdev);
-unblock_mode:
-	mlx5_eswitch_unblock_mode(mdev);
 unblock_ipsec:
 	mlx5_eswitch_unblock_ipsec(mdev);
 err_xfrm:
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
+unblock_mode:
+	if (!is_acq)
+		mlx5_eswitch_unblock_mode(mdev);
 	return err;
 }
 
-- 
2.53.0



