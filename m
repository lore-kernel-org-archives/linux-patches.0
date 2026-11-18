Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017008;
	b=tv2+Qxnt2JTYCeQ2DP/O8c1re7YqtBHCO4yVyMMsZxMVtYnCMRvqvVqNkGbFV8IA1Hfx
	 8gJqLePD40jpLdMcumwGMhvqEbobPgNbbZcx3UiQBJ2GhQcTJbZ+3rYwJ0csCXfPTK6dN
	 MTiWbt31O8FXwhuy0Ma5MYQ3+zoR/fd+9+0rO5JMtVC3xQ6uMnMheVAo5xKF4QcE+nMKL
	 nJVcqT+baf1c1DLiLdOMwkW9Se/dzu2Cdo3KYDAZlRUroBKmuKpxw3a5/w0P5DKfa51DN
	 fK8S3+80v5RivAFR/IlIoFMsitSCoq2tgRgolUcXLdhST7970V2WB/R9ta9cd1rq8aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMRCrplT+4aSH9oQGil+a1dBU6A86elFpFW+pZilKv0=;
	b=Ec4HIZZZEC6mKszvbq3OKXDgIHNhcYfBOdNNpgAn5Iud6LJ6WwrtxONnIZS4faKtmpfj
	 NPv388MV6an4rKNC1OcLYlZ9U/ZEdh/2AgSY6d2BioWEEZuLVExJ5fH04zea0+9W/WvxB
	 TDeKL7irSlZ5SezVLSZNgOVPcsPs1sOAnmMRMvosh8AtgZiyuK1Mu8Ru7DkOJ4S0rYl67
	 mC7c9/3qmkAZqIt3waHDrxgy+J233u7fgmxsri4WBnv0TFmlW9pyhnDmkhJOogs4DJnZX
	 5qbiMrhqG7xmiy56FTfemTHORVQLvL53pQPeL3cP3yYykukgzg5SiQ+Vn8107csPCsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTtuIl0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9532B606A31C;
	Wed, 18 Nov 2026 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTtuIl0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E412D1F000C4;
	Wed, 18 Nov 2026 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017008;
	bh=EMRCrplT+4aSH9oQGil+a1dBU6A86elFpFW+pZilKv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTtuIl0We/D3lGNqE+J2gNDv2wjVGtLTWMs89mRfocJdynpl0MvJlaj6GZDfZGqSB
	 3E/F/r0YS1CzxDLWff0q7vRGWJ/3iD0zjjDjo05y5O5BWOP3JkdJyqhxX/KH/YEaq9
	 av0CPXxKzikkJ9uo0A2Q/6XNTz03lh/hDsDT2SNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tate Whiteberg <whiteberg@arista.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0730/2651] serial: 8250_mid: wait for LSR tx empty before setting termios
Date: Wed, 18 Nov 2026 15:32:50 +0100
Message-ID: <20261118150314.151499360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tate Whiteberg <whiteberg@arista.com>

[ Upstream commit 1c305d5f1daabd317a60b6a2e2ac6b1aff7e05df ]

If mid8250_set_termios is called while data is still in transmission,
the corresponding register updates will corrupt the transmission.

Fix this by locking the port and and waiting for the transmitter to
empty before performing updates. It is necessary to wait for both
UART_LSR_THRE and UART_LSR_TEMT to ensure the final character is sent.

Fixes: f549e94effa1 ("serial: 8250_pci: add Intel Penwell ports")
Signed-off-by: Tate Whiteberg <whiteberg@arista.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20260831165911.2029839-3-whiteberg@arista.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mid.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mid.c b/drivers/tty/serial/8250/8250_mid.c
index 82656645b8a64..c02ecb96e8b6f 100644
--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/rational.h>
@@ -209,6 +210,7 @@ static void mid8250_set_termios(struct uart_port *p, struct ktermios *termios,
 				const struct ktermios *old)
 {
 	unsigned int baud = tty_termios_baud_rate(termios);
+	struct uart_8250_port *up = up_to_u8250p(p);
 	struct mid8250 *mid = p->private_data;
 	unsigned short ps = 16;
 	unsigned long fuart = baud * ps;
@@ -231,11 +233,16 @@ static void mid8250_set_termios(struct uart_port *p, struct ktermios *termios,
 	}
 
 	rational_best_approximation(fuart, mid->board->freq, w, w, &mul, &div);
-	p->uartclk = fuart * 16 / ps;		/* core uses ps = 16 always */
 
-	writel(ps, p->membase + INTEL_MID_UART_PS);		/* set PS */
-	writel(mul, p->membase + INTEL_MID_UART_MUL);		/* set MUL */
-	writel(div, p->membase + INTEL_MID_UART_DIV);
+	scoped_guard(spinlock_irq, &p->lock) {
+		p->uartclk = fuart * 16 / ps;	/* core uses ps = 16 always */
+
+		serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+
+		writel(ps, p->membase + INTEL_MID_UART_PS);	/* set PS */
+		writel(mul, p->membase + INTEL_MID_UART_MUL);	/* set MUL */
+		writel(div, p->membase + INTEL_MID_UART_DIV);
+	}
 
 	serial8250_do_set_termios(p, termios, old);
 }
-- 
2.53.0



