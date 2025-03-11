Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832E25DB0B;
	Tue, 11 Mar 2025 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705440; cv=none; b=tT8daGL0d7nFuNTF5w6d6rGpvUIUI07pWgMUH9SDK4OWKBd0CJeBK8/t3ioRzV0dg4qBrQQf4qSLd9CIfXVwmFyy6DwVpBlXII3wGT+RfIjpDJ4hv8aGZnWLVgzLAA99r1QZAGfsPo1zcaSjjNRrFvyaBxDw7cizVYiyCzHBOHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705440; c=relaxed/simple;
	bh=FmG7N2f9MRQmNSFrn3C63mxG62Qoc5lEw0q6Jij/WRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB2H5WY6NYq8AkbKpRoTD5NLCPCehFsL+UDQH5cePMUccmoxbvc9d60D9PiC9/nm8xgLppmUobVz3WuWBI44dHke/WKpMxfrv54VmqeH3uTEnMc/APENnOYjmXae/z/caEtdOnnx1q4PTZVYds9cTJcul7ckkk93ZwEz+8ouL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pl6+Fzwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pl6+Fzwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DFEC4CEE9;
	Tue, 11 Mar 2025 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705440;
	bh=FmG7N2f9MRQmNSFrn3C63mxG62Qoc5lEw0q6Jij/WRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pl6+Fzwz5BCc3uTAPjzyKRWC3tafwyP/HQd7eus7QpK3TacNsRuo2+yN6+PRGaYX9
	 Gcn7ZREhrcOMM2V/evpKpOJVwx6IBnIsQiB4CMfdDeoC6RMBHtCWK3LCXZO4u044j9
	 aFqpqWk+zIQNOSbM+VyAEBNdsiI0rbHIcXyAgLwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/328] rtlwifi: replace usage of found with dedicated list iterator variable
Date: Tue, 11 Mar 2025 15:56:27 +0100
Message-ID: <20250311145715.565298672@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit a0ff2a87194a968b9547fd4d824a09092171d1ea ]

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220324072124.62458-1-jakobkoschel@gmail.com
Stable-dep-of: 2fdac64c3c35 ("wifi: rtlwifi: remove unused check_buddy_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 13 ++++++-------
 drivers/net/wireless/realtek/rtlwifi/pci.c  | 15 +++++++--------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 8fb0b54738ca9..5898109b1c3e8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1995,8 +1995,7 @@ void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	unsigned long flags;
 
-	struct rtl_bssid_entry *entry;
-	bool entry_found = false;
+	struct rtl_bssid_entry *entry = NULL, *iter;
 
 	/* check if it is scanning */
 	if (!mac->act_scanning)
@@ -2009,10 +2008,10 @@ void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	spin_lock_irqsave(&rtlpriv->locks.scan_list_lock, flags);
 
-	list_for_each_entry(entry, &rtlpriv->scan_list.list, list) {
-		if (memcmp(entry->bssid, hdr->addr3, ETH_ALEN) == 0) {
-			list_del_init(&entry->list);
-			entry_found = true;
+	list_for_each_entry(iter, &rtlpriv->scan_list.list, list) {
+		if (memcmp(iter->bssid, hdr->addr3, ETH_ALEN) == 0) {
+			list_del_init(&iter->list);
+			entry = iter;
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Update BSSID=%pM to scan list (total=%d)\n",
 				hdr->addr3, rtlpriv->scan_list.num);
@@ -2020,7 +2019,7 @@ void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
-	if (!entry_found) {
+	if (!entry) {
 		entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 
 		if (!entry)
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index a31d013d8815a..f8e34ae09a800 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -300,14 +300,13 @@ static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	bool find_buddy_priv = false;
-	struct rtl_priv *tpriv;
+	struct rtl_priv *tpriv = NULL, *iter;
 	struct rtl_pci_priv *tpcipriv = NULL;
 
 	if (!list_empty(&rtlpriv->glb_var->glb_priv_list)) {
-		list_for_each_entry(tpriv, &rtlpriv->glb_var->glb_priv_list,
+		list_for_each_entry(iter, &rtlpriv->glb_var->glb_priv_list,
 				    list) {
-			tpcipriv = (struct rtl_pci_priv *)tpriv->priv;
+			tpcipriv = (struct rtl_pci_priv *)iter->priv;
 			rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
 				"pcipriv->ndis_adapter.funcnumber %x\n",
 				pcipriv->ndis_adapter.funcnumber);
@@ -321,19 +320,19 @@ static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 			    tpcipriv->ndis_adapter.devnumber &&
 			    pcipriv->ndis_adapter.funcnumber !=
 			    tpcipriv->ndis_adapter.funcnumber) {
-				find_buddy_priv = true;
+				tpriv = iter;
 				break;
 			}
 		}
 	}
 
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"find_buddy_priv %d\n", find_buddy_priv);
+		"find_buddy_priv %d\n", tpriv != NULL);
 
-	if (find_buddy_priv)
+	if (tpriv)
 		*buddy_priv = tpriv;
 
-	return find_buddy_priv;
+	return tpriv != NULL;
 }
 
 static void rtl_pci_parse_configuration(struct pci_dev *pdev,
-- 
2.39.5



