Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAD1BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C34C433EF;
	Tue,  7 Mar 2023 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212309;
	bh=0FUQUf3tFMdapdNJSPv+2g5rn/pSoqfGPS9OJiaNXFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7ZvrFnSTOg5ejgswU+HcE13VO7jHF0B2xEQt3X8r2hlgmMf9ZAM4rwFsgInw8ny0
	 LNaqmPQww2vD8FUS8NpIQ9nVwsjfPe3x3NGVzsMleH0RK5m8yNR2D+HWb+oEFi4JhH
	 QG38JXKUQZTMXiQZdidxsGZglUhvl9/nQKIvAF/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/885] wifi: mt76: mt7915: drop always true condition of __mt7915_reg_addr()
Date: Tue,  7 Mar 2023 17:50:48 +0100
Message-Id: <20230307170006.836654728@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit b0f7b9563358493dfe70d3e4c3ebeffc92d4b494 ]

smatch warnings:
addr <= MT_CBTOP2_PHY_END(0xffffffff) is always true (<= u32max),
so drop it.

Fixes: cd4c314a65d3 ("mt76: mt7915: refine register definition")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 7bd5f6725d7b7..bc68ede64ddbb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -436,7 +436,7 @@ static u32 __mt7915_reg_addr(struct mt7915_dev *dev, u32 addr)
 
 	if (dev_is_pci(dev->mt76.dev) &&
 	    ((addr >= MT_CBTOP1_PHY_START && addr <= MT_CBTOP1_PHY_END) ||
-	     (addr >= MT_CBTOP2_PHY_START && addr <= MT_CBTOP2_PHY_END)))
+	    addr >= MT_CBTOP2_PHY_START))
 		return mt7915_reg_map_l1(dev, addr);
 
 	/* CONN_INFRA: covert to phyiscal addr and use layer 1 remap */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index 5920e705835a7..bf569aa0057a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -740,7 +740,6 @@ enum offs_rev {
 #define MT_CBTOP1_PHY_START		0x70000000
 #define MT_CBTOP1_PHY_END		__REG(CBTOP1_PHY_END)
 #define MT_CBTOP2_PHY_START		0xf0000000
-#define MT_CBTOP2_PHY_END		0xffffffff
 #define MT_INFRA_MCU_START		0x7c000000
 #define MT_INFRA_MCU_END		__REG(INFRA_MCU_ADDR_END)
 #define MT_CONN_INFRA_OFFSET(p)		((p) - MT_INFRA_BASE)
-- 
2.39.2



