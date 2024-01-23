Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF8657DE;
	Tue, 23 Jan 2024 01:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975090; cv=none; b=Pg2txrqrT6LB6ffcLYcVhZtQU4EKKneGJkAxWYCoVRebrp9ryP6ohTZ7vSu9iCY+H4gEM8G/FuAaez9bRuJlzpZQSUSbH1zrTe81USbl3q2Ihyp5RRPlPQqUU47iw0eBZIQNPRRDFTuDNiVEkCxKFcCzwa6AQzR2UWZQCcPZZMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975090; c=relaxed/simple;
	bh=XakQvIxb+vpvmodPpMau3wBY9I/9a39qxuFAS5ta338=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gi9VRvpgpHYplx0vNftRK7r4O+HSpc14Vr+bNtx77RgFECVR09soYIpL+cKtv2JdZFNG4ZWgB9VNy6Y3/EHdb1Gf1OdR2EcibnqQiXzWg5jQDi3FFhSBrRtzygCCTZo9fUQuwvMFvAKzcZ71XhVPV8UcoUshiLnMsCu8P6NJSnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/yYOelt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/yYOelt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D54C43399;
	Tue, 23 Jan 2024 01:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975090;
	bh=XakQvIxb+vpvmodPpMau3wBY9I/9a39qxuFAS5ta338=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/yYOelth7pKWGdHM575CW47DP3bkgNVm6aNhz56YwC4ExDbc0kufOiinaTnD9LLP
	 gz6FgUVihE/KgivaFMZDLs11vKTXV68LUFU0EPmPYjxWkUw6LSAUf2cMW3GhDpEtiT
	 zc9HDgSvRm+1sP33N3XRp5RQQdFpbYvjqGE8cShI=
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
Subject: [PATCH 5.15 361/374] mlxsw: spectrum_acl_tcam: Make fini symmetric to init
Date: Mon, 22 Jan 2024 16:00:17 -0800
Message-ID: <20240122235757.508000957@linuxfoundation.org>
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

[ Upstream commit 61fe3b9102ac84ba479ab84d8f5454af2e21e468 ]

Move mutex_destroy() to the end to make the function symmetric with
mlxsw_sp_acl_tcam_init(). No functional changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 483ae90d8f97 ("mlxsw: spectrum_acl_tcam: Fix stack corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index c8d9f523242e..08d91bfa7b39 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -88,10 +88,10 @@ void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
 {
 	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
 
-	mutex_destroy(&tcam->lock);
 	ops->fini(mlxsw_sp, tcam->priv);
 	bitmap_free(tcam->used_groups);
 	bitmap_free(tcam->used_regions);
+	mutex_destroy(&tcam->lock);
 }
 
 int mlxsw_sp_acl_tcam_priority_get(struct mlxsw_sp *mlxsw_sp,
-- 
2.43.0



