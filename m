Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060859;
	b=WU9L8JNJ9C5xpYj6A9IJBv4yttrArb0fix27llPH7VdThVQYEhItAO9YrWmniFPCmK6r
	 9YjOz+GzZ/BFWFBwWOKZwgOznWEp85cIjUN2ANKGKDuWE26R8Xxa6l39rBm0tQg5o1CHh
	 7dCZRdGAk6CN0EF9TDH9zSsFO/MP94uU4czFCzjFqb8N0RS0IaaJVkVKxXPIePfZa9EB3
	 lYjih6ccCyquLlSbnoH6L2Qeh+A61u2ihMhwm79wUAPYlcGoR0lq7RSwBST5vSvwTMY04
	 QXEv7DNxr4lrhJlRsIAz40EuH1WKpvH5pNdkiw1tXp+ryV23TinEfLadmR3d3GmlvFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNhAmxiVtAZB7YmMT8s8z2RaCmSSHJjE1cw0EPGF4nU=;
	b=de+KSyXADKHqogJPpbe89ydZm0nEV7kEFPTogJnC5ElNwdz7EIjY+BWXiXeO4aWsuucr
	 idZdBWnvulsxuSuXDnYx1XoAzr3MCUD8cD+qNdwqQ40gH+Gak4cMvU8fjf7hnZG2ocZmH
	 2ROR8JUTpcBaAKQtbpksWBdgEzN99PB3leZ+DCQbJye16AlLu83ttErPYGWZRfXAt8/WZ
	 YPclDnBi4G3dWiNOst5mQGBFn49EQ8iYl8aeNPxaSc0rOWwd/UA9vklwQs8eX4pFd3tYF
	 CsV0horqtBwavTizzJrWtOUXmAxRmnBNbEudd1CD44T25XwoSlu95bPdhYfOfapEVWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mh3itCFE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1707F606A33E;
	Sat,  7 Nov 2026 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mh3itCFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66531F0089F;
	Sat,  7 Nov 2026 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060858;
	bh=DNhAmxiVtAZB7YmMT8s8z2RaCmSSHJjE1cw0EPGF4nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mh3itCFENyu7LKPGG7FQcR7+nR7YWvCy0sYC1Jb9/5ekjqyvZPNwIo80MxdfCt5mo
	 zPdjJM9Tv3aiAiBlLtbixv9FlJXTm5tQ2yPDQRmbJgYGjDDFHEFnAjqX1AJX08zEP7
	 leGBhPhNV6LCHDkhXK9QNwmrPqL0E3REdTLyWNUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0242/1536] wifi: mt76: mt7603: free beacon SKB on error
Date: Sat,  7 Nov 2026 08:37:38 -0500
Message-ID: <20261107135004.477455667@linuxfoundation.org>
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

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 965cbdbdfbd37a659a05ff88e49c216975bd9d2e ]

The SKB containing the generated beacon is not freed when the beacon
queue is deected stuck and scheduled for recovery.

Fixes potential memory leaks in case the beacon queue is detected stuck.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260611215658.259324-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index 6457ee06bb5a1..62e8de6949d1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -56,6 +56,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BCN));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
@@ -63,6 +64,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BMC));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
-- 
2.53.0



