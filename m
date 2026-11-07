Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060860;
	b=QtEOsRq54UCXCtQq6S0yApyPoUyzvcUQ60U4Wc/O1gzUDJtlQNr7YDGoln8NDSX1enzv
	 JcZ5BY14RDTBASc82RnPadZu+w9Jwvy7QcVle6qpzx65f0DB9OHiBaeWn0Hmk53NaIH4T
	 0IU2xOyyvX1Iw5qOmKPVFFXWoGn4DebNZMftuTTpOrxZ8oi8MY+6i8P5Oioe8VFwUDQch
	 SPCPZ4A6fUhQ+GV9XErtD/alXbekghll9sYHUXm433aWPZJMblF4DyPa6Dj5ZfHUr9Kln
	 SQGmVYM/JCHhkXhd49NsuyH6PglXFbGdkZmeECgtU65zNqy0n8glJkLq+C3edmVMpAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43CO0ohove8IA1ts1NfpEgCmcfXdz+C9mnwjO7zyNlI=;
	b=YVYWngH/2uiqClhOb5RyLe4DYeQcVxdr29mwuyYaMKoWSQ/UMzJ/8ceec2t+o3EgreTp
	 uqnTDyJ9dCvYG7djwjT9YxfvgxTG3211bDQUh7c4JeWEu3N1qqDL+6tjFhc3uCoYr6/zO
	 H8We+aF94IXEil7GcxIYJD9omCrvGdPKFljAVmkmilendmfByMEuRwDomI/WDpmNZ6VWv
	 7GeTLjlZ3BvoAHrm4hiOHHzQphJ1sOb7xzT1XZ/eYFofwjjnzHbMtxwPqkeiT+0KQ/2Cm
	 0kLsmh9smxeCGvMBxbDnDcCYSO3LKmsGZojcef3qyxf9FURJkB42VJnpSGzHI65vjMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJgyB0He;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A0606D813;
	Sat,  7 Nov 2026 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJgyB0He
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347EA1F008A1;
	Sat,  7 Nov 2026 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060860;
	bh=43CO0ohove8IA1ts1NfpEgCmcfXdz+C9mnwjO7zyNlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJgyB0HeABIn74nQCcjX6Dn9QaSWA0cSZqZrOLdxvDwMwhFrlXcE91mo3lpth1G8B
	 aYiX94w3IPLJ2P8SMgPb/nr0LDl+zrK3/Agz5Edbo5sl5gG/NWHwRpTsBDSII2gs+e
	 ViOYCJPSGgEiem5f6PvsDK7OVJ5ef4qr8HAgYrv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	0072a70 <90307219+0072a70@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0243/1536] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Sat,  7 Nov 2026 08:37:39 -0500
Message-ID: <20261107135004.506072649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



