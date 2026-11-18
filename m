Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046997;
	b=AV9CDPIMlozPRRloDAQTCcu8PWoCpnzoefxwkl6SQpTyWr60E8A8RYoI9OguaRZpecAE
	 qR/hycUvdcRHgeXl/vgp3PBCeYETOlBMFiO8iwpoWRGXnsxoZDTigS1aeb0D2g3Ol6hrF
	 S8dQOQ3jdHgppzDLwZweGg20fzaahqqvAf1b8Ew5ZLPnqqViva3984rUC4g4Oj8/DQfne
	 RiG+to63StA3A4nfpjc4fZT9BWrPstVPkwWy8SX1E760xSFSHkmmIPnBOdio/FiWMeInx
	 m0YoEAad0qQH1jRmqWEHX02J8URQ/VR7ilO10PM5NY3jisrjoOzeEf5xlaIF5QVb4WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CSxCwa1TfJzr55OSFN8z6AzQkSJ8iQYJtJYpARmEbjQ=;
	b=yQ1ZZ6IhAQquQyxnbcqjAWFEzsJDIYGa+zx1suumdDx7OViIrO4j8wHSGnxV9PaWFjHY
	 jxm+BKNE9vo75PrX+HnLx+iyh825lIISzgpQco68zBnt4+EbjA/3Qb+Y3Ah5qGPlosn2v
	 F4EiRo9b8bPfgyxty49iypu1/6xqosAg467i5XjbMBJWQzVY/9olgCaIveVgqFHQEql4+
	 SyXyTn5eF7w4/dz5/NUZpIdCC64zIi/zgbEP7DCNhxqV/OWirwMcvFCros8rb0AGxxEXP
	 FiWlgmqcEjvxSx93oOL3rGhfU8freXz3uU5jAKGCN7bEt7/8Hp9CBqTxOSohB8y4wsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qU3CfEYX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E02260A2601;
	Thu, 19 Nov 2026 00:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qU3CfEYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB921F000C8;
	Thu, 19 Nov 2026 00:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046997;
	bh=CSxCwa1TfJzr55OSFN8z6AzQkSJ8iQYJtJYpARmEbjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qU3CfEYXUC4sCcAgNIW09hoHGNqm42mO3UBKd+GXdK7e/jZOK0XP/mv0pAc7Q4Ww3
	 +76TDgzBcJOIB4CJ2/RRlA/TdK/RFqhILksgxWEcdsvPt9KhNgQTs7jCoPE9mXd06G
	 97GUEsrKPDQQjjKzSD4l34a7oSvN+mIeqnpHnniw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1482/2857] serial: exar: fix checkpach warnings
Date: Wed, 18 Nov 2026 15:41:56 +0100
Message-ID: <20261118150254.666232206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parker Newman <pnewman@connecttech.com>

[ Upstream commit c6795fbffc4547b40933ec368200bd4926a41b44 ]

-Fix several "missing identifier name" warnings from checkpatch in
struct exar8250_platform and struct exar8250_board.
Example:

WARNING: function definition argument <arg> should also have an
identifier name

- Fix space before tab warning from checkpatch:
WARNING: please, no space before tabs
+ * 0^I^I2 ^IMode bit 0$

Signed-off-by: Parker Newman <pnewman@connecttech.com>
Link: https://lore.kernel.org/r/f7fa6c16cb5f2c8c1c7cb7d29f80bc7be53f91ab.1713382717.git.pnewman@connecttech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 33d337816e00 ("serial: 8250_exar: store the GPIO platform device in struct exar8250")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 060090adabac6..9326a7bd4e2a1 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -133,7 +133,7 @@
  *
  * MPIO		Port	Function
  * ----		----	--------
- * 0		2 	Mode bit 0
+ * 0		2	Mode bit 0
  * 1		2	Mode bit 1
  * 2		2	Terminate bus
  * 3		-	<reserved>
@@ -169,8 +169,8 @@ struct exar8250_platform {
 	int (*rs485_config)(struct uart_port *port, struct ktermios *termios,
 			    struct serial_rs485 *rs485);
 	const struct serial_rs485 *rs485_supported;
-	int (*register_gpio)(struct pci_dev *, struct uart_8250_port *);
-	void (*unregister_gpio)(struct uart_8250_port *);
+	int (*register_gpio)(struct pci_dev *pcidev, struct uart_8250_port *port);
+	void (*unregister_gpio)(struct uart_8250_port *port);
 };
 
 /**
@@ -185,8 +185,8 @@ struct exar8250_board {
 	unsigned int num_ports;
 	unsigned int reg_shift;
 	int     (*board_init)(struct exar8250 *priv, struct pci_dev *pcidev);
-	int	(*setup)(struct exar8250 *, struct pci_dev *,
-			 struct uart_8250_port *, int);
+	int	(*setup)(struct exar8250 *priv, struct pci_dev *pcidev,
+			 struct uart_8250_port *port, int idx);
 	void	(*exit)(struct pci_dev *pcidev);
 };
 
-- 
2.53.0



