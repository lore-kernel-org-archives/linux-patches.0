Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216555;
	b=OWcoVq07Dr2BAxwkiGM69r5KQD6u0d8pIBmii0H7s2aqoR286sd88x9Vf2gh8iXq5x7s
	 SSAfaMTlNZtm/H/dIqrPS7qsJ7bNZTWaJEJsaCvWZUrRscy7Bkm8YerZT5NlenKOCcMl9
	 2PiRxHh93S2UxTI2ELsZc941uNhnuCHpjdpU9zCw/uAWwoa0qn0nU5DIvEIvxu4rgiv6V
	 Mzr/yENj/yQ3+PsXIY+0N1JUSe7VvyiNlbr/85sVABJqxnk0/iHKidYt6y+3A6eX+UU7L
	 +3ONTNYgyQJPZb8Q7zm2pzaxtu5ABfQC2lZU0ys84j9GiSOYICw6/aBOH8jiuThbaTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1QzQN4UiRWXkRfRiz1u/A6nVmoHOayBGhAKo89FCIHU=;
	b=Q60X1Ajf1NvJm190ymSs+5y8eTNA2+0EjYSaW6uO5P+0WR4UtkNedbTgRs/E2ENtHu3f
	 B9YqffcMvMxaaDf/d8MZLdQbXl+In8MF5klf3V4NFX2AfB7VogMbytqtbUvRSW5bGlhMv
	 ahICV1PHgFoR2sJZWI4hGNOZls/dYT7/kI/Ie4/B6XA0We0KjdqM6l9IekEtUD9C8DYNM
	 hVS9SZbNSejPc6WQpEspwoWIWleSmODljwGwxUt4ZWh/CekBQOmE9kLxBeRcIzl/O8BW6
	 vY9bJpx1iKg1T0HUFUZ0OogcjKB/sPDJ7fWUtiX/drfX9OTpNF4vJzn9Ji3H1RZwrLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qJbwoiU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB71606A31C;
	Wed, 28 Oct 2026 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qJbwoiU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA031F031E0;
	Wed, 28 Oct 2026 19:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216554;
	bh=1QzQN4UiRWXkRfRiz1u/A6nVmoHOayBGhAKo89FCIHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qJbwoiUxQ1PTyStBZbpfiowjNb/Lq7OiZT682h+znyp01MC7MfW+FhdVNOTmukNv
	 pWtKzsKXsxoJkcCIDNpJZm/hkxcL8v3ABLUnuNhfF+yKxyTEpf+l9dzX/s5itIHaU5
	 hap+RZ4TwHD+a9kbeKZcMzErCBxXjkhC8ZWOHNt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1595/1887] wifi: mt76: mt7915: unwind state on add_interface failure
Date: Wed, 28 Oct 2026 18:01:31 +0100
Message-ID: <20261028170535.765857494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2fb6480c52f611338e1b0abe5e6219be1fc9ab75 ]

When mt76_wcid_alloc() fails, mt7915_add_interface() returned without
clearing the vif_mask/omac_mask bits it had already set, without removing
the firmware dev info added earlier, and without clearing a monitor_vif
pointer to the vif mac80211 is about to free. mac80211 does not call
remove_interface() for a failed add, so the indices and firmware dev
entry leaked permanently and testmode could dereference the stale
monitor_vif. Add a proper error unwind.

Fixes: b619e01380ee ("mt76: fix MBSS index condition in DBDC mode")
Link: https://patch.msgid.link/20260724124813.3961474-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 0b79039e53178..4707e7727f179 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -239,7 +239,7 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
 	if (idx < 0) {
 		ret = -ENOSPC;
-		goto out;
+		goto err;
 	}
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
@@ -270,7 +270,17 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	mt7915_mcu_add_sta(dev, vif, NULL, true);
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 
+	mutex_unlock(&dev->mt76.mutex);
+
+	return 0;
+
+err:
+	dev->mt76.vif_mask &= ~BIT_ULL(mvif->mt76.idx);
+	phy->omac_mask &= ~BIT_ULL(mvif->mt76.omac_idx);
+	mt7915_mcu_add_dev_info(phy, vif, false);
 out:
+	if (phy->monitor_vif == vif)
+		phy->monitor_vif = NULL;
 	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
-- 
2.53.0



