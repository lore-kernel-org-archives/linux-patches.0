Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7076211CA1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2B5C433EF;
	Mon,  8 May 2023 11:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544693;
	bh=/Elnoj2QzjpjJK1ro0dCdRhNWhEUyfh6d99b26iN3wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUmm5BiRb1anRppHIuiAEBhu880UNH0xA2uQ+4Y77MsK5I0V06DTuvL1I1i3zyfrP
	 3HV7CeCcc9u6D1i1Efd6jm+sPfn4AyEqUuwpZ8WLk1bLCIastea3b7GjuF9mIh3ytB
	 z/NZZux/3REKkkLecRw/H8K6hIPlyCwpKhkPFMas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 494/694] spi: Constify spi parameters of chip select APIs
Date: Mon,  8 May 2023 11:45:29 +0200
Message-Id: <20230508094450.038000527@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d2f19eec510424caa55ea949f016ddabe2d8173a ]

The "spi" parameters of spi_get_chipselect() and spi_get_csgpiod() can
be const.

Fixes: 303feb3cc06ac066 ("spi: Add APIs in spi core to set/get spi->chip_select and spi->cs_gpiod")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/b112de79e7a1e9095a3b6ff22b639f39e39d7748.1678704562.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spi/spi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 4fa26b9a35725..509bd620a258c 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -266,7 +266,7 @@ static inline void *spi_get_drvdata(struct spi_device *spi)
 	return dev_get_drvdata(&spi->dev);
 }
 
-static inline u8 spi_get_chipselect(struct spi_device *spi, u8 idx)
+static inline u8 spi_get_chipselect(const struct spi_device *spi, u8 idx)
 {
 	return spi->chip_select;
 }
@@ -276,7 +276,7 @@ static inline void spi_set_chipselect(struct spi_device *spi, u8 idx, u8 chipsel
 	spi->chip_select = chipselect;
 }
 
-static inline struct gpio_desc *spi_get_csgpiod(struct spi_device *spi, u8 idx)
+static inline struct gpio_desc *spi_get_csgpiod(const struct spi_device *spi, u8 idx)
 {
 	return spi->cs_gpiod;
 }
-- 
2.39.2



