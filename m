Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA1214199F;
	Tue, 27 Feb 2024 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040782; cv=none; b=aXORPO2kpXoJgXdC/QZA29xzLJOHI117YbG4fx2W6CiI6t2Wb1hJ4iP4H16o9RrLGSmhGmoADnQR1T1sYnywW3p/zzGBN4npjCeck1GfqNIbYKvtJ0bfFS4nI+zWWrHZ6HbSCcmMCU7rkLVP+B1uOtkzWXOBliRt9d2eVdRZSTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040782; c=relaxed/simple;
	bh=VMS+fMwbHcQhYYnijFNWKbcU4x/ENqQd+HAGKOi8+IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOXNZUKx6cNXoIv1+muL1ZnY+TTS8l87eSqWUgfdqOcLgRBOAYm8Y+5nVitGkU6IlpFlgG7i81Lbzc2olrqI0NN2Z9pFcyO32Pm+th3PBEs3rRNE/wZeaaK2dVkIzxe41UQAQ5qNxocH/dJHs9UK5TKYZRbSrdSXw9QQ4AJXi1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+cy/f03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+cy/f03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFE3C433C7;
	Tue, 27 Feb 2024 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040782;
	bh=VMS+fMwbHcQhYYnijFNWKbcU4x/ENqQd+HAGKOi8+IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+cy/f03JBzhnzIPd0jypbip4e/W2ftChCWXCpwcp6oX6F2FNhe4LotKuCN6jD7/M
	 6rx8MIxhm1DYDhS+uWpFs1EeR+++BVmSmkATdRj/n/LHQmZJAJPD6Vg+avIRI2O37l
	 QqkKPcQRQXo55YoxxYeYbuRHE2xAYHqHU6GpVNgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 106/334] wifi: iwlwifi: do not announce EPCS support
Date: Tue, 27 Feb 2024 14:19:24 +0100
Message-ID: <20240227131633.906133253@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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
index 480f8edbfd35d..678c4a071869f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -668,7 +668,6 @@ static const struct ieee80211_sband_iftype_data iwl_he_eht_capa[] = {
 			.has_eht = true,
 			.eht_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 					IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE2 |
@@ -793,7 +792,6 @@ static const struct ieee80211_sband_iftype_data iwl_he_eht_capa[] = {
 			.has_eht = true,
 			.eht_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 					IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
 					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE2,
@@ -1020,8 +1018,7 @@ iwl_nvm_fixup_sband_iftd(struct iwl_trans *trans,
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



