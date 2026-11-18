Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033989;
	b=bMbgo8IsfwTnCnkkQUm/XwMnsJ2Entz01AqBRTqcjm4Qhed9xm6j3NvzkugK227xUx73
	 rsru15yg20dXoZOb4HEEvTT7fdxTvzi35KyjJQbefwNnddbUgVgbghZ0ugv4o9Ismybuy
	 7R2a4trFCJ8GmWY/x8AnIipaGXhIzGkvHYycLA+AG8S5T6yj7KVpGGB/Ga3p71rdV4uqG
	 oHmRvYmz/yitqQlm7oLS9t13I4Xid1ugocumGLokN6Mf5SuRYbrYVY0MgfUzLMltxc2nq
	 Y6xSKP80sFQRPMEJkNvT2+1PyNRJd3Ycd5KSD+o8hhnGU3WbU1/p3kzbPfRFqJDhvZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wYSNMNnnfZ9OlhB2FAO0kO1Pup4Nj5sfUDo7ckIIwbk=;
	b=gAZBRZmWwBToxwFHc5WBbw6ABYwUYcr8WY8MnT6TrVnDyU4ng6shE/a8gjG8tSmn1oeA
	 HIAtF5PfXUwX80GHjmkKPNem/CQE21oCflXD+UGuO7aEIX8uvScaLggc6ufI0L1PIyFL+
	 XF1TtDvi6/c88zOBQemeOewdlAVfIwLxQRKUzjC4wR4cTXyKcIJQQxGZHbx0wLkDD8q4X
	 RbyexnBrumbMaWEcXZKW49My4BYyl4PUQzX8lpPsFt+yn53Bb0VPIYi7bQAyl/cC8wnuI
	 k7ekjw8L3SBTbOPlbKH4D6XjUFNvJrE8/SeExmvjGheCpVHVb9CGT5FGPXkT8oSo+UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uDo25wH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA04606A331;
	Wed, 18 Nov 2026 20:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDo25wH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B355F1F000C5;
	Wed, 18 Nov 2026 20:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033989;
	bh=wYSNMNnnfZ9OlhB2FAO0kO1Pup4Nj5sfUDo7ckIIwbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDo25wH/4gLRE8rzf4a02tZgOxrlGMU/G1Q22ZiZqwUv+QQha5u2qJ+Gmj/lgKojQ
	 XYHqu2HIv2f061vslvAH5pVLARwfvderhPdfR5EZfHWGjMooV3/Xue8WYyrhn1GQtF
	 fUvS1FdkK0R12qx2hrduCrMMMA+3M0vwShaXoybk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	0072a70 <90307219+0072a70@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0203/3318] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Wed, 18 Nov 2026 15:13:45 +0100
Message-ID: <20261118150320.969002067@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit ddae0bcb01e71c1184bb3f526f9622e31dc38f3b ]

When the fcsfail filter is enabled the hardware passes frames with a bad
FCS up to the driver, but mt76x02_mac_process_rx() never checks
MT_RXINFO_CRCERR and hands them to mac80211 without
RX_FLAG_FAILED_FCS_CRC. In monitor mode the radiotap flags byte then
never gets IEEE80211_RADIOTAP_F_BADFCS set and corrupted frames cannot be
told apart from clean ones.

Set RX_FLAG_FAILED_FCS_CRC from the descriptor CRC error bit, matching
mt7603, mt7615, mt7915, mt7921, mt7925 and mt7996.

Reported-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Closes: https://github.com/morrownr/mt76/issues/38
Tested-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260613002544.27750-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 338f5b46c6511..14cfa597fb622 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -794,6 +794,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	if (rxinfo & MT_RXINFO_L2PAD)
 		pad_len += 2;
 
+	if (rxinfo & MT_RXINFO_CRCERR)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
 	if (rxinfo & MT_RXINFO_DECRYPT) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_MMIC_STRIPPED;
-- 
2.53.0



