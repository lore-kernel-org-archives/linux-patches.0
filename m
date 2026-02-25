Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B2F2D4805;
	Wed, 25 Feb 2026 06:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002747; cv=none; b=X6nZraK5CV/ySzDH4aCgmeRUeLKQ0JVosECSDk80chcuuZXKEdDO9K7mK3MnOxYcVwGlhrk1KybdusmqJIxs58c6rdf6jyKRVWOr++kJXFMHs8Pm0aq53c2wyrzk5TE8fctfQGrFR6m/1KZBhE6cfxoQYhfjlSfD7iJdUf1fW9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002747; c=relaxed/simple;
	bh=yL6RVQsa7uzZUnhoO1KkhHIsqrKMaV28l3ziPo8W1AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mrecLYipL+HjKqAfv8pjaQMsOBTUuR9qmUQmxj97yLd1+IOyJC87gPswd7W7qbd4XFZ4Ee7D1JGjHeC2POwraxaJ7wvx0uVsF24lso+V4A21z6fxxeJRNnL8gryQMIGYKIXvN/Joi0OpLpoS5x6zvUqLB7eDDyk45ZKkokrowmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKEpNzOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKEpNzOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D4DC116D0;
	Wed, 25 Feb 2026 06:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002747;
	bh=yL6RVQsa7uzZUnhoO1KkhHIsqrKMaV28l3ziPo8W1AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKEpNzOlXh1h/jb3QrMyrfPXBiudhH19D65m0dRi6D9v2WxZsu2SjOlI0zSl6xq29
	 gn5SNxvz9i/Y/K5yygQ531Ol2mIVOXt6rdHXu3YOhwosNzJWWmZoVpRH34mlLKZKSL
	 hfBtVg4Rf7B2opQe4gscIdVftK1lajizrhP9JcvM=
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
Subject: [PATCH 6.18 562/641] net/mlx5e: Use unsigned for mlx5e_get_max_num_channels
Date: Tue, 24 Feb 2026 17:24:48 -0800
Message-ID: <20260225012402.140268554@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b34b85539f3b1..5bced924a24fb 100644
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



