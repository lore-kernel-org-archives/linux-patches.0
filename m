Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993C325E82A;
	Tue, 11 Mar 2025 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706354; cv=none; b=DSBlKMPpooUfgSK3ytRQ0gKl3MoXgDYi72T5XWfCPoG7bCtqTZVzmbqbtHTuh28kTezPX2PoEp2ILNyCtz3QAsPj5qJNRX7F7f432o1F8siihQ2+ZRMZZx59tL544UkE1od7VBwWwEo7CuATMH5Iuk+n4tfM/4F8vk5Tail6iSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706354; c=relaxed/simple;
	bh=GAZiOMrq3azNwhoXjdRRKoUoECwYUWDK7+joXgy0nyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCukZcUDRXUVc2ZhB/HejUmm6YJg6qAyjzcTROTEE2WDlD+ocwh7RHVAIC0s5/V/WLNLvf6wgEbgxLhxGn4D0q6cN60g68ujMlDFv7P1uxuNTT2KtWVDtLAyiC6Gcb0aMP/EZJX3eY85ZZRtn3JCtV5hB5JxqMEukw4dtWq6F6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6PBdbgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6PBdbgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A865BC4CEE9;
	Tue, 11 Mar 2025 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706354;
	bh=GAZiOMrq3azNwhoXjdRRKoUoECwYUWDK7+joXgy0nyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6PBdbgvG0EAYN7fevkLEmiu7wJUr8RwMkyhn5w2YcRF84XuWANKeO720lapww5kj
	 VBbCTf3N/12MObgoeA0/UcsC0eFf2CTPdw1Aq2tB6QpGE/xMQkC6aUxhdIDTFWSCYQ
	 ycW4klilLcrnEVvAULiOnHWeBpny8tBlAc1twAJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/462] rtlwifi: replace usage of found with dedicated list iterator variable
Date: Tue, 11 Mar 2025 15:54:46 +0100
Message-ID: <20250311145759.148707842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1866f6c2acab1..7ec876c6c663e 100644
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
index 70f1cc906502b..f17a365fba070 100644
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



