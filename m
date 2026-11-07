Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063372;
	b=zlP38iFbBC7aAtrex1RyU8TUHxWVgVS9IoZUsaklsDZjYCy7NdfKGdzHVzaP0RvUF+e2
	 3I/89YX/WFoOZ+x8BD26mVwoEckF9i6YzFPeZaJIGb/4mNbGE13hq7Qa3K1283im8LT/Q
	 NSupQtlI9C1I8DE+1p2x4LrVuC++XIi3ijICnwppKpO3Pe024pxGt/mpdQ1uK+sN8UjeV
	 PxEffG/Zf1G+F99jIyoqt/FgXqpmnioGP9iePSpWrC6gQOmirg1v+A6YhuNm23U7TByOW
	 QeFpUSX/CXTeFzkBJnkWjOOkdewEo8rkNyzdTDbAG8G8svsDoP0Nm7w/r5yW2fT0iVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AZGuGPrOdNqJbNT839VEOn2Z8cWP25W4LTsq1eigXZE=;
	b=Tl9i0NDxzRpSc0C0vlf9HJ3yE/Lj7Tm96SgfUcXK0sPvLmfJkCm7uU71hqHmHw7/g1mj
	 1CsZSd2oNba+Lm9qqQbzGIN/TMn/RFBtxz04xLUQbqUcaH2ifC4k2fIaEQ84biWVjRn9t
	 LtrqyW0mCt1B4A9X7CAGUrCrmWRuibmIBLwpKLbu9tqahJJWS7P86SemSF0ZhtmwLHRWz
	 TqVKSLOArRz4LtkgkJvsW2WbRnvE0xrTpwhTEqkkovV6lfs/c2aKxyQDBLvU+35gxRN+2
	 rgnaXe2mNAZz3vIl+B1c2orHc8JcSSPiST1f9EjLvUjXl3Szq0N8/yx8N1V4cw8Lphw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyKOv06j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEE9606D801;
	Sat,  7 Nov 2026 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyKOv06j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23C91F008A1;
	Sat,  7 Nov 2026 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063372;
	bh=AZGuGPrOdNqJbNT839VEOn2Z8cWP25W4LTsq1eigXZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyKOv06jgbCucj65a4X2QwPadGQKl4DAdhCfvTZQasJU8kLBduh8Ux1bamTHoC/Xl
	 gEo+VnXaKWtBMY9zbnk00qzJS4z7ej1N5HWVfAtIReol0N4ts1qLTr08yithJaG3zn
	 WX3DgWkcvhISN79Xn5wxepu8xyYLc81kLZ0OP5Aw=
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
Subject: [PATCH 6.18 547/869] serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()
Date: Sat,  7 Nov 2026 08:53:49 -0500
Message-ID: <20261107134911.932469580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 776ec1ef29d62..325e587ae2c42 100644
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
@@ -329,6 +328,8 @@ static int lpss8250_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	lpss->board = (struct lpss8250_board *)id->driver_data;
+	/* for tests in lpss->board->exit() */
+	lpss->data.line = -1;
 
 	memset(&uart, 0, sizeof(struct uart_8250_port));
 
-- 
2.53.0



