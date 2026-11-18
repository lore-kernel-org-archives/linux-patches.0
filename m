Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041339;
	b=RKkBA3hUOVBf8s3HvX4jZ2kJnmgJcm+z3DUeG1rblQJmCcZjYmsQopORt6MkGDKapzEl
	 ru0CCN7KOBW5KY6OAZOdqAjryK3TO89PJsh6OnxetNx8irVkM9B3P3U7kZ7beaYOEiMhs
	 Y864cmSsSTtaW69+oHlnQr8cJ8QhFJy8gg8ALvgVFv/tin03ztEeDtZcacF3SXLK/8MSQ
	 ZwLPlOLM+EWmP+QGZdPsA9JN2VqkAuHWK8s6kZSGWfmTWDUlrnOjDZyMPp8ecDJNQ1Yt7
	 47KdEM/uimP1OFOsSsxF32oiqKQdbT6QNjuDoNOt5wkvSYP5wznQvnRYEacg7SpAYEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Rb4dKx8MMdFtZ+6+RsNWZ1Cut+lpbSE/ctKKIMOqCk=;
	b=xNm+Xruh1SLGcOKejptCxM/h489Jcql81Zz28KFPf3EoI6O5F3HPvv2++XskVdQjxYgI
	 iqNJc40JxklyOksQBQFuf3s4PlMsb9/2QkxsxS1lMuYP8/7MWOQJBvKh7mt37DTZSoupd
	 38NNz+XFAMt9XmMVL9Iwi7Ar+hywGjkseR/5IDJg1MdjR6aPk7vq4OFt3OLIf2sVwdG2y
	 pgF4I6mf5kZt19RaIjKhRDydjtb8jLY8RO8/gpFzagIyJJVHOuxpwP/qsiNKOXNxdYK2j
	 Xp+L7SHt5uQoqiB32FLpRUP3tALcJPxRte4j/3sS02+1GzVm93o6r2PPTeZZU3cSkcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9fpdixX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04044606A31C;
	Wed, 18 Nov 2026 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9fpdixX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D7D1F000C4;
	Wed, 18 Nov 2026 22:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041338;
	bh=+Rb4dKx8MMdFtZ+6+RsNWZ1Cut+lpbSE/ctKKIMOqCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9fpdixXw1fhRZKsmHYwB1peEV2F1bEH+QsNjNNsJ30tx5FRqmPZBd4mbpyxrK2/4
	 2vgjK9tikXkQU40ftpWKqFGQts67+b0M4nOUadbARIvN7wHNU6MKNGBKH1gm6sgs5z
	 yZCjLlOOTUEDyYaxn+niTO2+1W6BmAyKISVYqTeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2778/3318] wifi: mwifiex: append hotfix number to firmware version string
Date: Wed, 18 Nov 2026 15:56:40 +0100
Message-ID: <20261118150444.043307227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3756aa247e77d..07d06dfe0fe1f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1607,11 +1607,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
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
index 07ce071735d3e..029016394cfa3 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1059,6 +1059,12 @@ struct hw_spec_api_rev {
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
index 64d651c78570d..cdd98bbfbd72f 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -289,6 +289,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->config_bands = 0;
 	adapter->adhoc_start_band = 0;
 	adapter->fw_release_number = 0;
+	adapter->fw_hotfix_ver = 0;
 	adapter->fw_cap_info = 0;
 	memset(&adapter->upld_buf, 0, sizeof(adapter->upld_buf));
 	adapter->event_cause = 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index dc6b4cf616bea..d4c8daa19dc90 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -999,6 +999,7 @@ struct mwifiex_adapter {
 
 	bool ext_scan;
 	u8 fw_api_ver;
+	u16 fw_hotfix_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
 	u8 max_p2p_conn, max_sta_conn;
 	struct memory_type_mapping *mem_type_mapping_tbl;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 54a77304a64ea..1cea54f113dc8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1090,7 +1090,8 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 	char fw_ver[32];
 
 	ver.l = cpu_to_le32(adapter->fw_release_number);
-	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
+	sprintf(fw_ver, "%u.%u.%u.p%u.%u", ver.c[2], ver.c[1],
+		ver.c[0], ver.c[3], adapter->fw_hotfix_ver);
 
 	snprintf(version, max_len, driver_version, fw_ver);
 
-- 
2.53.0



