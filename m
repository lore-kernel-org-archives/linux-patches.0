Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214416;
	b=DnyLhOef/WJCIlgPpg0sJ7eRSMfA31q1rXT9p5vJFvoOVp4UxO2r9MjOwtmjchtPYjLV
	 JB2BIGuS4SwVEJk3RwJZtrIavuvPBsYLxbmiGjOGjI6rRznU7cNAhq/L7NuZfokIaF+6K
	 VtE7MNjbHak8eUYUfD4ZyF6yse3r4C1uPZwNvoDXpNzR6U8+liMkZuTZeD5XA+vQ+04kV
	 fJkf+Hike2kXBKbfciLmzgr6Kzu63/wtBiMdEr1p2bHJLOKNzbsZD0EsZySchGyz9Z/Qj
	 ShitwsUCCdctZ/Gd67zeo5W3hbFtOkIAVfQ86U9cDoo5EiiI9syjCnlExUflqUUkJQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++3Q4NAQCIc3/637hA6VVVjKs/gzCPXc2eS+y8eshPw=;
	b=eQ10Z9sHdMV4ILvwbhF3h0M2MfLleh0YDzP3rrLpTZh/i+/0bKhrjXZIsQfDOB4O7gPY
	 ejLVUZn+ENzQHz3c9JMn23g0Q11WLKlc88NnQpDEnRebqoSKNFmI4KTk8Y8gRCBN+pCb9
	 prDjhseKXoPLvIsEB7j5pQBDn9qg3zE3Mq3vo3fkMv/JBE6w0fSd7sqTJhq77shmCI0NK
	 KxpB49HunpGdvCpNO+VLhbebyq+ToHaCRVA2FRmdfJ+g6QmBLOJqLJ86VPuFN4KMC0You
	 uRJVnJDDLSyfOStsFPQ89E2FCnIzLydboaE5iZPCC7IkIu28mPpjJFeH6Wk8L0UwVKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R38XIdY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E17E606A331;
	Wed, 28 Oct 2026 19:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R38XIdY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7671F01825;
	Wed, 28 Oct 2026 19:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214416;
	bh=++3Q4NAQCIc3/637hA6VVVjKs/gzCPXc2eS+y8eshPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R38XIdY4c05ahdv/Rs9hZm/14uoXBZ4pwJ0mA5Iw6H4GKGE9UL/URhWKBH82LJybX
	 nQjBVmuEdJiau1n/3h9KREQaw1vt0mXf2mLIsPYoqYJ7qJFao6aUGg6D+x9cM4C7Ry
	 UbopRCPfEcrx7DSU/NYy+J9zbuN3yEsP8oD+Kniw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0849/1887] wifi: wilc1000: avoid buffer overflow in WID string configuration
Date: Wed, 28 Oct 2026 17:49:05 +0100
Message-ID: <20261028170518.745949900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>

[ Upstream commit fe9e4d0c39311d0f97b024147a0d155333f388b5 ]

Fix the following copy overflow warning identified by Smatch checker.

 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c:184 wilc_wlan_parse_response_frame()
        error: '__memcpy()' 'cfg->s[i]->str' copy overflow (512 vs 65537)

This patch introduces size check before accessing the memory buffer.
The checks are base on the WID type of received data from the firmware.
For WID string configuration, the size limit is determined by individual
element size in 'struct wilc_cfg_str_vals' that is maintained in 'len' field
of 'struct wilc_cfg_str'.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-wireless/aLFbr9Yu9j_TQTey@stanley.mountain
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Link: https://patch.msgid.link/20250829225829.5423-1-ajay.kathat@microchip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/microchip/wilc1000/wlan_cfg.c    | 37 ++++++++++++++-----
 .../wireless/microchip/wilc1000/wlan_cfg.h    |  5 ++-
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c
index 131388886acbf..cfabd5aebb540 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.c
@@ -41,10 +41,10 @@ static const struct wilc_cfg_word g_cfg_word[] = {
 };
 
 static const struct wilc_cfg_str g_cfg_str[] = {
-	{WID_FIRMWARE_VERSION, NULL},
-	{WID_MAC_ADDR, NULL},
-	{WID_ASSOC_RES_INFO, NULL},
-	{WID_NIL, NULL}
+	{WID_FIRMWARE_VERSION, 0, NULL},
+	{WID_MAC_ADDR, 0, NULL},
+	{WID_ASSOC_RES_INFO, 0, NULL},
+	{WID_NIL, 0, NULL}
 };
 
 #define WILC_RESP_MSG_TYPE_CONFIG_REPLY		'R'
