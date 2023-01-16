Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE0346B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B975AC433EF;
	Mon, 16 Jan 2023 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885304;
	bh=vEP0JPKXOWX4+9SHuJk1tvtK/ln1n+lmiCGm76WPqpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+YD9oZZjRG4mUHKbjPexBPGNuH5oJdnVVNysDdGrbAmN4Xiu8oFA+k7jP4hdzmgB
	 RZRWE4xP/sMRdJdm2u5M0WwQkxhC5VEy3c5nsZAFDaxjGd6/TgRBauYhHCobH4pj/9
	 N1Kgy53TCIPG6oVIB8deF9xTsKjUUHH6Sbh/iSXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/64] net/mlx5: Fix ptp max frequency adjustment range
Date: Mon, 16 Jan 2023 16:51:55 +0100
Message-Id: <20230116154745.248950019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit fe91d57277eef8bb4aca05acfa337b4a51d0bba4 ]

.max_adj of ptp_clock_info acts as an absolute value for the amount in ppb
that can be set for a single call of .adjfine. This means that a single
call to .getfine cannot be greater than .max_adj or less than -(.max_adj).
Provides correct value for max frequency adjustment value supported by
devices.

Fixes: 3d8c38af1493 ("net/mlx5e: Add PTP Hardware Clock (PHC) support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index c70c1f0ca0c1..44a434b1178b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -440,7 +440,7 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "mlx5_ptp",
-	.max_adj	= 100000000,
+	.max_adj	= 50000000,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
 	.n_per_out	= 0,
-- 
2.35.1



