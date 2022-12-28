Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14031875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68569C433D2;
	Wed, 28 Dec 2022 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243212;
	bh=68xVN3VZeD0h3tBkM7WjOn+syreLcmrMvcQukqO9hsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NO4PUmBZpDXs8okx1sc7g68S+g1II+W0vtnEmnyMs0bcrMQYw2olpxo2sVeYpo1Wp
	 4HL3ygdjLpPlUQP6VhYVAFT/yl99bPFHNgi9ttvKguCtHcFSZJV5jFudd98QOV8Qfc
	 V2fdXyzioqzUtvaNcrdTeaTGzg6C0jGSW/a1kgIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0463/1146] wifi: mt76: do not send firmware FW_FEATURE_NON_DL region
Date: Wed, 28 Dec 2022 15:33:22 +0100
Message-Id: <20221228144342.759041031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit f37f76d43865c58cb96aa13c87164abb41f22d0b ]

skip invalid section to avoid potential risks

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 011fc9729b38..025a237c1cce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2834,6 +2834,9 @@ mt76_connac_mcu_send_ram_firmware(struct mt76_dev *dev,
 		len = le32_to_cpu(region->len);
 		addr = le32_to_cpu(region->addr);
 
+		if (region->feature_set & FW_FEATURE_NON_DL)
+			goto next;
+
 		if (region->feature_set & FW_FEATURE_OVERRIDE_ADDR)
 			override = addr;
 
@@ -2850,6 +2853,7 @@ mt76_connac_mcu_send_ram_firmware(struct mt76_dev *dev,
 			return err;
 		}
 
+next:
 		offset += len;
 	}
 
-- 
2.35.1



