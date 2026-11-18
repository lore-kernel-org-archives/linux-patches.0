Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019755;
	b=X7ZqXZYNJovgBLWUzcXjC8I/Z5cjHW6Afw5cnMr7AkECBtBff9a4TdyImVFD6cw5Vylc
	 GoPHsHgU1m4t9huExS24AqakubbDydYo9v7a8RvfYAj/7U69STeXMlGvcQVWlqdHZs7WA
	 NxRYoqEK5eGDybI+A6yT+vDDmmUrBmMl902E0DON4pOMHg1SWvsSHgqK5rqZnjzgEX0UC
	 YBfeIMpDRDLc2sl1fBih78QiPqRYK4qxaO8DC8etlYvR5b1AGIQPuXq9fU9id0D9tkLf8
	 3Ud8gkk2Vp1TP5sfFrql/Z95pgVCw+wo+Hhg5W+69W2GW8WxeaVBcVaGyvY7GDF4Ylw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JL0RnZgBVkNiXH11iWUmlMCtonicuMDlOmz43Q/YIlo=;
	b=NZcecqRKqL526iUlUcnYNbVt4gv1Lv3bYaTwNCQNcU2zq2hrFxY/3o5QzspLtIG9JFbh
	 KyGYNupsIfrXuLKS+2c3R7+MzcQvlDVQfn0vbMGUZ3FecF+Zk0v9RVoyuZFO8W7QjUCN2
	 ehoFcTibWWUcsKj+GRgo6brrY6uCMRR3hh+Jlyr0RKQax9tzssOiVrFzvcUTkE63RH5dL
	 5ZJ7lBDa269pvg7a55kyaOX12ZaklSE8EMB/uLJ2hg9o4ied2kHwNu7OPh8570Kow0vPk
	 OeH+gs8j4Tvzf0v+kb6PXhbmds7kTyanW/XopTHF2XdwaxfStoWQEeZyYOoJvjsqESQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gX0LdF99;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4428D606A32F;
	Wed, 18 Nov 2026 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gX0LdF99
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654A1F000C4;
	Wed, 18 Nov 2026 16:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019755;
	bh=JL0RnZgBVkNiXH11iWUmlMCtonicuMDlOmz43Q/YIlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gX0LdF99M3u7jV00ZjD4bcZOanl4AJJh31NVo0tQolhr4U8SwmgO8Zuz6/9cqgcjj
	 qGjjwxUYskAZCfzQOFLYpS+oKZPYRNqjbVxsgvI3Z+wOmnRBeUFu4RzKQmbiJU/ipo
	 bCun9O1n1OfLWvU+qwT6UVcBIbtndzAeOQ7qIriY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1710/2651] wifi: mwifiex: append hotfix number to firmware version string
Date: Wed, 18 Nov 2026 15:49:10 +0100
Message-ID: <20261118150349.195233772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Chen <jeff.chen_1@nxp.com>

[ Upstream commit 958f20d5aa0aa645068454fdb62ebc625ac9a115 ]

mwifiex_ret_get_hw_spec() parses and logs the FW_HOTFIX_VER_ID TLV,
but the hotfix value is not stored in the adapter structure. As a
result, the hotfix number never appears in the firmware version string
returned by mwifiex_drv_get_driver_version().

Store the hotfix version from FW_HOTFIX_VER_ID and append it to the
firmware version string.

Assisted-by: LLM sparse
Fixes: 7715d79553de ("wifi: mwifiex: Support firmware hotfix version in GET_HW_SPEC responses")
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/20261012123624.3147417-2-jeff.chen_1@oss.nxp.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c    | 10 ++++++++--
 drivers/net/wireless/marvell/mwifiex/fw.h        |  6 ++++++
 drivers/net/wireless/marvell/mwifiex/init.c      |  1 +
 drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  3 ++-
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 29e0f274575e5..268a795db4867 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1594,11 +1594,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 						    api_rev->major_ver,
 						    api_rev->minor_ver);
 					break;
-				case FW_HOTFIX_VER_ID:
+				case FW_HOTFIX_VER_ID: {
+					struct hw_spec_fw_hotfix_ver *hf;
+
+					hf = (void *)tlv;
+					adapter->fw_hotfix_ver =
+						le16_to_cpu(hf->hotfix_ver);
 					mwifiex_dbg(adapter, INFO,
 						    "Firmware hotfix version %d\n",
-						    api_rev->major_ver);
+						    adapter->fw_hotfix_ver);
 					break;
+				}
 				default:
 					mwifiex_dbg(adapter, FATAL,
 						    "Unknown api_id: %d\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 93561116959ac..f254d6d6e3eb9 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1104,6 +1104,12 @@ struct hw_spec_api_rev {
 	u8 minor_ver;
 } __packed;
 
+struct hw_spec_fw_hotfix_ver {
+	struct mwifiex_ie_types_header header;
+	__le16 api_id;
+	__le16 hotfix_ver;
+} __packed;
+
 struct host_cmd_ds_get_hw_spec {
 	__le16 hw_if_version;
 	__le16 version;
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 0c89250137248..e8a5f9b758d60 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -296,6 +296,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->config_bands = 0;
 	adapter->adhoc_start_band = 0;
 	adapter->fw_release_number = 0;
+	adapter->fw_hotfix_ver = 0;
 	adapter->fw_cap_info = 0;
 	memset(&adapter->upld_buf, 0, sizeof(adapter->upld_buf));
 	adapter->event_cause = 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 27559e2ddc317..eb47ade44e1fb 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1003,6 +1003,7 @@ struct mwifiex_adapter {
 	bool host_mlme_enabled;
 	struct ieee80211_txrx_stypes mwifiex_mgmt_stypes[NUM_NL80211_IFTYPES];
 	u8 fw_api_ver;
+	u16 fw_hotfix_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
 	u8 max_p2p_conn, max_sta_conn;
 	struct memory_type_mapping *mem_type_mapping_tbl;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 19196848778c0..1d38747348511 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1144,7 +1144,8 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 	char fw_ver[32];
 
 	ver.l = cpu_to_le32(adapter->fw_release_number);
-	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
+	sprintf(fw_ver, "%u.%u.%u.p%u.%u", ver.c[2], ver.c[1],
+		ver.c[0], ver.c[3], adapter->fw_hotfix_ver);
 
 	snprintf(version, max_len, driver_version, fw_ver);
 
-- 
2.53.0



