Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625253;
	b=nbJqxrnzRIplLRCRIgZy47b9/7hITiu3ccraEfOyfhWb1c/RJPHscId+noGRnh6gLDUf
	 vDLzqRXfxrQ1/2hzeHTuGr1CQBUf+CPTyDE+gLeUGBfoF2P+vajsn6BnPeMM74kCVzZNU
	 9VNrEWSkt3oEBpE6OdfY34F3Kkpw9FRf8RGDffAqmsZQOvNxoJimftb3cXtOzM5Zr6HLH
	 GMMsDgUQVcEjReVHvK7c85jgk7eQLpblqPSSjy1rRLGPlf1q9PgIbQeJ8Lc1ZRSSUUnrC
	 3U7EDyATApeG/AuDjzoNazvKDeFF63QPRUNU3Y3J9A4n0eOTxpXYHI4p2kSejjerTEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CaJ43xmxY45yedW3PktRIiCX+84RC6Pl0zPuTCwBg2A=;
	b=Wd3n+miA2xWRLqRA8c3jR8vwSyyGbQ49CA2eFUfGhyjxPTTGoO5jKEqTpjTjaYd/3j56
	 miqTuW42p+1Ppsd7VRzbZfJF1PqsTPi0wfQBCNMCWChyzklt1LrpdXmfeWpSlMwxu2VYV
	 dHpDIPdPO/RKYpPkqqJqo/EWG1WsApWyEy4KtcR2i8ii5PCTCHqmLbTM21hLKGYz7akl1
	 TPEZfPYQSB38sqV/IXXoifoPwq2XBrB7avyoZ9tZ2tKbbZxsE3NRSrrnT7XbJbGQzm1Lx
	 p0RF4+U2iGe0KEWUh4xQ2dDnHRk/lfxJdCKSj7ECiZRJXkPAUDu/Ke6Cv0HFxweFsmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tNgnLmu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE13D606A323;
	Wed, 25 Nov 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tNgnLmu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871881F000D3;
	Wed, 25 Nov 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625253;
	bh=CaJ43xmxY45yedW3PktRIiCX+84RC6Pl0zPuTCwBg2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tNgnLmurvtcqSILO9RvN3OOnD0mwy/J6OTX3lfjlEj/WtYr0WsEo68C2jnEMACUE
	 6NdtbsQKvvf8Y579S0WS3cyMr19WenL4TinCszIdrntYMSpuRB57w5k17xLJOBgFKF
	 cgW9RDHdRSRgfqhiXw1WR7YcZgZiRnhnMqBl06/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 419/816] serial: sh-sci: Unregister UART on sysfs setup failure
Date: Wed, 25 Nov 2026 15:32:47 +0100
Message-ID: <20261125143858.894918186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit c5b33c86d86da3ccff8c05e2a28719e3ec933f70 ]

sci_probe_single() registers the UART port before sci_probe() creates
the RX FIFO tuning attributes. If either device_create_file() call
fails, probe returns an error without removing the port from the serial
core. Device-managed resources are then released while the port remains
registered.

Unregister the UART port before returning either sysfs creation error.
If the second attribute fails, remove the first attribute before
unregistering the port. Keep the existing probe failure policy and leave
the successful initialization path unchanged.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 5d23188a473d ("serial: sh-sci: make RX FIFO parameters tunable via sysfs")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260911031500.5745-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Kept this tree's separate timeout-attribute block and its fifosize>1 cleanup condition, changing only the two error exits to goto the new err_remove_port label. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index ae16800ef7d44..9cf20e81eed41 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3542,7 +3542,7 @@ static int sci_probe(struct platform_device *dev)
 	if (sp->port.fifosize > 1) {
 		ret = device_create_file(&dev->dev, &dev_attr_rx_fifo_trigger);
 		if (ret)
-			return ret;
+			goto err_remove_port;
 	}
 	if (sp->port.type == PORT_SCIFA || sp->port.type == PORT_SCIFB ||
 	    sp->port.type == PORT_HSCIF) {
@@ -3552,7 +3552,7 @@ static int sci_probe(struct platform_device *dev)
 				device_remove_file(&dev->dev,
 						   &dev_attr_rx_fifo_trigger);
 			}
-			return ret;
+			goto err_remove_port;
 		}
 	}
 
@@ -3562,6 +3562,10 @@ static int sci_probe(struct platform_device *dev)
 
 	sci_ports_in_use |= BIT(dev_id);
 	return 0;
+
+err_remove_port:
+	uart_remove_one_port(&sci_uart_driver, &sp->port);
+	return ret;
 }
 
 static void sci_console_save(struct sci_port *s)
-- 
2.53.0



