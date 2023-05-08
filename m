Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89022168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09997C433D2;
	Mon,  8 May 2023 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542389;
	bh=PTvpncsa3aEuMCBLnlSRQ1gsfrE66LxZEpGOhsOZO6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zs+5iZkH3flImzSBha9IcX4y4mCI8kkQlg8VOePY7uR6ZC5jDLygCYS27DtWjvmCz
	 QuLYBJqqAQQBgaNpP0xV7APHRr0bpYMgjJP+XVK0wiuVZcHubheL/V20+49le8tB6J
	 E6UNoRsg1+bJ+DIlOK7TVt1u6xd4Dxbmn4tYkdNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 385/663] wifi: mt76: remove redundent MCU_UNI_CMD_* definitions
Date: Mon,  8 May 2023 11:43:31 +0200
Message-Id: <20230508094440.600961391@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit 532f0482fc577a78c0086893ab39acb406ac3e65 ]

clear redundent definitions only

Fixes: 5b55b6da982c ("wifi: mt76: mt7921: add unified ROC cmd/event support")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 82fdf6d794bcf..3c7c369d997ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -962,9 +962,6 @@ enum {
 	DEV_INFO_MAX_NUM
 };
 
-#define MCU_UNI_CMD_EVENT                       BIT(1)
-#define MCU_UNI_CMD_UNSOLICITED_EVENT           BIT(2)
-
 /* event table */
 enum {
 	MCU_EVENT_TARGET_ADDRESS_LEN = 0x01,
-- 
2.39.2



