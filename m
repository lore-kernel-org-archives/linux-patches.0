Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1596322689C;
	Sat, 25 Oct 2025 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408613; cv=none; b=fvAWsPas6nhuvmX8iKzfUB4Zy/WZE6uClTOp4XTNrTW9GNLAFLDcV2XVKVO+pgHxScagSr6lLUaJfyn0QL+zqEH4dKX9NMoPMPT0Gxu9pbQUruOPTZJ2ld4J6x6UAiLMcAbEZ9YEsAixlB2BaX3tRAcKNyurzLz2d3xNfk2++xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408613; c=relaxed/simple;
	bh=isqCRwOCBVRNqs2PP7VApvkhVQSV1C4LUQqkc8P6sLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BG2VjHaX369YNAMe74L8Xovtbpsy9LyW/geId0K+x1pYknHJlVZXFyVJhXgqQ9s33lYMZNc9A0D+mld4jqEfK3O2anqMXypnkKNaQEnL+X9UsP9sd2/U5aqJAfBdC8Kea33BD86vyqKSZAohvVd7bLJ668GQGLY2YSLX2fblnoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYtxWHVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYtxWHVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F1BC4CEFF;
	Sat, 25 Oct 2025 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408612;
	bh=isqCRwOCBVRNqs2PP7VApvkhVQSV1C4LUQqkc8P6sLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYtxWHVWdY3g9iuss4UaUCmz906KVco75LesQpjQ/qF3Z/cn3bjvN6nOvt8jkUFMe
	 kiGKLIhkkhk+yYGd74C437FZK2chpSfK78R9YHsaaho1EicVyzS9uKd+6RYGNVF5+W
	 kZq1pzEuwzHBEgdVKWxdI0m6nE9PurzzaWiXHZ/RBXnIll6XxCj5XGV0PGUKMDWko0
	 GIh64pmzDhd35o9ES3X/veuwzjqs3tvOG40leqlN07UbizN4AzeTmCj+0NtSs/ZWxs
	 E+ALs31o+mEb0DMmhcmOpllYBHd7nUhaWfJpbFKchp/LFX5UGomIcjIhYQad+1Myp1
	 1u3QX4CmzKoFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	lars@metafoo.de,
	Michael.Hennerich@analog.com
Subject: [PATCH AUTOSEL 6.17] iio: adc: ad7124: do not require mclk
Date: Sat, 25 Oct 2025 11:54:15 -0400
Message-ID: <20251025160905.3857885-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit aead8e4cc04612f74c7277de137cc995df280829 ]

Make the "mclk" clock optional in the ad7124 driver. The MCLK is an
internal counter on the ADC, so it is not something that should be
coming from the devicetree. However, existing users may be using this
to essentially select the power mode of the ADC from the devicetree.
In order to not break those users, we have to keep the existing "mclk"
handling, but now it is optional.

Now, when the "mclk" clock is omitted from the devicetree, the driver
will default to the full power mode. Support for an external clock
and dynamic power mode switching can be added later if needed.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250828-iio-adc-ad7124-proper-clock-support-v3-2-0b317b4605e5@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation:
- Fixes a real usability bug: The driver previously required a DT “mclk”
  that represents the ADC’s internal master clock, which is not a
  hardware-provided clock. That caused probe failures or forced fake
  clock providers in DTS. Making it optional lets the driver work on
  correct DTs without a fake clock, which benefits users and
  downstreams.
- Small, contained change in one driver: All changes are local to
  `drivers/iio/adc/ad7124.c`, with no ABI or cross-subsystem impact.

Key code changes and rationale:
- Optional clock retrieval, not mandatory:
  - Probe path: Removes the unconditional
    `devm_clk_get_enabled(&spi->dev, "mclk")` and any `st->mclk` state.
    Instead, `ad7124_setup()` now calls
    `devm_clk_get_optional_enabled(dev, "mclk")` and proceeds if it’s
    absent. This directly fixes the “fake mclk required” problem while
    preserving support for legacy DTS that specify it.
- Sensible default behavior without DT clock:
  - `ad7124_setup()` now defaults to full power mode via
    `AD7124_ADC_CONTROL_POWER_MODE_FULL` when no “mclk” is provided,
    aligning with device expectations and maximizing performance by
    default. This maintains a consistent, predictable baseline when the
    DT no longer provides the legacy clock.
- Backwards compatibility with existing DTS using “mclk”:
  - If “mclk” is present, the driver derives `power_mode` from its rate
    via `ad7124_find_closest_match(ad7124_master_clk_freq_hz, …,
    mclk_hz)` and keeps the existing behavior. It even attempts
    `clk_set_rate(mclk, mclk_hz)` to preserve prior semantics. This
    avoids breaking older device trees that used “mclk” as a proxy for
    power mode.
- Correct ODR calculation without a real clock:
  - `ad7124_set_channel_odr()` switches from `fclk =
    clk_get_rate(st->mclk)` to using the ADC’s internal master clock
    frequency table: `fclk =
    ad7124_master_clk_freq_hz[FIELD_GET(AD7124_ADC_CONTROL_POWER_MODE,
    st->adc_control)]`. This is the right model for this ADC (MCLK is
    internal and determined by power mode), and avoids dependency on a
    fake external rate. The FS computation and clamping remain unchanged
    (DIV_ROUND_CLOSEST, clamp to [1..2047]), so behavior is stable aside
    from using the correct source clock.
