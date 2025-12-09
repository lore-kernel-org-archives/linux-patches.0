Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069F32BEFE4;
	Tue,  9 Dec 2025 00:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239477; cv=none; b=PT3IfUO5LqRKzuC0r5AnWwwq+M9Nfbjm9J1pt6tbK+WuDaTKi7m2flvZFQezoNrw57P9Yd30hL4s744m42WsHsstZtIGPDCeoZzzKt2jne2msU/Iu70R1lLVq8RXpi9NCEwx1KPhWiMQeBUQvy7GVPimjf7ZCEFACh8XHjkEVn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239477; c=relaxed/simple;
	bh=IeZgkpybZ0rIz1q+Gm3w9egLOf4sif3gjsDJ1W0YVoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLRKC4vNsmCM7Dm3PTwNUpTMbTVELpS3uHPVF1Jzm5xuFEXZrLxK+CWvZ5Htq6J7KCcXjmVlvNxLE91AwEi7O34Kig3/6X00XdH73tlTah1v0XK8M6nov1V2Fd7KoMoHQ6Tus41VZULB52g3uMqDdppkoIDExPlhDVQsUuq8hio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5vdX7Th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5vdX7Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19C4C4CEF1;
	Tue,  9 Dec 2025 00:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239476;
	bh=IeZgkpybZ0rIz1q+Gm3w9egLOf4sif3gjsDJ1W0YVoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5vdX7Th3nXrfFJ/wLikAWyTUnys+RmVPz68miz55BqAMNJo4zEX0Gd5xzXFMn7XR
	 MYE0bXBsmk8a4Iql3wzasU2ud+iGQF5QqMOV36dM3rkkC5FIWS3eZEEqo1Bw6DA32p
	 TpOKKVwGDcKFLL9wI7d3CMte43cJS3WA2HxaYaVzxcb0IDyj5CIXSBW1k8dszWjIp/
	 M+hn2Yu1Lm8CVEapD4E2w64+F0SgumxfBFBqlSmE4r1oq4e2SfvexrmMYMOPy3U4xv
	 mDckBg8ye/OV1m4ovznXuzSwIT7wI16mqmH3kgzDjjrCsPK9tYM50MuY3S2YC8C9kF
	 oynhgTmeZYJsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-5.15] fs/ntfs3: Support timestamps prior to epoch
Date: Mon,  8 Dec 2025 19:15:25 -0500
Message-ID: <20251209001610.611575-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 5180138604323895b5c291eca6aa7c20be494ade ]

Before it used an unsigned 64-bit type, which prevented proper handling
of timestamps earlier than 1970-01-01. Switch to a signed 64-bit type to
support pre-epoch timestamps. The issue was caught by xfstests.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Let me write the detailed analysis:

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `fs/ntfs3: Support timestamps prior to epoch`

**Commit Body:**
- The commit explains that before this fix, the code used an **unsigned
  64-bit type** (`u64`), which prevented proper handling of timestamps
  earlier than 1970-01-01 (the Unix epoch).
- The fix switches to a **signed 64-bit type** (`s64`) to support pre-
  epoch timestamps.
- The issue was caught by **xfstests test 258**, which specifically
  tests for timestamps prior to the epoch.

**Tags:**
- **No `Cc: stable@vger.kernel.org` tag** is present.
- **No `Fixes:` tag** is present.

### 2. CODE CHANGE ANALYSIS

#### The Bug:

In the current code (before the patch):

```980:987:fs/ntfs3/ntfs_fs.h
static inline void nt2kernel(const __le64 tm, struct timespec64 *ts)
{
        u64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;

        // WARNING: do_div changes its first argument(!)
        ts->tv_nsec = do_div(t, _100ns2seconds) * 100;
        ts->tv_sec = t;
}
```

The variable `t` is declared as `u64` (unsigned 64-bit integer). NTFS
timestamps are stored as the number of 100-nanosecond intervals since
January 1, 1601. After subtracting `SecondsToStartOf1970`
(0x00000002B6109100), which represents the number of seconds between
1601 and 1970, `t` represents a Unix timestamp.

**Problem:** When the NTFS timestamp represents a date before January 1,
1970, the subtraction produces a **negative** result. But since `t` is
unsigned (`u64`), the negative value wraps around to a very large
positive value, resulting in a wrong (future) timestamp.

**The `do_div` macro** operates on unsigned integers and uses unsigned
division, which doesn't handle negative values correctly.

#### The Fix:

The patch changes:
1. `u64 t` → `s64 t` (signed 64-bit integer)
2. `do_div(t, _100ns2seconds)` → `div_s64_rem(t, _100ns2seconds, &t32)`
   (signed division)
3. Introduces `s32 t32` to hold the remainder

The new code:
```c
static inline void nt2kernel(const __le64 tm, struct timespec64 *ts)
{
        s32 t32;
        /* use signed 64 bit to support timestamps prior to epoch.
xfstest 258. */
        s64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;

        ts->tv_sec = div_s64_rem(t, _100ns2seconds, &t32);
        ts->tv_nsec = t32 * 100;
}
```

