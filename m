Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65941183CA7;
	Sun,  1 Sep 2024 16:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209947; cv=none; b=ss0K6fJ4fMwLXIKwog9bAE6xCZAuqOr1QazFewsqEPXQehowrGJRcMo1a0huvymOXla9j3KrHy5CirtSvT/agUUXxY7v8kOQWfQZ+cTudtXRcrwQskrMbZdFiY5Pla8/5asLVArDWKAmW4i1z4AT/pgstC34nvbtCETiFNtrsOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209947; c=relaxed/simple;
	bh=wgPG5P8YO/JaPDwdk1FghsbyHZafWtAtErqfC/ax4yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C107hoGRQkzrnKl0QCsSQm9Mv4cCBdV9DTNM8YOUh3usP90n/c0sqmhoIXBOhQvcPe6DvUHnwev2e0ZkCfwhoUQsWtD7koH2N9o6fgMj1L9W2yonjHi0SIecg0A+9025OsLsd3swostu4EumjrsW4mE0lTeYQT9MGh92b6d3ofQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rpzp7vX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rpzp7vX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA61EC4CEC3;
	Sun,  1 Sep 2024 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209947;
	bh=wgPG5P8YO/JaPDwdk1FghsbyHZafWtAtErqfC/ax4yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rpzp7vX1zxG4dO1WssLV7NGIDDoeXwKm5zDqPBRNP8GNvoV6l3lJNtDZB3NCHR+5M
	 bb5n4pz5wxpBYbq4B+xH2UcDwAxuigAzuEipEgFKNqJIWqF3CWL8gPpHDBTh2M9xRl
	 yVBHhSEouRnOtihHblAebjrwPhR+PYdW8w94977M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/215] mlxbf_gige: Remove two unused function declarations
Date: Sun,  1 Sep 2024 18:15:46 +0200
Message-ID: <20240901160824.635673814@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0fdf2c8ca480d..13ba044e7d9a4 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -151,9 +151,6 @@ enum mlxbf_gige_res {
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



