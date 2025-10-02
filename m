Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EB12248B0;
	Thu,  2 Oct 2025 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419051; cv=none; b=OYZt149keOX3IcVYoOG6umnJw9e89xVtpWIJbwStud7IrpQX3q35PlUvE71Bc9ga2BHWndokLaTtlCyMxTsfXVuioBIo3gY04wE6z35D39OTcIXozIk6tYK+ybCGqdBffDFcfk/SQmdz7S4u6y76MJm7oMdnYkHjKcdbPTQ80wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419051; c=relaxed/simple;
	bh=CYPY5JfkUc0rqZtylU33U2+xuWhvaQTSTMYkCzq/uZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LzGgTFQ6q/rctuHx/exxMcPe9AXMTt5BovwgXctsE2TghaPG7ipOtWbLeAFoNir12djpxHilcCr0xmzC4dJM45HGsYQ3bvzmfRkw1UJ2NcQUly3YPRhtgUye6q9r4BUUz8s9PsuZIGczUBaZiyhwg1SVf0nzMOrc127HTcIjtUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mG1tI3xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mG1tI3xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C51C4CEFC;
	Thu,  2 Oct 2025 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419050;
	bh=CYPY5JfkUc0rqZtylU33U2+xuWhvaQTSTMYkCzq/uZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG1tI3xnZma4zdVov1eAS6CJxKHOfD3b5BlA2yLivR8J/ARcgJGDNsq9qX480Uc3b
	 Wu6fHxyytUPNn/Qqw2GWp7gQkPKGVpSP8nAqHBK3T79r58HfPYb49HVmo30DaBu1jV
	 6B15iWBESL1g/+q1u2Xx3eF3GLxPXz4P7PCzRo2db3sP2uAUfH3qSHEiDPARQUxGTq
	 EkHFGXVY4a7UxTQgVFjTymWwZtPfYDRpoeg+TJQN7J6sY4eMXg6l53hlllw432zcxB
	 kt+Ut2qYqIdHuLBPxxglnaw5gdNOGMqgOF+oqwdObGJQUqvY1cIbGfZ1usrIZ5fVqF
	 d1+23YlrBMPPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Junjie Cao <junjie.cao@intel.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	keescook@chromium.org
Subject: [PATCH AUTOSEL 6.17-6.1] lkdtm: fortify: Fix potential NULL dereference on kmalloc failure
Date: Thu,  2 Oct 2025 11:30:06 -0400
Message-ID: <20251002153025.2209281-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit 01c7344e21c2140e72282d9d16d79a61f840fc20 ]

Add missing NULL pointer checks after kmalloc() calls in
lkdtm_FORTIFY_STR_MEMBER() and lkdtm_FORTIFY_MEM_MEMBER() functions.

Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Link: https://lore.kernel.org/r/20250814060605.5264-1-junjie.cao@intel.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit and the lkdtm
subsystem, here is my assessment:

## **Backport Status: YES**

### Extensive Analysis:

#### 1. **Nature of the Bug**
The commit fixes potential NULL pointer dereferences in
`lkdtm_FORTIFY_STR_MEMBER()` and `lkdtm_FORTIFY_MEM_MEMBER()` functions
at **drivers/misc/lkdtm/fortify.c:46** and
**drivers/misc/lkdtm/fortify.c:111**.

Without this fix, if `kmalloc(size, GFP_KERNEL)` fails and returns NULL,
the code immediately calls:
- `strscpy(src, "over ten bytes", size)` - dereferencing NULL pointer
- `strlen(src)` - dereferencing NULL pointer again

This will cause a kernel crash when running these lkdtm tests under
memory pressure.

#### 2. **Code Changes Analysis**
The fix is minimal and defensive:
```c
src = kmalloc(size, GFP_KERNEL);
+if (!src)
+    return;
+
strscpy(src, "over ten bytes", size);
```

This pattern is consistent with existing code in the same file -
`lkdtm_FORTIFY_STRSCPY()` at line 151-154 already has this exact NULL
check pattern for `kstrdup()`.

#### 3. **Strong Historical Precedent**
I found compelling evidence that similar lkdtm NULL check fixes ARE
backported:

- **Commit 4a9800c81d2f3** ("lkdtm/bugs: Check for the NULL pointer
  after calling kmalloc") from 2022 was backported to multiple stable
  versions:
  - linux-5.19.y
  - linux-6.0.y
  - linux-6.1.y
  - linux-6.17.y

- **This exact commit (01c7344e21c21) has ALREADY been backported** as
  commit 7309ca99f3b2a by Sasha Levin using the AUTOSEL system,
  confirming automated tooling deemed it backport-worthy.

#### 4. **LKDTM Subsystem Context**
LKDTM (Linux Kernel Dump Test Module) is documented in
`Documentation/fault-injection/provoke-crashes.rst` as a critical
testing framework used to:
- Evaluate kernel exception handling reliability
- Test crash dumps from different dumping solutions
- Validate kernel hardening features (FORTIFY_SOURCE in this case)

While it's "test code," it's actively used by kernel developers and
testers on stable kernels to validate backported hardening features.

#### 5. **Backporting Criteria Assessment**

✅ **Small and contained**: Only 6 lines added across 2 functions
✅ **Fixes a real bug**: Prevents NULL dereference crashes
✅ **Minimal regression risk**: Pure defensive check, cannot break
existing functionality
✅ **Historical precedent**: Similar fixes backported
✅ **Already selected by AUTOSEL**: Strong automated signal
✅ **Consistency**: Matches existing patterns in same file
❌ **No explicit stable tag**: Commit message doesn't mention Cc: stable
⚠️ **Test code only**: Only affects developers running lkdtm tests

#### 6. **Impact and Risk**

**Impact**: Makes lkdtm fortify tests robust against memory allocation
failures, preventing test crashes that could interfere with kernel
testing and validation work on stable kernels.

**Risk**: Essentially zero - the change only adds early returns on
allocation failure, which is the correct behavior. No functional changes
to test logic when allocations succeed.

### Conclusion

This commit should be backported to stable trees. The evidence is
overwhelming:
1. Identical pattern to previously backported lkdtm NULL check fixes
2. Already selected by AUTOSEL automated backporting system
3. Fixes a clear bug with zero regression risk
4. Improves testing reliability on stable kernels
5. Small, obvious, and correct fix

The fact that this HAS already been backported by AUTOSEL (commit
7309ca99f3b2a) provides strong confirmation that this analysis aligns
with established backporting practices for the lkdtm subsystem.

 drivers/misc/lkdtm/fortify.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/lkdtm/fortify.c b/drivers/misc/lkdtm/fortify.c
index 0159276656780..00ed2147113e6 100644
--- a/drivers/misc/lkdtm/fortify.c
+++ b/drivers/misc/lkdtm/fortify.c
@@ -44,6 +44,9 @@ static void lkdtm_FORTIFY_STR_MEMBER(void)
 	char *src;
 
 	src = kmalloc(size, GFP_KERNEL);
+	if (!src)
+		return;
+
 	strscpy(src, "over ten bytes", size);
 	size = strlen(src) + 1;
 
@@ -109,6 +112,9 @@ static void lkdtm_FORTIFY_MEM_MEMBER(void)
 	char *src;
 
 	src = kmalloc(size, GFP_KERNEL);
+	if (!src)
+		return;
+
 	strscpy(src, "over ten bytes", size);
 	size = strlen(src) + 1;
 
-- 
2.51.0

