Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623547;
	b=KLVkAesbpCY9Vq2Uqv+gNMJrYqH3fnkynJQLUPGaTBCDdT96bp/cRH8mWozIbYxKQC0X
	 WCmrS7AUhE1aADCVLcq0UTywyVUQlsc8EUg9jHxl0XfeNsCxbg8BmpDbcGJTi/pCvK5Pr
	 ZcV8ycNUSy9gI4JQ5T0R7tumgYgExIfV/KJy53C9ai+RDSxLpzQX90GRjepP4KhCOfXlN
	 t4RO2eTDnCcY/TsK0x08KOhTuspqBXr6RR7hPeudbg+C+JdhS8j3zJHrj28X57QKqoxz6
	 I2Wq0r2Bo17G8xFE6xv9tigCZl1kUW8M7qmxSXj2rAc/N2YQTd3rCjQfTKvPxuYHzYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2W+0/verlc/nkpKDrVyoju2ntA0mjixFaAz7Hs3eqjE=;
	b=uPCMY9TYOKGTScx5+5WYPTGQgDOBh1F63oidOPcT5Zk23bweON3JqYwhPeehhqCva37b
	 BzPzvzMW1tYJHALI0XRt82PGLOkzNyeJuzKT5U+55c3Ku7exAA+x4G7bJFFu7rRjfFdR4
	 LM+5BY0DcMddpw/NN2y2MnfBmohSmgpaX+O50YiS2hmMZhCPNInsVP0j8lK1+ZdQgZUL7
	 6obFSu0PUmGuPCKcpGJn2BIpw3ffyKQ3Rga/odwXJEyYn46wFJtRujvewEzryUo1MRg6D
	 /EsMCwN7yLSUIa86b8ratYD7F6cBDvxdqtAfpgzxEPv2ZcetgnS17QUwzQokkL4lBnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NP4/B/Ro";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287D6606A331;
	Wed, 25 Nov 2026 16:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NP4/B/Ro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DA81F000C4;
	Wed, 25 Nov 2026 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623546;
	bh=2W+0/verlc/nkpKDrVyoju2ntA0mjixFaAz7Hs3eqjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NP4/B/RozZ5/THSQmXqoUIC7F7HphTqLjxwIhx71y0xTAoxKftqdVzUqN8B8mWCkJ
	 MWLirClgTmOAIKDrKFhHY+WkcnaBLenyzNCk2hikMoSMporvw3o8Jb0SLjuewZ3tIZ
	 70hUhckMxyBLgZuc3j7LBwGT29LvTejl0StV7Ulk=
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
Subject: [PATCH 6.18 896/990] serial: rda: free the interrupt on shutdown
Date: Wed, 25 Nov 2026 15:37:43 +0100
Message-ID: <20261125143842.998771632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


