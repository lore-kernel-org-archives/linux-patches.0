Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC6484227;
	Tue, 25 Aug 2026 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665621; cv=none; b=lSYEvbBlpBu9LIjQsHpFVsphBaXR5vpOwYP+DpBbflLXMd2svcw8QmSTTJNh4r1sE+ONBBD0BMyrrIL6LrrfDZ6EoxdrbRw20krQtRpQi6l4PttEVYFaXFVHU4nTok+7kQkNN9E6kr6Q854da106Pf9gyeHHw3b2ZcdhO2xQ1SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665621; c=relaxed/simple;
	bh=VGqOHnaqpvyVHx5kIoYqK0x7GkD1HrN54+uQmsWkjtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCTXSku9pD/s4xHQBt4XG8VZHLkacFnQBLapI9QzC+Rhp6a5ki+ipdmQV8vuEvfyyN05gJPEgh54rjF8rq6gfDdVxiQuD0ISxn7hJ9BbTpASA1cNrNZDAQY6Nhh+/RvA+HbwSkTHmsmNryTq7fCBaMKV4KSfR+O76XseP1aeINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSkDtIdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSkDtIdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9731F000E9;
	Tue, 25 Aug 2026 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665619;
	bh=KrmyubuB1bZC3u2e0CZkY1AxayFgtxXVRi8IV1Ho8yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSkDtIdqhsyCY0ff1CGxRnLZ6CU7DR92EDNGrUT0sJ/RzQiMEzihqIJVs2tZIkl/c
	 GZShv28UKTLirowPgNMjcwXY9T62kQ3cuI4QGQcKBu1sdy3w0jEd5xf+cDB2RAaxef
	 +LQcsXFqGqgVc/WnyTwCN3kNXKfc9TjsQo+V+9AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lech Perczak <lech.perczak@camlingroup.com>,
	Andy Shevchenko <andy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/87] serial: sc16is7xx: convert bitmask definitions to use BIT() macro
Date: Tue, 25 Aug 2026 15:25:33 +0200
Message-ID: <20260825132542.228435403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lech Perczak <lech.perczak@camlingroup.com>

[ Upstream commit d2e8590fd1048c5c0dba160edc6a48ee8305a1f0 ]

Now that bit definition comments were cleaned up, convert bitmask
definitions to use BIT() macro for clarity.
Convert SC16IS7XX_IIR_ID_MASK to use GENMASK() macro -
- while at that, realign comments.
Compose SC16IS7XX_LSR_BRK_ERROR_MASK using aforementioned constants,
instead of open-coding it, and remove now unneeded comments.

