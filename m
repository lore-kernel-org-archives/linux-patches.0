Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038535;
	b=rcy/KOkJhQGx6V87A9pQT1db9oT05uhhdnTr9rZs0krSjO8lr4WiZ/P7ABzNwrt02/Dc
	 rHoZ5s+kJKsgbSxkTReOqmuvCdNNR7sCZvZ6K7U16+HAO5wXy9KQvuIgEwuEiA/ik4NuG
	 2fLVnhN7vTY5hBL4vxI+Xe4v7ctyc/5kysyIGH8VsuRueCVkKD5faLNjgW9T/x/HZwYw0
	 DZYm10v3AZlQfEFmS0O+2DF1eT/XNjVk50niTkA5ZF+zKa7g1714xEk9nWS0xKvNYfUEY
	 Ls/uOOTKGQ5QSSKO6cWOVSRDKIW111/b2HeMMitTI1wx0oStqNzedGpj1t8OAgODKtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2aCVJzXgpFhvrqkhzbgaK2exNFRLaafM1yQAabxQGDY=;
	b=QIFOLZlz1lnslIrtW5n8aS94DmEDMBQ6x3uSov7X6xaLfzNp13U5XzZqFx+sksMnfVzG
	 Lzhhhc7+3UWuUtHy27SfICpERCd7G6KPc4Df0q/xadPInArh69r9zm1E4Ojpw+yTx776N
	 PbzqjWA+Ri0Rrpfd8L/vzxAGTjjwrRHqH8tsrBh1IQJt6o1Ida+4TQFswDuZCemAZREvu
	 KmDAS6cRRB/5ANBL1nedPP+ahjE8wxUlbWJBdzqlus4PRki9pMb2mnN5F1+h61H2HizkH
	 /SZ6+TzceaZF+Hq6b021ZaSHOo8VsjETORFoJy2MwJlVQeR9h5i0OWNXuh6hIzGWjHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqscC8Vm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E84D606A32F;
	Wed, 18 Nov 2026 21:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqscC8Vm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5EB1F000C4;
	Wed, 18 Nov 2026 21:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038535;
	bh=2aCVJzXgpFhvrqkhzbgaK2exNFRLaafM1yQAabxQGDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqscC8VmT54OmFfbEroinKu+gvmUWSLkyr8G5NkC3oUSkyk8/dXDyhf3rs8yjdWke
	 WrW7SN5nsnPoSpPi4VFRZYQl02arHA+cN9dHh+gQWC6WLWwLejwtpwF+TkhpW42c7r
	 m9Rzrm1g78K1g0gpqY74jf57iFhjndAwLF8lpU6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1740/3318] serial: exar: fix checkpach warnings
Date: Wed, 18 Nov 2026 15:39:22 +0100
Message-ID: <20261118150414.062751543@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d8e2dd5a2451e..aa72d252c6bcb 100644
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



