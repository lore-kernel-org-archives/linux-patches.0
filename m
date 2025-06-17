Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301A2EA15F;
	Tue, 17 Jun 2025 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175996; cv=none; b=ljc0CtbEwPGpON31fXbpDgFWJ9geuKeg5oTmZ2p1QKpqJMUSFtbaBQmLtY7ZIpM+J+DS5vQJzQkVSB/pLXEtO6xrCumT7EH1TxQJm/h0bVol/+1JFDgDF7sI6mmTwCHVExNG9UfSK6smNGvnqqs1cdwafBKjNeNTBL5zwfjEN5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175996; c=relaxed/simple;
	bh=Y3+vKKVUPGvlHLWY2U0dDmBV79SuixRpU/9T1itZ5CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9QaDQbav0f0dALDz+rElgZ3GZBZB2hoPAUUJgCfoA1Ej1/yRgtpB5m4Cm+YT8qoba8xaB2mQ3YAoYH22uwlhYGqZZHjA/tXHK8vRxrCj0WHCGPeuNd3axUZcLQIgRzVvLZ1EZfsSPXfyiooLVQTCBlVEAV6KT68ehibb+NPP5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NO969RHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NO969RHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE7AC4CEE3;
	Tue, 17 Jun 2025 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175996;
	bh=Y3+vKKVUPGvlHLWY2U0dDmBV79SuixRpU/9T1itZ5CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NO969RHIwVlv4r8c5xTd+OGeYJZKlKabFx1CpX+nyE+OBJJm8rIJLrNvFbwKj7QRZ
	 /BHnJy6oVOMQToQ6OysgcrtGmEsWbXRdVRpf+dLOatlo/zg6+1w7o4HxLu15qs7gQc
	 A0yVmIOZ5Eg8yVV5qQIrLUThS6ZuDLhwIuJvGWzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/512] wifi: mt76: mt7925: refine the sniffer commnad
Date: Tue, 17 Jun 2025 17:22:32 +0200
Message-ID: <20250617152427.182639533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit bd02eebfc0b3502fe8322cf229b4c801416d1007 ]

Remove a duplicate call to `mt76_mcu_send_msg` to fix redundant operations
in the sniffer command handling.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250414013954.1151774-2-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 7ad9e1eaaa8f3..9a9900eba5020 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2087,8 +2087,6 @@ int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 		},
 	};
 
-	mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(SNIFFER), &req, sizeof(req), true);
-
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(SNIFFER), &req, sizeof(req),
 				 true);
 }
-- 
2.39.5



