Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC1CDF5E
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77462C433EF;
	Mon, 15 May 2023 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169467;
	bh=kAa9RyPZ94/ugCvMO07SxJqvbPCdTHOzYntsQcMJj1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXskLlJ0zT9GHPQaGjEZRdgvl+NcPoqWS0pl5puyz9LcW0FL50jtuEN5jFwAkIQwq
	 bOlOarQFM3NsIrDCkw9y7Z2rPhyL6Dc/ox6WDCUgOJcUo5dr3rBlwxg97uqcAmVL3D
	 5MJqsa4RlBQg39kYWVxR3OOMP3VOuRDOXO5wMmBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 067/246] octeontx2-af: Fix depth of cam and mem table.
Date: Mon, 15 May 2023 18:24:39 +0200
Message-Id: <20230515161724.585910027@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 60999cb83554ebcf6cfff8894bc2c3d99ea858ba ]

In current driver, NPC cam and mem table sizes are read from wrong
register offset. This patch fixes the register offset so that correct
values are populated on read.

Fixes: b747923afff8 ("octeontx2-af: Exact match support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 20ebb9c95c733..6597af84aa367 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1868,9 +1868,9 @@ int rvu_npc_exact_init(struct rvu *rvu)
 	rvu->hw->table = table;
 
 	/* Read table size, ways and depth */
-	table->mem_table.depth = FIELD_GET(GENMASK_ULL(31, 24), npc_const3);
 	table->mem_table.ways = FIELD_GET(GENMASK_ULL(19, 16), npc_const3);
-	table->cam_table.depth = FIELD_GET(GENMASK_ULL(15, 0), npc_const3);
+	table->mem_table.depth = FIELD_GET(GENMASK_ULL(15, 0), npc_const3);
+	table->cam_table.depth = FIELD_GET(GENMASK_ULL(31, 24), npc_const3);
 
 	dev_dbg(rvu->dev, "%s: NPC exact match 4way_2k table(ways=%d, depth=%d)\n",
 		__func__,  table->mem_table.ways, table->cam_table.depth);
-- 
2.39.2



