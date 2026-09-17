Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFB6518148;
	Thu, 17 Sep 2026 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665763; cv=none; b=FUcSeqRoXM1Cr/Z7n4i0eHZr+YlRdtclliY2rKvMKhojo6ObQ2WhWffJdvFB6x3eGWPB+rPOD+SSkRyWprxQoAQHGSP2nkK6s9z9gFWbaFYHgIsltspLspyLD7s7Igj+flFztnLETRQqW5tWpWsAkQ+CMH/EHM3NXKaNuYsX5sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665763; c=relaxed/simple;
	bh=L1aYUBvEuBPOaa67oSc42oSVDDq0MY8868HjEIfVxro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INsynbxzrs6AGEPcgREJbNY6ucVaeRnu/vlYjVSh8IgcfDU2AgomBzPlM1BTFprw2YBVtjCVd5/eVhCNE0uIARrrptYLJATkd1P7/qxa7UndjldoE9dY1+uH3x7Vt6Sx5Ef68OcO7HHni8JrG2g8Wlr3mKAtT9JX/rmY/P/6GVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbXar1YH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbXar1YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A031F000FF;
	Thu, 17 Sep 2026 17:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665762;
	bh=u1UcTAMuMVb4NTF7YkqvPzaKFuo1VSb5O6L1wDbDVg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rbXar1YHK9g/AaPUo2h3MIRTwfY5Uar7+990A+hEjqjbrU9rE0pdHH7fLbBX3Wqkh
	 6h4h58KWh3+b/xquxK7O8wQcPbNED+I0cd9Qq0ypa84XzwFDKdfc5wtALnElAjwuiX
	 EFgqeUmNHpVgd4o07iV1O8/1ZHWjxs/3aJs265hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0811/1250] net/mlx5e: Fix missing FEC mode mapping for RS_544_514_INTERLEAVED_QUAD
Date: Thu, 17 Sep 2026 16:10:06 +0100
Message-ID: <20260917151613.898631931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 802eedcc0b25bb3e1b492f0600ab74325274d53b ]

MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD is missing from
pplm_fec_2_ethtool_linkmodes[], leaving index 4 zero-initialized.
As a result, when this FEC mode is active, find_first_bit() returns
index 4, causing __set_bit() to set bit 0
(ETHTOOL_LINK_MODE_10baseT_Half_BIT) instead of
ETHTOOL_LINK_MODE_FEC_RS_BIT. Consequently, ethtool reports:

  Advertised FEC modes: Not reported

Add the missing mapping to ETHTOOL_LINK_MODE_FEC_RS_BIT.

Fixes: 4e343c11efbb ("net/mlx5e: Support FEC settings for 200G per lane link modes")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902164634.3657606-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 8a07b9e8dc386..1aef0f550b58b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -985,6 +985,7 @@ static const u32 pplm_fec_2_ethtool_linkmodes[] = {
 	[MLX5E_FEC_NOFEC] = ETHTOOL_LINK_MODE_FEC_NONE_BIT,
 	[MLX5E_FEC_FIRECODE] = ETHTOOL_LINK_MODE_FEC_BASER_BIT,
 	[MLX5E_FEC_RS_528_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
+	[MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
 	[MLX5E_FEC_RS_544_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
 	[MLX5E_FEC_LLRS_272_257_1] = ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 };
-- 
2.53.0



