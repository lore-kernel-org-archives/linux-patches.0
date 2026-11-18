Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055849;
	b=dD5uJ+I+6oWDamdA1LO5vZRkekxvxat6tbvciHEXiK5yszfKkyLRzYRdpkbJu8wDl64X
	 sPBvDk6BiypnfQ7gdTqbE/MsyHCFrQ/fDvc2KAhcR9EapoLF8lA8fACUvzktiO26UJ+GI
	 QFYi4kS1ZrY6Dvf7kocH7r5Ios0mwQZEx0fntfHNm3fNwzLr4rn9gVN5rsVU+/VSXGucH
	 VnEXivdoiRoj65AoOJMzSD8t6GCUOiZnTNqrJt4pvIEjgI5rpI6sObWPE8961RgFFLfvr
	 PeZz/HmNmqTdsn6MPpkZO4LKm4jwVLVfg6corfwpuGXQdVj1ZxnvsGsN0uQ8RQsyBLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yYBMVwYu7nl9e97ZWsVM9GSny9VWBLJqFDRAzFKdAEY=;
	b=TF8JeqQnP8sn+GgXb1/aqCEDuNrcpfanzebYq6vQnKjQ5KoEr8Y9yUgVHp5fKflo5EPG
	 VgeUTq1Qr8dRTedKKHLdJsC5OlNbSl+CdIWI6fnZlj6wTOgUF4ccCbFs4AyExj08kKzg9
	 +OmRvyRpsnSpc6dM41JoLYSsZf19m0wxTzF6WxuAJPcoHWvokzDbTRIAGgOz3uwIDFaji
	 acP2ePZzn4KQ03E3aWbCBymg8M+Lb0FYY21APOh46TX+1UboHdoGlJiF426RQi3+6sLE5
	 I7Krg7MZ6wk3JhcC5/qfhbYnv4O34pWQbWLieKUOd+0cAyxGtE7H7sb0aFZ5okIA9HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q5Oi0Zv8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA0C606A331;
	Thu, 19 Nov 2026 02:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q5Oi0Zv8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D931F000C4;
	Thu, 19 Nov 2026 02:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055848;
	bh=yYBMVwYu7nl9e97ZWsVM9GSny9VWBLJqFDRAzFKdAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5Oi0Zv8g2KHab1E8WHb/qfleM+Vw1lncSzpaUN10bL0zs63UmKp1aKchfG3Md2Am
	 rnEE6/0tM5im7zednGQbd4mnIWNtQ6MnylviRSgpbHj5i6TfxhZtLcinC4xIeSnaqu
	 NHEyDVwUDILfmhezxSQNM/wSSi0aoAkIKE3rXR58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1779/2214] spi: spi-sun4i: sun4i_spi_transfer_one(): fix transfers for SUN4I_FIFO_DEPTH
Date: Wed, 18 Nov 2026 15:57:35 +0100
Message-ID: <20261118150122.664709332@linuxfoundation.org>
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
index ab99cc7438652..3e2ed10510398 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -321,7 +321,7 @@ static int sun4i_spi_transfer_one(struct spi_master *master,
 	sun4i_spi_enable_interrupt(sspi, SUN4I_INT_CTL_TC |
 					 SUN4I_INT_CTL_RF_F34);
 	/* Only enable Tx FIFO interrupt if we really need it */
-	if (tx_len > SUN4I_FIFO_DEPTH)
+	if (tx_len > SUN4I_FIFO_DEPTH - 1)
 		sun4i_spi_enable_interrupt(sspi, SUN4I_INT_CTL_TF_E34);
 
 	/* Start the transfer */
-- 
2.53.0



