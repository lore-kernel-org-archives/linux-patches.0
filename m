Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60587285CA2;
	Thu, 19 Feb 2026 02:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466697; cv=none; b=G3WZJ6x1a4bm4FsrytQKbI7IJ3cKwLjdV5Z+F2yuBa9ObIWyd5UdD6DMxF03Nv5rmPlHv4x7VSQzysJr4wrqDlyWvv7D0T+xWUP5x6QEcl+OpHa++pac5FpAj+A9whz75qa0p6uXAU4NEQNVtdh9MiSmusIvLaV/xP+QxVFUccQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466697; c=relaxed/simple;
	bh=7En8I07/4oFxJWOvuSQdW2P8VYxNHDDzzM8DUJKR2w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJaOrEefYVMzwQlTE7oxmYkwm4xcg0rEwv76x8DCk9txoIvB8L2y/kQLbauCzJI6hv6DQFU5vGG80usmWtDqInQfyTxHTOsjtHL2HYeSS7M9KNLiIZs+CM6ZRq/inLy62SHb5Xm4PpixOb1TcLXZ4a+MwdINdeqpgyZNwt7rSeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aH39I/qV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aH39I/qV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD6BC19422;
	Thu, 19 Feb 2026 02:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466697;
	bh=7En8I07/4oFxJWOvuSQdW2P8VYxNHDDzzM8DUJKR2w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aH39I/qVmlmTpMpx+TlXPHdX+UpmkIxvykw3l3t24N1KKXuMvNVWDJvhw2Jr9mFVq
	 6Q022yCi3OK+Ds0t6v4eAF8NhvJhkCCqptsKT7G8eYZwgWgqQm+xW2s2M8QWW9FKto
	 yhw3ure1h7k3S8aLVS5DJ7+5kiZmYyFDQUo8JPWXGZN9yCpaKb87bLJM95nq6Mbxce
	 JwWIGn+60TPZXvk0dV07mjE0YLtPkoS4s3eVYEEOcQrlzSCMPeVSMBMEYjnZSkbCee
	 M739OfkbTJOU06B9qdFD7N6BlTAzGgyqAmVDuNIkgmeTgEhTIM0+FmwJ3hROl058YM
	 VBn6+aVgJFFBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	jic23@kernel.org,
	lars@metafoo.de,
	Michael.Hennerich@analog.com,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] iio: Use IRQF_NO_THREAD
Date: Wed, 18 Feb 2026 21:04:02 -0500
Message-ID: <20260219020422.1539798-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 04d390af97f2c28166f7ddfe1a6bda622e3a4766 ]

The interrupt handler iio_trigger_generic_data_rdy_poll() will invoke
other interrupt handler and this supposed to happen from within the
hardirq.

Use IRQF_NO_THREAD to forbid forced-threading.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

`IRQF_NO_THREAD` has been available for a long time (it's a well-
established flag).

### Classification

This is a **bug fix for PREEMPT_RT kernels**. Without `IRQF_NO_THREAD`:
1. On PREEMPT_RT, the interrupt handler gets force-threaded
2. The handler runs in thread context instead of hardirq context
3. `iio_trigger_poll()` calls `generic_handle_irq()` which checks
   `in_hardirq()`
4. The check fails → `WARN_ON_ONCE` fires → sub-IRQ is not dispatched →
   **IIO trigger doesn't work**

This is not a theoretical issue — it's a complete functional breakage of
IIO triggers on PREEMPT_RT kernels.

### Scope and Risk Assessment

- **4 files changed**, each with a one-line flag addition
- No behavioral change on non-RT kernels (the flag is ignored when not
  force-threading)
- No risk of regression — `IRQF_NO_THREAD` is a well-understood, widely-
  used flag
- The fix is purely additive (adding a flag to existing IRQ registration
  calls)

### Risk vs Benefit

- **Risk**: Extremely low. Adding `IRQF_NO_THREAD` only prevents force-
  threading on RT kernels. On non-RT kernels, this flag is a no-op.
- **Benefit**: Fixes complete IIO trigger breakage for these four sensor
  drivers on PREEMPT_RT kernels.

### Concerns

1. **Scope**: This only fixes 4 of 19+ drivers that use
   `iio_trigger_generic_data_rdy_poll`. There may be other drivers
   needing the same fix, but each fix is self-contained.
2. **Dependencies**: None. This is a simple flag addition that applies
   cleanly.
3. **Affected versions**: Any kernel with PREEMPT_RT support and these
   IIO drivers.

### Verification

- Read `iio_trigger_generic_data_rdy_poll()` at
  `drivers/iio/industrialio-trigger.c:212` — confirmed it calls
  `iio_trigger_poll()` which calls `generic_handle_irq()` at line 204
