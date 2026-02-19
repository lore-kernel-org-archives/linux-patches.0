Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C89528980F;
	Thu, 19 Feb 2026 02:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466671; cv=none; b=L9I14EUq9gACeOcNdJjLAneU6cjb6hlRmXqT8ByIwSZxbFcu+qY9QLfn0JSlowoJ8g96Oh4G3ywwrOYlRhdecUhUp0nln7oZPept49T1GjYjjgHXhOsqp9HQGoNPHGjpy3XDf1e5OVHPdWzJpQrdw0y85i2UvGmwEcpqqq3tpy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466671; c=relaxed/simple;
	bh=0TRuLX6kxaRiOecT1Z3qkCQxkd7l+AXEWIyszpjG+0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ek/C9OIqN9udptYp56+dGSIC08MpDSwwseRQNoBBgySXqGF/0GNlGuyWe2TG41PI3kfhLwvF3PWSFoDvoEpNAJVTQ6mrQccs+n9dTB/gPjPYtq3uMRqh3/xS6v+sIwAodJHa+i+p+kP11NeAq+8I6XMlBFTi4mSbUQ9qHyThNCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6YnbUVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6YnbUVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAA8C19424;
	Thu, 19 Feb 2026 02:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466670;
	bh=0TRuLX6kxaRiOecT1Z3qkCQxkd7l+AXEWIyszpjG+0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6YnbUVQ0L4aep7k4R9/yG3qdnp7Doo9aw1xQAgdfpNFQxZZCWG4ewgEglXy6yqPC
	 b1Et48AQ+02IlGzd4JJWaYUL804Seip2VVrNw4dsgg9SFhPyw7KZJBx982YyY+qX3Y
	 jgliFS6Ah1/l6KYzNhBzQYJbacYeBgtlfw+vCqGEk9/xpI7/KSSSD4TVKYpTkfrr4Y
	 fafSUFdcabN2oe2vp41EK8oX1i4NFWlgifrDx1ezpv9WK49fr9rPiQFDEIIzh/0Lch
	 qZQFhn6/zKNBuq2kSEZRVzG0F3438h9XVdYGGhubS3NfIcflqT9M85D7WQRNRLlVKk
	 TFS+4Wov+PfCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Markus Perkins <markus@notsyncing.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] misc: eeprom: Fix EWEN/EWDS/ERAL commands for 93xx56 and 93xx66
Date: Wed, 18 Feb 2026 21:03:42 -0500
Message-ID: <20260219020422.1539798-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Markus Perkins <markus@notsyncing.net>

[ Upstream commit b54c82d6cbfc76647ba558e8e3647eb2b0ba0e2b ]

