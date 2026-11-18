Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031310;
	b=a8K1+SPDue0ZwVPydtNxMYUUuSRSH/mHecH18/4Z0JfvRJ/heuz3e35YSPxxSnDIErpa
	 53QN7cbN9ZbjAjcRJrQZ8EQFf8XHF6S143wAyr6UWFhjb2lK+iWukra0cdZCn05DQ7+pg
	 ghYSU5MpvMfxubkqlhxy+wreckWELjA/ZRnKpUJrySP09R5drcYmiSnkO/spgsiBEFc6g
	 J4eZr+e1YxLmwk+heQN9SUGUw5tv8LA0wR1iv0UW+DWu2byYTpmZFFuw6iAV63rjt1USJ
	 CE5kivQSGMiC2dnorwSw12kyVX2nU1DNg7DOiVbkoPkg2fCwU7K3//8yqJ+V3RJwZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CKs+IolXmryZmknxoTqPEGnDI0fWH887QzFCO5f/sdA=;
	b=CTVyo/pVGIcw1B7OaNW4vnkToJdZvmag5EV4FCYjySi9u7+bRPKFb0F86AEZSU7nH6Re
	 Lj2JzXMSb8cdUQ8R6FMTynUqo10LwtjSI+AEaT26/jYvv8jM+kdFJEaWvrrMu7YnYQaHd
	 6d7r3mpwtXC7pOdwo4zFLcpCDIMoDgJIWEV1vRdrYZQQwvCZUhLntT5rH69FdvQwiG9Xf
	 X+1gf9pdshCZDFwXCkt3e5P1jCIiYQiTFulhqr0KFZS1J/IXTl0fwVvAcXl9ha6Aa99ZW
	 VUYeLzTzFnv46yDTXEClo/gmWftjjMJS89P6y5zpnFZ54fqYzrKemv9TkGKZ4/5cYHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIRSZUTT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F69606A325;
	Wed, 18 Nov 2026 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIRSZUTT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678651F000C4;
	Wed, 18 Nov 2026 19:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031309;
	bh=CKs+IolXmryZmknxoTqPEGnDI0fWH887QzFCO5f/sdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIRSZUTTpRRt0zHoFbvvx/jxVcWcuKcA6kqmSgF9QIeBYCSd5BgbmquH+UpWhTVCh
	 aMbxAKzcO7Av247G+zYlQ5UnvmqH6VIi+y+1xBkNEFMpUMlmKXzC/RGHE07O5sSS65
	 Atc2oQXsEC5OnQ2hKiyccovsMfr0LFTUrHZpoqhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0971/1756] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 18 Nov 2026 15:51:38 +0100
Message-ID: <20261118150048.784489356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ac831422d4c77..1121c6a243750 100644
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



