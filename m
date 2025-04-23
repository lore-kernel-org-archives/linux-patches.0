Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADC41A23B0;
	Wed, 23 Apr 2025 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420363; cv=none; b=ONULjejX/QpA3NNRawF5nv6r16o6FQgJSsH7VIZhxTMASpWZjGlgDPvyZsl3NGh4u/6ii0hYu/RGTQE4lT4TMzwQRUw6YxvfhnIw62Pe9qB9x26HU60FsaIGxVhIoKGRBYo55xiocpotAHrIXat5OcMiinAeyDSo/rvnCJr51eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420363; c=relaxed/simple;
	bh=eu4AExGYxOLsgLzaLcZ89j86An9HG5ktvLOwMCIAwxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/3vbzJHrQ31iCll2hYU5SM9DDvTMx9+nb07DLDUIbPJtiVcWg/qYdKEplObQo7ZRXDorpm4vFricfhf4M/8EXUiK1dfo6XBF7eIVNccIjNxK18yMVZsskDdb7nx+xiVYM2/mydm8/ZbSzb77gZK+HRYZL8nnMWXnTD5en0EPkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn10up+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn10up+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0C4C4CEE2;
	Wed, 23 Apr 2025 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420363;
	bh=eu4AExGYxOLsgLzaLcZ89j86An9HG5ktvLOwMCIAwxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kn10up+B1OON2fz5KjvFzgueM4fn1V10oFrd3QxwSkOb4V8BwY4JmBhd9An8q0RUx
	 pty7gdSj638CwYoxVPDVMKOBYGxMmXnkbtEQRWZ8SV4yvJyT/BFQPOfAUdnWfyHi8x
	 BIWAfllSbv6W/Jk3ds7caKnEfpu6TVkczhm1TSno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 085/241] net: ethernet: mtk_eth_soc: correct the max weight of the queue limit for 100Mbps
Date: Wed, 23 Apr 2025 16:42:29 +0200
Message-ID: <20250423142624.051265628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7988de05e4ecd..6a34ad6483a14 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -734,7 +734,7 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
 		case SPEED_100:
 			val |= MTK_QTX_SCH_MAX_RATE_EN |
 			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 103) |
-			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 3);
+			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 3) |
 			       FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 1);
 			break;
 		case SPEED_1000:
@@ -757,7 +757,7 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
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



