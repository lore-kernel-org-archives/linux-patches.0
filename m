Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061443;
	b=dVe14s94lSrF2EXhZOklmKwnPhRH0uEZYiW1R2LLoDLSCwD2+QgO6zEyHl+4+1hEtAID
	 PQP96CykLJtkuDoS1pp41WFOwtLnfDMnXWSJcAMNqRARLJynrfpk4SAQERtJ9gNh7AMfH
	 vubBkwjO3NqYJn+RLhODDxwu6KWh84GeZ4WzJfVGKNyUzEkkfOjKE9lwYtIckJw4tVsV+
	 3rE+RxRGFi4YBsiA2soUPu3RF9aoXwWqdAX/JLKhE6xHlNz5TSYRWK3DJQdbOzcTJN3NZ
	 B2LeB5xNhuO69PRz49dpwg2nGk5fldl4wdn9h/pPnTVx8iWOJe6rva9XGnHyBkLMmjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qzq9isr2gXnK7+R3uYPuUE2gh5ODwjlnn1fuwd1VCfc=;
	b=iXeb/mqWINLykq0rxTrjr0hbONQPjvreygEW4PasgWs23NULItiGrVyJwcrB9Pp9bPAQ
	 IohbKfr3YFSRckcWtUMny+tKzdAt3nbO5RKY5na5xngwEpclt51SiRXSs7BkKhdqt7/A2
	 FLcODD6XJFVgJLXak1FxOmqcB5QO+o3aItELSVTxU5Ns3HsYVbU3X4cFT3NpDXVlAdNLm
	 tC3nCOx7gr7HEwaLnjhG89but4pP6xDPUe8uS8mXd+mrHvx01v4rQTjxyj9HALkWJV43x
	 FNpAn0J/aOJ8yBXQJ6sHih7lbH05j7vEQ6ABOZPwB1zwE+EDOvejDH7GeQm7a44fiqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01B46HL7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC0E606A325;
	Thu, 19 Nov 2026 04:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01B46HL7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5501F000C5;
	Thu, 19 Nov 2026 04:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061442;
	bh=Qzq9isr2gXnK7+R3uYPuUE2gh5ODwjlnn1fuwd1VCfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01B46HL7iI2AdZjX1M4ovUqyBzvYoeZo/TeszPCNhHMNo0dnWhSSzddBZOY3TY78s
	 6XcQ5ZWsNhuiRj8sdlmGFSefE4KtO0TUYd0NThpyC7d2H2W6/NDLdiUOp826jparOi
	 nb/BLZNryKg0ukQBLotJTPFqKR/s4iz2SB6aQ53Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1513/1848] spi: spi-sun4i: sun4i_spi_fill_fifo(): always apply A10 FIFO fill level workaround
Date: Wed, 18 Nov 2026 15:59:11 +0100
Message-ID: <20261118150022.640972126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit ee109e2bbea0986f6ad34bfbcba90fce36f17538 ]

In commit 6d9fe44bd73d ("spi: sun4i: fix FIFO limit"), the TX FIFO is
filled max to SUN4I_FIFO_DEPTH - 1 (= 63) bytes to work around
timeouts observed on A10s SoCs.

Commit 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO
size") added support for transfers larger than the FIFO size. This
commit did not consider the A10 workaround (limit the TX FIFO fill
size to SUN4I_FIFO_DEPTH - 1 (= 63) bytes) for refilling the TX FIFO
in the IRQ handler.

To apply the workaround independent from where sun4i_spi_fill_fifo()
is called, remove the length argument from the function and directly
take the max fill level of SUN4I_FIFO_DEPTH - 1 into account when
calculating the free space in the FIFO.

Due to the lack of HW this patch has not been tested on an A10 SoC,
but on an A20 SoC. It was not possible to reproduce the timeout on the
A20.

Fixes: 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO size")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://patch.msgid.link/20260914-spi-sun4i-fixes-v3-2-9fe919d5cecf@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 3e2ed10510398..de7155928ad8d 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -142,15 +142,21 @@ static inline void sun4i_spi_drain_fifo(struct sun4i_spi *sspi, int len)
 	}
 }
 
-static inline void sun4i_spi_fill_fifo(struct sun4i_spi *sspi, int len)
+static inline void sun4i_spi_fill_fifo(struct sun4i_spi *sspi)
 {
 	u32 cnt;
+	int len;
 	u8 byte;
 
-	/* See how much data we can fit */
-	cnt = SUN4I_FIFO_DEPTH - sun4i_spi_get_tx_fifo_count(sspi);
+	/*
+	 * See how much data we can fit
+	 *
+	 * Filling the FIFO fully causes timeout for some reason
+	 * at least on spi2 on A10s
+	 */
+	cnt = SUN4I_FIFO_DEPTH - 1 - sun4i_spi_get_tx_fifo_count(sspi);
 
-	len = min3(len, (int)cnt, sspi->len);
+	len = min_t(int, cnt, sspi->len);
 
 	while (len--) {
 		byte = sspi->tx_buf ? *sspi->tx_buf++ : 0;
@@ -310,12 +316,8 @@ static int sun4i_spi_transfer_one(struct spi_master *master,
 	sun4i_spi_write(sspi, SUN4I_BURST_CNT_REG, SUN4I_BURST_CNT(tfr->len));
 	sun4i_spi_write(sspi, SUN4I_XMIT_CNT_REG, SUN4I_XMIT_CNT(tx_len));
 
-	/*
-	 * Fill the TX FIFO
-	 * Filling the FIFO fully causes timeout for some reason
-	 * at least on spi2 on A10s
-	 */
-	sun4i_spi_fill_fifo(sspi, SUN4I_FIFO_DEPTH - 1);
+	/* Fill the TX FIFO */
+	sun4i_spi_fill_fifo(sspi);
 
 	/* Enable the interrupts */
 	sun4i_spi_enable_interrupt(sspi, SUN4I_INT_CTL_TC |
@@ -372,7 +374,7 @@ static irqreturn_t sun4i_spi_handler(int irq, void *dev_id)
 
 	/* Transmit FIFO 3/4 empty */
 	if (status & SUN4I_INT_CTL_TF_E34) {
-		sun4i_spi_fill_fifo(sspi, SUN4I_FIFO_DEPTH);
+		sun4i_spi_fill_fifo(sspi);
 
 		if (!sspi->len)
 			/* nothing left to transmit */
-- 
2.53.0



