Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55248276055;
	Tue,  8 Apr 2025 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115965; cv=none; b=Lu435t5Sm9gfrtU1vjbfpghasZ4yceqXIWPm5XWlj+zGopmMe65a0F0x/hoeDj52jJFqBUNoSr1fyLmNvDHEsH7lTXAT5Vkpf4xDOUuLYL+Ml5fsDv7TOiljfO26XLiHwvt7e1RlrdMlKuh7GDUFO92nVjHEcmip74BxvlN7xxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115965; c=relaxed/simple;
	bh=vRuSmH+sJ0ETlkjwTFc4GmLkA0+bgB8yrq+7epwz4fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHzzSADYslbC5HCgESZu4bZTw4psLpDRn70MEcuJH+Vfr21b1gP/HLyANYkGZiiW4fL2sQj8WgeRqkerbpjqox2vTYb1oy6I50lJIRHVI1x1PiO8twLpxk3Ury2jgKcvIZtAx/abMtFI2HDVu/oLFD2YqhTnamzZlN3upvyWqac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqWgPxqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqWgPxqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B163DC4CEE5;
	Tue,  8 Apr 2025 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115965;
	bh=vRuSmH+sJ0ETlkjwTFc4GmLkA0+bgB8yrq+7epwz4fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqWgPxqLKMKiRUYICQCNZcj1PAp9seGc4LSxXhJ6b1gHBo2a0UrydyWV+JHNy2Nt+
	 +j3WrfndvRtOdA7mi6FqJiXMVRWaBiK6sa5ebMpia3mlJm9MNA/XTuKosYnSEj+9IO
	 XpJq7AgV2gDTemMqCreYdCvdNiHo2ZnoO4/XoFBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/204] tty: serial: fsl_lpuart: use UARTMODIR register bits for lpuart32 platform
Date: Tue,  8 Apr 2025 12:51:41 +0200
Message-ID: <20250408104825.336696150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit d57d56e4dddfb5c92cd81abf8922055bf0fb85a4 ]

For lpuart32 platforms, UARTMODIR register is used instead of UARTMODEM.
So here should configure the corresponding UARTMODIR register bits to
avoid confusion.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230414022111.20896-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f5cb528d6441 ("tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index f94c782638686..e96354edff6e9 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1394,12 +1394,12 @@ static int lpuart32_config_rs485(struct uart_port *port, struct ktermios *termio
 			struct lpuart_port, port);
 
 	unsigned long modem = lpuart32_read(&sport->port, UARTMODIR)
-				& ~(UARTMODEM_TXRTSPOL | UARTMODEM_TXRTSE);
+				& ~(UARTMODIR_TXRTSPOL | UARTMODIR_TXRTSE);
 	lpuart32_write(&sport->port, modem, UARTMODIR);
 
 	if (rs485->flags & SER_RS485_ENABLED) {
 		/* Enable auto RS-485 RTS mode */
-		modem |= UARTMODEM_TXRTSE;
+		modem |= UARTMODIR_TXRTSE;
 
 		/*
 		 * The hardware defaults to RTS logic HIGH while transfer.
@@ -1408,9 +1408,9 @@ static int lpuart32_config_rs485(struct uart_port *port, struct ktermios *termio
 		 * Note: UART is assumed to be active high.
 		 */
 		if (rs485->flags & SER_RS485_RTS_ON_SEND)
-			modem |= UARTMODEM_TXRTSPOL;
+			modem |= UARTMODIR_TXRTSPOL;
 		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
-			modem &= ~UARTMODEM_TXRTSPOL;
+			modem &= ~UARTMODIR_TXRTSPOL;
 	}
 
 	lpuart32_write(&sport->port, modem, UARTMODIR);
-- 
2.39.5