@@ -147,44 +147,58 @@ static void wilc_wlan_parse_response_frame(struct wilc *wl, u8 *info, int size)
 
 		switch (FIELD_GET(WILC_WID_TYPE, wid)) {
 		case WID_CHAR:
+			len = 3;
+			if (len + 2  > size)
+				return;
+
 			while (cfg->b[i].id != WID_NIL && cfg->b[i].id != wid)
 				i++;
 
 			if (cfg->b[i].id == wid)
 				cfg->b[i].val = info[4];
 
-			len = 3;
 			break;
 
 		case WID_SHORT:
+			len = 4;
+			if (len + 2  > size)
+				return;
+
 			while (cfg->hw[i].id != WID_NIL && cfg->hw[i].id != wid)
 				i++;
 
 			if (cfg->hw[i].id == wid)
 				cfg->hw[i].val = get_unaligned_le16(&info[4]);
 
-			len = 4;
 			break;
 
 		case WID_INT:
+			len = 6;
+			if (len + 2  > size)
+				return;
+
 			while (cfg->w[i].id != WID_NIL && cfg->w[i].id != wid)
 				i++;
 
 			if (cfg->w[i].id == wid)
 				cfg->w[i].val = get_unaligned_le32(&info[4]);
 
-			len = 6;
 			break;
 
 		case WID_STR:
+			len = 2 + get_unaligned_le16(&info[2]);
+
 			while (cfg->s[i].id != WID_NIL && cfg->s[i].id != wid)
 				i++;
 
-			if (cfg->s[i].id == wid)
+			if (cfg->s[i].id == wid) {
+				if (len > cfg->s[i].len || (len + 2  > size))
+					return;
+
 				memcpy(cfg->s[i].str, &info[2],
-				       get_unaligned_le16(&info[2]) + 2);
+				       len);
+			}
 
-			len = 2 + get_unaligned_le16(&info[2]);
 			break;
 
 		default:
@@ -384,12 +398,15 @@ int wilc_wlan_cfg_init(struct wilc *wl)
 	/* store the string cfg parameters */
 	wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
 	wl->cfg.s[i].str = str_vals->firmware_version;
+	wl->cfg.s[i].len = sizeof(str_vals->firmware_version);
 	i++;
 	wl->cfg.s[i].id = WID_MAC_ADDR;
 	wl->cfg.s[i].str = str_vals->mac_address;
+	wl->cfg.s[i].len = sizeof(str_vals->mac_address);
 	i++;
 	wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
 	wl->cfg.s[i].str = str_vals->assoc_rsp;
+	wl->cfg.s[i].len = sizeof(str_vals->assoc_rsp);
 	i++;
 	wl->cfg.s[i].id = WID_NIL;
 	wl->cfg.s[i].str = NULL;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h
index 614c5673f2328..b0987682892aa 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan_cfg.h
@@ -24,12 +24,13 @@ struct wilc_cfg_word {
 
 struct wilc_cfg_str {
 	u16 id;
+	u16 len;
 	u8 *str;
 };
 
 struct wilc_cfg_str_vals {
-	u8 mac_address[7];
-	u8 firmware_version[129];
+	u8 mac_address[8];
+	u8 firmware_version[130];
 	u8 assoc_rsp[256];
 };
 
-- 
2.53.0



