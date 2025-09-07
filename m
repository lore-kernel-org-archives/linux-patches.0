Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1F14315A;
	Sun,  7 Sep 2025 20:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277884; cv=none; b=FJuOBYCOV8bmH2rng3WTnwx4s01dy5UT56Ka1O2Fv03p0GRVF/E8CmkhJxOUtQsHcSBqRe6uyspOJZBCQet538ZXtb4jxtz41mpKQKWMsGYodEgJYC2vDv30mZkd9JLMkYpPhlMxFHaCVGXTb21frJeIWkpT4SoWMAXtFv3kffA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277884; c=relaxed/simple;
	bh=nB4C838HlmyqXJ/TAcBACe4OMd8mv7pv3A+AELIxVRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mzdUTkMHDWrpJh5gv4xPYFPL6O8zMes2chE2UGSFzMb9PaMSerBkHVZ1tGinb6V2hliJpO+AwEcVNH8LroYgtubdLb1f09+ke4nHSwA/NFzsi+UlOmHZgXMDThbksgrz2M34qZpH3ofLMvXWIC4TWPfoLG9Egvhght0I0ZdhEZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgX03zij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgX03zij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B72C4CEF0;
	Sun,  7 Sep 2025 20:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277883;
	bh=nB4C838HlmyqXJ/TAcBACe4OMd8mv7pv3A+AELIxVRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgX03zijeUfJ5jMwwkCWRzEGS6eA8L+iNQvlFrJFUZui99nEJPN4QkqPwckV737nv
	 2xAvfc66+TCDWS3c0VWqQ6bWVsHNZJphmlLvZbYJkeTWwslm6GyIC+6m8FBxs0lJKD
	 iE98TKRMMZD/J9KOdV3i5Bt0TeiZ3UtItNgIQjTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lynne Megido <lynne@bune.city>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 152/183] platform/x86: acer-wmi: Stop using ACPI bitmap for platform profile choices
Date: Sun,  7 Sep 2025 21:59:39 +0200
Message-ID: <20250907195619.429326843@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit b0908e03fdd488a5ffd5b80d86dcfc77207464e7 ]

It turns out that the platform firmware on some models does not return
valid data when reading the bitmap of supported platform profiles.
This prevents the driver from loading on said models, even when the
platform profile interface itself works.

Fix this by stop using said bitmap until we have figured out how
the OEM software itself detects available platform profiles.

