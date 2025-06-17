Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A900B2356CE;
	Tue, 17 Jun 2025 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177405; cv=none; b=Oym6qNAFKudrgDzVa0t0fVdVK84WFphdCAWJEEf53hQD1xvwV+rOgcpmYQwiUOpwy0KQDv7/fxXiglm5Xrgyoq+KxC/dFf318BcijkPmHRZUvooPhcLYfNa+UGVJvqzYkxn8xM/4eITJVjiQTcsa+SjtKhT4ySsDatSbzV1QGc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177405; c=relaxed/simple;
	bh=sdNFcs18DApL99/oC7c4c5kN/DQ9UHJUxRswG0+lNCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWgyl7vKRUsR9iXqKU5hIaW0fT+7z9qJF7R/w9RP+sNKF4PMrIPaa1oO7M6DUU/z+SoaRczUefJj3glYwXMVbsk36ATPJVjz8HBCDIJAX6nBvKEyPaffBpeVEKXjoeAggpvqmDof91ZjS9O70ayOaJak+/DXQDEvqbAL1e8ErzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWt/DhhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWt/DhhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B12C4CEE3;
	Tue, 17 Jun 2025 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177405;
	bh=sdNFcs18DApL99/oC7c4c5kN/DQ9UHJUxRswG0+lNCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWt/DhhTkMK+Zt0eMJJoQpBJa6hXU8dUIk51MqfpCJQnqi1YBtJ+jAH3oWncbyTjE
	 Y9ZyEstJBRBNImeOQSxiEO3AkJS9/bH2zZhYhq2wFeuFyhFYdeyfYi16Sja8m+fdzD
	 RBZ6KuvOZboYdcdNSNqp6YMWuVnwZNXB2TFRJS14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 301/780] wifi: mt76: mt7996: fix beamformee SS field
Date: Tue, 17 Jun 2025 17:20:09 +0200
Message-ID: <20250617152503.726985432@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 5c78949fc7cd772d483a8abe126fe90937c0f002 ]

Fix the beamformee SS field for the mt7996, mt7992 and mt7990 chipsets.
For the mt7992, this value shall be set to 0x4, while the others shall
be set to 0x3.

Fixes: 5b20557593d4 ("wifi: mt76: connac: adjust phy capabilities based on band constraints")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250515032952.1653494-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 5af52bd1f1f12..e99dfd1771d52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1116,12 +1116,12 @@ mt7996_set_stream_he_txbf_caps(struct mt7996_phy *phy,
 
 	c = IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE;
 
-	if (is_mt7996(phy->mt76->dev))
-		c |= IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_4 |
-		     (IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4 * non_2g);
-	else
+	if (is_mt7992(phy->mt76->dev))
 		c |= IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_5 |
 		     (IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_5 * non_2g);
+	else
+		c |= IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_4 |
+		     (IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4 * non_2g);
 
 	elem->phy_cap_info[4] |= c;
 
-- 
2.39.5



