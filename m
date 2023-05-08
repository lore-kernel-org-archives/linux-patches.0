Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187BD168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9D3C433EF;
	Mon,  8 May 2023 10:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542312;
	bh=Pcm9NjD0tWqqHwFUtCDpqhZXaCNABcDIt2eScz57qdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9flCNUi/dMCa5+YlwqBtPBPAOesbXOcGFmUQncG3Xh4R/JneaoAD9hQCnw3EHZTv
	 j4ZHC8AdB4DCqellPSETRZhtM+GEWmX8R0ep8r8Fl8f4HoPekmbAsz8DBx9vCbRMKl
	 bsbgt+ADjfUopEu6KbcVxhIo+7OvQUUNkM9Sz9x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 396/663] wifi: mt76: mt7996: fix eeprom tx path bitfields
Date: Mon,  8 May 2023 11:43:42 +0200
Message-Id: <20230508094440.946295923@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 72fc0df3006ce5c109f9c68f0724e44c47b4ec7b ]

Swap the tx path bitfields of band1 and band2 to read correct setting.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h
index 8da599e0abeac..cfc48698539b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h
@@ -31,11 +31,11 @@ enum mt7996_eeprom_field {
 #define MT_EE_WIFI_CONF2_BAND_SEL		GENMASK(2, 0)
 
 #define MT_EE_WIFI_CONF1_TX_PATH_BAND0		GENMASK(5, 3)
-#define MT_EE_WIFI_CONF2_TX_PATH_BAND1		GENMASK(5, 3)
-#define MT_EE_WIFI_CONF2_TX_PATH_BAND2		GENMASK(2, 0)
+#define MT_EE_WIFI_CONF2_TX_PATH_BAND1		GENMASK(2, 0)
+#define MT_EE_WIFI_CONF2_TX_PATH_BAND2		GENMASK(5, 3)
 #define MT_EE_WIFI_CONF4_STREAM_NUM_BAND0	GENMASK(5, 3)
-#define MT_EE_WIFI_CONF5_STREAM_NUM_BAND1	GENMASK(5, 3)
-#define MT_EE_WIFI_CONF5_STREAM_NUM_BAND2	GENMASK(2, 0)
+#define MT_EE_WIFI_CONF5_STREAM_NUM_BAND1	GENMASK(2, 0)
+#define MT_EE_WIFI_CONF5_STREAM_NUM_BAND2	GENMASK(5, 3)
 
 #define MT_EE_RATE_DELTA_MASK			GENMASK(5, 0)
 #define MT_EE_RATE_DELTA_SIGN			BIT(6)
-- 
2.39.2



