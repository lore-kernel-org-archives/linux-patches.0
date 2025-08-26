Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592CD33768D;
	Tue, 26 Aug 2025 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208152; cv=none; b=BUnOmjVH4GwBusyAA0gQevAwpbgSFMpY75+vxmbSm0kXB8Zi/j9S4VnhP5hpah3HBojUhlPvk/vQMWfHOrZT+VqECQt+sdKtupT5MFUY9k4mEfuEqgGkQr4br2PsMwG9EjGpod5eUEeBS9MkBlVbw5GxH4WkQhT/mtNG5wdZW0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208152; c=relaxed/simple;
	bh=GFeD4+KORpGa4iRSr6hbJ1IzqdyrgdU/a6tG3rYTCRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW0CzGZrRghUdc8M0VCWO+Oc5r6BESEhYSbTkBlJxAthjhpitX5Ndeo3p5zLEYfRC0Zx3MzaHUrfzuedo4cACb5nSDL9spqzom6kEU4I86mqX201dXWrQdWHx4j2x1da9Xv+YV9ZTVl8bZtDhw2rU82t6WXMH5nR9AA1Uisn/kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ly5ytDr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ly5ytDr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C50C4CEF1;
	Tue, 26 Aug 2025 11:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208152;
	bh=GFeD4+KORpGa4iRSr6hbJ1IzqdyrgdU/a6tG3rYTCRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ly5ytDr1WNwBH1Gk2eJa4pTZgafA2LJqApWrUzqBhJroY4e0zTsSQSDCqVDcgNI4h
	 zaANb47EszoWLEYDdKDB4GxzXayTEqsnNe+jsHLDUdxstKYjxBl1YmNdh2KSr8Hnpc
	 /oXtIuGAcuysaO7m99wzWdnWW7RwARfxZ15PZN1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oren Sidi <osidi@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 449/457] net/mlx5: Add IFC bits and enums for buf_ownership
Date: Tue, 26 Aug 2025 13:12:13 +0200
Message-ID: <20250826110948.384121274@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oren Sidi <osidi@nvidia.com>

[ Upstream commit 6f09ee0b583cad4f2b6a82842c26235bee3d5c2e ]

Extend structure layouts and defines buf_ownership.
buf_ownership indicates whether the buffer is managed by SW or FW.

Signed-off-by: Oren Sidi <osidi@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1752734895-257735-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 451d2849ea66 ("net/mlx5e: Query FW for buffer ownership")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2c09df4ee574..83288df7bb45 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10460,8 +10460,16 @@ struct mlx5_ifc_pifr_reg_bits {
 	u8         port_filter_update_en[8][0x20];
 };
 
+enum {
+	MLX5_BUF_OWNERSHIP_UNKNOWN	= 0x0,
+	MLX5_BUF_OWNERSHIP_FW_OWNED	= 0x1,
+	MLX5_BUF_OWNERSHIP_SW_OWNED	= 0x2,
+};
+
 struct mlx5_ifc_pfcc_reg_bits {
-	u8         reserved_at_0[0x8];
+	u8         reserved_at_0[0x4];
+	u8	   buf_ownership[0x2];
+	u8	   reserved_at_6[0x2];
 	u8         local_port[0x8];
 	u8         reserved_at_10[0xb];
 	u8         ppan_mask_n[0x1];
@@ -10597,7 +10605,9 @@ struct mlx5_ifc_pcam_enhanced_features_bits {
 	u8         fec_200G_per_lane_in_pplm[0x1];
 	u8         reserved_at_1e[0x2a];
 	u8         fec_100G_per_lane_in_pplm[0x1];
-	u8         reserved_at_49[0x1f];
+	u8         reserved_at_49[0xa];
+	u8	   buffer_ownership[0x1];
+	u8	   resereved_at_54[0x14];
 	u8         fec_50G_per_lane_in_pplm[0x1];
 	u8         reserved_at_69[0x4];
 	u8         rx_icrc_encapsulated_counter[0x1];
-- 
2.50.1



