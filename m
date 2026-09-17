Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB34E020C;
	Thu, 17 Sep 2026 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659565; cv=none; b=Cz6LTp9ucUWt2Y5C96PzZy7XQ2kw7JCeSA+o7V/CSluaPt6VDUNUcsHgKWx1u/kNT0LOBaYRNSx5/diwBjmxKN8nZGLpxOLCV0mxcYSTEXJ96j5We3f6gcGxEIyQKGLdYUBuk6PXUsE153nrtDKBbYxZp1YuSBNMx9XFhXo/Mj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659565; c=relaxed/simple;
	bh=2rfmqC8OwLxuygfGcaKCtmntDWBowgKes3NQUoH9WZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRu3bOUQabWwLS78HasriqKPNVfx11WyfvPQWnucovOUoC7jraVQyB/cs8dWBOXqc9LyJF6FkdDe/U8O+65FzDJA+pAJ7nM5ua7hnsJL3yASb2sgj61NbkQEKmv040/zR4EtGNfelldHo14NBXY313SqjeNNqV9coPNcuxwewXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3dLyosu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3dLyosu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72C41F00893;
	Thu, 17 Sep 2026 15:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659558;
	bh=mRzoyl2utnER0ez8EI1oAR60DqJlHO11mnqwrbSUkeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3dLyosu+YczXd3IzSKxpPHY466HXPmO1jrNIFI2V/ANO+lq9aXdVjhBydoe8y1f4
	 4LAhVS0kfO38R6E73W/aWUtEhNEV11T3gc5s25AcbpXJ5+bX2ll+R9YcmztRnWtbgA
	 KcXITqelLL9zlxherXj+UHVtpurmIwkj4vQAN5eE=
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
Subject: [PATCH 7.2 298/733] net/mlx5e: Fix reporting support for all RS FEC variants
Date: Thu, 17 Sep 2026 16:10:06 +0100
Message-ID: <20260917151358.855595516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit c84ce45a7a3f3f024502c7f53308db9c76e4ae71 ]

get_fec_supported_advertised() populates the FEC modes reported as
supported to userspace. The MLX5E_ADVERTISE_SUPPORTED_FEC macro only
checked MLX5E_FEC_RS_528_514, causing devices that support only the
other RS variants (RS_544_514_INTERLEAVED_QUAD or RS_544_514) to not
advertise RS as supported to ethtool at all.

Introduce MLX5E_FEC_RS_MASK covering all three RS bit positions,
update the macro to accept a bitmask directly rather than a single
enum value, and pass MLX5E_FEC_RS_MASK for the RS entry.

Fixes: b5ede32d3329 ("net/mlx5e: Add support for FEC modes based on 50G per lane links")
Fixes: 4e343c11efbb ("net/mlx5e: Support FEC settings for 200G per lane link modes")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902164634.3657606-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h    |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 12 ++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index fa2283dd383b0..53dbdf77bccea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -66,4 +66,8 @@ enum {
 	MLX5E_FEC_LLRS_272_257_1 = 9,
 };
 
+#define MLX5E_FEC_RS_MASK (BIT(MLX5E_FEC_RS_528_514) | \
+			   BIT(MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD) | \
+			   BIT(MLX5E_FEC_RS_544_514))
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f285ad88b6d5a..3ed59ced0407a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1002,9 +1002,9 @@ static u32 pplm2ethtool_fec(u_long fec_mode, unsigned long size)
 	return 0;
 }
 
-#define MLX5E_ADVERTISE_SUPPORTED_FEC(mlx5_fec, ethtool_fec)		\
+#define MLX5E_ADVERTISE_SUPPORTED_FEC(fec_mask, ethtool_fec)		\
 	do {								\
-		if (mlx5e_fec_in_caps(dev, 1 << (mlx5_fec)))		\
+		if (mlx5e_fec_in_caps(dev, fec_mask))			\
 			__set_bit(ethtool_fec,				\
 				  link_ksettings->link_modes.supported);\
 	} while (0)
@@ -1030,13 +1030,13 @@ static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 	if (err)
 		return (err == -EOPNOTSUPP) ? 0 : err;
 
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_NOFEC,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(BIT(MLX5E_FEC_NOFEC),
 				      ETHTOOL_LINK_MODE_FEC_NONE_BIT);
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_FIRECODE,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(BIT(MLX5E_FEC_FIRECODE),
 				      ETHTOOL_LINK_MODE_FEC_BASER_BIT);
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_528_514,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_MASK,
 				      ETHTOOL_LINK_MODE_FEC_RS_BIT);
-	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_LLRS_272_257_1,
+	MLX5E_ADVERTISE_SUPPORTED_FEC(BIT(MLX5E_FEC_LLRS_272_257_1),
 				      ETHTOOL_LINK_MODE_FEC_LLRS_BIT);
 
 	active_fec_long = active_fec;
-- 
2.53.0



