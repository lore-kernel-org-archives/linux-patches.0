Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A392571C6;
	Thu, 17 Apr 2025 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915795; cv=none; b=urH0J5uklEalISmY12dvFiOgC3tGepq+Im/YJq0mA6s7jpIJEEhC07HYtQG8+Rrf2XhYewW2/9c+5seZhfywnDtbXJBr+9MQIrS24mea1EPMVG/R5ZYFat2Fxph31r9JFAspICeXnOsi2Wo93mGMtb0eF3mGouKOooBLTrjcops=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915795; c=relaxed/simple;
	bh=8HXhN67fvWv8oJj4QOm0vHuHygiROitPMvL9CSmXSP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtM8IefjtSNbCWhQZ0HYDJcVgryBjjrEjDcs+iQ4UCszj6aCEazOSbIuqOA94dyPlbg84NdacKBhQu9ANIGrs5IcAc42C93Zx1OrfvG+FvzvC0e2R+q3DCd1VtA+3QqonBBR1HdqbXkJO1Cr03BZmU0q8SRZfdBTN+mfDxbWBw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EUTHcL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EUTHcL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26C3C4CEE4;
	Thu, 17 Apr 2025 18:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915795;
	bh=8HXhN67fvWv8oJj4QOm0vHuHygiROitPMvL9CSmXSP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EUTHcL2uZnEZcSW/xepvXyTVc0amzgKFgJu8v0TkQHGx00Gyswy95UovqCF79jYx
	 c55NXY8JP3OIK/oDlZ5KEEOirqrx1GEKcr3gMnHf3o06iWb676rcV5yelO5VkzUEKE
	 4RFHBpNTlUgj8D+m/fd1nFX56FIPo+NOpLOud06U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 242/393] wifi: mt76: mt7925: ensure wow pattern command align fw format
Date: Thu, 17 Apr 2025 19:50:51 +0200
Message-ID: <20250417175117.330734078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 8ae45b1f699bbc27ea8647093f794f671e77410b upstream.

Align the format of "struct mt7925_wow_pattern_tlv" with
firmware to ensure proper functionality.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250116055925.3856856-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -566,8 +566,8 @@ struct mt7925_wow_pattern_tlv {
 	u8 offset;
 	u8 mask[MT76_CONNAC_WOW_MASK_MAX_LEN];
 	u8 pattern[MT76_CONNAC_WOW_PATTEN_MAX_LEN];
-	u8 rsv[7];
-} __packed;
+	u8 rsv[4];
+};
 
 struct roc_acquire_tlv {
 	__le16 tag;


