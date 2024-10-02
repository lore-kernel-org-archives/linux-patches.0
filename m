Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDC41D14FB;
	Wed,  2 Oct 2024 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879054; cv=none; b=I+88pNG6GvDGHxGiOVk9v/dNd+BpolJdbp922f5OfdWTGQKFSipmyj8LePX6A9J8FYwSeyTgpQzLn46rVfcqH0VOZkWrurTd13HnJ8j5aFyBfUXQe2w9uZCWSIYntepgRGJ56EGMf99cVxOHtz72WuTTBaNBZek6egIU2sjMfLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879054; c=relaxed/simple;
	bh=nmog2kAJ45ykvaotC2rRr7SH/PlB1SMdr1s3yu1qNxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/3i3aVSPev5Art0flXiS2FfMpbBGbGm6vPLtpW5quZdwNKtaso2N871EavH3Uni6mg8SCYPjZMNjjbK8w9DfSKRytvxOMG7KXHRK6YAs7LT+ie7zFwo9799/HILm1dnNFBqbyrofzdqDfUH2tGOs5cYlhXo4vuQa1IgRdnT42c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjdi2kYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjdi2kYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E07C4CEC2;
	Wed,  2 Oct 2024 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879053;
	bh=nmog2kAJ45ykvaotC2rRr7SH/PlB1SMdr1s3yu1qNxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjdi2kYIQGWol3E9G/aKAeYjfXhvryB2872/Ql6uVdsiO7Tm4idF9UevC5WJvNknz
	 RIXCsOv/lf/UpkNP+pDDHCMq+0F2rY+XOgYxaEZC0kZeusaiQHh2bQBa5jcyGDG432
	 sDUFHYbBhAN/iSsz4sS4+ZltPK9T9S3WkDjIBx6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 623/634] spi: fspi: add support for imx8ulp
Date: Wed,  2 Oct 2024 15:02:03 +0200
Message-ID: <20241002125835.717530712@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 9228956a620553d7fd17f703a37a26c91e4d92ab upstream.

The flexspi on imx8ulp only has 16 LUTs, different with others which
have up to 32 LUTs.

Add a separate compatible string and nxp_fspi_devtype_data to support
flexspi on imx8ulp.

Fixes: ef89fd56bdfc ("arm64: dts: imx8ulp: add flexspi node")
Cc: stable@kernel.org
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240905094338.1986871-4-haibo.chen@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-nxp-fspi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -371,6 +371,15 @@ static struct nxp_fspi_devtype_data imx8
 	.little_endian = true,  /* little-endian    */
 };
 
+static struct nxp_fspi_devtype_data imx8ulp_data = {
+	.rxfifo = SZ_512,       /* (64  * 64 bits)  */
+	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
+	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
+	.quirks = 0,
+	.lut_num = 16,
+	.little_endian = true,  /* little-endian    */
+};
+
 struct nxp_fspi {
 	void __iomem *iobase;
 	void __iomem *ahb_addr;
@@ -1297,6 +1306,7 @@ static const struct of_device_id nxp_fsp
 	{ .compatible = "nxp,imx8mp-fspi", .data = (void *)&imx8mm_data, },
 	{ .compatible = "nxp,imx8qxp-fspi", .data = (void *)&imx8qxp_data, },
 	{ .compatible = "nxp,imx8dxl-fspi", .data = (void *)&imx8dxl_data, },
+	{ .compatible = "nxp,imx8ulp-fspi", .data = (void *)&imx8ulp_data, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, nxp_fspi_dt_ids);


