Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16EBBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27656C433D2;
	Tue,  7 Mar 2023 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215115;
	bh=5HntSCKt/hTZbeMEjb/UQM2VfEiJJ6Blqg5wKcidHdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyI/go2AykOtK3xn6fTMlPfeKH/iJlkmwraQG1L3OXytGUWYKzl2XQ6g8FFDCEeX0
	 4/mE/7SnIuIVo5AzWkNbqVxlWX9AvRJbNv5JAFUyLNgOy0/cPi3YjoJzwT0ixBuTvC
	 Qe+yW9g5DzIZgawGP4AjQ3NVqZ0lbx23zb95s2R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/567] mt76: mt7915: fix polling firmware-own status
Date: Tue,  7 Mar 2023 17:57:41 +0100
Message-Id: <20230307165911.307870616@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 71bb496ce17f6976c8a75b054861781965b07ac0 ]

Check the register status bit instead of the trigger bit

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index e9d854e3293e4..1c900454cf58c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2689,7 +2689,7 @@ static int mt7915_driver_own(struct mt7915_dev *dev)
 {
 	mt76_wr(dev, MT_TOP_LPCR_HOST_BAND0, MT_TOP_LPCR_HOST_DRV_OWN);
 	if (!mt76_poll_msec(dev, MT_TOP_LPCR_HOST_BAND0,
-			    MT_TOP_LPCR_HOST_FW_OWN, 0, 500)) {
+			    MT_TOP_LPCR_HOST_FW_OWN_STAT, 0, 500)) {
 		dev_err(dev->mt76.dev, "Timeout for driver own\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index a213b5cb82f81..f4101cc9f9eb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -426,6 +426,7 @@
 #define MT_TOP_LPCR_HOST_BAND0		MT_TOP(0x10)
 #define MT_TOP_LPCR_HOST_FW_OWN		BIT(0)
 #define MT_TOP_LPCR_HOST_DRV_OWN	BIT(1)
+#define MT_TOP_LPCR_HOST_FW_OWN_STAT	BIT(2)
 
 #define MT_TOP_MISC			MT_TOP(0xf0)
 #define MT_TOP_MISC_FW_STATE		GENMASK(2, 0)
-- 
2.39.2



