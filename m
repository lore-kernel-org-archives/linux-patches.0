Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03C4308F0A;
	Thu, 19 Feb 2026 02:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466695; cv=none; b=m5PAgc+4cDtu5YT9Q0KmphXGi/SLbYTaSw0KPTM3S2OstlptREhTAfYk5ziYEZ4i7Rfz6rJL4bpQYxyjQ8Ih6/+j8fNrTVIwKqwxc81JV6VzLTHwAnxHL5hLFv4hMb5Kf+F/EG84HODPpolf9UACFXse6GJyegXoTEJ1vE0aXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466695; c=relaxed/simple;
	bh=XHfSr++LfcSDnt9pFUweddD+5djdvkHfs20so8hqnXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mT8OgQ+AncS1nrMwEXJN36nemDKS7ZeDYfvAP0wtXVOFQJZVbpIEtG5Ik0QaNkhlm87yMAjF9ILW+lI5dBTSqVmnVBz9AspgIaltdkiATUdny3osc6DfOIbA5SMM9GM0f/KblaspVc0t0C5qanhy5UDJGU0Kzy70uMIkM48gE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pFQoy0A9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pFQoy0A9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A48C116D0;
	Thu, 19 Feb 2026 02:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466695;
	bh=XHfSr++LfcSDnt9pFUweddD+5djdvkHfs20so8hqnXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFQoy0A9O+MxLFB/Yv7YehDK31QxNo3qrW3J5sSAF6ZKfGL/VuNpoYfkZG4/W2eVV
	 z3DGvHOtNBc+JOJC3r90Qo8ikQO01YsGQRhnytKqkKcWEd7VUvWCMYR+2N3DWcWW1m
	 +I6FORd0ch5Jt7VhUay6FnHxbr9seD+kNIkKAJcJsP3fu6EfpSEUOBpN5efOtM1djI
	 y4xFw2of74Hej2hxtGrSNWDnpelieTwaxoCiK+1pe2LvCiMHlYPrVNeXyLVZ8pe1Gq
	 HiAdDRElzht+fDkEm6bJFj94HHlK1mxTMmMPXent8W+V+ZuLd0nInbekoZuuEYNxg6
	 xrLL92ObldVMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Derek J. Clark" <derekjohn.clark@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	lanzano.alex@gmail.com,
	jic23@kernel.org,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] iio: bmi270_i2c: Add MODULE_DEVICE_TABLE for BMI260/270
Date: Wed, 18 Feb 2026 21:04:01 -0500
Message-ID: <20260219020422.1539798-25-sashal@kernel.org>
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

From: "Derek J. Clark" <derekjohn.clark@gmail.com>

[ Upstream commit f69b5ac682dbc61e6aca806c22ce2ae74d598e45 ]

Currently BMI260 & BMI270 devices do not automatically load this
driver. To fix this, add missing MODULE_DEVICE_TABLE for the i2c,
acpi, and of device tables so the driver will load when the hardware
is detected.

Tested on my OneXPlayer F1 Pro.

Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So:
- v6.13: Driver introduced with BMI260 support (no MODULE_DEVICE_TABLE)
- v6.14-v6.16: No changes to this file
- v6.17: Added suspend/resume pm_ops (affects the `.pm = pm_ptr(...)`
  line in the driver struct)
- v6.18: Added BMI0260 ACPI ID

The MODULE_DEVICE_TABLE additions are simple line additions between
existing code, so they should apply cleanly to v6.13+ (possibly with
minor context adjustments for v6.17+ changes and v6.18+ ACPI table
differences). A minor backport adaptation may be needed for older stable
trees that don't have the BMI0260 ACPI entry or the pm_ptr line, but
these are trivial context issues.

### Summary

**What it fixes**: BMI260/BMI270 I2C driver doesn't autoload when
hardware is detected because `MODULE_DEVICE_TABLE` macros were never
added. Users must manually load the module.

**Why it matters**: This is a device enablement bug affecting real
consumer hardware (handheld gaming PCs like GPD Win Mini, Aya Neo, OXP
Mini Pro, OneXPlayer F1 Pro). The driver exists but doesn't work without
manual intervention.

**Risk**: Essentially zero. `MODULE_DEVICE_TABLE` is a compile-time-only
construct that generates module alias information. It cannot cause
runtime regressions.

**Scope**: 3 lines added in 1 file. Minimal, well-understood change.

**Stable criteria met**:
- Obviously correct (trivially so)
- Fixes a real bug (driver doesn't autoload)
- Small and contained
- No new features
- Tested on real hardware
- Reviewed by respected kernel developer

### Verification

- `git log --diff-filter=A -- drivers/iio/imu/bmi270/bmi270_i2c.c`
  confirmed driver was introduced in commit `3ea51548d6b25` (v6.13)
- `git show 3ea51548d6b25` confirmed the original driver never had
  `MODULE_DEVICE_TABLE` — this has been a bug since day one
- `git show f35f3c832eb58` confirmed BMI260 support (with ACPI and OF
  tables) was added in v6.13
- `git tag --contains 3ea51548d6b25` confirmed the driver is in v6.13+
- `git tag --contains dc757dc1572d5` confirmed the BMI0260 ACPI ID is
  only in v6.18+, so the backport may need minor context adjustment for
  older trees
- `git log --oneline v6.16..v6.17 --
  drivers/iio/imu/bmi270/bmi270_i2c.c` confirmed suspend/resume was
  added in v6.17, which affects context near the driver struct
- The change is purely additive (3 macro invocations), verified by
  reading the diff

**YES**

 drivers/iio/imu/bmi270/bmi270_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/imu/bmi270/bmi270_i2c.c b/drivers/iio/imu/bmi270/bmi270_i2c.c
index b909a421ad017..b92da4e0776fa 100644
--- a/drivers/iio/imu/bmi270/bmi270_i2c.c
+++ b/drivers/iio/imu/bmi270/bmi270_i2c.c
@@ -37,6 +37,7 @@ static const struct i2c_device_id bmi270_i2c_id[] = {
 	{ "bmi270", (kernel_ulong_t)&bmi270_chip_info },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, bmi270_i2c_id);
 
 static const struct acpi_device_id bmi270_acpi_match[] = {
 	/* GPD Win Mini, Aya Neo AIR Pro, OXP Mini Pro, etc. */
@@ -45,12 +46,14 @@ static const struct acpi_device_id bmi270_acpi_match[] = {
 	{ "BMI0260",  (kernel_ulong_t)&bmi260_chip_info },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, bmi270_acpi_match);
 
 static const struct of_device_id bmi270_of_match[] = {
 	{ .compatible = "bosch,bmi260", .data = &bmi260_chip_info },
 	{ .compatible = "bosch,bmi270", .data = &bmi270_chip_info },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, bmi270_of_match);
 
 static struct i2c_driver bmi270_i2c_driver = {
 	.driver = {
-- 
2.51.0

