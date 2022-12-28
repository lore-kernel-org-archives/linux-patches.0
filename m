Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8071875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA55C433EF;
	Wed, 28 Dec 2022 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242707;
	bh=Me0nmIbEVVccwb+8rYj6t4kc+25Zhlj26GzdAUnhDsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kryJZeaBHjYfxINIBXJCfvGBdwuM0vD2R+o1ZSUvqSktzpfvVddQGSfGevsnbQVih
	 VoOYLnuFRbL3xS9WUTBGrhY9JQov2gHTXyjmt/EEJMK6JzGRcekiwTzPvG8JpZv4pL
	 0iGrM2tZ8WpH3IaSC2hO4zdcNvWDbcxNcqS3yh44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0442/1073] wifi: mt76: mt7921: fix reporting of TX AGGR histogram
Date: Wed, 28 Dec 2022 15:33:50 +0100
Message-Id: <20221228144340.036152554@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 028b4f22b37b88821fd87b56ce47b180583c774e ]

Similar to mt7915, fix stats clash between bins [4-7] in 802.11 tx
aggregation histogram.

Fixes: 163f4d22c118d ("mt76: mt7921: add MAC support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index dd8479adbcc9..5b0eba4cb421 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -852,7 +852,7 @@ void mt7921_mac_update_mib_stats(struct mt7921_phy *phy)
 		mib->tx_amsdu_cnt += val;
 	}
 
-	for (i = 0, aggr1 = aggr0 + 4; i < 4; i++) {
+	for (i = 0, aggr1 = aggr0 + 8; i < 4; i++) {
 		u32 val2;
 
 		val = mt76_rr(dev, MT_TX_AGG_CNT(0, i));
-- 
2.35.1



