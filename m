Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025669;
	b=V86Z8OgvymlDuEIZ4L1glfD1wRaY3TKZ1MOciFh2hICrtNkUS1/6gHnRvvIyccum49gW
	 aXhkY627tOtDHRDzKwRL0NjahakJQRNtAnCIfvvgezaZSYH35dZe7IsM85gDueHeL0Zn+
	 0o5xndeLPM2d+5P7KINtHZFDDYUA6QiyQaHMttDAuozGxfOjqrCXENoLEqAnaM0j0Kb4H
	 KBEZ33oYskCEqIoD3DwTr0zptgigHt7CjABp3aZx0Oh7Dhvk1vy5lshwTvxDychrmdLIK
	 MXBh5NbeEcuVRj8kAIJ9wKK6e6r6a9V+ciHPta5TeAc/RI0RWFFChdzF7mIeN6n4c9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9p8gTsAxCdbvnmd+cLSazzaZnFJoZ9o5R94C/ksz0bk=;
	b=VVBNmzx4q2Wxiu7KRE35MNl6niZM4umKnqubaHtuFtdzxXSaIHaJKj9+QdW8hJokcToN
	 OZNmRtEFwjq/IGK3VKQP8Ofm4faY5naKXaKIGJS6Wa+LuoFCnYCFGsYaZqUH1WdHrC2hC
	 pRyH2AE8HtiC7cR7P6ohmJKX/M+9etRAc2N8bJH/VDyEIJkPapKXcfhMCMcME77XxODht
	 /48PHc4xgMavfs3Vb90r9QrNrtYgpx7pGW4enaZtSbdqTfKBp42ChwtAeIgCkhrG3AIF6
	 f9cov9pS6/Y3xlJn4ReSWJVWd1BH3vG0ieLPI6lWgJOermw5Vp2jULw7RxFwG6j3/Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA3QMiA7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B6C606A31C;
	Wed, 18 Nov 2026 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA3QMiA7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8073D1F000C4;
	Wed, 18 Nov 2026 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025669;
	bh=9p8gTsAxCdbvnmd+cLSazzaZnFJoZ9o5R94C/ksz0bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AA3QMiA7wOstsVta2i1Tab3mHwJ4JMlRySVr0sHCb3iKlYNutzozgjyOGyqQGrnpA
	 NsvHYiUU+MbDlx+Bh1cVGRy04L1rqcHFvMXkrNTaje4Yh4/9lkISl5j5Oo6IwcK2cU
	 6SB/QU6INU8N6FB/BEKUW0HwHtFqOtSSCXi1Vqfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1162/2151] spi: spi-sun4i: sun4i_spi_transfer_one(): fix setting of clock rate
Date: Wed, 18 Nov 2026 15:48:17 +0100
Message-ID: <20261118150204.493898145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index b19c84d5c5db4..0a20bc19b1c3b 100644
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



