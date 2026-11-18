Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019068;
	b=Yv49LKLzAshepR/vTtBYVJsyeLsLhdFMJG2QCA2qohsER0KTU/EegxGv21ViPzXV1MR7
	 eGydkLSEJcpsDOTxuzRaCBlFeFM8YuMdkjNuzZOF2C4kOZuSAG7P2KrkpTo7ufpB56Dwm
	 e202vORd3e228rwQBwTbKf+q625OlxcNrbSUNNk8rY29WOo0MCzjePDnoC41VORc/C/x6
	 Yi2/J3I4zpS1Gj+6m30M3nFPS6oJasBiOHHh3hs83pci3zJGCy2BZicN5qIrR+MAJg9tr
	 9Rqy92gjNrYxTX503/d+H860K1qv6V5xYefIQlkQyg071KaZE5l3TSrF2gYRcsV6z9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wZMo+iegmPGZaytJEU8dM1y+kq+6e9d+A5FDG0lFUdw=;
	b=xVRFH3wfJ4LDt59NskUjDOzjVoAZUuyLe98r8c6d67Px50ULFjP4PRzJp5wh7XffoIzs
	 edPmQ73reng5KK53UPCotaN4re5bQPqShu4E/nVBezQNVf/6QzT7owUioMCn7yXgeEFm0
	 l56XvO5R0+AYt5dLKV7Z1kryAcuCLAVOLiP7zx8AzaxRAE/mfGDEWw407xNDv+JdeUDS4
	 pDfjj+Hk5RmoRTUn+s/lDKBIWHGHowBmY1Wp8WOFzYF+/LSNrTuUHOoZHvsMqHvIRyM6Z
	 2T89dhAxof6SkQj0bLMaiPnsOd6ohEb+YrG/b3WNUEtsPRAFeHO/EBV5dMRgtB7ENLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6Tzihph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC2460A2626;
	Wed, 18 Nov 2026 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6Tzihph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43F41F000C4;
	Wed, 18 Nov 2026 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019068;
	bh=wZMo+iegmPGZaytJEU8dM1y+kq+6e9d+A5FDG0lFUdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6TzihphdqrOGFgAUj1M6bBQoHPOlsKJmyRZ3iOolmxGxlemBPHIlgy0ITVhcG3it
	 AxGOQyPjYzlSjD/dYRQ6PZV6VB+2ugzgOznOZWs4nk2T/fMIFGpUHkOoMQ5eC4mo+v
	 fpa8qjcL1jQHszDuthPG72IqOBxppjNOYOTdNP8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Saran <maheshsaran477@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1464/2651] wifi: mt76: mt7921: clear WM2 from MT7902 RX all_complete_mask
Date: Wed, 18 Nov 2026 15:45:04 +0100
Message-ID: <20261118150340.739725459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Saran <maheshsaran477@gmail.com>

[ Upstream commit 87b67aa8eb32cf89dab4c6df88d65e07fec46592 ]

MT7902 does not have an MCU_WA ring and sets wm2_complete_mask to 0.
However, commit 83c65e82e5b2 ("wifi: mt76: connac2: apply new rx
all_complete_mask") populated all_complete_mask in the shared irq_map
template with MT_INT_RX_DONE_ALL, which includes MT_INT_RX_DONE_WM2.

Because MT7902 duplicates irq_map but only clears wm2_complete_mask,
its all_complete_mask still contains MT_INT_RX_DONE_WM2. This leaves
the MT7902 RX interrupt configuration inconsistent: the aggregate RX
completion mask includes WM2 even though the corresponding RX queue is
not present on MT7902.

Clear MT_INT_RX_DONE_WM2 from all_complete_mask for MT7902 as well.

Fixes: 83c65e82e5b2 ("wifi: mt76: connac2: apply new rx all_complete_mask")
Signed-off-by: Mahesh Saran <maheshsaran477@gmail.com>
Link: https://patch.msgid.link/20261006163553.11193-1-maheshsaran477@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 56a914aaa81ea..f87c44f2a8b6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -375,6 +375,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		}
 
 		map->rx.wm2_complete_mask = 0;
+		map->rx.all_complete_mask &= ~MT_INT_RX_DONE_WM2;
 		dev->irq_map = map;
 	}
 
-- 
2.53.0



