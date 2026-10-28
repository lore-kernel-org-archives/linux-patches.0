Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207631;
	b=TuyYd/nmUHGjh1Wzv1mbTvISyXiNIlEn+C26LqU85xGIqqqBkcoYRlRWDM6/SvBqBbFN
	 VWuy36MUUe2xIbQmGROW2LX0FtA0EqlwVpMNuKgp3osBY6Q5eTxIfrqL045qELnBt7sei
	 QWy3foLC66DbExfNT0Ke8V46tPFNTxZeT2gFGXydgep/ZVZJsGfomRnTNMnxrj1PCKI6b
	 G7UGUv8XtpsgfWZdiH6rk1xn6Pmn8ef04yWOC+dHypg1XBHixzwcpHl58yqor9sMzNH+8
	 Yjk+3OLBBNMIERM7Q74EquJJTgxpkH6kFKD60fXU6ZEbWqP8+46yC8lwLyrQzzSmClA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2iasT7TztrNV86BzwlxGq7EL+vsg0w+1Se08QBOH5ys=;
	b=CHwHsXKO3Dr9PUFZqBTF03PU4GNvWhQDkh3/OpspEs18FG3zr0CWbKwkeT936chhI3g7
	 Y4h5hAGAIZL9wZSq/7CqFfYkZ4C7T8GGnPpGy3/Ctc+dY0kxY4Rdr7BkVFe+GcCDYBICU
	 ukwQirT+OtphMbPWKK0ealLs9d9WwENJdDb9mZPZHpWGcNxMA7EstFeQPFk5A65jSb/1V
	 hStAD5QpRJW82TLHr1Mw68juQP6C+Qf9pWUrDbHgJXntU8/L+brTxa0d776tZuodGYuhK
	 6+n7BjlB6MU29HorjoaT+ZlZWSyHBizUF7eyKyW4dIx1FNFqCr7mVUH/VqDjpSA2IRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfvJucSK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E1B606A323;
	Wed, 28 Oct 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfvJucSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC4F1F01828;
	Wed, 28 Oct 2026 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207630;
	bh=2iasT7TztrNV86BzwlxGq7EL+vsg0w+1Se08QBOH5ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfvJucSKsY01u8TsLCikcy+c8kGfFmaNBcHhH+sgXj8HK178vZyPSJywHrswlq+4Y
	 CMQ65TzAzuDQsvC+t1okN8YYg4d8RuN7my9ps/vTZErmsHpTDv95ueWLqdaTh86P/g
	 bTNoheHTCux81KBBnjK0zQYrVXKeIwaNpi2iueFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Jones Jr <carlosjr.jones@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/247] spi: tegra114: assert CS GPIO for every transfer in a message
Date: Wed, 28 Oct 2026 17:57:24 +0100
Message-ID: <20261028165948.343883113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Carlos Jones Jr <carlosjr.jones@analog.com>

[ Upstream commit 8980bc573ae2d2b9d86d76aeb86c76e1597070bf ]

The driver provides its own transfer_one_message() and therefore drives
the chip-select GPIO itself rather than through the SPI core. The GPIO is
asserted only in the is_first_of_msg path of
tegra_spi_setup_transfer_one(), but tegra_spi_transfer_end() deasserts it
whenever a transfer has cs_change set. For a multi-transfer message whose
earlier transfers request cs_change -- for example a register read that
sends the address in one transfer and clocks the data back in the next --
the CS GPIO is released after the first transfer and never re-asserted,
so the remaining transfers are clocked with chip-select inactive and the
peripheral never drives the bus.

This was observed with an ADIS16470 IMU (adis16475 driver), whose
register read is a two-transfer, cs_change-framed exchange: a logic
analyzer showed the data frame clocked with CS high, and the driver read
0 while the device drove 0x4056 on the wire.

Re-assert the CS GPIO for every transfer so that multi-transfer messages
keep chip-select active across the whole message. gpiod_set_value() is
idempotent and polarity-aware, so this is a no-op for the first transfer
and for messages that keep CS asserted throughout.

Fixes: 63c1440596ff ("spi: tegra114: add support for gpio based CS")
Signed-off-by: Carlos Jones Jr <carlosjr.jones@analog.com>
Link: https://patch.msgid.link/20261002085540.1625-1-carlosjr.jones@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 5b8bd34e6bfd9..622bcaa0fe6e9 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -859,6 +859,13 @@ static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
 		command1 |= SPI_BIT_LENGTH(bits_per_word - 1);
 	}
 
+	/*
+	 * Re-assert the CS GPIO for every transfer: transfer_end() drops it
+	 * on cs_change, and the assert above only covers is_first_of_msg.
+	 */
+	if (spi_get_csgpiod(spi, 0))
+		gpiod_set_value(spi_get_csgpiod(spi, 0), 1);
+
 	return command1;
 }
 
-- 
2.53.0



