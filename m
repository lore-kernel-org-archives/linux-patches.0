Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036621;
	b=k61Y1xMVR1/mAUXKCpqqG/f2ZlKJ4QPTBuVDO9Wp6ku7UzyUf5FqMpeTGbVUVF81BYvU
	 n/kNjzVBDEPxZrrmDqyqgcsm9Cx352WMfORXyj1l6q2o7nMGnALEbywQCZY+WazB4QXyR
	 uprSkA9f6iFhqt7SzIsBZl85GX3d+6RHc8JcNnw7KNMgwjtGHaTNuIHZblIK1peqNwYwb
	 DOMOn0ek5AdyB7HAYgM9RsY7GAHBf59ML6RWkHRk5z/W+GKuQ63mNvUj0IH4F+hcmkY+4
	 ziFEOJR2SeUXSy1gajvoJLNPOWGuOfak6Vp5kg0hsgImCq6WeDi3BW8uz3DDuISf5Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dn5WXYZRU9s2l3dqfd2BhK5xw9BuxsEOj6W6Li28VlE=;
	b=wA+tog0EFi3rr2XzmV+HTlDN1F9tfhrTwU6Y7oXb+jiG9l3RKqew5DcQIdjw9Oh8TwZF
	 Azr2BEh9Nq8Xnw/obgYfB0ndK/yYa/AjRH0I+OetmipIWSulFSPcpUxZIMkechaifxjZU
	 PD0+kkBys8tb/yub2fOSdL03wlw6kPKpCl8vJGYdl61JwO4LaL6Y5HXQuo3uY3J6nihcI
	 sXIXaYOAA9DkNaLFtZ/glEgKCDHGM3nT+hIDkwaTJqj72ro1Tnxr8YOuykrqJe6M9O7cy
	 QWnVEn2V3PXY8WckxC11lanrHLZEKmDF8Qw8xqTM6TTGyIsj9QiPq7kgZxlXXMWJxrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRFya6np;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BD2606A325;
	Wed, 18 Nov 2026 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRFya6np
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016301F000C5;
	Wed, 18 Nov 2026 21:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036621;
	bh=dn5WXYZRU9s2l3dqfd2BhK5xw9BuxsEOj6W6Li28VlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRFya6npDpq8wE2kvYPVUbDxswPjtOvAg/2IZuXCtM/eWUoLR2kzzzOqTe2w41zEc
	 2JInFJ9tS+QPhvI+TZ5E8Z1kvLVJ1GfMgBuksp7TQ6ur2CaeRVHCyzUE5k/Hw+3NCl
	 vH+p5Kl0932fvxRX/yOw9gL8Jbf1SoUWxa54MPjE=
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
Subject: [PATCH 6.6 1108/3318] serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()
Date: Wed, 18 Nov 2026 15:28:50 +0100
Message-ID: <20261118150353.237287182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0e43bdfb74598..4a46ee9de2a13 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -183,9 +183,8 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 
 static void ehl_serial_exit(struct lpss8250 *lpss)
 {
-	struct uart_8250_port *up = serial8250_get_port(lpss->data.line);
-
-	up->dma = NULL;
+	if (lpss->data.line >= 0)
+		serial8250_get_port(lpss->data.line)->dma = NULL;
 }
 
 #ifdef CONFIG_SERIAL_8250_DMA
@@ -332,6 +331,8 @@ static int lpss8250_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	lpss->board = (struct lpss8250_board *)id->driver_data;
+	/* for tests in lpss->board->exit() */
+	lpss->data.line = -1;
 
 	memset(&uart, 0, sizeof(struct uart_8250_port));
 
-- 
2.53.0



