Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214482;
	b=naOqCa1qWBdH15cujk92ItKnYApwFlouqrjISKk98ZeK+BQaq5F2M+yXemQ5g4gGBIYj
	 SAbzn6L8uav1vyf41IWsLbF1erAWSS/+Ny3VT6qlFmROeRY22hCeVF/5HyBB5+EpZWutT
	 /mGVyL7olxTtw6OVw1+5CGr3PMFRknlRlK470LCPZ4I/YBNPD/cI+J+dMw5Px2H6Df8VM
	 grk+IdBxqeM4hoqmSwVRDPdqeXmGJCPHOUJiQBgRfKXPsfblg8wlYpj1VHQE+7C64hpMy
	 L0vO31mS7zXXyVOINCabbSRuV+kH/M41vNSArNAWppitXFE5g6IjaVdDX0zxEsiQI+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PtXEM6bKFXhe8itYJI1/H46KdTt9ZRYNZBW317K1s3U=;
	b=zC+TN/Ri9Uz7NeXnfuv+Ac4KryQbgJKxYP5gs9JwYYgYL5OBHcpO1StuHNBSPmziSMXw
	 tBTziCxWCfJYWL4yb7n2x0SGI7xC1ElFsbtQWVDH3yQegLoGFfzB8uBtyXba7PLt0LrUw
	 rMciZrYLpIu25/vsWrYsJsareyiqsBE5RlE9dD4HQSwm8onNCSo0ywBvFQW6bVufGD2P1
	 ocF/2V6y3L0eiQsgz1Mity89mPy9B4WckWL8H9DANcPskeEOkBkG6xNGeN2CcuTbO1FYg
	 16Poa18UEBNa0SeqmCZcxHzrBJLJYb6Z7L2Z6C78QS+XAuVXws6vghnDl1KAuCNGt4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTvyNKEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE59A606B7E1;
	Wed, 28 Oct 2026 19:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTvyNKEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF521F01828;
	Wed, 28 Oct 2026 19:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214481;
	bh=PtXEM6bKFXhe8itYJI1/H46KdTt9ZRYNZBW317K1s3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTvyNKEq8Zkw4+QupIlabjAOld31nRPHezUdZulPp1S70bLliEAuNPGMl67Gw6d9r
	 PhTnEbn+I/SdqC6SlAnA1U/IyrRJauF9Q7FD3BI/T4KSeXUNikSZsbN5XtQHFpJM1n
	 ODSlCunbPdo5kFgjipprLResfNiQl8J7F6PPcx/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0874/1887] mailbox: Explicitly include correct DT includes
Date: Wed, 28 Oct 2026 17:49:30 +0100
Message-ID: <20261028170519.308085335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit e9803aac5097ac74186b074d3176318fd10ec98c ]

The DT of_device.h and of_platform.h date back to the separate
of_platform_bus_type before it as merged into the regular platform bus.
As part of that merge prepping Arm DT support 13 years ago, they
"temporarily" include each other. They also include platform_device.h
and of.h. As a result, there's a pretty much random mix of those include
files used throughout the tree. In order to detangle these headers and
replace the implicit includes with struct declarations, users need to
explicitly include the correct includes.

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhu.c            | 1 +
 drivers/mailbox/arm_mhu_db.c         | 1 -
 drivers/mailbox/hi3660-mailbox.c     | 1 +
 drivers/mailbox/hi6220-mailbox.c     | 1 +
 drivers/mailbox/imx-mailbox.c        | 3 ++-
 drivers/mailbox/mailbox-mpfs.c       | 1 +
 drivers/mailbox/mailbox.c            | 1 +
 drivers/mailbox/mtk-adsp-mailbox.c   | 3 ++-
 drivers/mailbox/mtk-cmdq-mailbox.c   | 2 +-
 drivers/mailbox/omap-mailbox.c       | 2 +-
 drivers/mailbox/platform_mhu.c       | 1 +
 drivers/mailbox/rockchip-mailbox.c   | 2 +-
 drivers/mailbox/sprd-mailbox.c       | 2 +-
 drivers/mailbox/stm32-ipcc.c         | 1 +
 drivers/mailbox/tegra-hsp.c          | 1 -
 drivers/mailbox/zynqmp-ipi-mailbox.c | 2 --
 16 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/mailbox/arm_mhu.c b/drivers/mailbox/arm_mhu.c
index 22243cabe0565..537f7bfb7b064 100644
--- a/drivers/mailbox/arm_mhu.c
+++ b/drivers/mailbox/arm_mhu.c
@@ -12,6 +12,7 @@
 #include <linux/io.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #define INTR_STAT_OFS	0x0
 #define INTR_SET_OFS	0x8
