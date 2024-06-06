Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509CA196C85;
	Thu,  6 Jun 2024 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682906; cv=none; b=XOBVItL0NdxNi62feqxlGl2846JL9eKa8CKNyNpyb//GtNMtY1+1OHy+OHce6yoRIOMrQYwb5U8azBEPwtUgrRovghfpI8fkzVdC1r6I7q5Rk+bqzy/r0DTE8/ryGlTiqLdy5OmY/BOuIIUxUJK0G8fFnhtfKjCDAWVBw19lHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682906; c=relaxed/simple;
	bh=jmCtsH7DTIjuk6UaSe0tfzrLof2aKEZyNZccUjWdsSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sguz2afOwbgkisCA7C92R6XI6pDvYZZ4i2dZLqnYk+xkW7EVoMvEfKq7lsIn5fQFjqL+UN9IyUJ8+PldMyzWYzhNP6iw3yd/KGRpjT92aCTztvotK4av8EwPvGNIP27UI2pQpPRa1UuBfdhqKFv9cLZagbfBhX20CWe8qGo81s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gUoU8x1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gUoU8x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB40C4AF07;
	Thu,  6 Jun 2024 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682906;
	bh=jmCtsH7DTIjuk6UaSe0tfzrLof2aKEZyNZccUjWdsSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gUoU8x1oPqfGXj+/LSvzC7wFyxoGkbubH1koWdewbqTTbpxnhEw++g2g4FKixtZO
	 uVnViEuieePdFs11tFcdaj/qajZm0auz/naA4tvRxggAdvhaS7VScj7GORRCf9Rjc8
	 0ll35iznd92J9Pqquuj89CQYlqNEEsBu39lRTgAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 030/374] serial: sc16is7xx: add proper sched.h include for sched_set_fifo()
Date: Thu,  6 Jun 2024 16:00:09 +0200
Message-ID: <20240606131652.834458076@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 12915fffac279..ace2c4b333acc 100644
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



