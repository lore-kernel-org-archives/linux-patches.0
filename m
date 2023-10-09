Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBE522F00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bKpdhX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2A8C433C9;
	Mon,  9 Oct 2023 13:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858236;
	bh=Re4njsf6H6MGIDOOnApZu9XoOTx/o0CP5jBw8FZG7K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bKpdhX0KDUXfmcDgwE5htgwenUE/MNeWGBNTqBbJPUXEHeZXhl2YqWkuN6urUT3H
	 oxGhFZk08srsZ4mcisObplMohZ2N2+ivXg0r1ugiLw6JjM6rkj010T7+/Ihgs0ktTB
	 iMMPDJmQKCk40gpwb9R4egFzywIBc/g4J0I0WkWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/131] spi: nxp-fspi: reset the FLSHxCR1 registers
Date: Mon,  9 Oct 2023 15:01:39 +0200
Message-ID: <20231009130118.103427274@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

[ Upstream commit 18495676f7886e105133f1dc06c1d5e8d5436f32 ]

Reset the FLSHxCR1 registers to default value. ROM may set the register
value and it affects the SPI NAND normal functions.

Signed-off-by: Han Xu <han.xu@nxp.com>
Link: https://lore.kernel.org/r/20230906183254.235847-1-han.xu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 36a44a837031d..ee1b488d7dedc 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -897,6 +897,13 @@ static int nxp_fspi_default_setup(struct nxp_fspi *f)
 	fspi_writel(f, FSPI_AHBCR_PREF_EN | FSPI_AHBCR_RDADDROPT,
 		 base + FSPI_AHBCR);
 
+	/* Reset the FLSHxCR1 registers. */
+	reg = FSPI_FLSHXCR1_TCSH(0x3) | FSPI_FLSHXCR1_TCSS(0x3);
+	fspi_writel(f, reg, base + FSPI_FLSHA1CR1);
+	fspi_writel(f, reg, base + FSPI_FLSHA2CR1);
+	fspi_writel(f, reg, base + FSPI_FLSHB1CR1);
+	fspi_writel(f, reg, base + FSPI_FLSHB2CR1);
+
 	/* AHB Read - Set lut sequence ID for all CS. */
 	fspi_writel(f, SEQID_LUT, base + FSPI_FLSHA1CR2);
 	fspi_writel(f, SEQID_LUT, base + FSPI_FLSHA2CR2);
-- 
2.40.1



