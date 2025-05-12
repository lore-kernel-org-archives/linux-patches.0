Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D151D7E41;
	Mon, 12 May 2025 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072826; cv=none; b=sER1a2OM7lqamIwM3V2tOPpnCYQFnRpSxJq9eoFkKK3eZimER5GLQJXQxqb4RswrReYXbkSLg53IvLJlZEUofs4YTjwpT50HuTKrcpFG6FSig1ZjYOmyHpx9vGqGUfYh5Ns3p1po9DcpuIRjZ/5CUEFprqyoeHE/AcnFMIkqzPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072826; c=relaxed/simple;
	bh=0/MJtRJRhdO3ynq7XMaL8fRLPUNZaAkFCRU32KRgOPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awWuC+FSMUj9xlMoVf4VoFz12pMSh7IKCui6DMo2ITOjEwMC1UQiuiYqXtVV7oTQ7NY62P17HBfivn8ykpEJj+/ppKLPMVPA1ISwu+CcKPnWUxu9pWGrrWRk5dlvIUdeCJBwzJrSsK55sWAb7BLRWYJ/ok5QxW8A21IpbN/5pd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTG+cF/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTG+cF/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB46C4CEE7;
	Mon, 12 May 2025 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072826;
	bh=0/MJtRJRhdO3ynq7XMaL8fRLPUNZaAkFCRU32KRgOPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTG+cF/cF4agKSi7bvBGr60o0sGkCgl/W//aAIqecN+Kh+Eo68B1AE+8bBuPLgFCH
	 fSQS8J/n2iq8K/uPKcyA0cmXn+BlQFQadWNNJDRuLFKZSJvsY2rr7x2OaaUCEfe+3W
	 2JaPex9mWeOs4PVCrYnMChxFgb+gH1jSIXwYpe0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/184] wifi: mac80211: fix the type of status_code for negotiated TID to Link Mapping
Date: Mon, 12 May 2025 19:43:49 +0200
Message-ID: <20250512172042.860392400@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

[ Upstream commit e12a42f64fc3d74872b349eedd47f90c6676b78a ]

The status code should be type of __le16.

Fixes: 83e897a961b8 ("wifi: ieee80211: add definitions for negotiated TID to Link map")
Fixes: 8f500fbc6c65 ("wifi: mac80211: process and save negotiated TID to Link mapping request")
Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Link: https://patch.msgid.link/20250505081946.3927214-1-michael-cy.lee@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h |  2 +-
 net/mac80211/mlme.c       | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3750e56bfcbb3..777f6aa8efa7b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1524,7 +1524,7 @@ struct ieee80211_mgmt {
 				struct {
 					u8 action_code;
 					u8 dialog_token;
-					u8 status_code;
+					__le16 status_code;
 					u8 variable[];
 				} __packed ttlm_res;
 				struct {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ad0d040569dcd..cc8c5d18b130d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7177,6 +7177,7 @@ ieee80211_send_neg_ttlm_res(struct ieee80211_sub_if_data *sdata,
 	int hdr_len = offsetofend(struct ieee80211_mgmt, u.action.u.ttlm_res);
 	int ttlm_max_len = 2 + 1 + sizeof(struct ieee80211_ttlm_elem) + 1 +
 		2 * 2 * IEEE80211_TTLM_NUM_TIDS;
+	u16 status_code;
 
 	skb = dev_alloc_skb(local->tx_headroom + hdr_len + ttlm_max_len);
 	if (!skb)
@@ -7199,19 +7200,18 @@ ieee80211_send_neg_ttlm_res(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(1);
 		fallthrough;
 	case NEG_TTLM_RES_REJECT:
-		mgmt->u.action.u.ttlm_res.status_code =
-			WLAN_STATUS_DENIED_TID_TO_LINK_MAPPING;
+		status_code = WLAN_STATUS_DENIED_TID_TO_LINK_MAPPING;
 		break;
 	case NEG_TTLM_RES_ACCEPT:
-		mgmt->u.action.u.ttlm_res.status_code = WLAN_STATUS_SUCCESS;
+		status_code = WLAN_STATUS_SUCCESS;
 		break;
 	case NEG_TTLM_RES_SUGGEST_PREFERRED:
-		mgmt->u.action.u.ttlm_res.status_code =
-			WLAN_STATUS_PREF_TID_TO_LINK_MAPPING_SUGGESTED;
+		status_code = WLAN_STATUS_PREF_TID_TO_LINK_MAPPING_SUGGESTED;
 		ieee80211_neg_ttlm_add_suggested_map(skb, neg_ttlm);
 		break;
 	}
 
+	mgmt->u.action.u.ttlm_res.status_code = cpu_to_le16(status_code);
 	ieee80211_tx_skb(sdata, skb);
 }
 
@@ -7377,7 +7377,7 @@ void ieee80211_process_neg_ttlm_res(struct ieee80211_sub_if_data *sdata,
 	 * This can be better implemented in the future, to handle request
 	 * rejections.
 	 */
-	if (mgmt->u.action.u.ttlm_res.status_code != WLAN_STATUS_SUCCESS)
+	if (le16_to_cpu(mgmt->u.action.u.ttlm_res.status_code) != WLAN_STATUS_SUCCESS)
 		__ieee80211_disconnect(sdata);
 }
 
-- 
2.39.5



