Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128AB282F3A;
	Mon, 23 Mar 2026 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282456; cv=none; b=OkPnXec7SHkeu+QfF4IYeyt+c1xn7/AA52GpijihUaRohb++cd0L4BO3FzOJQ2JAd2dsN7GiMWSpRz5zgYIUgWW54VLdQ5HnfxRJslo24gi8BQRVmxgAMsLshGnKyJpBgbwCTRoonDrZMaXZT84x0XRM3JWoqMG+PJKfAqLP13s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282456; c=relaxed/simple;
	bh=NshCl6RgegHC4W1UTrm97hWXRRUwV7IyB3canFvhb3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4yKjwZDIcwLaljvwdHg9SHPA8JfDINSXsF6b51oJudAkFYhEYYWx8YSqpAnlF0MDTankiKYmpcYVvjLRqBa0JfW3Y6A3pjJR/inqzFMm7aesuLZlqIPtZaO6SqcpArhudcqXxxoYTgHXEu9RY82Hr9qdPHSUxzptNznu+Z2Scw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTELN97c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTELN97c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ACAC4CEF7;
	Mon, 23 Mar 2026 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282456;
	bh=NshCl6RgegHC4W1UTrm97hWXRRUwV7IyB3canFvhb3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTELN97cYCbOCld2VR1ozTR+3XePgEpxEVxuCMVZI+Rij5SSG399eg1kBsNV5Fpfd
	 8sX5+V5eFP+1lKrvDUGlZz3LwioURQC8xyPP9iDe+voD/+TefDLrDgnsaOp2HwftGs
	 jCr3Z1TdIwy0qetylT0rjgtcGVbUBqbIY/K8NzzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/481] net/mlx5: IFC updates for disabled host PF
Date: Mon, 23 Mar 2026 14:42:25 +0100
Message-ID: <20260323134529.204987305@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit cd1746cb6555a2238c4aae9f9d60b637a61bf177 ]

The port 2 host PF can be disabled, this bit reflects that setting.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1752064867-16874-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: aed763abf0e9 ("net/mlx5: Fix deadlock between devlink lock and esw->wq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4df7b3d358607..9610b325f2b61 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11496,7 +11496,9 @@ struct mlx5_ifc_mtrc_ctrl_bits {
 
 struct mlx5_ifc_host_params_context_bits {
 	u8         host_number[0x8];
-	u8         reserved_at_8[0x7];
+	u8         reserved_at_8[0x5];
+	u8         host_pf_not_exist[0x1];
+	u8         reserved_at_14[0x1];
 	u8         host_pf_disabled[0x1];
 	u8         host_num_of_vfs[0x10];
 
-- 
2.51.0



