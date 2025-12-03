Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8FC35A957;
	Wed,  3 Dec 2025 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780107; cv=none; b=QBxYAtxMnnurhaYegVXUJu/fpq3kl6tWdtxseTuJgoIM68HohU2KrYD22tVhFj/fndi3mUnmvm+Nc1+iwWwF8rkcyxsPFCrO774tCaQtWYxiUrdat+KNwJp+1UFFvDfjbaT9JYCT34iAxdK8XC1sr0VCETSfB4S/dKgsyTBUoAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780107; c=relaxed/simple;
	bh=1DmaTgZ093tIJcndwQYg0IvzDSHdhn9nmBdflZ9YQ3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUs+0dPNj06+dLNE4ze5q6eIIrUfru4x0JL9RKnD3u4DmoKzX0AfrJisZazQsYCMtKn+K5ZcvT5mXL+aLxSmy+LPRGx5056WB64suiYK5GlY4R5TnDen3Av8tCX/C32Na9Id/MB3nRPbIHSNPrUwUF16jJUIQA6hxnXs7dV43tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqDUvmBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqDUvmBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C3FC4CEF5;
	Wed,  3 Dec 2025 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780107;
	bh=1DmaTgZ093tIJcndwQYg0IvzDSHdhn9nmBdflZ9YQ3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqDUvmBAREBwoCE4W0FsxYp2Wgfc/EBn8FltkL1lKDsYXpNZzx/CBYcd9uLemv+Kz
	 lSzeE0CpsVnLOQuLsY5SC1TfPb40q0zk65GV/ZNZetYDKSymlf7xInLlM8tyADiZom
	 YqoVlS97xId4zomXyq7irViJ812YXndeyAmfOp2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 456/568] net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()
Date: Wed,  3 Dec 2025 16:27:38 +0100
Message-ID: <20251203152457.407023904@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit b0c959fec18f4595a6a6317ffc30615cfa37bf69 ]

The call to devlink_info_version_fixed_put() in
mlxsw_linecard_devlink_info_get() did not check for errors,
although it is checked everywhere in the code.

Add missed 'err' check to the mlxsw_linecard_devlink_info_get()

Fixes: 3fc0c51905fb ("mlxsw: core_linecards: Expose device PSID over device info")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251113161922.813828-1-Pavel.Zhigulin@kaspersky.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 99196333d1324..525973da7abc9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -601,6 +601,8 @@ int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
 		err = devlink_info_version_fixed_put(req,
 						     DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
 						     info->psid);
+		if (err)
+			goto unlock;
 
 		sprintf(buf, "%u.%u.%u", info->fw_major, info->fw_minor,
 			info->fw_sub_minor);
-- 
2.51.0



