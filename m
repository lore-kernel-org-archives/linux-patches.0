Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062363;
	b=zys/YkWEChFoVctflkipGZMtgRYncVC1M34V3AtViNAEcbcxyoPeU00RdAZrmpr5uwPB
	 T+JoCl2YAa5vu8e+ouZR3hdSHHoaDnFIP4HKAeo1C6AX2p75hRrueZ5DqCrzh5bwn0FCT
	 2VNu+cV2Mx2adkjd4GbWPKt5VzJJSeZfkGXGt0WJmHJFB0Kx1FI4JFwPFp6dlffFYUwDz
	 fMsiVC5rW/m8Glug8DPYz0e3IvJyrHd5bP2rM3rTsmFvDCQ1d8NOH5lxpY1MR9pythMZ/
	 fbSNENsyjrs7eUxGDxHyzqXA7ur98XS014SqE1ZW4MRUxZGlRxHy32WZdoEun99DMZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ls5BRhSYSI0gcpnIOZQtowd/5AQvXl8HTPjDPFRYrzg=;
	b=eTS5tCvQOr4sHQLApJBpHXwJTnoUG8MTEY21SsBbseXEc3vMVPDpJb2gKdMKedIU75vq
	 aukC8zSYB4Fcl2RL93olNjkPDIb/NYHoZZ0nZfllgHbm4soMhQLkOqICT1qpks3yC67F5
	 +HodD0TQCwemIj+Cfw2UocAOR07O7mJrms/oFafkuNodR/XD6CDyl0mDXrr0V7JWZh2im
	 BPNUjBQyAFaE+ZilaKQ8O/OeZj/E4GHfkEZZfHohCAQizz2uz9XcVoOkJi1RNNwEO2OA2
	 my62i/g8lIVryXr1h1jlcqk5gysaogzM6BZwjAZVNvHqdyxLnptaJ+NSyrD2RlHClQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2Kp0mic;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397086082BEB;
	Sat,  7 Nov 2026 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2Kp0mic
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E105C1F0089F;
	Sat,  7 Nov 2026 14:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062363;
	bh=Ls5BRhSYSI0gcpnIOZQtowd/5AQvXl8HTPjDPFRYrzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2Kp0micySuNSQ1cZwA22XJqtrHNQeCjLWhMRjYx+IFI3p3AIB+6LYs4idLqrCLdB
	 2maXUFB6UpqS+RWA1Eb9yqPsGHW1ClMEKtp8RbyFv4yyX8y0vMGtIAiv6OCZ1JKOTR
	 z//wG8VAX4DUJdujiBZE/9LvsQ9WRgJPhgRMFyts=
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
Subject: [PATCH 6.12 1289/1536] serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()
Date: Sat,  7 Nov 2026 08:55:05 -0500
Message-ID: <20261107135033.990470483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



