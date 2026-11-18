Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041117;
	b=P0wg70j3dxQPMPkJacXMi1VFCVO2E9IqAcGiU3I606sZyMzcaQdDBfUDvgiy64/ICXi4
	 WfXIP44qOYnhBjWPQx79d/pxSf5c7eXz9JxwunjBT6y1Yzh27DMySzNVRbjq3rOqGi43i
	 jsyD1E4UavN1Rs63zw+hqkNbHXkfjNbyh/dLWNMsH6LGiyy3C0qdxVS9vTXnmwbCJjz/K
	 oSK7NdNColm1BXAaVYB8AcvOxQdUA7Kl6yp+Qd++JiGGbhSk0LoeCal5BF8IXH0fjZkBG
	 5X9xSl65tL5PjzMd2Vs++8XOW5b4QG8aLakBoo5P4jqNaTYGqYBqnunccsd0BjwO9cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SMJs/EPm+VDk5Du2HPiLMVtMEcg/RD08vr2Qqs25xfU=;
	b=mws7d5U0M4HUTvXkdKpuK47/hakB2SzPeiqdk2V/tyag9mMiZtCgkqRlcHyssp090X7n
	 VK8+NIF6fsmaECyJ/znCqB7TROaV+x7bDJmVW1SRt3TmXpcZyArU9iqV9/G9fDfp9xAQn
	 vwJfSf7raTxIf3z1+hgSvkavea07yqd+zOveZ7HoOFrc/nHAPWqs8D5Yjhp+H8lUwrmuI
	 8G1xaMJazaI/3F3SAbIMeZEsbZJTGka8nNpzPz37E1BxKqjhmm+dgb0yQ/ISwTISjErLG
	 ziaoRcsJcCGuQiICo3Z8oUXrVGS0edvOvKrxdxq1WzcTA+AdVzOO3PRQBnqFFBLTQSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwxiTZ8Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC75606A31C;
	Wed, 18 Nov 2026 22:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwxiTZ8Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBED21F000C4;
	Wed, 18 Nov 2026 22:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041117;
	bh=SMJs/EPm+VDk5Du2HPiLMVtMEcg/RD08vr2Qqs25xfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwxiTZ8ZnZyXtoejJSkFYMm5rvpDMxawnPttaLqyR6CNnSDj9K2gDap9IdfN2DFpa
	 oRYQcG6Przqj5A2iBnFU77gYOBKClSSo3g/xoFZpGIofu8DTKYIJCi8SHWMsUmtUvr
	 UQ5HDtGEcy1jnYV0EdPJcMWwvRvtuib7WHUJPcVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2672/3318] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 18 Nov 2026 15:54:54 +0100
Message-ID: <20261118150441.165843569@linuxfoundation.org>
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
index d5071981014ee..20f2854d134d1 100644
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



