Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AA71547C4;
	Mon, 16 Sep 2024 12:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488130; cv=none; b=WkGAEvA1f3DUmfLzeXeXJQG4e062nl7056tgbwMivjMi+eRNo5iNKXc7CXiSp1V/nuUhBkgZyMqG7vlMFJzVhG4kfAeyAIMAp87lxQdYo9F8izPbfhNPOFAcLXK97uIOOmiqqmfWgpzq+5bP6kHJMpMuVX4XqgPHheb8n4iTjn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488130; c=relaxed/simple;
	bh=N9X8GWgQkvb0Kdt0f1p05buNSWqOesx3FHTBf7S+Ogc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1XpoaGR8urwPsaMQjKzrqYB91lAIxFe6gSnpAkvv8OfT7KzID/x4mXco/rNQfqZqd6bP0xIkmklQe9D2K0caNGTC/IcHJDBUy2A3Oj+KJirKFFt50Cn6dmK/SmOgl7joFo/732ykfPlUerKkIMv/dAZ1MVy3mkeUv+Z9/XgKD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWzUVAVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWzUVAVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1B3C4CEC4;
	Mon, 16 Sep 2024 12:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488130;
	bh=N9X8GWgQkvb0Kdt0f1p05buNSWqOesx3FHTBf7S+Ogc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWzUVAVJxoTsQqpIb+NFJvAvIQO9IXbgRR86KOvoV2qkYn5WbyYs26RnywDjb4JrW
	 jKG3BlRdQbDvbEkmVUhA0+HiIUNE62SXy29MjJmZwMWyAhxIgfe/rXjgobwQhbHx85
	 SYr8uZfqvffkz59t/rv64EeEk8gKBJSMiw+F3i1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/63] net/mlx5: Correct TASR typo into TSAR
Date: Mon, 16 Sep 2024 13:44:23 +0200
Message-ID: <20240916114222.612953820@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit e575d3a6dd22123888defb622b1742aa2d45b942 ]

TSAR is the correct spelling (Transmit Scheduling ARbiter).

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240613210036.1125203-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 861cd9b9cb62 ("net/mlx5: Verify support for scheduling element and TSAR type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 include/linux/mlx5/mlx5_ifc.h                     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index b8bf98a0a80a..41d875066149 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -537,7 +537,7 @@ static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
 	switch (type) {
 	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
 		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_TASR;
+		       ELEMENT_TYPE_CAP_MASK_TSAR;
 	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
 		return MLX5_CAP_QOS(dev, esw_element_type) &
 		       ELEMENT_TYPE_CAP_MASK_VPORT;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 64434a3b7e1a..271c5a87751f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3743,7 +3743,7 @@ enum {
 };
 
 enum {
-	ELEMENT_TYPE_CAP_MASK_TASR		= 1 << 0,
+	ELEMENT_TYPE_CAP_MASK_TSAR		= 1 << 0,
 	ELEMENT_TYPE_CAP_MASK_VPORT		= 1 << 1,
 	ELEMENT_TYPE_CAP_MASK_VPORT_TC		= 1 << 2,
 	ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC	= 1 << 3,
-- 
2.43.0



