Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020018;
	b=eUL7KLlNlVbZQYwXUJ/OHs79k+UqlaW9PaOA96I2kMHSz8A8kE5Ac9VzUDHaXxAgXMCN
	 2FZoafJ32AMcpAs0WpZOifLIZO640iEVl2uJfLG0KiPoCEUJvOV3Tz4vwrh9KqCrB7VCY
	 CfKmil5ZMJFAUS6d8Ny4Eeg/+0rvu1R8ArZ/K/0JdUmtWTi/JOr3jUDptRo+PZis2B5M6
	 BBQEg5PLO30+aC1xnwZJqXmXa1Nc+HnT1Hm4MDs0y3SSSBuZLTtP978kOxs+yW6T3pYr1
	 9w462D+T2TkK+tussWvIboVKTkdA+owXlQFozCQAYXoKJYdZVIMlScL010/VBTX0u0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KfMz/Owkd4eGAHHjJ/BYrdjgN8ePR3z7LbMdhZeEKEY=;
	b=dIbN2Wv6TKBV2rRdOMJXraIJSn/1ipkYEAK2Yx/Qt/kTOsrgodMHQ8dK1g1z3lF2KjQK
	 YvMYvbbBFAi6l5mot9ANINhIM4X3DOj+zPVcLRm4TgoBjvD9x1lJbyhQYbd5aCTSo5Cjw
	 2whTbjCCi1nkhjlAZoA5OmSQjE8iLdRt/mfgBrhxa4GmtIJQFzwxR/kthGTtZhSjbtfkW
	 7/perZPqt3YN4cL8qwDHzMxxsvT+KmiFGhKKAYBYXbUp9JaZP1Ac+RC4dWnhtNdDjnr99
	 QBdGvfK4zNLtpS71rHhNuFy3nTP0QZDwgZDkT9dE+W71g6xDjUSoIPpPP+mWbelR+cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKHEe6iA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FE9606A332;
	Wed, 18 Nov 2026 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKHEe6iA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFD11F000C5;
	Wed, 18 Nov 2026 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020018;
	bh=KfMz/Owkd4eGAHHjJ/BYrdjgN8ePR3z7LbMdhZeEKEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKHEe6iAHw2T9FYeVgbfnQX3ilnb/mbXFwHNlx0VOG3WVRVF8Q7ZfPekrrMgfih5X
	 DCOXxwqRwUrOrNH2cGXG4JpzDYX6/YowiBn+C22KgjE5IMQ9phOV/hL7sJ9Pi4rGNi
	 9n3/4qIJigSTnKgMmSH6DuBVTCWkIqaqePNh4fgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Heinzel <dennis.heinzel@irs.systems>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1803/2651] spi: axi-spi-engine: fix stale SYNC IRQ pending
Date: Wed, 18 Nov 2026 15:50:43 +0100
Message-ID: <20261118150352.188968560@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 02bbc5d0cfc50..87c05cb064ccf 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -887,6 +887,7 @@ static int spi_engine_setup(struct spi_device *device)
 	struct spi_controller *host = device->controller;
 	struct spi_engine *spi_engine = spi_controller_get_devdata(host);
 	unsigned int reg;
+	int ret;
 
 	if (device->mode & SPI_CS_HIGH)
 		spi_engine->cs_inv |= BIT(spi_get_chipselect(device, 0));
@@ -922,8 +923,15 @@ static int spi_engine_setup(struct spi_device *device)
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



