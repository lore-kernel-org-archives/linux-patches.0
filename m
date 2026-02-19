Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89DF2D3733;
	Thu, 19 Feb 2026 02:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466677; cv=none; b=gcqXF+PQSRqgom2NTuR/6ORdJUBFXkI1A/gW7rDGtamu0KVaySgXzxPJIEP7FBAovrt4Om0hmo39MkaccEmTkxtb+2auoe76OT9FC/j+1x1BivmcCwBA9BKGJu/f37eeYy1/kM3wlgYLAcsfjLlFu7wut6jQV1k65gn8ZYY4PIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466677; c=relaxed/simple;
	bh=swp5sgbe/xrd6C6QW8h31BIMSEtKXgCDJ3Pyo9y4mA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d3QhOCsjSP0y7X07VboeJgP/nNkaImGBuJAKBMUJv+yN/sxvqkhvVvQUEsnPQwL1t46dadRZ2PfRkLC+9ftgVJSlGLUbm5FCIPpUTFPBT9yJmSlFevUcMXjIjnYQ2X/Cm73d0FM0d198kYp58XoUAp9+U+odCFI1EAtd0Ojjrh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRkhAJ0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRkhAJ0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937FAC19424;
	Thu, 19 Feb 2026 02:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466677;
	bh=swp5sgbe/xrd6C6QW8h31BIMSEtKXgCDJ3Pyo9y4mA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRkhAJ0UMsO3EwMBD0WLT7dMs9VNStSIgX2xqPAjp73+IrKLsz1MCIv+xpummAtsF
	 uv0j42RRuPxkInHgBaEoXahTlSOC8ZoQI/lkidzWSL15fkYFsnQ7OKZwFUhrZPf2eQ
	 k8dW6z2dEOIKvZyQi7K5GvA5lc1TtInhemBnOS84ULxPL6G3BQdJuYUYaYuc5TazP3
	 BDtB5ozLW85HQdGrMMb/Yjj1tf8tSmowlMEgCejf0HETQDhOcB1YAuuEQx7Qh9BIGI
	 qj8bkjsOB3YBxWdz/TIIpoEBparTcSbL0xHuNNYCe6MLFjEDB1tCcDQKtLYJCqm5lJ
	 IHFPtL+xwFDyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oleksandr Suvorov <cryosay@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Frank Li <Frank.Li@nxp.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-watchdog@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] watchdog: imx7ulp_wdt: handle the nowayout option
Date: Wed, 18 Feb 2026 21:03:47 -0500
Message-ID: <20260219020422.1539798-11-sashal@kernel.org>
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

From: Oleksandr Suvorov <cryosay@gmail.com>

[ Upstream commit d303d37ef5cf86c8c3b2daefd2a7d7fd8ca1ec14 ]

The module parameter `nowayout` indicates whether the watchdog should ever
be allowed to stop, but the driver currently ignores this option.

Pass the `nowayout` parameter to the watchdog core by setting the
WDOG_NO_WAY_OUT flag accordingly.

Signed-off-by: Oleksandr Suvorov <cryosay@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Classification: Bug Fix

This is a **real bug fix**, not a feature addition. The driver:
1. **Already defines** the `nowayout` module parameter (lines 51-54)
2. **Already advertises** the parameter to users via `MODULE_PARM_DESC`
3. But **never applies** it to the watchdog device

This means a user could set `nowayout=1` expecting the watchdog to be
unstoppable once started, but the driver would silently ignore this
setting. This is a correctness bug with potential **safety/reliability
implications** — the `nowayout` feature exists specifically to prevent
accidental watchdog stops that could leave a system unmonitored.

## Stable Kernel Criteria Assessment

1. **Obviously correct and tested**: Yes. It's a single-line addition of
   `watchdog_set_nowayout(wdog, nowayout)` — the standard pattern used
   by 106 other watchdog drivers. Reviewed by Guenter Roeck (watchdog
   co-maintainer) and Frank Li.

2. **Fixes a real bug**: Yes. The module parameter `nowayout` is defined
   but ineffective. Users who rely on `nowayout=1` for system safety are
   not getting the protection they expect.

3. **Important issue**: Moderate. This is a safety feature for embedded
   systems using watchdog timers. If a user sets `nowayout=1` expecting
   the watchdog can never be stopped, but it can be stopped, a system
   failure could go undetected.

4. **Small and contained**: Yes. Single line addition in one file.

5. **No new features**: Correct. The feature (nowayout parameter)
   already exists and is already declared. This just makes it work as
   intended.

6. **Applies cleanly**: The change is a single line insertion with
   stable context.

## Risk Assessment

- **Risk**: Extremely low. This is a single call to a well-established
  inline function that sets one bit in a status field. The function is
  used in 106 other drivers identically.
- **Benefit**: Users of the imx7ulp watchdog (NXP i.MX7ULP SoC, used in
  embedded/IoT) get correct `nowayout` behavior.
- **Regression potential**: Near zero. The only behavioral change is
  that `nowayout=1` now actually works, which is what users who set it
  expect.

## Verification

- Verified that `nowayout` module parameter is defined at lines 51-54 of
  `drivers/watchdog/imx7ulp_wdt.c` but never applied via
  `watchdog_set_nowayout()` before this patch.
- Verified that `watchdog_set_nowayout()` is a simple inline function in
  `include/linux/watchdog.h` that just sets the `WDOG_NO_WAY_OUT` status
  bit.
- Verified that 106 other watchdog drivers in `drivers/watchdog/` follow
  the exact same pattern of calling `watchdog_set_nowayout()` in their
  probe function.
- Verified the commit is reviewed by Guenter Roeck (watchdog subsystem
  co-maintainer) — `Reviewed-by: Guenter Roeck <linux@roeck-us.net>`.
- Verified the change is a single line addition with no dependencies on
  other commits.
- The imx7ulp_wdt driver has existed since at least Linux 4.17 (based on
  the driver's maturity), meaning this bug affects all stable trees that
  include this driver.

## Conclusion

This is a clear, minimal bug fix for a watchdog driver that declares a
safety-critical module parameter but doesn't apply it. The fix is one
line, follows the established pattern used by 106 other drivers, and was
reviewed by the watchdog subsystem maintainer. The risk is essentially
zero and the benefit is correct behavior for a safety feature on
embedded systems.

**YES**

 drivers/watchdog/imx7ulp_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/imx7ulp_wdt.c b/drivers/watchdog/imx7ulp_wdt.c
index 0f13a30533574..03479110453ce 100644
--- a/drivers/watchdog/imx7ulp_wdt.c
+++ b/drivers/watchdog/imx7ulp_wdt.c
@@ -346,6 +346,7 @@ static int imx7ulp_wdt_probe(struct platform_device *pdev)
 	watchdog_stop_on_reboot(wdog);
 	watchdog_stop_on_unregister(wdog);
 	watchdog_set_drvdata(wdog, imx7ulp_wdt);
+	watchdog_set_nowayout(wdog, nowayout);
 
 	imx7ulp_wdt->hw = of_device_get_match_data(dev);
 	ret = imx7ulp_wdt_init(imx7ulp_wdt, wdog->timeout * imx7ulp_wdt->hw->wdog_clock_rate);
-- 
2.51.0

