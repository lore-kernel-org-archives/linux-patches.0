Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409188F66;
	Sun, 10 Aug 2025 00:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785275; cv=none; b=pD8LjeIBv5KuNKt3f53rj3QuLFrlkCseQUEL40R3RTwLckVTXjfc/9v6sED0fNkkSPaNPLHisTOwfhNJkgv8aYJEz8pMTpih+4cNnPgTMzcySNldj4aRPmdx48brJBet/lRbGQ3QFyQPotjg9/SqKd7eNDSQx/Ajyi8eQ82gjao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785275; c=relaxed/simple;
	bh=41hUf9bxvDMh/CKNrGtM+EU4UvB6br1dU5pEOJhS6v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yh253e9PuLvXjUF7Nm2IHsN+QrPWAmAxsDul+cPSkPR0J6vDhWTfo/5xkBY89Ab4+At6u12EWtC7+x9oL+p0rkDwU4d1lTNOKaHvAA1XMUVdVufKR7Rq2HSpY/oKeXapC5sBUA3a+L4SJjVvgZ4xRIhVXLsnvWfXrxfVqXZ/TXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rGACSqRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGACSqRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE94CC4CEF4;
	Sun, 10 Aug 2025 00:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785275;
	bh=41hUf9bxvDMh/CKNrGtM+EU4UvB6br1dU5pEOJhS6v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGACSqRNdfDUWwOUPGD4YkbxbS7A41Rt0BBJOXkdYEzUiBnICCxabSuIcZRHY66kp
	 Kr5XYYSChI8YAFV6I43RXGhQNOr/jmxAZuofN013KKM1j0LLsCYpqqDC+nDQHyyxyV
	 QF0EFxsNu/Pft8knXkxnpAh41Wag8PFwwjMnCla3Gz/E2/ScNGhK+vk1zq4Z9XkjNt
	 cir9vK2pD2u5d4/0s/yL3geix6WGO/MvEpFXcoaE69V3PCTlMVctKEKCfPB+1sppr2
	 b0ZrJQs8y4p8lZmzJwUZAe20CL6IoUxTsSu1M5FA3uywLBiYg0wtJ7RKqQifOFhkYI
	 Vc87TD7AAGCzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	Peter Korsgaard <peter@korsgaard.com>,
	Cherniaev Andrei <dungeonlords789@naver.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-5.4] kconfig: lxdialog: fix 'space' to (de)select options
Date: Sat,  9 Aug 2025 20:20:52 -0400
Message-Id: <20250810002104.1545396-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

[ Upstream commit 694174f94ebeeb5ec5cc0e9de9b40c82057e1d95 ]

In case a menu has comment without letters/numbers (eg. characters
matching the regexp '^[^[:alpha:][:digit:]]+$', for example - or *),
hitting space will cycle through those comments, rather than
selecting/deselecting the currently-highlighted option.

This is the behaviour of hitting any letter/digit: jump to the next
option which prompt starts with that letter. The only letters that
do not behave as such are 'y' 'm' and 'n'. Prompts that start with
one of those three letters are instead matched on the first letter
that is not 'y', 'm' or 'n'.

Fix that by treating 'space' as we treat y/m/n, ie. as an action key,
not as shortcut to jump to  prompt.

Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: Cherniaev Andrei <dungeonlords789@naver.com>
[masahiro: took from Buildroot, adjusted the commit subject]
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding of the bug and fix. Let me provide
my analysis:

**Backport Status: YES**

## Extensive Analysis:

This commit fixes a **clear user interface bug** in the kernel's
menuconfig system (lxdialog) that affects the fundamental usability of
kernel configuration. Here's the detailed analysis:

### The Bug:
When a menu contains comment lines that start with non-alphanumeric
characters (like `-`, `*`, or other special characters matching
`^[^[:alpha:][:digit:]]+$`), pressing the space bar incorrectly cycles
through these comment items instead of selecting/deselecting the
currently highlighted option.

### Root Cause (from code analysis):

1. **Line 267 (original)**: The condition `if (strchr("ynmh", key))`
   checks if the pressed key is one of the special action keys (`y`,
   `n`, `m`, `h`). If it is, it sets `i = max_choice` to skip the jump-
   to-prompt logic.

2. **Lines 269-282**: For any other key (including space), the code
   searches for menu items starting with that character, treating it as
   a shortcut to jump to prompts beginning with that letter.

3. **The problem**: Space (ASCII 32) was not included in the special
   action keys list, so when pressed, it would trigger the jump-to-
   prompt logic. If menu items had comments starting with spaces or
   special characters, the space key would match these and jump to them
   instead of performing its intended action.

4. **Lines 362-398**: The switch statement shows that space (line 362)
   IS supposed to be an action key that returns value 8 (line 397-398),
   which indicates a selection/deselection action.

### The Fix:
The fix is minimal and surgical - changing line 267 from:
```c
if (strchr("ynmh", key))
```
to:
```c
if (strchr("ynmh ", key))  // Added space character
```

This ensures space is treated as an action key, not as a jump-to-prompt
shortcut.

### Why This Should Be Backported:

1. **Fixes a real user-facing bug**: This directly impacts anyone using
   menuconfig to configure the kernel, which is a fundamental tool for
   kernel configuration.

2. **Minimal and contained fix**: The change is a single character
   addition with no architectural changes or new features.

3. **Low regression risk**: The fix only affects the specific broken
   behavior and restores the intended functionality that's already
   defined in the switch statement.

4. **Long-standing issue**: The commit message indicates this came from
   Buildroot, suggesting it's been affecting users across multiple
   projects for some time.

5. **Clear behavioral inconsistency**: The code clearly shows space was
   meant to be an action key (returning value 8 in the switch
   statement), but was incorrectly handled in the shortcut logic.

6. **No side effects**: The change only affects space key handling in
   menuconfig and doesn't touch any kernel runtime code or critical
   subsystems.

This is an ideal stable backport candidate - it fixes a clear bug with
minimal change and risk.

 scripts/kconfig/lxdialog/menubox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 6e6244df0c56..d4c19b7beebb 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -264,7 +264,7 @@ int dialog_menu(const char *title, const char *prompt,
 		if (key < 256 && isalpha(key))
 			key = tolower(key);
 
-		if (strchr("ynmh", key))
+		if (strchr("ynmh ", key))
 			i = max_choice;
 		else {
 			for (i = choice + 1; i < max_choice; i++) {
-- 
2.39.5

