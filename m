Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625300;
	b=GFq+g/nEh1R6x1Kzwd2HWOF72wisc8VVx2i2wb4RdVFGDGSqgQwVl5xFS6iaQn2bQ+Ib
	 chtdlfXrFzbaMGS6wW6hniS3PmD6EL2bM249nRsxAdIyb531tHYA35FjZg0QH1lRTDORp
	 PCwrzrlIW0haz5Ozr8mdYFiHrWJEXnU4vriANfsHxwDTh44d5w34ZG6BzkhtfwQztzWwA
	 isGhMbs5pFokvFAaq5aV3FpJF5ZmKYuUuyy/REXft3P2fosijC3y+FXu1ggfdq+zlin34
	 ndfkZSXSG6wwlh8C+YGTswNYlb2vOGS1DK/VLpJmVb4MCBmQCmL4n9FJKuFOB829HwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e95YFdVd8QkyX3V0coag6eE1w22uBhlDC9V9i/2JND8=;
	b=34lLO4hp6V0cU2Cx+lp9wtc0UOOcbwY7ePhCd7BoTO3aCUceINVqv7gLko5DUv9l6ef8
	 aPD+g6fgBe+FTNFl5KUCerfAVYhQMqaL8lKw0JsqyWsYj6bmvIrZsvVXDNADmHWKHlKVZ
	 kuiUgemsxobEHvdxNOhAmwCemc0M8dIJAqyFEzhltQZUy9kW9GChWCIroWRgpXEeITVs3
	 vzEAp/QmbzeX9X1wCEAg7+O5MbuEyxR9ka2z4pdnGjzmCJXjbRjnAkFMaFHSO2qE9VJWU
	 ULYbL7BOQScFVDB/R2YhPUyIk5H2yxN/znEn9iKPZFPfExYwYMGI3dWKbb/0pkvo4zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k98/P+up";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A93606A321;
	Wed, 25 Nov 2026 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k98/P+up
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DF41F000C4;
	Wed, 25 Nov 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625299;
	bh=e95YFdVd8QkyX3V0coag6eE1w22uBhlDC9V9i/2JND8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k98/P+upVXgujAgpmMdDhqXfxVWxnMlN9vSa+T1xZCFUwjvAoxU7/8+bu2TG9/QYf
	 CuRDfe38bL679lvpAHm3jWVERhuSRgpyb9i0DOBLRazudfVCZqqoPb8omwgsMmt2jp
	 AilbSNo3lZngkgkAv15/HUgqgJK1l/IlKbHG86ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 464/816] wifi: mt76: mt7996: validate TLV length in mt7996_mcu_ie_countdown()
Date: Wed, 25 Nov 2026 15:33:32 +0100
Message-ID: <20261125143859.941118980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit e75897e6cb8b900d095acf6fbff1ffb026c86c35 ]

mt7996_mcu_ie_countdown() iterates over TLV entries in the countdown
event but only checks for a non-zero tlv->len.  A malformed event with
a TLV length smaller than the 4-byte TLV header advances the cursor by
less than a header size, causing misaligned reads on subsequent
iterations.  A TLV whose declared length exceeds the remaining buffer
is also not caught, so the cursor can overshoot the end.  The band
field of the event header is also read without checking that the event
is long enough to contain it.

This is the same class of bug fixed for mt7925 in
commit fc7801b7f11d ("wifi: mt76: mt7925: fix infinite loop in UNI
event TLV parsing").

Fix by checking that the event contains the header before reading the
band, and that each TLV is large enough to contain the countdown notify
payload and does not exceed the remaining buffer.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Assisted-by: Claude (Anthropic)
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB0001CCE8D1BEE1F330D9E57AC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ sashal: Added bounds checks in the countdown TLV parser, using a literal 4 for the payload size because the countdown notify struct doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index a8a0737635d27..edb825675408c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -450,6 +450,9 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 	struct header *hdr = (struct header *)data;
 	struct tlv *tlv = (struct tlv *)(data + 4);
 
+	if (skb->len < sizeof(*rxd) + sizeof(*hdr))
+		return;
+
 	if (hdr->band >= ARRAY_SIZE(dev->mt76.phys))
 		return;
 
@@ -458,7 +461,12 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 
 	tail = skb->data + skb->len;
 	data += sizeof(struct header);
-	while (data + sizeof(struct tlv) < tail && le16_to_cpu(tlv->len)) {
+	while (data + sizeof(struct tlv) <= tail) {
+		u16 tag_len = le16_to_cpu(tlv->len);
+
+		if (tag_len < sizeof(*tlv) + 4 || data + tag_len > tail)
+			break;
+
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_IE_COUNTDOWN_CSA:
 			ieee80211_iterate_active_interfaces_atomic(mphy->hw,
@@ -472,7 +480,7 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 			break;
 		}
 
-		data += le16_to_cpu(tlv->len);
+		data += tag_len;
 		tlv = (struct tlv *)data;
 	}
 }
-- 
2.53.0



