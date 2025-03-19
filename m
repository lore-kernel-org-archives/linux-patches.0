Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934ED2139D4;
	Wed, 19 Mar 2025 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395031; cv=none; b=Y/2pD92kltZJbGCkuFzQKzYz2FALK6bxakTpcjQrVqAoc7DCtluHiaVBSzn1O/IbL44QBkks9bQOmWGQ4QnaSKi9BEmzeH3qLblA5MU0EL4ZdVQO1eYIPV/lpyOyGLXVeqnlexuw+jZJ+qKp24ruMQslZdI5QojN0DSQUKbqxT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395031; c=relaxed/simple;
	bh=EkSy2jhAu7lXscssGDOKWZdW3svYLaTj2/Zoi9+u8tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9HO0S1cnsH82iQXS5f5eYTJGWdWvvIQt1+kG9+xZ6LKo7vbhyHa3o1ds04pWOGQ0nE+S7JjKHMQ1Bf1NXWkADFa+rIYsCjWvioY4z3HYGlCHS1FImUNUYFAeHtk5pTA0w+pKdGkuvSBoL9p6Kx0f5MRFFnSBWQPuaMNXWf35As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtS5PxNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtS5PxNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08799C4CEE8;
	Wed, 19 Mar 2025 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395031;
	bh=EkSy2jhAu7lXscssGDOKWZdW3svYLaTj2/Zoi9+u8tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtS5PxNOtKxTy4T4+Rv8cWIMCesrCBAsbMKDgJ+GMySzAf1EuUs+5wgBQhh3Wl/4z
	 GXllDBQemW5+EpynWHqfwYL/6M9geSnuE+cyk95rVUYoShztVM5y8pCCsHgxtygWBJ
	 2K0+GE9f6R9Twg7wJjJ1LcvuyL35mdKKbRh8o9nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/231] net/mlx5: HWS, Rightsize bwc matcher priority
Date: Wed, 19 Mar 2025 07:29:04 -0700
Message-ID: <20250319143028.086877790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit 521992337f67f71ce4436b98bc32563ddb1a5ce3 ]

The bwc layer was clamping the matcher priority from 32 bits to 16 bits.
This didn't show up until a matcher was resized, since the initial
native matcher was created using the correct 32 bit value.

The fix also reorders fields to avoid some padding.

Fixes: 2111bb970c78 ("net/mlx5: HWS, added backward-compatible API handling")
Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1741644104-97767-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.h  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.h
index 4fe8c32d8fbe8..681fb73f00bbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.h
@@ -16,8 +16,8 @@ struct mlx5hws_bwc_matcher {
 	struct mlx5hws_matcher *matcher;
 	struct mlx5hws_match_template *mt;
 	struct mlx5hws_action_template *at[MLX5HWS_BWC_MATCHER_ATTACH_AT_NUM];
+	u32 priority;
 	u8 num_of_at;
-	u16 priority;
 	u8 size_log;
 	u32 num_of_rules; /* atomically accessed */
 	struct list_head *rules;
-- 
2.39.5