commit 14374fbb3f06 ("misc: eeprom_93xx46: Add new 93c56 and 93c66
compatible strings") added support for 93xx56 and 93xx66 eeproms, but
didn't take into account that the write enable/disable + erase all
commands are hardcoded for the 6-bit address of the 93xx46.

This commit fixes the command word generation by increasing the number
of shifts as the address field grows, keeping the command intact.

Also, the check for 8-bit or 16-bit mode is no longer required as this
is already taken into account in the edev->addrlen field.

Signed-off-by: Markus Perkins <markus@notsyncing.net>
Link: https://patch.msgid.link/20251202104823.429869-3-markus@notsyncing.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### What the commit fixes

This commit fixes **broken EWEN (write enable), EWDS (write disable),
and ERAL (erase all) commands** for 93xx56 and 93xx66 EEPROMs. When
commit 14374fbb3f06 added support for these larger EEPROM variants (in
v5.14), the SPI command word generation for these special commands was
not updated to account for the larger address fields.

The ADDR_EWEN (0x30), ADDR_EWDS (0x00), and ADDR_ERAL (0x20) constants
are defined for the 6-bit address space of the 93xx46. With the 93xx56
and 93xx66, the address space is 7-9 bits depending on variant and mode.
The old code only handled the 93xx46 case (shift by 0 for 16-bit, shift
by 1 for 8-bit). The fix generalizes the shift to `(edev->addrlen - 6)`,
correctly scaling for all variants.

### Bug Impact

Without this fix, EWEN/EWDS/ERAL commands send **incorrect SPI command
words** to 93xx56 and 93xx66 EEPROMs. This means:
- **Write operations will fail** because write-enable (EWEN) sends the
  wrong command
- **Erase operations will fail** because ERAL sends the wrong command
- The EEPROM effectively becomes **read-only** because the write-enable
  gate cannot be opened

This is a **data correctness / hardware functionality** bug for anyone
using 93xx56 or 93xx66 EEPROMs.

### Stable Kernel Rules Assessment

1. **Obviously correct and tested**: The fix is mathematically sound —
   the shift formula `(addrlen - 6)` correctly generalizes the address
   offset for all variants. The commit was accepted by Greg KH.
2. **Fixes a real bug**: Yes — write and erase operations are completely
   broken for 93xx56/93xx66.
3. **Important issue**: Moderate — it makes the hardware unusable for
   writes.
4. **Small and contained**: Yes — only 2 code hunks in one file,
   changing 6 lines of logic code to 2, plus a comment.
5. **No new features**: Correct — this fixes existing broken
   functionality.
6. **Applies cleanly**: Should apply to any tree that has the
   prerequisite commit 14374fbb3f06 (v5.14+).

### Risk Assessment

- **Very low risk**: The fix is a simple arithmetic generalization. For
  the 93xx46 case (addrlen=6 or 7), the new code produces identical
  results to the old code. The change only affects 93xx56/93xx66 which
  were already broken.
- **No regression risk for existing users**: 93xx46 users are unaffected
  since `addrlen - 6 = 0` (16-bit) or `1` (8-bit), matching the original
  behavior exactly.

### Verification

- **git log** confirmed commit 14374fbb3f06d exists in the tree and was
  the commit that added 93c56/93c66 support (verified in
  `drivers/misc/eeprom/eeprom_93xx46.c`)
- **git describe --contains** showed 14374fbb3f06d went into v5.14-rc1,
  so stable trees v5.15.y, v6.1.y, v6.6.y, v6.12.y all contain the buggy
  code
- **Code analysis** of `eeprom_93xx46_probe()` (lines 485-503) confirmed
  addrlen calculation: `ilog2(size)` for 8-bit, `ilog2(size) - 1` for
  16-bit
- **Manual verification** of the shift arithmetic for all 6 variant/mode
  combinations confirmed the fix produces correct results
- **Backward compatibility verified**: For 93xx46 (addrlen=6 in 16-bit,
  addrlen=7 in 8-bit), the new formula `<< (addrlen - 6)` produces `<<
  0` and `<< 1` respectively, matching the old code's `else` and `if
  (EE_ADDR8)` branches exactly
- The file `drivers/misc/eeprom/eeprom_93xx46.c` exists in the current
  tree with the buggy code confirmed at lines 194-197 and 331-334
- The change was accepted via Greg KH (driver core maintainer), adding
  confidence in correctness

**YES**

 drivers/misc/eeprom/eeprom_93xx46.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index 9cae6f530679b..5230e910a1d11 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -45,6 +45,7 @@ struct eeprom_93xx46_platform_data {
 #define OP_START	0x4
 #define OP_WRITE	(OP_START | 0x1)
 #define OP_READ		(OP_START | 0x2)
+/* The following addresses are offset for the 1K EEPROM variant in 16-bit mode */
 #define ADDR_EWDS	0x00
 #define ADDR_ERAL	0x20
 #define ADDR_EWEN	0x30
@@ -191,10 +192,7 @@ static int eeprom_93xx46_ew(struct eeprom_93xx46_dev *edev, int is_on)
 	bits = edev->addrlen + 3;
 
 	cmd_addr = OP_START << edev->addrlen;
-	if (edev->pdata->flags & EE_ADDR8)
-		cmd_addr |= (is_on ? ADDR_EWEN : ADDR_EWDS) << 1;
-	else
-		cmd_addr |= (is_on ? ADDR_EWEN : ADDR_EWDS);
+	cmd_addr |= (is_on ? ADDR_EWEN : ADDR_EWDS) << (edev->addrlen - 6);
 
 	if (has_quirk_instruction_length(edev)) {
 		cmd_addr <<= 2;
@@ -328,10 +326,7 @@ static int eeprom_93xx46_eral(struct eeprom_93xx46_dev *edev)
 	bits = edev->addrlen + 3;
 
 	cmd_addr = OP_START << edev->addrlen;
-	if (edev->pdata->flags & EE_ADDR8)
-		cmd_addr |= ADDR_ERAL << 1;
-	else
-		cmd_addr |= ADDR_ERAL;
+	cmd_addr |= ADDR_ERAL << (edev->addrlen - 6);
 
 	if (has_quirk_instruction_length(edev)) {
 		cmd_addr <<= 2;
-- 
2.51.0

