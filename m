Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997713DE431;
	Tue, 31 Mar 2026 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975883; cv=none; b=bMVnO4sEAsRD9cHTefregwnm14Bc4/O80kTUZTyCS0zlGdixHgVdxYWaJPGCG8kbIddKvS/zajbgGa0KueF1rUJraHxfp/gtZZIqHpRDGSXjhbFRaDrKLoQdSh8Yq2x6nPzoF0Wzp3xlY7P+1pImav6gIV06m7HwVjA+YacmoMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975883; c=relaxed/simple;
	bh=YidEm3Dj6Q6EEqK6vcbqdXZaeVQ2Q4z112DeNjcNAYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDim/xmzvaaIcIGuCfBoRJB2npcD9+BHXhkXequHPNHICjai72MK3mrYqftc+VvK5q9e383SWr/PTrzXNOHT9Jqm7bdu0ZGSn0E103/cDW/5SddEomdigI2WsqSDPI8wlvLR4wMUP5FIoRX7webCwyAkQcfXwcIzd3lDCTUfxhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIle1viL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIle1viL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30564C19423;
	Tue, 31 Mar 2026 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975883;
	bh=YidEm3Dj6Q6EEqK6vcbqdXZaeVQ2Q4z112DeNjcNAYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIle1viLxBDCyVWKZ/Tw5FvZsLXmXw8m70Ub/LpmDIaSUkfrBxi1LiScC+V0iozrK
	 Lh3vD6MTva6Jq3dlpnsAFUAAj8yT/DoBs4ygMBdeKLIZupW3C+iDgItnkdGbNhieGd
	 AUsga8jqlaQ5t+tG7szrqqmOEwTJOaypr8wGCyms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/244] spi: Group CS related fields in struct spi_device
Date: Tue, 31 Mar 2026 18:21:13 +0200
Message-ID: <20260331161746.202714795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit dd8a9807fa03666bff52cb28472fb227eaac36c9 ]

The CS related fields are sparse in the struct spi_device. Group them.
While at it, fix the comment style of cs_index_mask.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20250331103609.4160281-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: cc34d77dd487 ("spi: use generic driver_override infrastructure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spi/spi.h | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 71ad766932d31..825c41611852a 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -134,13 +134,6 @@ extern void spi_transfer_cs_change_delay_exec(struct spi_message *msg,
  * @max_speed_hz: Maximum clock rate to be used with this chip
  *	(on this board); may be changed by the device's driver.
  *	The spi_transfer.speed_hz can override this for each transfer.
- * @chip_select: Array of physical chipselect, spi->chipselect[i] gives
- *	the corresponding physical CS for logical CS i.
- * @mode: The spi mode defines how data is clocked out and in.
- *	This may be changed by the device's driver.
- *	The "active low" default for chipselect mode can be overridden
- *	(by specifying SPI_CS_HIGH) as can the "MSB first" default for
- *	each word in a transfer (by specifying SPI_LSB_FIRST).
  * @bits_per_word: Data transfers involve one or more words; word sizes
  *	like eight or 12 bits are common.  In-memory wordsizes are
  *	powers of two bytes (e.g. 20 bit samples use 32 bits).
@@ -148,6 +141,11 @@ extern void spi_transfer_cs_change_delay_exec(struct spi_message *msg,
  *	default (0) indicating protocol words are eight bit bytes.
  *	The spi_transfer.bits_per_word can override this for each transfer.
  * @rt: Make the pump thread real time priority.
+ * @mode: The spi mode defines how data is clocked out and in.
+ *	This may be changed by the device's driver.
+ *	The "active low" default for chipselect mode can be overridden
+ *	(by specifying SPI_CS_HIGH) as can the "MSB first" default for
+ *	each word in a transfer (by specifying SPI_LSB_FIRST).
  * @irq: Negative, or the number passed to request_irq() to receive
  *	interrupts from this device.
  * @controller_state: Controller's runtime state
@@ -160,8 +158,7 @@ extern void spi_transfer_cs_change_delay_exec(struct spi_message *msg,
  *	the device will bind to the named driver and only the named driver.
  *	Do not set directly, because core frees it; use driver_set_override() to
  *	set or clear it.
- * @cs_gpiod: Array of GPIO descriptors of the corresponding chipselect lines
- *	(optional, NULL when not using a GPIO line)
+ * @pcpu_statistics: statistics for the spi_device
  * @word_delay: delay to be inserted between consecutive
  *	words of a transfer
  * @cs_setup: delay to be introduced by the controller after CS is asserted
@@ -169,8 +166,11 @@ extern void spi_transfer_cs_change_delay_exec(struct spi_message *msg,
  * @cs_inactive: delay to be introduced by the controller after CS is
  *	deasserted. If @cs_change_delay is used from @spi_transfer, then the
  *	two delays will be added up.
- * @pcpu_statistics: statistics for the spi_device
+ * @chip_select: Array of physical chipselect, spi->chipselect[i] gives
+ *	the corresponding physical CS for logical CS i.
  * @cs_index_mask: Bit mask of the active chipselect(s) in the chipselect array
+ * @cs_gpiod: Array of GPIO descriptors of the corresponding chipselect lines
+ *	(optional, NULL when not using a GPIO line)
  *
  * A @spi_device is used to interchange data between an SPI slave
  * (usually a discrete chip) and CPU memory.
@@ -185,7 +185,6 @@ struct spi_device {
 	struct device		dev;
 	struct spi_controller	*controller;
 	u32			max_speed_hz;
-	u8			chip_select[SPI_CS_CNT_MAX];
 	u8			bits_per_word;
 	bool			rt;
 #define SPI_NO_TX		BIT(31)		/* No transmit wire */
@@ -216,23 +215,29 @@ struct spi_device {
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
 	const char		*driver_override;
-	struct gpio_desc	*cs_gpiod[SPI_CS_CNT_MAX];	/* Chip select gpio desc */
+
+	/* The statistics */
+	struct spi_statistics __percpu	*pcpu_statistics;
+
 	struct spi_delay	word_delay; /* Inter-word delay */
+
 	/* CS delays */
 	struct spi_delay	cs_setup;
 	struct spi_delay	cs_hold;
 	struct spi_delay	cs_inactive;
 
-	/* The statistics */
-	struct spi_statistics __percpu	*pcpu_statistics;
+	u8			chip_select[SPI_CS_CNT_MAX];
 
-	/* Bit mask of the chipselect(s) that the driver need to use from
-	 * the chipselect array.When the controller is capable to handle
+	/*
+	 * Bit mask of the chipselect(s) that the driver need to use from
+	 * the chipselect array. When the controller is capable to handle
 	 * multiple chip selects & memories are connected in parallel
 	 * then more than one bit need to be set in cs_index_mask.
 	 */
 	u32			cs_index_mask : SPI_CS_CNT_MAX;
 
+	struct gpio_desc	*cs_gpiod[SPI_CS_CNT_MAX];	/* Chip select gpio desc */
+
 	/*
 	 * Likely need more hooks for more protocol options affecting how
 	 * the controller talks to each chip, like:
-- 
2.53.0



