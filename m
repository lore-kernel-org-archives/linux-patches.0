Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2AF3081D4;
	Sat, 25 Oct 2025 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409584; cv=none; b=e/gCYyDnbPuOBl2WDWRQ9pkB9T0uhtGj8UHlf1QlH+7dQWMs3R1Atci2W/6ot3DXhNpOnNSZAX2JdrV1x/SntDQYyirqsLYF9okpmvJQp7Vi2jFfH3RkECI9PLJaCNxcftaXPt3moffa0PJ/agh34Jj6HGva2fWCALddVx8gQAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409584; c=relaxed/simple;
	bh=PiYJFepj4BkcAzZZOM34fZvaafj2TLZDVJCaAxH7ux8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3rFM6wjJW0ScoS4heTlh9tYMTagmhXsvnMlXnJe5qzsFh6s4O5DJ5plzd81c1yqNg/25lN/db6bDKM0mLDqhvhRRJAPuMRJG8BBShLzhW7cYs30Ttiyg06pDJkUpnewQNnBedb4JvgN8oMfUNhr1FhJSYSzGJms1+9EcQGzdrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hebykwz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hebykwz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB5AC4CEFB;
	Sat, 25 Oct 2025 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409584;
	bh=PiYJFepj4BkcAzZZOM34fZvaafj2TLZDVJCaAxH7ux8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hebykwz2dTrV4/TdeM7mThHLs8f5bWLENC08oFEGIZzsadAULBsztR4eqWHmYN4kD
	 MRsw5/XAEPvSD9TiwG+ZCVMhNzMdpzNNUOXrhOGAnm/Pyy7DvJKwO8zRSESDf7r7ha
	 HoGPBroy9P+0Rw/hwrABsMVQufDZK5HnFIF2QlNaePV5EsXh7qA9TGq9x/zPWEd5pa
	 IH3kVCGrx8T3NWNtsXwWtE8/yJ6LCZUeUxveHMCOvUu22mRbEEUISHQdScPjwblKl4
	 Wi9dv8OrlnfqpaMsc7oRdU+x/LMKiw86xiXNL/o/kRL/P4BHkT05sn6BGUft0pyIDF
	 WSh0YVKsfM+aQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	andy@kernel.org,
	alexandre.f.demers@gmail.com,
	zhao.xichao@vivo.com
Subject: [PATCH AUTOSEL 6.17-5.4] iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register
Date: Sat, 25 Oct 2025 12:00:08 -0400
Message-ID: <20251025160905.3857885-377-sashal@kernel.org>
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

From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

[ Upstream commit d75c7021c08e8ae3f311ef2464dca0eaf75fab9f ]

avg sample info is a bit field coded inside the following
bits: 5,6,7 and 8 of a device status register.

Channel num info the same, but over bits: 1, 2 and 3.

Mask both values in order to avoid touching other register bits,
since the first info (avg sample), came from DT.

Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250717221559.158872-1-rodrigo.gobbi.7@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Bug fixed: The original code shifts unmasked values into the status
  register, so out-of-range inputs can clobber unrelated control bits.
  Specifically, `avg_samples` is read from firmware/DT without runtime
  validation and then used as
  `SPEAR_ADC_STATUS_AVG_SAMPLE(st->avg_samples)` (a plain left shift)
  when building the status word in `spear_adc_read_raw()` at
  drivers/iio/adc/spear_adc.c:160 and drivers/iio/adc/spear_adc.c:161.
  Since the average field resides in bits 5–8, any high bit of
  `avg_samples` bleeds into higher status bits. Critically, if
  `avg_samples` has bit 4 set (value >= 16), then `(x << 5)` sets bit 9,
  which is `SPEAR_ADC_STATUS_VREF_INTERNAL`
  (drivers/iio/adc/spear_adc.c:35). That can force internal Vref
  selection even when an external Vref is configured, causing wrong
  measurements and unpredictable behavior.
- Source of the risk: `avg_samples` comes from DT via
  `device_property_read_u32(dev, "average-samples", &st->avg_samples);`
  with no runtime bounds checking (drivers/iio/adc/spear_adc.c:319).
  While the binding restricts it to 0..15
  (Documentation/devicetree/bindings/iio/adc/st,spear600-adc.yaml:43),
  the driver cannot rely on DT schema validation being present or
  enforced at runtime.