- Read `iio_trigger_poll()` comment at line 193: "This function should
  only be called from a hard IRQ context" — confirmed the hardirq
  requirement
- Read `kernel/irq/irqdesc.c:666`: confirmed `WARN_ON_ONCE(!in_hardirq()
  ...)` check that would trigger if called from thread context
- Read `ad7766_irq()` at `drivers/iio/adc/ad7766.c:187-191`: confirmed
  it also calls `iio_trigger_poll()` directly, same issue
- Confirmed `IRQF_NO_THREAD` is defined in
  `include/linux/interrupt.h:83` and has been available for a long time
- Confirmed author Sebastian Andrzej Siewior is the PREEMPT_RT
  maintainer — this is from someone with deep expertise
- Confirmed reviewer Andy Shevchenko and IIO maintainer Jonathan Cameron
  signed off
- `PREEMPT_RT` config option exists since at least v5.x (2019), so this
  affects stable trees
- Confirmed no behavioral change on non-RT kernels (IRQF_NO_THREAD is
  ignored when not force-threading)

### Conclusion

This is a small, surgical, obviously correct fix for a real bug that
causes complete IIO trigger failure on PREEMPT_RT kernels. It adds
`IRQF_NO_THREAD` to four IRQ registrations where the handler must run in
hardirq context (because it calls `generic_handle_irq()`). The fix has
zero risk on non-RT kernels and is essential for RT kernel users. It
meets all stable kernel criteria: fixes a real bug, is small and
contained, is obviously correct, and doesn't introduce new features.

**YES**

 drivers/iio/accel/bma180.c        | 5 +++--
 drivers/iio/adc/ad7766.c          | 2 +-
 drivers/iio/gyro/itg3200_buffer.c | 8 +++-----
 drivers/iio/light/si1145.c        | 2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 8925f5279e627..7bc6761f51354 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -986,8 +986,9 @@ static int bma180_probe(struct i2c_client *client)
 		}
 
 		ret = devm_request_irq(dev, client->irq,
-			iio_trigger_generic_data_rdy_poll, IRQF_TRIGGER_RISING,
-			"bma180_event", data->trig);
+				       iio_trigger_generic_data_rdy_poll,
+				       IRQF_TRIGGER_RISING | IRQF_NO_THREAD,
+				       "bma180_event", data->trig);
 		if (ret) {
 			dev_err(dev, "unable to request IRQ\n");
 			goto err_trigger_free;
diff --git a/drivers/iio/adc/ad7766.c b/drivers/iio/adc/ad7766.c
index 4d570383ef025..1e6bfe8765ab3 100644
--- a/drivers/iio/adc/ad7766.c
+++ b/drivers/iio/adc/ad7766.c
@@ -261,7 +261,7 @@ static int ad7766_probe(struct spi_device *spi)
 		 * don't enable the interrupt to avoid extra load on the system
 		 */
 		ret = devm_request_irq(&spi->dev, spi->irq, ad7766_irq,
-				       IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN,
+				       IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN | IRQF_NO_THREAD,
 				       dev_name(&spi->dev),
 				       ad7766->trig);
 		if (ret < 0)
diff --git a/drivers/iio/gyro/itg3200_buffer.c b/drivers/iio/gyro/itg3200_buffer.c
index a624400a239cb..cf97adfa97274 100644
--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -118,11 +118,9 @@ int itg3200_probe_trigger(struct iio_dev *indio_dev)
 	if (!st->trig)
 		return -ENOMEM;
 
-	ret = request_irq(st->i2c->irq,
-			  &iio_trigger_generic_data_rdy_poll,
-			  IRQF_TRIGGER_RISING,
-			  "itg3200_data_rdy",
-			  st->trig);
+	ret = request_irq(st->i2c->irq, &iio_trigger_generic_data_rdy_poll,
+			  IRQF_TRIGGER_RISING | IRQF_NO_THREAD,
+			  "itg3200_data_rdy", st->trig);
 	if (ret)
 		goto error_free_trig;
 
diff --git a/drivers/iio/light/si1145.c b/drivers/iio/light/si1145.c
index f8eb251eca8dc..ef0abc4499b74 100644
--- a/drivers/iio/light/si1145.c
+++ b/drivers/iio/light/si1145.c
@@ -1248,7 +1248,7 @@ static int si1145_probe_trigger(struct iio_dev *indio_dev)
 
 	ret = devm_request_irq(&client->dev, client->irq,
 			  iio_trigger_generic_data_rdy_poll,
-			  IRQF_TRIGGER_FALLING,
+			  IRQF_TRIGGER_FALLING | IRQF_NO_THREAD,
 			  "si1145_irq",
 			  trig);
 	if (ret < 0) {
-- 
2.51.0

