Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E77431282F;
	Tue, 10 Feb 2026 23:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766308; cv=none; b=b5grRX7d9IMRvKwzKf7jZZw//EmeMwqIzV5SVaZ2EqMBmR3T+E9V3KrLpUCUAZOi/U4b5Cgf2Y3jls6ozghLi5VE7R0PNEGv4cvCCWbKSkOMDRUDFLOtwgCdCKIw4yiAAXRpjRKKX/LJPGr4fvw/vYtDZh0XcbjCCCBEbeHhPTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766308; c=relaxed/simple;
	bh=w8vP2q0rvyREAlNGeuGRnI2tnurQEkz6cx0XcZRcUEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNGeXJgcGWcGNC1O68x3s21Ogv5VsZyVVY6vSS4sRYWO7BtAYr9HJG6Jkkiplo8UgGytUSwWH+Uw4AsaraZTFgufzfcO5ubia4LXHagz83MOR2JwtZn4ac1c5IlSvOnRbHcT0PPVfZmkdU/SZcXpv5pIUoUKvepJwPIaiCu6q7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HD7S7FXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HD7S7FXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E633C116C6;
	Tue, 10 Feb 2026 23:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766308;
	bh=w8vP2q0rvyREAlNGeuGRnI2tnurQEkz6cx0XcZRcUEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD7S7FXPISVjiI0kgl/Zzbd0266DaRT+tMqzcfMkVklGxuouBbd3zLM+x+n7+HL0X
	 12i5CBTPd5W3vbWD6WavJ3wHovVkeOVC+wpDRhszNBGSbNLe5Opmkm+BqVJ8mGBiI0
	 kU+AtZDI3g23iqCiwc8XWMxnFlsWUCIAhTvQSsbmzk+PQVvv47r9Ey4iDilA4s8PEn
	 8d/UYvLBus6x7CNdBjKl5kX3tcK2mVWpMfS9GlTNyzUl2M8KATll56qdfS4DcDMSDw
	 exy8Och43mkuMiZ8bGcWJsGxHTTmphrk2g+jv7W9UTAwxTPfAaI/96aZiSMy5xXK7J
	 e2sFksGhcQz5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Frank Li <Frank.Li@nxp.com>,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	miquel.raynal@bootlin.com,
	linux-i3c@lists.infradead.org,
	imx@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-5.15] i3c: master: svc: Initialize 'dev' to NULL in svc_i3c_master_ibi_isr()
Date: Tue, 10 Feb 2026 18:31:00 -0500
Message-ID: <20260210233123.2905307-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 3c9ffb4db787428a5851d5865823ab23842d5103 ]

Initialize the 'dev' pointer to NULL in svc_i3c_master_ibi_isr() and add
a NULL check in the error path.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202512131016.YCKIsDXM-lkp@intel.com/
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251215200852.3079073-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here's my complete analysis:

## Detailed Analysis

### 1. Bug Mechanism

The function `svc_i3c_master_ibi_isr()` declares `struct i3c_dev_desc
*dev;` without initialization (line 537). The variable `dev` is **only
assigned** inside the `SVC_I3C_MSTATUS_IBITYPE_IBI` case of the switch
statement (line 600). For the other three cases — `HOT_JOIN`,
`MASTER_REQUEST`, and `default` — `dev` is **never assigned** and
remains an uninitialized stack pointer containing garbage.

After the switch, the error path at line 629-635 checks:
```c
if (svc_i3c_master_error(master)) {
    if (master->ibi.tbq_slot) {
        data = i3c_dev_get_master_data(dev);  // BUG: dev could be
uninitialized
```

`i3c_dev_get_master_data()` directly dereferences
`dev->common.master_priv` (in `include/linux/i3c/master.h:624-627`). If
`dev` is uninitialized garbage, this dereference causes **undefined
behavior** — most likely a kernel crash/oops, or worse, access to random
memory (potential security issue).

### 2. Practical Reachability

In the **current code**, `master->ibi.tbq_slot` is only set non-NULL by
`svc_i3c_master_handle_ibi()` (line 476), which is only called in the
`IBI` case where `dev` IS assigned. So in normal flow, if `tbq_slot` is
non-NULL in this invocation, `dev` should be valid.

