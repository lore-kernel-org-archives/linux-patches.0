Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643903EA89
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAkIOL8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F09C433C9;
	Wed, 15 Nov 2023 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076996;
	bh=61DUVm0EWTOlpMTZZg6o2BlTUua64yxlhRxE42YGgOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAkIOL8Gr1I6RZ0WxLj7n3Pl85hR8U3+z6hqg+fIQk+csjcl8AYUuBVO3NZXHvtvi
	 fs52PwzbxKWzkoOE+FFR10/Vviyq+5dAdIHcX/yhMJg2VYAdRf0+nShNUnlrNpkUbt
	 Pd3TL84EYPSbVNH8TJEmI/BWXHuJkpZELzV9/COY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/603] wifi: mt76: mt7996: fix TWT command format
Date: Wed, 15 Nov 2023 14:10:33 -0500
Message-ID: <20231115191619.227209424@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf443748ef7cc..b0e6f51041fdd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3548,7 +3548,9 @@ int mt7996_mcu_twt_agrt_update(struct mt7996_dev *dev,
 			       int cmd)
 {
 	struct {
-		u8 _rsv[4];
+		/* fixed field */
+		u8 bss;
+		u8 _rsv[3];
 
 		__le16 tag;
 		__le16 len;
@@ -3566,7 +3568,7 @@ int mt7996_mcu_twt_agrt_update(struct mt7996_dev *dev,
 		u8 exponent;
 		u8 is_ap;
 		u8 agrt_params;
-		u8 __rsv2[135];
+		u8 __rsv2[23];
 	} __packed req = {
 		.tag = cpu_to_le16(UNI_CMD_TWT_ARGT_UPDATE),
 		.len = cpu_to_le16(sizeof(req) - 4),
@@ -3576,6 +3578,7 @@ int mt7996_mcu_twt_agrt_update(struct mt7996_dev *dev,
 		.flowid = flow->id,
 		.peer_id = cpu_to_le16(flow->wcid),
 		.duration = flow->duration,
+		.bss = mvif->mt76.idx,
 		.bss_idx = mvif->mt76.idx,
 		.start_tsf = cpu_to_le64(flow->tsf),
 		.mantissa = flow->mantissa,
-- 
2.42.0



