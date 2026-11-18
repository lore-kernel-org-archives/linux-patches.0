Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019113;
	b=X0ge4/2gDDjP3PM1+tupXzZNJn8ehW0Ra6sB9wnV7daaHncItg2MnkJU6bKxjiYFA2Oe
	 s63I8r4OSDPhQnu62JzI0E3DGM0JFq7IQycUbS6IgC0V6/kRZqsRc2ooRLw/tK8V5/v/0
	 3vlWi+iqe0tPZ99HVD5OsUPCrU39MhAJ6GJNo8bWyoMBt8MX828snzHRfd6Pm0SJoFkCC
	 +tE9mtDlcSjU9t1C/DwcUuJ6N/J+UD0Q8i1ceCQ5yg4yyB9uUfkTST/5lkJPTEG64q2cg
	 ksvrg5efj7SdjHvCul4uSON5Ge8oVgrvVi0pdlFan7P1z0xrnBQF2L41XimWQ2jON2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RrCnbuCzrNmNWeAWpBlgx2lb9f2dsDc/Dd7FKTnmBA0=;
	b=K+EqKRgJO9Q8MjtWEzPCa9B1GZnqLHlR4xLVAtEiaDPgmv5BvnKxZxz1gxFBIFpQiVmk
	 HY2smYwmBN9cgq03zcQF15xRHQ5+ukg8KRUmjSno4dEo887VqO5tB8AUQxV+YkV6vOe5H
	 symIH/yBvpA5HlUgKrpIfCdTjYiRuKTeEtv0eHkToKwPTJJKTiatNYoLTsqL0HWuJ6oyL
	 /RfOepP250DIwB5eFnOI3E/zOO43CTFodzueQ8flN4chCEZdTOHCHRD0C7wGLPLY+vIJ/
	 1GMlQ1jb9ZLkyumM/2BoL4c105uPLe8AQJs3sgtgwuvx5qD1Auh28ZTnLXQ63fi3d/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+uK44Lg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBD606A332;
	Wed, 18 Nov 2026 16:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+uK44Lg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FDA1F000C4;
	Wed, 18 Nov 2026 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019113;
	bh=RrCnbuCzrNmNWeAWpBlgx2lb9f2dsDc/Dd7FKTnmBA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+uK44LgGiQpl0LvEkM+KhGK+/nrsezK9wxN1Jiw6r2j2awOL5w79R/g63iaihh1I
	 yiWJdj7cwyeaFY3GbgFheRoWkMhF4dzZ787MZ8PP6/PYd88yChZLz71WQSam7uZ9b5
	 1sKiEhABjWiHcV5ME97OJNVGP+Gr20gt5/0jYU3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1478/2651] wifi: mt76: mt7996: do not reuse the deflink of a removed station link
Date: Wed, 18 Nov 2026 15:45:18 +0100
Message-ID: <20261118150341.237115304@linuxfoundation.org>
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

[ Upstream commit 51773d5196a0b85884ad245aa788370c4c8ac58d ]

mt7996_mac_sta_init_link() puts a new link in msta->deflink whenever
the station has no primary link. A removed link keeps its msta_link
until the station is removed, and the station has no primary link
after one mt7996_mac_sta_change_links() call removes all of its links
and adds others. If the removed
primary link was in msta->deflink, the new link then overwrites it:
both link slots point to the same msta_link, and the WTBL index of the
removed link is lost, so mt7996_mac_sta_remove() never returns it to
wcid_mask.

Use msta->deflink only if no link slot of the station points to it,
and allocate the msta_link otherwise. Choose the primary link as
before.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Link: https://patch.msgid.link/20261006205936.669125-14-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 7b9ec454b39ce..acd2d15649df5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1150,6 +1150,20 @@ mt7996_sta_deflink_set(struct ieee80211_sta *sta, unsigned int link_id,
 	mt7996_sta_init_txq_wcid(sta, idx);
 }
 
+static bool
+mt7996_sta_deflink_busy(struct mt7996_dev *dev, struct mt7996_sta *msta)
+{
+	unsigned int link_id;
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		if (mt7996_sta_link_protected(dev, msta, link_id) ==
+		    &msta->deflink)
+			return true;
+	}
+
+	return false;
+}
+
 static void
 mt7996_sta_deflink_release(struct mt7996_dev *dev, struct ieee80211_sta *sta,
 			   unsigned int link_id)
@@ -1217,17 +1231,19 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	if (idx < 0)
 		return -ENOSPC;
 
-	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED) {
-		msta_link = &msta->deflink;
-		mt7996_sta_deflink_set(sta, link_id, idx);
-	} else {
+	if (mt7996_sta_deflink_busy(dev, msta)) {
 		msta_link = kzalloc_obj(*msta_link);
 		if (!msta_link) {
 			mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
 			return -ENOMEM;
 		}
+	} else {
+		msta_link = &msta->deflink;
 	}
 
+	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
+		mt7996_sta_deflink_set(sta, link_id, idx);
+
 	INIT_LIST_HEAD(&msta_link->rc_list);
 	INIT_LIST_HEAD(&msta_link->wcid.poll_list);
 	msta_link->sta = msta;
-- 
2.53.0



