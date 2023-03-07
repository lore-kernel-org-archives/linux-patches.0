Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B20BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07673C433EF;
	Tue,  7 Mar 2023 19:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215664;
	bh=2HyyGHbU19N8wN7gwvdxhKw6EH96AyXcByLAHVbiGB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd/Z+Pa7jlrDjKgMv5JcmK8LAg0DLyWELFSzwdiFsQ1wyAGeR5BiA3BZzH/L0AeSC
	 XQHLmhjTVLHptcaFAQCvyPa5Zl5lpK/GydkijjqjxWiTfoyg3WAgymNRZwsUyvU/VW
	 tzMVK7hPUM/3iSluU63acgoI9pTNNLe53Sd+KPy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/567] serial: fsl_lpuart: fix RS485 RTS polariy inverse issue
Date: Tue,  7 Mar 2023 18:01:03 +0100
Message-Id: <20230307165920.071655585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 3957b9501a5a8fa709ae4a47483714491471f6db ]

The previous 'commit 846651eca073 ("serial: fsl_lpuart: RS485 RTS
polariy is inverse")' only fixed the inverse issue on lpuart 8bit
platforms.

This is a follow-up patch to fix the RS485 polarity inverse
issue on lpuart 32bit platforms.

Fixes: 03895cf41d18 ("tty: serial: fsl_lpuart: Add support for RS-485")
Reported-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Link: https://lore.kernel.org/r/20230207162420.3647904-1-shenwei.wang@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 08096d33af8a6..f4d9dc4648da4 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1406,9 +1406,9 @@ static int lpuart32_config_rs485(struct uart_port *port,
 		 * Note: UART is assumed to be active high.
 		 */
 		if (rs485->flags & SER_RS485_RTS_ON_SEND)
-			modem &= ~UARTMODEM_TXRTSPOL;
-		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
 			modem |= UARTMODEM_TXRTSPOL;
+		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
+			modem &= ~UARTMODEM_TXRTSPOL;
 	}
 
 	/* Store the new configuration */
-- 
2.39.2



