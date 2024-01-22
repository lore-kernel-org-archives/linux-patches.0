Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D067113DBA6;
	Tue, 23 Jan 2024 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971977; cv=none; b=nJFI7pt6FoWHedu1zLG4WVeZRuLCDuMVTrdf/QmQjJTCPKzmCtWdL9tZyqHpUqCSPWGVz+qmtpGxsvwQzr1CtrdLE0iKhzrKLXiGngvynHPl0u8g9DNo7s9naW6u3qLQusvydBFZZGN7sR2NC3IaLAmOHTlD98VY+q7qXktbes0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971977; c=relaxed/simple;
	bh=erUucxvAv+wtq62Ec0VKgKULTKMtW0d80XZhCAnrv/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHnOLuoiab6x18msmgqTkxlhTSJ60giLRgWGBGWYeN4VDnrG8WDPvWLBJjEIJwWI0TZLVHxLN+FNdw5STOFNVdnsvcevQ/s//+nfPhLmISDTqghb+PHLI4wynpRAaqM62WJ3E35K1DYA/XfrfY5lsIcq4yqu/mdgz0zJU1+TrJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4cUqrpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4cUqrpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC33C433F1;
	Tue, 23 Jan 2024 01:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971977;
	bh=erUucxvAv+wtq62Ec0VKgKULTKMtW0d80XZhCAnrv/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4cUqrpRzStNf34miKVadTAo+GyWkFmuyiXU6wp4kepMMOwySZB/3/NzGtt7n3QiJ
	 pnXetwbh9Ijap113R+qglc1yZyoZGpWUAp8kJMDLOWdFCoRo7AiR3iLVGCTjtSbBDh
	 rEarxo+cWTnDNA7wY0VK65E0FgJl6XW7Ve2O6/yc=
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
Subject: [PATCH 5.10 279/286] mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
Date: Mon, 22 Jan 2024 15:59:45 -0800
Message-ID: <20240122235742.811007111@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



