Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034020;
	b=mGrAyaVvIC03jJFmfBMB4AlrxNxFkre631G7m9MpZ/NrHVFV+x3T6xEbvHa7gwbMwq76
	 CBtFQMokfepZ/SjzlvnTfzX95ZgiIPrtgSqyKb6FrEN2IoMo4IKoEI6s0PKAT1t0Midxm
	 MJCKDM+fqi9/x0+uwvT8T7SsGi7Jfg4ORIkqa+flx/Pi66yXwhi7/u3/DKXZxZXcww1jT
	 RjlmxgfIrPoHQeZxKWdRTELo6acNHhJ6mPFgUpcbzyAfrnngwxuTXDjDqQjxx91DrJI4V
	 0bZXiHnUkZA9sH36AuvNkotVW6TYT3jpyXxUZliuVfCJwO6B9/afDjVuQ6nbX9iaNnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gWADfR/cLDEIizYX2JQeeGFVtjxFReSu1HEuth7ORRc=;
	b=lIVCI9P29FMYZ4AmMne6B+JtyXHIPuZonzRCoSIiOFMMAm2lhHMk1p4LjGCbtYp2l1F/
	 DeJXYWfAC4JUN1O2LaOsLbtAatD3pEw8cyOIW1C8K7e60utO+EabGgXuDSspkv0UFZJ2J
	 FdTeF86U5rZO0yI0p8Pujz1wINa31ICQqzd11St6DF3gI89jURnWOcZZx7Z4FrlGSTUoJ
	 WDbZuwHtufa9DJsXCiq2uwX/+JisjxWug/sfmy/5UJ7aMQvSxkPW8cFyqpX19/JDPyesy
	 RVxTjZiY9ujEApf9X7DForf6BXFR7e7t+ojwOYAhy5Y4nqeK6x7mLjiWoHl90DLKEMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONIs5M3X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBEC606A31C;
	Wed, 18 Nov 2026 20:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONIs5M3X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABCC1F000C4;
	Wed, 18 Nov 2026 20:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034020;
	bh=gWADfR/cLDEIizYX2JQeeGFVtjxFReSu1HEuth7ORRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONIs5M3XrX6u7s+jJTbbC93fIlv1vu1MPlltfOw5lSDKgX72fl8N9RJwVCxmFszzZ
	 TZ8x7/GlbbqnzFZ/WMBNDH+NqWkjs95HQpwan5J1pLZyptRZ0LXCTYLVkwURDm2caD
	 il1TSBgF0U3CdBt2caXRrggI5rDiAwE+5aLLrCwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0204/3318] wifi: mt76: mt7915: configure noise floor reporting on reset
Date: Wed, 18 Nov 2026 15:13:46 +0100
Message-ID: <20261118150321.004481069@linuxfoundation.org>
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

From: David Bauer <mail@david-bauer.net>

[ Upstream commit a92cd5dd792a63a5d8a72142835382d4edbe9933 ]

When performing a full system recovery of the MCU on a dual-phy
platform, band 0 (usually 2.4GHz) stops reading correct noise floor
data.

This is due to noise floor reporting only being configured correctly
for the second device PHY.

Configure the respective registers correctly after restarting the MCU
firmware to fix reported noise-floor values.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260516144944.2574053-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index fd743ef86e7ab..3490a13b0abe5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1302,6 +1302,7 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	struct mt7915_phy *phy2;
 	struct mt76_phy *ext_phy;
 	struct mt76_dev *mdev = &dev->mt76;
+	bool run_main, run_ext;
 	int i, ret;
 
 	ext_phy = dev->mt76.phys[MT_BAND1];
@@ -1394,13 +1395,17 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	mt7915_init_txpower(dev, &dev->mphy.sband_5g.sband);
 	ret = mt7915_txbf_init(dev);
 
-	if (test_bit(MT76_STATE_RUNNING, &dev->mphy.state)) {
+	run_main = test_and_clear_bit(MT76_STATE_RUNNING, &dev->mphy.state);
+	run_ext = ext_phy &&
+		  test_and_clear_bit(MT76_STATE_RUNNING, &ext_phy->state);
+
+	if (run_main) {
 		ret = mt7915_run(dev->mphy.hw);
 		if (ret)
 			goto out;
 	}
 
-	if (ext_phy && test_bit(MT76_STATE_RUNNING, &ext_phy->state)) {
+	if (run_ext) {
 		ret = mt7915_run(ext_phy->hw);
 		if (ret)
 			goto out;
-- 
2.53.0



