Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966233C2D;
	Sat, 14 Feb 2026 21:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104392; cv=none; b=Se0kGpU/8A2uEcUvHkmJwZx7AQhwNG5Jdo9FFcj9n2jeFV59BR3n0w+0jeqwDULVu0IyTRsX3HKecu+r7FZc0zCJBq30AZ6tSnpcjB2ex8MLW6qSPYDHDPNTLKWpQ7Xtamn+j3ghsS9d8VowQFDGnZBSe4RpVefRdClkAm/O9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104392; c=relaxed/simple;
	bh=t7/McNgBzIgMYa/0Ws8Wx37DuvsjekDq93jR0pg7hOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pT9sou3vifhACjdvr0Dz14Ag+bV6inIfojJPTBnAYHpPjyqpkrWMaDhSwCgzaqeiRRn4GGMIm27wUFFt+EfsEsMOtt9o6fN6VfNaMK7O+CwOzwLsmUd0jX+AnId4PVNZxw3k+L3pBCIfXy6g09FMDVRfFlw0ugUAdY2IP+pl3EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ybx8R12J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ybx8R12J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE92C16AAE;
	Sat, 14 Feb 2026 21:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104392;
	bh=t7/McNgBzIgMYa/0Ws8Wx37DuvsjekDq93jR0pg7hOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ybx8R12JyYp6/Cb9D4iIdMB6ukIlmdN6BMWfxFg1vWwikIedjKnHxwezEHyLiUKqH
	 99gxSLanhx4IE5LG1s/Z2RKe7/cDdtoKsPBtnGu8MHCKHdv0JWuLgaMNYJlxzWa+g2
	 /CHvIqr194Hzq4Nxhu1UOaGEvWRX7NeUVLk6Mc+Ck1sg5Ip0V+yEds1lFu56avZTld
	 hvOgB53U1D03+lUrSMtOxeCgmayUh99608G+4V90iXFgCetS8xkiQ+Ak871SSd1D1C
	 f31rBYGOtYdX4GaEcqULDdj5GUQ6wSUfS0CPHP+iAXGZQ7sDIhKHskfD3BWQUMlX6F
	 36HpWm4rz7KEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	somashekhar.puttagangaiah@intel.com,
	ilan.peer@intel.com,
	yelangyan@huaqin.corp-partner.google.com,
	nidhish.a.n@intel.com
Subject: [PATCH AUTOSEL 6.19-6.18] wifi: iwlwifi: mld: fix chandef start calculation
Date: Sat, 14 Feb 2026 16:23:22 -0500
Message-ID: <20260214212452.782265-57-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit d2fcdf36554316cc51f7928b777944738d06e332 ]

A link pair in which both links are in 5 GHz can be used for EMLSR only
if they are separated enough.

To check this condition we calculate the start and the end of the
chandefs of both links in the pair and do some checks.

But the calculation of the start/end of the chandef is currently done
by subtracting/adding half the bandwidth from/to the control channel's
center frequency, when it should really be subtracted/added from/to the
center frequency of the entire chandef.

Fix the wrong calculation.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260111193638.2138fdb99bd5.I4d2e5957b22482a57b1d6ca444e90fcf73bf2cab@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of wifi: iwlwifi: mld: fix chandef start calculation

### 1. Commit Message Analysis

The commit message clearly describes a **bug fix** — the word "fix" is
in the subject and the body explains the incorrect calculation. The
issue is about EMLSR (Enhanced Multi-Link Single Radio) link pair
validation for 5 GHz band operation. The calculation was using the
**control channel's center frequency** (`chan->center_freq`) instead of
the **chandef's center frequency** (`center_freq1`) when computing
channel edges. This is a straightforward logic error.

The commit has a `Reviewed-by: Johannes Berg` tag — Johannes Berg is the
mac80211/cfg80211 maintainer, which is a strong trust indicator.

### 2. Code Change Analysis

The diff is minimal — only **two lines changed**:

```c
- c_low_upper_edge = c_low->chan->center_freq +
+ c_low_upper_edge = c_low->center_freq1 +

- c_high_lower_edge = c_high->chan->center_freq -
+ c_high_lower_edge = c_high->center_freq1 -
```

