Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF001E2834;
	Wed, 25 Feb 2026 01:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983593; cv=none; b=VM9Q2zD/bBV5jTDz84nB48TZtsk4rFFDB3P9FktwV8UY5oyKiv8CkQSnWSVDDJ9n3PTB2NQucQe7XASxxciurJ3cOVUEUb1Eg0vPRTMVYM1mix8e3QNadqPRplfOxe852Xo6T4MuQUJEgueBPtJSMCEjHPA2BtJRsumpuFSFvZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983593; c=relaxed/simple;
	bh=spO1g7q2mYWiJqioBsCdnA9zoRbZ8phgffo1obS6irQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVbFzeRosKSEQxkLhU5g0UYuOXSyFMLF8nBtbrUJZgMz6hsmglYkk0ZXA596lypt3+pJju9SqIfYPIubpHibUmq8dAYPYjA73XlsWTQZm1hGnH3Rj9rzFyqoDRzXtvgHkw+KI8a+jQRnIUQLDYeDi2TvxWc0+eMqHdCroTIyY9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJre8y40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJre8y40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD86C116D0;
	Wed, 25 Feb 2026 01:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983593;
	bh=spO1g7q2mYWiJqioBsCdnA9zoRbZ8phgffo1obS6irQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJre8y40vEJyE9dR0jPH2z/BqiSNtdqGq18N6KMggPnCIBBy2MTSn/S2SZ3ykNrst
	 LJDGwPkw9H0cH8a/6tWFsRUkMogvXHRjYyP6P+ZH/JzMVWuPHpjuVYHEMTECRd39m/
	 ExvpYfIdSGekwlvkEMdqgJNh5FeBxqAhZdtNsDzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <Jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 690/781] net/mlx5e: Use unsigned for mlx5e_get_max_num_channels
Date: Tue, 24 Feb 2026 17:23:19 -0800
Message-ID: <20260225012416.689791875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 57a94d4b22b0c6cc5d601e6b6238d78fb923d991 ]

The max number of channels is always an unsigned int, use the correct
type to fix compilation errors done with strict type checking, e.g.:

error: call to ‘__compiletime_assert_1110’ declared with attribute
  error: min(mlx5e_get_devlink_param_num_doorbells(mdev),
  mlx5e_get_max_num_channels(mdev)) signedness error

Fixes: 74a8dadac17e ("net/mlx5e: Preparations for supporting larger number of channels")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <Jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260218072904.1764634-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ff4ab4691baf0..a06d08576fd4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -179,7 +179,8 @@ static inline u16 mlx5_min_rx_wqes(int wq_type, u32 wq_size)
 }
 
 /* Use this function to get max num channels (rxqs/txqs) only to create netdev */
-static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
+static inline unsigned int
+mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 {
 	return is_kdump_kernel() ?
 		MLX5E_MIN_NUM_CHANNELS :
-- 
2.51.0