- The fix: The patch adds `#include <linux/bitfield.h>` and replaces the
  shift macros with masks using `GENMASK` and `FIELD_PREP`, ensuring
  values are masked to their field width before being merged:
  - Replaces `#define SPEAR_ADC_STATUS_CHANNEL_NUM(x) ((x) << 1)`
    (drivers/iio/adc/spear_adc.c:32) with `#define
    SPEAR_ADC_STATUS_CHANNEL_NUM_MASK GENMASK(3, 1)` and uses
    `FIELD_PREP` when composing the register.
  - Replaces `#define SPEAR_ADC_STATUS_AVG_SAMPLE(x) ((x) << 5)`
    (drivers/iio/adc/spear_adc.c:34) with `#define
    SPEAR_ADC_STATUS_AVG_SAMPLE_MASK GENMASK(8, 5)` and uses
    `FIELD_PREP`.
  - In `spear_adc_read_raw()`, it now uses
    `FIELD_PREP(SPEAR_ADC_STATUS_CHANNEL_NUM_MASK, chan->channel)` and
    `FIELD_PREP(SPEAR_ADC_STATUS_AVG_SAMPLE_MASK, st->avg_samples)`
    instead of raw shifts when building `status`.
- Scope and risk: The change is small and localized to a single driver
  and code path used for starting a conversion. It introduces no new
  features or architectural changes. The new include
  `<linux/bitfield.h>` is standard in supported stable kernels and
  `FIELD_PREP/GENMASK` are widely used in-tree. Masking the channel is
  also a safe improvement (even though `chan->channel` is in-range),
  keeping register writes robust.
- User impact: Prevents accidental toggling of unrelated control bits
  (notably Vref selection) and writing ones to reserved/unknown bits if
  DT passes an out-of-range `average-samples`. This is a clear
  functional bug that can affect users with misconfigured or legacy DTs.
- Stable criteria:
  - Fixes a real bug (register bit clobbering; can produce incorrect ADC
    behavior).
  - Minimal and contained change.
  - No functional side effects beyond enforcing correct bitfields.
  - Touches a single IIO ADC driver, not core subsystems.
  - Commit message explains rationale; even without an explicit “Cc:
    stable” tag, it meets stable backport rules.

Conclusion: This is a straightforward, low-risk bug fix that prevents
corruption of control bits when programming the ADC status register. It
should be backported to stable.

 drivers/iio/adc/spear_adc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/spear_adc.c b/drivers/iio/adc/spear_adc.c
index e3a865c79686e..df100dce77da4 100644
--- a/drivers/iio/adc/spear_adc.c
+++ b/drivers/iio/adc/spear_adc.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/completion.h>
@@ -29,9 +30,9 @@
 
 /* Bit definitions for SPEAR_ADC_STATUS */
 #define SPEAR_ADC_STATUS_START_CONVERSION	BIT(0)
-#define SPEAR_ADC_STATUS_CHANNEL_NUM(x)		((x) << 1)
+#define SPEAR_ADC_STATUS_CHANNEL_NUM_MASK	GENMASK(3, 1)
 #define SPEAR_ADC_STATUS_ADC_ENABLE		BIT(4)
-#define SPEAR_ADC_STATUS_AVG_SAMPLE(x)		((x) << 5)
+#define SPEAR_ADC_STATUS_AVG_SAMPLE_MASK	GENMASK(8, 5)
 #define SPEAR_ADC_STATUS_VREF_INTERNAL		BIT(9)
 
 #define SPEAR_ADC_DATA_MASK		0x03ff
@@ -157,8 +158,8 @@ static int spear_adc_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_RAW:
 		mutex_lock(&st->lock);
 
-		status = SPEAR_ADC_STATUS_CHANNEL_NUM(chan->channel) |
-			SPEAR_ADC_STATUS_AVG_SAMPLE(st->avg_samples) |
+		status = FIELD_PREP(SPEAR_ADC_STATUS_CHANNEL_NUM_MASK, chan->channel) |
+			FIELD_PREP(SPEAR_ADC_STATUS_AVG_SAMPLE_MASK, st->avg_samples) |
 			SPEAR_ADC_STATUS_START_CONVERSION |
 			SPEAR_ADC_STATUS_ADC_ENABLE;
 		if (st->vref_external == 0)
-- 
2.51.0

