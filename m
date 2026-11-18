Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019085;
	b=HFkzev0P67xRaOg6f5UthCKcUL+8wxujMoGXjrOjCPwzcXl05TgKKE57LQXtMLZ+LXcS
	 88ojnC7SmAJcnCkdHR/XueQlydZMaWsUk23RyI5j/x1ptKeYJ4iJq09PZVfCRECKTefFV
	 M9eXfXKeuxihUXE7xqyfBKjo51hT2hQ0rJLCZLtBHAt1I9pzyG7RB+XASUtNIHolN6DsM
	 6dLSxlSfLYzhaI9I6T+dyXi9lAl7DrwBfIDt5cVIvMXvR0FtUINwUi5MmsFfsnQqCTNwq
	 ozhEMqfp9a5ARGLCUVJFRGf96v+piRKuiCJobzNm7xh4EI7t+3DZCBORodsGdeER3nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HjYrewJQ4ZL6Pql16OHvBpTpD6Vmuo7fWj6sqbs1bMk=;
	b=V/BhOAYuW2MLOVG5zjMFBvTJBPCADtBBqTfmfoAkY7i55WphZNT2o56B2gDxc+/rhdEO
	 BcQ7ymGjuFPQbC6rnhpIA/ptFPiYyidyjmQ/PYJrTBY2w1bvvsGS75BWzCJ9mPyJO/c3S
	 XwERzVQPvApGZD+Xh5OmgFn9to+dhwnB3Obs41fzIabUDQUHyO4+Rs9KDXBHajbP3OVHp
	 f/8YJS2Fq5LwuSWSzGzE0WMPf+BOrWYNDHQ+6+sm82EovGdAFzoaQLrJnCvnWkxPP0C38
	 861jD6TkJSAiMByTMkvIYHrQITTl2MrqyBxnNvbXiVtyDkUdrKH2KiS4BTe7cnyDkhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIofaFcD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6824D606A320;
	Wed, 18 Nov 2026 16:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIofaFcD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6091F000C4;
	Wed, 18 Nov 2026 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019085;
	bh=HjYrewJQ4ZL6Pql16OHvBpTpD6Vmuo7fWj6sqbs1bMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIofaFcD66j8QoO1XrpnH3c4IgMIqPXh2ifZ72yil16Bree6Yq0C9oYUj8F3qf2Sl
	 PnaTAIIIN2RIKLnEoxhgCAIezkz1L7Ww+mP5U7vwxuPS+0ff7wFdNtGaxAdgoQOyuw
	 +8BMltuS/Nk5TKvFr8NPe9avng4cx/v60MxlzQKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1469/2651] wifi: mt76: mt7996: update the address of an AP link that is added again
Date: Wed, 18 Nov 2026 15:45:09 +0100
Message-ID: <20261118150340.919111634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit cebf7dbfa14a39bdf3913f3fa7452d096c90c15b ]

mt7996_vif_link_remove() only stops an AP link and keeps its BSS, so a
link that is added again takes the early branch of mt7996_vif_link_add().
For other interface types that branch sends DEV_INFO with the new link
address. For an AP it only restarts the link, and the firmware keeps
the own MAC address the link had when it was first created.

The hardware takes A2 of an encapsulation offload frame from that
address. A reload that gives an AP MLD link a new address therefore
makes every data frame on that link carry the old address as TA. The
receiver acknowledges the frame by its RA but cannot find a key for the
TA and drops it, so the AP counts no failure. The BSS_INFO update on
BSS_CHANGED_BEACON_ENABLED restores the BSSID, but nothing sends
DEV_INFO again.

Send DEV_INFO for an AP link as well, before the link is restarted.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Link: https://patch.msgid.link/20261006205936.669125-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 2343db54fb546..0ec919dda036e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -312,15 +312,15 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	if ((mvif->mt76.valid_links & BIT(link_conf->link_id)) &&
 	    !mlink->offchannel) {
-		if (vif->type == NL80211_IFTYPE_AP)
-			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
-							true);
-
 		/* update the link address */
 		ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
 		if (ret)
 			return ret;
 
+		if (vif->type == NL80211_IFTYPE_AP)
+			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
+							true);
+
 		return mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink,
 					       msta_link, true);
 	}
-- 
2.53.0



