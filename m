Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC69A266B65;
	Tue, 30 Sep 2025 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245274; cv=none; b=RhZCHFUC8rqFzVIUe8RIxFdQ0fsQIvqG+sHzNBxdaAag/vEVmS3t4h7FdG1u7iqFonykNYbQCr/O1zk7YgfRYlvmesLBkWmGSqr/4ZrvkvWTj+C/FN4JN2qRBj1P6L2GfmtELg+TE0qkWgIygiLjHyQwDKNy7T3O82xwZVQNvkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245274; c=relaxed/simple;
	bh=7BDHcUxAypu65CO94tEr6pK+iohPIhO4ps/OkOP05U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9muWHqnIMmkalEfr23sD+1S3Vx4TFGUDyHicSmj41h3eDnUFJp1k2UpSR4kKEUVctIMPTQN8FpSbG2Kuw+E9YA+cFsR8w8bPHYpViz3OQX9W4M/Ve5W3ZAs/6N98X7jcXyrg6hTa7JXwZuBY9m38SK/Ot1kZ7AboGJAPJPuKkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B76UCcF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B76UCcF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53737C4CEF0;
	Tue, 30 Sep 2025 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245274;
	bh=7BDHcUxAypu65CO94tEr6pK+iohPIhO4ps/OkOP05U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B76UCcF2x+Unx0/9iNBVZ4FelWprT4sFd6eQwfzFwJs7EGF7uCIMcPgeqmqdghyuf
	 8+v7JE4wx/XMou+Xj6lLF2jYbLBKZf7toaOi3Kn/pxTieOGhXL5L7vOyinNuyw8V0E
	 ioomSFx5RB3tIV5CwSGNsrpI786jnFaheXw9w5D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/151] can: bittiming: replace CAN units with the generic ones from linux/units.h
Date: Tue, 30 Sep 2025 16:47:28 +0200
Message-ID: <20250930143832.308538453@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 330c6d3bfa268794bf692165d0f781f1c2d4d83e ]

In [1], we introduced a set of units in linux/can/bittiming.h. Since
then, generic SI prefixes were added to linux/units.h in [2]. Those
new prefixes can perfectly replace CAN specific ones.

This patch replaces all occurrences of the CAN units with their
corresponding prefix (from linux/units) and the unit (as a comment)
according to below table.

 CAN units	SI metric prefix (from linux/units) + unit (as a comment)
 ------------------------------------------------------------------------
 CAN_KBPS	KILO /* BPS */
 CAN_MBPS	MEGA /* BPS */
 CAM_MHZ	MEGA /* Hz */

The definition are then removed from linux/can/bittiming.h

[1] commit 1d7750760b70 ("can: bittiming: add CAN_KBPS, CAN_MBPS and
CAN_MHZ macros")

[2] commit 26471d4a6cf8 ("units: Add SI metric prefix definitions")

Link: https://lore.kernel.org/all/20211124014536.782550-1-mailhol.vincent@wanadoo.fr
Suggested-by: Jimmy Assarsson <extja@kvaser.com>
Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 38c0abad45b1 ("can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/bittiming.c           | 5 +++--
 drivers/net/can/usb/etas_es58x/es581_4.c  | 5 +++--
 drivers/net/can/usb/etas_es58x/es58x_fd.c | 5 +++--
 include/linux/can/bittiming.h             | 7 -------
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 9dda44c0ae9df..45f8baa56fd39 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
  */
 
+#include <linux/units.h>
 #include <linux/can/dev.h>
 
 #ifdef CONFIG_CAN_CALC_BITTIMING
@@ -81,9 +82,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	if (bt->sample_point) {
 		sample_point_nominal = bt->sample_point;
 	} else {
-		if (bt->bitrate > 800 * CAN_KBPS)
+		if (bt->bitrate > 800 * KILO /* BPS */)
 			sample_point_nominal = 750;
-		else if (bt->bitrate > 500 * CAN_KBPS)
+		else if (bt->bitrate > 500 * KILO /* BPS */)
 			sample_point_nominal = 800;
 		else
 			sample_point_nominal = 875;
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
index 14e360c9f2c9a..1bcdcece5ec72 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.c
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/units.h>
 #include <asm/unaligned.h>
 
 #include "es58x_core.h"
@@ -469,8 +470,8 @@ const struct es58x_parameters es581_4_param = {
 	.bittiming_const = &es581_4_bittiming_const,
 	.data_bittiming_const = NULL,
 	.tdc_const = NULL,
-	.bitrate_max = 1 * CAN_MBPS,
-	.clock = {.freq = 50 * CAN_MHZ},
+	.bitrate_max = 1 * MEGA /* BPS */,
+	.clock = {.freq = 50 * MEGA /* Hz */},
 	.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC,
 	.tx_start_of_frame = 0xAFAF,
 	.rx_start_of_frame = 0xFAFA,
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index b71d1530638b7..8ccda748fd084 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/units.h>
 #include <asm/unaligned.h>
 
 #include "es58x_core.h"
@@ -521,8 +522,8 @@ const struct es58x_parameters es58x_fd_param = {
 	 * Mbps work in an optimal environment but are not recommended
 	 * for production environment.
 	 */
-	.bitrate_max = 8 * CAN_MBPS,
-	.clock = {.freq = 80 * CAN_MHZ},
+	.bitrate_max = 8 * MEGA /* BPS */,
+	.clock = {.freq = 80 * MEGA /* Hz */},
 	.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY |
 	    CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
 	    CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_TDC_AUTO,
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 9e20260611ccb..9d7c902da245e 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -12,13 +12,6 @@
 #define CAN_SYNC_SEG 1
 
 
-/* Kilobits and Megabits per second */
-#define CAN_KBPS 1000UL
-#define CAN_MBPS 1000000UL
-
-/* Megahertz */
-#define CAN_MHZ 1000000UL
-
 #define CAN_CTRLMODE_TDC_MASK					\
 	(CAN_CTRLMODE_TDC_AUTO | CAN_CTRLMODE_TDC_MANUAL)
 
-- 
2.51.0



