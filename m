Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00771BDE9;
	Wed,  3 Jan 2024 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7LLMbs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2244AC433C8;
	Wed,  3 Jan 2024 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301308;
	bh=CNne+aeALxqTy5NGJcV/PN2EOylGS7PcFdil3X1wjD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7LLMbs0Nvmxb2Tj8PxO1sqESB2uwbDtxj+yjOuqeJRstOduedMRCfCy9wvjqhHzx
	 lGPPdE7bAuGAPjRQliJF/1DloiD/FGDmQiMECHvNAxZWUtrcq4NTajjJWdjd2FHlSp
	 eILdgbEa1rYxVGK7+NgdtNFVL9SN5mHTjOLHrhms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 097/100] spi: Constify spi parameters of chip select APIs
Date: Wed,  3 Jan 2024 17:55:26 +0100
Message-ID: <20240103164910.696912032@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit d2f19eec510424caa55ea949f016ddabe2d8173a upstream.

The "spi" parameters of spi_get_chipselect() and spi_get_csgpiod() can
be const.

Fixes: 303feb3cc06ac066 ("spi: Add APIs in spi core to set/get spi->chip_select and spi->cs_gpiod")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/b112de79e7a1e9095a3b6ff22b639f39e39d7748.1678704562.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/spi/spi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -263,7 +263,7 @@ static inline void *spi_get_drvdata(stru
 	return dev_get_drvdata(&spi->dev);
 }
 
-static inline u8 spi_get_chipselect(struct spi_device *spi, u8 idx)
+static inline u8 spi_get_chipselect(const struct spi_device *spi, u8 idx)
 {
 	return spi->chip_select;
 }
@@ -273,7 +273,7 @@ static inline void spi_set_chipselect(st
 	spi->chip_select = chipselect;
 }
 
-static inline struct gpio_desc *spi_get_csgpiod(struct spi_device *spi, u8 idx)
+static inline struct gpio_desc *spi_get_csgpiod(const struct spi_device *spi, u8 idx)
 {
 	return spi->cs_gpiod;
 }


