Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031165;
	b=lozzxQ5wYibLOnn/8NqehKHOUReP32rHW+0FNYeOpISiGTJX8jvN7d0F4H1NKSlGws/Z
	 OPEPMfvvfh/zf9S59jX7IuMOeXvllJTBAWT9QmOJU0b5DJ9PNcRtyjx3FEzCyb5knQoMt
	 wL0gvHKYgMZEtQKSxRZmhYEcq8FMg6vGx9tZ8wogII2nmsatO00u/AVX5bhkSzguU2lTj
	 pyTLckR7In2PUCXv6a33nT/PrDJEJkw7zJnmUqQxzGqFYzamDXFO4Xs32VmNWuXuXGgmq
	 VCxG1u3kdnByj58zM7zJaCsvWnPioBWt1/QPr8gNYP1rWACYwOkjPtWo+nUp/XIQTOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BFRet/tkoJF2NrZ8ywJ5+mR6eOP+PJUq7aL+3J279M4=;
	b=h8+0e8WwTPZVktwYFsOehz9wVPnjebEBIAR/A4ZsV7pXr2hLn8AyaVz5QC3Vc5B6oMih
	 eNM2iJPaGivxZzjORL26ZXjZqT3cNC8SobvmESH3u907LYBynFqv/fYTUTXjGMVRQ7hJa
	 IiAeepDEEdFDYPsanr/77njO9ZadQHGjnt5kKShwsI5T4tOVhob5T6Ha+QOl7ddX8+hQH
	 MnrGKKOPkNYghPFL+T4m4X8433l8Gy15rFoFLoofmy7FV2bBccxa9vbyiMfsrAela3w27
	 QB8jCcfYCAOxybZFwV9bksfnsxXc9gcKY6nLxpKl9hUi1BiUNM/w0sxgOgigg7z6VNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F8z4RNpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E34606A325;
	Wed, 18 Nov 2026 19:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F8z4RNpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77C71F000D4;
	Wed, 18 Nov 2026 19:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031165;
	bh=BFRet/tkoJF2NrZ8ywJ5+mR6eOP+PJUq7aL+3J279M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8z4RNpIyCRQZ9z9KxvNNw/gCDiFOGxcyaUtvVqGouSIMYEqA+BjtZy0XdDlPG5Qx
	 pGZnYnVkZPJfwrOb/Jhs+0keeqGDsTlBKn4g/ZSS+XK8Vhtl4MIJDnC1sh1/zsBoAJ
	 aebLi4MYyqRPKOKxpXQlHungaH55iK50veIMhv+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0925/1756] spi: spi-sun4i: sun4i_spi_transfer_one(): fix setting of clock rate
Date: Wed, 18 Nov 2026 15:50:52 +0100
Message-ID: <20261118150046.793144540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 672ba6d88324f223634dd2dc4098f6fb6b346b25 ]

A SPI transfer defines the _maximum_ speed of the SPI transfer. However
the driver doesn't take into account that the clock divider is always
rounded down (due to integer arithmetic). This results in a too high
clock rate for the SPI transfer.

E.g.: with an mclk_rate of 24 MHz and an SPI transfer speed of 10 MHz,
the original code calculates a reg of "0", which results in an effective
divider of "2" and a 12 MHz clock for the SPI transfer.

Use DIV_ROUND_UP() instead of a plain integer division to fix the
problem.

While there simplify the divider calculation for the CDR1 case, use
order_base_2() instead of two ilog2() calculations.

Fixes: b5f6517948cc ("spi: sunxi: Add Allwinner A10 SPI controller driver")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://patch.msgid.link/20260914-spi-sun4i-fixes-v3-3-9fe919d5cecf@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 9b21d3b945b35..59e8a82cd8b64 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -212,7 +212,7 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 				  struct spi_transfer *tfr)
 {
 	struct sun4i_spi *sspi = spi_controller_get_devdata(host);
-	unsigned int mclk_rate, div;
+	unsigned int mclk_rate, div, div_cdr1, div_cdr2;
 	unsigned long time_left;
 	unsigned int start, end, tx_time;
 	unsigned int tx_len = 0;
@@ -296,15 +296,13 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 	 * First try CDR2, and if we can't reach the expected
 	 * frequency, fall back to CDR1.
 	 */
-	div = mclk_rate / (2 * tfr->speed_hz);
-	if (div <= (SUN4I_CLK_CTL_CDR2_MASK + 1)) {
-		if (div > 0)
-			div--;
-
-		reg = SUN4I_CLK_CTL_CDR2(div) | SUN4I_CLK_CTL_DRS;
+	div_cdr1 = DIV_ROUND_UP(mclk_rate, tfr->speed_hz);
+	div_cdr2 = DIV_ROUND_UP(div_cdr1, 2);
+	if (div_cdr2 <= (SUN4I_CLK_CTL_CDR2_MASK + 1)) {
+		reg = SUN4I_CLK_CTL_CDR2(div_cdr2 - 1) | SUN4I_CLK_CTL_DRS;
 	} else {
-		div = ilog2(mclk_rate) - ilog2(tfr->speed_hz);
-		reg = SUN4I_CLK_CTL_CDR1(div);
+		div = min(SUN4I_CLK_CTL_CDR1_MASK + 1, order_base_2(div_cdr1));
+		reg = SUN4I_CLK_CTL_CDR1(div - 1);
 	}
 
 	sun4i_spi_write(sspi, SUN4I_CLK_CTL_REG, reg);
-- 
2.53.0



