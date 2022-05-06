Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BFE7E8
	for <patches@lists.linux.dev>; Fri,  6 May 2022 07:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651823852; x=1683359852;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NfqfBy/2mV+d23R6nU9hPwmIhD35HU5Ufwf2vf+gjMc=;
  b=uwIptRrmQECNNGUcBRxzxqIFDeK7AXKyPtNjCRmOcOahnPB0I2KDRH0J
   vTk2WX7l2x1+AC0vEXB3T/m0neib1sdGHMRpNtVmTxToXBs9diyzTAHkQ
   RNxBe+MJA7lDsHK5UIqMV2EC3cUiRmXD3nS8RKAW1SBnZzTJfTGdFSB6t
   ccPq76hLcs/OK3ZhCccBuX2DqNFflppjITe4AGwLnh946GPT0fDSVrJih
   CKi3yFME4GQIAtDPrrjKz2+JqfBF2lzZw4+7dyA4zKTwylsh9/rhUuJLd
   hdqi3oYgJupGjbV7twFPexpcvYsRfUZRe0hugg7mH3ziknSTa8rGMVjty
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="155029122"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2022 00:56:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 6 May 2022 00:56:22 -0700
Received: from ROU-LT-M43238L.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 6 May 2022 00:56:20 -0700
From: <nicolas.ferre@microchip.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Claudiu Beznea <claudiu.beznea@microchip.com>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>, <broonie@kernel.org>,
	<patches@lists.linux.dev>, Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH] ARM: configs: at91: Enable AUTOFS_FS required by systemd
Date: Fri, 6 May 2022 09:56:11 +0200
Message-ID: <20220506075611.17840-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Align all at91 defconfigs to required options for systemd.
The missing of autofs would cause warnings on boot
when not available.

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 arch/arm/configs/sama5_defconfig | 1 +
 arch/arm/configs/sama7_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index 1c4c5a035518..18852803522e 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -222,6 +222,7 @@ CONFIG_PWM_ATMEL_HLCDC_PWM=y
 CONFIG_PWM_ATMEL_TCB=y
 CONFIG_EXT4_FS=y
 CONFIG_FANOTIFY=y
+CONFIG_AUTOFS_FS=m
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_UBIFS_FS=y
diff --git a/arch/arm/configs/sama7_defconfig b/arch/arm/configs/sama7_defconfig
index 4a8466306b54..63302858b9c4 100644
--- a/arch/arm/configs/sama7_defconfig
+++ b/arch/arm/configs/sama7_defconfig
@@ -200,6 +200,7 @@ CONFIG_RESET_CONTROLLER=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_FANOTIFY=y
+CONFIG_AUTOFS_FS=m
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_UBIFS_FS=y
-- 
2.32.0

