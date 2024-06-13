Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9BEEC4;
	Thu, 13 Jun 2024 12:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282182; cv=none; b=Ai6ADgDRqD6xnF33goPVS//TlR1Sxn0SoXHYAZwYMIUA3/RC2FmqGwguBLeguwqJ87ZwS/nhM7QdKTTS0infzag5gO+6v3pK8YhHzwYSpA6He1BShVfZsEx7edmPnC3SvfTVyVapY3oyQUiczEfI0VSDXj69gYUis68AK64o73U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282182; c=relaxed/simple;
	bh=KBb9RyTiMVF9UTa4rowfn7TyQd/UaunCsuv++l7uKTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6LJW9o63TuceG0jZaySt/W07QaWvARx8HoPqOXpJL1aJZMU54/0NlajtovLZFJG3EuhYOITL+rNgY16kBW3ZvVvEWVfPXlBXyY0okHtFC/dm8divSnqXUuL2AIskr5ScRy/2Z08cgsVIyo8cbyMGXAOphNT7+pToY8+MAREQPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPLo1KUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPLo1KUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26E2C2BBFC;
	Thu, 13 Jun 2024 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282182;
	bh=KBb9RyTiMVF9UTa4rowfn7TyQd/UaunCsuv++l7uKTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPLo1KUjdFA8dWZS8ecgKvDTg5R1n0kKawNCNdCC/UWsG85E5zmaRHr1pCI3GlQTr
	 wEJUGm5MqFudkUCdldULaKAp3Qq9yafB+0vGJyrMfM35akUOFQJMtlMfNBOYDIIhjG
	 ag47iH/LRVXbzZXxdh5gMcviJvZxhEOtlOTouoYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/402] serial: sc16is7xx: add proper sched.h include for sched_set_fifo()
Date: Thu, 13 Jun 2024 13:32:28 +0200
Message-ID: <20240613113309.594590355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0066a0e235164..35f8675db1d89 100644
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



