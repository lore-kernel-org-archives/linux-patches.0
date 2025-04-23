Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94FB261573;
	Wed, 23 Apr 2025 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422186; cv=none; b=BmQ/ww6RAweiB78bilP/dkM9FuGa/TNW0bfvAiS4YZhGhPxga3Xmi/y4SqC0lHEeMKnHw9NJ1lJVuvrgyilzjqA7G1prNqm6xUdtOb60Jxh+Yg8e2eMq3ItKaZbIXnGP2ndTw9IPCjfrGyvzGAyweg0g6UNukq610VE4Dmc+sP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422186; c=relaxed/simple;
	bh=8PZ5T85UIjubX7osB0/WXpP/PrQH+ym6kTYt33YFw/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=og6ZC71JbG6XAwSN1YyXKhudNgHAY8D72OYDd1JfQfMSuWpShvGAHUcHlagl9L8oWhWMevY+GWBp1YjwbIu/qQIZxzyYbuYZiP+HhxnxQXL+DryXM/ooWuhylstifRgJf09FJKrvDzqstl0eWph1VuCpjXcKLgK6xw5Z5iDd7q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssM1IVtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssM1IVtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E10C4CEE2;
	Wed, 23 Apr 2025 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422185;
	bh=8PZ5T85UIjubX7osB0/WXpP/PrQH+ym6kTYt33YFw/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssM1IVtVwFXAuu1yZmPz5oiVErPlZfODijfZ8/d76oFEZZoCA/I8wSguyIyZSHJ7P
	 O1zDaLANHu8lnD5UDT9rbCTjTkOJIIRwePoDEFGn97UrjyOUcFXhEkv78bslmuy57z
	 NkoAi2853/b+h4PU1yD9z9/1gO+/ZhsZKYUccKt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/393] net: ethernet: mtk_eth_soc: correct the max weight of the queue limit for 100Mbps
Date: Wed, 23 Apr 2025 16:43:09 +0200
Message-ID: <20250423142655.442246408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo-Cun Chen <bc-bocun.chen@mediatek.com>

[ Upstream commit 6b02eb372c6776c9abb8bc81cf63f96039c24664 ]

Without this patch, the maximum weight of the queue limit will be
incorrect when linked at 100Mbps due to an apparent typo.

Fixes: f63959c7eec31 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
Signed-off-by: Bo-Cun Chen <bc-bocun.chen@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/74111ba0bdb13743313999ed467ce564e8189006.1744764277.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bdc424123ee6c..a22a5bdc7ce62 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -724,7 +724,7 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
 		case SPEED_100:
 			val |= MTK_QTX_SCH_MAX_RATE_EN |
 			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 103) |
-			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 3);
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 3) |
 			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 1);
 			break;
 		case SPEED_1000:
@@ -747,7 +747,7 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
 		case SPEED_100:
 			val |= MTK_QTX_SCH_MAX_RATE_EN |
 			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 1) |
-			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 5);
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 5) |
 			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 1);
 			break;
 		case SPEED_1000:
-- 
2.39.5



