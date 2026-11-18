Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027465;
	b=ZWbG0SIZ3wnnSxCldIZASjtTgWTZP1YsWBO+x2rDKnYsofSQUasxolUXb72Ia4fs+vCW
	 mYQQxsGMKJiQ7rNwQ8O7KFTbMl6HswTAl5QkEWm1SRO8mgjvF4GrTm9BqfZmtBY2WPyWo
	 AWSPBhApGqoeLTcxapM4nTYmRWlqHcFix1dMeBidFPq+iN9k5heLFtLaf4XQQkWl5oBHv
	 ReaSeQc3F8hz+e6DuRrM5Fou7hMA0USyPXB67JUeZ/fneSddNss2UcxWqLhOpQ/1w4sZ4
	 h5bxTgLg8xWCRCzgqvq9k17bk2nokfODCwgoLdwYF2vw+NACnUjp0BnjBfo9GGH5elQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2efgTIcl3evpZPnVRSAUvxUyATT6Q+jabri7p986Psk=;
	b=qdvLe3A9R2zHOOdsfBIlAVN/V+On82eqWrnPF7a0728IaTsTy4CaOu8OD+Mu0SH0JhzX
	 iTjnkkE1VaAXs4GwNQrmVVU7UfPB7CXpSJWP3+wAHEfoII9hCboP114zIPrsjx/lOTfL/
	 7aTHYwdd61sdqmX5IJpmAR91wVLQTIWDFRy1ddNUpz5rUyDMjAD3dB2ZvQw056YSR38Cl
	 7cAQ+T3y3ntTn7e+/Ijq7zwgBeKCsNTdyjuF0ipSjqrHh3J97tz8RZuYEtUsp9XzBrT5D
	 NBA/ZLX9Bdk9U2v+ymZLSO1KpRVRhXCxS7MmR81eSZOMx0mf4ZyxSCtn3JDk492VsCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0vDZ7r3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400D60A2603;
	Wed, 18 Nov 2026 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0vDZ7r3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A21A1F000C4;
	Wed, 18 Nov 2026 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027464;
	bh=2efgTIcl3evpZPnVRSAUvxUyATT6Q+jabri7p986Psk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0vDZ7r361dAfQ8GIcXyxmSCzYFk5PAVKnWbmhvS0T++ZAaJojD8FrTAw0sxY/JJE
	 IiP7b2xT5tEJ2fmvO5K4jMd8V5hVrHQUpIdgKNfJbR34FvCgjDVB5XSIOFmS4Cngtr
	 hi8fbCRIJCNTDuY/h8WV20+vv4YxUKUx4GDlwj3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Alexandre Cassen <acassen@corp.free.fr>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1799/2151] net/mlx5: HWS, fix reformat pool creation race
Date: Wed, 18 Nov 2026 15:58:54 +0100
Message-ID: <20261118150227.343840284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit d730ca15cf3e4806e38fa8fc6f2af8d7405ef2a4 ]

mlx5_fs_get_pr_encap_pool() inserts a new pool when the lookup misses.
Two callers allocating the first reformat of a size at once both
create one and the second fails with -EBUSY. TC serializes these
allocations under encap_tbl_lock while RDMA flow actions on the FDB
don't.

Sashiko AI review of an earlier series spotted this issue.

Tested for regressions on ConnectX-7 with firmware 28.48.1000.

Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261012100555.1317878-2-acassen@corp.free.fr
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/fs_hws.c        | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 5745ba84c3a0f..8267df307c8bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -1232,7 +1232,7 @@ static struct mlx5_fs_pool *
 mlx5_fs_get_pr_encap_pool(struct mlx5_core_dev *dev, struct xarray *pr_pools,
 			  enum mlx5hws_action_type reformat_type, size_t size)
 {
-	struct mlx5_fs_pool *pr_pool;
+	struct mlx5_fs_pool *pr_pool, *old;
 	unsigned long index = size;
 	int err;
 
@@ -1246,13 +1246,14 @@ mlx5_fs_get_pr_encap_pool(struct mlx5_core_dev *dev, struct xarray *pr_pools,
 	err = mlx5_fs_hws_pr_pool_init(pr_pool, dev, size, reformat_type);
 	if (err)
 		goto free_pr_pool;
-	err = xa_insert(pr_pools, index, pr_pool, GFP_KERNEL);
-	if (err)
-		goto cleanup_pr_pool;
-	return pr_pool;
+	old = xa_cmpxchg(pr_pools, index, NULL, pr_pool, GFP_KERNEL);
+	if (!old)
+		return pr_pool;
 
-cleanup_pr_pool:
 	mlx5_fs_hws_pr_pool_cleanup(pr_pool);
+	kfree(pr_pool);
+	return xa_is_err(old) ? ERR_PTR(xa_err(old)) : old;
+
 free_pr_pool:
 	kfree(pr_pool);
 	return ERR_PTR(err);
-- 
2.53.0



