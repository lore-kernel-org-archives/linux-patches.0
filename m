Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFDF27FD59;
	Tue, 20 Jan 2026 19:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768937703; cv=none; b=m67xNEDKRLQ2RsCeZaqK227eu+S49SSBqqKDSEjRLc1Njju1z2mpPjyCcw1wwVzLqMpLmVlrqyW4z0TXo0osXFUL6py82yd8rTiD2HaIOrlk6m2pjTLM8NVgFxXJIDZygzSEXnVZVSk81mppcXVwtQq1BdsJhROXvtkFpjP/2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768937703; c=relaxed/simple;
	bh=RBwba5PH5VB3vWbCNV2r9x5/crOibO5WxEaYcKLXAmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7amhc/q2sDHBxI7fwvHmNBFU5D34wcYbeetWL+TH3s7/TMhEZHDtcYHwpQk237pzdEvZqTgYMtvoYU0szGzPGiq8P/Hs0wfNNNIdKWS2T0gkEvN8oiq1gyJubAoCWwQxAXGqRtUU2uyK9Zj1Mf2FxnrSBJG1HIUTsVLHa7ftCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoN+0wTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoN+0wTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0085AC2BC86;
	Tue, 20 Jan 2026 19:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768937703;
	bh=RBwba5PH5VB3vWbCNV2r9x5/crOibO5WxEaYcKLXAmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoN+0wTDlp5v/wc4AqTd48xaLZ7sOpDiD6dzlkmCzk2QwfoBb6KHvVNws7YaE06dD
	 Nmd668aEjANA3JRnlFd8XUetahYvWcSV+ztHbdXVUdA7e2kgf3fB2wM1tjf0/1WkKO
	 h8NsOIvJYykuGzp4gzUVBXUl7W4G1FSrujLRNIcZ79O5zFdzlIA84+Eoc5rJDlzmoj
	 VmhngsBG73ooy8kxW1E6bqbNcHVkdzwm9b7Vn666NA5kWwWt6I+1do8AuK28oE/w90
	 Qh1Ho988NqAZXZ78ZyJLqkORSTAPKaKBwmuPKWfGhATfe4OlSnhu2E54T1WpqZsG+p
	 i3GEz9ixlPUgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dimitrios Katsaros <patcherwork@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: tlv320adcx140: Propagate error codes during probe
Date: Tue, 20 Jan 2026 14:34:46 -0500
Message-ID: <20260120193456.865383-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120193456.865383-1-sashal@kernel.org>
References: <20260120193456.865383-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.6
Content-Transfer-Encoding: 8bit

From: Dimitrios Katsaros <patcherwork@gmail.com>

[ Upstream commit d89aad92cfd15edbd704746f44c98fe687f9366f ]

When scanning for the reset pin, we could get an -EPROBE_DEFER.
The driver would assume that no reset pin had been defined,
which would mean that the chip would never be powered.

Now we both respect any error we get from devm_gpiod_get_optional.
We also now properly report the missing GPIO definition when
'gpio_reset' is NULL.

Signed-off-by: Dimitrios Katsaros <patcherwork@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://patch.msgid.link/20260113-sound-soc-codecs-tvl320adcx140-v4-3-8f7ecec525c8@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms my analysis. In `adcx140_reset()`, the code checks `if
(adcx140->gpio_reset)`. An error pointer like `-EPROBE_DEFER` evaluates
to TRUE (non-zero), so if the original code allowed an error pointer to
be stored, this function would try to use an invalid descriptor -
leading to a crash or undefined behavior.

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS
- The commit message clearly explains the bug: `-EPROBE_DEFER` was being
  swallowed when getting the reset GPIO
- The consequence is that "the chip would never be powered" - this is a
  real functionality bug
- The fix properly propagates errors and only logs "missing GPIO" when
  the GPIO is actually NULL

### 2. CODE CHANGE ANALYSIS
**The Bug:**
- `devm_gpiod_get_optional()` can return error pointers (e.g.,
  `-EPROBE_DEFER`)
- The original code only logged a message when `IS_ERR()` was true, but
  continued execution
- If `-EPROBE_DEFER` was returned, the driver would fail silently - the
  device would not work properly
- Worse, an error pointer would pass the `if (adcx140->gpio_reset)`
  check in `adcx140_reset()`, potentially causing crashes

**The Fix:**
- Properly returns errors from `devm_gpiod_get_optional()` using
  `dev_err_probe()`
- `dev_err_probe()` is the modern idiom that handles `-EPROBE_DEFER`
  cleanly (doesn't spam logs)
- The informational message is now correctly tied to
  `!adcx140->gpio_reset` (GPIO truly not defined)

### 3. CLASSIFICATION
- **Bug fix**: Yes - fixes improper error handling that causes device
  malfunction
- **Security**: No
- **New feature**: No - this is correcting existing broken behavior
- **Exception category**: Not a device ID/quirk/DT fix, but a standard
  bug fix

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed**: Only ~4 lines modified
- **Files touched**: 1 file (single audio codec driver)
- **Complexity**: Very low - straightforward error handling fix
- **Risk**: Very low - the change is localized and makes the code behave
  correctly
- **Subsystem**: ASoC codec driver (specific hardware, not core
  infrastructure)

### 5. USER IMPACT
- **Who is affected**: Users of TLV320ADCx140 family audio codecs (TI
  ADCs)
- **Severity**: Without this fix, the device may fail to initialize
  properly when GPIO provider isn't ready yet
- **Real-world impact**: The `-EPROBE_DEFER` case is common during early
  boot when GPIO controllers aren't yet initialized

### 6. STABILITY INDICATORS
- Has `Signed-off-by` from the patch author and subsystem maintainer
  (Mark Brown)
- Standard error handling pattern used in many other drivers

### 7. DEPENDENCY CHECK
- No dependencies on other commits
- The driver has existed since kernel 5.7 (added Feb 2020)
- This fix should apply cleanly to all stable kernels that have this
  driver

### Conclusion

This is an **excellent candidate for stable backport** because:
1. It fixes a real bug where `-EPROBE_DEFER` is swallowed, causing
   device initialization failure
2. The fix is small, surgical, and obviously correct
3. It uses the modern `dev_err_probe()` pattern that's standard across
   the kernel
4. Risk of regression is minimal - it only changes error handling to do
   the right thing
5. The bug has existed since the driver was introduced, affecting all
   users of this codec

**YES**

 sound/soc/codecs/tlv320adcx140.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index d594bf166c0e7..bcbc240248342 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -1158,6 +1158,9 @@ static int adcx140_i2c_probe(struct i2c_client *i2c)
 	adcx140->gpio_reset = devm_gpiod_get_optional(adcx140->dev,
 						      "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(adcx140->gpio_reset))
+		return dev_err_probe(&i2c->dev, PTR_ERR(adcx140->gpio_reset),
+				     "Failed to get Reset GPIO\n");
+	if (!adcx140->gpio_reset)
 		dev_info(&i2c->dev, "Reset GPIO not defined\n");
 
 	adcx140->supply_areg = devm_regulator_get_optional(adcx140->dev,
-- 
2.51.0

