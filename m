Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040995;
	b=0I7ap5OR6gRWbndq7oj0yogke82LBScsTdkd73Us96WxCm1OG8GmYctCcMjLPuCpI0Jm
	 Qgn19UlxRW6RGWvcwmJ1ghguatQGXrT0iQuZmjCf1rrsH/qMCEQ+NuOQhmoFYGkgOyP6a
	 jef+cSoXcF/yLHoAMNnGFyuaJYrJhnz3+M8useoculENe2dgBLWkvheOzfJS78epk78/G
	 PqqBcInScDUzGvjHk+aNfTrfSiZn6EKfooA5g7ZRBUcy2bLqne6220PqSVvn7CYJ0zt5s
	 9y4nScruFJh2sh+QA6BqBtshOegYmSiuCInnbpxbgULRdosdx4+yZn/0324d1RLbTMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+8koTZh730SiHrPzRNGQWL4SR+K0bjJwzvIdn1FHd3M=;
	b=c2ILvvXYW/u0PyEmvmoI70YBUoYoth0pYYIdF0jk2y7he1IeuWdBBEoi+Tc2zaMpFV2W
	 5oQ8SJSmbC963z6fS4xo1au5KA4b4rb91YzGxf+yIxQhV5vSu6xB0OtDlxvMuIeRmfztP
	 NkyLMTYO1ivDO/FFBLt5NundoBDtaPKxCdyh4JfTxOyiRtuRyw+Q7PRfWSXenT0DiSdoh
	 oDz03t9HEYg/2e4XnUn9+WAbeOd69Xuf/GW4H3mfFeqL8nR+poUW/nCUrR8EsvEb8h3hn
	 TKgVYVRkFV0jx6qoPUOdqLL+yJleDIYGBJqcdnO4TXy0QpH8sy3pKMMxrw13m8dXj4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6yXAOL1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A29606A31C;
	Wed, 18 Nov 2026 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6yXAOL1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3361F000C4;
	Wed, 18 Nov 2026 22:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040994;
	bh=+8koTZh730SiHrPzRNGQWL4SR+K0bjJwzvIdn1FHd3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6yXAOL170cLn++4IQHKWC5ilLswEYF1J/osUoVHcPE32hIygZd78oOv+VJhcdZNl
	 PCD/ViiesoUF4ki3uwM/JngPRxQ0DmD84dkXTZ16CK+oj/Fx7Dllp/opHnqfpyUUYq
	 LKglLm6Tjn+mHNDPhaA0RZl+bfhVlPwB2eeqJDqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2655/3318] wifi: mt76: connac: add more unified event IDs
Date: Wed, 18 Nov 2026 15:54:37 +0100
Message-ID: <20261118150440.691945760@linuxfoundation.org>
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

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit ebe81e6b8659bbae5d76c0b292e38abe4aa0cb1d ]

Add more unified event IDs which will be used in new chipset.

This is the preliminary patch for mt7925 support.

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: c88f880c6430 ("wifi: mt76: mt7996: validate firmware event lengths before parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 4740c6dc31089..c4273f602d355 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1009,8 +1009,15 @@ enum {
 enum {
 	MCU_UNI_EVENT_RESULT = 0x01,
 	MCU_UNI_EVENT_FW_LOG_2_HOST = 0x04,
+	MCU_UNI_EVENT_ACCESS_REG = 0x6,
 	MCU_UNI_EVENT_IE_COUNTDOWN = 0x09,
+	MCU_UNI_EVENT_COREDUMP = 0x0a,
+	MCU_UNI_EVENT_BSS_BEACON_LOSS = 0x0c,
+	MCU_UNI_EVENT_SCAN_DONE = 0x0e,
 	MCU_UNI_EVENT_RDD_REPORT = 0x11,
+	MCU_UNI_EVENT_ROC = 0x27,
+	MCU_UNI_EVENT_TX_DONE = 0x2d,
+	MCU_UNI_EVENT_NIC_CAPAB = 0x43,
 };
 
 #define MCU_UNI_CMD_EVENT			BIT(1)
-- 
2.53.0



