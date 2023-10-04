Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A1F1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqo9sU3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2CEC433C7;
	Wed,  4 Oct 2023 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443489;
	bh=0c0gxWKZkoY31pwPBnTwRaTSXhJwJROyatevWwRxQ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqo9sU3IDRJQzJDK7+Y5RycG/O2njt0ngte9ADvXD7lMobqeUZ7F7FJhUMZbNKhMv
	 CuEaacukW7XHSnwePuTiseTwKGt+6u9iPtVrHDRzNKbaf9txljP/UIBTe3wpzpfUXQ
	 5VxHEXzl6I+Z8FKIXwwoXuliLRY2eHE2PhgQyHR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/259] spi: nxp-fspi: reset the FLSHxCR1 registers
Date: Wed,  4 Oct 2023 19:55:47 +0200
Message-ID: <20231004175225.275637452@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d6a65a989ef80..c7a4a3606547e 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1029,6 +1029,13 @@ static int nxp_fspi_default_setup(struct nxp_fspi *f)
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



