Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744A7657D6;
	Tue, 23 Jan 2024 01:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975088; cv=none; b=PDNnvZZYpleu5wr27quCPQzy5w8JbK+Z5fbDQ9qH5mk2ifGXDZtdbsbee+YeYhzI4GsxfPDdRc3UlFAxrDYA2Ha9AifZTYUbQCLHbDov8FizdkJFWKDEpIss8J9us3oZzKhZWK2y+/DMEJXQcGUHbBM43hzI2kJr8/GgL1YcmUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975088; c=relaxed/simple;
	bh=llwV6XSjMWTCBJSOWR6BcisvfnNmBgdzxeoxd8/daGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAFlMTIddNLWfB2Ek57g83W9pMC/p/8tgHP3/NdKv8EwLlZ8YqnDOT3+N3aj0Xm5BBZkzrq58h2Yuw+ebGMHaB+bI52JJMXa6Bs9OD36jVLwGXpgV50ACCShOildpIYrCq+eH7yv6iW6hRJUN4FNBbpOMnv+KpTlOP10MkeZu8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1o6teaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1o6teaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3589EC433F1;
	Tue, 23 Jan 2024 01:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975088;
	bh=llwV6XSjMWTCBJSOWR6BcisvfnNmBgdzxeoxd8/daGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1o6teafMc7f3Ygq2cDtXZvrdXJ95EF4/ESl/F/TOqgw1iz5XoaGzeAB3TGMosRgx
	 BSe6Vn2Dmsih0Ppl/DkfIbk06FTTpMkROA3TTzYDKyhdB47VEa2yiZaZzpqFNu1aK7
	 GCBmJD2AtLCc52LORHimajuJQhJw2euHM4TEil7U=
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
Subject: [PATCH 5.15 360/374] mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
Date: Mon, 22 Jan 2024 16:00:16 -0800
Message-ID: <20240122235757.470265155@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 483ae90d8f97 ("mlxsw: spectrum_acl_tcam: Fix stack corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 31f7f4c3acc3..c8d9f523242e 100644
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
@@ -76,6 +78,8 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	bitmap_free(tcam->used_groups);
 err_alloc_used_groups:
 	bitmap_free(tcam->used_regions);
+err_alloc_used_regions:
+	mutex_destroy(&tcam->lock);
 	return err;
 }
 
-- 
2.43.0



