Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8445022B584;
	Thu,  9 Oct 2025 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025535; cv=none; b=BAWg9gE7rQW8GOERDMs76hKjDtGwafyJG+zm63oZ7ZHtdVfyEx9XrM2zekBvMwes9xy15Q3btB0sd0dDNiW8JHPHD8UfqfXECVfeWI66Thaci8CERtyTbWoXr+pl9/uNAH7z8DT/LSglEy5yBo66tp8YucT3hM+QfhBOpK8W550=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025535; c=relaxed/simple;
	bh=gLoOvZaZyk3LDFmYP7fOmUaKwcQ5LWOXLvQDRcmJk18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YW/gr7hAxYMrtlBwCrEo08redwJKZ/N9/ZYOIfjj2EvSOzfUucOMBcnoIY05cuKGIYD5GT2we4saBXJGpvpczIhVUFXHiu90mgcyqq88ptx/7H+Lze3FlayvuxCSsQaCKx2m89psvOLhcT/t2U1vClyFI/39TP9CZEaGFgdUSms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dD6zbSa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dD6zbSa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AA8C4CEF8;
	Thu,  9 Oct 2025 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025535;
	bh=gLoOvZaZyk3LDFmYP7fOmUaKwcQ5LWOXLvQDRcmJk18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dD6zbSa31ij0bU6g2nN+Cf26f1xrkjQhfT/CNyK8INO67vl91CZ92L1tRlGqJo0Vv
	 galHqeui6POdlTqY5fNXk63C+qxDWD3rDw0/QMRZ0tsrxFRcsachO81cIp1h1+sBPR
	 SDHM15vF5TfRVJozPnRWlA87AJPswPo9K50JJGzWHsO2Fdj/9Ylt8dLOsqup/xwmu9
	 i4aWZi5Vtpwu/lIbDazXoLgy1GWhNnyIC2/FCy5UJy4+HEQNywg1nNd6ZXuuWktu7D
	 XsDJ7CqFwh3R1VLDffpW1fxej0FQBJYLAtzgTPZpKsh0XuIsmrg33sSSVdDRxUMSAu
	 ne0s929RN6RDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	pali@kernel.org,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] hwmon: (dell-smm) Remove Dell Precision 490 custom config data
Date: Thu,  9 Oct 2025 11:55:01 -0400
Message-ID: <20251009155752.773732-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit ddb61e737f04e3c6c8299c1e00bf17a42a7f05cf ]

It turns out the second fan on the Dell Precision 490 does not
really support I8K_FAN_TURBO. Setting the fan state to 3 enables
automatic fan control, just like on the other two fans.
The reason why this was misinterpreted as turbo mode was that
the second fan normally spins faster in automatic mode than
in the previous fan states. Yet when in state 3, the fan speed
reacts to heat exposure, exposing the automatic mode setting.

Link: https://github.com/lm-sensors/lm-sensors/pull/383
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250917181036.10972-2-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Corrects a long‑standing misinterpretation on Dell Precision 490:
    fan state 3 is automatic mode, not a manual “turbo” speed. Keeping
    `fan_max = I8K_FAN_TURBO` (3) wrongly exposed a manual level that
    the hardware doesn’t actually support, leading to incorrect sysfs
    behavior and user‑space control on that model.

- Scope and change details
  - Removes the model‑specific override for Precision 490:
    - Deletes the model enum entry `DELL_PRECISION_490` from
      `drivers/hwmon/dell-smm-hwmon.c:1390`.
    - Removes its `i8k_config_data` entry which set `.fan_mult = 1` and
      `.fan_max = I8K_FAN_TURBO` at `drivers/hwmon/dell-smm-
      hwmon.c:1395-1407` (only the Precision 490 block is removed).
    - Drops the DMI entry and associated `driver_data` hook in
      `i8k_config_dmi_table` at `drivers/hwmon/dell-smm-
      hwmon.c:1410-1435`.
  - No functional code paths are changed; only a DMI quirk is removed.

