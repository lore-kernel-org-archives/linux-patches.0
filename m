Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8A44FDA57;
	Thu, 17 Sep 2026 17:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664940; cv=none; b=s4m+Oer0i3HBfAyiRKvggslS/rNuWaiUByqxxG/ah5P7zdTVyoyMk0s+uMhZYNhVcg8FLFJOmhvdRTxXIXeFASDNuI9UHWYclOiWn7aUzfeRFrhNHTd7qSFINoRsJVQfV4P8vZwL1UJ7wHmPib9esMpRKNuP6okCcVWw3PSjsVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664940; c=relaxed/simple;
	bh=gKHmaUecaIVVY7/wTGdXSSytRWvLWU2rux/exRDO2zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOG6FC6zMNV8Dnu54heD1UX6RPEjenmLeIGsYnZ/EniXEcTvOkMOPYYHaBBQzxzQz3yURn41TsgBHv72C8gP4twYpdS9bnGcqpL3S1y7Le3uP5hYoRXGYUJpN6kHpmIhiNoUWTDgPyV+jaYB28HO8nAQvh2Nc4i7mWZPLJfUwhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5qyoyXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5qyoyXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0DB1F000FF;
	Thu, 17 Sep 2026 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664939;
	bh=OhgtW7Thv/y9nFpKDCOZvXxYPWus3tuTatNBWCrzXfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5qyoyXgfxaxJHlAngH7mTvGoJUdWNWwDyi3UceSqJxNTl5KUUY3M0Y2yppmBMjwE
	 k7kTb9+GECxKunvieKlPOtT3WMiB+uyrKo71jjjGX3v2KsBxhAZn5pzAyoUgzoZ/cO
	 e9KCP509xi+0cwVAs34Q56tCZwBuT0orucbSCp50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgi Valkov <gvalkov@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0539/1250] wifi: mwifiex: replace one-element arrays with flexible array members
Date: Thu, 17 Sep 2026 16:05:34 +0100
Message-ID: <20260917151606.551172302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgi Valkov <gvalkov@gmail.com>

[ Upstream commit 1cb5845a58d8e1f85d5766c6fbcbfddf96c212a1 ]

Replace deprecated one-element arrays with flexible array members.
CONFIG_FORTIFY_SOURCE reports the following warning when
one-element arrays are used as variable-length buffers:

sta_cmd.c:1033 mwifiex_sta_prepare_cmd
memcpy: detected field-spanning write (size 84) of single field
"domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)

Convert affected structs to use flexible array members.
- Preserve existing wire layouts.
- Use DECLARE_FLEX_ARRAY() for structs inside affected unions.

Tested-on: WRT3200ACM, OpenWrt
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260716001728.57799-1-gvalkov@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      | 18 +++++++++---------
 drivers/net/wireless/marvell/mwifiex/join.c    |  8 ++++----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index e9e8966069121..93561116959ac 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -823,7 +823,7 @@ struct chan_band_param_set {
 
 struct mwifiex_ie_types_chan_band_list_param_set {
 	struct mwifiex_ie_types_header header;
-	struct chan_band_param_set chan_band_param[1];
+	struct chan_band_param_set chan_band_param[];
 } __packed;
 
 struct mwifiex_ie_types_rates_param_set {
@@ -886,7 +886,7 @@ struct mwifiex_ie_types_wildcard_ssid_params {
 #define TSF_DATA_SIZE            8
 struct mwifiex_ie_types_tsf_timestamp {
 	struct mwifiex_ie_types_header header;
-	u8 tsf_data[1];
+	u8 tsf_data[];
 } __packed;
 
 struct mwifiex_cf_param_set {
@@ -903,8 +903,8 @@ struct mwifiex_ibss_param_set {
 struct mwifiex_ie_types_ss_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_cf_param_set cf_param_set[1];
-		struct mwifiex_ibss_param_set ibss_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_cf_param_set, cf_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ibss_param_set, ibss_param_set);
 	} cf_ibss;
 } __packed;
 
@@ -922,8 +922,8 @@ struct mwifiex_ds_param_set {
 struct mwifiex_ie_types_phy_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_fh_param_set fh_param_set[1];
-		struct mwifiex_ds_param_set ds_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_fh_param_set, fh_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ds_param_set, ds_param_set);
 	} fh_ds;
 } __packed;
 
@@ -1383,7 +1383,7 @@ struct host_cmd_ds_802_11_snmp_mib {
 	__le16 query_type;
 	__le16 oid;
 	__le16 buf_size;
-	u8 value[1];
+	u8 value[];
 } __packed;
 
 struct mwifiex_rate_scope {
@@ -1551,7 +1551,7 @@ struct mwifiex_scan_cmd_config {
 	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
 	 *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
 	 */
-	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
+	u8 tlv_buf[];	/* SSID TLV(s) and ChanList TLVs are stored
 				   here */
 } __packed;
 
@@ -1683,7 +1683,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
 struct mwifiex_ietypes_domain_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
-	struct ieee80211_country_ie_triplet triplet[1];
+	struct ieee80211_country_ie_triplet triplet[];
 } __packed;
 
 struct host_cmd_ds_802_11d_domain_info {
diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index b48f7febaf03f..259140395d353 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -421,15 +421,15 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	phy_tlv = (struct mwifiex_ie_types_phy_param_set *) pos;
 	phy_tlv->header.type = cpu_to_le16(WLAN_EID_DS_PARAMS);
-	phy_tlv->header.len = cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
-	memcpy(&phy_tlv->fh_ds.ds_param_set,
+	phy_tlv->header.len = cpu_to_le16(sizeof(*phy_tlv->fh_ds.ds_param_set));
+	memcpy(phy_tlv->fh_ds.ds_param_set,
 	       &bss_desc->phy_param_set.ds_param_set.current_chan,
-	       sizeof(phy_tlv->fh_ds.ds_param_set));
+	       sizeof(*phy_tlv->fh_ds.ds_param_set));
 	pos += sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
 
 	ss_tlv = (struct mwifiex_ie_types_ss_param_set *) pos;
 	ss_tlv->header.type = cpu_to_le16(WLAN_EID_CF_PARAMS);
-	ss_tlv->header.len = cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
+	ss_tlv->header.len = cpu_to_le16(sizeof(*ss_tlv->cf_ibss.cf_param_set));
 	pos += sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
 
 	/* Get the common rates supported between the driver and the BSS Desc */
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index dcca71158fc68..0a0458e15e289 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -108,7 +108,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		    "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
-				- 1 + S_DS_GEN);
+				+ S_DS_GEN);
 
 	snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
-- 
2.53.0



