Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434523064B9;
	Tue, 30 Sep 2025 15:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245498; cv=none; b=uFXsxbFmkB/I16dY7Qzycj24v4X9xKzI704kxRG400T0RbVhz7tLhgUC+68KSxLLsHQh+mc3QxqCZkIL9DdYrWmCXlNtzCvpJwe65O73dMy4OE1AvaIwhBsNKzv2izbVLJN/0Xmzs/24RAtiYmgz1IUJslmlViLid37ClLYWkzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245498; c=relaxed/simple;
	bh=JY4DDcqzxSdRQ1oyw4cm0jqPwKWie/ei3c5EmNOtlx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHCO/gVjYWrpJ8KWJknZwX70Co+e0eLYgkdXYDd9J1itoiuLhw5Zg8pUSBPyXYXAi9yudmjGtfywpjmOVs/9hFCCr9JN1cdXP/ohndyc0JouwctkS4mImpzhZsJwRmlsV3y/DRZemHKFaSY25cW73Qa0sPnj195cQXc5Xd+QY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfB30+Z1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfB30+Z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8484C4CEF0;
	Tue, 30 Sep 2025 15:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245498;
	bh=JY4DDcqzxSdRQ1oyw4cm0jqPwKWie/ei3c5EmNOtlx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfB30+Z11VMTHW9Ls2gQB4EGRMI0mm260nlRhNO6dq89x4iCnLvMxzgariJEH5Q5A
	 5bM2h5ml7h/wtmGuL6JjrVkakrNzhxFKZEOYWatEoluaNu/fn8JIzauc28YPqmr74g
	 NOWdZ2/fGoxC3SelvHd2U0qsnXu83jcAI/jkkn4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/73] can: etas_es58x: sort the includes by alphabetic order
Date: Tue, 30 Sep 2025 16:47:32 +0200
Message-ID: <20250930143821.747148906@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 8fd9323ef7210b90d1d209dd4f0d65a8411b60e1 ]

Follow the best practices, reorder the includes.

While doing so, bump up copyright year of each modified files.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221126160525.87036-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 38c0abad45b1 ("can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es581_4.c    | 4 ++--
 drivers/net/can/usb/etas_es58x/es58x_core.c | 6 +++---
 drivers/net/can/usb/etas_es58x/es58x_core.h | 8 ++++----
 drivers/net/can/usb/etas_es58x/es58x_fd.c   | 4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
index 1bcdcece5ec72..4151b18fd045d 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.c
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -6,12 +6,12 @@
  *
  * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
  * Copyright (c) 2020 ETAS K.K.. All rights reserved.
- * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ * Copyright (c) 2020-2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
+#include <asm/unaligned.h>
 #include <linux/kernel.h>
 #include <linux/units.h>
-#include <asm/unaligned.h>
 
 #include "es58x_core.h"
 #include "es581_4.h"
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index ddb7c5735c9ac..5aba168496037 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -7,15 +7,15 @@
  *
  * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
  * Copyright (c) 2020 ETAS K.K.. All rights reserved.
- * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ * Copyright (c) 2020-2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
+#include <asm/unaligned.h>
+#include <linux/crc16.h>
 #include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
-#include <linux/crc16.h>
-#include <asm/unaligned.h>
 
 #include "es58x_core.h"
 
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 640fe0a1df636..4a082fd69e6ff 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -6,17 +6,17 @@
  *
  * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
  * Copyright (c) 2020 ETAS K.K.. All rights reserved.
- * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ * Copyright (c) 2020-2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
 #ifndef __ES58X_COMMON_H__
 #define __ES58X_COMMON_H__
 
-#include <linux/types.h>
-#include <linux/usb.h>
-#include <linux/netdevice.h>
 #include <linux/can.h>
 #include <linux/can/dev.h>
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <linux/usb.h>
 
 #include "es581_4.h"
 #include "es58x_fd.h"
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index c97ffa71fd758..fa87b0b78e3eb 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -8,12 +8,12 @@
  *
  * Copyright (c) 2019 Robert Bosch Engineering and Business Solutions. All rights reserved.
  * Copyright (c) 2020 ETAS K.K.. All rights reserved.
- * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ * Copyright (c) 2020-2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
+#include <asm/unaligned.h>
 #include <linux/kernel.h>
 #include <linux/units.h>
-#include <asm/unaligned.h>
 
 #include "es58x_core.h"
 #include "es58x_fd.h"
-- 
2.51.0



