Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B429403;
	Tue, 23 Jan 2024 01:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974742; cv=none; b=lUvWeMK+WsvpYu1E0ZVHbQ7H6bYq/jA0XlgrB3XBEhYkC/XU5AzmN+cQPrEy/BUUxKh3dF17o5KUh8KoRK54/ZcUoJZAytJsVJhFy58fj8cCXN6e1E83NZGytPOIne8IxTx5VuvQt9ElrIWW/qrD5B704ZngT1WIOu98glAvoLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974742; c=relaxed/simple;
	bh=4uMabi3SBiTieTnM3vxtY5i6FyhAvuwkWiYTZYqKS70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0LG5yRPGP5JWZ1SEppSOkOkN4en3vAxFsc3VndFempPmG+96JaivK3OJfKd5nmlOasFMbFQQvphgPPaQsXs1Ho5CcG7gBfFfoW1UpmC4+/cLqymyvF6PM1EVYX1F3O4i4oI0g8fZ7wW8kv0CUWaIMf4XaJy0vKt9TDy8mCjNMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+lulWvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+lulWvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB18C433C7;
	Tue, 23 Jan 2024 01:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974742;
	bh=4uMabi3SBiTieTnM3vxtY5i6FyhAvuwkWiYTZYqKS70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+lulWvWBTDCJeAgw29DHyBE/LM38zy6wIzmxwK92TD6elUhmvFMgGAFAo+HNOkTs
	 1EMJN/frUZUUGSPvA33aMqwCU90r713ZU1CS+LyKgzDq7goASvwiU4G6cfs6bpV3Qo
	 07BDj4Q6Ki1yoHTxvwPSOy5oRc7mj7FbmUC2mjzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/583] wifi: iwlwifi: dont support triggered EHT CQI feedback
Date: Mon, 22 Jan 2024 15:53:23 -0800
Message-ID: <20240122235816.721133690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 637bbd5b3cbd0fc6945ebd2e311315b6cca1f9c5 ]

EHT CQI is one of the EHT PHY capabilities. We don't support EHT CQI.
The non-triggered CQI feedback bit was unset in a previous patch,
but the triggered CQI feedback bit wasn't. Unset it.

Fixes: 0e21ec6edbb5 ("wifi: iwlwifi: nvm: Update EHT capabilities for GL device")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231207044813.092528daf59e.I5715769490835819beddb00c91bbc9e806e170cb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 31176897b746..e3120ab893f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1012,7 +1012,8 @@ iwl_nvm_fixup_sband_iftd(struct iwl_trans *trans,
 			  IEEE80211_EHT_PHY_CAP3_NG_16_MU_FEEDBACK |
 			  IEEE80211_EHT_PHY_CAP3_CODEBOOK_4_2_SU_FDBK |
 			  IEEE80211_EHT_PHY_CAP3_CODEBOOK_7_5_MU_FDBK |
-			  IEEE80211_EHT_PHY_CAP3_TRIG_MU_BF_PART_BW_FDBK);
+			  IEEE80211_EHT_PHY_CAP3_TRIG_MU_BF_PART_BW_FDBK |
+			  IEEE80211_EHT_PHY_CAP3_TRIG_CQI_FDBK);
 		iftype_data->eht_cap.eht_cap_elem.phy_cap_info[4] &=
 			~(IEEE80211_EHT_PHY_CAP4_PART_BW_DL_MU_MIMO |
 			  IEEE80211_EHT_PHY_CAP4_POWER_BOOST_FACT_SUPP);
-- 
2.43.0



