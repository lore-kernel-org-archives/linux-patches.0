Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EA8200D4;
	Mon,  4 Mar 2024 21:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588586; cv=none; b=UjyyhTshGng3wf+zUdX3sLwZYob3NyHFofEAWT9LMl6cfQbrrRawPJfIATP3roiN7txLGzLFChBQWqVbl+eFC6N/zpL4U9DnTJds8BkT3AIdm6oTikftE4eWTEsnuKpjlJaHlccDdm3Ep2l45ubVWnDl4lrITgxsMVxeKvrwmAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588586; c=relaxed/simple;
	bh=SJiYvQhR0fX4uIAb4jttxf/CsuGsjzRtLXL8SdbbN28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFJ66DBp/cHWRSG7f7DenH3S73HMOhWXw8YIri3+ngZmfCSQy1mW/9x/W12dZ9pufV+aNLJ+AOZCQH0T3QbtpvVTRpkqdrzriJXV9JOpMPbl3CbaBkjZICP3Dh9pEw5XPuoP5FbxAfRLx44uBW/czU5FUsXs+noaO1kuF/BFs5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZHzehI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZHzehI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86271C433C7;
	Mon,  4 Mar 2024 21:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588585;
	bh=SJiYvQhR0fX4uIAb4jttxf/CsuGsjzRtLXL8SdbbN28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZHzehI0l5/F9mJNh+28AJM0t2z3ZFcRSsQw+8NhxwCT4yxG5mFpxJCijhO6A/FWT
	 vd9bSfUNbz/wkhbrdH5OjipYCJIFygjZAxKnprWb/8LwW5VkqacOxIo9TYpALCszcZ
	 dk48lQVR86XkXp6LEckzOdOKpHVc3hX0IOwhJndE=
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
Subject: [PATCH 6.1 009/215] mlxsw: spectrum_acl_tcam: Make fini symmetric to init
Date: Mon,  4 Mar 2024 21:21:12 +0000
Message-ID: <20240304211557.307078428@linuxfoundation.org>
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

[ Upstream commit 61fe3b9102ac84ba479ab84d8f5454af2e21e468 ]

Move mutex_destroy() to the end to make the function symmetric with
mlxsw_sp_acl_tcam_init(). No functional changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index dc2e204bcd727..2107de4e9d99b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -86,10 +86,10 @@ void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
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



