Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026571;
	b=hG+3K/85J7blMxEzzITGBkdZVKKs/Y4Myzwml6iiqHFCHDPKJ/nuV7ppQWr3enYRPxpH
	 LuYxfH7KJsD5rW542uhaRhTEypSI6rNqILm0dFKuukoKuK8OtsDy98AUGexeZU2Q+lHiP
	 Cp+SPhW47N/44gB3NRjkqeLH1OB8mGkKdZ5yssb4pGIt0DTNpsrZrc0gwpSorExLk8ssA
	 C5mvRjFzZ0DU/uUcdvJrpNejMpe6lwDzGISNrPatdDR8LfhUu4qTAzJ8I5S5hcLuFN52m
	 VlaMdkVt7ZpxpqyjD+6xzC9rnupqH2AD2eXxrx1JgItTPSLkeqEcM24VbetdGPrwhdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AUgvlJuWH9OcWKAEdoAgaIqpDgo5cYTLvZnYq1RAhxI=;
	b=vfYYjwKOCki2pvA7ASLXHB2IH294YT6WK7tYtjuDSL42iVyUmZXCFAGtHKrV6oUKI2QM
	 6dFpQU5Z4KCc6hP2wIm3fqP96PSuYaC1bgpVg4pv92GdYDeO9xS8UScLM2Nc8yskQZSYG
	 CTp8KA74offSGbjPdP1M6xxX/h/pcLmSJWXryWihxiAiimQNC0slBAd++8lr8hMsBt3I0
	 k8oasxDJWaUzfxZGdeVxfYBohec3t+Be8FhvKV+ghvMIz4tkDYqg9A3y6qyP4FKgZ/yVp
	 cT2VMKMYG9c6TMgvfJddqqy+4U9iIVlRKAIIgpgSLuMPU4ngP+jUc3EWrxgTXlPPNWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXGI+pyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D2A606A31C;
	Wed, 18 Nov 2026 18:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXGI+pyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B5C1F000C4;
	Wed, 18 Nov 2026 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026571;
	bh=AUgvlJuWH9OcWKAEdoAgaIqpDgo5cYTLvZnYq1RAhxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXGI+pyuLDWsammA3wdoGBbStr+A9YZyCquPW41j0tvKAn+Fb9bAbmpRaIzzejmiY
	 rSfVLdJXjxhX26k1pJ2/fVKRaC8pmcbnbEL/51gf1B/rVY8qZX3ah3RsAF3j3Zq6e/
	 +bSOZ/NfMvnGjNpJddAIpbq0GcL/P8a/UPlCIuew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Heinzel <dennis.heinzel@irs.systems>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1466/2151] spi: axi-spi-engine: fix stale SYNC IRQ pending
Date: Wed, 18 Nov 2026 15:53:21 +0100
Message-ID: <20261118150215.299299562@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Santos <Jonathan.Santos@analog.com>

[ Upstream commit ea29c686f96adcb505071ef228ba8047dc951fac ]

spi_engine_setup() sends a SYNC(1) command and polls SYNC_ID to confirm
it was parsed by the FPGA, but never clears the corresponding interrupt
pending bit (INT_PENDING[SYNC]). When the first real SPI transfer starts
and INT_SYNC is enabled, that stale pending bit fires immediately, causing
the IRQ handler to see the leftover SYNC_ID from setup, match it against
the current transfer's ID, and prematurely signal completion before the
hardware finishes.

This race manifests at low SPI clock frequencies (~2-3 MHz), where the
FPGA takes long enough to execute the transfer that handler is parsed
before it finishes. At higher SCLK rates the transfer completes fast
enough that the issue is masked.

Fix this by clearing INT_PENDING[SYNC] after the polled SYNC, ensuring no
stale interrupt is left pending.

Reported-by: Dennis Heinzel <dennis.heinzel@irs.systems>
Closes: https://ez.analog.com/linux-software-drivers/f/q-a/604145/axi-spi-engine-stale-sync-pending-can-complete-first-transfer-early-at-low-spi-clock-2-3-mhz
Fixes: 1d0ee0c9df31 ("spi: axi-spi-engine: wait for completion in setup")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Link: https://patch.msgid.link/d3033a01a695c915e4dc5952dfe0587b2f77d733.1791361360.git.Jonathan.Santos@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index e06f412190fd2..6a2128459f559 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -787,6 +787,7 @@ static int spi_engine_setup(struct spi_device *device)
 	struct spi_controller *host = device->controller;
 	struct spi_engine *spi_engine = spi_controller_get_devdata(host);
 	unsigned int reg;
+	int ret;
 
 	if (device->mode & SPI_CS_HIGH)
 		spi_engine->cs_inv |= BIT(spi_get_chipselect(device, 0));
@@ -809,8 +810,15 @@ static int spi_engine_setup(struct spi_device *device)
 	writel_relaxed(SPI_ENGINE_CMD_SYNC(1),
 		       spi_engine->base + SPI_ENGINE_REG_CMD_FIFO);
 
-	return readl_relaxed_poll_timeout(spi_engine->base + SPI_ENGINE_REG_SYNC_ID,
-					  reg, reg == 1, 1, 1000);
+	ret = readl_relaxed_poll_timeout(spi_engine->base + SPI_ENGINE_REG_SYNC_ID,
+					 reg, reg == 1, 1, 1 * USEC_PER_MSEC);
+
+	/* Clear the stale SYNC pending bit so it doesn't fire when the IRQ is later enabled. */
+	writel_relaxed(SPI_ENGINE_INT_SYNC, spi_engine->base + SPI_ENGINE_REG_INT_PENDING);
+	/* Read back to flush posted write. */
+	readl_relaxed(spi_engine->base + SPI_ENGINE_REG_INT_PENDING);
+
+	return ret;
 }
 
 static int spi_engine_transfer_one_message(struct spi_controller *host,
-- 
2.53.0