- Why the behavior is now correct and safer
  - With the quirk gone, the driver falls back to default limits:
    - `data->i8k_fan_max = fan_max ? : I8K_FAN_HIGH;` so max manual fan
      state defaults to 2, not 3 (drivers/hwmon/dell-smm-hwmon.c:1256).
      This prevents treating the special state 3 as a regular manual
      speed.
    - The driver already autodetects `fan_mult` (sets it to 1 if nominal
      RPM looks like true RPM): see autodetection at
      `drivers/hwmon/dell-smm-hwmon.c:1231`. So removing the
      Precision‑490 `fan_mult=1` override does not regress RPM
      reporting.
  - Correct sysfs reporting and control of automatic mode:
    - The driver interprets state 3 as “auto” (`I8K_FAN_AUTO == 3`;
      include/uapi/linux/i8k.h:36-41). When `i8k_fan_max` is 2, a
      returned state 3 is “> data->i8k_fan_max” and thus treated as
      auto, not a manual PWM value (drivers/hwmon/dell-smm-
      hwmon.c:956-960).
    - The `pwmX_enable` knob is only exposed when `i8k_fan_max <
      I8K_FAN_AUTO` (drivers/hwmon/dell-smm-hwmon.c:878). With the bad
      `fan_max=3` gone, Precision 490 now correctly gets `pwm_enable` to
      reflect/toggle auto mode per hardware behavior (and
      `hwmon_pwm_enable` reading maps auto to 2 at drivers/hwmon/dell-
      smm-hwmon.c:966-969).

- Historical context and correctness
  - The removed quirk dates back to i8k: “Add support for Dell Precision
    490 ...” which set `fan_max = I8K_FAN_TURBO` (commit 7b88344631536,
    in legacy i8k driver). Newer understanding (and documentation)
    clarified that several machines, including Precision 490, use state
    3 as a “magic” auto state rather than a manual turbo.
  - Documentation now reflects this behavior (Documentation/hwmon/dell-
    smm-hwmon.rst:360-366, 375).

- Stable backport criteria
  - Important user-visible bugfix: prevents exposing/allowing a
    non‑existent manual fan level and aligns sysfs with hardware
    behavior.
  - Small and contained: 14 line deletions in a single driver source
    file; no API/ABI changes; affects only Precision 490 via DMI.
  - Low regression risk: default paths are mature; `fan_mult`
    autodetection covers the removed override; no architectural changes.
  - No dependency on broader refactors: The removal stands alone. It
    synergizes with “automatic fan mode” support (mainline improvement),
    but even on older stable trees it simply avoids mislabeling 3 as a
    valid manual state.

- Conclusion
  - This is a classic quirk fix: minimal, model‑specific, and correcting
    wrong behavior. It should be backported to stable trees that still
    contain the Precision 490 DMI override so those kernels no longer
    misrepresent fan capabilities on that system.

 drivers/hwmon/dell-smm-hwmon.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 1e2c8e2840015..3f61b2d7935e4 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1331,7 +1331,6 @@ struct i8k_config_data {
 
 enum i8k_configs {
 	DELL_LATITUDE_D520,
-	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS,
 };
@@ -1341,10 +1340,6 @@ static const struct i8k_config_data i8k_config_data[] __initconst = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_TURBO,
 	},
-	[DELL_PRECISION_490] = {
-		.fan_mult = 1,
-		.fan_max = I8K_FAN_TURBO,
-	},
 	[DELL_STUDIO] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
@@ -1364,15 +1359,6 @@ static const struct dmi_system_id i8k_config_dmi_table[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
 	},
-	{
-		.ident = "Dell Precision 490",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME,
-				  "Precision WorkStation 490"),
-		},
-		.driver_data = (void *)&i8k_config_data[DELL_PRECISION_490],
-	},
 	{
 		.ident = "Dell Studio",
 		.matches = {
-- 
2.51.0

