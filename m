Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8DB17BED0;
	Sat, 17 Oct 2026 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254075; cv=none; b=FWrpfzN2kqHu+rSe2akuzysp2zg7xdSWdFukpX6Sx4bTqmuJaehbWeei3mzaVp3lmrbZJ7G+nVZTgfJyp0l77MrbrH+mGJvqOogWkuOyX874/9pOrTz5i3EvtAzepzd3gqQCrTmVi4+2bjdqVzuZA4XeXBI8K7mr39EJeKKUp8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254075; c=relaxed/simple;
	bh=DHvR+wtmEdBf+2+PDFW163dgbDQZ9yaafqNHJJP2NDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOVUUJ1j5Etmgm7mriSUX+wyZcxI4DYwet+FeF32yDvL977fFmUV34ZcmKmzuyrPriq7c9P0sIvEr2n+8cqAR5RBBow6aIQSH/2nvrnPZaR+0EzgkXyGVQCfhkGQIMqGSfBOqnZsY3Jhl3exFofKAB49d8K5Io7ICE3mf5TVCqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Igtu6Xql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Igtu6Xql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709BB1F000C4;
	Sat, 17 Oct 2026 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254074;
	bh=rhaURqi8OprAspzOGGbLT4aBJ6Zh9o8/DL8/LawwE8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Igtu6Xql7H72ax0BU30KL9CGYXJw+mSgeOrjPUjkhOzmxzex+ejg0pVZtr90nIIjp
	 VWtcn29qIUT+Sk7+6EZ+NYubM8DHZV0tn74YoZp8uHMl2GFGmleDsslmx/5/vEDqPs
	 2j0kejhvPLQNL1REHtzhVhugABKLlYVPwqgQC63E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/869] spi: microchip-core-qspi: remove unused param from mchp_coreqspi_write_op()
Date: Sat, 17 Oct 2026 17:52:11 +0200
Message-ID: <20261017160044.507878851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 75ca45c472dac206df2ebbc1c0f1f9c3bbdace50 ]

"word" is unused in mchp_coreqspi_write_op(), so delete it.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20250620-starry-excusably-25e6be957d9d@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7672749e1496 ("spi: microchip-core-qspi: control built-in cs manually")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core-qspi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-microchip-core-qspi.c b/drivers/spi/spi-microchip-core-qspi.c
index 8bce9aeb259a4..1d24aee26dac5 100644
--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -194,7 +194,7 @@ static inline void mchp_coreqspi_read_op(struct mchp_coreqspi *qspi)
 	}
 }
 
-static inline void mchp_coreqspi_write_op(struct mchp_coreqspi *qspi, bool word)
+static inline void mchp_coreqspi_write_op(struct mchp_coreqspi *qspi)
 {
 	u32 control, data;
 
@@ -415,7 +415,7 @@ static int mchp_coreqspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *o
 		qspi->rxbuf = NULL;
 		qspi->tx_len = op->cmd.nbytes;
 		qspi->rx_len = 0;
-		mchp_coreqspi_write_op(qspi, false);
+		mchp_coreqspi_write_op(qspi);
 	}
 
 	qspi->txbuf = &opaddr[0];
@@ -426,7 +426,7 @@ static int mchp_coreqspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *o
 		qspi->rxbuf = NULL;
 		qspi->tx_len = op->addr.nbytes;
 		qspi->rx_len = 0;
-		mchp_coreqspi_write_op(qspi, false);
+		mchp_coreqspi_write_op(qspi);
 	}
 
 	if (op->data.nbytes) {
@@ -435,7 +435,7 @@ static int mchp_coreqspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *o
 			qspi->rxbuf = NULL;
 			qspi->rx_len = 0;
 			qspi->tx_len = op->data.nbytes;
-			mchp_coreqspi_write_op(qspi, true);
+			mchp_coreqspi_write_op(qspi);
 		} else {
 			qspi->txbuf = NULL;
 			qspi->rxbuf = (u8 *)op->data.buf.in;
-- 
2.53.0



