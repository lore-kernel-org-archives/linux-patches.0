Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FE62F0C5C;
	Mon, 22 Sep 2025 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570194; cv=none; b=kdm09z39qFquLUX3rqN3kTa1Aj4Kww90r1vbk+tkw8msqQWevlynqMFOBDj8co6w9SU+BGxa20eYAQfgupBIC/guf8cXCKlKWSkU4x7USSyKQTCpcJU6vQObs//wvILPvESgHV0C28xyN9b8N1A0kPadNAM8O+hys4yYs6IGwlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570194; c=relaxed/simple;
	bh=ZUU7DFydGrSZ6SGCDE9d0x7Co+3nxyWz065RLl+B0jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fkk78Zv2f5om7u6Z5f24YLa30HRqxj8cP+gTTDrTWrzph0BUN+kty24Bq+WkoVG0PYNQRdPVx5vTVcWWpai8Z0jkLnmQw1sVVI9wy4JNdYGVL+Lni8W74jm9G0tdNbbmFY5MlsiSIVZpqJGHF/GfO6J5G5YdZeZRQk0RVb2EnYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDcjW2z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDcjW2z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C687C4CEF0;
	Mon, 22 Sep 2025 19:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570194;
	bh=ZUU7DFydGrSZ6SGCDE9d0x7Co+3nxyWz065RLl+B0jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDcjW2z3uO8Z5e8LmSwIrqw64VCRoSMpy5Y9i0B14+rW1me3DjZwCOwOFRcRbQ2bO
	 zgNpIKAgo2ppKJoci5fM1HGSOa+F2Xq5TQIbU+7YQ5pNxbOvz5/yH6KK1wS5ci4S8J
	 4E1SS/7srkCupMETmoGR6s0VoFp+CGj2CiBK1NT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 042/149] Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"
Date: Mon, 22 Sep 2025 21:29:02 +0200
Message-ID: <20250922192413.925576490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 3fbfe251cc9f6d391944282cdb9bcf0bd02e01f8 ]

This reverts commit d24341740fe48add8a227a753e68b6eedf4b385a.
It causes errors when trying to configure QoS, as well as
loss of L2 connectivity (on multi-host devices).

Reported-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/20250910170011.70528106@kernel.org
Fixes: d24341740fe4 ("net/mlx5e: Update and set Xon/Xoff upon port speed set")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e39c51cfc8e6c..f0142d32b648f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -136,8 +136,6 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
 	if (up) {
 		netdev_info(priv->netdev, "Link up\n");
 		netif_carrier_on(priv->netdev);
-		mlx5e_port_manual_buffer_config(priv, 0, priv->netdev->mtu,
-						NULL, NULL, NULL);
 	} else {
 		netdev_info(priv->netdev, "Link down\n");
 		netif_carrier_off(priv->netdev);
-- 
2.51.0



