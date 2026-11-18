Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049316;
	b=DYvcf8mMZpH0sT/z9pEicjO0av0fRQz3tBsv+ewxLlKrsUDMV+Nwcg/NUfloGhqUiRaY
	 HN7XzGnEFEloxVoCTVy8qMwdwEPDfdSyCkYCvjqzT3j4QtKIpljT+lcUjriiw3gLguat/
	 4KOl5JjCfB+foFAjG8DqVM4MAftETdmry501BO1o5wsw9V3OclTb2MBwH23P7RpsveJjo
	 CETJnsA93jgh9u25/W35MCzUt5E0FC049m6v8YuzxhexaQw9RvQWinwDBDNH0vTSFFz1U
	 Ib858rSbqa+jcyp7Q1ng5euXRSX2hTQS3uq7gP18FBO5FHcWlIiwZcckWU9/cRergqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HKnaZrAvWDi1Nfh3p/MXZQ0mAQeAsna05erc1f6sQII=;
	b=Pj2EgRiB/+oNwplpb9KaeLRlIeeZDMuBeAxdjSZqiWwJZMANfRUrVlcD8p6/LymH/rdK
	 reUndZut7S7DpMzRALg/i4XZHHWJYTokrB8JxeDvTyp8ZR3gKNp5M+AmlmlBAbQTQuaqR
	 7pfGyqkmyldK+dizue2qh2ojsvxXINIebYkJC8e6DjaHRnFO8oc4bq4KBfmpUOp7brFd4
	 Wo+93jV3m3WVf0scGYlJFEAR4dEz0r/VddRXvFnEE8HeXWUMbfnK+E1/6DDLuVIB+fB4K
	 iMmMexzNgNhNoBoVaMAnESqO2sSGkOEfuOdAb0f+GmTuv0+ze2cIPD/FgkjCcpu6coQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9NDtrV9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE715606A336;
	Thu, 19 Nov 2026 00:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9NDtrV9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E996B1F000C4;
	Thu, 19 Nov 2026 00:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049316;
	bh=HKnaZrAvWDi1Nfh3p/MXZQ0mAQeAsna05erc1f6sQII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9NDtrV9DSzTeQ0keOkNmD5SCjQCyhPCvGAiLVIp+HKb02spjzwBMg2WDCwPtaxiV
	 SaHhvXustpQM+BGrnls7B9UZL3IgtxRDV7R0IybSBLm5kolNcsmPJmRjWK+FsYmXGE
	 Bc1d3Zqfuzs7qocVqJIK1+OH9SwO6lkMqmp9TDrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2307/2857] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 18 Nov 2026 15:55:41 +0100
Message-ID: <20261118150324.556848128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 53f6766938ae2..f12378f564e50 100644
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



