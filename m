Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76C0320CDB;
	Mon, 18 Aug 2025 13:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523527; cv=none; b=pKqe2IY1vdSTPYVYRgfpR1YWgI355Yrx6h2vanqCrFI+3hPhL6KmYj2CYJQQabOwGtpdswIPCNBnDrR+oC5pPHCN3YWcQgiVdWmLXPBmQICs8j7v3qpl12JUWr1vqd6MI8zN7bXUXZsdXlPNYSbJU60yPQUVer5ty/U8564mKzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523527; c=relaxed/simple;
	bh=WIVf0MCupzZqXQ59ACVwEDhqszKg9b2p66GjosaW90k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR8FMXKh44MrP9tyH05qaEIiMncsN75st1vcAt+cMFGc6GPtQjh/ia/kmc04ic2FQfQ+Oxw7Wi1oeiBKk6m92ouCZdVgJrXmNtfBk6EqCCngBtKtSg7lntS5eb2KNl+XGLsnK+uTEmTIUunQ7g/6NxZligGx8BwppBYc4yIgr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3jf+7wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3jf+7wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1D4C4CEEB;
	Mon, 18 Aug 2025 13:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523527;
	bh=WIVf0MCupzZqXQ59ACVwEDhqszKg9b2p66GjosaW90k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3jf+7wzTHJU7d/aqyTOlTuQJ+GSOtThKDEsmkXR9Cw1l7M79hiQPIUaDr1b8Wepe
	 zyAfB0YhSyS6OLuBsVmkbGoGskr7iw7qSeJUVVkv7frqYC50nGpnz4u6A+jwErXptr
	 svEAis5wNGyfzs6l8u9Q4N7PIBm1ZrphN5MSMpbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 199/515] wifi: iwlwifi: mld: use spec link id and not FW link id
Date: Mon, 18 Aug 2025 14:43:05 +0200
Message-ID: <20250818124506.027463344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 170db5f873850a04a8eafd3401b2ea36adb20cea ]

In missed beacon handling, we compare the FW link id to the
bss_param_ch_cnt_link_id, which is a spec link id. Fix it.

Reviewed-by: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250723094230.2104f8cac836.I25ed77c2b87bde82a9153e2aa26e09b8a42f6ee3@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 82a4979a3af3..5f7628c65e3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -863,21 +863,23 @@ void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
 {
 	const struct iwl_missed_beacons_notif *notif = (const void *)pkt->data;
 	union iwl_dbg_tlv_tp_data tp_data = { .fw_pkt = pkt };
-	u32 link_id = le32_to_cpu(notif->link_id);
+	u32 fw_link_id = le32_to_cpu(notif->link_id);
 	u32 missed_bcon = le32_to_cpu(notif->consec_missed_beacons);
 	u32 missed_bcon_since_rx =
 		le32_to_cpu(notif->consec_missed_beacons_since_last_rx);
 	u32 scnd_lnk_bcn_lost =
 		le32_to_cpu(notif->consec_missed_beacons_other_link);
 	struct ieee80211_bss_conf *link_conf =
-		iwl_mld_fw_id_to_link_conf(mld, link_id);
+		iwl_mld_fw_id_to_link_conf(mld, fw_link_id);
 	u32 bss_param_ch_cnt_link_id;
 	struct ieee80211_vif *vif;
+	u8 link_id;
 
 	if (WARN_ON(!link_conf))
 		return;
 
 	vif = link_conf->vif;
+	link_id = link_conf->link_id;
 	bss_param_ch_cnt_link_id = link_conf->bss_param_ch_cnt_link_id;
 
 	IWL_DEBUG_INFO(mld,
@@ -889,7 +891,7 @@ void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
 
 	mld->trans->dbg.dump_file_name_ext_valid = true;
 	snprintf(mld->trans->dbg.dump_file_name_ext, IWL_FW_INI_MAX_NAME,
-		 "LinkId_%d_MacType_%d", link_id,
+		 "LinkId_%d_MacType_%d", fw_link_id,
 		 iwl_mld_mac80211_iftype_to_fw(vif));
 
 	iwl_dbg_tlv_time_point(&mld->fwrt,
-- 
2.39.5



