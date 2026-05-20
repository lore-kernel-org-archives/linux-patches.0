Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497273C6A5C;
	Wed, 20 May 2026 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297681; cv=none; b=i7mJNYYAafL5RvGounk0Von8kO0BWjQljirbS5V8L+3LPUZyLFGUud2Lh6cPauWgAx5TbXw/aesNoPJbfh0X7fY18Uj3THd4F0jrLeHGxU/a8Pk3DS+O4InX1lKb8QVd+YVOSAh9Ii9ciTg7zeIot9GLW3PiYvD/vKuUa9JjHL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297681; c=relaxed/simple;
	bh=in6VxyQrRiZGhWxdEeWoBn7wRRUHOmdesNX/Cg2l3C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMnEudaYp6W8/5l+8GOh32HbEyiQt86uZ4BMPf8sAKwKJNuv7qCwcy1n/VSGi2p0khjm/tmaosmRSp1tkXmiS04e+Oey/UkYe4Tyvo5NzYNHGIGgCL5gASD3Bo93dsmHWnhwKPyAfyijEwyL/nVaEIZpiFo7p1UqR0BqHikOzJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSmxH7QK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSmxH7QK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C021F00893;
	Wed, 20 May 2026 17:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297680;
	bh=iwm+JLqzDBqQt5sXXyJeGPFQpPnVIXprV27yxT3a+Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSmxH7QKoMD9hVqgb1n3vNLiMO8DljMezpCeSB+3XFYdeUmtTXMMaFHxcp784Hie/
	 q68znraufbxQQEyRQ+zFqYUhvXZcZEwBnRQVtn/J6IEaVHcNBCrYENay8EqU0X6zJk
	 Dz3d3F27r1juwF+lSnYfABJ5QXWJ7L4DutdHqVpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/957] wifi: mt76: mt7996: fix FCS error flag check in RX descriptor
Date: Wed, 20 May 2026 18:09:29 +0200
Message-ID: <20260520162136.425430406@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit d8db56142e531f060c938fa0b5175ed6c8cabb11 ]

The mt7996 driver currently checks the MT_RXD3_NORMAL_FCS_ERR bit in
rxd1 whereas other Connac3-based drivers(mt7925) correctly check this
bit in rxd3.

Since the MT_RXD3_NORMAL_FCS_ERR bit is defined in the fourth RX
descriptor word (rxd3), update mt7996 to use the proper descriptor
field. This change aligns mt7996 with mt7925 and the rest of the
Connac3 family.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20251013090826.753992-1-alok.a.tiwari@oracle.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 15d796702a589..2aa8bb779b228 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -527,7 +527,7 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 	    !(csum_status & (BIT(0) | BIT(2) | BIT(3))))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-	if (rxd1 & MT_RXD3_NORMAL_FCS_ERR)
+	if (rxd3 & MT_RXD3_NORMAL_FCS_ERR)
 		status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (rxd1 & MT_RXD1_NORMAL_TKIP_MIC_ERR)
-- 
2.53.0



