Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064874;
	b=MylW/3/f97SttG8NyuSFCKZv9lXNi2/M1MD7Ughm9OLgPpBXdnQDQBtgWedwytj1444Z
	 W/04jwFCmWdbh18I9Uvg3bTmgON5jSv02GzSf0btZS8MuN99xixGfBzS2qCrSUDHRB+Io
	 IsoFH8TfBv71XZc4XNjnx6E7aIq+XvEZPsVVgw6q5NN787qWtXAFNtf1xBrTs6q/ASOzL
	 IZo1sUBcZSArsQg4THpIRaYABinKxpdg/UU/s1f/RyiC/hC8CQZwhrHCdICoGqXqAAPIf
	 eimzxG5fISKl5AHSSvnNXn44XOxFVZx8q4ibVjee+ynAIFAH2ca6VYOol5FgIFdvqtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1+ukuAyRYzkxFt0XT5dxiduhN+VE+RHr8nHFCwg/ME4=;
	b=M7+seql8ryUb/9mLkfFLxcindsVQWein3cgELS9OH9EuRr6gUFZRY49pBkctX0Rmo3tz
	 aGM8i5pFdS8Rwox3j6ZjI/CnXNeBNKSIoDYGiFzYqQUKSN7yMsXPHxidtFstv4ui7DIm/
	 kEnosdwVRmU0TSUGeEQXQEIbqzymKFg83kwRKNdZEmfU+m1o54/gcdS8hQIqWk6scCbbF
	 XaAdCiZXi6WQyhHV4vH/S5pI1Xq63SF1S4t0QG8EneRkWVT/mYw2lhqH7L/Vnpm9aAf44
	 wjQBHcaMtTUWJaquQS4PjnxddhPck3d9bempGGPN2PyT70VurXFWJiz47fabtnshicw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZEdKcbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4634606CE4A;
	Sat,  7 Nov 2026 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZEdKcbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E841F0089F;
	Sat,  7 Nov 2026 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064873;
	bh=1+ukuAyRYzkxFt0XT5dxiduhN+VE+RHr8nHFCwg/ME4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZEdKcbZ4s3w5zn/WNlbH+OGqjlVIphaa1urvBS1tw6WsxsxRcnd2NiVE2C5kFHe7
	 Xb50Am8yyf5cSdAejReNz/sN9JVFsDfydtgVYUySJp6vY4U4h7HkZKzchoHtdkZYOb
	 0/xPkWaNLIcjkPFgmLyTv2w+u1x7UT7Oe5LAbfF4=
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
Subject: [PATCH 7.3 0752/1257] serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()
Date: Sat,  7 Nov 2026 08:50:48 -0500
Message-ID: <20261107135000.057796246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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



