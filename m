Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8619E13398C;
	Tue, 23 Jan 2024 00:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969296; cv=none; b=kIUKYiYsFJ7lJzx312jG4PFCRVWORnzPEOY9uI9EJEdNLP/5EvVC7YWGYEh/ePcKqg3+mSEsr2KoEIKTfZeoHGGrsPy4+c+k+nczg94PoLKQ3ZcV4658B41l15xAvXt7DvWEqaKiIFi74dkq6yJcDgYKa1bnGDMXXHTcoOjAjEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969296; c=relaxed/simple;
	bh=BaWiGXo036Gn9iamq47EAT+tysA/4ln6fv67DwZDtF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kju4Tlp5eZ0rvjbkikGpyNW9dax70fFatc5WHDDseRnDf5VssVDsdjyB8OLgdhGFvNoN4DiHejn+wH80zDc1dq/alfOApanNF7ihnutMnICa8KxdwHTBymrd6YV1PImIUkz8hEeeKX0nZKqpAyeeCr+cNK2VvwcxN8J0xowB1cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rR6wvW4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rR6wvW4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4DEC43399;
	Tue, 23 Jan 2024 00:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969296;
	bh=BaWiGXo036Gn9iamq47EAT+tysA/4ln6fv67DwZDtF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rR6wvW4eA6ISh1KwJmgdqVc0+fbkK3ARAvvhMSgQBMmpye/1vVSxS98pbKedyCrA3
	 8XX8g3sezJqVXSLzlc08d0Kmau0Hfp3Q2g5m/Rt2MCSyscgINZkEHsRwvH8e/wcnbp
	 hePnKDmMKSiI45ytU3pjqHTktBHE3X8fMpCHTHdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 153/641] wifi: mt76: mt7915: also MT7981 is 3T3R but nss2 on 5 GHz band
Date: Mon, 22 Jan 2024 15:50:57 -0800
Message-ID: <20240122235822.821076757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit ff434cc129d6907e6dbc89dd0ebc59fd3646d4c2 ]

Just like MT7916 also MT7981 can handle 3T3R DBDC frontend and should
hence be included in the corresponding conditional expression in the
driver. Add it.

Fixes: 6bad146d162e ("wifi: mt76: mt7915: add support for MT7981")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index a3fd54cc1911..9d747eb8ab82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1059,8 +1059,9 @@ mt7915_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 
 	phy->mt76->antenna_mask = tx_ant;
 
-	/* handle a variant of mt7916 which has 3T3R but nss2 on 5 GHz band */
-	if (is_mt7916(&dev->mt76) && band && hweight8(tx_ant) == max_nss)
+	/* handle a variant of mt7916/mt7981 which has 3T3R but nss2 on 5 GHz band */
+	if ((is_mt7916(&dev->mt76) || is_mt7981(&dev->mt76)) &&
+	    band && hweight8(tx_ant) == max_nss)
 		phy->mt76->chainmask = (dev->chainmask >> chainshift) << chainshift;
 	else
 		phy->mt76->chainmask = tx_ant << (chainshift * band);
-- 
2.43.0



