Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028188;
	b=nfo8ykJ1DjTj4RZPkCXZJpX13Vx9lF1W6kYBe3Qa5CFIIjIdtS5Spf7+jRqRtuca1RhM
	 17GPX0bWg6Gc4/Z8Y1OJJSdsI/vrqgckwjrlemDcCggs7xvj099A+3GNc+L+Sd6ipD3HE
	 NfTOEE4AY9twlwqh3dj8r97dixyunBN1JY7j+rF/Y26Br+ZiUDI4ErsvrhKkqCVLYNqrs
	 EUXfl/vWtX5JBYj0zd19mlEhVAnmfQN7satd2TSmNeZRSJSXap3Ov6iGIi0tkNTpi0Lz3
	 2JFNDkBpY+TSj7b9jw/pZ22xSEhnyqr0k+k/fVXhOBDQKTgHhDtZ1FAC+zBz5lDbKEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ll06TSZjVcoq3LmOk29XE6D53Sehl2OX0+Q5/FklAMY=;
	b=cJBDZIkQ1WavUJI14eJ72cWVD38SzHO1q4JAQtGa4nsZdyC2lwMKxNQLNnVnkg/HUj8q
	 IcWgdELcaku1yx50Qt9GqjLDlKLClSyl7LNj6WWprSNN3GmK6/yRoXQAUaQlC8Dc5pk3z
	 nRBGfYtsLwBk3+TsE1RizCMLc5rhyOCa0Dzq/hwRU++yJQu29RGKoT4l8NJ5SNZcGDzXC
	 sApsLHizHVmqI70zP/7NM8kpJ6eNdHi9jXZxkfrhOhfIYrUWhAhUdnMULkGbIpn3y52/A
	 KMthIDQ/yIfdtIqsKOkOG3HTUAv/VpdCS9UPbdsX1/8TxB1WSzeeQ6pAiJxPDhGZ/QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KyI01rLu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D25606A320;
	Wed, 18 Nov 2026 18:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KyI01rLu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BB91F000C4;
	Wed, 18 Nov 2026 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028187;
	bh=Ll06TSZjVcoq3LmOk29XE6D53Sehl2OX0+Q5/FklAMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KyI01rLuuHcNRWjgo4eeNykDQxSMWjUjk0o0riscP2ACT6tCQdXmxPd2l93h41XIt
	 Upo4EjvmBj+xwTcmRMRuudURxG3efV2clsw+jfCdE5PACSQ5hgE/i8uRI8SzjKjp6q
	 xmy8f82PPHKR42mYBcNhjclFqFc4CfSsyTeTsFsM=
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
Subject: [PATCH 6.18 2057/2151] net/mlx5: Only set num_doorbells on a fully initialized SF
Date: Wed, 18 Nov 2026 16:03:12 +0100
Message-ID: <20261118150236.654814577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 055ee020c56f4..7e436d32d69f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -541,6 +541,12 @@ static int mlx5_devlink_num_doorbells_validate(struct devlink *devlink, u32 id,
 	u32 val32 = val.vu32;
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



