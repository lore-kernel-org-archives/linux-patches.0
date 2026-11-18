Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051302;
	b=E6mKThqv7dq2Hdg2tYuqBEJQ8RW0iKwdEW2JdkDdllGIDHdXb7Csa0wUS5WfQ4iH1OAw
	 s97z7y8kGUglh3yq4CPx/JKXXqDBsDrS3bHGDTd6RUc7KETDx+xakTL6ej8jsjHSrcQpV
	 0r+HqOz0iuTlMYuQNfOa3EKZjHhdIVctseq+6eyDjCpMV+wMXmf8vDOdStDOvFMhosrEb
	 xndupiChVvvRBTOjyiCHqKZ/yB9zu7PZS5hDVia7PBgZrskZ18WvZh6lCIIY8uSJ2KnT0
	 w1z/G2ibXkgDMrurm/npEvzdNPAjEIi9ILsO2SzvwVo/lOISG0E/Z1vMqxEszUFpGOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EZprnQAKNx8ksApx6+a2Pm4UdJqm8EM4eSvrDf3MqQU=;
	b=qfZRSKu9ziJAnYr6DMApUx388V3cLRp7mTVDbdeyIHSLNqQrpsiXW5bkXHtrmAEf9L/y
	 GoCHE9GTDpOH1sZQWVO2pdi11VObQce0D8cqmZPYrQLuabPHts58juHfBsfLTN/r0sfx9
	 na2SaXEt9qCEnApHWsDjKAeMo04cVISLFV6rTOsw9EdI+Te/Dnzqnlh6qndZ08fWHD74X
	 bq5q13qJzi33EmHV8Wnb3Vi6/VBVujYOiw0rFNHED983qbKE6Tx9NCJ+G8zYHPvILGFZ3
	 RbPToYTE68nwI9h2h9WZ+3Y61qeP6jiIQ/NB5A8n2Kal/qpnlKHw29GdlL9/Na6emBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftDr2wBJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14DD606A320;
	Thu, 19 Nov 2026 01:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftDr2wBJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321BD1F000C4;
	Thu, 19 Nov 2026 01:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051302;
	bh=EZprnQAKNx8ksApx6+a2Pm4UdJqm8EM4eSvrDf3MqQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftDr2wBJpAeDPZJknq7N7A04+NvbpH9Ase1y3htJ1PVfdAQlermJwxpwjyh50N8UK
	 sAwK+CsBrTsST6ylE1d00wiPvUNJekzDZjGnnmp8mYJRodFRi9OTq8pY5+PZFp+XGB
	 9KwowCraoxVJ3GVtcSm1zeV1k3j25oFUxCHLkHJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	0072a70 <90307219+0072a70@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0159/2214] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Wed, 18 Nov 2026 15:30:35 +0100
Message-ID: <20261118150016.488468057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d29d695a433d9..b0f8e29e3cc4d 100644
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



