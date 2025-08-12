Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BCA2FDC5F;
	Tue, 12 Aug 2025 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020246; cv=none; b=lSuPh8IgLuDbnTBaw71gX/u/+ZC9OsnUGP7+KtEBYRtcRikDFIX243EBtZwzBEK/MXL+FtvyQqtPCrcDOd0RQVQ33uXl7N/0fJ0tC2rM7/3BcPQd0W+nsnUkn9lDnBf+HmBdK2GbpJOpM8V7siMM4ArtYZs8wx3QDuGYAxXaRXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020246; c=relaxed/simple;
	bh=xHoREArMj+q69A3x6ewfsGZHN0xMfZtqf/uS0/6imQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYjf9qXZcYMKlJaMosPTL6q2PZuaVjmCE0LvNILwiMqU7HoHf1iTnE9GzS1T3LaTkWWAyLWNPoI8pd83pQmPkACjosI8Uc3VY9S/q0JqXjILltQdJlzC7XtyXkyzjrjnJGaJNOiPkZhtWE6A4VptpgAUchemjXp6ualijem3clI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkEyW/nP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkEyW/nP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C609C4CEF0;
	Tue, 12 Aug 2025 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020245;
	bh=xHoREArMj+q69A3x6ewfsGZHN0xMfZtqf/uS0/6imQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkEyW/nPN0CTsF6pVcuY+0uGgbOOafE7PIeFo4K+qB1YTP7TNIq93NAej933+RsZz
	 ZgoCMxG2jqaxiOUMy6L1bNVhGBhtUsvVHeGN4A3Sx+zSh6QUkhCQk34eZa0jMlz20c
	 d2P+ML8/kbQzmvC6mg5lcgXFk/A8nnMjB0IoWiIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andy@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/253] iio: adc: ad7949: use spi_is_bpw_supported()
Date: Tue, 12 Aug 2025 19:26:33 +0200
Message-ID: <20250812172948.913892979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 7b86482632788acd48d7b9ee1867f5ad3a32ccbb ]

Use spi_is_bpw_supported() instead of directly accessing spi->controller
->bits_per_word_mask. bits_per_word_mask may be 0, which implies that
8-bits-per-word is supported. spi_is_bpw_supported() takes this into
account while spi_ctrl_mask == SPI_BPW_MASK(8) does not.

Fixes: 0b2a740b424e ("iio: adc: ad7949: enable use with non 14/16-bit controllers")
Closes: https://lore.kernel.org/linux-spi/c8b8a963-6cef-4c9b-bfef-dab2b7bd0b0f@sirena.org.uk/
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20250611-iio-adc-ad7949-use-spi_is_bpw_supported-v1-1-c4e15bfd326e@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7949.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad7949.c b/drivers/iio/adc/ad7949.c
index edd0c3a35ab73..202561cad4012 100644
--- a/drivers/iio/adc/ad7949.c
+++ b/drivers/iio/adc/ad7949.c
@@ -308,7 +308,6 @@ static void ad7949_disable_reg(void *reg)
 
 static int ad7949_spi_probe(struct spi_device *spi)
 {
-	u32 spi_ctrl_mask = spi->controller->bits_per_word_mask;
 	struct device *dev = &spi->dev;
 	const struct ad7949_adc_spec *spec;
 	struct ad7949_adc_chip *ad7949_adc;
@@ -337,11 +336,11 @@ static int ad7949_spi_probe(struct spi_device *spi)
 	ad7949_adc->resolution = spec->resolution;
 
 	/* Set SPI bits per word */
-	if (spi_ctrl_mask & SPI_BPW_MASK(ad7949_adc->resolution)) {
+	if (spi_is_bpw_supported(spi, ad7949_adc->resolution)) {
 		spi->bits_per_word = ad7949_adc->resolution;
-	} else if (spi_ctrl_mask == SPI_BPW_MASK(16)) {
+	} else if (spi_is_bpw_supported(spi, 16)) {
 		spi->bits_per_word = 16;
-	} else if (spi_ctrl_mask == SPI_BPW_MASK(8)) {
+	} else if (spi_is_bpw_supported(spi, 8)) {
 		spi->bits_per_word = 8;
 	} else {
 		dev_err(dev, "unable to find common BPW with spi controller\n");
-- 
2.39.5



