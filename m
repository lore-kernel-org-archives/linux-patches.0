Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019057;
	b=1TyWIKSGsQpmUjfghb9n8BzGvx2Yoqq9aULmneuzrkeSPNUAl4m3FSv653yuvXtaDIb9
	 jU7oK85MF/Rsl3XIb9kGiCvuleeeapsiH0S43eux7vG8ic1NMcACiGdNBpJGw77J3fVi0
	 xWyqzigvjq9YVaiqEgaRh9Um8xWi/hWcekVhM9yT3SDHmadV2EXqOIPxKRzUN1ql4q3HA
	 qv17ElNxSB/ffQ7MTlUAWX+biamCO3Zp+esgtlns0I2mA9zblPX+YnEoDE2NnLV4EgmUh
	 IEg5KkLvOhX7S//jJRm13sDDLNFX8O8en6f/f6TF0w2/wS1PbUFUvql7Xv6Y7uIEjVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQShBiin/YDiZ6r3LVp56fWYnOh3Mxij2/rfFB9O4+Y=;
	b=HSOIARmR6vY0aOYl8+FoF3DOkFzJA6zjoqGCy49HhIxeiE3tIEQBC0fifvpwdWewrBSL
	 PxAyK697FdeC2au/M+2uzis6q/9WflsVt9lKOTR/bLGVH5dpT7TMN1e79NcFcnUV6HxcS
	 BOlkgXb6DF2ny3FPH6pBKU8y5ObykR//eoQdi1J1/t83EJkbuJyv4OxIuS0LRjZngqC3D
	 mdys3p8E3fcybfuXESaKFe6JEvUu2Tmn6pZHhhb0Z1ROEUvSy5XfRFVvsDsmOYQEcSxVS
	 jTDwsLBBrBJUYDnVp7aGZ/bPPwqccCgDCKWpOB60d5PkQY0uenrWXuvhdAhQn1tPbPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HksJ1CY+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E1606A320;
	Wed, 18 Nov 2026 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HksJ1CY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31791F000C8;
	Wed, 18 Nov 2026 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019057;
	bh=QQShBiin/YDiZ6r3LVp56fWYnOh3Mxij2/rfFB9O4+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HksJ1CY+PQ8N6xQGs+r3sdP07b5zk/b2dE+bOvBbsD/lOqv2uczalGomFGSu8R5YH
	 J1VntyhDN215Qk9fHLKJQjQdVjaSxbKggT8kQ5SYIINurCJ8WpvQ+3Tn855nUAGFTY
	 btOxgB6u11eHyvPJ+mRh/iTgxFtb4aLsohIYTvzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1460/2651] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 18 Nov 2026 15:45:00 +0100
Message-ID: <20261118150340.596468860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index ff57ede87f717..1ce0192c2c91f 100644
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



