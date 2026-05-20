Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A853D3DCD9C;
	Wed, 20 May 2026 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276012; cv=none; b=I8dNUSvUD8NIwlSOOdOnAZ57K9URAPAMV266zW8SvmvFPI3S9AT/tR3yXO+F7coigMp7OT3cN9nnBGYcGNNHfsgl+NFcSssuHE8WwbwfgMhfN639LT9F5JS6BrjazcH+QTfJNisYG4h9AgzwrTu3COsRCJn9esrkGLQkPJpUaQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276012; c=relaxed/simple;
	bh=v4e5a/aMz1v6YR6+cednVDxQr9k3Oa+VodsgFCUyhVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0stWTCIYrJAqDzIYp7Kid5+/0iLrJOlgJFzIQb9QrBG+lHEbEFJj2CahXKsHZlb2Z35ZSMxPksc9SH9iZbmC1xjuZdZO30u+u0+my/zq771Y3UsWM+/jRH/5kqdpBZ5ah8qxwHAiMWcWCgoOHh13Zv98T7At2MnIqk8KDspgow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5LPF1J/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5LPF1J/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638791F00894;
	Wed, 20 May 2026 11:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276007;
	bh=wh2vO+k2OhSXHw9Yg21L+HN+Ur8L1oQbLmdePBB+R98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5LPF1J/4TewEoUQVfXgXu+kBGKHoDoWw8ETg/KWpZh0ZQ83roQKF5Sb2LV/Do4/p
	 1c5p9Iq6jquG2tUQr/eEbo59BEH1jdbeD73tBpw6X1VzrtJy373WkDQgyr3XRDjuhf
	 RxS0Xc8QBqtP8SSv2VpJwWvJRPGweJJrvyz3I9mLWOfFynSxqQV0UYc5+O34IWaSkE
	 aAjzyuPPmAzqFknLqlZGwQM+/HuJ2Ln4zSONAVHFDfVVspwuyG+PIIqTkLZgDVkqg8
	 3vNh/utmkddK0AzpwJRvslCGdLsHusfojp81Yzx8tRe5BkC5uEmRvD6u1Chxl6Sq2C
	 96/ncE5/qBGMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen-Shi-Hong <eric039eric@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	linux-hwmon@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] docs: hwmon: sy7636a: fix temperature sysfs attribute name
Date: Wed, 20 May 2026 07:18:48 -0400
Message-ID: <20260520111944.3424570-16-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Shi-Hong <eric039eric@gmail.com>

[ Upstream commit 51f57607e30bee282a1d40845f89a311cbb26481 ]

The hwmon sysfs naming convention uses
temp[1-*]_input for temperature channels.

Documentation/hwmon/sy7636a-hwmon.rst currently documents
temp0_input, while the driver uses the standard hwmon
temperature channel interface.

Update the documentation to use temp1_input.

Signed-off-by: Chen-Shi-Hong <eric039eric@gmail.com>
Link: https://lore.kernel.org/r/20260514154108.1937-1-eric039eric@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record: Subsystem is `docs: hwmon: sy7636a`. Action verb is `fix`.
Claimed intent is to correct the documented temperature sysfs attribute
name from `temp0_input` to `temp1_input`.

Record: Tags present: `Signed-off-by: Chen-Shi-Hong
<eric039eric@gmail.com>`, `Link:
https://lore.kernel.org/r/20260514154108.1937-1-eric039eric@gmail.com`,
`Signed-off-by: Guenter Roeck <linux@roeck-us.net>`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
stable`.

Record: The commit describes a documentation bug: the sy7636a hwmon
document names `temp0_input`, while hwmon temperature channels are named
`temp[1-*]_input`. No crash, data corruption, or runtime bug is claimed.

Record: This is not a hidden runtime bug fix. It is an explicit
documentation correctness fix.

## Phase 2: Diff Analysis
Record: One file changed: `Documentation/hwmon/sy7636a-hwmon.rst`, 1
insertion and 1 deletion. No functions modified. Scope is a single-file
documentation-only surgical fix.

Record: Before, the document told users to read `temp0_input`. After, it
tells users to read `temp1_input`. No normal/error/init runtime path
changes.

Record: Bug category is documentation/API-description correctness.
Verified against `Documentation/hwmon/sysfs-interface.rst`, which
documents `temp[1-*]_input`, and `drivers/hwmon/hwmon.c`, where
temperature attributes use `temp%d_input` with base index `1`.

Record: Fix quality is obviously correct and minimal. Runtime regression
risk is zero because no code changes.

## Phase 3: Git History Investigation
Record: `git blame` shows `temp0_input` was introduced by
`de34a40532507` when the sy7636a hwmon driver/doc was added. Ancestry
checks show that commit is not in `v5.17` but is in `v5.18`, so the
documentation bug exists from v5.18 onward where the driver exists.

Record: No `Fixes:` tag is present, so there was no Fixes target to
follow.

Record: Related file history on `origin/master`: `51f57607e30be` doc
attribute fix, `2f88425ef590b` regulator-enable leak fix,
`68c2a8b59d231` sensor description doc fix, `80038a758b7fc` alias
addition, `5b5d8ae019543` constification, `a96f688b4e446` underline
warning fix, `de34a40532507` driver addition. This patch is standalone
for trees with the current doc context.

Record: Author history under hwmon/doc paths shows only this commit from
Chen-Shi-Hong in the checked history. Guenter Roeck, the hwmon
maintainer, committed/applied it.

Record: No functional dependencies. For older stable trees that do not
contain `68c2a8b59d231`, the exact patch context differs and needs a
trivial manual backport.

## Phase 4: Mailing List And External Research
Record: `b4 dig -c 51f57607e30be` found the original submission at
`https://patch.msgid.link/20260514154108.1937-1-eric039eric@gmail.com`.

