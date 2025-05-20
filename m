Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D3C242D92;
	Tue, 20 May 2025 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750777; cv=none; b=XXDtmTG9RMs0PJy5qR1ZL19hR4cUhMMlv8Y2vQDXcwt1+DdV8bCM9oPtnEiHupZw6YrXsm/nhNhi2NKwBckFDQ9PPbTHZUrz5wnn6G8q4yBWekgc+SFKuCOOy9aWvmDDiA0vbGOKM2ZbGreuTx1MFtU+lfXksZqtK56SSgv6WJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750777; c=relaxed/simple;
	bh=/zwt+bcGEdtiAE2UHR0ktLETxlL63Yk5ibLWBfOY3XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TilOly86QNcN/YQv/WnDfbBz87dD/pWW3O+CQVcOYlWNR5Hyoqe9DVZ3epn/wG00Y0imxvK1A/ZdX9VMQHPrKPMZVEzT0scpDxxBhZsHPR3W13EnK+54qI8eb/MMXBMhWp/AlVw+zpU6hIuCMBvP16NNV7qoYbWe3VjQqUgDX5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0EohMXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0EohMXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1CFC4CEE9;
	Tue, 20 May 2025 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750777;
	bh=/zwt+bcGEdtiAE2UHR0ktLETxlL63Yk5ibLWBfOY3XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0EohMXLkVQer/L8okC8Pr5mAYd9gFeZUJ4hscV2vodbd1C94k0fCbDr7zhb6/mHx
	 9O0NFGFcKpOw8HfZsmbb8GRM8AyzrcWQ+d9TTJJIY5iItFT6mtnoOqH2UR6dr6Z/vk
	 G0o4ym8muVMPqCnUvq9nnPfVRYP34sSdCU8JWIrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Xiao <fossben@pm.me>,
	Niklas Schnelle <niks@kernel.org>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.14 118/145] wifi: mt76: mt7925: fix missing hdr_trans_tlv command for broadcast wtbl
Date: Tue, 20 May 2025 15:51:28 +0200
Message-ID: <20250520125815.175222739@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 0aa8496adda570c2005410a30df963a16643a3dc upstream.

Ensure that the hdr_trans_tlv command is included in the broadcast wtbl to
prevent the IPv6 and multicast packet from being dropped by the chip.

Cc: stable@vger.kernel.org
Fixes: cb1353ef3473 ("wifi: mt76: mt7925: integrate *mlo_sta_cmd and *sta_cmd")
Reported-by: Benjamin Xiao <fossben@pm.me>
Tested-by: Niklas Schnelle <niks@kernel.org>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://lore.kernel.org/lkml/EmWnO5b-acRH1TXbGnkx41eJw654vmCR-8_xMBaPMwexCnfkvKCdlU5u19CGbaapJ3KRu-l3B-tSUhf8CCQwL0odjo6Cd5YG5lvNeB-vfdg=@pm.me/
Link: https://patch.msgid.link/20250509010421.403022-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1867,14 +1867,14 @@ mt7925_mcu_sta_cmd(struct mt76_phy *phy,
 			mt7925_mcu_sta_mld_tlv(skb, info->vif, info->link_sta->sta);
 			mt7925_mcu_sta_eht_mld_tlv(skb, info->vif, info->link_sta->sta);
 		}
-
-		mt7925_mcu_sta_hdr_trans_tlv(skb, info->vif, info->link_sta);
 	}
 
 	if (!info->enable) {
 		mt7925_mcu_sta_remove_tlv(skb);
 		mt76_connac_mcu_add_tlv(skb, STA_REC_MLD_OFF,
 					sizeof(struct tlv));
+	} else {
+		mt7925_mcu_sta_hdr_trans_tlv(skb, info->vif, info->link_sta);
 	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, info->cmd, true);


