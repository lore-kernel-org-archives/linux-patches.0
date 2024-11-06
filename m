Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B731DF24B;
	Wed,  6 Nov 2024 12:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895992; cv=none; b=Rxn4w01qlSaZ0OP4xNpP3/rHs+i9e68i7tQvGlWLoESED9NwU4wWFIMdKXRNp43v/Btt9G1mdR/FAJweBS9uJ1nF6lbEsh3ly543C6QAlNJRqSGu2Pr1rV5UjlvZ5wyrH4rBCbTWnqdlxAfYTZvPkq/JgOskJOWf+dghmqQFlAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895992; c=relaxed/simple;
	bh=Wesyq9kjfm383SzGkMYX6/E/kVC5z1FC3MnGguLfA4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+NRYn0u2g1BCdGayyX73WZ95Y9ccAY0xoThF/DiOY4yfd1EWYm0UVjGb+Z2ps2uo7o2/8NPsZAnn0HptAuGZjMe8AjYEQk4VRjVK8cM9HrCI/WJFYaAhgPhx4Am8BF19YP0I2wcTLDUIwj9DrmDlNv5ubgguacInZbsdSoxoek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jInpjO98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jInpjO98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04AFC4CECD;
	Wed,  6 Nov 2024 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895992;
	bh=Wesyq9kjfm383SzGkMYX6/E/kVC5z1FC3MnGguLfA4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jInpjO98j/SLqSeFyi0aFYKVaDYSQq2wlVM70WogjEgWvzJn1aZr4W9WHa+6KLXbw
	 5p++HjlpvxuYCm+Oph/AQX0m/zCTU8Gh5O7lk3PzAgOe1v8H/C/7eQwJCtOg5IQHS8
	 OtmdAs9dzexVc4XE63n77nb02eEQTZeF8xrXP7As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 054/245] net: ethernet: mtk_wed: fix path of MT7988 WO firmware
Date: Wed,  6 Nov 2024 13:01:47 +0100
Message-ID: <20241106120320.546294911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 637f41476384c76d3cd7dcf5947caf2c8b8d7a9b ]

linux-firmware commit 808cba84 ("mtk_wed: add firmware for mt7988
Wireless Ethernet Dispatcher") added mt7988_wo_{0,1}.bin in the
'mediatek/mt7988' directory while driver current expects the files in
the 'mediatek' directory.

Change path in the driver header now that the firmware has been added.

Fixes: e2f64db13aa1 ("net: ethernet: mtk_wed: introduce WED support for MT7988")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/Zxz0GWTR5X5LdWPe@pidgin.makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_wo.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
index 87a67fa3868d3..c01b1e8428f6d 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -91,8 +91,8 @@ enum mtk_wed_dummy_cr_idx {
 #define MT7981_FIRMWARE_WO	"mediatek/mt7981_wo.bin"
 #define MT7986_FIRMWARE_WO0	"mediatek/mt7986_wo_0.bin"
 #define MT7986_FIRMWARE_WO1	"mediatek/mt7986_wo_1.bin"
-#define MT7988_FIRMWARE_WO0	"mediatek/mt7988_wo_0.bin"
-#define MT7988_FIRMWARE_WO1	"mediatek/mt7988_wo_1.bin"
+#define MT7988_FIRMWARE_WO0	"mediatek/mt7988/mt7988_wo_0.bin"
+#define MT7988_FIRMWARE_WO1	"mediatek/mt7988/mt7988_wo_1.bin"
 
 #define MTK_WO_MCU_CFG_LS_BASE				0
 #define MTK_WO_MCU_CFG_LS_HW_VER_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x000)
-- 
2.43.0