Signed-off-by: Lech Perczak <lech.perczak@camlingroup.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/8b45a01e-7cc5-4d53-b467-c6680bc51ef4@camlingroup.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 246ac114f485 ("serial: sc16is7xx: enable THRI before filling TX FIFO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |  176 +++++++++++++++++++++--------------------
 1 file changed, 91 insertions(+), 85 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -9,6 +9,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bitops.h>
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -73,52 +74,52 @@
 #define SC16IS7XX_XOFF2_REG		(0x07) /* Xoff2 word */
 
 /* IER register bits */
-#define SC16IS7XX_IER_RDI_BIT		(1 << 0) /* Enable RX data interrupt */
-#define SC16IS7XX_IER_THRI_BIT		(1 << 1) /* Enable TX holding register
+#define SC16IS7XX_IER_RDI_BIT		BIT(0)   /* Enable RX data interrupt */
+#define SC16IS7XX_IER_THRI_BIT		BIT(1)   /* Enable TX holding register
 						  * interrupt */
-#define SC16IS7XX_IER_RLSI_BIT		(1 << 2) /* Enable RX line status
+#define SC16IS7XX_IER_RLSI_BIT		BIT(2)   /* Enable RX line status
 						  * interrupt */
-#define SC16IS7XX_IER_MSI_BIT		(1 << 3) /* Enable Modem status
+#define SC16IS7XX_IER_MSI_BIT		BIT(3)   /* Enable Modem status
 						  * interrupt */
 
 /* IER register bits - write only if (EFR[4] == 1) */
-#define SC16IS7XX_IER_SLEEP_BIT		(1 << 4) /* Enable Sleep mode */
-#define SC16IS7XX_IER_XOFFI_BIT		(1 << 5) /* Enable Xoff interrupt */
-#define SC16IS7XX_IER_RTSI_BIT		(1 << 6) /* Enable nRTS interrupt */
-#define SC16IS7XX_IER_CTSI_BIT		(1 << 7) /* Enable nCTS interrupt */
+#define SC16IS7XX_IER_SLEEP_BIT		BIT(4)   /* Enable Sleep mode */
+#define SC16IS7XX_IER_XOFFI_BIT		BIT(5)   /* Enable Xoff interrupt */
+#define SC16IS7XX_IER_RTSI_BIT		BIT(6)   /* Enable nRTS interrupt */
+#define SC16IS7XX_IER_CTSI_BIT		BIT(7)   /* Enable nCTS interrupt */
 
 /* FCR register bits */
-#define SC16IS7XX_FCR_FIFO_BIT		(1 << 0) /* Enable FIFO */
-#define SC16IS7XX_FCR_RXRESET_BIT	(1 << 1) /* Reset RX FIFO */
-#define SC16IS7XX_FCR_TXRESET_BIT	(1 << 2) /* Reset TX FIFO */
-#define SC16IS7XX_FCR_RXLVLL_BIT	(1 << 6) /* RX Trigger level LSB */
-#define SC16IS7XX_FCR_RXLVLH_BIT	(1 << 7) /* RX Trigger level MSB */
+#define SC16IS7XX_FCR_FIFO_BIT		BIT(0)   /* Enable FIFO */
+#define SC16IS7XX_FCR_RXRESET_BIT	BIT(1)   /* Reset RX FIFO */
+#define SC16IS7XX_FCR_TXRESET_BIT	BIT(2)   /* Reset TX FIFO */
+#define SC16IS7XX_FCR_RXLVLL_BIT	BIT(6)   /* RX Trigger level LSB */
+#define SC16IS7XX_FCR_RXLVLH_BIT	BIT(7)   /* RX Trigger level MSB */
 
 /* FCR register bits - write only if (EFR[4] == 1) */
-#define SC16IS7XX_FCR_TXLVLL_BIT	(1 << 4) /* TX Trigger level LSB */
-#define SC16IS7XX_FCR_TXLVLH_BIT	(1 << 5) /* TX Trigger level MSB */
+#define SC16IS7XX_FCR_TXLVLL_BIT	BIT(4)   /* TX Trigger level LSB */
+#define SC16IS7XX_FCR_TXLVLH_BIT	BIT(5)   /* TX Trigger level MSB */
 
 /* IIR register bits */
-#define SC16IS7XX_IIR_NO_INT_BIT	(1 << 0) /* No interrupts pending */
-#define SC16IS7XX_IIR_ID_MASK		0x3e     /* Mask for the interrupt ID */
-#define SC16IS7XX_IIR_THRI_SRC		0x02     /* TX holding register empty */
-#define SC16IS7XX_IIR_RDI_SRC		0x04     /* RX data interrupt */
-#define SC16IS7XX_IIR_RLSE_SRC		0x06     /* RX line status error */
-#define SC16IS7XX_IIR_RTOI_SRC		0x0c     /* RX time-out interrupt */
-#define SC16IS7XX_IIR_MSI_SRC		0x00     /* Modem status interrupt
-						  * - only on 75x/76x
-						  */
-#define SC16IS7XX_IIR_INPIN_SRC		0x30     /* Input pin change of state
-						  * - only on 75x/76x
-						  */
-#define SC16IS7XX_IIR_XOFFI_SRC		0x10     /* Received Xoff */
-#define SC16IS7XX_IIR_CTSRTS_SRC	0x20     /* nCTS,nRTS change of state
-						  * from active (LOW)
-						  * to inactive (HIGH)
-						  */
+#define SC16IS7XX_IIR_NO_INT_BIT	0x01		/* No interrupts pending */
+#define SC16IS7XX_IIR_ID_MASK		GENMASK(5, 1)	/* Mask for the interrupt ID */
+#define SC16IS7XX_IIR_THRI_SRC		0x02		/* TX holding register empty */
+#define SC16IS7XX_IIR_RDI_SRC		0x04		/* RX data interrupt */
+#define SC16IS7XX_IIR_RLSE_SRC		0x06		/* RX line status error */
+#define SC16IS7XX_IIR_RTOI_SRC		0x0c		/* RX time-out interrupt */
+#define SC16IS7XX_IIR_MSI_SRC		0x00		/* Modem status interrupt
+							 * - only on 75x/76x
+							 */
+#define SC16IS7XX_IIR_INPIN_SRC		0x30		/* Input pin change of state
+							 * - only on 75x/76x
+							 */
+#define SC16IS7XX_IIR_XOFFI_SRC		0x10		/* Received Xoff */
+#define SC16IS7XX_IIR_CTSRTS_SRC	0x20		/* nCTS,nRTS change of state
+							 * from active (LOW)
+							 * to inactive (HIGH)
+							 */
 /* LCR register bits */
-#define SC16IS7XX_LCR_LENGTH0_BIT	(1 << 0) /* Word length bit 0 */
-#define SC16IS7XX_LCR_LENGTH1_BIT	(1 << 1) /* Word length bit 1
+#define SC16IS7XX_LCR_LENGTH0_BIT	BIT(0)   /* Word length bit 0 */
+#define SC16IS7XX_LCR_LENGTH1_BIT	BIT(1)   /* Word length bit 1
 						  *
 						  * Word length bits table:
 						  * 00 -> 5 bit words
@@ -126,7 +127,7 @@
 						  * 10 -> 7 bit words
 						  * 11 -> 8 bit words
 						  */
-#define SC16IS7XX_LCR_STOPLEN_BIT	(1 << 2) /* STOP length bit
+#define SC16IS7XX_LCR_STOPLEN_BIT	BIT(2)   /* STOP length bit
 						  *
 						  * STOP length bit table:
 						  * 0 -> 1 stop bit
@@ -134,11 +135,11 @@
 						  *      word length is 5,
 						  *      2 stop bits otherwise
 						  */
-#define SC16IS7XX_LCR_PARITY_BIT	(1 << 3) /* Parity bit enable */
-#define SC16IS7XX_LCR_EVENPARITY_BIT	(1 << 4) /* Even parity bit enable */
-#define SC16IS7XX_LCR_FORCEPARITY_BIT	(1 << 5) /* 9-bit multidrop parity */
-#define SC16IS7XX_LCR_TXBREAK_BIT	(1 << 6) /* TX break enable */
-#define SC16IS7XX_LCR_DLAB_BIT		(1 << 7) /* Divisor Latch enable */
+#define SC16IS7XX_LCR_PARITY_BIT	BIT(3)   /* Parity bit enable */
+#define SC16IS7XX_LCR_EVENPARITY_BIT	BIT(4)   /* Even parity bit enable */
+#define SC16IS7XX_LCR_FORCEPARITY_BIT	BIT(5)   /* 9-bit multidrop parity */
+#define SC16IS7XX_LCR_TXBREAK_BIT	BIT(6)   /* TX break enable */
+#define SC16IS7XX_LCR_DLAB_BIT		BIT(7)   /* Divisor Latch enable */
 #define SC16IS7XX_LCR_WORD_LEN_5	(0x00)
 #define SC16IS7XX_LCR_WORD_LEN_6	(0x01)
 #define SC16IS7XX_LCR_WORD_LEN_7	(0x02)
@@ -149,58 +150,63 @@
 								* reg set */
 
 /* MCR register bits */
-#define SC16IS7XX_MCR_DTR_BIT		(1 << 0) /* DTR complement
+#define SC16IS7XX_MCR_DTR_BIT		BIT(0)   /* DTR complement
 						  * - only on 75x/76x
 						  */
-#define SC16IS7XX_MCR_RTS_BIT		(1 << 1) /* RTS complement */
-#define SC16IS7XX_MCR_TCRTLR_BIT	(1 << 2) /* TCR/TLR register enable */
-#define SC16IS7XX_MCR_LOOP_BIT		(1 << 4) /* Enable loopback test mode */
-#define SC16IS7XX_MCR_XONANY_BIT	(1 << 5) /* Enable Xon Any
+#define SC16IS7XX_MCR_RTS_BIT		BIT(1)   /* RTS complement */
+#define SC16IS7XX_MCR_TCRTLR_BIT	BIT(2)   /* TCR/TLR register enable */
+#define SC16IS7XX_MCR_LOOP_BIT		BIT(4)   /* Enable loopback test mode */
+#define SC16IS7XX_MCR_XONANY_BIT	BIT(5)   /* Enable Xon Any
 						  * - write enabled
 						  * if (EFR[4] == 1)
 						  */
-#define SC16IS7XX_MCR_IRDA_BIT		(1 << 6) /* Enable IrDA mode
+#define SC16IS7XX_MCR_IRDA_BIT		BIT(6)   /* Enable IrDA mode
 						  * - write enabled
 						  * if (EFR[4] == 1)
 						  */
-#define SC16IS7XX_MCR_CLKSEL_BIT	(1 << 7) /* Divide clock by 4
+#define SC16IS7XX_MCR_CLKSEL_BIT	BIT(7)   /* Divide clock by 4
 						  * - write enabled
 						  * if (EFR[4] == 1)
 						  */
 
 /* LSR register bits */
-#define SC16IS7XX_LSR_DR_BIT		(1 << 0) /* Receiver data ready */
-#define SC16IS7XX_LSR_OE_BIT		(1 << 1) /* Overrun Error */
-#define SC16IS7XX_LSR_PE_BIT		(1 << 2) /* Parity Error */
-#define SC16IS7XX_LSR_FE_BIT		(1 << 3) /* Frame Error */
-#define SC16IS7XX_LSR_BI_BIT		(1 << 4) /* Break Interrupt */
-#define SC16IS7XX_LSR_BRK_ERROR_MASK	0x1E     /* BI, FE, PE, OE bits */
-#define SC16IS7XX_LSR_THRE_BIT		(1 << 5) /* TX holding register empty */
-#define SC16IS7XX_LSR_TEMT_BIT		(1 << 6) /* Transmitter empty */
-#define SC16IS7XX_LSR_FIFOE_BIT		(1 << 7) /* Fifo Error */
+#define SC16IS7XX_LSR_DR_BIT		BIT(0)   /* Receiver data ready */
+#define SC16IS7XX_LSR_OE_BIT		BIT(1)   /* Overrun Error */
+#define SC16IS7XX_LSR_PE_BIT		BIT(2)   /* Parity Error */
+#define SC16IS7XX_LSR_FE_BIT		BIT(3)   /* Frame Error */
+#define SC16IS7XX_LSR_BI_BIT		BIT(4)   /* Break Interrupt */
+#define SC16IS7XX_LSR_BRK_ERROR_MASK \
+	(SC16IS7XX_LSR_OE_BIT | \
+	 SC16IS7XX_LSR_PE_BIT | \
+	 SC16IS7XX_LSR_FE_BIT | \
+	 SC16IS7XX_LSR_BI_BIT)
+
+#define SC16IS7XX_LSR_THRE_BIT		BIT(5)   /* TX holding register empty */
+#define SC16IS7XX_LSR_TEMT_BIT		BIT(6)   /* Transmitter empty */
+#define SC16IS7XX_LSR_FIFOE_BIT		BIT(7)   /* Fifo Error */
 
 /* MSR register bits */
-#define SC16IS7XX_MSR_DCTS_BIT		(1 << 0) /* Delta CTS Clear To Send */
-#define SC16IS7XX_MSR_DDSR_BIT		(1 << 1) /* Delta DSR Data Set Ready
+#define SC16IS7XX_MSR_DCTS_BIT		BIT(0)   /* Delta CTS Clear To Send */
+#define SC16IS7XX_MSR_DDSR_BIT		BIT(1)   /* Delta DSR Data Set Ready
 						  * or (IO4)
 						  * - only on 75x/76x
 						  */
-#define SC16IS7XX_MSR_DRI_BIT		(1 << 2) /* Delta RI Ring Indicator
+#define SC16IS7XX_MSR_DRI_BIT		BIT(2)   /* Delta RI Ring Indicator
 						  * or (IO7)
 						  * - only on 75x/76x
 						  */
-#define SC16IS7XX_MSR_DCD_BIT		(1 << 3) /* Delta CD Carrier Detect
+#define SC16IS7XX_MSR_DCD_BIT		BIT(3)   /* Delta CD Carrier Detect
 						  * or (IO6)
 						  * - only on 75x/76x
 						  */
-#define SC16IS7XX_MSR_CTS_BIT		(1 << 4) /* CTS */
-#define SC16IS7XX_MSR_DSR_BIT		(1 << 5) /* DSR (IO4)
+#define SC16IS7XX_MSR_CTS_BIT		BIT(4)   /* CTS */
+#define SC16IS7XX_MSR_DSR_BIT		BIT(5)   /* DSR (IO4)
 						  * - only on 75x/76x
 						  */
-#define SC16IS7XX_MSR_RI_BIT		(1 << 6) /* RI (IO7)
+#define SC16IS7XX_MSR_RI_BIT		BIT(6)   /* RI (IO7)
 						  * - only on 75x/76x
 						  */
-#define SC16IS7XX_MSR_CD_BIT		(1 << 7) /* CD (IO6)
+#define SC16IS7XX_MSR_CD_BIT		BIT(7)   /* CD (IO6)
 						  * - only on 75x/76x
 						  */
 #define SC16IS7XX_MSR_DELTA_MASK	0x0F     /* Any of the delta bits! */
@@ -236,19 +242,19 @@
 #define SC16IS7XX_TLR_RX_TRIGGER(words)	((((words) / 4) & 0x0f) << 4)
 
 /* IOControl register bits (Only 750/760) */
-#define SC16IS7XX_IOCONTROL_LATCH_BIT	(1 << 0) /* Enable input latching */
-#define SC16IS7XX_IOCONTROL_MODEM_A_BIT	(1 << 1) /* Enable GPIO[7:4] as modem A pins */
-#define SC16IS7XX_IOCONTROL_MODEM_B_BIT	(1 << 2) /* Enable GPIO[3:0] as modem B pins */
-#define SC16IS7XX_IOCONTROL_SRESET_BIT	(1 << 3) /* Software Reset */
+#define SC16IS7XX_IOCONTROL_LATCH_BIT	BIT(0)   /* Enable input latching */
+#define SC16IS7XX_IOCONTROL_MODEM_A_BIT	BIT(1)   /* Enable GPIO[7:4] as modem A pins */
+#define SC16IS7XX_IOCONTROL_MODEM_B_BIT	BIT(2)   /* Enable GPIO[3:0] as modem B pins */
+#define SC16IS7XX_IOCONTROL_SRESET_BIT	BIT(3)   /* Software Reset */
 
 /* EFCR register bits */
-#define SC16IS7XX_EFCR_9BIT_MODE_BIT	(1 << 0) /* Enable 9-bit or Multidrop
+#define SC16IS7XX_EFCR_9BIT_MODE_BIT	BIT(0)   /* Enable 9-bit or Multidrop
 						  * mode (RS485) */
-#define SC16IS7XX_EFCR_RXDISABLE_BIT	(1 << 1) /* Disable receiver */
-#define SC16IS7XX_EFCR_TXDISABLE_BIT	(1 << 2) /* Disable transmitter */
-#define SC16IS7XX_EFCR_AUTO_RS485_BIT	(1 << 4) /* Auto RS485 RTS direction */
-#define SC16IS7XX_EFCR_RTS_INVERT_BIT	(1 << 5) /* RTS output inversion */
-#define SC16IS7XX_EFCR_IRDA_MODE_BIT	(1 << 7) /* IrDA mode
+#define SC16IS7XX_EFCR_RXDISABLE_BIT	BIT(1)   /* Disable receiver */
+#define SC16IS7XX_EFCR_TXDISABLE_BIT	BIT(2)   /* Disable transmitter */
+#define SC16IS7XX_EFCR_AUTO_RS485_BIT	BIT(4)   /* Auto RS485 RTS direction */
+#define SC16IS7XX_EFCR_RTS_INVERT_BIT	BIT(5)   /* RTS output inversion */
+#define SC16IS7XX_EFCR_IRDA_MODE_BIT	BIT(7)   /* IrDA mode
 						  * 0 = rate upto 115.2 kbit/s
 						  *   - Only 750/760
 						  * 1 = rate upto 1.152 Mbit/s
@@ -256,15 +262,15 @@
 						  */
 
 /* EFR register bits */
-#define SC16IS7XX_EFR_AUTORTS_BIT	(1 << 6) /* Auto RTS flow ctrl enable */
-#define SC16IS7XX_EFR_AUTOCTS_BIT	(1 << 7) /* Auto CTS flow ctrl enable */
-#define SC16IS7XX_EFR_XOFF2_DETECT_BIT	(1 << 5) /* Enable Xoff2 detection */
-#define SC16IS7XX_EFR_ENABLE_BIT	(1 << 4) /* Enable enhanced functions
+#define SC16IS7XX_EFR_AUTORTS_BIT	BIT(6)   /* Auto RTS flow ctrl enable */
+#define SC16IS7XX_EFR_AUTOCTS_BIT	BIT(7)   /* Auto CTS flow ctrl enable */
+#define SC16IS7XX_EFR_XOFF2_DETECT_BIT	BIT(5)   /* Enable Xoff2 detection */
+#define SC16IS7XX_EFR_ENABLE_BIT	BIT(4)   /* Enable enhanced functions
 						  * and writing to IER[7:4],
 						  * FCR[5:4], MCR[7:5]
 						  */
-#define SC16IS7XX_EFR_SWFLOW3_BIT	(1 << 3)
-#define SC16IS7XX_EFR_SWFLOW2_BIT	(1 << 2)
+#define SC16IS7XX_EFR_SWFLOW3_BIT	BIT(3)
+#define SC16IS7XX_EFR_SWFLOW2_BIT	BIT(2)
 						 /*
 						  * SWFLOW bits 3 & 2 table:
 						  * 00 -> no transmitter flow
@@ -277,8 +283,8 @@
 						  *       XON1, XON2, XOFF1 and
 						  *       XOFF2
 						  */
-#define SC16IS7XX_EFR_SWFLOW1_BIT	(1 << 1)
-#define SC16IS7XX_EFR_SWFLOW0_BIT	(1 << 0)
+#define SC16IS7XX_EFR_SWFLOW1_BIT	BIT(1)
+#define SC16IS7XX_EFR_SWFLOW0_BIT	BIT(0)
 						 /*
 						  * SWFLOW bits 1 & 0 table:
 						  * 00 -> no received flow
@@ -311,9 +317,9 @@ struct sc16is7xx_devtype {
 	int	nr_uart;
 };
 
-#define SC16IS7XX_RECONF_MD		(1 << 0)
-#define SC16IS7XX_RECONF_IER		(1 << 1)
-#define SC16IS7XX_RECONF_RS485		(1 << 2)
+#define SC16IS7XX_RECONF_MD		BIT(0)
+#define SC16IS7XX_RECONF_IER		BIT(1)
+#define SC16IS7XX_RECONF_RS485		BIT(2)
 
 struct sc16is7xx_one_config {
 	unsigned int			flags;


