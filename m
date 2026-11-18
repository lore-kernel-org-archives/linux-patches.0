Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022171;
	b=jqNlpW1coYC8viUzsXeHrqnb5wFoUFxB8XC/5qHiDjc4YvlGBC4nWFjGO8ifUeDMcr5y
	 cWDj+oyrqG+6TsnR0qJ/PX0yaXdm01y4FeCyMngEeysTT/4o2FjCd8IhPIj1VJbnb3Fiv
	 JSCDyrex1OhN/54U5nUh/JV+UW4kbTHwsr4Loh5X38e8oJyvfZKNOEuq570q/WIXioc+C
	 sj7VYc2tp1sgLn50hUksVhX6hvqQyguOtg2t0ZSD3Okppd6fn+CYtMVodK0twHvBYED8j
	 V2zVI00k1ct/P2VlTP2YiaV4JrE1KY0PuoAyYVZfG3j3CjOvaIk0aecOmhh+nQKjIDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwzPwVPOaUEwVmKsGDXr6TGJoKjAQu5qRKR2BxHsJaQ=;
	b=yXymTT9CKv2KrCBkHbKGCks9F30fZgbuTmoE5yEx3LYW+cBA9ZB1dbEWTDbpIp6vuuil
	 ey25FJaOt99NKvn9v799uzMOUNWUGtG8TanxXa5xoHq3bu0PEYcyti7Z6IPYZ7RAy3zO1
	 /yLs46ume+6NHQxq4p4pxbdChKMypS0wdL+DtqgwiueQKJoTkfRJizxJSgdoyifiYX2Up
	 KL7NlFqDLnre8BWgAQLZZih/98vj4a1RiqQqaP8AB079fQZ4nK6N3yZbKc3k3YBWaTlGB
	 W44VvEKVKejpoywggPJ8q+xqJGYVKI5yR20mg6NQ2iHoy7N/oO0LLmaT23EYtNmwmtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iT3jk8xj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A2A606A325;
	Wed, 18 Nov 2026 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iT3jk8xj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8D61F000C7;
	Wed, 18 Nov 2026 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022171;
	bh=lwzPwVPOaUEwVmKsGDXr6TGJoKjAQu5qRKR2BxHsJaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iT3jk8xj4V2Xdto5pluzRAv/VeHeNmyRiOMTN+wxB9y0E5J3KKB/YnzHnHmVDST93
	 Y1sG85YnniUEIQGmboLtthbSTNHUAPDqqBadJOGFUgC5DgsqURoPIBPc+THLrnmRu4
	 LP1fW5m0CZYhag5Hg5mEHTxejjH8NnxFr693l/L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2566/2651] net/mlx5: Only set num_doorbells on a fully initialized SF
Date: Wed, 18 Nov 2026 16:03:26 +0100
Message-ID: <20261118150416.790481917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit fa503935c2d6603856dafff0a0852631ab6e9503 ]

The validation for the num_doorbells devlink param rejects values
greater than num_channels. For lightweight SFs, this ends up accessing
a NULL priv->eq_table, leading to a crash.

Fix that by rejecting setting num_doorbells on uninitialized SFs.

Fixes: 11bbcfb7668c ("net/mlx5e: Use the 'num_doorbells' devlink param")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261026084503.4122732-1-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b9026cc643835..30a97e48dda7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -542,6 +542,12 @@ static int mlx5_devlink_num_doorbells_validate(struct devlink *devlink, u32 id,
 	u32 val32 = val->vu32;
 	u32 max_num_channels;
 
+	if (mlx5_dev_is_lightweight(mdev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Setting num_doorbells requires full device initialization; reload the device first");
+		return -EOPNOTSUPP;
+	}
+
 	max_num_channels = mlx5e_get_max_num_channels(mdev);
 	if (val32 > max_num_channels) {
 		NL_SET_ERR_MSG_FMT_MOD(extack,
-- 
2.53.0



