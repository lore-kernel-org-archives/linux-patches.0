Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4FC8635C;
	Tue, 26 Aug 2025 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756209008; cv=none; b=EpXVEqckreVp4eTfjVy+bPJz78m+dKija1H75UEehH6fcwzEYLlub/1VkR1L+XiQvQgq43dBwmAiXR+GGPfd3tPbAsFdtd1rR87E0eiVWbQgfm5X/SWweRhQVQIygsavXI2LvEYzCbeIsI5hxOioW23VEWNPONOMuhwGNmkAV/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756209008; c=relaxed/simple;
	bh=TU9OKUFSEgToJboc98V/0Q7VSvPGjY6HyV3SyNZbESU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNTWYFwO0wNwL5+OWrEh4eUJUtEXaDVlsKOyELqPdNvzlEwQ4y+SJrCNhTwE3X9BIt9nA2C+z3TjkMoWWwcKkOc4ho6F/BPQVUJJ34ltB/7M1pleSYemzPLn7zqfQgxmcdVljGmrO7r/1AL1+dLAC7BtcC39v6HwQwMPyVlgbqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLw2ApOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLw2ApOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ABEC4CEF1;
	Tue, 26 Aug 2025 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756209007;
	bh=TU9OKUFSEgToJboc98V/0Q7VSvPGjY6HyV3SyNZbESU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLw2ApOXW5vkhvE4Gitr97hL42q8dknxWNbux8GpIfV0YUhCOcRs1ldZZs8Y/ZX+f
	 xw6hpi3NmmwBmD4BkhLFmgMvDxDm7oxpERE3XmUVeuSHCXBN42vDfykO7fBvQ5sCLq
	 qaUMygrYj7F3DHrZ/2xDKfaNSkdnv8jjQnwOXcyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oren Sidi <osidi@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/322] net/mlx5: Add IFC bits and enums for buf_ownership
Date: Tue, 26 Aug 2025 13:12:10 +0200
Message-ID: <20250826110923.667704908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 512e25c416ae..2b1a816e4d59 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10358,8 +10358,16 @@ struct mlx5_ifc_pifr_reg_bits {
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
@@ -10491,7 +10499,9 @@ struct mlx5_ifc_mtutc_reg_bits {
 struct mlx5_ifc_pcam_enhanced_features_bits {
 	u8         reserved_at_0[0x48];
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



