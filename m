Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3862EB5D4;
	Mon, 24 Nov 2025 08:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971631; cv=none; b=hOLENj9zEocI/VSrhDM0Ut9cjuo07w1PFLXA+/ZpwxixZhFowjiZ72yBbw8DYibBQGIo07BSugu9zubwiuNJDGLneLXevlHFp/ZHQ9NgkoGmSmC7/oA2eAw8s8AsyCbJAzSj64V5SKGapr97luXx3jyVM2H/eXShha9nDSE50Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971631; c=relaxed/simple;
	bh=V8mMtwyYvDseC7xByP0VJfqNU0O5GRT5uJapBwyAmyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZiQf8FSOGNS85eD9FSkfNB/6OQDIL/5kzWD/ge3kAy1xEzmZoSvoDGLXsmpt8nasI3fpuds9WFQUAMhw16qNwDSQ8ZxGbppi4sDRh1jrq+3A6o4vwkIyg+Jn15g6gKqbsls23IG8hts5Er5eYG2HJWCOhfg6DnTl1ykjIjplKQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGIBG3SO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGIBG3SO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F18C4CEF1;
	Mon, 24 Nov 2025 08:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971630;
	bh=V8mMtwyYvDseC7xByP0VJfqNU0O5GRT5uJapBwyAmyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGIBG3SOKAifV+GfCyg9+nFc91NXsN4qvRCHtRizWLxaJXlaPm7sFe2cH25cbDW92
	 shWfSCWe7OE99F3pqjLAQRLllehfANFMlSEcfzwFkD0xwNfElLHEYe5WeWB6uYM6QE
	 /3t7GbQuDiAjIviJIuaJHIiqF4mGR0USY1WoOZzlnU7h9RuDommKOZLvKzs32oBSdo
	 9WY0wEb0lveL9wOuqFSPrro0/20ysiGLPtYTywdtkZnyjMqjT5FQIIbeRzc+pdM9IV
	 srHhH2O/KrbctyvQDeL6RLqJ1RzRTxHVpmIsOINpIe8lWOVbbIK6ZkHu8EbmQ/hUCd
	 pDYdInPyXXqEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Edip Hazuri <edip@medip.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mpearson-lenovo@squebb.ca,
	mario.limonciello@amd.com,
	kuurtb@gmail.com,
	luzmaximilian@gmail.com,
	jeffbai@aosc.io,
	julien.robin28@free.fr,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] platform/x86: hp-wmi: mark Victus 16-r0 and 16-s0 for victus_s fan and thermal profile support
Date: Mon, 24 Nov 2025 03:06:28 -0500
Message-ID: <20251124080644.3871678-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Edip Hazuri <edip@medip.dev>

[ Upstream commit 54afb047cd7eb40149f3fc42d69fd4ddde2be9f0 ]

This patch adds Victus 16-r0 (8bbe) and Victus 16-s0(8bd4, 8bd5) laptop
DMI board name into existing list

Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20251015181042.23961-3-edip@medip.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 1. COMMIT MESSAGE ANALYSIS
The commit subject "platform/x86: hp-wmi: mark Victus 16-r0 and 16-s0
for victus_s fan and thermal profile support" clearly indicates a
hardware enablement patch.
- **Problem:** Specific HP Victus laptop models (16-r0 and 16-s0) are
  not recognized by the `hp-wmi` driver's thermal management logic.
- **Solution:** Add their DMI board names to the driver's allowlist.
- **Tags:** No "Fixes:" or "Cc: stable" tags are present, which is
  common for device ID additions, though "Cc: stable" is preferred.
- **Type:** Hardware enablement via ID addition.

### 2. DEEP CODE RESEARCH
**Code Change:**
The patch modifies `drivers/platform/x86/hp/hp-wmi.c` by adding three
strings (`"8BBE"`, `"8BD4"`, `"8BD5"`) to the
`victus_s_thermal_profile_boards[]` array.

**Mechanism:**
1. **Entry Point:** The driver initializes platform profiles
   (performance, balanced, quiet modes).
2. **Detection:** The function `is_victus_s_thermal_profile()` (not
   shown in diff but known from context) checks `dmi_check_system()` or
   compares the board name against the
   `victus_s_thermal_profile_boards[]` array.
3. **Behavior:**
    - **Before:** These laptops return `false`, causing the driver to
      fall back to generic or legacy thermal handling, or disable
      thermal profile support entirely. This results in users being
      unable to control fan speeds or thermal envelopes (e.g.,
      "Performance" mode won't work).
    - **After:** The board names match, returning `true`. This engages
      the `victus_s` code path, enabling the correct WMI calls for these
      specific motherboard revisions.

**Dependencies:**
The patch relies on the `victus_s` infrastructure (functions like
`platform_profile_victus_s_ops`) being present in the kernel. This
infrastructure was introduced recently. Therefore, this backport is
valid **only** for stable trees that contain the base `victus_s` support
(likely 6.13+ or earlier kernels where the feature itself was
backported). For kernels lacking the base feature, this patch is
irrelevant. Assuming the target stable tree has the driver
infrastructure, this ID addition is correct.

### 3. STABLE KERNEL RULES ASSESSMENT
This commit falls squarely under **Exception #1: NEW DEVICE IDs**.
- **Rule:** "Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing
  drivers... These are trivial one-line additions that enable hardware
  support."
- **Analysis:**
    - **Existing Driver:** The `hp-wmi` driver and the `victus_s`
      capability already exist in the tree.
    - **Trivial:** The change is purely data (adding strings to an
      array).
    - **No Logic Change:** No executable code logic is altered; only the
      data set for detection is expanded.
    - **Hardware Support:** It enables existing, tested driver code to
      function on new hardware variants.

### 4. RISK VS BENEFIT
- **Benefit:** High for affected users. Without this patch, owners of
  these laptops on stable kernels (e.g., enterprise desktops, LTS
  distros) have broken thermal management.
- **Risk:** Negligible. The change is isolated to a string array. It
  cannot cause regressions for other devices because the strings are
  unique identifiers.
- **Regression Potential:** Zero. Existing supported devices (`8C99`,
  `8C9C`) are untouched.

### 5. CONCLUSION
This is a textbook example of a safe stable backport. While it
technically adds support for "new" hardware, the Linux stable process
explicitly allows adding Device IDs to existing drivers to ensure that
users on long-term kernels can use new hardware revisions. The change is
minimal, obviously correct, and fixes a functional deficiency for
specific hardware models without impacting others.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 8b3533d6ba091..9a668e2587952 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -92,8 +92,9 @@ static const char * const victus_thermal_profile_boards[] = {
 	"8A25"
 };
 
-/* DMI Board names of Victus 16-r1000 and Victus 16-s1000 laptops */
+/* DMI Board names of Victus 16-r and Victus 16-s laptops */
 static const char * const victus_s_thermal_profile_boards[] = {
+	"8BBE", "8BD4", "8BD5",
 	"8C99", "8C9C"
 };
 
-- 
2.51.0

