Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AF113398C;
	Tue, 23 Jan 2024 00:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969315; cv=none; b=B8swLZC8T/G5FuvXtp4AWW16bUIrh5KmThtUY9GM8yrLZw1Nyv3tmC9td6MbZpV6Q6ctUTS0aE9HK29UPZfK5a01Bwz1DR+bfjMlAMvGLSidF2j1M7RGnGSub6eHYY3VHmWsQtov8NPvqCBFWj64Qeli+lmCGru0Y2NCzI9dvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969315; c=relaxed/simple;
	bh=AYLPSnzZz7hgUfJvKgIijB37gyqdmpJE4YDuUKMebjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diZcR2xSq1J/9KYbStiQSj3qwDmbhgx0coQ3HbSJ3SMvj/EroJd0HgbMx01vKjGi2b+CWmpSCFxTqevhlI1i8fX8YxBrM8Q3SyyQocPhIDxgKRtUuTiM5cNf3c7MK3G9mteDyPNnNxK0t6dOq50hNOMkTPFlqAOe8sEbEHQQ5Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3jKt5Av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3jKt5Av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97982C43399;
	Tue, 23 Jan 2024 00:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969314;
	bh=AYLPSnzZz7hgUfJvKgIijB37gyqdmpJE4YDuUKMebjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3jKt5AvuzhaMnmCJBO8J44iIfRYk0D1YXEjntIVZscjI5U0GIp9InBuuH59UUChR
	 srdcLu88KddslMJTXU+tjv2674iZuw20rEw03r9QXMA0LgHBlYXfBDICAKB8h24sV9
	 WP9t7hAqY5hyeHDqXw6lA0blStydCNk13yZUr7hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 169/641] wifi: iwlwifi: dont support triggered EHT CQI feedback
Date: Mon, 22 Jan 2024 15:51:13 -0800
Message-ID: <20240122235823.298774767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index 6015e1255d2a..480f8edbfd35 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1029,7 +1029,8 @@ iwl_nvm_fixup_sband_iftd(struct iwl_trans *trans,
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



