Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E429051DE1C;
	Wed, 30 Sep 2026 17:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791192; cv=none; b=hPkWcNriUz8AXd3LqIfCKqdKI7uaE1ypDfXtG2xH/jkaskfTOO8luu64mx8ProHGq92XUvt/+cmMlE4XRHNa9SV45p9t0VCPrANFY/FmCZkfmqdQuU3k6ArD/ZrxKfFZ8JRBuHoEvVNv/xI39b/XEQchV22W9Ml9nKfsqVYA5cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791192; c=relaxed/simple;
	bh=Y3c487L6aYsEbYkrM6IY0ao4Z7bkOfxe8cUZ33E6rFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oERzTmEb5G4JhWt0kK1Mgz6fmKKXrUIl5UYnrRbIythC6NaDldStJh/UWEzEG+DT0ypkRH0A2+JLxGsYOerDKj9Tl/WMn91yk3EtnFW/uHlDrrUlG14UddEWIffEPPywLCVagldXx5NzWHTdNunPGzIGm4A2KCsXWiesU3Wpq9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvvKJBMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvvKJBMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8FD1F000FF;
	Wed, 30 Sep 2026 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791190;
	bh=FPl7rY0Ag5kDT55fwIQddI+pDibQHMQOn8xzNmMyX/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvvKJBMqAeYJZ+GqZE5tAKJigNCJCDzO+PHZq9L69LrWeZ0JnThvQUU2Cjkv5u/je
	 he828Qy0WxWXlVLMHY9B/GBD4gb1PWZVzPR/7vZ9fxKfweeuFYCm1Aqa1eumWEJhcx
	 S+EHZp3u4lj0SGzn6V1/F5/gk4CNiLEkRo5MT17w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgi Valkov <gvalkov@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/752] wifi: mwifiex: replace one-element arrays with flexible array members
Date: Wed, 30 Sep 2026 17:21:24 +0200
Message-ID: <20260930152402.875501739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86eebe4182644..bbfb095334a60 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -802,7 +802,7 @@ struct chan_band_param_set {
 
 struct mwifiex_ie_types_chan_band_list_param_set {
 	struct mwifiex_ie_types_header header;
-	struct chan_band_param_set chan_band_param[1];
+	struct chan_band_param_set chan_band_param[];
 } __packed;
 
 struct mwifiex_ie_types_rates_param_set {
@@ -860,7 +860,7 @@ struct mwifiex_ie_types_wildcard_ssid_params {
 #define TSF_DATA_SIZE            8
 struct mwifiex_ie_types_tsf_timestamp {
 	struct mwifiex_ie_types_header header;
-	u8 tsf_data[1];
+	u8 tsf_data[];
 } __packed;
 
 struct mwifiex_cf_param_set {
@@ -877,8 +877,8 @@ struct mwifiex_ibss_param_set {
 struct mwifiex_ie_types_ss_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_cf_param_set cf_param_set[1];
-		struct mwifiex_ibss_param_set ibss_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_cf_param_set, cf_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ibss_param_set, ibss_param_set);
 	} cf_ibss;
 } __packed;
 
@@ -896,8 +896,8 @@ struct mwifiex_ds_param_set {
 struct mwifiex_ie_types_phy_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_fh_param_set fh_param_set[1];
-		struct mwifiex_ds_param_set ds_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_fh_param_set, fh_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ds_param_set, ds_param_set);
 	} fh_ds;
 } __packed;
 
@@ -1349,7 +1349,7 @@ struct host_cmd_ds_802_11_snmp_mib {
 	__le16 query_type;
 	__le16 oid;
 	__le16 buf_size;
-	u8 value[1];
+	u8 value[];
 } __packed;
 
 struct mwifiex_rate_scope {
@@ -1517,7 +1517,7 @@ struct mwifiex_scan_cmd_config {
 	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
 	 *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
 	 */
-	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
+	u8 tlv_buf[];	/* SSID TLV(s) and ChanList TLVs are stored
 				   here */
 } __packed;
 
@@ -1649,7 +1649,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
 struct mwifiex_ietypes_domain_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
-	struct ieee80211_country_ie_triplet triplet[1];
+	struct ieee80211_country_ie_triplet triplet[];
 } __packed;
 
 struct host_cmd_ds_802_11d_domain_info {
diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index 80e187391b25c..760e26eb0d5fc 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -431,15 +431,15 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
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
index 48ea00da1fc9e..6b7ffe3517703 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -120,7 +120,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		    "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
-				- 1 + S_DS_GEN);
+				+ S_DS_GEN);
 
 	snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
-- 
2.53.0



