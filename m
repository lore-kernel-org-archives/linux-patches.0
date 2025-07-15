Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020A2ECD3C;
	Tue, 15 Jul 2025 13:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587166; cv=none; b=G390b5HBsg0YnKQtgl3BAhO8Ch+xxRuaEVGN4o17S87IzMxKA6dCJ4BrADz/m9tyA4FqQf3JdOWCJtOpR38vu9pqMQquR3kLObqkI+MXN9oc/WtWgp6X+Xo16LORA8O3KsoNYZEBF0AMuUJCWJ4aDYK/FJRa2iuOCpnG16T+qIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587166; c=relaxed/simple;
	bh=0SEdfAs6ifof6HjzPvS2lH58rtdH6uTpCGFD88HWzcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CafoLFqnvb6XVW4lMJFhrQ+sMiSpm0/T80wY4xJ8ZDN2xFmD8n6alL2x3fORUzYrUYjN6+v8dKXEjkCwICIqive2WugeRiez3JeDXVZnYCxLG174Zb1td/wgVzuXPIuGv/LvctqGgISOQdVmoxxJdewaX8tGpZ+tqEaqyAWL0BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mvh/r8c/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mvh/r8c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7698C4CEF1;
	Tue, 15 Jul 2025 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587166;
	bh=0SEdfAs6ifof6HjzPvS2lH58rtdH6uTpCGFD88HWzcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mvh/r8c/2QCCBkwGfRi4mXbxM6V+CTWQkl/W2NO6URIXmqTCERDSYkXzpM64PS05u
	 B4i62As9zIbY670qtPrHluQGehsbMNdgAA5JxTPXoT6HpOj/UvCY8zW4YSgZBV0X1w
	 d8MdDuzj3xKBBrogBAwzLMgnuG1ctDK9zQ7LquIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 160/192] net/mlx5: Reset bw_share field when changing a nodes parent
Date: Tue, 15 Jul 2025 15:14:15 +0200
Message-ID: <20250715130821.336228882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit f7b76466894083c8f518cf29fef75fcd3ec670e5 ]

When changing a node's parent, its scheduling element is destroyed and
re-created with bw_share 0. However, the node's bw_share field was not
updated accordingly.

Set the node's bw_share to 0 after re-creation to keep the software
state in sync with the firmware configuration.

Fixes: 9c7bbf4c3304 ("net/mlx5: Add support for setting parent of nodes")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/1752155624-24095-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index b6ae384396b33..ad9f6fca9b6a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -1076,6 +1076,7 @@ static int esw_qos_vports_node_update_parent(struct mlx5_esw_sched_node *node,
 		return err;
 	}
 	esw_qos_node_set_parent(node, parent);
+	node->bw_share = 0;
 
 	return 0;
 }
-- 
2.39.5