**However, there are scenarios where the bug can trigger:**

- If `tbq_slot` was left non-NULL from a **previous invocation** due to
  a code path that failed to clean it up (a secondary bug). Then on the
  next ISR entry with a different `ibitype` (e.g., HOT_JOIN), `dev`
  would be uninitialized while `tbq_slot` is non-NULL.
- The code is **fragile** — any future change that sets `tbq_slot` in a
  different path would immediately make this crash reachable.

Notably, the "non critical tasks" section at line 646 **already has**
`if (dev)` guard, indicating the author of that code recognized `dev`
might not be valid. The error path at line 630 lacked this same
protection — an inconsistency.

### 3. Reporter and Detection

Reported by `kernel test robot <lkp@intel.com>` — Intel's automated
kernel testing infrastructure that runs static analysis tools (Smatch,
sparse, compiler warnings). The `Closes:` link to an lkp report confirms
this is a compiler/static-analyzer warning about use of an uninitialized
variable. These reports identify real code defects.

### 4. Fix Assessment

The fix is minimal and obviously correct:
1. **Initialize `dev` to NULL** (line change: `struct i3c_dev_desc
   *dev;` → `struct i3c_dev_desc *dev = NULL;`)
2. **Add NULL check in error path** (line change: `if
   (master->ibi.tbq_slot)` → `if (master->ibi.tbq_slot && dev)`)

This makes the error path consistent with the "non critical tasks" path
that already checks `if (dev)` at line 646.

### 5. Scope and Risk

- **Lines changed:** 2 (trivially small)
- **Files touched:** 1 (`drivers/i3c/master/svc-i3c-master.c`)
- **Risk of regression:** Zero — this only ADDS safety checks
- **No behavioral change** in the happy path (when `dev` is valid)
- The fix is **defense-in-depth** — prevents a crash if the guard
  condition `tbq_slot != NULL` is ever true when `dev` wasn't set

### 6. Stable Tree Applicability

The original driver was added in v5.12 (`dd3c52846d59`). The error path
with the uninitialized `dev` has existed since the driver's creation.
The exact code shape changed in:
- `8d29fa6d921ca` (6.17 cycle) — moved from workqueue to ISR context
- `a7869b0a2540f` (6.18 cycle) — manual IBI response

For older stable trees, the fix would need to target the
`svc_i3c_master_ibi_work()` function instead of
`svc_i3c_master_ibi_isr()`, but the same pattern applies.

### 7. Classification

This is an **uninitialized variable fix** — one of the recognized bug
categories for stable backports. It prevents:
- Potential **kernel crash** from dereferencing garbage pointer
- Potential **security vulnerability** (accessing uncontrolled memory)
- **Compiler warnings** that pollute build output

### Conclusion

This commit fixes a real uninitialized variable issue detected by static
analysis. The fix is trivially small (2 lines), obviously correct, zero
risk of regression, and prevents a potential kernel crash/oops if the
error path is reached with `dev` uninitialized. It aligns the error
path's safety checks with those already present in the non-critical task
handling path. It meets all stable kernel criteria: fixes a real bug, is
small and contained, obviously correct, and introduces no new features.

**YES**

 drivers/i3c/master/svc-i3c-master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index a62f22ff8b576..857504d36e186 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -533,8 +533,8 @@ static int svc_i3c_master_handle_ibi_won(struct svc_i3c_master *master, u32 msta
 static void svc_i3c_master_ibi_isr(struct svc_i3c_master *master)
 {
 	struct svc_i3c_i2c_dev_data *data;
+	struct i3c_dev_desc *dev = NULL;
 	unsigned int ibitype, ibiaddr;
-	struct i3c_dev_desc *dev;
 	u32 status, val;
 	int ret;
 
@@ -627,7 +627,7 @@ static void svc_i3c_master_ibi_isr(struct svc_i3c_master *master)
 	 * for the slave to interrupt again.
 	 */
 	if (svc_i3c_master_error(master)) {
-		if (master->ibi.tbq_slot) {
+		if (master->ibi.tbq_slot && dev) {
 			data = i3c_dev_get_master_data(dev);
 			i3c_generic_ibi_recycle_slot(data->ibi_pool,
 						     master->ibi.tbq_slot);
-- 
2.51.0