Tested-by: Lynne Megido <lynne@bune.city>
Reported-by: Lynne Megido <lynne@bune.city>
Closes: https://lore.kernel.org/platform-driver-x86/3f56e68f-85df-4c0a-982c-43f9d635be38@bune.city/
Fixes: 191e21f1a4c3 ("platform/x86: acer-wmi: use an ACPI bitmap to set the platform profile choices")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250826204007.5088-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 71 ++++++---------------------------
 1 file changed, 12 insertions(+), 59 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 69336bd778eea..13eb22b35aa8f 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -129,6 +129,7 @@ enum acer_wmi_predator_v4_oc {
 enum acer_wmi_gaming_misc_setting {
 	ACER_WMID_MISC_SETTING_OC_1			= 0x0005,
 	ACER_WMID_MISC_SETTING_OC_2			= 0x0007,
+	/* Unreliable on some models */
 	ACER_WMID_MISC_SETTING_SUPPORTED_PROFILES	= 0x000A,
 	ACER_WMID_MISC_SETTING_PLATFORM_PROFILE		= 0x000B,
 };
@@ -794,9 +795,6 @@ static bool platform_profile_support;
  */
 static int last_non_turbo_profile = INT_MIN;
 
-/* The most performant supported profile */
-static int acer_predator_v4_max_perf;
-
 enum acer_predator_v4_thermal_profile {
 	ACER_PREDATOR_V4_THERMAL_PROFILE_QUIET		= 0x00,
 	ACER_PREDATOR_V4_THERMAL_PROFILE_BALANCED	= 0x01,
@@ -2014,7 +2012,7 @@ acer_predator_v4_platform_profile_set(struct device *dev,
 	if (err)
 		return err;
 
-	if (tp != acer_predator_v4_max_perf)
+	if (tp != ACER_PREDATOR_V4_THERMAL_PROFILE_TURBO)
 		last_non_turbo_profile = tp;
 
 	return 0;
@@ -2023,55 +2021,14 @@ acer_predator_v4_platform_profile_set(struct device *dev,
 static int
 acer_predator_v4_platform_profile_probe(void *drvdata, unsigned long *choices)
 {
-	unsigned long supported_profiles;
-	int err;
+	set_bit(PLATFORM_PROFILE_PERFORMANCE, choices);
+	set_bit(PLATFORM_PROFILE_BALANCED_PERFORMANCE, choices);
+	set_bit(PLATFORM_PROFILE_BALANCED, choices);
+	set_bit(PLATFORM_PROFILE_QUIET, choices);
+	set_bit(PLATFORM_PROFILE_LOW_POWER, choices);
 
-	err = WMID_gaming_get_misc_setting(ACER_WMID_MISC_SETTING_SUPPORTED_PROFILES,
-					   (u8 *)&supported_profiles);
-	if (err)
-		return err;
-
-	/* Iterate through supported profiles in order of increasing performance */
-	if (test_bit(ACER_PREDATOR_V4_THERMAL_PROFILE_ECO, &supported_profiles)) {
-		set_bit(PLATFORM_PROFILE_LOW_POWER, choices);
-		acer_predator_v4_max_perf = ACER_PREDATOR_V4_THERMAL_PROFILE_ECO;
-		last_non_turbo_profile = ACER_PREDATOR_V4_THERMAL_PROFILE_ECO;
-	}
-
-	if (test_bit(ACER_PREDATOR_V4_THERMAL_PROFILE_QUIET, &supported_profiles)) {
-		set_bit(PLATFORM_PROFILE_QUIET, choices);
-		acer_predator_v4_max_perf = ACER_PREDATOR_V4_THERMAL_PROFILE_QUIET;
-		last_non_turbo_profile = ACER_PREDATOR_V4_THERMAL_PROFILE_QUIET;
-	}
-
-	if (test_bit(ACER_PREDATOR_V4_THERMAL_PROFILE_BALANCED, &supported_profiles)) {
-		set_bit(PLATFORM_PROFILE_BALANCED, choices);
-		acer_predator_v4_max_perf = ACER_PREDATOR_V4_THERMAL_PROFILE_BALANCED;
-		last_non_turbo_profile = ACER_PREDATOR_V4_THERMAL_PROFILE_BALANCED;
-	}
-
-	if (test_bit(ACER_PREDATOR_V4_THERMAL_PROFILE_PERFORMANCE, &supported_profiles)) {
-		set_bit(PLATFORM_PROFILE_BALANCED_PERFORMANCE, choices);
-		acer_predator_v4_max_perf = ACER_PREDATOR_V4_THERMAL_PROFILE_PERFORMANCE;
-
-		/* We only use this profile as a fallback option in case no prior
-		 * profile is supported.
-		 */
-		if (last_non_turbo_profile < 0)
-			last_non_turbo_profile = ACER_PREDATOR_V4_THERMAL_PROFILE_PERFORMANCE;
-	}
-
-	if (test_bit(ACER_PREDATOR_V4_THERMAL_PROFILE_TURBO, &supported_profiles)) {
-		set_bit(PLATFORM_PROFILE_PERFORMANCE, choices);
-		acer_predator_v4_max_perf = ACER_PREDATOR_V4_THERMAL_PROFILE_TURBO;
-
-		/* We need to handle the hypothetical case where only the turbo profile
-		 * is supported. In this case the turbo toggle will essentially be a
-		 * no-op.
-		 */
-		if (last_non_turbo_profile < 0)
-			last_non_turbo_profile = ACER_PREDATOR_V4_THERMAL_PROFILE_TURBO;
-	}
+	/* Set default non-turbo profile */
+	last_non_turbo_profile = ACER_PREDATOR_V4_THERMAL_PROFILE_BALANCED;
 
 	return 0;
 }
@@ -2108,19 +2065,15 @@ static int acer_thermal_profile_change(void)
 		if (cycle_gaming_thermal_profile) {
 			platform_profile_cycle();
 		} else {
-			/* Do nothing if no suitable platform profiles where found */
-			if (last_non_turbo_profile < 0)
-				return 0;
-
 			err = WMID_gaming_get_misc_setting(
 				ACER_WMID_MISC_SETTING_PLATFORM_PROFILE, &current_tp);
 			if (err)
 				return err;
 
-			if (current_tp == acer_predator_v4_max_perf)
+			if (current_tp == ACER_PREDATOR_V4_THERMAL_PROFILE_TURBO)
 				tp = last_non_turbo_profile;
 			else
-				tp = acer_predator_v4_max_perf;
+				tp = ACER_PREDATOR_V4_THERMAL_PROFILE_TURBO;
 
 			err = WMID_gaming_set_misc_setting(
 				ACER_WMID_MISC_SETTING_PLATFORM_PROFILE, tp);
@@ -2128,7 +2081,7 @@ static int acer_thermal_profile_change(void)
 				return err;
 
 			/* Store last profile for toggle */
-			if (current_tp != acer_predator_v4_max_perf)
+			if (current_tp != ACER_PREDATOR_V4_THERMAL_PROFILE_TURBO)
 				last_non_turbo_profile = current_tp;
 
 			platform_profile_notify(platform_profile_device);
-- 
2.51.0



