Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB11947A6C;
	Tue, 14 May 2024 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686558; cv=none; b=RA8xASS/2qc98Z704wFupt0dFNLpIsMK+ZYGsv6HRx0UUM4oyDEuYTf0czP3iFrVkfcfhslTbvEUSgS4yhpfV0fmre+mTEDpUpPrt2UDNwquz9PEq34i6IQwXaDRSYAVL4Xi1z3GmlPKn9sr73G7mmE+WqYGmnvQ3mwJR2OUXOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686558; c=relaxed/simple;
	bh=+4QpH/XNRV7BsrJUrJRBucMlRO8pGMkz3iqyE3MasbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrqvMK2KhZw7hGogfecgEGA+TzjXfgJJAOWg+uUZJ4+AOnSgwqdMxkZ6vy8dWtFU0v4Qv8wAgX2e0Moqsrf9j0Rg1btX9gI+78p6gZyunX1i5AAXc3ECoiwxAngYU1aP4qiWxfOo3k+zu1hishfnwceiRQceXml9MtGs0+GykjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yR57JrIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yR57JrIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334B3C2BD10;
	Tue, 14 May 2024 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686558;
	bh=+4QpH/XNRV7BsrJUrJRBucMlRO8pGMkz3iqyE3MasbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yR57JrIJRDtM50dKc7zjFocVVOFVFWdB3hWWfqcbviNH9vXF9OPU7u0wK1B/FJS8G
	 aVC/zxIuAT2IsD2C/mGGnU6UQrdLdBhWklYMzRmXubkoHwBRCK6wf09wekuzp0/b6P
	 IAmraerVI5QSAhXwMWKGYxXRS8yV1E8vPZViAdKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Kent Gibson <warthog618@gmail.com>
Subject: [PATCH 6.1 178/236] gpiolib: cdev: Add missing header(s)
Date: Tue, 14 May 2024 12:19:00 +0200
Message-ID: <20240514101027.118795111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 52ee7c02f67808afa533c523fa3e4b66c54ea758 ]

Do not imply that some of the generic headers may be always included.
Instead, include explicitly what we are direct user of.

While at it, sort headers alphabetically.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Rewiewed-by: Kent Gibson <warthog618@gmail.com>
Stable-dep-of: ee0166b637a5 ("gpiolib: cdev: fix uninitialised kfifo")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index e40c93f0960b4..d2027212901fd 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -12,6 +12,7 @@
 #include <linux/file.h>
 #include <linux/gpio.h>
 #include <linux/gpio/driver.h>
+#include <linux/hte.h>
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
 #include <linux/kernel.h>
@@ -20,11 +21,12 @@
 #include <linux/mutex.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/poll.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/timekeeping.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
-#include <linux/hte.h>
+
 #include <uapi/linux/gpio.h>
 
 #include "gpiolib.h"
-- 
2.43.0



