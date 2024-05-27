Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0C5D518;
	Mon, 27 May 2024 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836600; cv=none; b=OFUQxrsLAyht3K8ucX1ARA0cgFtQFwpipoGtLCU/ZltRvC+A6CBbQKIFcMknwhf9tYLk67Do/D8AKDJoShQHAp4qX3aQBWFCAmYAS5RlM/2LVidHm69vpZMeb9+pDBDWO08bL0p3G6YPobFgiiDRoV/MAzvVTgqJJbJBYTttFk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836600; c=relaxed/simple;
	bh=SgNrFIfdomVSHKI6T5O+OMFhVXkOJCZEu57FyjVzOqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POoBuC5kF6v5dV1ESLBFHgepwxCnPytdkBjCFtvah4IlR04m6+ncbaQAwD+l4uLEP/GwsELeKroETlq7Bjqs/4dq3VROxh8q1bg7DOGRqdHfV4hiLtsldrO5PeBxbOon+freMMd8ZM/kOpDTC1xzDSu1YXJhOI30fmrcbfO2CTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQ8K8gxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQ8K8gxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C2BC2BBFC;
	Mon, 27 May 2024 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836599;
	bh=SgNrFIfdomVSHKI6T5O+OMFhVXkOJCZEu57FyjVzOqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQ8K8gxvWAQl6nZnY2YjpxcZHS26h5tT4CaqH11ysaCkV9nDVji2sKvXsDBcVylJ/
	 GAKAelY/gjdzvo7KeKh33Y4Tfgzf9STVKWCraSLiHsxZnnSq3sS2DMTctB80nY/Kl+
	 zE3QSeGiLpUkKGTD+vZ8pIbsOMRNMOhknM7L8nm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 117/427] mlx5: avoid truncating error message
Date: Mon, 27 May 2024 20:52:44 +0200
Message-ID: <20240527185612.739686483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