**What was wrong:** The code was computing the upper/lower edges of a
channel definition by taking `chan->center_freq` (the control channel's
center frequency) and adding/subtracting half the bandwidth. However,
for wide channels (40/80/160 MHz), the control channel's center
frequency is NOT the center of the entire channel definition —
`center_freq1` is. For example, on an 80 MHz channel, the control
channel is a 20 MHz slice at one edge, so `chan->center_freq` could be
30 MHz away from the actual center of the chandef.

**Impact of the bug:** The separation check between two 5 GHz links
would use incorrect edge calculations. This could either:
- Incorrectly allow EMLSR on links that are too close together (causing
  HW/FW issues)
- Incorrectly disallow EMLSR on links that should be valid (degrading
  WiFi 7 performance)

Both outcomes affect real users with Intel WiFi 7 hardware using EMLSR.

### 3. Classification

This is a clear **bug fix** — correcting a wrong variable reference in a
calculation. It's not a feature addition, refactoring, or cleanup.

### 4. Scope and Risk Assessment

- **Lines changed:** 2 (extremely small)
- **Files changed:** 1
- **Risk:** Very low — the change simply uses the correct field from the
  same structure
- **Subsystem:** iwlwifi driver (Intel wireless) — widely used, actively
  maintained
- **Could break something?** Extremely unlikely — it's correcting a
  calculation to use the semantically correct value

### 5. User Impact

This affects users with Intel WiFi 7 hardware (which supports EMLSR).
Incorrect EMLSR pair validation could lead to:
- Using EMLSR on unsuitable link pairs → potential connectivity issues
  or firmware problems
- Not using EMLSR on suitable pairs → reduced WiFi 7 performance

WiFi 7 with EMLSR is increasingly common in modern laptops.

### 6. Stability Indicators

- Reviewed by Johannes Berg (cfg80211/mac80211 maintainer)
- The fix is obviously correct — `center_freq1` is the standard field
  for the center frequency of the entire channel definition, while
  `chan->center_freq` is only the control channel

### 7. Dependency Check

The code references `cfg80211_chandef_get_width()` and `center_freq1` —
both are long-established cfg80211 infrastructure. The `mld/mlo.c` file
is relatively new (WiFi 7/MLD support), so I should check when this was
introduced.

Let me check if this code exists in stable trees:

The `drivers/net/wireless/intel/iwlwifi/mld/` directory is part of the
iwlwifi MLD (Multi-Link Device) support which was added relatively
recently. This would only need backporting to stable trees that contain
this code.

### 8. Stable Criteria Assessment

| Criterion | Met? |
|-----------|------|
| Obviously correct | Yes — `center_freq1` is the correct field for
chandef center |
| Fixes real bug | Yes — wrong frequency used in separation calculation
|
| Small and contained | Yes — 2 lines in 1 file |
| No new features | Correct — pure fix |
| Tested (reviewed) | Yes — Reviewed-by Johannes Berg |

### Risk vs Benefit

- **Risk:** Essentially zero — it's a 2-line change using the correct
  struct field
- **Benefit:** Correct EMLSR link pair validation for Intel WiFi 7 users

The fix is small, surgical, obviously correct, fixes a real bug in
wireless channel validation, was reviewed by the cfg80211 maintainer,
and meets all stable kernel criteria.

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/mlo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
index c6b151f269216..1efefc737248f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
@@ -844,9 +844,9 @@ iwl_mld_emlsr_pair_state(struct ieee80211_vif *vif,
 		if (c_low->chan->center_freq > c_high->chan->center_freq)
 			swap(c_low, c_high);
 
-		c_low_upper_edge = c_low->chan->center_freq +
+		c_low_upper_edge = c_low->center_freq1 +
 				   cfg80211_chandef_get_width(c_low) / 2;
-		c_high_lower_edge = c_high->chan->center_freq -
+		c_high_lower_edge = c_high->center_freq1 -
 				    cfg80211_chandef_get_width(c_high) / 2;
 
 		if (a->chandef->chan->band == NL80211_BAND_5GHZ &&
-- 
2.51.0

