Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5840F1EB3D;
	Tue,  8 Apr 2025 12:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116758; cv=none; b=kFE7JeD8FH6I0AdDWsHiBHAOr/cEcDDn9T3Rg9vxnHkoxf7nceuY9flpyFLY7+jfFhhqFInlVxjVTdCEfnK5GyKUD7oPxOHCeDgaj9lduW9ZIVYx5rFSLSl3L79X84SlqFrOVEomECzWIEnu4uUMW4/B2q/VR+phTKlPJGROu2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116758; c=relaxed/simple;
	bh=wNpfxMFMrNlufgDE+XI2ujYRsDNJ5yXa3Bfls1DJW0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPqtjbSJrFgKul1DolDWM+VXTb4Rb7en1xEeTeYUgYLJq8MWvi3Zsf1eVWFriPBMnBoueVZyiPW5wvV31hiyANwVkkwThIatW4tLEcnpB/TkUHwOKbYyH6ZPEdw9+MXy4h1Wax3pagaEg06dkugk6t7ia+8jw0uXmJ9mqxooPx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9++eP2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9++eP2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA429C4CEE7;
	Tue,  8 Apr 2025 12:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116758;
	bh=wNpfxMFMrNlufgDE+XI2ujYRsDNJ5yXa3Bfls1DJW0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9++eP2PL/Bq0klhrWv089lNS2DXu5pbUuJjEGu5I1geqleYio08k0WtQXY4ecII2
	 yGY7Au4cyUpYCnBUd4KLxsI6dDoZ8hT9tAYbCsBkhzEBfwFWGGSm4rZdGD35RQ8kbt
	 NndRwYqtIHf9l2FCCvkc/cKdhtY4oUE9zMi0Mr90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/423] wifi: iwlwifi: mvm: use the right version of the rate API
Date: Tue,  8 Apr 2025 12:49:42 +0200
Message-ID: <20250408104851.707808436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a03e2082e678ea10d0d8bdf3ed933eb05a8ddbb0 ]

The firmware uses the newer version of the API in recent devices. For
older devices, we translate the rate to the new format.
Don't parse the rate with old parsing macros.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.13d70cdcbb4e.Ic92193bce4013b70a823cfef250ee79c16cf7c17@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 65f8933c34b42..0b52d77f57837 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -995,7 +995,7 @@ iwl_mvm_decode_he_phy_ru_alloc(struct iwl_mvm_rx_phy_data *phy_data,
 	 */
 	u8 ru = le32_get_bits(phy_data->d1, IWL_RX_PHY_DATA1_HE_RU_ALLOC_MASK);
 	u32 rate_n_flags = phy_data->rate_n_flags;
-	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK_V1;
+	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
 	u8 offs = 0;
 
 	rx_status->bw = RATE_INFO_BW_HE_RU;
@@ -1050,13 +1050,13 @@ iwl_mvm_decode_he_phy_ru_alloc(struct iwl_mvm_rx_phy_data *phy_data,
 
 	if (he_mu)
 		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK_V1,
+			le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
 						   rate_n_flags),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW);
-	else if (he_type == RATE_MCS_HE_TYPE_TRIG_V1)
+	else if (he_type == RATE_MCS_HE_TYPE_TRIG)
 		he->data6 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_KNOWN) |
-			le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK_V1,
+			le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
 						   rate_n_flags),
 					 IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW);
 }
-- 
2.39.5



