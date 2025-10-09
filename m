Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C38F2FD1C5;
	Thu,  9 Oct 2025 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025680; cv=none; b=XayHAlcvKiVBiv9SdHMOj3F0HaaxkIpFBfDMtFeIL7WcsoSO5frn/5T6QddQIlZP4WtpELfo7gPeDFdtAHkQC4xkWaq+IOzrIKmSQiFY7jtQ2wkYvA0oRQjjIlQz8svbMan6zAgvhYPE72QfDrGlYkzs2POVjJsF+B2apEzBsE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025680; c=relaxed/simple;
	bh=0FZRvzA47eF9x3pLRMH/yb9l3Nh10OZ72DVTIIZKB0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCJgNm2pwhv2w8jQhHqpWrXwaLqSG4MrXYeTPX0EY68hzNiDGUeU+thMP+8XUmPdbLHU297izQy0qLLLQduEU2Ut011CS6PtMglQR6b2099ZVqR7syba6Gy5wNBM+CRJC5OdBzIWXwwYxMmLH/VWcfi57RelsQ8IsSDb+mTs/8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=As84tUbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="As84tUbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF519C4CEFE;
	Thu,  9 Oct 2025 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025680;
	bh=0FZRvzA47eF9x3pLRMH/yb9l3Nh10OZ72DVTIIZKB0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=As84tUbvbYDxrV3kYdHt8v4T3oGWczv2W/NhRInlGKXIvev0FQ2L7pUe8sOhB+PJs
	 7qKD2iE2Dg5iaEJO8e172JgjD2rAfOIEvngK/tR91pWRxjErxRO81h4ObEA3CMAPqD
	 OBhbsOFVTaPEak9YACaw07YqB7w+1imliP+4Y6nmaz64iNukj6v91+LO/Ez7RN1sf2
	 MaZ1YjoTwP4L+4nxxme2VQ3rcTYZ3bPmjTad3y2Etc/altc/wK3sNiK6KhgtAJ6Qeb
	 8FPzcIeB9AeslwRf8N2gV+lCMMaFoNN4nmxcOcinTjMDUPSQTUNPWiGh3awr9AjCMC
	 Nq0D2dXCvT7PQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	pali@kernel.org,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] hwmon: (dell-smm) Add support for Dell OptiPlex 7040
Date: Thu,  9 Oct 2025 11:56:18 -0400
Message-ID: <20251009155752.773732-112-sashal@kernel.org>
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

[ Upstream commit 53d3bd48ef6ff1567a75ca77728968f5ab493cb4 ]

The Dell OptiPlex 7040 supports the legacy SMM interface for reading
sensors and performing fan control. Whitelist this machine so that
this driver loads automatically.

Closes: https://github.com/Wer-Wolf/i8kutils/issues/15
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250917181036.10972-5-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Change scope and intent: The patch only adds a single DMI whitelist
  entry for “Dell OptiPlex 7040” to the legacy SMM allowlist used by the
  dell-smm hwmon driver. It adds a new block in `i8k_dmi_table` with
  explicit vendor and exact product matches, no other logic changes. See
  drivers/hwmon/dell-smm-hwmon.c:1334–1339.

- How it affects behavior: The i8k_dmi_table is consulted to decide if
  legacy SMM probing is permitted. If the system is not in this table,
  the driver refuses legacy SMM unless overridden by module params; with
  newer code it falls back to WMI. The gating is in
  `dell_smm_legacy_check()`, which returns -ENODEV when the DMI table
  doesn’t match and neither `ignore_dmi` nor `force` is set
  (drivers/hwmon/dell-smm-hwmon.c:1756–1761). Adding 7040 lets the
  driver load and use the legacy SMM path on that system automatically.

- Autoloading safety and containment: The driver exposes a DMI modalias
  and will auto-load only on machines matching this entry. The new match
  is guarded by both `DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc.")` and
  `DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7040")`, ensuring no
  unintended matches (drivers/hwmon/dell-smm-hwmon.c:1334–1338, 1378).

- Precedent and consistency: Neighboring entries for similar models,
  OptiPlex 7050 and 7060, already exist and were accepted
  (drivers/hwmon/dell-smm-hwmon.c:1320–1332). Extending coverage to the
  7040 is consistent with established support for this platform family
  and the commit message notes the 7040 supports legacy SMM for sensors
  and fan control.

- Risk assessment:
  - No architectural changes, no new interfaces; it’s a pure DMI
    whitelist addition in a single file.
  - SMM-specific risks are mitigated by existing vendor/model blacklists
    for known-problematic systems (e.g., fan support freeze blacklist;
    drivers/hwmon/dell-smm-hwmon.c:1482–1512). 7040 is not on any
    blacklist.
  - Security posture remains unchanged: fan control and serial number
    are already restricted by default to CAP_SYS_ADMIN (`restricted`
    default true; drivers/hwmon/dell-smm-hwmon.c:127–133).

- User impact: Fixes a real-world usability gap where the driver would
  not autoload on OptiPlex 7040 (previously requiring module parameters
  or leaving sensors/fan control unavailable). The commit references a
  user report (Closes: GitHub issue) and was accepted by the hwmon
  maintainer.

- Backport suitability:
  - Change is small, localized, and low risk.
  - It aligns with stable rules for adding device IDs to enable existing
    functionality.
  - Applies cleanly conceptually to older stable trees which also use
    `i8k_dmi_table` and `MODULE_DEVICE_TABLE(dmi, i8k_dmi_table)` (e.g.,
    v6.1, v6.6), even though line positions differ.

Given the minimal, well-scoped nature of the change and clear user
benefit without broader side effects, this is a good candidate for
stable backport.

 drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 3f61b2d7935e4..5801128e16c3c 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1280,6 +1280,13 @@ static const struct dmi_system_id i8k_dmi_table[] __initconst = {
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7050"),
 		},
 	},
+	{
+		.ident = "Dell OptiPlex 7040",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7040"),
+		},
+	},
 	{
 		.ident = "Dell Precision",
 		.matches = {
-- 
2.51.0

