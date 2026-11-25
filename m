Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620410;
	b=HjjHuw//YecFJ9bGjzWv/7YDOza9R+wGbvrYOvELpvvKCvhB+ppZ8YZ0+sMQmYJcYvKZ
	 I6mtyu/624doV9R8HN0mBu4xktabXwXbnfLloxbNU/RW17AGZpmQa57Kp4nHFXi7GIjT1
	 6TbH0kTSuOmDU3z3h8hbZdzuUY2MO51n/ZR4nImq7RH7l9/hSsWi2p+mu5fQhXo7p2CDV
	 d98O2exs4v9DJZ+7sagnTxzWvEeo4ItWfPHdSI8i6edFReNKbsELEm2SEPcSKD2QA8NDR
	 7aHLPg8uV6saM3ZLjCs5pLT99Soz9HdcE2CwvcEY1cq2Xba40tNhRSPu20xKFoH0LMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PmrlH2uyY8Eydl+EztceT2Je55myHr3+AvrpAV3yfqw=;
	b=nmIlfiuHenQ8byoS8uxmCd6uYqbOcC0kjAZylG2yidg6eA8y3duDljNeRado6OzpOy/v
	 oEBXxHfaWTdZovazYTf9s4yJf6ZmhfY9Kgy4iRg1KqRvghvcZRdOlq+8PE+ESRxBQjMtz
	 CbWDJkIYChJHLpEb1Xy+GcYxUqcTzfO4DXzxRZw3j0bbX+O6FMdzEln90pyQxVnOGfymD
	 87dzJjDbTUJ1j9unetfhahFLOyNNJbp8JW/kReemXDO2SUCUk15NibTRGF9lr1j9YIsgy
	 GUpol9C9lOsX25RQnrOc6wyw5Amc3EKT/2GfxVADZtN3TT3OYLM92nB+0kysCPpw5Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVxKRGOV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D628606A323;
	Wed, 25 Nov 2026 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVxKRGOV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED0D1F000C6;
	Wed, 25 Nov 2026 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620409;
	bh=PmrlH2uyY8Eydl+EztceT2Je55myHr3+AvrpAV3yfqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVxKRGOVtdkzzge0tCxaVRODjmdQnC3Fz2Ir/oWs3AOE3Z0vIB1AdAUXx9YXDwSN1
	 1f1nDya/m/R+769/bCFd5+e6pe5GQyN/vmttFzuvY1RXp0OsChnUqw7/sUTsp+oGvr
	 DyfgFRm8G9P1LzcJbsGstAgTcFFZPsPDewEwDFYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Robin Gong <yibin.gong@nxp.com>,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Pan Chuang <panchuang@vivo.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sherry Sun <sherry.sun@nxp.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0908/1005] serial: imx: fix the tty reference of the wakeup event
Date: Wed, 25 Nov 2026 15:37:26 +0100
Message-ID: <20261125143842.964760596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 6d7fbd5a28d092ab61ec0092cf1e085d2bb9ed7e upstream.

To report a wakeup event, imx_uart_enable_wakeup() gets the tty with
tty_port_tty_get() and never puts it: each wakeup by the UART leaks a
reference, and the tty is not freed when it is closed.

Fixes: 0cfadf4bcd28 ("tty: serial: imx: Add missing wakeup event reporting")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Frank Li <Frank.Li@nxp.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Robin Gong <yibin.gong@nxp.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Pan Chuang <panchuang@vivo.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-19-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 986fefb45c63..18892fc4a35b 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2742,8 +2742,14 @@ static void imx_uart_enable_wakeup(struct imx_port *sport, bool on)
 		imx_uart_writel(sport, ucr1, UCR1);
 	}
 
-	if (wake_active && irqd_is_wakeup_set(irq_get_irq_data(sport->port.irq)))
-		pm_wakeup_event(tty_port_tty_get(port)->dev, 0);
+	if (wake_active && irqd_is_wakeup_set(irq_get_irq_data(sport->port.irq))) {
+		struct tty_struct *tty = tty_port_tty_get(port);
+
+		if (tty) {
+			pm_wakeup_event(tty->dev, 0);
+			tty_kref_put(tty);
+		}
+	}
 
 	uart_port_unlock_irq(&sport->port);
 }
-- 
2.56.1



