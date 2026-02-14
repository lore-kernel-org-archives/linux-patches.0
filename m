Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A0921CC51;
	Sat, 14 Feb 2026 01:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031178; cv=none; b=IbdJcF1iYoBKynpX3darf1wpVbOAN0ab4y90TsXuFnm6C827S4Q3NyphOOeMajZISCT70/iPl0ZB2SGmFBDmv8zN8mEIDt9PZ6y2gJcqCJ+cNYwm3M1vmoMV7zRAi0D26VWYioM29htDGLPk/5070Gc5B8l4SWFcMfgtNA7B/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031178; c=relaxed/simple;
	bh=GHcyStTuYgk9248+ZgiWTEGoNOtoLR827ZiQo/x1ng4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZE2p9BZx68tc75z0hQH/6DbJ7nMo7yHsMruRcuAWH/XlgoUl8fUk/HrjEgg/ELha0KnAbj6rHSeTQs5IObEo2ehU4M1DRfEg5/W81sFMN+KkGDmieJVn9ibgzG6altEpV+8XrO60MR2NpRLb+/whQ3OsTXdXzAuRW046G2YsEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PU97r3er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PU97r3er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6B8C116C6;
	Sat, 14 Feb 2026 01:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031178;
	bh=GHcyStTuYgk9248+ZgiWTEGoNOtoLR827ZiQo/x1ng4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PU97r3erxaSJZZ1QLGnJD6vMeJ0ohVPgF15DyhA/X4i9fMLhF6by7vZce4w27EWND
	 rtqdn3pRv/DxqEi/zRaG3RYuWRWuL3wyrO1sykFQImzcCLSt2i2CTf4qW/NROPvFEh
	 KJS/zSJdteOP5HbKqVlsis6stHdiLh49WNcDONCa1jbPRLJe/zFMTuKl54KRuD49dq
	 g1esx7+LEbdfuum1IP5Fcm9pDkymD9nxNEClZ7IbiTHe8zGsYlPuOTIjfaybVk9Y51
	 Rclj/4/xkdfeOeexTCY5rmjO9e/aJp0fjJtS9PFIgox3fiGdDb4y19iXbMhe0wbYT6
	 w//0M8O5iOt4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joey Bednar <linux@joeybednar.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] HID: apple: Add "SONiX KN85 Keyboard" to the list of non-apple keyboards
Date: Fri, 13 Feb 2026 19:59:31 -0500
Message-ID: <20260214010245.3671907-91-sashal@kernel.org>
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

From: Joey Bednar <linux@joeybednar.com>

[ Upstream commit 7273acfd0aef106093a8ffa3b4973eb70e5a3799 ]

The SoNiX KN85 keyboard identifies as the "Apple, Inc. Aluminium
Keyboard" and is not recognized as a non-apple keyboard. Adding "SoNiX
KN85 Keyboard" to the list of non-apple keyboards fixes the function
keys.

