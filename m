Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723E336308F;
	Thu,  2 Jul 2026 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010173; cv=none; b=TJwedTCm2YxmsXoZK0lgUS5+KgQAW3Np4u43Jt6X4G5tliMqYd0uM5v4r1PQVj25dkOmevJrk9ohkx6JAd6RUOrnOWl5DFyv5Vzn+NAU5Yv+Z9vUO4igUzJgfuhcdeamcSbGDmk1zBpU06WEc3oKovmWPMunzyEJUxMcEX9EaHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010173; c=relaxed/simple;
	bh=V2aGcCP1qZSzCJai0W1kLDiHpsbyUYHHR0MLeLQh4ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSoHQ5vp3JRhH4pWi48UPEQKipq180u09Ruj3kVifiQeVAwiUFcePYdD11Er7QBbldLa6SoKfPM9PG53dV3qexkckDujxCpPtNigHoLk5wu8B1JX8VPrm/RKHO3k473RuQgJFcBe7vKTSL/OiWdx4UAEJreDj2K1M22MqQTDbe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnE2nlba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnE2nlba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF981F00A3A;
	Thu,  2 Jul 2026 16:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010172;
	bh=7V77QcpPGRiFyoNoflmJfSw8vu8flBxU20AEtqn9sNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnE2nlba1fSaISzbakktw5LnlLz9/gXZAaIHf/oq1lMaiK1ztgQW0koig8vrgRZa2
	 z20TGqQr4iQ9A38RuG/7PAg0/n4Pdxvnh4hjybsm0z5t6UAG6Ee8eFHpNq/mDJmsxe
	 xOoK6Mabc8LCeulCCcgDkELWjscPkMBPW4Tw8u2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Yen <leon.yen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	David Ruth <druth@chromium.org>,
	Felix Fietkau <nbd@nbd.name>,
	Ajrat Makhmutov <rauty@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/204] wifi: mt76: mt7921: avoid undesired changes of the preset regulatory domain
Date: Thu,  2 Jul 2026 18:17:38 +0200
Message-ID: <20260702155118.700357422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Leon Yen <leon.yen@mediatek.com>

commit 2425dc7beaadc39c2636f97f8bdc22dc3cf88149 upstream.

Some countries have strict RF restrictions where changing the regulatory
domain dynamically based on the connected AP is not acceptable.
This patch disables Beacon country IE hinting when a valid country code
is set from usersland (e.g., by system using iw or CRDA).

Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Tested-by: David Ruth <druth@chromium.org>
Link: https://patch.msgid.link/20240412085357.13756-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ajrat Makhmutov <rauty@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 4bd533c4ba9a1c..276dfb9c26e0dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -137,6 +137,13 @@ mt7921_regd_notifier(struct wiphy *wiphy,
 	dev->mt76.region = request->dfs_region;
 	dev->country_ie_env = request->country_ie_env;
 
+	if (request->initiator == NL80211_REGDOM_SET_BY_USER) {
+		if (dev->mt76.alpha2[0] == '0' && dev->mt76.alpha2[1] == '0')
+			wiphy->regulatory_flags &= ~REGULATORY_COUNTRY_IE_IGNORE;
+		else
+			wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_IGNORE;
+	}
+
 	if (pm->suspended)
 		return;
 
-- 
2.53.0



