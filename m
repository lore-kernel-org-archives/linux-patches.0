Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0320B197A67;
	Thu,  6 Jun 2024 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683231; cv=none; b=HpDNPdmA3Xjxf2YuVH8gW0z4HS6VEoSi7QBIv1oPxJxRn7cnr72KiT99I3BulH/tCo53DV8bu0CPiC6/wu8b1cl6To7oecCWrS1upbL5dyxX6T05tkWX7mfumFJo/Q1zX5XgeiGuKD/vfl4DHrAL7IA7SsOGGpIhcs8GztLlM58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683231; c=relaxed/simple;
	bh=kp+GbPbJ170w7E86xeThPon+Gi1QRQR8qBXC9LQdTys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2T+IwmLJZw5cF4jt9nJcWaD9HtocqQspWUM5GPTBzmlSOV2kaHCfmP1dGrfUZ919KRMi4N9+ZXRMusb68wR9/2w6pVy13GutgmasE0M5tjkQLrq0/pIjTYEFQ8O60HTotCRiOqt97P1e9PK5lmVQ75/HvZVxczGxvF3c6h1yxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgVnLCP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgVnLCP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7FFC2BD10;
	Thu,  6 Jun 2024 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683230;
	bh=kp+GbPbJ170w7E86xeThPon+Gi1QRQR8qBXC9LQdTys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgVnLCP9WPsUzkhS58m9ogfA73BpZ0+x7wdPo6Gd0ZsD2ZrLIIAll79CCIqXampU9
	 mJmNO5F0lgseC9ZJ3ZkVK/H9izxLGurLcJrbEaTAsDUbe6xrXP7shLUJarqKOLYuSQ
	 AWPCn7HiBBLuw1egOAiUapXPJmH9Vq2dCHtsus/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/744] mlx5: avoid truncating error message
Date: Thu,  6 Jun 2024 15:56:54 +0200
Message-ID: <20240606131736.971705490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b324a960354b872431d25959ad384ab66a7116ec ]

clang warns that one error message is too long for its destination buffer:

drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c:1876:4: error: 'snprintf' will always be truncated; specified size is 80, but format string expands to at least 94 [-Werror,-Wformat-truncation-non-kprintf]

Reword it to be a bit shorter so it always fits.

Fixes: 70f0302b3f20 ("net/mlx5: Bridge, implement mdb offload")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/20240326223825.4084412-5-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 1b9bc32efd6fa..c5ea1d1d2b035 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1874,7 +1874,7 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
 				 addr, vid, vport_num);
 			NL_SET_ERR_MSG_FMT_MOD(extack,
-					       "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
+					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)\n",
 					       addr, vid, vport_num);
 			return -EINVAL;
 		}
-- 
2.43.0



