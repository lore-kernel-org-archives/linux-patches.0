Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031104;
	b=fVeTtROohvmgoXL/ACPDj0DPsImrc/AOAskDTbX92GrNptSc+UPJBCiDIXMUfCydJYSL
	 TA99bDOujEg84EM6h1v+7g2l5O1MfJ4C5c+wShQFjs18WQpwX8kLkUdGQ8EDuC5pBCsvH
	 +y+zYdVbhhCsxW445SagzluY+LgT9GzIjv4uEqzk873pDor74rKST4kYLVXldSr+TiZuK
	 fGalXQEjF0Q2L3tsozqsaglvzR1P/w8vmSbXjuhXtcyG/2ryMkDeXIZSKQXEWyui8q3NO
	 eCNkAt+SzSC6O0Sdf67uznAXTNvqjYAbmkDyr/LiHHxWkKW1tRocr6LTSqIjQ+AW6Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b2hmT9YG4+JPRqWK6FllebAgUIE5YuD8JHq/CmlUPis=;
	b=zbMgPa/Ew4w+dMK98ISkgehALSk8IQJ4TAI/Yb4jxTe6/W1E3pNDd4mSeMZ6DdpoWFpH
	 MenpPpQauvnlZQQKqAyaW8pDZhpbyVFMugl6JBYfuPZgc9q0jF7nW7U6utvr3TyiyAVM3
	 61naXSMfuHCR0qPd72Gzd2tIdStZ+hSamYMXjF7rwsVkRjA6CRhaFIRQf6mwI+WbVopDx
	 iFEo1rO+88Igd3ozD5Kt0UYnRRL0el3ifUh2z/O1daJfNw7piJ6EpdFfmRBo6RM37/DPi
	 22Iu0KEngr2WhFhf3Hwf8r+5FCBAgmDPX23+9IaLRdhCvgAPnVbp+cf3PTeWX57K3vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhrWA6Uu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33F9606A32C;
	Wed, 18 Nov 2026 19:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhrWA6Uu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047311F000C4;
	Wed, 18 Nov 2026 19:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031104;
	bh=b2hmT9YG4+JPRqWK6FllebAgUIE5YuD8JHq/CmlUPis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhrWA6UuXTa27kwqvWuNlTkUomTQLGtdYVtroc0FuL+rpW6+CLfHSqfJAqSeAKeaB
	 bZX+P/cFZXhykS96qA/ckZSXLS3Z7qQFFKbYpvBsUWilQcLQCg/mn8E9T5qAVYISqS
	 F2/X7Lpj7XYHAVClP/xW7v/Bw20Sg6fqzkr7LGds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0923/1756] spi: spi-sun4i: sun4i_spi_transfer_one(): fix transfers for SUN4I_FIFO_DEPTH
Date: Wed, 18 Nov 2026 15:50:50 +0100
Message-ID: <20261118150046.722101873@linuxfoundation.org>
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
index 4e33e0cec1b21..406a28728fb2c 100644
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



