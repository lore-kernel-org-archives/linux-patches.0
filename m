Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43883DF007;
	Tue, 16 Jun 2026 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635067; cv=none; b=hAkIoY3x5PrVCdYqAS3V9nV/l6AF6YBcAe4UqBQs605nwNbIPt3C/JtZiNlMoBkQN4/WUsthBcLMta/Ox4JdACcZJvV2ppPce/E78rPJvV9xxXzBZWFF0ZNcFgzMuTwAsRZ81/umKBd6VdfXK9MYYFh3MvIWLrf7YscM5Shcd88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635067; c=relaxed/simple;
	bh=HyjvumuACgLQ/5+6kygdrNUVD+83uTbTI32fqvyjGmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fROesB7wgzUF55k0UPfGO8wjYQZmAMvv/ZDWAWVf8ikHI574rl/cNQfkCswP4CyopRJkY8D/QwCqFDUnCbLNODOiHI8O5ePWaPCSFGEcn/M0H/0eaEMkFSyhNTDy4Qv5NHWUic8UKAeVs8hQ+Xpv19NCT3jXqBzZE+XopTgnGu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxwMmxyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxwMmxyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5821F000E9;
	Tue, 16 Jun 2026 18:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635066;
	bh=Q32RKynozgCx/tXP2uS2AU8eEbHfU+6J6tM+tc0Te9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxwMmxyl4aBYRpC2PC1X/ywuoCTMLvKIx20S7OFg7sFJr2PfIGNEBmwB6oj0+TXHs
	 6CJAcdiaFEu+lgceJLGAz7nYDteTXiRkmfYwnpnWdKgqAiVI1jZTo1gHArIy2A+dW6
	 SaU3Qu7X9mnO2vr4EB0271tvcDiuZWCSv8/rfuy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/411] tty: serial: qcom-geni-serial: align #define values
Date: Tue, 16 Jun 2026 20:30:22 +0530
Message-ID: <20260616145121.671872318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 6cde11dbf4b65170eeefba48df730c93d75e01a3 ]

Keep the #define symbols aligned for better readability.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221229155030.418800-5-brgl@bgdev.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ca2584d841b6 ("serial: qcom-geni: fix UART_RX_PAR_EN bit position")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   60 +++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 30 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -35,57 +35,57 @@
 #define SE_UART_MANUAL_RFR		0x2ac
 
 /* SE_UART_TRANS_CFG */
-#define UART_TX_PAR_EN		BIT(0)
-#define UART_CTS_MASK		BIT(1)
+#define UART_TX_PAR_EN			BIT(0)
+#define UART_CTS_MASK			BIT(1)
 
 /* SE_UART_TX_STOP_BIT_LEN */
-#define TX_STOP_BIT_LEN_1	0
-#define TX_STOP_BIT_LEN_2	2
+#define TX_STOP_BIT_LEN_1		0
+#define TX_STOP_BIT_LEN_2		2
 
 /* SE_UART_RX_TRANS_CFG */
-#define UART_RX_PAR_EN		BIT(3)
+#define UART_RX_PAR_EN			BIT(3)
 
 /* SE_UART_RX_WORD_LEN */
-#define RX_WORD_LEN_MASK	GENMASK(9, 0)
+#define RX_WORD_LEN_MASK		GENMASK(9, 0)
 
 /* SE_UART_RX_STALE_CNT */
-#define RX_STALE_CNT		GENMASK(23, 0)
+#define RX_STALE_CNT			GENMASK(23, 0)
 
 /* SE_UART_TX_PARITY_CFG/RX_PARITY_CFG */
-#define PAR_CALC_EN		BIT(0)
-#define PAR_EVEN		0x00
-#define PAR_ODD			0x01
-#define PAR_SPACE		0x10
+#define PAR_CALC_EN			BIT(0)
+#define PAR_EVEN			0x00
+#define PAR_ODD				0x01
+#define PAR_SPACE			0x10
 
 /* SE_UART_MANUAL_RFR register fields */
-#define UART_MANUAL_RFR_EN	BIT(31)
-#define UART_RFR_NOT_READY	BIT(1)
-#define UART_RFR_READY		BIT(0)
+#define UART_MANUAL_RFR_EN		BIT(31)
+#define UART_RFR_NOT_READY		BIT(1)
+#define UART_RFR_READY			BIT(0)
 
 /* UART M_CMD OP codes */
-#define UART_START_TX		0x1
+#define UART_START_TX			0x1
 /* UART S_CMD OP codes */
-#define UART_START_READ		0x1
+#define UART_START_READ			0x1
 
-#define UART_OVERSAMPLING	32
-#define STALE_TIMEOUT		16
-#define DEFAULT_BITS_PER_CHAR	10
-#define GENI_UART_CONS_PORTS	1
-#define GENI_UART_PORTS		3
-#define DEF_FIFO_DEPTH_WORDS	16
-#define DEF_TX_WM		2
-#define DEF_FIFO_WIDTH_BITS	32
-#define UART_RX_WM		2
+#define UART_OVERSAMPLING		32
+#define STALE_TIMEOUT			16
+#define DEFAULT_BITS_PER_CHAR		10
+#define GENI_UART_CONS_PORTS		1
+#define GENI_UART_PORTS			3
+#define DEF_FIFO_DEPTH_WORDS		16
+#define DEF_TX_WM			2
+#define DEF_FIFO_WIDTH_BITS		32
+#define UART_RX_WM			2
 
 /* SE_UART_LOOPBACK_CFG */
-#define RX_TX_SORTED	BIT(0)
-#define CTS_RTS_SORTED	BIT(1)
-#define RX_TX_CTS_RTS_SORTED	(RX_TX_SORTED | CTS_RTS_SORTED)
+#define RX_TX_SORTED			BIT(0)
+#define CTS_RTS_SORTED			BIT(1)
+#define RX_TX_CTS_RTS_SORTED		(RX_TX_SORTED | CTS_RTS_SORTED)
 
 /* UART pin swap value */
-#define DEFAULT_IO_MACRO_IO0_IO1_MASK		GENMASK(3, 0)
+#define DEFAULT_IO_MACRO_IO0_IO1_MASK	GENMASK(3, 0)
 #define IO_MACRO_IO0_SEL		0x3
-#define DEFAULT_IO_MACRO_IO2_IO3_MASK		GENMASK(15, 4)
+#define DEFAULT_IO_MACRO_IO2_IO3_MASK	GENMASK(15, 4)
 #define IO_MACRO_IO2_IO3_SWAP		0x4640
 
 /* We always configure 4 bytes per FIFO word */