`div_s64_rem()` is designed for signed 64-bit division with a 32-bit
divisor, properly handling negative values and returning the remainder
through a pointer.

**Root Cause:** Using unsigned arithmetic for a value that can be
negative (pre-epoch timestamps).

### 3. CLASSIFICATION

- **Bug fix:** YES - This is fixing incorrect behavior with timestamps
  before 1970.
- **New feature:** NO - It doesn't add new functionality, only fixes
  existing functionality.
- **Security fix:** NO - No security implications.
- **Exception category:** NO - Not a device ID, quirk, DT update, build
  fix, or documentation fix.

### 4. SCOPE AND RISK ASSESSMENT

**Lines Changed:** Very minimal - changes ~8 lines of code within a
single inline function.

**Files Touched:** 1 file (`fs/ntfs3/ntfs_fs.h`)

**Subsystem Complexity:**
- NTFS3 is a relatively new filesystem (added in 5.15)
- The change is in a core time conversion function `nt2kernel()` that is
  called whenever reading timestamps from disk
- All file timestamps (creation, modification, access times) use this
  function

**Risk Assessment:**
- **LOW RISK** - The change is small, surgical, and uses a well-
  established kernel API (`div_s64_rem`)
- The new code is mathematically equivalent to the old code for
  timestamps after 1970
- For timestamps before 1970, the new code produces correct results
  (negative `tv_sec` values)
- The `timespec64` structure's `tv_sec` field is `time64_t` which is
  signed (`__s64`), so it can properly represent negative timestamps

### 5. USER IMPACT

**Who is affected?**
- Users of NTFS3 filesystem
- Users with NTFS volumes containing files with pre-1970 timestamps

**How severe?**
- The bug causes **data corruption** (incorrect timestamp
  display/storage) for pre-epoch files
- Without this fix, timestamps like January 1, 1960 would appear as some
  date far in the future
- This breaks file management tools and any software relying on correct
  timestamps

**Test Coverage:**
- The fix was identified by **xfstests generic/258**, a standard
  filesystem test that specifically validates pre-epoch timestamp
  handling
- This is a well-known and commonly run test suite

### 6. STABILITY INDICATORS

- **No `Tested-by:` tag** - However, xfstests is mentioned, implying the
  fix was tested against this test suite
- **No `Reviewed-by:` tag**
- The commit is from the ntfs3 maintainer (Konstantin Komarov from
  Paragon Software)

### 7. DEPENDENCY CHECK

- **No dependencies** - This is a standalone fix
- Uses existing kernel APIs (`div_s64_rem`, `s64`, `s32`) that have been
  available for a long time
- The affected code (`nt2kernel` function) has existed since ntfs3 was
  introduced in kernel 5.15

### Summary

**YES signals:**
1. ✅ Fixes a **real bug** (incorrect timestamps for pre-epoch dates)
2. ✅ **Small and surgical** change - only 8 lines changed in one
   function
3. ✅ **Obviously correct** - uses proper signed arithmetic for values
   that can be negative
4. ✅ No new features, no new APIs
5. ✅ Caught by **xfstests**, a standard fs test suite (test 258)
6. ✅ Applies to all stable kernels that have ntfs3 (5.15+)
7. ✅ Zero risk of regression for post-epoch timestamps (mathematically
   equivalent)
8. ✅ Fixes **data integrity issue** (timestamp corruption)

**NO signals:**
1. ⚠️ No explicit `Cc: stable@vger.kernel.org` tag
2. ⚠️ No `Fixes:` tag
3. ⚠️ No `Tested-by:` or `Reviewed-by:` tags

**Verdict:**

This is a clear bug fix that addresses a real issue (incorrect pre-epoch
timestamp handling) that affects NTFS3 users. The fix is small,
surgical, uses well-tested kernel APIs, and is mathematically correct.
While the commit lacks stable tags, the nature of the fix - correcting
data integrity issues with timestamps - makes it appropriate for
backporting. The bug has existed since ntfs3 was introduced (5.15), so
all stable trees with ntfs3 would benefit from this fix.

The lack of `Cc: stable` tag is likely an oversight since the fix
clearly meets stable kernel criteria: it's a bug fix, small in scope,
obviously correct, and fixes a real user-visible issue (incorrect file
timestamps).

**YES**

 fs/ntfs3/ntfs_fs.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 630128716ea73..2649fbe16669d 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -979,11 +979,12 @@ static inline __le64 kernel2nt(const struct timespec64 *ts)
  */
 static inline void nt2kernel(const __le64 tm, struct timespec64 *ts)
 {
-	u64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;
+	s32 t32;
+	/* use signed 64 bit to support timestamps prior to epoch. xfstest 258. */
+	s64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;
 
-	// WARNING: do_div changes its first argument(!)
-	ts->tv_nsec = do_div(t, _100ns2seconds) * 100;
-	ts->tv_sec = t;
+	ts->tv_sec = div_s64_rem(t, _100ns2seconds, &t32);
+	ts->tv_nsec = t32 * 100;
 }
 
 static inline struct ntfs_sb_info *ntfs_sb(struct super_block *sb)
-- 
2.51.0

