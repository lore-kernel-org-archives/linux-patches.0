Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A031218D630;
	Thu, 15 Aug 2024 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729358; cv=none; b=ukXgguZmDOpIVJbbKT+R3VSx9aLN6Pd43K8f/1BNXVaxZpAnlEr8jP2BEUP94sKt3M4E3nO/rADV9qSdHhwR8S1EhAO0yOxutrPfu3UM7oFLybCUgjj8rSb5iYXSZxdNViZXB2DJh/dpOio0g2Syj09arhVd37kQguvSGibmt1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729358; c=relaxed/simple;
	bh=5HvrtVKuYSuvMB8GiZJJW0JI6MScNN4KX9MimJ7eEOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuDrGFVzsQPL4fEIqbLyhrnUmtkN2fb7famh6fb3PQ1Tz1+RlZO04sDUO+v6H/XsYNOtaxC4k8NAiRHTKFaCW/kzVj5zJwE5baehC3DLki8f7+aTxbOmxNjJNRHaHiIWMyvk5kGfMbZy6I7e0IYb3egXdSvglkFBebc/MWhA7tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqdt0XBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqdt0XBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6967C32786;
	Thu, 15 Aug 2024 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729358;
	bh=5HvrtVKuYSuvMB8GiZJJW0JI6MScNN4KX9MimJ7eEOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqdt0XBy0O0fMj0HTuRqWzTxZExa5WyQ3sk0DSS1SSvt4PGcYHwpjAFhXXC9hYVEP
	 M4Ob3sOWiR4T4XyFuRjgIdNcVDAcw3hgETuz6TAdaAi/ilB078nNv3nczT1D14Ov3L
	 xe9oWCIQjFj1BQ3klCdMlqFPPyo5Dt1NDSjp0xq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/484] wifi: virt_wifi: dont use strlen() in const context
Date: Thu, 15 Aug 2024 15:18:51 +0200
Message-ID: <20240815131944.105318514@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/virt_wifi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index ec730bc44adc1..dd6675436bda6 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
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



