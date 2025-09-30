Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00A31F4C8E;
	Tue, 30 Sep 2025 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245340; cv=none; b=IdgqAwerQdqdfvyIu9hv0beTt07J9ngNQ03iHgyZPwKMmwElnV5KACWhX3Rx8EVmtwhzaIL+MzYBDw/JphOSLQQTMklNCbmgdixH22IrwJkcSdA613MAvBrdoonGAIEg02TnPY357cyovH+EGBpZYxX6daaofr7y53AkTr5lUds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245340; c=relaxed/simple;
	bh=ROPy0QOwiieVW4qkgQSkAop0VxBpjxIlT57yz97/Ou8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIfO/6vWW5ozLoVmbi9GjQKTLdeVqsvLKI2yp2A+d0bbI6753nDXDvsjVTs7GQWD9P2NLhwZ6yqD2tiRzgr3y25t/V6hViI/P93GEts3IzTVxW83QxsoF1ncA6ufpsVjiUMsYPnopVmeiB+Y8Yyg+mBVXjeToklcIW+9CeMkJ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tn1BGW7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tn1BGW7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F4EC4CEF0;
	Tue, 30 Sep 2025 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245340;
	bh=ROPy0QOwiieVW4qkgQSkAop0VxBpjxIlT57yz97/Ou8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tn1BGW7KywUpa9AMVrdnONEaNp/P7tcaR7yuRrVygSMnj/xgtJ5WejsPwbmWV+D7E
	 IGpug4f88Ag3sjwZFiuaMPYEPyo8MrkfVMtmRAoOybWp/pgl+vjTpbn79InkhaoV6d
	 aAmaqR8fDJg6tQF3nANUWQiBplpwEvmro3hxYzhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/151] can: etas_es58x: sort the includes by alphabetic order
Date: Tue, 30 Sep 2025 16:47:32 +0200
Message-ID: <20250930143832.467539887@linuxfoundation.org>
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
index 0c0e2363f674b..b6ee532977734 100644
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
index e5033cb5e6959..3d4fd068c8faf 100644
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
index 8ccda748fd084..3693851b36008 100644
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