diff --git a/drivers/mailbox/arm_mhu_db.c b/drivers/mailbox/arm_mhu_db.c
index aa0a4d83880fc..27a510d469082 100644
--- a/drivers/mailbox/arm_mhu_db.c
+++ b/drivers/mailbox/arm_mhu_db.c
@@ -15,7 +15,6 @@
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_device.h>
 
 #define INTR_STAT_OFS	0x0
 #define INTR_SET_OFS	0x8
diff --git a/drivers/mailbox/hi3660-mailbox.c b/drivers/mailbox/hi3660-mailbox.c
index ab24e731a7823..17c29e960fbf8 100644
--- a/drivers/mailbox/hi3660-mailbox.c
+++ b/drivers/mailbox/hi3660-mailbox.c
@@ -11,6 +11,7 @@
 #include <linux/iopoll.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
diff --git a/drivers/mailbox/hi6220-mailbox.c b/drivers/mailbox/hi6220-mailbox.c
index fca61f5312d91..cf92523fd30b6 100644
--- a/drivers/mailbox/hi6220-mailbox.c
+++ b/drivers/mailbox/hi6220-mailbox.c
@@ -15,6 +15,7 @@
 #include <linux/kfifo.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 3292fb2dc3bf2..5eef59f00abd5 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -14,7 +14,8 @@
 #include <linux/kernel.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
 #include <linux/slab.h>
diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index 08aa840cccaca..5fde9b9e6fea8 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <linux/mailbox_controller.h>
 #include <soc/microchip/mpfs.h>
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index a00a02b6709c7..0af89103b034a 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/mailbox_client.h>
 #include <linux/mailbox_controller.h>
+#include <linux/of.h>
 
 #include "mailbox.h"
 
diff --git a/drivers/mailbox/mtk-adsp-mailbox.c b/drivers/mailbox/mtk-adsp-mailbox.c
index 182045dd90df9..8bcecddee0eb5 100644
--- a/drivers/mailbox/mtk-adsp-mailbox.c
+++ b/drivers/mailbox/mtk-adsp-mailbox.c
@@ -10,7 +10,8 @@
 #include <linux/kernel.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
 
 struct mtk_adsp_mbox_priv {
diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 3d369c23970cc..1eaab345f4a62 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -15,7 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/mailbox_controller.h>
 #include <linux/mailbox/mtk-cmdq-mailbox.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
 
 #define CMDQ_OP_CODE_MASK		(0xff << CMDQ_OP_CODE_SHIFT)
 #define CMDQ_NUM_CMD(t)			(t->cmd_buf_size / CMDQ_INST_SIZE)
diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
index 098c82d871371..2f8334c1ef5f4 100644
--- a/drivers/mailbox/omap-mailbox.c
+++ b/drivers/mailbox/omap-mailbox.c
@@ -16,7 +16,7 @@
 #include <linux/kfifo.h>
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/omap-mailbox.h>
diff --git a/drivers/mailbox/platform_mhu.c b/drivers/mailbox/platform_mhu.c
index a5922ac0b0bfd..54161303a36b6 100644
--- a/drivers/mailbox/platform_mhu.c
+++ b/drivers/mailbox/platform_mhu.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/mailbox_controller.h>
diff --git a/drivers/mailbox/rockchip-mailbox.c b/drivers/mailbox/rockchip-mailbox.c
index e0e9ba8f89993..99f049f76f0c9 100644
--- a/drivers/mailbox/rockchip-mailbox.c
+++ b/drivers/mailbox/rockchip-mailbox.c
@@ -8,8 +8,8 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/mailbox_controller.h>
+#include <linux/of.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 #define MAILBOX_A2B_INTEN		0x00
diff --git a/drivers/mailbox/sprd-mailbox.c b/drivers/mailbox/sprd-mailbox.c
index 2a43fb375bcb9..109ff60c4ac74 100644
--- a/drivers/mailbox/sprd-mailbox.c
+++ b/drivers/mailbox/sprd-mailbox.c
@@ -11,7 +11,7 @@
 #include <linux/io.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 
diff --git a/drivers/mailbox/stm32-ipcc.c b/drivers/mailbox/stm32-ipcc.c
index 15d538fe2113b..4ad3653f38666 100644
--- a/drivers/mailbox/stm32-ipcc.c
+++ b/drivers/mailbox/stm32-ipcc.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_wakeirq.h>
 
diff --git a/drivers/mailbox/tegra-hsp.c b/drivers/mailbox/tegra-hsp.c
index e12cd1a621554..96d034992aaf3 100644
--- a/drivers/mailbox/tegra-hsp.c
+++ b/drivers/mailbox/tegra-hsp.c
@@ -8,7 +8,6 @@
 #include <linux/io.h>
 #include <linux/mailbox_controller.h>
 #include <linux/of.h>
-#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 6a48b832950db..90f248ef2a1fc 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -16,8 +16,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_device.h>
-#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 
 /* IPI agent ID any */
-- 
2.53.0