Record: `b4 dig -a` found only v1 of a single-patch series. No newer
unapplied revision found.

Record: `b4 dig -w` showed recipients included Chen-Shi-Hong, Guenter
Roeck, Jonathan Corbet, Shuah Khan, `linux-hwmon`, `linux-doc`, and
`linux-kernel`.

Record: The b4-fetched thread contains Guenter Roeck replying “Applied.”
No NAKs, objections, or stable-specific nomination were found in that
thread. Lore `WebFetch` was blocked by Anubis, but `b4` successfully
retrieved the thread.

## Phase 5: Code Semantic Analysis
Record: No code functions are modified.

Record: Manual code tracing verified the documentation claim:
`drivers/hwmon/sy7636a-hwmon.c` registers `HWMON_CHANNEL_INFO(temp,
HWMON_T_INPUT)`. `drivers/hwmon/hwmon.c` formats temperature attributes
with `temp%d_input`, and `hwmon_attr_base()` returns `1` for temperature
sensors. Therefore the first temperature channel is `temp1_input`.

Record: Callers/callees are not applicable to the patch because it
changes documentation only. The affected “path” is users reading the
hwmon documentation.

Record: Similar pattern check found the generic hwmon documentation and
many hwmon docs use `temp1_input`, supporting the correction.

## Phase 6: Stable Tree Analysis
Record: `v5.15` does not contain `Documentation/hwmon/sy7636a-hwmon.rst`
or `drivers/hwmon/sy7636a-hwmon.c`, so the patch is not applicable
there.

Record: `v6.1`, `v6.6`, and `v6.12` contain the sy7636a driver and the
wrong `temp0_input` documentation. `v7.0` contains the wrong attribute
name with the newer “external NTC” text.

Record: The exact patch applies cleanly to the current
`stable/linux-7.0.y` checkout. It does not apply cleanly to `v6.1` or
`v6.6` because the surrounding description text differs before the later
doc description fix; a trivial one-line context-adjusted backport is
needed there.

Record: No alternate fix for this exact documentation bug was found in
local stable history.

## Phase 7: Subsystem Context
Record: Subsystem is hwmon documentation. Criticality is low for
runtime, but it documents a userspace-visible sysfs ABI path for sy7636a
hardware users.

Record: The sy7636a hwmon files have low churn and only a handful of
targeted fixes since introduction.

## Phase 8: Impact And Risk
Record: Affected population is sy7636a hardware users and anyone writing
scripts or instructions based on
`Documentation/hwmon/sy7636a-hwmon.rst`.

Record: Trigger is reading/following the documentation. If followed
literally, users look for a non-existent `temp0_input` instead of the
actual `temp1_input`.

Record: Failure severity is LOW: documentation/user guidance bug, not a
kernel crash or data corruption issue.

Record: Benefit is modest but real: correct stable documentation for a
userspace-visible hwmon attribute. Risk is effectively zero: one
documentation line, no code, no ABI change.

## Phase 9: Final Synthesis
Evidence for backporting: verified documentation is wrong; verified
driver/core generate `temp1_input`; patch is one-line documentation-
only; hwmon maintainer applied it; documentation fixes are an allowed
stable exception with no runtime regression risk.

Evidence against backporting: it is not a serious runtime bug, security
issue, crash, or data corruption fix. Older stable trees before the
sensor-description doc change need a trivial context adjustment.

Stable rules checklist: obviously correct, yes; fixes a real
documentation bug, yes; important runtime issue, no; small and
contained, yes; no new feature/API, yes; stable applicability, yes for
v7.0 cleanly and older applicable with minor backport adjustment.
Exception category: documentation fix.

Verification:
- [Phase 1] Parsed exact commit `51f57607e30be` from `origin/master` and
  confirmed tags/message.
- [Phase 2] Inspected exact diff: one doc line changes `temp0_input` to
  `temp1_input`.
- [Phase 3] `git blame` confirmed `temp0_input` came from
  `de34a40532507`; ancestry checks place it first in v5.18.
- [Phase 4] `b4 dig` found the original patch; `b4 dig -a` showed v1
  only; `b4 dig -w` showed appropriate hwmon/doc recipients; b4 mbox
  showed Guenter replied “Applied.”
- [Phase 5] Read sy7636a driver and hwmon core; confirmed first
  temperature channel is named `temp1_input`.
- [Phase 6] Checked `v5.15`, `v6.1`, `v6.6`, `v6.12`, and `v7.0`
  content; exact patch applies to current 7.0 stable, not directly to
  v6.1/v6.6 due context.
- [Phase 8] Confirmed no runtime code changes, so regression risk is
  zero.

This should be backported where the sy7636a documentation exists, with
trivial context adjustment for older trees as needed.

**YES**

 Documentation/hwmon/sy7636a-hwmon.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/hwmon/sy7636a-hwmon.rst b/Documentation/hwmon/sy7636a-hwmon.rst
index 0143ce0e5db76..03d866aba6e81 100644
--- a/Documentation/hwmon/sy7636a-hwmon.rst
+++ b/Documentation/hwmon/sy7636a-hwmon.rst
@@ -22,5 +22,5 @@ The following sensors are supported
 sysfs-Interface
 ---------------
 
-temp0_input
+temp1_input
 	- Temperature of external NTC (milli-degree C)
-- 
2.53.0