Signed-off-by: Joey Bednar <linux@joeybednar.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the exact same pattern. The "SONiX KN85 Keyboard"
identifies itself as an Apple keyboard (via vendor/product IDs matching
Apple's Aluminium Keyboard) but has a different HID name string than
"SONiX USB DEVICE", so the existing entry doesn't match it. The
`strncmp` prefix match means "SONiX USB DEVICE" would only match devices
whose name starts with exactly that string — "SONiX KN85 Keyboard"
starts with "SONiX KN" which doesn't match "SONiX USB".

---

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and concise:
- **Problem**: The SoNiX KN85 keyboard identifies itself (via USB
  VID:PID) as the "Apple, Inc. Aluminium Keyboard" but is not an Apple
  keyboard.
- **Consequence**: Without the fix, the HID apple driver applies Apple-
  specific function key mapping (`fnmode=1`, fkeyslast), making the
  function keys behave as media keys by default. This is wrong for a
  non-Apple keyboard.
- **Fix**: Adding the keyboard's name string to the
  `non_apple_keyboards[]` list so it gets properly detected and uses
  `fnmode=2` (fkeysfirst) by default.
- The commit was signed off by the HID subsystem maintainer Jiri Kosina,
  confirming it was accepted through the proper review process.

### 2. CODE CHANGE ANALYSIS

The change is a **single line addition** to a static constant array:

```356:367:drivers/hid/hid-apple.c
static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
        { "SONiX USB DEVICE" },
        { "SONiX AK870 PRO" },
        // ... rest of array
};
```

The new entry `{ "SONiX KN85 Keyboard" }` is added at the top. The
matching mechanism (`apple_is_non_apple_keyboard()` at line 369) does a
`strncmp` prefix comparison, so the full name "SONiX KN85 Keyboard"
would need to start with "SONiX KN85 Keyboard" to match (which it does
exactly). The existing "SONiX USB DEVICE" entry does NOT match because
the KN85 keyboard reports its name starting with "SONiX KN85", not
"SONiX USB".

### 3. CLASSIFICATION

This is a **hardware quirk/workaround**. The SoNiX KN85 keyboard is a
non-Apple keyboard that falsely presents Apple USB vendor/product IDs (a
common practice for cheap third-party keyboards), causing it to be
handled by the `hid-apple` driver. The driver then applies Apple-
specific key translation logic to a keyboard that doesn't need or want
it, breaking the function keys for the user.

This falls squarely into the "QUIRKS and WORKAROUNDS" exception category
for stable backporting:
- It's a hardware-specific fix for a real device with broken behavior
- It uses an existing mechanism (the `non_apple_keyboards` array)
- It fixes a real user-facing issue (broken function keys)

### 4. SCOPE AND RISK ASSESSMENT

- **Size**: 1 line added to a data array. Cannot be smaller.
- **Files touched**: 1 (`drivers/hid/hid-apple.c`)
- **Complexity**: Zero — it's a string literal added to an array
- **Risk of regression**: Effectively zero. The string match only
  triggers for devices reporting "SONiX KN85 Keyboard" as their name. No
  other devices are affected. The matching is by HID device name, not
  vendor/product ID, so it's extremely targeted.
- **Dependencies**: None. The `non_apple_keyboards[]` mechanism exists
  in all relevant stable trees (introduced in v6.0-rc1).

### 5. USER IMPACT

- **Who is affected**: Users of the SoNiX KN85 keyboard running Linux.
  These are real-world hardware owners.
- **Severity**: Without this fix, the function keys (F1-F12) on the KN85
  keyboard are mapped to media keys by default (brightness, volume,
  etc.), which is wrong for this keyboard. This makes the keyboard
  effectively unusable for standard function key operations unless the
  user manually overrides `fnmode` via a module parameter.
- **Workaround exists**: Users can set `fnmode=2` manually, but this is
  not discoverable and should not be needed.

### 6. STABILITY INDICATORS

- The commit follows the exact same pattern as **5+ previous similar
  commits** (SONiX AK870 PRO, hfd.cn/WKB603, Jamesdonkey/A3R, Hailuck,
  the original non-apple keyboards mechanism).
- Signed off by the HID subsystem maintainer (Jiri Kosina).
- The pattern has been in the kernel since v6.0 and is well understood.

### 7. DEPENDENCY CHECK

- **No dependencies**. The `non_apple_keyboards[]` array and
  `apple_is_non_apple_keyboard()` function exist in all relevant stable
  trees.
- The patch applies cleanly to any tree that already has the "SONiX
  AK870 PRO" entry (or can trivially be adjusted if that entry isn't
  present — it's just adding a line to an array).

### 8. PRECEDENT

This is identical in nature to the "SONiX AK870 PRO" (743c81cdc98fd),
"hfd.cn/WKB603" (df83a0df820b9), "Hailuck" (c4444d8749f69), and
"Jamesdonkey/A3R" (113f736655e4f) commits. All follow the same one-line-
addition pattern to the same array.

### Summary

This is a textbook hardware quirk addition — a single line of data added
to an existing mechanism that fixes broken function keys for a specific
keyboard model. It has zero risk of regression, zero dependencies beyond
existing infrastructure, fixes a real user-facing problem, and follows a
well-established pattern with multiple precedents. This is exactly the
kind of commit that stable trees exist to carry.

**YES**

 drivers/hid/hid-apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 57da4f86a9fa7..233e367cce1d1 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -354,6 +354,7 @@ static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
 };
 
 static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
+	{ "SONiX KN85 Keyboard" },
 	{ "SONiX USB DEVICE" },
 	{ "SONiX AK870 PRO" },
 	{ "Keychron" },
-- 
2.51.0

