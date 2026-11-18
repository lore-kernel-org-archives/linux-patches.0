Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043339;
	b=5DOg/Tf41yz0gdfhXUH2z5cZxH1DrpD/sZLvubulhk8IJt1Pcy7/7KUZznlkz089xRT9
	 bHlqJCJjaqgBAavijrOGj4hx1CL4VTH2to3RY06Che9py+HDVbx2Cg8iHV+YAculOzFFZ
	 pwnAdOP7re5nuLUTQ6C23dhYV/dUE3YZNKDpC2T7e6ZBAxCtWAVn7vD2VU706R+ZR2Ucy
	 KXffBAC7YdHV4aHJiOWK6dNp2kRAHNh0SUwfWVoBTlEb7kTgdTvXK/VvvopV/ZoXl0vgK
	 J5um2ptcKJ7BQokCyK+48oJjS7n9CSkppTkl7JlnQiZsnW2GXlpmKeOwysZm6jBzzXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kbxs9qLyHmaDJCWIEOSI1hcHF48hPwpb2Mx4NYh2lCc=;
	b=JvebIbRJi+wp0XyTaVv7u4ZLtXw33nIgUec1cEZnTYeuWh/gX1FEsanUPyouSTmEhCo1
	 vN4BLOg3cL0PZKkGGYgRXMsxd9D+X/TgCB615fHSxsrvZwlz/2t7M/xISgH7+AYx4M2+i
	 1mwWD9pMOwqTHddG9aSS6jgv7VQYnHpvPCt+5rAZS/SwDBiF20EO5+ZtEZsU8KKIUyYsx
	 pxOs3Zr5EfBRJjDMi6PKNOpBUIQnAAna0AmRAbXusD+zB0tUxsi3xvpSorlEElRui0RMO
	 e6tgRnSLzUdRvLkvCODWXN/hQE1qDBVJj6yzh5ieV/Z6YCrTxeUdEitVfxa6TIS7PaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnC1znF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C4E606A320;
	Wed, 18 Nov 2026 23:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnC1znF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0791F000C4;
	Wed, 18 Nov 2026 23:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043338;
	bh=Kbxs9qLyHmaDJCWIEOSI1hcHF48hPwpb2Mx4NYh2lCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnC1znF+fLuIMKwNK+TRdaeH1Hq1i6hjU8gunRTvwyygr5dgL2Q+6E7/4rbpxdk0l
	 jBFN26/C1c9twS+Q3tWuRZ6k0lssXC/8cAu84rrw/erb93xMWd7d4VbyToL0BYU0I9
	 NVlLODLeF241HdaCgfFMd1aGVSU631CKbRuTyiVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	0072a70 <90307219+0072a70@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0175/2857] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Wed, 18 Nov 2026 15:20:09 +0100
Message-ID: <20261118150207.652756655@linuxfoundation.org>
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
index b236f943949be..4c2092905314c 100644
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



