Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D2B145FE0;
	Thu, 12 Mar 2026 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346538; cv=none; b=plCq+VxPNWdhH2kldgobY+jvcRgirs6fbHGc3Nf/ljm/U4WhxNQSAGE77zE1jdGmUQKSM8iWBxcnrHwazbF3azgeyWC+enWETt0rZ679ZiDolXbgNMsO3q/s/SVb5tnw9qs94LIjsHi2qfjUPfExcHFKNAnKu0O8EzYnRUxoVgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346538; c=relaxed/simple;
	bh=uluP+eu1t80c4kCHSEEqO2KKYD2OYkpczCGY/oQp3+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHRrII11raKNadQijxx7pNneG7m+ahn1a8M+KICw3JNXKlPBCyj1owoJf6ukwuUw7dE/NaIcXQNNTYdq+MCzDDxrOr2MqOvVaYKbvHyYRT314HncGfhK6wwx9OEagh1KU8QXW1g5YkpcOjak0SybfHs/75zIcOZvykDvENvS5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbldtW5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbldtW5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A19C4CEF7;
	Thu, 12 Mar 2026 20:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346538;
	bh=uluP+eu1t80c4kCHSEEqO2KKYD2OYkpczCGY/oQp3+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbldtW5HrC4+cufUMk4hboKIDDrN0Q7jwTBwO2fRTn1xDSIiePY0aDGIteShMLRUM
	 MuozJ+0mPLpmv3NGhTLFR5AFRAYapt4iNDmvj8RhweGTJ7zw0J67Q//qpR9zvg+ClG
	 1g9GgARMwXX0Id/LTJNt8VRmXjZlZ0v5j/Px9SXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/265] mailbox: sort headers alphabetically
Date: Thu, 12 Mar 2026 21:07:34 +0100
Message-ID: <20260312201020.633861570@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit db824c1119fc16556a84cb7a771ca6553b3c3a45 ]

Sorting headers alphabetically helps locating duplicates,
and makes it easier to figure out where to insert new headers.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c          | 14 +++++++-------
 include/linux/mailbox_client.h     |  2 +-
 include/linux/mailbox_controller.h |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 87de408fb068c..c7134ece6d5dd 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -6,18 +6,18 @@
  * Author: Jassi Brar <jassisinghbrar@gmail.com>
  */
 
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/err.h>
-#include <linux/module.h>
 #include <linux/device.h>
-#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
 #include <linux/mailbox_client.h>
 #include <linux/mailbox_controller.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #include "mailbox.h"
 
diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
index 734694912ef74..c6eea9afb943d 100644
--- a/include/linux/mailbox_client.h
+++ b/include/linux/mailbox_client.h
@@ -7,8 +7,8 @@
 #ifndef __MAILBOX_CLIENT_H
 #define __MAILBOX_CLIENT_H
 
-#include <linux/of.h>
 #include <linux/device.h>
+#include <linux/of.h>
 
 struct mbox_chan;
 
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index 6fee33cb52f58..5fb0b65f45a2c 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -3,11 +3,11 @@
 #ifndef __MAILBOX_CONTROLLER_H
 #define __MAILBOX_CONTROLLER_H
 
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
 #include <linux/of.h>
 #include <linux/types.h>
-#include <linux/hrtimer.h>
-#include <linux/device.h>
-#include <linux/completion.h>
 
 struct mbox_chan;
 
-- 
2.51.0



