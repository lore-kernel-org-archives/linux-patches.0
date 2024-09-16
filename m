Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176F9156641;
	Mon, 16 Sep 2024 12:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488336; cv=none; b=MGQkB7ySx7OV0WM7xu0JZj3Tys8TvzrvoUaul3uFJvrN2K1ChKCfoqGroxHcausP+U0AQtyNwqcgNX+lsnHj1bNJ0RKJbrktDydwM+E7niVQyH1cNQRqHl9DegvEirOBDADkw+0Uj3g+6v0QTBZfNrnS9p3iw52BjLN16pK3TNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488336; c=relaxed/simple;
	bh=ZB8DaBpzkeQvQa78IV06F1r5wPvl8c+DhE1ISQJvg3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrJKBIRVueuW/nKDHZ5N/5e7HdmHwuTnX/J5Q06wnEaRoPJspoX/rkp2B+Qg75tqAdCQ5STrayrFsxXvw1crteeau8uYZ6VVOxx8pKfJOmH3em2hp0Bbf75323cQznvHyKFFUX5rXB/OsfqzLZFeySi4WSVkI/VSdDBLWqFDRFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jvn1rdF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jvn1rdF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95351C4CEC4;
	Mon, 16 Sep 2024 12:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488336;
	bh=ZB8DaBpzkeQvQa78IV06F1r5wPvl8c+DhE1ISQJvg3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jvn1rdF2ntAp4N1lJkWr9MaKJ9aUQq1x8h7obH0gIICGki5feqwkVB+LC0alj246G
	 Ji0rmVvT1S5o5i8m4w+Tn2fpcTyYKPAAm94hQyHaK6uWt17y9L0Y/haTxkwmcubMIk
	 DiNxKCkIm1TIuqmHM10U/lcGgS/XhAob4IZsstYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 078/121] net/mlx5e: Add missing link mode to ptys2ext_ethtool_map
Date: Mon, 16 Sep 2024 13:44:12 +0200
Message-ID: <20240916114231.740923708@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 80bf474242b21d64a514fd2bb65faa7a17ca8d8d ]

Add MLX5E_400GAUI_8_400GBASE_CR8 to the extended modes
in ptys2ext_ethtool_table, since it was missing.

Fixes: 6a897372417e ("net/mlx5: ethtool, Add ethtool support for 50Gbps per lane link modes")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 5b3b442c4a58..9d2d67e24205 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -208,6 +208,12 @@ void mlx5e_build_ptys2ethtool_map(void)
 				       ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
 				       ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT,
 				       ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT);
+	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_400GAUI_8_400GBASE_CR8, ext,
+				       ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT);
 	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_100GAUI_1_100GBASE_CR_KR, ext,
 				       ETHTOOL_LINK_MODE_100000baseKR_Full_BIT,
 				       ETHTOOL_LINK_MODE_100000baseSR_Full_BIT,
-- 
2.43.0



