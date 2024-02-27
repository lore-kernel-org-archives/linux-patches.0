Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8254A13B2B4;
	Tue, 27 Feb 2024 13:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041942; cv=none; b=qbcRImFR+j87LifZFRUk4AOqPNAxXgxTMBIsM/V67D9opsSCYQH5XXczdgGsLgc0wyb5jKDhXMBZZ+MAyK4K3otx1JUckGW1T2xhvTJWK8bRrmC/d88M70w1sDcAmX94zWjWEbN4sVZqubfKSSmy2VBoDzun/Xwjx/px3StH+2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041942; c=relaxed/simple;
	bh=sciJhZfheStLpZTb1DWwGOghl83kebUezza7TIuRdLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnFNSlEwYKaopUP0htc/KyQddq4q/YEnyiU2RALinTx0sSR9gY8NGYuWZg6/TPt5MGJ3w8oFMb3wSkzW8y1B9ClUZmDak42xQO8OP7qzuJOxSnvDh81yP5FMODbHcY4ilfL4PQTB7zYCX13gXcVGel3oQDEfn7vf7kwIqB1l+oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvgzNOsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvgzNOsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11899C433F1;
	Tue, 27 Feb 2024 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041942;
	bh=sciJhZfheStLpZTb1DWwGOghl83kebUezza7TIuRdLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvgzNOsRBQB6pl0eVCg1/4Oneqi5WKI2P19N7lX9B3RDt44KtwEV5MU30NeEerkOK
	 Ypge8f9dLjI/cemqDMzxHkCB0pObYQd3GxWW6PlVrToOmhG7s2kctnEJjuaAvlT59q
	 L9kTEiCwYhBzYLqMNzi/YCo+rBI0GQmYw3hUO7GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/299] wifi: iwlwifi: do not announce EPCS support
Date: Tue, 27 Feb 2024 14:23:26 +0100
Message-ID: <20240227131628.958887735@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit a23c0af103e184bb1252dddddda040f6641bea7b ]

mac80211 does not have proper support for EPCS currently as that would
require changing the ECDA parameters if EPCS (Emergency Preparedness
Communications Service) is in use. As such, do not announce support for
it in the capabilities.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240201155157.59d71656addc.Idde91b3018239c49fc6ed231b411d05354fb9fb1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index e3120ab893f4e..878d9416a1085 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -668,7 +668,6 @@ static const struct ieee80211_sband_iftype_data iwl_he_eht_capa[] = {
 			.has_eht = true,
 			.eht_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 					IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE2,
@@ -792,7 +791,6 @@ static const struct ieee80211_sband_iftype_data iwl_he_eht_capa[] = {
 			.has_eht = true,
 			.eht_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 					IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE2,
@@ -1003,8 +1001,7 @@ iwl_nvm_fixup_sband_iftd(struct iwl_trans *trans,
 	if (CSR_HW_REV_TYPE(trans->hw_rev) == IWL_CFG_MAC_TYPE_GL &&
 	    iftype_data->eht_cap.has_eht) {
 		iftype_data->eht_cap.eht_cap_elem.mac_cap_info[0] &=
-			~(IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
-			  IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
+			~(IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
 			  IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE2);
 		iftype_data->eht_cap.eht_cap_elem.phy_cap_info[3] &=
 			~(IEEE80211_EHT_PHY_CAP0_PARTIAL_BW_UL_MU_MIMO |
-- 
2.43.0



