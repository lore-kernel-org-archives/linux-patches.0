Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1F372223;
	Mon, 29 Jan 2024 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548503; cv=none; b=XP63C2uaDRm7PuvwxMp0iVCFnjKOy8hMOtrPD5Ouc3zJ1kSq7nB+5k88kBn5dJXIPAgQuikY7+CyzdH+bImEFMwru1ioFbseSWoHuf7FpYPhDgV/v9QxX1VnFNlEBxzR3jGdfWhITy9QedJDqM8b5ytcAzh9zM2JHb4xryJ4imA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548503; c=relaxed/simple;
	bh=b+K6aWXo7dKfxVh1bFcP5alfIAnKxrB/b2UmIJBqFdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWH/8jkW84NhOGrmwDH73zPcebasJcl6rgiuQ5doa8JNkALGNaoge6quPOfu81rx70LveiC1Phm/S6OYdbrzhFbXuOpNwQyIRQOXGzIie+8e2GkoLROwcQL4YGdmWVQalqFhrWWCyr1cZCE0Bu1i6qg3UxxooZQcTNydB8BUA5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=md1wDA8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="md1wDA8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73884C433C7;
	Mon, 29 Jan 2024 17:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548503;
	bh=b+K6aWXo7dKfxVh1bFcP5alfIAnKxrB/b2UmIJBqFdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=md1wDA8rIkbQEGxjKZpHkg7edy/SrEKScSOLMClF1TqNtDR2JVvpYc6EZpjcdo7EH
	 Yx5FSpIW4u8loVBJyYrm+FsQmfqmCn/iyh1UZW+zk2XLlqR4/LkyXMO93i1ley8Z/m
	 auv1T44JHt3ZGq9MUzgIHvfJ4iEwbQYazvEN84DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 131/331] serial: sc16is7xx: remove unused line structure member
Date: Mon, 29 Jan 2024 09:03:15 -0800
Message-ID: <20240129170018.781589516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

commit 41a308cbedb2a68a6831f0f2e992e296c4b8aff0 upstream.

Now that the driver has been converted to use one regmap per port, the line
structure member is no longer used, so remove it.

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-4-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -323,7 +323,6 @@ struct sc16is7xx_one_config {
 
 struct sc16is7xx_one {
 	struct uart_port		port;
-	u8				line;
 	struct regmap			*regmap;
 	struct kthread_work		tx_work;
 	struct kthread_work		reg_work;
@@ -1531,7 +1530,6 @@ static int sc16is7xx_probe(struct device
 		     SC16IS7XX_IOCONTROL_SRESET_BIT);
 
 	for (i = 0; i < devtype->nr_uart; ++i) {
-		s->p[i].line		= i;
 		/* Initialize port data */
 		s->p[i].port.dev	= dev;
 		s->p[i].port.irq	= irq;


