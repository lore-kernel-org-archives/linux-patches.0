Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053905;
	b=QFYTnaPVKjkDUOlhUgdsRLEUGCBcAZisWpFYpYhBEAVxKFJDVBZb7LBa1YVaDvkYuc70
	 iK/cRVRZx9PBsxPjALSAA5A6lYaHQQnpNoZm5in9vP1EiH03gfhus7pjAH9FfMblGKHa5
	 DbH2n24YaAljqN9jodoebzxXFz384E4/DLmYo0e1850jUDK8gfcDAHRIOnAx//0UZugWp
	 dpL5XXQnasS0+bGkXJ31we96LPvijVFoleMfweNsyRqcFjVRq5LnugZ343nItWTYLLp/V
	 vjudVcp/+ZY19HzSKoTWiFsETNIpNA0UlI1hcwZWdKXmNsgt+m3Yj8JP3qFJ2BnSBiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9KRD+Nb8EWDMmYnXqDnXX6CD/iZ9WgEYs3Lf+7DLQYQ=;
	b=Rp9RIE6MCPJji9yr7JmJylBe5okj0jn+LG6d9fUG+WBLdkoLa40RubqiC/1KvfFQd9Zf
	 NrYA8xEpCxbr6p4RxOV2s6FLLokTmLR8Ag2G/lMf7n/xfRmo1lqZkfNjOsujqvpv8rHbX
	 UUA6P7Oy1eVlHhh5hVQLEyv7ex02WNJKHx668OyoK3pq38ZhlcnRgfIimJ02QSeFpocTd
	 ZceVSuYoxhCgrlYkYeLOubxUEzTzYDnUCuB26lFIIDdq6uaETjp2ScXtyUsS7LruRtZt8
	 xYdSBsJmRTIgtqCjQxMkRsIY6TNsw4NX6IBGWA8O+Y2Y/Ya3hMLNTXvssdpI/pHkyHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+BUGQo6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B22606A32A;
	Thu, 19 Nov 2026 02:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+BUGQo6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6811F000C7;
	Thu, 19 Nov 2026 02:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053905;
	bh=9KRD+Nb8EWDMmYnXqDnXX6CD/iZ9WgEYs3Lf+7DLQYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+BUGQo6yPf0tdiD+1vxEmW1aC5h2QeWa58+Ap7Ial7EScSrqm6RvSvwBazWVFgCH
	 dX9qtCm+AoQQ7+rOSU4yWHYKVT4ySpbgWecVQq2CQ8LtLCteil6N+u77/zmI8NSF8t
	 7VoU/YS0gV/c0F8vv9DhnjunmipRuySGBZD+5liE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1085/2214] serial: exar: fix checkpach warnings
Date: Wed, 18 Nov 2026 15:46:01 +0100
Message-ID: <20261118150055.646462530@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2740840679d78..b5275cad4a69b 100644
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
@@ -168,8 +168,8 @@ struct exar8250;
 struct exar8250_platform {
 	int (*rs485_config)(struct uart_port *, struct serial_rs485 *);
 	const struct serial_rs485 *rs485_supported;
-	int (*register_gpio)(struct pci_dev *, struct uart_8250_port *);
-	void (*unregister_gpio)(struct uart_8250_port *);
+	int (*register_gpio)(struct pci_dev *pcidev, struct uart_8250_port *port);
+	void (*unregister_gpio)(struct uart_8250_port *port);
 };
 
 /**
@@ -184,8 +184,8 @@ struct exar8250_board {
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



