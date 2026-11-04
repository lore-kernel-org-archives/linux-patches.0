Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829762;
	b=hXLYiz7Wl1kdw/oy0iErIX21QoMzmd6e/MEK9IGh00SyYbU/DuF3ZlVOWBNmvRUkMY3u
	 e9Gm9vb4w21C8ZKjhi03eK7yTgSQSRS8T2xh5aqjqdrnvOxtBUJ86C4z2EHOURaDQHZoE
	 3GRm3AUTut+hEkQL1rVY5IlsIVKJpWFogIo3NDipqg5RULUajCpV+fzfshbF8Y2rHPCee
	 bV0pGTcAxD/IIya0yPlXsUJwUdjxGDRscP1Z6jps58O8oxnUSs6AlHYyogF3lI3xfgNyS
	 +F6HHcF6iA9cpy6cHD2wuf957xua072PPOrOO2oQ6eZpUKcREO72dbBnL67Nen+PPEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RL3dhLp517p02Lc2UO+obytynwSUH0YqALREJw5OEa4=;
	b=KcPQn3oeRcAbbmW5mu2oIVbHVfIUTRjo7zfSqTRtZx1PMj1IoDyOQu5IHoTbe9YjfGnu
	 RIhTSMP0yr+IULj4GfR7b0Wm0u1mcQ18v28Pqhw27Qzwk6pHK1LW14P4M/H096dWKuBu4
	 ZZ3ZiKl7bOL9UYqNdseY3t8E7ZjGdsLZ9Z6+1Nwu0JHNq3hLBJ0KkwOA0WQSAroRYSTX5
	 JERs/uc+LAbnXd3xsNQgEso9mmKWeMejR+NL9osYFd6VCa/HJPIJBxI9++TKbOMmzvWCa
	 /Xjn9Gf080hShBdyT15NLjW2dMk2uJccAo3IbEThTZEULgibHe+FP/FUwgNBA6eHG/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zD3YwLcp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BDA606CA23;
	Wed,  4 Nov 2026 22:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zD3YwLcp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DBC1F000C1;
	Wed,  4 Nov 2026 22:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829761;
	bh=RL3dhLp517p02Lc2UO+obytynwSUH0YqALREJw5OEa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zD3YwLcpkUk68UygJh/lVvQWsiFkA9Bed2DcBLVwq0cUaFlnlfwtriubtGvtd/qj6
	 eze97ClnPGcqscQ78T0HitjZndvLhYdNq9c6k8KdMqvGQjOQs1HA5TwdSO7UfHuCSJ
	 5HREU8dCzbDYzTp5iR0dv/L9wIvD50ePQ0nquXJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0326/1005] wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211
Date: Wed,  4 Nov 2026 16:00:59 -0500
Message-ID: <20261104211053.083087830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 0bbd6c52dfff62b319963f54cd9370f9486e59d2 ]

The PS queue filed redirected frames under the TID taken from the TXD,
while mac80211 was told about the TID taken from the QoS header, or TID 0
for anything that is not a QoS data frame. When the two disagree,
mt7603_release_buffered_frames() skips the frame because it does not
match the requested TIDs, so it stays in the PS queue until the station
wakes up. Buffered MMPDUs hit this whenever they were sent on a
non-zero TID.

Use one TID for both.

Link: https://patch.msgid.link/20260801145334.1166751-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index e26cc78fff949..25009e49e7771 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -39,7 +39,6 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 
 	val = le32_to_cpu(txd[1]);
 	idx = FIELD_GET(MT_TXD1_WLAN_IDX, val);
-	skb->priority = FIELD_GET(MT_TXD1_TID, val);
 
 	if (idx >= MT7603_WTBL_STA - 1)
 		goto free;
@@ -72,6 +71,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 		hwq = MT_TX_HW_QUEUE_MGMT;
 	}
 
+	skb->priority = tid;
 	ieee80211_sta_set_buffered(sta, tid, true);
 
 	val = le32_to_cpu(txd[0]);
-- 
2.53.0



