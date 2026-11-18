Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058523;
	b=s29QugWc4ynW34iUzhWZ6WW3YOv6KdPOEErIupN6E5CIwTIvpnbJ6F8R9HiZNhn9WhVx
	 fQGWK+Gr3L5pfRqVmwH8tx0bubLME9E2H1UmynGmkGaGPf/Esettu3hsMOL4M05eQVS62
	 tzN210FsbkXWq7DJWfK9d7bJs3RYMHt/Wct6oXyEW93N8RDAc9qoOKBBoyn+Y5OycGRnk
	 cvYIs9ddAx9GVltRRSscXgBTfvf8DOPp3cmftJp+nmPemRC08x5lLYxro26ga7w16sJUe
	 4F+Y4ycKgP9ZvQgptrsllGOKAMaoOLg1SQu9oeCvoIkOL0gbySZIxjnyydpN4xw5EHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OrMhTdAr5f85YePUyTiZAYWWHvCj/Le5jyjx0yA+SnY=;
	b=YJsUruGO9MfukAJDUQ+hAEpoem5JPr3a8QT5QRXptepSpCPlb67lYRtdXK5xAjNUSZJi
	 CEB2kDifjABYFGpTyf3ujiMabeEpFUkthw02VBV8nDBLl5uFcEw6HF+FJGCOuyQyOywJ/
	 17dU0GbJxjbaYYFxm2CrttdxSpAorFg5CbKP2k2vQSyzi4+jijTbuhQ9zqJfbzYVvCuVl
	 6RJKLquNriyaTNj7Y+WW6EjNvEycx3WiHc0ptURN34+dp48OVFVC1QWQzF2sxQm5eBmly
	 pWYmK7nqb52C8rg04Un7Z9+BfXpruHEdWtqsndiYwyMDfp8Z1G1l1zdiRDCyhLV89gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGXZcIAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9526606A332;
	Thu, 19 Nov 2026 03:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGXZcIAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A01F1F000C4;
	Thu, 19 Nov 2026 03:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058523;
	bh=OrMhTdAr5f85YePUyTiZAYWWHvCj/Le5jyjx0yA+SnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGXZcIAY5vanS6hBS1CP85STAVxt3e3grVb0Nna17rw3lv816bB/Uj+OjUPUVz0A3
	 Ah+8qHOauZfEQPNOTRwcWJ6uiOuEZ+ldoDEHjhrp6sNiZ0bnuSEaaWzB7+J5fSIEEg
	 W5+WXFa8q6rdePQRqoHWnPlcnA4gQ9UYNyGl3rEc=
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
Subject: [PATCH 5.10 0515/1848] serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()
Date: Wed, 18 Nov 2026 15:42:33 +0100
Message-ID: <20261118145936.265933180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1349c161c1922..e1fc1cb295ec7 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -172,9 +172,8 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 
 static void ehl_serial_exit(struct lpss8250 *lpss)
 {
-	struct uart_8250_port *up = serial8250_get_port(lpss->data.line);
-
-	up->dma = NULL;
+	if (lpss->data.line >= 0)
+		serial8250_get_port(lpss->data.line)->dma = NULL;
 }
 
 #ifdef CONFIG_SERIAL_8250_DMA
@@ -321,6 +320,8 @@ static int lpss8250_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	lpss->board = (struct lpss8250_board *)id->driver_data;
+	/* for tests in lpss->board->exit() */
+	lpss->data.line = -1;
 
 	memset(&uart, 0, sizeof(struct uart_8250_port));
 
-- 
2.53.0



