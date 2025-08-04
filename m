Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EE52AE8E;
	Mon,  4 Aug 2025 00:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267648; cv=none; b=OQtAV3H5JnsmgVVBd04ooRv0kl30sCCg9qvJ3vX4w2XGIHhfMhmSrZIewIexLL5zBnId4PDEN7+aviROILGS4M+XwUwu4kBFXryaw4S26yp/9cp1QcK4oy3iyCn+qCzpSaTrlEA+ewCVevbC0aP4p9OyaHQ0BuVW27c7Ck206hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267648; c=relaxed/simple;
	bh=k6qjTOFhkTdzSGVjp+qijW3fkekNAcu+yYa059LfT/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Si1+/hrYdQZJSqiqTkVkWW7pOJ8qn8irxbq1xmRO29MGW3pnRljBraWSC9cEsSjEmDkIpWA5YriNdHaS6vgxay9ftZ7wubQOsITV2C5YjwVkQjiv/lToL4NJdTeBmAa9x9qG7z1GZuIBZ8yVv/SZ74rcx7gxfIzfKKHT2ltd2gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgmCkzRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgmCkzRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288D8C4CEF8;
	Mon,  4 Aug 2025 00:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267648;
	bh=k6qjTOFhkTdzSGVjp+qijW3fkekNAcu+yYa059LfT/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgmCkzRcXOsrKH4uK1Te8r4IKZ3bTkIwBnIqktLecxdPxOMIS33+ZYlrERZzxn3/c
	 5QaGd+hJPfNUjRqYi8Qn/C/9IC2l9JLnNsQ45WJPkx9QRDHSn/e2rGisuBP2/jsLF8
	 bvkqbni6sALwXczWPcb1q0IcJUVBzw7Wz61Wl69zaQTCUKAWXshNkzc1bd8zqH9DuS
	 ojqcjj2ttcXpfONQE6qEMHV9RumwRzz5mA4fOX2WGkjTEV6NoiEvS6D5LceF47YIfh
	 eRrO9wq3/Yiq1ZE9aAOJXdYu4l0s4bBmsJYxNgsjfu46ilJph6ZR5UEb6tNx0xbGKk
	 VgIF4SZfEVz3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xinxin Wan <xinxin.wan@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com
Subject: [PATCH AUTOSEL 6.12 68/69] ASoC: codecs: rt5640: Retry DEVICE_ID verification
Date: Sun,  3 Aug 2025 20:31:18 -0400
Message-Id: <20250804003119.3620476-68-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Xinxin Wan <xinxin.wan@intel.com>

[ Upstream commit 19f971057b2d7b99c80530ec1052b45de236a8da ]

To be more resilient to codec-detection failures when the hardware
powers on slowly, add retry mechanism to the device verification check.
Similar pattern is found throughout a number of Realtek codecs. Our
tests show that 60ms delay is sufficient to address readiness issues on
rt5640 chip.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Xinxin Wan <xinxin.wan@intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530142120.2944095-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Analysis of the Commit

### 1. Bug Fix Nature
This commit fixes a real-world hardware detection issue where the RT5640
codec device ID verification fails on systems where the hardware powers
on slowly. The failure results in the driver returning `-ENODEV` and the
audio codec not being initialized, causing complete audio failure.

### 2. Small and Contained Change
The fix is minimal and highly contained:
- Only adds 3 lines of code
- The change is isolated to the probe function's device ID verification
  logic
- No architectural changes or new features introduced
- The retry logic is simple: if initial ID read doesn't match, wait
  60-100ms and retry once

### 3. Clear Purpose with No Major Side Effects
The code change:
```c
regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+if (val != RT5640_DEVICE_ID) {
+    usleep_range(60000, 100000);
+    regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+}
```
- Only adds a single retry with delay if the first read fails
- The delay (60-100ms) is reasonable for probe-time initialization
- No impact on normal operation when hardware is ready

### 4. Follows Established Pattern
The commit message mentions "Similar pattern is found throughout a
number of Realtek codecs," and the probe function already contains a
400ms delay after enabling LDO1 (line 3004), showing that power-on
delays are expected for this hardware.

### 5. Minimal Risk of Regression
- The retry only occurs when device ID verification would have failed
  anyway
- In the worst case, it adds a 60-100ms delay to failed probe attempts
- Systems where the codec is ready immediately continue to work without
  delay
- The pattern is conservative: only one retry attempt

### 6. Important User Impact
Without this fix, affected systems experience:
- Complete audio failure on boot
- No audio codec detection
- Requires manual intervention or multiple reboots to get audio working

### 7. Stable Tree Suitability
This fix meets all stable kernel criteria:
- Fixes a real bug affecting users
- Minimal change with clear purpose
- No new features or APIs
- Low risk of introducing new issues
- Self-contained within a single driver

The commit represents a classic hardware quirk fix that improves
reliability without adding complexity, making it an ideal candidate for
stable backport.

 sound/soc/codecs/rt5640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 855139348edb..c366ae2275e8 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -3013,6 +3013,11 @@ static int rt5640_i2c_probe(struct i2c_client *i2c)
 	}
 
 	regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+	if (val != RT5640_DEVICE_ID) {
+		usleep_range(60000, 100000);
+		regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+	}
+
 	if (val != RT5640_DEVICE_ID) {
 		dev_err(&i2c->dev,
 			"Device with ID register %#x is not rt5640/39\n", val);
-- 
2.39.5

