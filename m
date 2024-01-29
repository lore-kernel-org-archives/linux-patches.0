Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B9515B964;
	Mon, 29 Jan 2024 17:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548272; cv=none; b=LQvh0aM8V4S2wwQb3PhHbvEayqilE+HPfa/Po8lZEpUIF/9hMJhAdzUpJ/GYsoqckO3MZHSiOA9oHzqdZ6ME1x2QlLeH5grw2ajQMHGUtOKLYXEryQprU/P7aFeo2j1eCr/4JlJFiDw/STMaWq9VcpL25mHJoM7qkJEXMPdDz8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548272; c=relaxed/simple;
	bh=pstOJ4OusnQlHBeEChUGVBngSfsQdA8jqaoA9wPTvA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=supl/VrxcRZHXkpO4Ev8D+gQcHHbg/GabiBcW6KckeRIyXfNs0dQlQQIYpouPyebMR1uzEYWFEndVM9IPVHuhzP7aW1h962N25SDsKn13Ch/rzeZep+RJgt15sDXsQriRAB083SoGQbWaGyOu+8+Mlgx+DJevfGyMWVBnjZhdUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwcW5F6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwcW5F6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE77C433C7;
	Mon, 29 Jan 2024 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548271;
	bh=pstOJ4OusnQlHBeEChUGVBngSfsQdA8jqaoA9wPTvA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwcW5F6rVbItKBFup1dfCM2jW4rgyEu4exrUOhpGb9LqOQPNWs6oybynFUVtLGj35
	 +28SLZZYgyzrU+h3quhnBwgmBl5v6sFqbENjeiqqEfZIjRHTTL5DK/NxhVUnZjmSyI
	 A2RV20BMomyjha22nGGAmrEmx6GZOsFB94hKQkqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 061/185] serial: sc16is7xx: remove unused line structure member
Date: Mon, 29 Jan 2024 09:04:21 -0800
Message-ID: <20240129170000.561727484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
@@ -1533,7 +1532,6 @@ static int sc16is7xx_probe(struct device
 		     SC16IS7XX_IOCONTROL_SRESET_BIT);
 
 	for (i = 0; i < devtype->nr_uart; ++i) {
-		s->p[i].line		= i;
 		/* Initialize port data */
 		s->p[i].port.dev	= dev;
 		s->p[i].port.irq	= irq;


