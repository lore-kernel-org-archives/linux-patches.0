Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73DC410D16;
	Wed,  4 Feb 2026 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218276; cv=none; b=sUEYGAY1dfmlst4f4NCtA7eM8e9gCbzhDO6ijPynV2njEVMmwwWVe7DLwHMUgawLX+iVIhAt0CAFxmH3UiFLcaG5oxvJbIPFiFOQ49VdIiG7BKkEJBMj4zn3ZjAsBsDNcby/8nXRUh3Lxw9Bi11PRWZI1dDf9W8VeyLBfq8YAT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218276; c=relaxed/simple;
	bh=CH2F8XAa1O8EJ/nen9WIOEBJgRNtO5qzkqp6CSyAT2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1uImbiq226+Wn6/t40JxqDr8FPRtPDjypqATevWMPFZVOxnJPx/eAbYggOxuUckIN8MIHRCoJAl+9jvTUKUhMfqXfe9Gw6AWA1uOpwry3WG1ODk8Tktytx6qgyyCwPInEvFKeRsjKqMVAaGetwHzA6Yeu3LbIzqVor4RnKJeIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFy0a/SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFy0a/SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBE7C4CEF7;
	Wed,  4 Feb 2026 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218275;
	bh=CH2F8XAa1O8EJ/nen9WIOEBJgRNtO5qzkqp6CSyAT2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFy0a/SRJdy06/aRtEC+cnJ3OL/NbSImCyEqdoYMzGoK2k0eV6okVmnm8QemRO7LF
	 Jd2TxpZLzVjus9+zKG2SRpGUMWC6sumQbN0S3OWUtJzJkSP/+iImxhc5V5kF5PVUh+
	 FNyhvIiTzeo6/SHPIN+X3BPjJXz9bUt1b3wkfM7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Li <gavinl@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 262/280] Revert "net/mlx5: Block entering switchdev mode with ns inconsistency"
Date: Wed,  4 Feb 2026 15:40:36 +0100
Message-ID: <20260204143919.127299452@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gavin Li <gavinl@nvidia.com>

[ Upstream commit 8deeefb24786ea7950b37bde4516b286c877db00 ]

This reverts commit 662404b24a4c4d839839ed25e3097571f5938b9b.
The revert is required due to the suspicion it is not good for anything
and cause crash.

Fixes: 662404b24a4c ("net/mlx5e: Block entering switchdev mode with ns inconsistency")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
[ The context change is due to the commit e25373416678
("net/mlx5e: Rewrite IPsec vs. TC block interface") in v6.6
which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |   19 -------------
 1 file changed, 19 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3493,18 +3493,6 @@ static int esw_inline_mode_to_devlink(u8
 	return 0;
 }
 
-static bool esw_offloads_devlink_ns_eq_netdev_ns(struct devlink *devlink)
-{
-	struct net *devl_net, *netdev_net;
-	struct mlx5_eswitch *esw;
-
-	esw = mlx5_devlink_eswitch_get(devlink);
-	netdev_net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
-	devl_net = devlink_net(devlink);
-
-	return net_eq(devl_net, netdev_net);
-}
-
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -3519,13 +3507,6 @@ int mlx5_devlink_eswitch_mode_set(struct
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
-	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV &&
-	    !esw_offloads_devlink_ns_eq_netdev_ns(devlink)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Can't change E-Switch mode to switchdev when netdev net namespace has diverged from the devlink's.");
-		return -EPERM;
-	}
-
 	mlx5_lag_disable_change(esw->dev);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {


