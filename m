Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB92E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E0FC433D2;
	Wed, 28 Dec 2022 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239200;
	bh=yruAiydkoe2rm6p5nOjFrbK3Grz8jYDgSc9KqQIyRWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gy0+9V+gOw+wYd7ZTg7xPN/HyZhjaRdSshJgHfOXzjm7H4iUMXoOBT4mRxtH7TGtH
	 teUjy38ubzTyTWxm42Cl2xhEvDEQUjb/HTOFi3VS/DONpJ3nZZTsaPdKgzC6aki7rK
	 +bdjmD7kUWhGMWtA6PmIPgUQmG0mNuVttunagKBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/731] can: kvaser_usb: make use of units.h in assignment of frequency
Date: Wed, 28 Dec 2022 15:34:33 +0100
Message-Id: <20221228144301.373109056@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit b8f91799687eeb6ffe73b66420db46d8c0292295 ]

Use the MEGA define plus the comment /* Hz */ when assigning
frequencies.

Link: https://lore.kernel.org/all/20211210075803.343841-1-mkl@pengutronix.de
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 8d21f5927ae6 ("can: kvaser_usb_leaf: Fix improved state not being reported")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 7 ++++---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 9 +++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 215f2b48db24..b485f0bc2e6b 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/units.h>
 #include <linux/usb.h>
 
 #include <linux/can.h>
@@ -2049,7 +2050,7 @@ const struct kvaser_usb_dev_ops kvaser_usb_hydra_dev_ops = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_kcan = {
 	.clock = {
-		.freq = 80000000,
+		.freq = 80 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 80,
 	.bittiming_const = &kvaser_usb_hydra_kcan_bittiming_c,
@@ -2058,7 +2059,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_kcan = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 	.clock = {
-		.freq = 24000000,
+		.freq = 24 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
@@ -2066,7 +2067,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_rt = {
 	.clock = {
-		.freq = 80000000,
+		.freq = 80 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 24,
 	.bittiming_const = &kvaser_usb_hydra_rt_bittiming_c,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index a653318f583a..6d64d566873d 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -19,6 +19,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/units.h>
 #include <linux/usb.h>
 
 #include <linux/can.h>
@@ -446,7 +447,7 @@ static const struct can_bittiming_const kvaser_usb_leaf_m32c_bittiming_const = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_usbcan_dev_cfg = {
 	.clock = {
-		.freq = 8000000,
+		.freq = 8 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_leaf_m16c_bittiming_const,
@@ -454,7 +455,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_usbcan_dev_cfg = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_m32c_dev_cfg = {
 	.clock = {
-		.freq = 16000000,
+		.freq = 16 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_leaf_m32c_bittiming_const,
@@ -470,7 +471,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_16mhz = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_24mhz = {
 	.clock = {
-		.freq = 24000000,
+		.freq = 24 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
@@ -478,7 +479,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_24mhz = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.clock = {
-		.freq = 32000000,
+		.freq = 32 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
-- 
2.35.1



