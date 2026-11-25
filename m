Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623338;
	b=B398iTRA2wPHJ2kLGhFHmC6VtHlJYRsTgYDd/Qaia0kGDbSEPtyVx6dYJPUneuAFnHBM
	 llTsg+H3lbeVXvhmQbc0D9aZk84KruPGXykZMplMovyqrE3FE4zu+OesOux15NMbey0xr
	 rCd7rwUEVyUHIp16/g2CuWRJOGA3UfPmrB0aLO65ql8n9V67N/VAaQukBjEWYGYW1rLft
	 JCSPzBpv/CirrRzuERhaLjvTsj5oyBxvwqSmjj4BpU/G7O6UEdxupVr6eAY4XSJovykpq
	 47gIvYPIyiqLe/1M57gwhZLy7J9zTUBD17P1H4wNfcBTFRxyUOFoaJqdKN8PVjhcdNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ppaaMH/tmVQfy6No/XlaR37RMp/LyeCpgxO/bxVZamg=;
	b=egJmHsWkqt+cE5tRw9O/sgE5rIYqp12K9T5Bp1AKmm6Ebz9ulo31++7XxbtvEzmfX/5p
	 dMEeQdpCpBxBU+4XqR7YpsV+O8wLbJF+rLyfWMCGaUHvtFW2jrUEKoMOZahFGSBxSJ92M
	 WB94RUQ/Hj5rbswbFArrZ2pCf5FeKAM4UsW5iIpYZew46d8NTFY6DbUEn9OAuSClCamK6
	 hsG4ndcQVCR9hm5wvl+CHBCZKL+FBJvIxGUsrWfczBGGGjHFlDGoo//EB+LsJcxLLfGNa
	 9UNKVris5MiJ0/3MDrSxJhNED3YHeQF1Wh87v2U7nh2RBELQxhBJHRfk9eFazfRAyPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UpBVMD/+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B8606A323;
	Wed, 25 Nov 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UpBVMD/+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06E61F000C0;
	Wed, 25 Nov 2026 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623338;
	bh=ppaaMH/tmVQfy6No/XlaR37RMp/LyeCpgxO/bxVZamg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpBVMD/+6XHvodyL5JuV04EPL5MBvIQBYgsACmA2+u5b9zrh6QfnRjM89P+7tB1UZ
	 mzGrZ+HtaX8E3y+mKnBNHhhqqvgP2n5cwjxCax48ylke1v6wUCZc2L/zSufSrqHg59
	 7vE/s7IDkgjd3c/M7uTBZ4oG1Tdi3lUFg43TNXac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Antone <aae@amazon.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 824/990] gpio: aspeed: Clear only the acked lines G4 interrupt status
Date: Wed, 25 Nov 2026 15:36:31 +0100
Message-ID: <20261125143841.337313197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1045,6 +1045,17 @@ static void aspeed_g4_reg_bit_set(struct
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


