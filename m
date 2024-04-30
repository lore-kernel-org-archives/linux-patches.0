Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD9C17592;
	Tue, 30 Apr 2024 11:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476489; cv=none; b=r9+uvTLXHOFBizlXmDY2xlgYxWDqTESKEuFHTrYceW4R6TbH/4tN9x2ed5nUJDs6/VlF7O/N29bAlMx4sVWxyFVa4Cj6YdWIR3YA9KF/XH6smY3PdQ4te2YvHKDzrN6RI0cP//1Y9yJBryRatgHcgiaitSVD5QUoM/i+TKCqzPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476489; c=relaxed/simple;
	bh=TtjWmCJLUc3M0HlbdUFiQUGA/JKVqy45+hBHNCKLzv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDZNAV76WduANbC3c6ipbf5SusugpcS8B9DwrPOyqskgFbHeBYEhvwmOff6I4a8UYiSVd849Vw1wXeqkjacyyUIxv4cZsV3Da6K76sGZ7iOM7PGiNNs3dLutjQTGt7IYIOWJ6ArBElicUI3QQJ1DLFBKE6WjzLEIMabGIRVHnRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlkbzT5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlkbzT5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE516C2BBFC;
	Tue, 30 Apr 2024 11:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476489;
	bh=TtjWmCJLUc3M0HlbdUFiQUGA/JKVqy45+hBHNCKLzv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlkbzT5Scipv1I+2K93/PpGvHbjrCRwWynyGrLe73EhlqEEUEJ4gmZUGTudxcDLZA
	 /Vjr4VkXH/Yq0jZUJTT6FfDeNcLzMDcT2kWJWr4wC35Y3mFv/f2dcE/DY16AeFt3oi
	 Wu4CfnDZyBnwsNAdi6yrH2oLfnpWKZlM9yLKHewc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Alexander Zubkov <green@qrator.net>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/110] mlxsw: spectrum_acl_tcam: Rate limit error message
Date: Tue, 30 Apr 2024 12:40:16 +0200
Message-ID: <20240430103048.956800212@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5bcf925587e9b5d36420d572a0b4d131c90fb306 ]

In the rare cases when the device resources are exhausted it is likely
that the rehash delayed work will fail. An error message will be printed
whenever this happens which can be overwhelming considering the fact
that the work is per-region and that there can be hundreds of regions.

Fix by rate limiting the error message.

Fixes: e5e7962ee5c2 ("mlxsw: spectrum_acl: Implement region migration according to hints")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/c510763b2ebd25e7990d80183feff91cde593145.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 44c750e1025ac..b0396cbf3cce8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1547,7 +1547,7 @@ mlxsw_sp_acl_tcam_vregion_rehash(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_acl_tcam_vregion_migrate(mlxsw_sp, vregion,
 						ctx, credits);
 	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
+		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
 		return;
 	}
 
-- 
2.43.0



