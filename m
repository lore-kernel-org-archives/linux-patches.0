Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025837;
	b=LjYUPVw/391SRkSojMLR44DxE+1ZxQfUf59CiYO2Fwa2Zrg9ssJsAIZ48uZbWaM9HLmz
	 d5tY3y8BGDtdZFF2QNA8S0P0MZbntl3PFBon8XjS3tuxV/f8nDhe0Q5MrCvWQAkmLTLHc
	 LXyXOPms1UxxZoge8zH0k5uXs4M2xmb9egebv5WJsvF/HcyOzIBHvyYRX/17sTH9NEH/r
	 uwJwfJcUgEvEnrkuQmlqa2sH/y6LuiBkhRU0U0SR80J5E+nkdGhFmzeCOHWFC60hVGmjr
	 Xr6+UFe5OsN13f8b5yoVzR4n+17uUb15PhLUZXJ+26OIHNr9g6/T8DbzPySCiE+xUTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nmUvi69OOpPybtdslvvBL484FbazmLkCasHHWa1YXPo=;
	b=kGWQXHPY9Ad0xoM0VZlCR9CXxvrfflbx5B61+bbwcSnMibqkTOY6u1LRSP0XvSdjA+5Q
	 sBDeVc8PNh1QSHT5JQtia1UYbDD1NN2IIAJsugBV9A5pqzg2xUrwuUUojVY8PvZg5XA1V
	 BjkRjBxyoKY2KHr3R8FeOJ7oPiJBO70fnxngtXRvCkCI5sC+2g7pzkmbRhgVaw02groLU
	 T+GhItfd6T2VBUZqPOjcdaClEGj9WaoagtcmxfTaXE3WlkndeWIETaLTO9DslAaz5i4MZ
	 Yh6xqL4dEg47jwKzrk4uhFqvIxMJ22anXsX51ugP3V/DpKHRPt6RSmfzkhh6akiZuug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpCM02es;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFEC606A320;
	Wed, 18 Nov 2026 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpCM02es
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECC81F000C4;
	Wed, 18 Nov 2026 18:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025837;
	bh=nmUvi69OOpPybtdslvvBL484FbazmLkCasHHWa1YXPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpCM02esc+7WaigD/AOTI7T+2M/YtM5d1Esxxr1wnWXBsJ4sL3PFKwaWLn2dIBMY9
	 eqw4X3EzxYKJ7usr8ZTke4DH1izIv0TKtQDLv+waV2vz9sWxKLNrUDJQHmDzi2QBW/
	 feKQ2sSk8oXxhEvGfe5eWzIYRe/druNepJnhnSxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1221/2151] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 18 Nov 2026 15:49:16 +0100
Message-ID: <20261118150206.676637825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit 40217d8e6cba433a6ccb8c73737dd38b54dcc26f ]

On MT7663 the hwmon temp1_input attribute always reads 0.

mt7615_mcu_parse_response() takes the temperature from the first dword of
the THERMAL_CTRL response payload, but MT7663 firmware reports it in the
second one. On a DASAN H660GM-A (MT7663E, N9 firmware 7663mp1827) the
request and its response are:

  request:  00 00 00 00
  response: 00 00 00 00 2a 00 00 00

0x2a is the reading, 42 degrees, while the driver returns the leading
zero. mt7915 and mt7921 already pull sizeof(*rxd) + 4 for this command.

Restrict the extra pull to MT7663, as no MT7615 or MT7622 hardware was
available to check whether their firmware uses the same layout.

Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Link: https://patch.msgid.link/20260819192911.1886457-1-naseefkm@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 91c9d787d553c..5e30cd42c9d29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -153,6 +153,8 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
 		skb_pull(skb, sizeof(*rxd));
+		if (is_mt7663(mdev))
+			skb_pull(skb, 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_QUERY(RF_REG_ACCESS)) {
 		skb_pull(skb, sizeof(*rxd));
-- 
2.53.0



