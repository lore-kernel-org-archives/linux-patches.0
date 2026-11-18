Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052641;
	b=OTQ74VvN5/4crZCTyATXlcyslPJafU+4Us71hkcDpUIFMAGaHT9cic7YhVPMHz6Pp665
	 ZjJct4yl9S4BWcu+v+YD22/3+xCGBSXP6ziQVKlKrFwsFxpJUWwmSWwxoDti0VhVtdS8O
	 PigZEMlhA/0bK4DuohqinAAf1NY2Pf3vG16V84JoC/EBVcv6qN5lnyk/8X+A42uOoqoH6
	 83eMj2V+RPdPs7gAwXKrPqNp3vX59c+TBqILoUXyvG7iI7vtwnPEdhRX+gyiI9+N+4ijh
	 SFM4uZKfIQ+eSRxnrJKZ2ZDWpSjcslYnPWBfkn9LiBvKa6LErn9sSBrScrAL04qC5NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=n+6dN0D7wB1ZHRE5YWQhC47WCukmxfMIQ3ud28CXMu0=;
	b=FWxcJfBwmH6fZRDchN1aoaHI5Oy7CgH+ySUjwQ2GL8YiCyxtCfFA0fRyFPkpoK+zYPyr
	 c/WcYTjbvB9yBXZWtBd85BE7EAU7Na4e7jmsBSJeqF/F6NU+jn/5wiGePaqvMco7R3c9a
	 dOMYxp5IeuBs8XWQrqNoVlAeL9i1qNyJXy+3OzLOy3azytJLaKtFhIEwDIW1Db6cKj/h7
	 bghFuUEuVRD+wD+t3d/WDIPX+ThaqDM33ehY75MvEYWzLLPnxAWwqTCjGNOJR3NbDcYgK
	 ZX7aKuQOtTWvaSN7ou8o1MQEMFujh6wnu5dy0zSn5Yd9Y+DOhZn3ywmnBfLEiq48PaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQRRJgal;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45591606A31C;
	Thu, 19 Nov 2026 01:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQRRJgal
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7BA1F000C4;
	Thu, 19 Nov 2026 01:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052641;
	bh=n+6dN0D7wB1ZHRE5YWQhC47WCukmxfMIQ3ud28CXMu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQRRJgalI9f3Qpq5cwL61RDtuTbFb9j88FmIKcv7yn3fVjB2l8nXIRCp4VqBILb++
	 cL8+rMvqBuavURqbH0YBmoM7d5myA2WUiZezz1oNlw5h9UKLLp9WcyWc+YTHscQQMY
	 Ms5ap6865jK0KOJ6cpmm26E2coj5hC4Ktc8SsARA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	stable@kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-serial@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0637/2214] serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()
Date: Wed, 18 Nov 2026 15:38:33 +0100
Message-ID: <20261118150036.819182271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 3e3ae95a3d84a6028f37a07ab7ad78bb14689f2e ]

lpss8250_probe() calls lpss->board->exit() on its error path. For the
EHL board, that is ehl_serial_exit() and it does:
serial8250_get_port(lpss->data.line)->dma = NULL;

But when lpss8250_dma_setup() or serial8250_register_8250_port() fails,
lpss->data.line was never assigned. As lpss is kzalloc()ed, line is 0
and ehl_serial_exit() clears the dma pointer of an unrelated port --
serial8250_ports[0], i.e. ttyS0, which is often the console.

Initialize lpss->data.line to -1 in probe and skip the clearing in
ehl_serial_exit() if no port was registered.

Fixes: 5318f70da7e8 ("serial: 8250_lpss: Balance reference count for PCI DMA device")
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Assisted-by: LLM
Cc: "Ilpo Järvinen" <ilpo.jarvinen@linux.intel.com>
Cc: stable@kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-serial@vger.kernel.org
Link: https://patch.msgid.link/f389df34aaa538270313ebd4cea75c2baaf46b95.1791873876.git.jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_lpss.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index 87d70e81273c0..39414272a7840 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -185,9 +185,8 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 
 static void ehl_serial_exit(struct lpss8250 *lpss)
 {
-	struct uart_8250_port *up = serial8250_get_port(lpss->data.line);
-
-	up->dma = NULL;
+	if (lpss->data.line >= 0)
+		serial8250_get_port(lpss->data.line)->dma = NULL;
 }
 
 #ifdef CONFIG_SERIAL_8250_DMA
@@ -334,6 +333,8 @@ static int lpss8250_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	lpss->board = (struct lpss8250_board *)id->driver_data;
+	/* for tests in lpss->board->exit() */
+	lpss->data.line = -1;
 
 	memset(&uart, 0, sizeof(struct uart_8250_port));
 
-- 
2.53.0



