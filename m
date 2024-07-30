Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC298BE8;
	Tue, 30 Jul 2024 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357256; cv=none; b=emsF1IfYq8zMfqytsqewIhZK8fgDdghIJjSnN7AP1cZ59EMfO8OfJRFupmhLA9DWpU3egaP9FXQp4KrHhSYrUDi/XZhdMwL0a7Jrc+69GCRv7uupxEl1KXyrmImc9MbYK34sZRkbXmFd/MoBMp7ndInNkmGT192NBIUR/VYGCjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357256; c=relaxed/simple;
	bh=pZRpqMqMYdT93C1Xh566H5TWjxu1aaMa4J5zL41eNt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2xcrREm76zkbxGnrKmcOG1g1pZaz52PzAWuGnOhGU4LkUL81BjCLsqV1fKf3hNf41MbxX3P17muFaP1hw2FV7omNX11c0FXn93O/paEbW7oMtInfjtjv2/nQOpKdHNR2RC8Zfj9ZCn6iiuLvl74vACKOFACICVmpNPf1TOME0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLKH/gxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLKH/gxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA81C32782;
	Tue, 30 Jul 2024 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357255;
	bh=pZRpqMqMYdT93C1Xh566H5TWjxu1aaMa4J5zL41eNt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLKH/gxoFWZrw+qLf01fFVqgOPxWf3IS9iqzVp9C92kOMkDf5xkxbsDvnw0r1eZJs
	 SXMWUIwYqlI58V8W2jAORCk967/KCEa/h9CQpQLIrqn1H81uDRsVHG6DefSU3kR4v9
	 YP2Ea8QaoaD2oJZF7SGFKpbiBkzD0LVaFJs0yLt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 237/809] wifi: virt_wifi: dont use strlen() in const context
Date: Tue, 30 Jul 2024 17:41:53 +0200
Message-ID: <20240730151733.965182284@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6e909f489191b365364e9d636dec33b5dfd4e5eb ]

Looks like not all compilers allow strlen(constant) as
a constant, so don't do that. Instead, revert back to
defining the length as the first submission had it.

Fixes: b5d14b0c6716 ("wifi: virt_wifi: avoid reporting connection success with wrong SSID")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407090934.NnR1TUbW-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202407090944.mpwLHGt9-lkp@intel.com/
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/virt_wifi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virtual/virt_wifi.c b/drivers/net/wireless/virtual/virt_wifi.c
index d2271a7644a01..4ee3740804667 100644
--- a/drivers/net/wireless/virtual/virt_wifi.c
+++ b/drivers/net/wireless/virtual/virt_wifi.c
@@ -137,6 +137,7 @@ static struct ieee80211_supported_band band_5ghz = {
 static u8 fake_router_bssid[ETH_ALEN] __ro_after_init = {};
 
 #define VIRT_WIFI_SSID "VirtWifi"
+#define VIRT_WIFI_SSID_LEN 8
 
 static void virt_wifi_inform_bss(struct wiphy *wiphy)
 {
@@ -148,7 +149,7 @@ static void virt_wifi_inform_bss(struct wiphy *wiphy)
 		u8 ssid[8];
 	} __packed ssid = {
 		.tag = WLAN_EID_SSID,
-		.len = strlen(VIRT_WIFI_SSID),
+		.len = VIRT_WIFI_SSID_LEN,
 		.ssid = VIRT_WIFI_SSID,
 	};
 
@@ -262,7 +263,7 @@ static void virt_wifi_connect_complete(struct work_struct *work)
 		container_of(work, struct virt_wifi_netdev_priv, connect.work);
 	u8 *requested_bss = priv->connect_requested_bss;
 	bool right_addr = ether_addr_equal(requested_bss, fake_router_bssid);
-	bool right_ssid = priv->connect_requested_ssid_len == strlen(VIRT_WIFI_SSID) &&
+	bool right_ssid = priv->connect_requested_ssid_len == VIRT_WIFI_SSID_LEN &&
 			  !memcmp(priv->connect_requested_ssid, VIRT_WIFI_SSID,
 				  priv->connect_requested_ssid_len);
 	u16 status = WLAN_STATUS_SUCCESS;
-- 
2.43.0



