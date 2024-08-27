Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EAD1C6F5A;
	Tue, 27 Aug 2024 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772031; cv=none; b=g/wjyFc/Uuy1WfIZ3RG/eHcM7IswoFDlLwCHysLvLH/xsZz9cYxIkoF/8Xg7s27ArQvsqp6zdzkEeS/txPX+GddxUt5jS1E4IYm7JD8CcSlRVb8kiYiTVUfbLJ4Dvtls0/HKPfNqdZ+ll8WLleqtQez/ACa4O0mWpR8h8XFSpLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772031; c=relaxed/simple;
	bh=cfKNNhKcfFDrTI1V7Myw0PPSgsoO02GM/U05TI8Ye4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOTDPkj8l42tBMmwJwGmVGsCKDIkxDhrjLFKmoj0qR2AtLTmIr4IkI7EoHUuSiklYUJn4Fb9MpALXFyf1BWMF8ZDuT9K6IPCc7EarmLnTt0gQHdWcbkhrNiumQOTeP0zHblexLlWocxKhbUKyv5EfOC1DrYEVkIi4r6TWAFnfBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7xJ8Rq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7xJ8Rq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1976BC4DDE5;
	Tue, 27 Aug 2024 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772030;
	bh=cfKNNhKcfFDrTI1V7Myw0PPSgsoO02GM/U05TI8Ye4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7xJ8Rq037gabDCk/S2vfEmAfypFCyfj+PkOuiCQuk6K48nLQC5Gs9NRganAFELFO
	 ulEQKk/burhH8r/nSx+RSJ5Z6DhmqlN70hM7g1BoeJfwFgiwbY5UPq7vzz4k0mGm0d
	 NkpLdvHiHRTTEf5VBcPFCz9iAmrnnMebLza2hVlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/321] mlxbf_gige: Remove two unused function declarations
Date: Tue, 27 Aug 2024 16:36:40 +0200
Message-ID: <20240827143841.741250270@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 98261be155f8de38f11b6542d4a8935e5532687b ]

Commit f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
declared but never implemented these.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Link: https://lore.kernel.org/r/20230808145249.41596-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: df934abb185c ("mlxbf_gige: disable RX filters until RX path initialized")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index 5a1027b072155..483fca0cc5a0c 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -148,9 +148,6 @@ enum mlxbf_gige_res {
 int mlxbf_gige_mdio_probe(struct platform_device *pdev,
 			  struct mlxbf_gige *priv);
 void mlxbf_gige_mdio_remove(struct mlxbf_gige *priv);
-irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(int irq, void *dev_id);
-void mlxbf_gige_mdio_enable_phy_int(struct mlxbf_gige *priv);
-
 void mlxbf_gige_set_mac_rx_filter(struct mlxbf_gige *priv,
 				  unsigned int index, u64 dmac);
 void mlxbf_gige_get_mac_rx_filter(struct mlxbf_gige *priv,
-- 
2.43.0



