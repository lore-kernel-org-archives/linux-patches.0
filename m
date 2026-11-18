Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031700;
	b=VPqmrPySqEuZ9/l2nPXrENANxYfrgk++EA8Ayn3TMG1hm6KPL58/m349BP+BhnNWvGsq
	 J/FGf8Un0T3I7kSa9VDZ/cEVoRjmcis2cCIwakjUxOIS3KXn7miMGMzmxvunV0Q3z0NUm
	 7vL3n45P0wfkesS7bNy1EntmzmhZsRAmMCPgwvV+bxdHgZ5JS8Zp5tB6myXAAOCn7whuU
	 5ENj5qQIvHG8TzhNQzqIJ3AlfF7ps+h2n7cZYNbZUTMDNA4TyewpizKWRQxZX6C7AKaB6
	 qlnPdaCt2r6rbFYO6Dj/+VomZWcWmhRqZVMk2ipEA7SOKlfCpgSRI7PFCL8xIgJszGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+E2uthcrZCGwOKKXBcZY0D40fcRdwOy54rravRvjMls=;
	b=Gqe4G3P1Wx4eGDsMIcMEc1wpdrOp/LuOQ99ii6/AopodzuWVegLOXRSEnm8w+1ATg921
	 KJnqREnhVzsFsgKZw1uOnQLvM+7fD1BL/CTuspAWfqLmLjLBmrSvRDkulB2HYyCRv9Nq8
	 kw6SAFKnvtxP3MctgDz8tAVdqKdqKyn+QePKej2k5jrzpkZhx6wRT2x/Ei+A+yXNFmKvA
	 eT4/4i9DNrTnq2VBTQw33MvnQInlH6uQmKV3+0DDFjTccQYldrMe+uig6x9E9IogQjEAH
	 9j2x9BSufC9Ud//KkVajxfsmczH/4i85ZbFe7n1yvfbuWZ1IbLvLBY2Q4XT0Fvzfwfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfIsf1XC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3099C606A31C;
	Wed, 18 Nov 2026 19:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfIsf1XC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C031F000C5;
	Wed, 18 Nov 2026 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031700;
	bh=+E2uthcrZCGwOKKXBcZY0D40fcRdwOy54rravRvjMls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfIsf1XCUOHQ0xu4QzCpFVcHOJZTLMImwSsbT+e+/P4XBZSE4y5g5oPdn6T5e8NII
	 H2rIcRNlki69Dzx7wZrf5XKhXBV/I+39kSY5lToteGAmxiq/m2qM3Xd2wiyKMXC97L
	 ZMjOfL8pP5boyn81WvSsxxfkxUgJ2oIlPxNvAyvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1109/1756] wifi: mwifiex: append hotfix number to firmware version string
Date: Wed, 18 Nov 2026 15:53:56 +0100
Message-ID: <20261118150054.308906059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b30ed321c6251..2b1ca4602bdc2 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1621,11 +1621,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
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
index 2a7ebac212385..7f9b4d3e18c40 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1099,6 +1099,12 @@ struct hw_spec_api_rev {
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
index 4caf54954894d..638f24ba520d9 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -295,6 +295,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->config_bands = 0;
 	adapter->adhoc_start_band = 0;
 	adapter->fw_release_number = 0;
+	adapter->fw_hotfix_ver = 0;
 	adapter->fw_cap_info = 0;
 	memset(&adapter->upld_buf, 0, sizeof(adapter->upld_buf));
 	adapter->event_cause = 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 566adce3413cb..b39d42061fc57 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1010,6 +1010,7 @@ struct mwifiex_adapter {
 	bool host_mlme_enabled;
 	struct ieee80211_txrx_stypes mwifiex_mgmt_stypes[NUM_NL80211_IFTYPES];
 	u8 fw_api_ver;
+	u16 fw_hotfix_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
 	u8 max_p2p_conn, max_sta_conn;
 	struct memory_type_mapping *mem_type_mapping_tbl;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 7c8e5e17a9969..7a8d1029fea63 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1089,7 +1089,8 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 	char fw_ver[32];
 
 	ver.l = cpu_to_le32(adapter->fw_release_number);
-	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
+	sprintf(fw_ver, "%u.%u.%u.p%u.%u", ver.c[2], ver.c[1],
+		ver.c[0], ver.c[3], adapter->fw_hotfix_ver);
 
 	snprintf(version, max_len, driver_version, fw_ver);
 
-- 
2.53.0



