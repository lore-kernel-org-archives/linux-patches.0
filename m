Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276AD1B29CC;
	Thu,  6 Jun 2024 14:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683412; cv=none; b=fK38ly82CJKbIsrskig0dX3rE1VKlDHB3i7msgGEsy1exR6ro/Z4jRX/SrsYTrPsRd7rzyPJN2E+EehEJPg2JfEk9H5eddrz+xIhc36FzdC/QqVyQL5+Xl1Sxekv7UQNCKtMFIUC7CwLTAEg5jYkqU6WBd7JxVLEbe39aIRd1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683412; c=relaxed/simple;
	bh=BKF3hUnxhUXsrCSDPxLyVt+G290bYVtyz26U3yME+4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7VR6NSHLwWaCbbJ7BaL5VhbT3eclWEF3o5B4cT/+5k2TBnOwyRacWXVFDiLRwDfsfaM105Yst2zp8K+8wVCnYog7c2/3ee+NAsBvUjBfIUozdi2r8h5TlEz9J7CYp2TmLt5d+yJoTer9mv6TLPPUyjrMTl+Da2Cii3+zx89kdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LoPVlhvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LoPVlhvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083CBC32781;
	Thu,  6 Jun 2024 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683412;
	bh=BKF3hUnxhUXsrCSDPxLyVt+G290bYVtyz26U3yME+4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoPVlhvBZKtqJ5ey8Gg9205Ay/+2O6B9ZvQPlVyY/VTWwKJuUkYi+RJ4mtLgyrFbS
	 Wb2pQbp6cWrFnRJ/SI0KCes4joHpnT3Ct0L02GatOhgv3juijVYuY/q81onUvLQPIM
	 +QOPOIYjlg+Fbb7ql4/dwX8AIzXlGTCeOI4xdzKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 295/473] serial: sc16is7xx: add proper sched.h include for sched_set_fifo()
Date: Thu,  6 Jun 2024 16:03:44 +0200
Message-ID: <20240606131709.649256186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index e331b57d6d7d3..e6eedebf67765 100644
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



