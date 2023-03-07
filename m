Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBE6BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104FBC433EF;
	Tue,  7 Mar 2023 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211665;
	bh=/ua/swVXMWEQW3uEKX2NhCvSMZh/xus9H/iyTUGrLsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvnmC/EzdIVgljntTzKX+mfHbWHUheZxiaAzhnNdKhftKHNUmR6sTfCARAgu/P01J
	 F63FlcCnfVx+e8o2Nz4F+dVDJccYaYCAo+kbz8KlzMRws/KzIARBLSWGfQluYwt2TZ
	 9Lx/qg+wMlnaJj8nfmtB2q0dtaYOBD/u5gIuz2m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Binderman <dcb314@hotmail.com>,
	Dhruva Gole <d-gole@ti.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 0937/1001] spi: spi-sn-f-ospi: fix duplicate flag while assigning to mode_bits
Date: Tue,  7 Mar 2023 18:01:49 +0100
Message-Id: <20230307170102.770683367@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dhruva Gole <d-gole@ti.com>

commit 078a5517d22342eb0474046d3e891427a2552e3c upstream.

Replace the SPI_TX_OCTAL flag that appeared two time with SPI_RX_OCTAL
in the chain of '|' operators while assigning to mode_bits

Fixes: 1b74dd64c861 ("spi: Add Socionext F_OSPI SPI flash controller driver")

Reported-by: David Binderman <dcb314@hotmail.com>
Link: https://lore.kernel.org/all/DB6P189MB0568F3BE9384315F5C8C1A3E9CA49@DB6P189MB0568.EURP189.PROD.OUTLOOK.COM/

Cc: stable@vger.kernel.org
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20230223095202.924626-1-d-gole@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sn-f-ospi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sn-f-ospi.c b/drivers/spi/spi-sn-f-ospi.c
index 348c6e1edd38..333b22dfd8db 100644
--- a/drivers/spi/spi-sn-f-ospi.c
+++ b/drivers/spi/spi-sn-f-ospi.c
@@ -611,7 +611,7 @@ static int f_ospi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ctlr->mode_bits = SPI_TX_DUAL | SPI_TX_QUAD | SPI_TX_OCTAL
-		| SPI_RX_DUAL | SPI_RX_QUAD | SPI_TX_OCTAL
+		| SPI_RX_DUAL | SPI_RX_QUAD | SPI_RX_OCTAL
 		| SPI_MODE_0 | SPI_MODE_1 | SPI_LSB_FIRST;
 	ctlr->mem_ops = &f_ospi_mem_ops;
 	ctlr->bus_num = -1;
-- 
2.39.2



