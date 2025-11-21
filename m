Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CCA332904;
	Fri, 21 Nov 2025 13:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731066; cv=none; b=kBw0l14aH1HgY6H1y5GBXeRhEMAdG78/PADHbdN/wTe5nZo3XnDUJpQlMGbmiAbg1QXPpPGknEQLidnbTn1kmc6L5ABjc2RzdewTFnaUEGZr+TBj3AaldAglwDjfm7WXy8sU14opvIUCZa4YCoGiGzK9DqkS+qO0LDPp+QLWtDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731066; c=relaxed/simple;
	bh=GU2YJE6da1vFszGXyhEI+0lS19E7Ewluu3+vLSKTBek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf3MWOt1pnxtDQL/PbzvkSFCddbWmuXTMRGUKbzmt90P2TpiysjWSj0i8blD1xF8l6aCDeIKxr/73tUfxk4MfSN10Nx+W5/OHI/LkW1m6hEA5AR5om4NNhetcARDXqIye4JGs3SGV/Kf2oCuU0M4T4wdnTM9P20Mh5YfMUd5PrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAJDZ1Y6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAJDZ1Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E9C4CEF1;
	Fri, 21 Nov 2025 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731066;
	bh=GU2YJE6da1vFszGXyhEI+0lS19E7Ewluu3+vLSKTBek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAJDZ1Y6XeWWG3kwQfVy3hhBqR0Noy5B2y3+L5aoldMA4xwXK2AtHvLesVWBCXbwt
	 4tRQmCFEvYxV37d8XOphnqksSIg0efsAJNDA6+7CB16Mvu6JtJKNLMq6ox7Um6p9sA
	 N697LtIrI6PT+VkPJOtqZx3BeYdpzOtm0jWFbfBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 077/247] net/mlx5e: Fix potentially misleading debug message
Date: Fri, 21 Nov 2025 14:10:24 +0100
Message-ID: <20251121130157.360651026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d88a48210fdcb..9b93da4d52f64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -598,6 +598,19 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
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
@@ -628,8 +641,9 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
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



