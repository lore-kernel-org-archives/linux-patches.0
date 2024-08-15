Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333E01AE845;
	Thu, 15 Aug 2024 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731180; cv=none; b=GaGQHJFXvbIxu4S04KOmQ8kHltR7QCGPi8LJf7HA/P/hNFMSqPk23KGDvImqSDBmOekSvClfvm29ugq+SsaZqESelSTJYd96RLY6VzZBZGwuTCbkPOh6Plyg16AhdGnn1v26Eyn8sZmIVC+cIlLoiD+5UfdYUNLRA+uvJWF5Jdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731180; c=relaxed/simple;
	bh=OOszv/TKdGMoICoZ2ItFFX2Zilg2dBIVll4qlFQsCp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL/rWbyXSkQiH0Fe/bUnAtI3YNNoh5kV6ab5+9ouW2V6veZC5GYOuL3YjwK1UnDTFX1o76H2LfJId+8l/EDbJUWDBGNT+rLv6U0aWJNZhra3mxO1276fSgU3eoH01Wq/lyvqyKhwzhd0yhFFOr2PcP/nVYR76txNuPT/Jsnxje8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTjWuJeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTjWuJeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966F7C32786;
	Thu, 15 Aug 2024 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731180;
	bh=OOszv/TKdGMoICoZ2ItFFX2Zilg2dBIVll4qlFQsCp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTjWuJeVmjxPZeqM18a/lVEDMP0OLqcJI6iCgEIZ/dPniO7bLY6XdkMaz/VDoyROH
	 RJGXLscXsXrWPlDAOMJUeAwzxwU/6ocabI3Zo5iyR1nXuuJevgklqJ0qzAR1ddGZ7+
	 5f/cx3U+ri2z5P+EjCgA/aAHoRdi9WZ4SWaBDNAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/259] wifi: virt_wifi: dont use strlen() in const context
Date: Thu, 15 Aug 2024 15:23:00 +0200
Message-ID: <20240815131904.622210751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index be5201bd824c2..41958eb15f876 100644
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



