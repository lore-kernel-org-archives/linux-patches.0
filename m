Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E013DBB7;
	Tue, 23 Jan 2024 01:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971980; cv=none; b=CWi7erzVDAI4Siij1LFE4KZn79p2aueF+hnS06+hSKDIWKaeOsKCnk8Oq3c+r7lC2i2mcNwDaiKN1BWni0PFZ10khJfhJbaUU/V1DTJXjoJbP8/UFAtNlxE2wjbtPrOIY9nPbHAwFfPkALT7NCwvGyf0dKnQyUm9lwdUuPQMT1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971980; c=relaxed/simple;
	bh=gvCaObOaoypwu/sRWKV79RXWnppku0JMPByJj4Y1aiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXLPDk2h0L//DfMSS4Ef967ndq3Dmuw3NyCDTvacBAQLKLhkSi8X5LTYtIvHKY3tbREoirRbrNrfnncjsYKqd6yd2IW2bqfABlPsxLbwhNmInJbFVhouitml3gjTH7j1RL+2pZFKO5lgwTQ4iPrVtzupBnZagNSnXZmEFpc5tTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2a1yCHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2a1yCHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150C1C433F1;
	Tue, 23 Jan 2024 01:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971980;
	bh=gvCaObOaoypwu/sRWKV79RXWnppku0JMPByJj4Y1aiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2a1yCHjl3XSl8m6ww0Ayk7XR9lJEqVNVrl+bf4YSiYTYJmwLYWGIBku+qXJMC4ge
	 LMamVC8oB42fMbYaft470Ya4nXDlSG/NzRsbPu1M1Bvj7sQLYeo98L+f/5vIXwJhNU
	 EEyUhEE9q4zRrSVa5187Eb1DproYdjtyKYp6mINc=
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
Subject: [PATCH 5.10 280/286] mlxsw: spectrum_acl_tcam: Make fini symmetric to init
Date: Mon, 22 Jan 2024 15:59:46 -0800
Message-ID: <20240122235742.848911256@linuxfoundation.org>
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



