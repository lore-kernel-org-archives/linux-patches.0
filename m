Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B1F3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp4Q95R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2C2C433C8;
	Wed, 15 Nov 2023 19:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077899;
	bh=CplloXKYWm8JFd3GbHIXxuGAelyyEIeT5qWM9hl3uxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp4Q95R210hVZlKr9+xYhWclDEBJUf/0KrITE3hfGpfCvex7nmcOkzDIiltPnG4CE
	 N3oe5dX8unJ5jgVlyCgTx3r7l/msSS2WjC7FcYCl2WFvaNt45UuMBZAm88pOw18azg
	 HcSQcuGtmqHjs2+X9BMq5ve5UQztd3yVkdPoOoiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 588/603] spi: spi-zynq-qspi: add spi-mem to driver kconfig dependencies
Date: Wed, 15 Nov 2023 14:18:53 -0500
Message-ID: <20231115191651.952439783@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>

[ Upstream commit c2ded280a4b1b7bd93e53670528504be08d24967 ]

Zynq QSPI driver has been converted to use spi-mem framework so
add spi-mem to driver kconfig dependencies.

Fixes: 67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1699037031-702858-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 2c21d5b96fdce..bcbf840cd41c8 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -1157,6 +1157,7 @@ config SPI_XTENSA_XTFPGA
 config SPI_ZYNQ_QSPI
 	tristate "Xilinx Zynq QSPI controller"
 	depends on ARCH_ZYNQ || COMPILE_TEST
+	depends on SPI_MEM
 	help
 	  This enables support for the Zynq Quad SPI controller
 	  in master mode.
-- 
2.42.0



