Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D968611A;
	Sat, 30 Dec 2023 12:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIm/LWKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FA4C433C7;
	Sat, 30 Dec 2023 12:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938030;
	bh=AnwJfsFbH18yNTA+YvwN/e+8bTxiWb1QU+KUiWoE/6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIm/LWKTOdoezWFqTYH9EM+pE90BeIl7Kh5LI/Cw4zp04U1FsBKl6mZ2P5yW/MSWi
	 HXBeWkG9UzPeCAFalMYyVXztXbyo6WL+5LPXowNLtDKGwIvrPN4JzRsOMiZrQCqbJa
	 hdrYwgi0nCcWjmNeGf9hjhRqyv4pxUhgVxQXoELA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 156/156] spi: cadence: revert "Add SPI transfer delays"
Date: Sat, 30 Dec 2023 12:00:10 +0000
Message-ID: <20231230115817.394410437@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 7a733e060bd20edb63b1f27f0b29cf9b184e0e8b upstream.

The commit 855a40cd8ccc ("spi: cadence: Add SPI transfer delays") adds a
delay after each transfer into the driver's transfer_one(). However,
the delay is already done in SPI core. So this commit unnecessarily
doubles the delay amount. Revert this commit.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20231206145233.74982-1-namcao@linutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -451,7 +451,6 @@ static int cdns_transfer_one(struct spi_
 		udelay(10);
 
 	cdns_spi_process_fifo(xspi, xspi->tx_fifo_depth, 0);
-	spi_transfer_delay_exec(transfer);
 
 	cdns_spi_write(xspi, CDNS_SPI_IER, CDNS_SPI_IXR_DEFAULT);
 	return transfer->len;


