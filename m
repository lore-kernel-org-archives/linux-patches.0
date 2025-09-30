Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C7C23506A;
	Tue, 30 Sep 2025 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244686; cv=none; b=G+0okpHgvB8sI3KBgtCh8q145nwT0hPeqEicL17fb5PGmnS9y0L24EA9pNOLBRbBgf7r44XW1MsdvLWZP8RbZSlflk0SFISSL6OqcY4C8xfD8Rv/fBPA4+MVWH1rVQjcV/+cSB1iArEJMM1CwRRHRwyGgnMsvHOaWqZ5ppbmkZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244686; c=relaxed/simple;
	bh=RguUYyxXh6oJxL3oKNVIuTIvhfR+2ttaqU+jUT5W86A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG7QRndQObFrbyy5Q3sQlQvLPGehKZbrhquIMr8BmJcZBp0WHluWYjKCqJl4ABo8H7dVjgXB7vyl1e1LoDldpNULpgaJOlzjLvPwRwATKSgYc+p54vDHfRWTqmOB1fXV5rzGwMQLAwR6iSrdmEGmiMW4NRtSKBfkSfOwaI1eBiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8haVFZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8haVFZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CCFC4CEF0;
	Tue, 30 Sep 2025 15:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244686;
	bh=RguUYyxXh6oJxL3oKNVIuTIvhfR+2ttaqU+jUT5W86A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8haVFZXcE9faPng6haUBcqG8y2tYvk/69s17v5l+pZOK8mQ80fVAo3tN65Jces+S
	 NZI/mAbgs7mlJ9zj2CCYC8+ThNVLnLXb7kcmv5oQoFgJfMmWBgIXyzcfsNp90Tjd9N
	 Ss/fPW11ladFNu2pz9Xta4lhjhIwfHo2Ap2UA62E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 082/143] net/mlx5e: Fix missing FEC RS stats for RS_544_514_INTERLEAVED_QUAD
Date: Tue, 30 Sep 2025 16:46:46 +0200
Message-ID: <20250930143834.506475588@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 6d0477d0d067a53c1d48d0aff1fd52e151721871 ]

Include MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD in the FEC RS stats
handling. This addresses a gap introduced when adding support for
200G/lane link modes.

Fixes: 4e343c11efbb ("net/mlx5e: Support FEC settings for 200G per lane link modes")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1758525094-816583-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 19664fa7f2171..46d6dd05fb814 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1466,6 +1466,7 @@ static void fec_set_block_stats(struct mlx5e_priv *priv,
 	case MLX5E_FEC_RS_528_514:
 	case MLX5E_FEC_RS_544_514:
 	case MLX5E_FEC_LLRS_272_257_1:
+	case MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD:
 		fec_set_rs_stats(fec_stats, out);
 		return;
 	case MLX5E_FEC_FIRECODE:
-- 
2.51.0



