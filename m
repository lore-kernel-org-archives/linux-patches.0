Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17311ADC97;
	Sat, 14 Feb 2026 01:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031031; cv=none; b=FUAsUEBHy4PIQObx7Eq28kYheU8WVEV2bOWPuYj2zzC20w8aEnutK+iErPllh1Ok4lgVTX8tdl7oXQ/3NlDJwQ95OwUaiVh4oiqQh9L4Xp8L0pK6lOBWlTQwTigloXxnc/0/zYHoZg8UpTj+MLpUGjpP/WokrNVjjiVz+RUaQYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031031; c=relaxed/simple;
	bh=7Ax7O5xU/XKNjc++DiZfBXmM1hs2inRsy74vM8vYJOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKT6OqIzwgofSW5rhz30s8WVZUvlvWPqeKwbv+bYxYGHYqP+k1Q6ymQiY6yDNZbDF/jd0seEqABwgSB4cECLAcljYwH9/zHd1WEipHXozNXadKmKWS0hGRCj6vXV/fOLttoCH9af+OxjSE4wlegxZ50xK1tW7pOD/utespWqeS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XmiIPLHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XmiIPLHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA0AC16AAE;
	Sat, 14 Feb 2026 01:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031030;
	bh=7Ax7O5xU/XKNjc++DiZfBXmM1hs2inRsy74vM8vYJOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmiIPLHXX0t+GeTLbPxB03pBvTql0x5HcwnK6zoG/ZUswqI8l4OQID3Su4VwKWTzC
	 eaRF8P9n31jRQ0JPyzN68xm46oXSqg9ZomOaUJbmrOsISZo4dcgSE3vYa5Vp4gg6Pl
	 sZMlfTtM7WG7cBtmL2qkqDHuX8/5af7hcSmgHKfsn9i3anclQgxhDc+LEzS0xiIZSm
	 J4FovgDX6ejsg7GF7yAQex+u10I7ZG/Mhb7LgzfgpmJg6M1TN6P2+T2RhAGkig3Gwj
	 aT7xV/ksXOExPXMc0g5bHhxNX3Oj66+tnC/Kx4O8kMyFm/nFt0o32xrezg6dKUFoec
	 dAH7zkqJ2jzag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robert McIntyre <rjmcinty@hotmail.com>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] hwmon: (asus-ec-sensors) add Pro WS TRX50-SAGE WIFI A
Date: Fri, 13 Feb 2026 19:58:31 -0500
Message-ID: <20260214010245.3671907-31-sashal@kernel.org>
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

From: Robert McIntyre <rjmcinty@hotmail.com>

[ Upstream commit af7e57d444141ac9e77b57296d59c3e965c4c4fa ]

Adding support for Pro WS TRX50-SAGE WIFI A, which is identical
sensors-wise to Pro WS TRX50-SAGE WIFI

Signed-off-by: Robert McIntyre <rjmcinty@hotmail.com>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20251213200531.259435-4-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis
This commit adds support for a new motherboard variant — the "Pro WS
TRX50-SAGE WIFI A" — to the asus-ec-sensors hwmon driver. The commit
message explicitly states that this board is "identical sensors-wise" to
the already-supported "Pro WS TRX50-SAGE WIFI".

### Code Change Analysis
The change is minimal and purely additive:

1. **Documentation**: Adds one line to `asus_ec_sensors.rst` listing the
   new board name in the supported boards list.

2. **Driver**: Adds two lines to the DMI matching table in `asus-ec-
   sensors.c`:
  ```c
  DMI_EXACT_MATCH_ASUS_BOARD_NAME("Pro WS TRX50-SAGE WIFI A",
  &board_info_pro_ws_trx50_sage_wifi),
  ```
  This reuses the **exact same** `board_info_pro_ws_trx50_sage_wifi`
  structure as the existing "Pro WS TRX50-SAGE WIFI" entry. No new
  board_info structure, no new sensor definitions, no new code paths —
  just a new DMI string mapping to an existing configuration.

### Classification: New Device ID / Board ID
This falls squarely into the **"New Device IDs"** exception category for
stable backports. It is analogous to adding a new PCI ID or USB ID to an
existing driver. The driver already exists and supports this hardware
configuration; only the board name string is different.

### Risk Assessment
- **Risk: Extremely low**. The change adds a DMI match entry that points
  to an already-tested board configuration. If the DMI doesn't match
  (user has a different board), this code is never reached. If it does
  match, it uses the same well-tested sensor configuration.
- **Scope**: 3 lines of actual code change (1 doc line + 2 driver
  lines).
- **Dependencies**: None. The `board_info_pro_ws_trx50_sage_wifi`
  structure and the `DMI_EXACT_MATCH_ASUS_BOARD_NAME` macro already
  exist in stable trees.
- **Regression potential**: Essentially zero — this cannot affect any
  existing board's behavior.

### User Impact
Without this patch, users with the "Pro WS TRX50-SAGE WIFI A"
motherboard variant have no hardware monitoring sensor support through
this driver, even though the hardware is identical to the already-
supported model. This is a real-world hardware enablement issue.

### Stable Criteria Check
- **Obviously correct**: Yes — trivial DMI table addition reusing
  existing config.
- **Fixes a real issue**: Yes — enables hardware monitoring on a board
  variant that should work but doesn't.
- **Small and contained**: Yes — 3 lines.
- **No new features**: Correct — this uses existing driver
  functionality; it just adds a new board name to match against.
- **No new APIs**: Correct.

**YES**

 Documentation/hwmon/asus_ec_sensors.rst | 1 +
 drivers/hwmon/asus-ec-sensors.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Documentation/hwmon/asus_ec_sensors.rst b/Documentation/hwmon/asus_ec_sensors.rst
index 232885f24430d..b5e1bc7ac0643 100644
--- a/Documentation/hwmon/asus_ec_sensors.rst
+++ b/Documentation/hwmon/asus_ec_sensors.rst
@@ -10,6 +10,7 @@ Supported boards:
  * PRIME X670E-PRO WIFI
  * PRIME Z270-A
  * Pro WS TRX50-SAGE WIFI
+ * Pro WS TRX50-SAGE WIFI A
  * Pro WS X570-ACE
  * Pro WS WRX90E-SAGE SE
  * ProArt X570-CREATOR WIFI
diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 61b18b88ee8ff..a1445799e23d8 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -793,6 +793,8 @@ static const struct dmi_system_id dmi_table[] = {
 					&board_info_pro_art_x870E_creator_wifi),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("Pro WS TRX50-SAGE WIFI",
 					&board_info_pro_ws_trx50_sage_wifi),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("Pro WS TRX50-SAGE WIFI A",
+					&board_info_pro_ws_trx50_sage_wifi),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("Pro WS WRX90E-SAGE SE",
 					&board_info_pro_ws_wrx90e_sage_se),
 	DMI_EXACT_MATCH_ASUS_BOARD_NAME("Pro WS X570-ACE",
-- 
2.51.0

