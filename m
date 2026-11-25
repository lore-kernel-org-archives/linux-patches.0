Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620102;
	b=aH6aQV7nzUHSZyFk9zdgSzjdWI4EF/qPQisEwCqOnFBpS/Czk9N7wOQG3rSU8d6xTxcp
	 JZAcBz4bZWw20i6P4v6Fy4ollKBKRhUYECR817bJqLzpVgZoJmA5k+hi3XLVVNbZLnbqq
	 F3sOeN/aWuWUDVWJtS1NRShFe41+ORW93DoJ4Jk7Yq5nuq48tFCxKobCnLGsQm4zJXJJJ
	 J1y4JEELqjqVy4B1dIUG0cSreC5EeSmTW5qz4GT66VQA92oGKwkJdqUK8vn6gJZ7Mn3+b
	 fWl/Mx7JQH9ivKEmiWUNPf8u1ZDEV1AjmVPN1aETJXLhvYkkes/jMONxD1u7O5y3gMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zXKxX9zIQPSiF0pv5W/tsC4wB4G9RHGZ3xF6pcUpfcQ=;
	b=d553F4VNkZ+Rd5NeDdbWygxPhiJxTaBMyDjXQqlpwIOnL+6Y2pz4OZD8w8t/YYjC10ok
	 7jswWReYzpz7He4bFLVLpW6TkGNLuXUzo++UxJpkrhJTstUSdJ/pXrOElyGJ/VSlEkSOS
	 v/kbeVjjF/zx1jff/cJ1mefAz6xCtpmcI3ss6GEJG/0OxheEOsmKuX7e/LKXSkXo0X9tg
	 Agoo1JMq229k4WjDt5XA3BSbSp5l5GnwSB7yHeNz3pwq5iK4VackcODR0Nc7cUqK72xoX
	 oxmClC0ooe/y7ljtzOM1oha2soP48lP6P82yVJbzHdbfjaU4gN9fQdJfbw1Z2YxRwpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpGQO4VH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4A7606A31E;
	Wed, 25 Nov 2026 15:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpGQO4VH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185531F000D0;
	Wed, 25 Nov 2026 15:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620101;
	bh=zXKxX9zIQPSiF0pv5W/tsC4wB4G9RHGZ3xF6pcUpfcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpGQO4VHPSmxPaqRu4q3zzBJV6UzZTrgt3MmFJTPTMGgqZnFdlAAhAY3PpXs4hztx
	 KTf+Lg4CUomagdNeZTPFjRA0VY0kauftrrfzAHVqnxz313xndcqsniAgc2DnalNrHN
	 MeWieKjkGZ9vgXoHOyVn+NoXx9llipkDDJngzHRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Antone <aae@amazon.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0809/1005] gpio: aspeed: Clear only the acked lines G4 interrupt status
Date: Wed, 25 Nov 2026 15:35:47 +0100
Message-ID: <20261125143840.681026323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 5d362564bd2982def7e80d7f1e756a97440c7adb upstream.

The G4 interrupt status registers are write-1-to-clear: writing 0 to a
bit has no effect and writing 1 clears that line's status flag.
aspeed_gpio_irq_ack() clears a line's status through
aspeed_g4_reg_bit_set(), which reads the bank's status register, sets
the line's bit and writes the whole value back. That write clears every
interrupt pending in the 32-line bank, not just the acked one.

aspeed_gpio_irq_handler() reads each bank's status register once and
dispatches the lines that were set. If another line in the same bank
latches an edge after that read and before an ack in the bank, the ack
clears its status and the handler is never called for it, so the edge
is lost.

Write only the line's own bit when clearing the interrupt status on G4.

Fixes: 79fc9a2fcc45 ("gpio: aspeed: Create llops to handle hardware access")
Cc: stable@vger.kernel.org
Reported-by: Aaron Antone <aae@amazon.com>
Suggested-by: Aaron Antone <aae@amazon.com>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Tested-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20261104-gpio-aspeed-irq-status-v1-1-9805645f856d@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-aspeed.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1041,6 +1041,17 @@ static void aspeed_g4_reg_bit_set(struct
 	void __iomem *addr = aspeed_gpio_g4_bank_reg(gpio, bank, reg);
 	u32 temp;
 
+	/*
+	 * The interrupt status register is write-1-to-clear. Write only this
+	 * line's bit so that interrupts pending on the other lines of the bank
+	 * stay latched.
+	 */
+	if (reg == reg_irq_status) {
+		if (val)
+			iowrite32(GPIO_BIT(offset), addr);
+		return;
+	}
+
 	if (reg == reg_val)
 		temp = gpio->dcache[GPIO_BANK(offset)];
 	else


