Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA111BEF9D
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 04:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891166; cv=none; b=LLuH1zhXJLaOLzpLM2sBygLhStIz2eRIlYOWsYlLZ6QiAIfv/Z++puZMsNKyoWaPP/WSH2HvD0RUiW1Uq02Z153ivj1gB74fMCFJV+cObTA8/6oXt+k7mEcisfCObdGpFhcUD8ngxpD+11tljHQbJOEWjmRuQ/K5phqXHk+pmdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891166; c=relaxed/simple;
	bh=4goXdOx9lfRVnaXZlUVvcAhlw3Mb1G0PYn6TF+/Wg/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iOfrCqzgz67IVnQJnWGvAGpQr9ALYght6EzEtVNkAi601jB17Wh67utHcWSxRsfksUX4rmhhSRK/4Iw1i2X3Qs+Y+q2jXdm0u39YA4UULHxa1OfoIERmsyEEWi1mKQ++nlqUcMe8uHNkdIzfv+FKpjJ1v9rTiLJley9VwMHivEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=GrG84HtF; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="GrG84HtF"
Received: from hwang4-ThinkPad-T14s-Gen-2a.. (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 382AB3FB97;
	Wed, 11 Dec 2024 04:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733891163;
	bh=PvngHJdImia0SPIQHxBEG2gJH1U//d+dGI8nrQPy1wg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=GrG84HtFvx64pCSzaClGcO/ZnCJMRVfhFSwHLVaeaMfUikJaVEJhz9RJOq5YtXoR1
	 b1X0VuUKJBZjuTXjSHA7ruykxgOonS5wq3GbaN+MvCQxr9lidFWGw53GOha0PCSYWB
	 8pJfpSkVpV1eJHsU8aeqvEifigbyZNYQwbCn9joUBi1UmgoegKBr90aYO0LS54zs0L
	 JE0HywXFZE4m+0/CFvNT4fEg12zPFVmBeyKRS4zKIBwj5y5maMx5K0JbQrx2TYMk9L
	 /dSlBkXKQC7SGIrVC6EwJRLcvmvl1ByOkAFfkTO2t5V2LnFYMmBLFFwnib1AsVWpTY
	 wTfEsMMLj+OVA==
From: Hui Wang <hui.wang@canonical.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: hvilleneuve@dimonoff.com,
	hui.wang@canonical.com
Subject: [stable-kernel][5.15.y][PATCH 4/5] serial: sc16is7xx: remove unused line structure member
Date: Wed, 11 Dec 2024 12:25:43 +0800
Message-Id: <20241211042545.202482-5-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241211042545.202482-1-hui.wang@canonical.com>
References: <20241211042545.202482-1-hui.wang@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 41a308cbedb2a68a6831f0f2e992e296c4b8aff0 upstream.

Now that the driver has been converted to use one regmap per port, the line
structure member is no longer used, so remove it.

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-4-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/tty/serial/sc16is7xx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 90b39ddec082..a2d05dd5a339 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -313,7 +313,6 @@ struct sc16is7xx_one_config {
 
 struct sc16is7xx_one {
 	struct uart_port		port;
-	u8				line;
 	struct regmap			*regmap;
 	struct kthread_work		tx_work;
 	struct kthread_work		reg_work;
@@ -1278,7 +1277,6 @@ static int sc16is7xx_probe(struct device *dev,
 		     SC16IS7XX_IOCONTROL_SRESET_BIT);
 
 	for (i = 0; i < devtype->nr_uart; ++i) {
-		s->p[i].line		= i;
 		/* Initialize port data */
 		s->p[i].port.dev	= dev;
 		s->p[i].port.irq	= irq;
-- 
2.34.1

