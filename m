Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDADA43CECE;
	Tue, 10 Mar 2026 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133337; cv=none; b=uxV5lOZ5WFyjG18PuiNdKvsYsTisSBoue1Hluc1DwutPp+eN3k0JqJlAW5JuGAX8zbDPiJZ3ILxC8OONezy6NOCjs5GYbdeljaVR/pHzuA570VWPvixPxqBRT0GFrkzE9C9Vl0IyWpIZt1ZngGMiF4N7VqAbgdh8bI3jLYIvdGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133337; c=relaxed/simple;
	bh=r20ACUyX46W//qwQrsgv7hnF9K8v0qrYhdoGLXz72g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sm1o4nbfIymcLKX+bmH2BfDwmwIHjWUN7qPcujueZAgTMeQ44hlWes/vEvEy7u+6ICVxep6h82tC6kzNwIMulcNlXRYmSNn7Jkfyo6/BJcKf1osIwq19SBgXpeBjk2eEKzxyMKdDDTSX0R2s6Ndvx749p1yzbeo3UyQ+uwHn98s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJxQHLUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJxQHLUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37F8C2BCAF;
	Tue, 10 Mar 2026 09:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133337;
	bh=r20ACUyX46W//qwQrsgv7hnF9K8v0qrYhdoGLXz72g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJxQHLUYSWlxIwheROj1/G+Q9gvQEDn5ljZy8jd5Ltq7qVQg4nM/y7YBFNFYNNduh
	 I31g+/lCiplcy/YxYoYO1A+851BGzvNdGDRqvb8w0L9XMNm9JZPe9ScXJyFbo6NFeY
	 pwb4E+us0kyPlwLv8PwIULEa62doi6zFpnRVWwEBXEogWHOP79sGvfIRMYqdxX/SmJ
	 z1YhO8mmYXQBezGVVoAAy9onFaYbiXBDHLUIxPDHfuecfUNx8BqtqSjZxhIrSXmBLu
	 1u6QbpR63XrHSJUzFWVOfY9Jy0DV1qgmAlUrMgLRHT13nHgO901H1Y0a+ZVWjItJTm
	 K6AnwhyvVPRiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Victor Lattaro Volpini <victorlattaro@proton.me>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] platform/x86: hp-wmi: Add Victus 16-d0xxx support
Date: Tue, 10 Mar 2026 05:01:21 -0400
Message-ID: <20260310090145.2709021-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Victor Lattaro Volpini <victorlattaro@proton.me>

[ Upstream commit 249f05e625c6e6c14b27fd34a2f06a1afb9b456d ]

This patch enables Victus thermal profile support for the HP
Victus 16-d0xxx. It does so by adding model's DMI board name 88F8 to
victus_thermal_profile_boards.

Tested on a Victus 16-d0xxx:
  - Victus thermal profile choices available (quiet, balanced, performance)
    instead of the default ones (cool, quiet, balanced, performance);
  - Profile switching works correctly;
  - About 4% increase in FPS using benchmark Cyberpunk 2077 on
  performance profile;
  - No noticeable regressions.

Signed-off-by: Victor Lattaro Volpini <victorlattaro@proton.me>
Link: https://patch.msgid.link/20260210000048.250280-1-victorlattaro@proton.me
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

This commit adds a single DMI board name ("88F8") to the
`victus_thermal_profile_boards` array in the HP WMI platform driver,
enabling thermal profile support (quiet, balanced, performance) for the
HP Victus 16-d0xxx laptop. The comment is also updated from "16-d1xxx"
to "16-d" to reflect the broader coverage.

### Classification: Hardware ID Addition

This falls squarely into the **"New Device IDs"** exception category for
stable backports. It's adding a board identifier to an existing, well-
established list so that an already-implemented feature works on a
specific hardware model.

### Code Change Assessment

The actual code change is minimal:
- **+1 line**: Adding `"88F8"` to the `victus_thermal_profile_boards`
  string array
- **1 line modified**: Comment updated from "Victus 16-d1xxx" to "Victus
  16-d"

This is about as low-risk as a change can be. The array is used to match
against DMI board names, and if no match occurs, the code simply takes a
different path. Adding an entry can only affect the specific hardware it
matches.

### Testing and Review

- Tested on the actual HP Victus 16-d0xxx hardware by the author
- Thermal profile switching verified to work correctly
- No regressions observed
- Reviewed by subsystem maintainer Ilpo Järvinen

### Risk vs. Benefit

- **Risk**: Essentially zero. The change only activates for the specific
  board with DMI name "88F8". No other hardware is affected.
- **Benefit**: Users of the HP Victus 16-d0xxx get proper thermal
  profile support instead of incorrect default profiles, enabling
  correct fan/performance management.

### Stable Criteria Check

1. Obviously correct and tested: **Yes** - trivial addition, tested on
   hardware
2. Fixes a real bug: **Yes** - wrong thermal profiles presented to users
   of this hardware
3. Important issue: **Moderate** - hardware not working correctly for
   its users
4. Small and contained: **Yes** - one-line addition to a string array
5. No new features: **Correct** - enables existing feature on new
   hardware
6. Applies cleanly: **Very likely** - the array has existed for multiple
   releases

### Verification

- Confirmed from the diff that the change is a single string addition to
  an existing `const char *` array
- The `victus_thermal_profile_boards` array is an existing mechanism in
  the driver for matching Victus laptops by DMI board name
- The commit has `Reviewed-by: Ilpo Järvinen` (subsystem maintainer)
  confirming review
- The commit message documents actual hardware testing with specific
  results
- The change follows the exact same pattern as the existing "8A25" entry
  already in the array

This is a textbook device ID / hardware quirk addition - the most common
and least controversial type of stable backport.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index ec87fd96686cf..e3a7ac2485d68 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -154,8 +154,9 @@ static const char * const omen_timed_thermal_profile_boards[] = {
 	"8BAD",
 };
 
-/* DMI Board names of Victus 16-d1xxx laptops */
+/* DMI Board names of Victus 16-d laptops */
 static const char * const victus_thermal_profile_boards[] = {
+	"88F8",
 	"8A25",
 };
 
-- 
2.51.0

