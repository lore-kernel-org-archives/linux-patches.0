Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DF135C185;
	Wed,  3 Dec 2025 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779827; cv=none; b=tj2PGfiFJSoT1S10I4VOsCXY9HBqpGoo4D84gA5UMecdeoKhkaKa1pG3q0C3O4VNK/FMEv9imgfrtZBtyh3Wyt9LP6ricYKFSfShfvblxilAruMMuTXO7AjWCO23xh2cw7NtSRZqQJU8lfZMvlJEQo63yURob6XxflL68gy/3uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779827; c=relaxed/simple;
	bh=thvuptWvUX3gWb3ZnoeXMGYeEIH2g+BROnm4F9ghNgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCdMtiHUjg9sSyM6jpdhY/K4k2jwHtpBu4sS/fhrFvf5zejY/ET52zp8W72qBfgGL6Y5QbOYwFd49QkS1MiL5duPFfpek5ojLeHiP1gH8oqAKuZJ+t26r245z8UhwdxiY2a9Cbx77M8bkdsUsgKXjSjl1kLTC30etnSl+zu0CrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKvg5IKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKvg5IKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF65C4CEF5;
	Wed,  3 Dec 2025 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779827;
	bh=thvuptWvUX3gWb3ZnoeXMGYeEIH2g+BROnm4F9ghNgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKvg5IKMuPoibPaUPSxo6Z6Ll4Cka2Go71f7mM5gKzmllO9WZtBjFbQJKSpGc5UMT
	 LbBSKglLurlKFTGP8w6xukK/bGYaC2QD4hpJdQAvMhw6L9a7CKiBwlyStUwfV278G/
	 c2Vg9O7tzCJDsjq787r43ZvmK59kWY4HB2VgC7y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 373/568] net/mlx5e: Fix potentially misleading debug message
Date: Wed,  3 Dec 2025 16:26:15 +0100
Message-ID: <20251203152454.359373337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 9fcc2b6c10523f7e75db6387946c86fcf19dc97e ]

Change the debug message to print the correct units instead of always
assuming Gbps, as the value can be in either 100 Mbps or 1 Gbps units.

Fixes: 5da8bc3effb6 ("net/mlx5e: DCBNL, Add debug messages log")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1762681073-1084058-6-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index ca096d8bcca60..29e633e6dd3f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -590,6 +590,19 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 	__u64 upper_limit_mbps;
 	__u64 upper_limit_gbps;
 	int i;
+	struct {
+		int scale;
+		const char *units_str;
+	} units[] = {
+		[MLX5_100_MBPS_UNIT] = {
+			.scale = 100,
+			.units_str = "Mbps",
+		},
+		[MLX5_GBPS_UNIT] = {
+			.scale = 1,
+			.units_str = "Gbps",
+		},
+	};
 
 	memset(max_bw_value, 0, sizeof(max_bw_value));
 	memset(max_bw_unit, 0, sizeof(max_bw_unit));
@@ -620,8 +633,9 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 	}
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		netdev_dbg(netdev, "%s: tc_%d <=> max_bw %d Gbps\n",
-			   __func__, i, max_bw_value[i]);
+		netdev_dbg(netdev, "%s: tc_%d <=> max_bw %u %s\n", __func__, i,
+			   max_bw_value[i] * units[max_bw_unit[i]].scale,
+			   units[max_bw_unit[i]].units_str);
 	}
 
 	return mlx5_modify_port_ets_rate_limit(mdev, max_bw_value, max_bw_unit);
-- 
2.51.0



