Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064511;
	b=anxVbg6Gn+J9r3EtxNAdiUlTJgCP7ofn9sdAXM0ORCX9x7LDra1hHnZHHX668yvblzBU
	 qySCtlNLOYrOiLJVVaY/I7O/gUjSJZwgH/urtT1HOa7GseOCFRmwJb84Lg2kFvsrabDKz
	 1UmaZrrm8Ea999QUX11iP3+Wft/tBm7XKulWkqU5NpczH5wenYnlJcfJAXSs1avU857td
	 neT0q7EAcyWDp+kxVvp2h5fd8sohnRKeN5xfGov8HL9MsJRjKjUHMpOCtojS2ogL2tSyH
	 sghnlp7S7L4c+0lC1bSGya6gZrHuwI5NQRRulTGfubgil2ck63CD5SWH3GyzTVHGZVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CG18Sk+i+Cih/gfGwpDTzosfAV0hO8RXutbQsaOwGnk=;
	b=eK9x91pRlQr1Rcbk7w/sz6MKRly3mCdwEyKcLpwXKSolJCf2UPYhVEHuiG5g75EWHtyT
	 AhxUOzP3S1xZbK90ByOSeeTq8OZ8p/7eeRpbqASTMXDcr35O7a53XrJYtR3w28RWwMH81
	 U6vTc0WugIU+JCNJaNe1Ebr+fIHBO3VMGmNwBJ8A8GOBV3LVIVTrnAZTsAyCtX3sbQjc7
	 EnLbgb7T5lDyrtD2Fm9QuALwFTiYd2HknlWKfIhVVhoFOJYIPq4s+rEsMsRQCZRswhKi9
	 YU01qMxKvaY2Ell6ew+oNYp/hEQXMubhFWO/JbrhEH11UdsxlfGXI6v5vYrw1kuAE2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYtPAWp5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD40606B893;
	Sat,  7 Nov 2026 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYtPAWp5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2391F0089F;
	Sat,  7 Nov 2026 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064511;
	bh=CG18Sk+i+Cih/gfGwpDTzosfAV0hO8RXutbQsaOwGnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYtPAWp5jFCURTyaTBw2qM3iOgFT6+BuWIWypMJXmakzj6Nx5IHwU9yOS9s8BVfpN
	 4Za+U92wEREwltotTuRZiKqgrinT8zj/RwZoh54cpOOMYFi6TdlBy8LNZ1C75Xgzc+
	 ItMCK2+NBBviGcG2Yoan27BQZBQ/g2HbFx4H/Q9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0541/1257] wifi: mt76: mt7925: cancel mlo_pm_work on the USB stop path
Date: Sat,  7 Nov 2026 08:47:17 -0500
Message-ID: <20261107134954.340180356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 9f299215d1d835aeeee8b269dad09e1be06f856e ]

Every other teardown path cancels this work, PCIe unbind included. USB
unbind does not: PCIe has its own unregister hook for it, while USB
shares a generic one and the stop callback that would have covered it is
replaced in probe.

That cancel came in commit 81faf578320d ("wifi: mt76: mt7925: cancel
mlo_pm_work on stop"), whose last line says it covers both buses. That's
mine and it's a boo-boo.

Give the USB path its own stop that cancels the work first.

Two-link MLO on a Netgear A9000, work armed then the interface down:

                   stock    patched
    stop ran        3/3      3/3
    work still ran  3/3      0/3

Skipping the stop entirely leaves both builds running it, so the zero is
the cancel.

Fixes: 276a56883257 ("wifi: mt76: mt7925: update the power-saving flow")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20261003234944.96066-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index 1757023ea70d5..db6fd014447bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -147,6 +147,15 @@ static int mt7925u_mac_reset(struct mt792x_dev *dev)
 	return err;
 }
 
+static void mt7925u_stop(struct ieee80211_hw *hw, bool suspend)
+{
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
+
+	mt792xu_stop(hw, suspend);
+}
+
 static int mt7925u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
@@ -193,7 +202,7 @@ static int mt7925u_probe(struct usb_interface *usb_intf,
 	if (!ops)
 		return -ENOMEM;
 
-	ops->stop = mt792xu_stop;
+	ops->stop = mt7925u_stop;
 
 	mdev = mt76_alloc_device(&usb_intf->dev, sizeof(*dev), ops, &drv_ops);
 	if (!mdev)
-- 
2.53.0



