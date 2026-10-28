Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213813;
	b=kSmK3Db4wbojphIb0s8SPTPGLEKLYTnf/WvVyp3WCy53hVIZYpubyDRnxXjbFRRDlEXx
	 YjuaKZKSWP/D2l098AnIOlDkhEeZ7qEEHPhQY6KTIDv4BoOvUj86PMuCm/IRHEbAyFOCk
	 lXBTX/fq5zUVCIEaK311Ln4NaWcHuH9RS9gu65NZnguMOxvHpWb1oxgEGZLldtQqUqmmg
	 y2zB1ZA2lCyDY2WlZkBmfiDAIsj4xh73aCwMyW3MGQptNdJrLudI0jvW1NA9w4pQp8/A0
	 1eEZHkv1uxZIDVbhgxnWCtkvHKOnvdGLVdML8u1imkP9JH5QO8aHjqGYMGNKwkXtSNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y7nIGBESd3JteVtXUdEAS4pEXJH7J3d0JLHZ7xSMPf8=;
	b=acOQ3Aud5mJ4/YOttL8/WffdWvEo9SlMpYoBY8BQdT36UZwfnIRmzOMAEVtE1pXgNFRJ
	 gAD0GUhsAmwy0L9XyVNM01rl/sPEEnxtbDRvQmdVDhl9jCyvKBYfbwWKgcn9XBgaCTPGD
	 +IcJxLUWodz2370ZvfatOYJzgBfBg541qX2o2X1sKBAZePAZJXDLQG5I7oKT+Ef3AW6pr
	 HClO8c+PvIb9wretkvFIIb6QSzzoo+8H3o6ygsJuj0ypevU+xPdVmIjeWV/LPvzFwfGKp
	 Nsbb+V6E8ZCJBoZj9Ot00kjeMvigQwWxLioeCKVGNt6iXhiTOCQlEOPCGmuiuXPunsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OBN//3lb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5C9606A31A;
	Wed, 28 Oct 2026 18:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBN//3lb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2936B1F01825;
	Wed, 28 Oct 2026 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213812;
	bh=Y7nIGBESd3JteVtXUdEAS4pEXJH7J3d0JLHZ7xSMPf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBN//3lb+oME0X/FkuBUDzHM/r/ZvKOh+eusqPba9xCJzHOtWMvmW9sU4n1e8auSt
	 a99ojafqQbwkyCHykMR2jEYzyUiY3NQYPgzkTdMaAaVY8ag7w2fnp664dqj/tf7UdQ
	 uzE1DThdp8AjWHLc5LG+0twzeU9Lqs3ZHV/l5K0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wilkins <steve.wilkins@raymarine.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0639/1887] spi: microchip-core: ensure TX and RX FIFOs are empty at start of a transfer
Date: Wed, 28 Oct 2026 17:45:35 +0100
Message-ID: <20261028170513.952699570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wilkins <steve.wilkins@raymarine.com>

[ Upstream commit 9cf71eb0faef4bff01df4264841b8465382d7927 ]

While transmitting with rx_len == 0, the RX FIFO is not going to be
emptied in the interrupt handler. A subsequent transfer could then
read crap from the previous transfer out of the RX FIFO into the
start RX buffer. The core provides a register that will empty the RX and
TX FIFOs, so do that before each transfer.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Signed-off-by: Steve Wilkins <steve.wilkins@raymarine.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20240715-flammable-provoke-459226d08e70@wendy
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-microchip-core.c b/drivers/spi/spi-microchip-core.c
index bfad0fe743ad7..acc05f5a929e6 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -91,6 +91,8 @@
 #define REG_CONTROL2		(0x28)
 #define REG_COMMAND		(0x2c)
 #define  COMMAND_CLRFRAMECNT	BIT(4)
+#define  COMMAND_TXFIFORST		BIT(3)
+#define  COMMAND_RXFIFORST		BIT(2)
 #define REG_PKTSIZE		(0x30)
 #define REG_CMD_SIZE		(0x34)
 #define REG_HWSTATUS		(0x38)
@@ -489,6 +491,8 @@ static int mchp_corespi_transfer_one(struct spi_controller *host,
 	mchp_corespi_set_xfer_size(spi, (spi->tx_len > FIFO_DEPTH)
 				   ? FIFO_DEPTH : spi->tx_len);
 
+	mchp_corespi_write(spi, REG_COMMAND, COMMAND_RXFIFORST | COMMAND_TXFIFORST);
+
 	while (spi->tx_len)
 		mchp_corespi_write_fifo(spi);
 
-- 
2.53.0



