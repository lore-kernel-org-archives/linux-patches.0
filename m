Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0853DE560;
	Tue, 30 Apr 2024 10:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474300; cv=none; b=sLPjkNqPYcgelR7rEKu2B7O52hUBMSOsyek2GddjvRQGK+VY8E4I7aQr8BtMRhHfh//NHGLc0CtIyopQJM645JUB3CTCSiGH0jwHcczBVG7SNV4gyMM5L20VDIXfw1mK4jWbtQQtMCnHtb2aVDS9KhdK3EIH3It9JCsWSS6IegY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474300; c=relaxed/simple;
	bh=EMr6XvL6kn6bgfjqQhVxEjRK+yX7k4A+fALhE7mPXj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijahh6iQpobobGzcRxyv9JKclhRxGCQCwwIZKhrPBjhnUTxCkRbV24B2QJ/iYGlKcOYd6+wpeK4UVR951u4iCXiCuX5piLN6bOG0kRY2Xo+fQR16yYL+9qoY0QjVF8+7LBo192a3/Lkc2I+I05L/3fm+zrqbzFZwftw8KWnHoKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2MEVNUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2MEVNUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E41C2BBFC;
	Tue, 30 Apr 2024 10:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474299;
	bh=EMr6XvL6kn6bgfjqQhVxEjRK+yX7k4A+fALhE7mPXj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2MEVNUFuXJomB1FJMxx3iuyPZyP7ZdtTB3kkKSak/03mO13C/tanPDbtLi7E73lV
	 cKdAh24w/82qYiPfjiKJMROg+n0HpsSjuOWGFk+u5EgCFffbo19fFQ32lEogSIt/E8
	 mD7B1iYcXnCzu1kxvH9TTih1aAdkcVXRtkZSPaYE=
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
Subject: [PATCH 6.8 099/228] mlxsw: spectrum_acl_tcam: Rate limit error message
Date: Tue, 30 Apr 2024 12:37:57 +0200
Message-ID: <20240430103106.656362148@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 1ff0b2c7c11de..568ae7092fe0e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1450,7 +1450,7 @@ mlxsw_sp_acl_tcam_vregion_rehash(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_acl_tcam_vregion_migrate(mlxsw_sp, vregion,
 						ctx, credits);
 	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
+		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
 		return;
 	}
 
-- 
2.43.0



