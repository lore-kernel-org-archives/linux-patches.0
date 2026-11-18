Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018831;
	b=RsDGK248WJh5fRYLal7jiSDScpdk3cXnYb0QfFTpia9pDZqm3/CT8dQY99kmFQFSfGei
	 +yjE18G9MeAlMz2q6qafzSznP5TYXcDN471mH0365Haeh6g5SXYKOPASulM8RK/pSYA5n
	 FpBZ4YvxvHS873DmVbRZKC9OLpINTX2SMpLFtbwbvL3Pm3xumqFtv62tqPhHaMoXGpdCf
	 jQb2UGvYHuo8qmUmmTXBQnedOLLwa/oOL/5N3pYUVFgW5/qOv7Bd9Nrb5OjI0LKA4DUE5
	 FTf2OrMSRB+57gPLFP8mjsiEkW0j8NSChIg4wI0C/ICZbSDabBVwZAjekT6WsYe7jCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TmQiUPyiwlUfWdeO5CNA9K4NaEleRvycqwYYoiZgK5M=;
	b=hqdupmhdQvcxhgaRs37MXqsXbrHNEelGgzJ1/DANFstD56rt8bZJl+NAs/9DPwxvxkqs
	 5D4FokjRkyirPue3JO2aV+1n3YBhUKCgTFg00KtzZXn/4IS1qewQeAzaLIp9+BnkqzOJf
	 z0+HkSXtxPGCO5TPm+eLWdl2FBXJ8c1JUipOUmZS0z3IDiWt3ZJnJpl1yWglpvmsJdFWJ
	 uvMcjJNxC4nXbgatQ8lO3SKFq/hHO3OGgiroz9Se0MsKjJOnHt2B/tMZ8vVcC28jNvKMW
	 2QIKPcu5ebMCrbU5INqRBJbOMGw0QnFRFo7E3eBItJmWT9xzKIA0+/2xX3Z/NdhfbXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g378j7oR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB42606A31C;
	Wed, 18 Nov 2026 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g378j7oR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC751F000C4;
	Wed, 18 Nov 2026 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018831;
	bh=TmQiUPyiwlUfWdeO5CNA9K4NaEleRvycqwYYoiZgK5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g378j7oR14mpoR9pozimETrWsZHGtNUbPRuPPlY7jhx3K6IYxJ9FH+yCKf8Nut3Rj
	 pFe7p0r8RWtAD8AcONh23TB0nJwahZSAuwP3CLpHmpnPh6RqLt7BsOLO1CZFBAGqsh
	 D2Cm2g4G/ZYCubYg0PomDQznKUZO1CdW1tg3S6cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1379/2651] spi: spi-sun4i: sun4i_spi_transfer_one(): fix transfers for SUN4I_FIFO_DEPTH
Date: Wed, 18 Nov 2026 15:43:39 +0100
Message-ID: <20261118150337.671684432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f3ce7a3ca82bd9cda9ef61250aeff65fe6b44809 ]

In commit 6d9fe44bd73d ("spi: sun4i: fix FIFO limit"), the TX-FIFO is
filled max to SUN4I_FIFO_DEPTH - 1 (= 63) bytes to work around timeouts
observed on A10s SoCs.

Commit 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO
size") added support for transfers larger than the FIFO size. But this
commit only enabled the TX-FIFO empty interrupt for transfers larger
than the FIFO (= 64) bytes.

This breaks transfers with exactly 64 bytes: the TX-FIFO is only filled
with 63 bytes but the interrupt to refill the FIFO is not triggered. The
problem can be reproduced with the following command:

| spidev_test -D /dev/spidev0.1 -S 64 -s 20000000 -I 1
|
| [ 7797.548745] spi_master spi0: spi0.1: timeout transferring 64 bytes@20000000Hz for 110(100)ms
| [ 7797.557237] spidev spi0.1: SPI transfer failed: -110
| [ 7797.562308] spi_master spi0: failed to transfer one message from queue
| [ 7797.568936] spi_master spi0: noqueue transfer failed

To fix the problem enable the TX-FIFO interrupt if the total TX length
is larger than SUN4I_FIFO_DEPTH - 1 (= 63) bytes.

Fixes: 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO size")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://patch.msgid.link/20260914-spi-sun4i-fixes-v3-1-9fe919d5cecf@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index d5c16392cd4d7..2e23244539053 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -322,7 +322,7 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 	sun4i_spi_enable_interrupt(sspi, SUN4I_INT_CTL_TC |
 					 SUN4I_INT_CTL_RF_F34);
 	/* Only enable Tx FIFO interrupt if we really need it */
-	if (tx_len > SUN4I_FIFO_DEPTH)
+	if (tx_len > SUN4I_FIFO_DEPTH - 1)
 		sun4i_spi_enable_interrupt(sspi, SUN4I_INT_CTL_TF_E34);
 
 	/* Start the transfer */
-- 
2.53.0



