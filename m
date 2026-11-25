Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620412;
	b=rh0yDw/lFzxiZtOtLGO4PtbLuqJ6XDyHGTkGzYEmnh5PnG3lojcIL1hctG7JLLsloegO
	 lYS2NsdQzJlIh3U9DfWd91M+O24dbTLXCE9rPhLDaBUXRsXSgipQ/ov0jV5hq7gqWYo9W
	 pnq9fT7tQFqx/Hu0Fp8MMYBKYa27hc4OEtJ0ElhvDZGpPIixypqbMPD+cY/88MhgZ69DV
	 EWTrCCy7cHvZ2g7gifABAl19JJsjm+HwyoQXclzZ6ngb+5xt3T328ptJlqMq6d3A6oTh0
	 38eSxrjTIpfmtWj2Tk+/Ndgtmn5LZbWI+BmWSiUBJO61DkjznuX3KKdpEJl6Jy4+Xkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hwwh8xeHRycq/6GUKz74SRwxhTuWRlUZyQ1brnQl21I=;
	b=k8qDbfwK65fXQtk7g/5W9UX4b/y9cgWo+J3Cj6ZQotmkgb19gA2qmCjkDB+4OEJWUUcF
	 VWQ3hwNxTMenrRUSBJSzGInRbtB5YoSuH/J/XizCGXDAFYuSgdOQ5spMmyt5IoSNte6cp
	 j2ij03NXiEQrt5hVl36ZaZlkxtBJzkGs0mrTQNiNtt+R7zsJQAXmCCU3Fb1EjQaJm0xwh
	 hx3WBpSUYg8uwPS0RNfcg0pPZVZJUIebqz9ULSieIe0bsY7FxyrrFzvoqxKzWrJR2YRq1
	 9uYl85x+d9Qqg7hEX7Fz6fojpnFKtrA9wp26y2QyeFhfAFoFFNH7WA1Weu82IAJJ8gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZP8AB0E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68E2606A31E;
	Wed, 25 Nov 2026 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZP8AB0E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319EE1F000C6;
	Wed, 25 Nov 2026 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620412;
	bh=hwwh8xeHRycq/6GUKz74SRwxhTuWRlUZyQ1brnQl21I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZP8AB0E5bzBsZaeMAKfJCx1xlw15TpmtxRgTUpsiw32CaC1knd8YmOP3tAaPE83u
	 NtO2VGRP77Xh28kEr4+EqkaPgyyrl4yO0u3i++pKsUbmo2P6H3GYeJbDyEvNfa7/Er
	 +025ZEga5Nphb7UigWE9EMmooy0XgcjWomJSPYbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
	Olof Johansson <olof@lixom.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 7.3 0909/1005] serial: rda: free the interrupt on shutdown
Date: Wed, 25 Nov 2026 15:37:27 +0100
Message-ID: <20261125143842.987221277@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 859f7c56709b161a72b629b6f2f1384dcd374404 upstream.

rda_uart_startup() requests the interrupt, and nothing ever frees it.
It is not shared, so once the port has been closed, the next startup
fails with -EBUSY and the port cannot be opened any more.

Free it in rda_uart_shutdown().

Fixes: c10b13325ced ("tty: serial: Add RDA8810PL UART driver")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Andreas Färber" <afaerber@suse.de>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-20-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/rda-uart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/rda-uart.c
+++ b/drivers/tty/serial/rda-uart.c
@@ -471,6 +471,8 @@ static void rda_uart_shutdown(struct uar
 	rda_uart_write(port, val, RDA_UART_CTRL);
 
 	uart_port_unlock_irqrestore(port, flags);
+
+	free_irq(port->irq, port);
 }
 
 static const char *rda_uart_type(struct uart_port *port)


