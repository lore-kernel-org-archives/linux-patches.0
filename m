Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC885C8EB;
	Wed, 23 Apr 2025 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419863; cv=none; b=u1MgUxEODdCHZublQasB/qriJvCMnaX1PgWuK7SxKSTvATC0eWngX8c1vMHFlWVDoux+6gKX2BasppjUIOA1vYZHBi9Y56g4GkXctgD5bWz1rydNtYb24Oy+E/hsnw5LH2JBbHrapepFNWGhcpuY/QFT5Iyilek+gAJWfXSooVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419863; c=relaxed/simple;
	bh=3godAIAT3FOagBmVy56lmOITPl2nLyOXa8Jod4IIqtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULsOBbGvffIUqTMg63PnjVpq9aIvITla79XHlUAlp96ZLzaOoJrfvIzx401t/HgU6A3nTViK8LdeJOE1ZGi/3OYn4t+ePLvoa4Es3eo5qb6/oBQkyBspIETvHiL8DeAmP1IwKC6HxOg8hgn4NYjoEjzDVunnSJQArIxM0/cWuwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pfd9VVe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pfd9VVe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C1AC4CEE2;
	Wed, 23 Apr 2025 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419863;
	bh=3godAIAT3FOagBmVy56lmOITPl2nLyOXa8Jod4IIqtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pfd9VVe/tPup8lspSNjd1Qx+c8vVX7cKxE/TcSMALLt/mwUbwHqovGVosvUw16MZ1
	 Xmm0xFw6MeHrZOxL+N99DqRXEqrexVRFbJS6Q+Me4rR9BD+qhp+MMex8zZV/noHuce
	 McoVcdu0hAiQRsELaUJhOI4naPR1YTOc2LJ63dPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/223] net: ethernet: mtk_eth_soc: correct the max weight of the queue limit for 100Mbps
Date: Wed, 23 Apr 2025 16:42:25 +0200
Message-ID: <20250423142620.101014276@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82af9bddc12fb..941c7c380870b 100644
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



