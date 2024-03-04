Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBD010A35;
	Mon,  4 Mar 2024 21:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588560; cv=none; b=jVvvweWmtZNWEH+j1IGH5Py7rC+OXuvs7RWc8CowEVRmTsm61T0zTZqt5/g6FgdyzKGgjDYAaAfW8jt3l8oVKSMSPgzqkf6LpKm2/DtxZlVfsm7vmCYbRjWbVwZHfqOq/Opq045xZ4pCGn5A0AtwslyUibiu/4DMp3wp1oQOZok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588560; c=relaxed/simple;
	bh=GSw/wkq4oUKIdMN5b5IPskoQyCA/m6sY77X7VrD54so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6GYIvYBBbDzTEGhww2eAG4yU3BLzIBS41MWKcYRaJFMOdgU1LbBWO8ZfWIELdkrXQvqLdpEHkL7j5LKUOpePVY9HK706UIfUxfid7nN81Ar+zR8r00v2P+LTPUYJc7UozXNnySGPLAzCYSahvRLdKdCBuyTvYJ2s/Y7Ocni0OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EpUwH7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EpUwH7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96D1C43390;
	Mon,  4 Mar 2024 21:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588560;
	bh=GSw/wkq4oUKIdMN5b5IPskoQyCA/m6sY77X7VrD54so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EpUwH7iD+mtjtlRsxcJ0BYWeZ2FgHNQIyndrhEICiYdgZPfen4p9Wthvsu7hqs2r
	 OQek4Pqjp1zNeLuaMidYGUJ0tmd5rxe4swpiQV4RAmvaMNwrCy44bTLMdWk1jTuG2y
	 2cNsGdjgrhL0GVrd0NUBrqolGipmTIBtaZWHRlyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/215] mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
Date: Mon,  4 Mar 2024 21:21:13 +0000
Message-ID: <20240304211557.341849644@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 65823e07b1e4055b6278725fd92f4d7e6f8d53fd ]

Pair mutex_init() with a mutex_destroy() in the error path. Found during
code review. No functional changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 2107de4e9d99b..41eac7dfb67e7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -52,8 +52,10 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 		max_regions = max_tcam_regions;
 
 	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
-	if (!tcam->used_regions)
-		return -ENOMEM;
+	if (!tcam->used_regions) {
+		err = -ENOMEM;
+		goto err_alloc_used_regions;
+	}
 	tcam->max_regions = max_regions;
 
 	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
@@ -78,6 +80,8 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	bitmap_free(tcam->used_groups);
 err_alloc_used_groups:
 	bitmap_free(tcam->used_regions);
+err_alloc_used_regions:
+	mutex_destroy(&tcam->lock);
 	return err;
 }
 
-- 
2.43.0



