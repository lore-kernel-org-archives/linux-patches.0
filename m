Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D634611EB;
	Tue, 10 Mar 2026 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133346; cv=none; b=YwkkF37FOh0UjcUdfev9dRnwslyVBfmRNG2wBAyLBqtzNRJwL9EPWuo1GEXzj8Dp6M1k51n4h0HxPyqp9sAl33dabAih9LmBEjFymiX/pwCaRSh8KVkKcwwPwDSGbSvBNEa25NfCuQ7UEyPzm7TGThGeKBxObG4jXQ/7hOguMFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133346; c=relaxed/simple;
	bh=kJ9yAoKqQR0qPa9X6EJY1Faa7AXdnaoQnpLA7rvbQS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIPv+YNyVNo0andMqFwO9Y5CCzw8ujb/ltMzFw0eyslPu0aHuH4Li4NEdlG+7uEo2SPYIL1CCi4iL0LEo4Aw3gQKYR0QibukJW+BSn6bUD5Ch/gCB8RmIlz6kpbKK7R1z41UKfFxQQFb2hUHQOPr19r3zpQYNdOYLc5I+F+m4Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/M9COnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/M9COnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AE2C2BC9E;
	Tue, 10 Mar 2026 09:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133346;
	bh=kJ9yAoKqQR0qPa9X6EJY1Faa7AXdnaoQnpLA7rvbQS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/M9COnxW8j/hvE6m+KXdZuTWcVPG+jCZflpXB1hi/NhR+0ONcihynp6cazUmfzJV
	 K8WZLXAvqCKj8YmT5+6bVcs0OQTZPe/0ZP6PnbRCWLSoUj7pBIVtSs8D/ynUQVTohB
	 NbhBjBpCQxWCsADCdV93UmvRLGik0fGSb5nE7Pn147uivBSbW9dgKL8ibJ0FYkQW6k
	 fsvuwU2tTthXmlTw7dUD8adaXlH36YnBt0Wosaou1kPFQQE88YQyN42AxHlnzINeUN
	 AVbgDx4hDR5+osDoaOYHpGIYwvllJAghl4DmiLmBhM+CXOmNPbsrl2cjweD/3VOO4c
	 B3Mv1si3lzFug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] HID: apple: Add EPOMAKER TH87 to the non-apple keyboards list
Date: Tue, 10 Mar 2026 05:01:27 -0400
Message-ID: <20260310090145.2709021-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7c698de0dc5daa1e1a5fd1f0c6aa1b6bb2f5d867 ]

EPOMAKER TH87 has the very same ID as Apple Aluminum keyboard
(05ac:024f) although it doesn't work as expected in compatible way.

Put three entries to the non-apple keyboards list to exclude this
device: one for BT ("TH87"), one for USB ("HFD Epomaker TH87") and one
for dongle ("2.4G Wireless Receiver").

Link: https://bugzilla.suse.com/show_bug.cgi?id=1258455
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The patch just adds three string entries to the array. The only concern
is whether the exact context (previous entries) exists in stable trees,
but since this is just appending to an array, even if some intermediate
entries are missing, the patch can be trivially adjusted.

### Problem Being Fixed

The EPOMAKER TH87 keyboard uses the same USB vendor/product ID as Apple
Aluminum keyboards (05ac:024f). Without this fix, the hid-apple driver
applies Apple-specific key translation logic to this non-Apple keyboard,
causing it to not work as expected. The bug is tracked in SUSE's
bugzilla (bsc#1258455), confirming it affects real users.

### Stable Kernel Rules Assessment

1. **Obviously correct and tested**: Yes - trivial addition of string
   entries to a quirk list. Same pattern used for 10+ other keyboards.
   Comes from SUSE maintainer (Takashi Iwai).
2. **Fixes a real bug**: Yes - keyboard doesn't work correctly without
   this fix.
3. **Important issue**: Yes - keyboard malfunction for affected users
   (wrong key mappings).
4. **Small and contained**: Yes - adds 3 lines to a static array, zero
   logic changes.
5. **No new features/APIs**: Correct - uses existing infrastructure.
6. **Applies cleanly**: Should apply with trivial context adjustment if
   intermediate entries are missing.

### Risk Assessment

**Risk: Extremely low.** The change only adds entries to a name-matching
list. The matching uses `strncmp` prefix matching. The entries are
specific enough ("TH87", "HFD Epomaker TH87", "2.4G Wireless Receiver")
to only match intended devices. One concern: "2.4G Wireless Receiver" is
a somewhat generic name and could match other devices' dongles, but the
effect of matching (setting `APPLE_IS_NON_APPLE` flag which changes
fnmode default) is benign for actual non-Apple keyboards.

### Verification

- **Verified** `non_apple_keyboards` infrastructure was introduced in
  commit `a0a05054583fe` (v6.0-rc1), present in all current stable trees
  (6.1.y+).
- **Verified** the commit adds only 3 string entries to the static
  `non_apple_keyboards[]` array at line 368-370.
- **Verified** `apple_is_non_apple_keyboard()` uses `strncmp` prefix
  matching at line 380.
- **Verified** the effect of matching is setting `APPLE_IS_NON_APPLE`
  quirk bit at line 770, which changes function key behavior default.
- **Verified** the bug is tracked at
  `https://bugzilla.suse.com/show_bug.cgi?id=1258455` (referenced in
  Link: tag).
- **Verified** this follows the exact same pattern as 7+ previous non-
  apple keyboard additions (GANSS, Hailuck, Jamesdonkey, A3R, hfd.cn,
  WKB603, SONiX AK870 PRO, SONiX KN85).
- **Verified** author is Takashi Iwai (tiwai@suse.de), a senior SUSE
  kernel maintainer.

### Conclusion

This is a textbook hardware quirk addition. It adds device
identification entries to an existing mechanism, fixing a real-world
keyboard malfunction reported by users (with bugzilla link). The change
is trivial (3 lines of string data), zero risk to existing
functionality, and follows an established pattern used by many other
entries. It clearly meets all stable kernel criteria.

**YES**

 drivers/hid/hid-apple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 233e367cce1d1..2f9a2e07c4263 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -365,6 +365,9 @@ static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
 	{ "A3R" },
 	{ "hfd.cn" },
 	{ "WKB603" },
+	{ "TH87" },			/* EPOMAKER TH87 BT mode */
+	{ "HFD Epomaker TH87" },	/* EPOMAKER TH87 USB mode */
+	{ "2.4G Wireless Receiver" },	/* EPOMAKER TH87 dongle */
 };
 
 static bool apple_is_non_apple_keyboard(struct hid_device *hdev)
-- 
2.51.0

