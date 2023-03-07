Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB05BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D862C433A8;
	Tue,  7 Mar 2023 17:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209517;
	bh=ikfnVinAPdN807eVqKdI+oZ1iqC+crWO2YaaJsKIIwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2EhD8kBPPbqqT9M4pILqs+osG7GxWywd/tOW/cKShAtVoROGxzcE/fSuwBNVlig9
	 H33lVFMZ51bb/0k5XZb7/NufBLrjPyasfiz8HQvJIJdEhDr2I18H4y6+8CiXKwphJN
	 /O531q2tFKetAwxgrh8UuXdAJ/cxkgAryS7ATdQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0244/1001] wifi: mt76: connac: fix POWER_CTRL command name typo
Date: Tue,  7 Mar 2023 17:50:16 +0100
Message-Id: <20230307170032.391361972@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 0d82fc956edb67b5755cc64ac6b9aee79cfbbff0 ]

Fix typo MCU_UNI_CMD_POWER_CREL to MCU_UNI_CMD_POWER_CTRL.

Fixes: 779d34de055e ("wifi: mt76: connac: add more unified command IDs")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index f1e942b9a887b..82fdf6d794bcf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1198,7 +1198,7 @@ enum {
 	MCU_UNI_CMD_REPT_MUAR = 0x09,
 	MCU_UNI_CMD_WSYS_CONFIG = 0x0b,
 	MCU_UNI_CMD_REG_ACCESS = 0x0d,
-	MCU_UNI_CMD_POWER_CREL = 0x0f,
+	MCU_UNI_CMD_POWER_CTRL = 0x0f,
 	MCU_UNI_CMD_RX_HDR_TRANS = 0x12,
 	MCU_UNI_CMD_SER = 0x13,
 	MCU_UNI_CMD_TWT = 0x14,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index a88fc7680b1a9..d781c6e0f33ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2399,7 +2399,7 @@ mt7996_mcu_restart(struct mt76_dev *dev)
 		.power_mode = 1,
 	};
 
-	return mt76_mcu_send_msg(dev, MCU_WM_UNI_CMD(POWER_CREL), &req,
+	return mt76_mcu_send_msg(dev, MCU_WM_UNI_CMD(POWER_CTRL), &req,
 				 sizeof(req), false);
 }
 
-- 
2.39.2



