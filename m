Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF0B46AEF0;
	Tue, 16 Jun 2026 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625504; cv=none; b=hVkbekOB1TFTUQW1Y8SR7wsRQm+ej60DYOwgmyP/fi93K4ACJ9n6C0/ORgFbkfA7XsdcOZOXMe8Iczy/yoTklcGdrEygxGfqgNNIw+UD9dJ3yQT6KsirtAeNAgTDOgQ/BqSXoD4KXLBU3UAT36aLwoCqV9cpWyjq5dDaKAf8MOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625504; c=relaxed/simple;
	bh=b0QsQUw5z0WQBkNPHjGOSR3FNU/evNWCS5b4wNfrgp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnjtYcKSBNfBvXsa54hI3TM3uGNBRyjJx/jG9F8NEYiJ+r64mGqDCJ1Cx3pXaAa0xJguJ5EMeXYVRCaaElBJmcSN5sRDhxKoX5SUl+S1WkqA0sX/9EhnkyFbb98DS6nvCOb5RrWRdEYMNf9+By8AbcPmbtmiBOsrkTT9DB+svkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdeFdxS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdeFdxS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED9C1F000E9;
	Tue, 16 Jun 2026 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625503;
	bh=wnb38xQSa9t9sQNQSEAZHDRq0PzbGolMI44K85S5L90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdeFdxS4wUcDB2IgLIDDZYqiP080MQHWS+XlkDqMdH6zKAeaEMCW9Fh7xy+pQMJo5
	 OKdj95jgFat5w5kVTnMjnp6+3Kpf9WLgtXwI3CoS8xxkgGqOq7l67M5IV7NMbJXMEx
	 EfF3J2NdRAwgslXgjN1/87R/qpdc+PzHBwFs92J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/325] spi: rzv2h-rspi: Fix SPDR read access width for 16-bit RX
Date: Tue, 16 Jun 2026 20:28:39 +0530
Message-ID: <20260616145103.837164766@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 310628484ef06f95c5589374fade917a5689787b ]

The RZ/V2H hardware manual (section 7.5.2.2.1) specifies that read access
size for the SPI Data Register (SPDR) are fixed at 32 bits. The
RZV2H_RSPI_RX macro for the 16-bit data path used readw(), violating
this requirement.

Switch to readl() for the 16-bit RX path to conform to the hardware
specification.

Fixes: 8b61c8919dff ("spi: Add driver for the RZ/V2H(P) RSPI IP")
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Link: https://patch.msgid.link/20260610-rzv2h-rspi-v2-1-40c80b4a2c90@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rzv2h-rspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rzv2h-rspi.c b/drivers/spi/spi-rzv2h-rspi.c
index dcc431ba60a9e5..c981dd3c0dbab6 100644
--- a/drivers/spi/spi-rzv2h-rspi.c
+++ b/drivers/spi/spi-rzv2h-rspi.c
@@ -105,8 +105,9 @@ static inline void rzv2h_rspi_rx_##type(struct rzv2h_rspi_priv *rspi,	\
 RZV2H_RSPI_TX(writel, u32)
 RZV2H_RSPI_TX(writew, u16)
 RZV2H_RSPI_TX(writeb, u8)
+/* The read access size for RSPI_SPDR is fixed at 32 bits */
 RZV2H_RSPI_RX(readl, u32)
-RZV2H_RSPI_RX(readw, u16)
+RZV2H_RSPI_RX(readl, u16)
 RZV2H_RSPI_RX(readl, u8)
 
 static void rzv2h_rspi_reg_rmw(const struct rzv2h_rspi_priv *rspi,
-- 
2.53.0



