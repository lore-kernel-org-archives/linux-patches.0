Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B140339B4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waHYcdW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF3FC433C7;
	Mon,  9 Oct 2023 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858946;
	bh=yiqx4y9AifpPfEUIhqh4ETayJHIj5YagPxvwAPw9oQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waHYcdW2mQHV2RKQkhcLFnaT3rNQLLgM/diaXGVeMvUrrjgdKsxHXyIbIRQF7WKG3
	 GkSgH3BIXLBh9kHWfwomhfZdGhEyPsY40ubET+47u8DW5FVCAXYMdyetQq+EbpLNCx
	 b1BsBk+JvIdtNkV3HXHYD1uNB4ajuO1kokHJwKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/226] spi: nxp-fspi: reset the FLSHxCR1 registers
Date: Mon,  9 Oct 2023 15:01:23 +0200
Message-ID: <20231009130129.965969399@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bcc0b5a3a459c..90b5fbc914ae2 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -950,6 +950,13 @@ static int nxp_fspi_default_setup(struct nxp_fspi *f)
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



