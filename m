Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC89621CC51;
	Sat, 14 Feb 2026 01:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031089; cv=none; b=PrwxQ1Mevdk8RZtmmyeL5G0DxyHWqUHyBQIXLyaIC8jg8YbEPxKHqcO/a82B6JeQP8zC1vOOPWuBQ+Zc4EHOBd0AbxFhswoM6y+cLjT3yplxmZkWYAlHyVAHDcd3HyAAB3+SpEems3tS0CiMVn7Kqnh6WKO4Mjxw9B6Y1xyY4nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031089; c=relaxed/simple;
	bh=RltvkgbiOio83qQupUFJ2gLje9Ee9CeirjZn3HX7XiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ca7n6GukImV4qe07iTitQ7/kD+iBTW+oeoaLwlh9Rofj+LRrnuHjEB377+DJTkitQN1ibu0YNfmkdJZZdJE9DJGujN03rzKnvqMs8DT/InbCovb/9s2e4jPpj7chGN4VkF1+KVSzkdV+QJrLUuwjKhbznu1mNoZzu+07QuL7Hyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWi2SCEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWi2SCEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0BDC16AAE;
	Sat, 14 Feb 2026 01:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031088;
	bh=RltvkgbiOio83qQupUFJ2gLje9Ee9CeirjZn3HX7XiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWi2SCEyOWsKiFa69vWwIyYJyn5rdkUxvot4m4CWi9NqXp+yElhv+1pHMQtsX01Jb
	 8/pQVum+B/UuGP8IZotYPj6oJldiFChuCXjS6ds3qLaJ5mU6XaWTEz5V6NEagyl1nj
	 FtD+PoES1irBZZCj1TPxDUcLUI3upZ0ktRyc0kqHRHYEvrddhtl66pk0u2Uf/Fhm5K
	 AlXI0p+YU0jIfFJeJBbdyvGov4xU30IJagr+GrQKbgR7mfNRVsfEFVbsgaTZ6ziplN
	 0mIX/+yaL7DMorxd5YPnNuGtC5WTGTXPgHX+YfPJiogydKn/a6Dw9Pza353KpIXg4f
	 BWj1EF81RYY2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hsieh Hung-En <hungen3108@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	kuninori.morimoto.gx@renesas.com,
	yelangyan@huaqin.corp-partner.google.com,
	nicolas.frattaroli@collabora.com
Subject: [PATCH AUTOSEL 6.19-5.10] ASoC: es8328: Add error unwind in resume
Date: Fri, 13 Feb 2026 19:58:56 -0500
Message-ID: <20260214010245.3671907-56-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hsieh Hung-En <hungen3108@gmail.com>

[ Upstream commit 8232e6079ae6f8d3a61d87973cb427385aa469b9 ]

Handle failures in the resume path by unwinding previously enabled
resources.

If enabling regulators or syncing the regcache fails, disable regulators
and unprepare the clock to avoid leaking resources and leaving the device
in a partially resumed state.

Signed-off-by: Hsieh Hung-En <hungen3108@gmail.com>
Link: https://patch.msgid.link/20260130160017.2630-6-hungen3108@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ASoC: es8328: Add error unwind in resume

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes adding error unwinding in the
resume path of the ES8328 audio codec driver. The key phrases are:
- "Handle failures in the resume path by unwinding previously enabled
  resources"
- "avoid leaking resources and leaving the device in a partially resumed
  state"

This is a **resource leak fix** on error paths — a classic stable-worthy
bug fix pattern.

### 2. CODE CHANGE ANALYSIS

The change is in `es8328_resume()`:

**Before:** Two error paths (`regulator_bulk_enable` failure and
`regcache_sync` failure) would `return ret` directly without cleaning up
previously acquired resources.

**Bug 1:** If `regulator_bulk_enable()` fails, the clock
(`clk_prepare_enable`) was already enabled but never disabled → **clock
leak**.

**Bug 2:** If `regcache_sync()` fails, both the clock and regulators
were enabled but never cleaned up → **clock leak + regulator leak**.

**After:** The fix adds proper `goto` error labels:
- `err_regulators`: disables regulators, then falls through to `err_clk`
- `err_clk`: disables/unprepares the clock

This is a textbook error-path resource cleanup fix.

### 3. CLASSIFICATION

This is a **bug fix** — specifically a resource leak fix. It fixes real
resource leaks (clock and regulator) that occur on the resume error
path. These are not theoretical:

- If `regulator_bulk_enable` fails during resume (e.g., power supply
  issue), the clock is leaked.
- If `regcache_sync` fails during resume (e.g., I2C bus issue), both
  clock and regulators are leaked.
- Repeated suspend/resume cycles with failures could accumulate leaked
  resources.

This falls squarely into the "cleanup that adds error handling IS a bug
fix" category.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~10 lines of actual change — very small and
  surgical.
- **Files changed:** 1 file (`sound/soc/codecs/es8328.c`)
- **Risk:** Extremely low. The change only affects error paths. The
  normal (successful) resume path is completely unchanged. The cleanup
  calls (`regulator_bulk_disable`, `clk_disable_unprepare`) are
  standard, well-understood operations.
- **Subsystem:** ASoC codec driver — contained, driver-level change.

### 5. USER IMPACT

The ES8328 is used in real hardware (notably in some ARM SBCs and audio
applications). Users who experience resume failures (e.g., due to
transient I2C errors) would leak resources. Over time, this could cause:
- Clock framework issues (clock stuck in enabled state)
- Regulator framework issues (regulator stuck enabled, preventing power
  savings)
- Potential cascading failures in subsequent suspend/resume cycles

### 6. STABILITY INDICATORS

- The fix is straightforward and follows established kernel error-
  handling patterns.
- Reviewed and merged by Mark Brown (ASoC maintainer) — strong trust
  indicator.
- The pattern (goto-based error unwinding) is the standard Linux kernel
  idiom.

### 7. DEPENDENCY CHECK

This fix is self-contained. It only modifies the `es8328_resume`
function by changing two `return ret` statements to `goto` labels and
adding cleanup code at the end of the function. No dependencies on other
commits. The ES8328 driver exists in all recent stable trees.

### CONCLUSION

This commit fixes real resource leaks in the resume error path of the
ES8328 codec driver. It is:
- **Obviously correct** — standard goto-based error unwinding pattern
- **Fixes a real bug** — resource leaks on resume failure
- **Small and contained** — ~10 lines in one function in one file
- **No new features** — purely error handling improvement
- **Low risk** — only affects error paths, normal path unchanged

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 sound/soc/codecs/es8328.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index 1e11175cfbbbf..47c6b0c218b2c 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -758,17 +758,23 @@ static int es8328_resume(struct snd_soc_component *component)
 					es8328->supplies);
 	if (ret) {
 		dev_err(component->dev, "unable to enable regulators\n");
-		return ret;
+		goto err_clk;
 	}
 
 	regcache_mark_dirty(regmap);
 	ret = regcache_sync(regmap);
 	if (ret) {
 		dev_err(component->dev, "unable to sync regcache\n");
-		return ret;
+		goto err_regulators;
 	}
 
 	return 0;
+
+err_regulators:
+	regulator_bulk_disable(ARRAY_SIZE(es8328->supplies), es8328->supplies);
+err_clk:
+	clk_disable_unprepare(es8328->clk);
+	return ret;
 }
 
 static int es8328_component_probe(struct snd_soc_component *component)
-- 
2.51.0

