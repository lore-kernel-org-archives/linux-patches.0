Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A38C17BED0;
	Sat, 17 Oct 2026 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253520; cv=none; b=qdAARwpio5QgC+IxhMePoE2BHNjDrIfnXTnldecYH5xBFLrojyUszKIUZINHCZ2e9Pzp2lebvgPggYtOQ/TwIXbB6UYB4f9FKhfa+leQe+CLOx+wJiq9CgjutTdDYng90OmBsNffs1RXiUxAtd3O5YKCJp0fMFexuBEcIV78LHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253520; c=relaxed/simple;
	bh=T2jrSmqGF6ArsRvqrFrNx6zMf044RD8n2suNZtwWQfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZtgh8E1xqT/6MIpPrXd4GR0eArHFsUe4mjsMICLHJ66ThbeGXpqPbPO+3YDTLy2aIC6EnAoEnxqg0SDKfO3x89Diw1QFlNUAev7nl/EjrgM4kGO7K/dcMJv6Cp88azz0NqRvYxDVpjBADSO+AVjSCzSqpugnzf8a0X/OP5xfM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4GbVCC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4GbVCC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AC91F000C4;
	Sat, 17 Oct 2026 16:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253519;
	bh=O59s+1qZ+tvPj75rWMrKg6Yh6gsPjtq8jjwAN4psW+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4GbVCC+IbnqJNguQiQRsost6UV2TIBst7ObLgJyXvEyXnCPenG4P/ESq7gpoLTE0
	 V1G3HJU+wPQurQTAC7FsE1bVu+kiTkr0E/RArwmcJzCfpyyjzIbNDdJAp2nTEzqMVz
	 spoHQ9IT0NSmblyrCYltds8znktHh8Iad6td2qE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/869] net/mlx5: HWS, fix bad parameter in CQ creation
Date: Sat, 17 Oct 2026 17:49:45 +0200
Message-ID: <20261017160040.733716754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 2462c1b9217246a889ec318b3894d84e4dd709c6 ]

'cqe_sz' valid value should be 0 for 64-byte CQE.

Fixes: 2ca62599aa0b ("net/mlx5: HWS, added send engine and context handling")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Vlad Dogaru <vdogaru@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250817202323.308604-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e5eba42f0134 ("mlx5: Fix default values in create CQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c  | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c
index 08be034bd1e16..ad766451cd6ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c
@@ -839,7 +839,6 @@ static int hws_send_ring_open_cq(struct mlx5_core_dev *mdev,
 		return -ENOMEM;
 
 	MLX5_SET(cqc, cqc_data, uar_page, mdev->priv.uar->index);
-	MLX5_SET(cqc, cqc_data, cqe_sz, queue->num_entries);
 	MLX5_SET(cqc, cqc_data, log_cq_size, ilog2(queue->num_entries));
 
 	err = hws_send_ring_alloc_cq(mdev, numa_node, queue, cqc_data, cq);
-- 
2.53.0



