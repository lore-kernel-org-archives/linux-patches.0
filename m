Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7292222CA;
	Mon, 23 Jun 2025 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714174; cv=none; b=IBZ1tJ8odmHcNkr6IZc1DQzd7MYKFZAY8CVrY0i7oZaF0C6G4uY1Us9VWgA0Z8ceZANkEH4XnNmtUP/cnecy/z4BiX3DfX84C2ybVBUSeiOKIH323djrlL1kNwHZNL3poieykCthz0VZCcJ88G+wo1ObVgEWC+nrKBzzRzw0xQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714174; c=relaxed/simple;
	bh=miQOrr3Fwf1xm/DRqT1MyBH/gFKBW+pR77ff4VpyIsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp7btStRR8jk3954DdCU2gho5TpVLFiWXSl2qpcIPzWmaN0i1JIX4Z/V8Vjytsf6//ju5bGb2ZLovGk4GEColviI1wPnc7hvzcMLZML6cm+p7FMKRDKViqqWruNsHPhfLF2cjRfJgGmB5zPeUJbb7mHf1d3J8waDiC06zYyUvOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIPUdfl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIPUdfl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C71C4CEEA;
	Mon, 23 Jun 2025 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714174;
	bh=miQOrr3Fwf1xm/DRqT1MyBH/gFKBW+pR77ff4VpyIsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIPUdfl02sXoq8T8WSe81DsMhH9zhMoWJ8meHEol2fdkv1iS/tjPoq3cteXK5PCyn
	 93gz1mYS6rF7PeRkLWFO7SVqDLweh3R8UQz14TRsY0W9gZlKjxfDJ1b163VSRYfhTE
	 G8NJ5WA191riuGBW3ewc2AR32NhyhIS7TslziiqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henk Vergonet <henk.vergonet@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/290] wifi: mt76: mt76x2: Add support for LiteOn WN4516R,WN4519R
Date: Mon, 23 Jun 2025 15:06:42 +0200
Message-ID: <20250623130631.143312542@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henk Vergonet <henk.vergonet@gmail.com>

[ Upstream commit 3c0e4f606d8693795a2c965d6f4987b1bfc31097 ]

Adds support for:
 - LiteOn WN4516R
 - LiteOn WN4519R
 Both use:
 - A nonstandard USB connector
 - Mediatek chipset MT7600U
 - ASIC revision: 76320044

Disabled VHT support on ASIC revision 76320044:

 This fixes the 5G connectibity issue on LiteOn WN4519R module
 see https://github.com/openwrt/mt76/issues/971

 And may also fix the 5G issues on the XBox One Wireless Adapter
 see https://github.com/openwrt/mt76/issues/200

 I have looked at the FCC info related to the MT7632U chip as mentioned in here:
 https://github.com/openwrt/mt76/issues/459
 These confirm the chipset does not support 'ac' mode and hence VHT should be turned of.

Signed-off-by: Henk Vergonet <henk.vergonet@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250418143914.31384-1-henk.vergonet@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c     |  2 ++
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c    | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 70d3895762b4c..00248e2b21ea7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -17,6 +17,8 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 	{ USB_DEVICE(0x057c, 0x8503) },	/* Avm FRITZ!WLAN AC860 */
 	{ USB_DEVICE(0x7392, 0xb711) },	/* Edimax EW 7722 UAC */
 	{ USB_DEVICE(0x0e8d, 0x7632) },	/* HC-M7662BU1 */
+	{ USB_DEVICE(0x0471, 0x2126) }, /* LiteOn WN4516R module, nonstandard USB connector */
+	{ USB_DEVICE(0x0471, 0x7600) }, /* LiteOn WN4519R module, nonstandard USB connector */
 	{ USB_DEVICE(0x2c4e, 0x0103) },	/* Mercury UD13 */
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
 	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 33a14365ec9b9..3b55628115115 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -191,6 +191,7 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct mt76_usb *usb = &dev->mt76.usb;
+	bool vht;
 	int err;
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2u_phy_calibrate);
@@ -217,7 +218,17 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 
 	/* check hw sg support in order to enable AMSDU */
 	hw->max_tx_fragments = dev->mt76.usb.sg_en ? MT_TX_SG_MAX_SIZE : 1;
-	err = mt76_register_device(&dev->mt76, true, mt76x02_rates,
+	switch (dev->mt76.rev) {
+	case 0x76320044:
+		/* these ASIC revisions do not support VHT */
+		vht = false;
+		break;
+	default:
+		vht = true;
+		break;
+	}
+
+	err = mt76_register_device(&dev->mt76, vht, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
 	if (err)
 		goto fail;
-- 
2.39.5