- No functional loss or architectural change:
  - The change doesn’t remove capabilities; it simply makes “mclk”
    optional and aligns the f_clk source with the hardware model. It
    also leaves a clear path for adding true external clock support and
    dynamic power-mode switching later without affecting current stable
    users.

Risk assessment:
- Low regression risk:
  - Existing DTs specifying “mclk” continue to work, with `power_mode`
    still selected based on that rate.
  - DTs without “mclk” now work (previously failed), defaulting to full
    power. Increased power use is the intended default and preferable to
    a probe failure; it’s not a regression for any previously working
    configuration.
  - Changes are isolated to the driver and maintain the same IIO ABI.
- No security concerns and no critical subsystem changes.

Stable tree suitability:
- Addresses a real-world misconfiguration/DT friction that blocks driver
  use.
- Minimal, targeted changes; no feature additions; follows stable policy
  of important low-risk fixes.
- Commit message clearly states intent and backwards compatibility with
  existing DTs.

Conclusion: This is a good, low-risk bugfix for stable backporting.

 drivers/iio/adc/ad7124.c | 62 ++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 4d8c6bafd1c31..ed35d2a8bbf1b 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -174,7 +174,6 @@ struct ad7124_state {
 	struct ad_sigma_delta sd;
 	struct ad7124_channel *channels;
 	struct regulator *vref[4];
-	struct clk *mclk;
 	unsigned int adc_control;
 	unsigned int num_channels;
 	struct mutex cfgs_lock; /* lock for configs access */
@@ -254,7 +253,9 @@ static void ad7124_set_channel_odr(struct ad7124_state *st, unsigned int channel
 {
 	unsigned int fclk, odr_sel_bits;
 
-	fclk = clk_get_rate(st->mclk);
+	fclk = ad7124_master_clk_freq_hz[FIELD_GET(AD7124_ADC_CONTROL_POWER_MODE,
+						   st->adc_control)];
+
 	/*
 	 * FS[10:0] = fCLK / (fADC x 32) where:
 	 * fADC is the output data rate
@@ -1111,21 +1112,50 @@ static int ad7124_parse_channel_config(struct iio_dev *indio_dev,
 static int ad7124_setup(struct ad7124_state *st)
 {
 	struct device *dev = &st->sd.spi->dev;
-	unsigned int fclk, power_mode;
+	unsigned int power_mode;
+	struct clk *mclk;
 	int i, ret;
 
-	fclk = clk_get_rate(st->mclk);
-	if (!fclk)
-		return dev_err_probe(dev, -EINVAL, "Failed to get mclk rate\n");
+	/*
+	 * Always use full power mode for max performance. If needed, the driver
+	 * could be adapted to use a dynamic power mode based on the requested
+	 * output data rate.
+	 */
+	power_mode = AD7124_ADC_CONTROL_POWER_MODE_FULL;
 
-	/* The power mode changes the master clock frequency */
-	power_mode = ad7124_find_closest_match(ad7124_master_clk_freq_hz,
-					ARRAY_SIZE(ad7124_master_clk_freq_hz),
-					fclk);
-	if (fclk != ad7124_master_clk_freq_hz[power_mode]) {
-		ret = clk_set_rate(st->mclk, fclk);
-		if (ret)
-			return dev_err_probe(dev, ret, "Failed to set mclk rate\n");
+	/*
+	 * This "mclk" business is needed for backwards compatibility with old
+	 * devicetrees that specified a fake clock named "mclk" to select the
+	 * power mode.
+	 */
+	mclk = devm_clk_get_optional_enabled(dev, "mclk");
+	if (IS_ERR(mclk))
+		return dev_err_probe(dev, PTR_ERR(mclk), "Failed to get mclk\n");
+
+	if (mclk) {
+		unsigned long mclk_hz;
+
+		mclk_hz = clk_get_rate(mclk);
+		if (!mclk_hz)
+			return dev_err_probe(dev, -EINVAL,
+					     "Failed to get mclk rate\n");
+
+		/*
+		 * This logic is a bit backwards, which is why it is only here
+		 * for backwards compatibility. The driver should be able to set
+		 * the power mode as it sees fit and the f_clk/mclk rate should
+		 * be dynamic accordingly. But here, we are selecting a fixed
+		 * power mode based on the given "mclk" rate.
+		 */
+		power_mode = ad7124_find_closest_match(ad7124_master_clk_freq_hz,
+			ARRAY_SIZE(ad7124_master_clk_freq_hz), mclk_hz);
+
+		if (mclk_hz != ad7124_master_clk_freq_hz[power_mode]) {
+			ret = clk_set_rate(mclk, mclk_hz);
+			if (ret)
+				return dev_err_probe(dev, ret,
+						     "Failed to set mclk rate\n");
+		}
 	}
 
 	/* Set the power mode */
@@ -1303,10 +1333,6 @@ static int ad7124_probe(struct spi_device *spi)
 			return dev_err_probe(dev, ret, "Failed to register disable handler for regulator #%d\n", i);
 	}
 
-	st->mclk = devm_clk_get_enabled(&spi->dev, "mclk");
-	if (IS_ERR(st->mclk))
-		return dev_err_probe(dev, PTR_ERR(st->mclk), "Failed to get mclk\n");
-
 	ret = ad7124_soft_reset(st);
 	if (ret < 0)
 		return ret;
-- 
2.51.0

