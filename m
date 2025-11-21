Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE4034C127;
	Fri, 21 Nov 2025 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733284; cv=none; b=R7hepQuQCM6C3xOO1g//dCzE+k4oFolHg1dSBfDlMjOxA8l4LpbxDkj1qnvI4JkJYW/r4sjne+NP9B5lhq+vjfpWetSXnMb+WASMa1HVeUaITOjZNohknqGIBWCJDuNBkHDIPwCX3I0c4vUo2wAhrFrsqzMm+8cN+6mUF1oe/b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733284; c=relaxed/simple;
	bh=D1lzFaPDw/ASlqWA+jxCK6a8GUZUJV1ymbNK3rzelOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSohdqksxMDrnMGYh4c1zNK1w2ITSwMrklzBjlfp1NiV71TLD2Yf0iNMIrAgzQHiCoD87x7mKqoc6r77hbRP3/ePbG7wg2Tibr2cQkJwtYDGJbrffzE1It+0446qTL5eAeXXvtqJez3KvZX7Zt1J71FQXWd7WUlC9lag0SSUULM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5QBQyll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5QBQyll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F67CC4CEF1;
	Fri, 21 Nov 2025 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733283;
	bh=D1lzFaPDw/ASlqWA+jxCK6a8GUZUJV1ymbNK3rzelOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5QBQyllK+qlmi4VLDpBEXXVq/yNOszBGcav+pz6ykGrcdPhLkJ1hZFrcfP44nNRW
	 eASKkpHvJM1iSctJZ+h1QuKJ99IXRSJbKh7Mbn/r3TZMeTBaPNj9EflJKN7TIKlA71
	 kI0li9dFnTLYtHV4+dP2TPSsLj0KtIzq8RFSR8K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 414/529] net/mlx5e: Fix potentially misleading debug message
Date: Fri, 21 Nov 2025 14:11:53 +0100
Message-ID: <20251121130245.749798980@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



