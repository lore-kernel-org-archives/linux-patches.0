Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7E2BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64632C433EF;
	Tue,  7 Mar 2023 17:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209197;
	bh=6Ou/obbiQkfuLt6sKs3+sngkWYw6NXG3A1WTqT1Qy4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vj5L4Ox3epZUkWtpiXeqsVxJcWHvrQMmoE3fWhpO1vt9dP1KXIzXRHi7i0vXHXF2O
	 ISgLWTVZrm/o8cp2fV3gbGt0Wt209kG3X/nKUR59AYA39gaZOO+NXnTXIK+H1i3moA
	 yE2YXBjXJf9i4OWGwEPnVNPEWsdvhmfOiiilS378=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0141/1001] wifi: mt76: mt7996: drop always true condition of __mt7996_reg_addr()
Date: Tue,  7 Mar 2023 17:48:33 +0100
Message-Id: <20230307170028.176564506@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit ef1ea24cb0ecfd42c1ff266d92613163792aec77 ]

addr <= MT_CBTOP2_PHY_END(0xffffffff) is always true (<= u32max),
so drop it.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 521769eb6b0e9..60781d046216a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -149,7 +149,7 @@ static u32 __mt7996_reg_addr(struct mt7996_dev *dev, u32 addr)
 
 	if (dev_is_pci(dev->mt76.dev) &&
 	    ((addr >= MT_CBTOP1_PHY_START && addr <= MT_CBTOP1_PHY_END) ||
-	     (addr >= MT_CBTOP2_PHY_START && addr <= MT_CBTOP2_PHY_END)))
+	    addr >= MT_CBTOP2_PHY_START))
 		return mt7996_reg_map_l1(dev, addr);
 
 	/* CONN_INFRA: covert to phyiscal addr and use layer 1 remap */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
index 794f61b93a466..42980b97b4d41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
@@ -463,7 +463,6 @@ enum base_rev {
 #define MT_CBTOP1_PHY_START			0x70000000
 #define MT_CBTOP1_PHY_END			0x77ffffff
 #define MT_CBTOP2_PHY_START			0xf0000000
-#define MT_CBTOP2_PHY_END			0xffffffff
 #define MT_INFRA_MCU_START			0x7c000000
 #define MT_INFRA_MCU_END			0x7c3fffff
 
-- 
2.39.2



