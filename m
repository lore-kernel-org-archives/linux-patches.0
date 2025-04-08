Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB9B2690D0;
	Tue,  8 Apr 2025 11:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113020; cv=none; b=K8tF/RcP27xZH9Xt9YuG3/bspCnq5oTGENAAjYZOdjbZB1sw+CSWLP6PYfztfadZeHREVEoRDjfQuXx73zpgyBysLvVdkxXw+yEP4jtkprVdGPSag1W208gnE/Dmp1an9yfXQ2xcdwo2Qv4Ul4nt1tUVX3OlHOiuXgfmXdOEpa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113020; c=relaxed/simple;
	bh=Z7BHNqWrY3PVk91MLhtyysULRh7O9Gav9UsBnRczn7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1mR1m7ywArn5H7myaqRz96APwNjRFDT8RMGgWzjk3bsyf9HLVLl+fwHg+4yC2+sHNuneyIZ6q4xMOGuStrDf7UZiJODgLknLZxq0YhaISsWOVxLULIVqJsHH4CfC6EK3/F0Pt0b6R1tFcRxsvI7/w7Ol4nyqdl5lhq8ighsG3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWx29WMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWx29WMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81047C4CEE5;
	Tue,  8 Apr 2025 11:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113019;
	bh=Z7BHNqWrY3PVk91MLhtyysULRh7O9Gav9UsBnRczn7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWx29WMcin+JmkU0tOe5OfGhpyWWFfHl0eU2A9ynfL/Hjdlku0SrGdjqK/74VdJPe
	 AGfbwlz/Jh/X3g47ZklgL3DGXO12OX9OxLi+maX68gI0fXRmvjdG+memjAOzU+2Bg8
	 QDtHdlwY0PkIWpRve6kmHZuw2OUsyi/MEuFeb3Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/279] tty: serial: fsl_lpuart: use UARTMODIR register bits for lpuart32 platform
Date: Tue,  8 Apr 2025 12:50:38 +0200
Message-ID: <20250408104833.264043014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9f1be9ce47e03..fe1fba335483f 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1396,7 +1396,7 @@ static int lpuart32_config_rs485(struct uart_port *port,
 			struct lpuart_port, port);
 
 	unsigned long modem = lpuart32_read(&sport->port, UARTMODIR)
-				& ~(UARTMODEM_TXRTSPOL | UARTMODEM_TXRTSE);
+				& ~(UARTMODIR_TXRTSPOL | UARTMODIR_TXRTSE);
 	lpuart32_write(&sport->port, modem, UARTMODIR);
 
 	/* clear unsupported configurations */
@@ -1406,7 +1406,7 @@ static int lpuart32_config_rs485(struct uart_port *port,
 
 	if (rs485->flags & SER_RS485_ENABLED) {
 		/* Enable auto RS-485 RTS mode */
-		modem |= UARTMODEM_TXRTSE;
+		modem |= UARTMODIR_TXRTSE;
 
 		/*
 		 * RTS needs to be logic HIGH either during transfer _or_ after
@@ -1428,9 +1428,9 @@ static int lpuart32_config_rs485(struct uart_port *port,
 		 * Note: UART is assumed to be active high.
 		 */
 		if (rs485->flags & SER_RS485_RTS_ON_SEND)
-			modem |= UARTMODEM_TXRTSPOL;
+			modem |= UARTMODIR_TXRTSPOL;
 		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
-			modem &= ~UARTMODEM_TXRTSPOL;
+			modem &= ~UARTMODIR_TXRTSPOL;
 	}
 
 	/* Store the new configuration */
-- 
2.39.5



