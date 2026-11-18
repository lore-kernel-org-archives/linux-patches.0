Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057457;
	b=RFDCUEZw39ST3dpucbZfAaSYd7Gtvje0eJ4wU99JqD37AxF568uf+s1n9uleTF6R3vQb
	 KgUAt846Up6O2B/uVQe3TDCFlld4Q0VKxXuC7Z0QFY/GI6c/odXrZkU4el3iT/2nrezZI
	 d0Xb9Y1rNMKpvB2WZ5Tk4dXWxdniHhdzdNy6YRJbreOPKhHSBceMFNKWAJzUqEl1f3PpI
	 s2w4SsdZ/xl0qoXOsRB8SKZriHgw7Sk3x/8PMWH7S69F8IsBtmTvK2+Iny7CzVfCINHy/
	 xdcp89herurUkRoc18NCOX9rQ/yCgQD4aUXsul9y5WU9GTOsxPExok9CZ+m2ItSURcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F3dQP3gYrPo1Jb9ulzfm4H7BuXA1xrtOqeoVe45ecbI=;
	b=wUrBV378+u/LdCAzKYOsFMO/bpK7oD2qNc3wL2dzbkiY2/8afBQjP/pn7uMl19t1Rym2
	 hYpZvFCVZitYdVgb9NrvuzoeWuA6gOKg6jyFmLjaOPco0hoXZCPKYtK3+u3ldXe/vZ7rS
	 ud+xt18ZqGV6bZt9Z+EW8q8PXihQVo9d/SReg8h2hZqiYjOFPF/3k2Jw2upwWjwWqdGDx
	 oZ88sDyqdvXyESUrBg/Jvd/L4a998JTN0w9ouPEggvuyAX9M/pElRDngLvWyzVZrjpuF5
	 GLeTaY39JJklOdJ5EqRxKWwf1pjgz5I22oSjYGY9OGC7n1iMT/UNAM5DDiGnj7zz6/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xskj19tG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986360A261E;
	Thu, 19 Nov 2026 03:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xskj19tG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243281F000C8;
	Thu, 19 Nov 2026 03:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057457;
	bh=F3dQP3gYrPo1Jb9ulzfm4H7BuXA1xrtOqeoVe45ecbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xskj19tGOXc9dR6JYNasnaGLDmjfL0kUDjpF0bi70bkMkfGaLEsRXmC8vbJZRvzwq
	 1a+XMStaaSiLnLdL2adPNcWZWMcU3AWeh0SK+CVGFW+NsFnS34stj5wwiUTrZLlrFx
	 XESLO3p+Ne4KOJaVv+kCQ4bosgz+beUVrDD2/3oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	0072a70 <90307219+0072a70@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0135/1848] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Wed, 18 Nov 2026 15:36:13 +0100
Message-ID: <20261118145916.883545467@linuxfoundation.org>
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
index e0e588d51adc0..c5d3bb1d04b04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -790,6 +790,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
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



