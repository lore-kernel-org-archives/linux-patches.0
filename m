Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E6A1DE4FF;
	Wed, 19 Mar 2025 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395167; cv=none; b=kC8TkryK9l3pjBftGnoXe2CZ/NDstVjR9Z9t9/KYwYB6bPHmGMbvORpiJ6VWgrYYnqDSCAfNBBV3fAvlXq9E8RrQlzo0+CasEKWoSkyWjVpTemPpVRxUkjJDLJQhIKLhrSKocoKAitMmA+tvPDKejQwykzquH1D3RumoUX1gYl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395167; c=relaxed/simple;
	bh=kIxAx/tlXnvggueC7HNkmUhgScjDtfm+eUMjJ4J4PIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3hS2y1J04g5TQBlqvc6kqYAP1a/D6Ip1r22ZnMdY2V4UMaZh4hd2vz1sgrUrUb2xE4Aik5V36jCYMOlRJ4yKgtU4knCIusw26Gwom7W1UuKGBCr87L6c+PuWRN9qYi8G+nHfuIzH6hZeCzYrReOW8/aaEFSqbplaWLL94uYMdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/yG2e4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/yG2e4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6D2C4CEE4;
	Wed, 19 Mar 2025 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395167;
	bh=kIxAx/tlXnvggueC7HNkmUhgScjDtfm+eUMjJ4J4PIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/yG2e4VfvxEANUDuLGk6n8d72rcR4tOUMVsHJA7uIv/F518kDF+owDL4xZ9vYtSF
	 uAoXIVysoO5CkDmJ2aXeNOMnBbIFdmuy3G2qE4yUwkdD+np2t7/7Utn8ZQr98q1C/Q
	 fExK+ftcIATZFXQ/8nLdmWWWfDOlyEjBYarc2e1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/166] net/mlx5: Fill out devlink dev info only for PFs
Date: Wed, 19 Mar 2025 07:29:48 -0700
Message-ID: <20250319143020.448346514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit d749d901b2168389f060b654fdaa08acf6b367d2 ]

Firmware version query is supported on the PFs. Due to this
following kernel warning log is observed:

[  188.590344] mlx5_core 0000:08:00.2: mlx5_fw_version_query:816:(pid 1453): fw query isn't supported by the FW

Fix it by restricting the query and devlink info to the PF.

Fixes: 8338d9378895 ("net/mlx5: Added devlink info callback")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/20250306212529.429329-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1bccb5633ab4b..f66788a2ed77e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -46,6 +46,9 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	u32 running_fw, stored_fw;
 	int err;
 
+	if (!mlx5_core_is_pf(dev))
+		return 0;
+
 	err = devlink_info_version_fixed_put(req, "fw.psid", dev->board_id);
 	if (err)
 		return err;
-- 
2.39.5



