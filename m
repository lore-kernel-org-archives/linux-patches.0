Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F2F3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKQDDq4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AC2C433C8;
	Wed, 15 Nov 2023 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076167;
	bh=uobFnS0ygiwKsUXmKElHdx+SauYKzpFEwwTGSE5rdgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKQDDq4DxOCeZXNZefqlbBgEAu/tFCOXCnEzvXNEPgBzPYGWkfp2xqWG3duByuM7g
	 r2S0eY3F7SDOFhw9VfzWAvTpYm9GQxQpNVuEjb2mmDNN+vADBdbqltYdukxJqXHyf4
	 ngGbJvwV5TQs4tfp0Z/AG+GuIOnXpJRseX4++cJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 091/550] wifi: mt76: mt7996: fix TWT command format
Date: Wed, 15 Nov 2023 14:11:15 -0500
Message-ID: <20231115191607.026646117@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 84f313b7392f6501f05d8981105d79859b1252cb ]

Align the command format of UNI_CMD_TWT_ARGT_UPDATE to firmware.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 6520761d9fe13..fbf9a5c3b98ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3449,7 +3449,9 @@ int mt7996_mcu_twt_agrt_update(struct mt7996_dev *dev,
 			       int cmd)
 {
 	struct {
-		u8 _rsv[4];
+		/* fixed field */
+		u8 bss;
+		u8 _rsv[3];
 
 		__le16 tag;
 		__le16 len;
@@ -3467,7 +3469,7 @@ int mt7996_mcu_twt_agrt_update(struct mt7996_dev *dev,
 		u8 exponent;
 		u8 is_ap;
 		u8 agrt_params;
-		u8 __rsv2[135];
+		u8 __rsv2[23];
 	} __packed req = {
 		.tag = cpu_to_le16(UNI_CMD_TWT_ARGT_UPDATE),
 		.len = cpu_to_le16(sizeof(req) - 4),
@@ -3477,6 +3479,7 @@ int mt7996_mcu_twt_agrt_update(struct mt7996_dev *dev,
 		.flowid = flow->id,
 		.peer_id = cpu_to_le16(flow->wcid),
 		.duration = flow->duration,
+		.bss = mvif->mt76.idx,
 		.bss_idx = mvif->mt76.idx,
 		.start_tsf = cpu_to_le64(flow->tsf),
 		.mantissa = flow->mantissa,
-- 
2.42.0



