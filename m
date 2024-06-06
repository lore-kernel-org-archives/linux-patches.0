Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B1D196C89;
	Thu,  6 Jun 2024 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683477; cv=none; b=fFBMiqDxAga4vefsr0k7paoGUAcOALWqLSLbsJXP0KdOqQ7W7YZakP/JR4ducU1ognT8Z/SQRVOtQ/XInkOlQfAWeIYK/i1OYNN8NBMAY2BUbwo5Miy0r3gWnZZWtkLqDA+LNJVeluHpxQ9TdP88/BlRm8hxpOJ54s+RqnjhjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683477; c=relaxed/simple;
	bh=3tzdrC2t8L2f5YtAs2yFO5CSVm1i1TEXFBD2ApwzVew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxmKOI2hAXK9QEgfgIXR5TOQ+jtcqeYJAxh5YyyG6na4BgZPo1x9Az/FNYRHhwAihCqPEu3TlG6lOv6p/cgE/UYO1RDs7z8NUvCFbq4+pEmcQUrRfRNdZ8kz2WjW1yJhghQpBYSE9+0RTTBYuO9qf60ynI3ktStcaXKx3KO9RJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o28CiG56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o28CiG56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75067C2BD10;
	Thu,  6 Jun 2024 14:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683477;
	bh=3tzdrC2t8L2f5YtAs2yFO5CSVm1i1TEXFBD2ApwzVew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o28CiG56QjdN0100cDkq1D0YPytg5mZ8E+HZI5nhwuGigvbe6R8vOUpFA6XRgw7LY
	 /Yo6WBtSSd9yTtJnn9BXoK0Rz3KKPJXLJ4CngZOJ11wU/9hvyw6+R9JFBIVHkShL7g
	 7enUdK86rKLWm5zPlmfj/A5p2fRZs1hI0xMj+wXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 420/744] serial: sc16is7xx: add proper sched.h include for sched_set_fifo()
Date: Thu,  6 Jun 2024 16:01:32 +0200
Message-ID: <20240606131745.948717652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 2a8e4ab0c93fad30769479f86849e22d63cd0e12 ]

Replace incorrect include with the proper one for sched_set_fifo()
declaration.

Fixes: 28d2f209cd16 ("sched,serial: Convert to sched_set_fifo()")
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240409154253.3043822-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index f75b8bceb8ca2..89eea1b8070fb 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
+#include <linux/sched.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/tty.h>
@@ -25,7 +26,6 @@
 #include <linux/spi/spi.h>
 #include <linux/uaccess.h>
 #include <linux/units.h>
-#include <uapi/linux/sched/types.h>
 
 #define SC16IS7XX_NAME			"sc16is7xx"
 #define SC16IS7XX_MAX_DEVS		8
-- 
2.43.0



