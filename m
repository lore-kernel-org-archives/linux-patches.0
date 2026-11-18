Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024254;
	b=B2kerRKNf7RqtsZbQ4FqP97rixthImCotf3kA9UY5ED9+Q492RccnrJNG2O1bnXUBzww
	 wxLLAK/qEkCUxGVp3y4V17VnYH/knXMZyrKRtYs9UgzEFrK0d5p4AurYsMHos79Cw8M+4
	 e/o9VlNiPxR2+jdHNe/Y4Y2vkB6vZtNeda88iKnSzK75LXduYStqT6zfaNL3YD9uTRLXs
	 E8DN3r2fsrq61iOC9CcDSLrCOAz+8qYPG1CMe/qfO8VNcaKKATd1wHQxtZUVrC8yg+xFG
	 gJpWZJdL7C8foxQ+oZwFOXeKXzac+WmIiWOjszuWCCMr+r5aJdTeO+HWfneY0bWGg3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2HgbchdjctYgPtOYjmE7RTfVUMw1jlDN1EpFpk89R9w=;
	b=4MxI8YWvZ76S2p/ZlrKlx76n1Y17zjzDJ0UYjAxkjgF0U+ytCXIwAj4gg1dvOx/kGMbW
	 IhiYOi6YzIFkdcWJq/WFeI/oTQLtEIaNPZ/tCsyEFiLp2E929JyPZM5Yd7DxJjIKaXeC1
	 OIxzwaz0ulY1M54yDh8turR3MB4y6MzNeU2bsPm3/JWYTHpJXarFvbRicSDOZnYO0NfmB
	 rnIVuNdWEKg47Tqvf0WCLIb7vy2i3+nSElCxqyYoEslJjS0wJrCm/kgnVaIamAQMKGfMI
	 3Wlpuy8xVFhxY3LD7XVGbldJOl85nuCbhrcBftv8AthdnhIZ1MzUA1gU+DiqxxY3f3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b4/wG2qk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D74D60A260B;
	Wed, 18 Nov 2026 17:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4/wG2qk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AF51F000CD;
	Wed, 18 Nov 2026 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024254;
	bh=2HgbchdjctYgPtOYjmE7RTfVUMw1jlDN1EpFpk89R9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4/wG2qk+uAudYQeb/lQM5bIWfQENhUgVw40kOaXyoL+Ax5GINFdOrMoKxYBhBQjj
	 kEOenBs7FCwmGOb9+aaHgKc2IxsRWMiejc9vj7HJF8otdE/uvM+XOUD0Nnyo89WNEx
	 rKKh1V1K1h5VQ9j3AaQWyJEoBqLuzJn0n4/Gy22U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0661/2151] serial: sh-sci: Drop checking port type for device file{create, remove}
Date: Wed, 18 Nov 2026 15:39:56 +0100
Message-ID: <20261118150145.919234693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 42f7303c5f668403f06d9b938d3de2bda3736530 ]

Ports that support FIFO has fifosize > 1. Replace checking the port type
with fifosize for device file{create, remove}.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20251129164325.209213-5-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c5b33c86d86d ("serial: sh-sci: Unregister UART on sysfs setup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index a64a26fb7ff86..96f70581d6ecf 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3375,16 +3375,14 @@ static struct uart_driver sci_uart_driver = {
 static void sci_remove(struct platform_device *dev)
 {
 	struct sci_port *s = platform_get_drvdata(dev);
-	unsigned int type = s->type;	/* uart_remove_... clears it */
 
 	sci_ports_in_use &= ~BIT(s->port.line);
 	uart_remove_one_port(&sci_uart_driver, &s->port);
 
-	if (s->port.fifosize > 1)
+	if (s->port.fifosize > 1) {
 		device_remove_file(&dev->dev, &dev_attr_rx_fifo_trigger);
-	if (type == PORT_SCIFA || type == PORT_SCIFB || type == PORT_HSCIF ||
-	    type == SCI_PORT_RSCI)
 		device_remove_file(&dev->dev, &dev_attr_rx_fifo_timeout);
+	}
 }
 
 static const struct sci_of_data of_sci_scif_sh2 = {
@@ -3743,15 +3741,10 @@ static int sci_probe(struct platform_device *dev)
 		ret = device_create_file(&dev->dev, &dev_attr_rx_fifo_trigger);
 		if (ret)
 			return ret;
-	}
-	if (sp->type == PORT_SCIFA || sp->type == PORT_SCIFB ||
-	    sp->type == PORT_HSCIF || sp->type == SCI_PORT_RSCI) {
+
 		ret = device_create_file(&dev->dev, &dev_attr_rx_fifo_timeout);
 		if (ret) {
-			if (sp->port.fifosize > 1) {
-				device_remove_file(&dev->dev,
-						   &dev_attr_rx_fifo_trigger);
-			}
+			device_remove_file(&dev->dev, &dev_attr_rx_fifo_trigger);
 			return ret;
 		}
 	}
-- 
2.53.0



