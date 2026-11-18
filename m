Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061375;
	b=uJqaF0UuzQmLBDjAOBXqieY505C/hBkI7wUHQGs0wi48RcQt4aVgMgK3qvlJkqRHSTJJ
	 Bv2fHt285SESnlGp2zb20h8PaHeuT9IUSXUq5+HhdjH/EarAVslhAJI0wVwC+ZlYbsw+R
	 Dz0ZEdkp3oD0bPZaR8oUSxcqFBGrKkKX7rQDJQE55e9wbr23HnAmlzwWBmyoi9I7R3n7/
	 MBXCH9NyfU84Rdsby5nau0owIT/9MHAYSKZmULUJno0zIYg/gZSzwpx/NqGGcdO/gdFgy
	 omITfjLZhQvRO9eZSj9kkswk5srS0AsiBxA+L042dKWTTqpcYj7Jk1xv19XzKREaXNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lmb8hNnOmBGHWy4mvpu3aR2NG4UI68Um3DFl/6HM+eU=;
	b=dSuuW8rmVL38xzbDSw6sOGGB+zzMcv0W3m9MjR2rSO6bOdAFZGDTS9evSzcp3/SLHiae
	 w46jQkie/DbAygcATTZhqemPuA5iz3jdB81wSVZXGgda1T5ucdxeIdBhQNrK9ppNTlXFW
	 BsAoBq+zSjPtP5rXU+ScZJemTOhvpInTHQ9DqmSEJAMWmoYWUCgTi+8ULk7t9Sj+mGYBq
	 dODgq/4x5GWYuBMXzg33vjDa+zIdLE17/Zs/qqhvVjFA3ugoFlXS/fVqkx40qrZmwvG0h
	 fHfOKyPFvmdbByTgtGx5cXNuYaawvURnOgJSbfwn4qMM6Za5TKoB6HhQYvwO9mOJvZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v06gbALS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5DB606A32A;
	Thu, 19 Nov 2026 04:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v06gbALS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A751F000C4;
	Thu, 19 Nov 2026 04:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061375;
	bh=Lmb8hNnOmBGHWy4mvpu3aR2NG4UI68Um3DFl/6HM+eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v06gbALSNMgXjNEDhTLIevWf6dZ5e6S61HsOHB3mWn3W/xu1dI5R36NT9QR/fIXTw
	 SNL07orFNGXMxBWSE3Bnkm+Ew0J6HVLUhaanqPJz9/IPxnOPveS7AhEo15f/4r03Wg
	 fi49GbVaCQuQrMnUnw8hb0UkE6OA6v90TBUS/m4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1530/1848] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 18 Nov 2026 15:59:28 +0100
Message-ID: <20261118150023.438675790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 88e8157f6c960..6ed470050632c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -195,6 +195,8 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		break;
 	case MCU_EXT_CMD_GET_TEMP:
 		skb_pull(skb, sizeof(*rxd));
+		if (is_mt7663(mdev))
+			skb_pull(skb, 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 		break;
 	case MCU_EXT_CMD_RF_REG_ACCESS | MCU_QUERY_PREFIX:
-- 
2.53.0



