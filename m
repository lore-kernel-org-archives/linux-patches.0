Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5661990C7;
	Fri, 12 Dec 2025 02:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505355; cv=none; b=lpsSh0JAg7Pc+ueiy9jZeUcT8+ppu3H4u1Gt2o06qtsioiEJyBdLDZbmS6IbjBcYyJND5LFF/0udVeFD4Y4g9Wh0blBYaxNvMZZ+Q7f1OY+zU0jMR44Qlt+iDVIsJS8QE6YwUfy7qasbgHcCiyVRb1jqoQlBV2/mL7m/21YTjf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505355; c=relaxed/simple;
	bh=Q0zPclX8sDJjPyfg/Ub1RrRNa1FZeWqxEeqLAcXePMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DC+P+9xi+PUPo/6B+Q5JFqwfslt3erFBEc1oJ61h6ogBE4qjXHebY6Z/84Pi8oc7si/7Y03kiqnuRKSErczfA4h7WAjwmaL1Q0HP/AtmhRxyUj4cWB3Z/TJ7CCMlY7b+DdN+q2dBNE8BmJjmNaY3Kdjv9I+vn9Jh+a0iabAFiaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBtahSZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBtahSZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4044FC19421;
	Fri, 12 Dec 2025 02:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765505354;
	bh=Q0zPclX8sDJjPyfg/Ub1RrRNa1FZeWqxEeqLAcXePMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBtahSZXikRp4sHZ8WUpliESIkwhaHmjMgkOXsDYieCqQN5aSiYFKPW2deH3kY9QW
	 gZ2izzUIUpHyXvwf+mKGGwOQYzOcCya3i0bTvrLFwFKUUdO0RvtONnsdu7CPppQkxS
	 jIGpu8mYuM2VB0lPFedmazPBAhSk3ZkbrPHwtbOCh0veDLM7VPvbQX56JcoE2DGD5h
	 ovNi+qUt0Ii+LpTtepkF+/5IwZKRH0Zzw12MgNU4d9k3aU8btpqaIZ4s6ZZGegdVTh
	 Y+csX4vaa2sGw6baTTYPHxaqSFssG/S0ln1xh0J4eVryUdeCX7G+HA9aIJ2BOqxBaJ
	 v2NXlNQE1wjyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Derek J. Clark" <derekjohn.clark@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] platform/x86: wmi-gamezone: Add Legion Go 2 Quirks
Date: Thu, 11 Dec 2025 21:08:56 -0500
Message-ID: <20251212020903.4153935-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212020903.4153935-1-sashal@kernel.org>
References: <20251212020903.4153935-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: "Derek J. Clark" <derekjohn.clark@gmail.com>

[ Upstream commit 55715d7ad5e772d621c3201da3895f250591bce8 ]

Add Legion Go 2 SKU's to the Extreme Mode quirks table.

Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20251127151605.1018026-4-derekjohn.clark@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: platform/x86: wmi-gamezone: Add Legion Go 2
Quirks

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** Adds Legion Go 2 SKUs to the Extreme Mode quirks table

**Tags present:**
- Multiple Reviewed-by tags (3 reviewers: Armin Wolf, Mark Pearson, Ilpo
  Järvinen)
- Signed-off-by tags

**Tags absent:**
- No `Cc: stable@vger.kernel.org`
- No `Fixes:` tag

### 2. CODE CHANGE ANALYSIS

The change is minimal and mechanical:
- Adds two new DMI entries to the existing `fwbug_list[]` table
- New entries: "Legion Go 8ASP2" and "Legion Go 8AHP2" (Legion Go 2
  variants)
- Both use the same `&quirk_no_extreme_bug` quirk as existing Legion Go
  devices
- Also removes a stray blank line (cleanup)

The structure is identical to existing entries - DMI vendor/product
matching to apply a known quirk.

### 3. CLASSIFICATION: QUIRK/DEVICE-ID ADDITION

This falls into **two explicit exception categories** for stable:

1. **Device ID Addition:** Adding DMI identifiers to an existing driver
   to enable hardware support
2. **Hardware Quirk:** The `quirk_no_extreme_bug` works around firmware
   bugs where devices falsely report extreme thermal mode support

Without this quirk, the driver would attempt to enable "extreme mode" on
Legion Go 2 devices that have incomplete BIOS implementations,
potentially causing thermal management issues.

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Value |
|--------|-------|
| Lines added | ~14 (two DMI table entries) |
| Files changed | 1 |
| Complexity | Very low |
| Risk | Minimal |

**Risk analysis:**
- Change only affects Legion Go 2 hardware (DMI matching ensures
  isolation)
- Uses exact same quirk mechanism proven with existing Legion Go devices
- No new code paths introduced
- Pattern identical to existing well-tested entries

### 5. USER IMPACT

**Affected users:** Legion Go 2 (8ASP2/8AHP2) owners

**Without this fix:** These devices might have their thermal
profiles/extreme mode misconfigured due to firmware bugs, potentially
causing:
- Unexpected platform profile behavior
- Incorrect thermal mode settings

**Severity:** Moderate - hardware usability issue

### 6. STABILITY INDICATORS

- **3 Reviewed-by tags** from different reviewers (strong review
  coverage)
- Pattern is well-established in the driver
- Mechanical, predictable change

### 7. DEPENDENCY CHECK

The wmi-gamezone driver needs to exist in the target stable tree. This
is a relatively new driver (for Legion Go devices released ~2023), so it
may only exist in recent stable branches (6.6+). If the driver doesn't
exist in older stables, the patch simply won't apply.

### DECISION RATIONALE

**Arguments FOR backporting:**
1. Classic quirk addition - explicitly allowed exception in stable rules
2. Equivalent to device ID addition for new hardware SKUs
3. Very small, surgical change with minimal risk
4. Uses existing infrastructure and proven quirk
5. Well-reviewed (3 reviewers)
6. Fixes real hardware behavior issues (firmware bugs)
7. DMI matching isolates impact to specific hardware only

**Arguments AGAINST:**
1. No explicit `Cc: stable` tag from maintainer
2. Adds support for new hardware (could be viewed as feature)
3. Driver may not exist in older stable trees

**Conclusion:**

This commit is a textbook example of a hardware quirk addition that's
appropriate for stable backporting. The stable kernel documentation
explicitly allows:
- Adding device IDs to existing drivers
- Adding hardware quirks/workarounds for buggy devices

The change is small (~14 lines), low risk (DMI-isolated to specific
hardware), uses existing proven mechanisms, and fixes real hardware
issues. The lack of an explicit stable tag isn't disqualifying - many
valid stable patches don't include it. Stable maintainers can determine
applicability based on whether the driver exists in their trees.

**YES**

 drivers/platform/x86/lenovo/wmi-gamezone.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lenovo/wmi-gamezone.c b/drivers/platform/x86/lenovo/wmi-gamezone.c
index 0eb7fe8222f4a..b26806b37d960 100644
--- a/drivers/platform/x86/lenovo/wmi-gamezone.c
+++ b/drivers/platform/x86/lenovo/wmi-gamezone.c
@@ -274,8 +274,23 @@ static const struct dmi_system_id fwbug_list[] = {
 		},
 		.driver_data = &quirk_no_extreme_bug,
 	},
+	{
+		.ident = "Legion Go 8ASP2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Legion Go 8ASP2"),
+		},
+		.driver_data = &quirk_no_extreme_bug,
+	},
+	{
+		.ident = "Legion Go 8AHP2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Legion Go 8AHP2"),
+		},
+		.driver_data = &quirk_no_extreme_bug,
+	},
 	{},
-
 };
 
 /**
-- 
2.51.0

