Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D73F86EF;
	Wed, 20 May 2026 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276062; cv=none; b=ONn4i+31Jwe5e89dbuyVAmgKBrsZcy91WOSZMZ+gRJgiAXtoxAvdXNcdm2HhuP6KuSxJSd6hf3J4JjYmttFmA9m8d2IkU52wgB5ZAl8qA/SFYT6nm5YwFnuBjBnXZEVlzQm7MZbL8hSNcfwMAfjjRcxjJZUBOfnVaiAgaF/3oG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276062; c=relaxed/simple;
	bh=q6eOR/vT0ruqLc4hKC0zEPDh3Q6xaUvvH3Ag+Rm9p30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wws+jXxt7T3JdWTansjQ9u6c/Mrq47dDfj90NXr5Qi6p9B6la3GLs7OWqmP0WhTayXq0eqzIeY/Kh3olvs6HOwCQNn9JciOK9u36r3+BF1IdF/DvP7kPr7tbz2c7nqURsNHjX70439/rHCcXqFu3f78PV/4CZFKQqWVcenLJM+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8kAzGAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8kAzGAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94C61F00897;
	Wed, 20 May 2026 11:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276058;
	bh=4E4m0krrTAOPHzvgF8sRUKe90FnIaCW88Ns6rN2/13c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8kAzGAZezew7YqU1jAiuwjlJ7LYpDvl5E1RVUzBPu1MGtghsSRP0Ede8pQIZyV/N
	 cdY0wkSpm4YxjWtx+rt6KeOEc8sn2C+7ayVwKExsC1arS8NAO8cKdyMfKaVPeIOnaU
	 RCZiAMBSwEwjyLNZlqikzHZbRNLM8Wsj962Q0e3DWJSt2Ugo9i3ZOLx3a4/VQ+tPsC
	 RBuKB/ZEGiCzm+k0tkn4aTlN40/AIn3HsV6gHCUkfrwS7zJLNe60IQtupPhrQz8r5E
	 c30KFDvbO9cU2ClQ7YRxopIH0CVpeA9U/UtAKNuqxzjQneIVwC1IOvZM6X/89PKYMy
	 rXvJ8yNe4pdtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Athira Rajeev <atrajeev@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] powerpc/pseries/htmdump: Free the global buffers in htmdump module exit
Date: Wed, 20 May 2026 07:19:24 -0400
Message-ID: <20260520111944.3424570-52-sashal@kernel.org>
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

From: Athira Rajeev <atrajeev@linux.ibm.com>

[ Upstream commit 54d54f33813d7911555226b4220737177a2ba8d6 ]

htmdump modules uses global memory buffers to capture
details like capabilities, status of specified HTM, read the
trace buffer. These are initialized during module init and
hence needs to be freed in module exit.

Patch adds freeing of the memory in module exit. The change
also includes minor clean up for the variable name. The
read call back for the debugfs interface file saves filp->private_data
to local variable name which is same as global variable
name for the memory buffers. Rename these local variable
names.

Signed-off-by: Athira Rajeev <atrajeev@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260314132432.25581-1-atrajeev@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary
This commit fixes a real resource leak in
`arch/powerpc/platforms/pseries/htmdump.c`: `htm_status_buf`,
`htm_info_buf`, and `htm_caps_buf` are each allocated with
`kmalloc(PAGE_SIZE, GFP_KERNEL)` during module/debugfs initialization,
but only `htm_buf` is freed in `htmdump_exit()`. The patch adds the
three missing `kfree()` calls. The local-variable renames are cleanup
and are also used by the following two patches in the same posted
series.

The benefit is modest because the leak is on module unload, not a hot
path, and the feature is PowerPC pseries/debugfs-specific. But it is a
real leak in a `default m` module, the fix is trivial, isolated, and low
risk. For stable trees that contain the v6.16-era `htmstatus`,
`htminfo`, and `htmcaps` additions, this is suitable.

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Record 1.1: Subsystem is `powerpc/pseries/htmdump`; action verb is
`Free`; claimed intent is freeing global HTM debugfs buffers during
module exit.

Record 1.2: Tags in the supplied commit message: `Signed-off-by: Athira
Rajeev <atrajeev@linux.ibm.com>`, `Signed-off-by: Madhavan Srinivasan
<maddy@linux.ibm.com>`, `Link:
https://patch.msgid.link/20260314132432.25581-1-atrajeev@linux.ibm.com`.
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
or `Cc: stable@vger.kernel.org` tag was present in this commit.

Record 1.3: The body describes global memory buffers initialized in
module init and not freed in module exit. The user-visible symptom is
unreclaimed kernel memory after unloading the module. No crash, stack
trace, reporter, affected-version statement, or reproducer is given.

Record 1.4: This is a hidden cleanup-style bug fix: the functional
change is missing resource release on module exit.

### Phase 2: Diff Analysis
Record 2.1: One file changed:
`arch/powerpc/platforms/pseries/htmdump.c`, 17 insertions and 14
deletions in the posted patch. Modified functions are `htmdump_read()`,
`htmstatus_read()`, `htminfo_read()`, `htmcaps_read()`, and
`htmdump_exit()`. Scope is single-file surgical.

Record 2.2: The read-callback hunks rename local variables from names
shadowing globals to `*_data`; behavior is unchanged. The exit hunk
changes `htmdump_exit()` from freeing only `htm_buf` to freeing
`htm_buf`, `htm_status_buf`, `htm_info_buf`, and `htm_caps_buf`.

Record 2.3: Bug category is resource leak. Verified allocations are
three `PAGE_SIZE` buffers for status/info/caps in
`htmdump_init_debugfs()` without corresponding frees before this patch.

Record 2.4: Fix quality is high: `kfree(NULL)` is safe, the buffers are
global module-owned allocations, and debugfs removal already happens
before freeing. Regression risk is very low. The only non-functional
churn is local-variable rename.

### Phase 3: Git History Investigation
Record 3.1: `git blame` on the current stable checkout points the
relevant lines at the repository boundary merge `f3f5edc5e41e0`, so I
followed explicit commit objects. `htm_status_buf` was added by
`627cf584f4c3`, `htm_info_buf` by `dea7384e14e7`, and `htm_caps_buf` by
`143a2584627c`, all described by `git describe --contains`/history as
v6.16-rc1-era commits.

Record 3.2: Candidate has no `Fixes:` tag, so no direct Fixes target
applies. Related series patches 2/3 and 3/3 have `Fixes:` tags for
`dea7384e14e7` and `627cf584f4c3`, but this patch does not depend on
those fixes.

Record 3.3: Recent `htmdump` history shows the v6.16 additions for
status/info/setup/flags/caps and a header include fix. The candidate is
patch 1/3 in a series; patch 1 is standalone, while patches 2/3 and 3/3
textually build on its variable renames.

Record 3.4: Author Athira Rajeev authored the original htmdump expansion
commits; Madhavan Srinivasan committed them. This was verified from `git
show` for the status/info/caps commits.

Record 3.5: No prerequisite is needed for patch 1 beyond the buffers
existing. An isolated `git apply --check` of patch 1 succeeds on the
current 7.0 stable checkout.

### Phase 4: Mailing List And External Research
Record 4.1: `b4 dig` could not be meaningfully run because the candidate
commit object/hash is not present in the checked-out refs; `b4 dig -h`
confirmed it requires `-c <commitish>`. I used `b4 mbox -c` with
message-id `20260314132432.25581-1-atrajeev@linux.ibm.com`; it fetched a
3-message thread and reported no newer revision.

Record 4.2: Original recipients from the mbox were
`maddy@linux.ibm.com`, `linuxppc-dev@lists.ozlabs.org`, and CCs
including `hbathini`, `sshegde`, and IBM HTM-related recipients. No
review replies, NAKs, or stable nominations were present in the fetched
mbox.

Record 4.3: No `Reported-by` or bug-report link exists for this
candidate. `WebFetch` to lore/patch.msgid was blocked by Anubis, but `b4
mbox` successfully fetched the thread.

Record 4.4: The patch is part of a 3-patch series. Patch 1 fixes exit
cleanup; patch 2 fixes `htminfo_read()` offset handling; patch 3 fixes
`htmstatus_read()` offset handling. Patch 1 can apply standalone, and
later patches depend textually on its renames.

Record 4.5: Stable-specific lore WebFetch was blocked by Anubis.
WebSearch for the exact subject and stable context found no specific
stable discussion. Local `git log --grep` checks of `v6.18`, `v6.19`,
`v7.0`, and `linux-rolling-stable` found no exact-subject match.

### Phase 5: Code Semantic Analysis
Record 5.1: Modified functions are `htmdump_read()`, `htmstatus_read()`,
`htminfo_read()`, `htmcaps_read()`, and `htmdump_exit()`.

Record 5.2: Callers/entry points are verified through file operations
and module macros: `htmdump_exit()` is registered with `module_exit()`,
reads are reached through debugfs files created by
`debugfs_create_file()` with the corresponding fops.

Record 5.3: Key callees are `debugfs_remove_recursive()`, `kfree()`,
`htm_hcall_wrapper()`, `virt_to_phys()`, and
`simple_read_from_buffer()`. The functional fix only adds `kfree()`
calls in exit.

Record 5.4: Reachability is module lifecycle and debugfs based. The leak
triggers on module unload after successful allocation of the
status/info/caps buffers. Unprivileged triggering was not verified and
is not relied on; Kconfig shows `HTMDUMP` is `tristate`, `default m`,
and depends on `PPC_PSERIES && DEBUG_FS`.

Record 5.5: Similar pattern found: `htm_buf` was already freed in
`htmdump_exit()`, while the three later-added global buffers were not.

### Phase 6: Stable Tree Analysis
Record 6.1: `v6.15` has `htmdump.c` with only `htm_buf`; `v6.16`,
`v6.17`, `v6.18`, `v6.19`, and `v7.0` have the three additional buffers
and only free `htm_buf`. So the bug affects stable trees containing the
v6.16 htmdump expansions, not older trees lacking those buffers.

Record 6.2: Backport difficulty is low for affected trees. The patch’s
base blob matches `v6.16`/`v6.17`/current 7.0 content for the relevant
file, and isolated patch 1 applies cleanly to the current checkout.

Record 6.3: No exact-subject related fix was found in checked `v6.18`,
`v6.19`, `v7.0`, or `linux-rolling-stable`.

### Phase 7: Subsystem And Maintainer Context
Record 7.1: Subsystem is PowerPC pseries platform driver/debugfs
support. Criticality is peripheral/platform-specific, not core kernel-
wide.

Record 7.2: `git log -20 v7.0 -- arch/powerpc/platforms/pseries` shows
active pseries development, but this particular fix is contained to
`htmdump.c`.

### Phase 8: Impact And Risk
Record 8.1: Affected users are PowerPC pseries users with
`CONFIG_HTMDUMP` enabled, primarily using the debugfs HTM dump module.

Record 8.2: Trigger is successful module initialization followed by
module exit/unload. Repeated load/unload can accumulate unreclaimed
pages until reboot. This is not verified as unprivileged-triggerable.

Record 8.3: Failure mode is kernel memory/resource leak, three
`PAGE_SIZE` allocations per unload for the later buffers. Severity is
medium: real and persistent until reboot, but not a crash/security/data-
corruption fix and not a hot path.

Record 8.4: Benefit is moderate for affected stable users; risk is very
low because the functional change is only three `kfree()` calls after
debugfs removal.

### Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: real resource leak, affects stable
trees v6.16 and newer that contain the expanded htmdump module, fix is
tiny and obviously correct, isolated patch applies cleanly. Evidence
against: peripheral platform-specific module, leak occurs on module
unload rather than common runtime path, no reporter/testing/stable tags
in this patch. Unresolved: no full lore review discussion was available
beyond the 3-patch mbox; direct WebFetch lore pages were blocked.

Record 9.2: Stable rules checklist: obviously correct yes; fixes a real
bug yes; important enough is borderline but acceptable as a real
resource leak with very low regression risk; small and contained yes; no
new feature/API yes; applies to affected stable trees yes for current
7.0 and likely cleanly where file matches v6.16+.

Record 9.3: No automatic exception category applies: this is not a
device ID, quirk, DT update, build fix, or documentation-only fix.

Record 9.4: Decision is YES for stable trees that contain
`htm_status_buf`, `htm_info_buf`, and `htm_caps_buf`.

## Verification
- Phase 1: Parsed supplied commit message and b4-fetched patch 1;
  confirmed no `Fixes:`, `Reported-by`, `Tested-by`, review, or stable
  tag in patch 1.
- Phase 2: Read `arch/powerpc/platforms/pseries/htmdump.c`; confirmed
  allocations and missing frees; inspected patch hunks from
  `/tmp/htmdump-20260314.mbx`.
- Phase 3: Ran `git blame -L 410,485`; followed explicit commits
  `627cf584f4c3`, `dea7384e14e7`, and `143a2584627c` with `git show`;
  checked author/subsystem history.
- Phase 4: `b4 mbox -c` fetched the 3-message thread; direct `WebFetch`
  lore URLs were blocked; WebSearch found no exact stable discussion.
- Phase 5: Used `rg`, `ReadFile`, and Kconfig/Makefile/docs to verify
  module/debugfs reachability and `CONFIG_HTMDUMP` as `tristate`,
  `default m`.
- Phase 6: Checked `v6.15`, `v6.16`, `v6.17`, `v6.18`, `v6.19`, and
  `v7.0` file contents; isolated patch 1 passed `git apply --check`.
- Phase 8: Verified failure mode from concrete `kmalloc(PAGE_SIZE)`
  allocations and missing matching `kfree()` calls.
- Unverified: whether every downstream stable branch has identical
  context; direct stable-list lore search was blocked by Anubis.

**YES**

 arch/powerpc/platforms/pseries/htmdump.c | 31 +++++++++++++-----------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/htmdump.c b/arch/powerpc/platforms/pseries/htmdump.c
index 742ec52c9d4df..93f0cc2dc7fb6 100644
--- a/arch/powerpc/platforms/pseries/htmdump.c
+++ b/arch/powerpc/platforms/pseries/htmdump.c
@@ -86,7 +86,7 @@ static ssize_t htm_return_check(long rc)
 static ssize_t htmdump_read(struct file *filp, char __user *ubuf,
 			     size_t count, loff_t *ppos)
 {
-	void *htm_buf = filp->private_data;
+	void *htm_buf_data = filp->private_data;
 	unsigned long page, read_size, available;
 	loff_t offset;
 	long rc, ret;
@@ -100,7 +100,7 @@ static ssize_t htmdump_read(struct file *filp, char __user *ubuf,
 	 * - last three values are address, size and offset
 	 */
 	rc = htm_hcall_wrapper(htmflags, nodeindex, nodalchipindex, coreindexonchip,
-				   htmtype, H_HTM_OP_DUMP_DATA, virt_to_phys(htm_buf),
+				   htmtype, H_HTM_OP_DUMP_DATA, virt_to_phys(htm_buf_data),
 				   PAGE_SIZE, page);
 
 	ret = htm_return_check(rc);
@@ -112,7 +112,7 @@ static ssize_t htmdump_read(struct file *filp, char __user *ubuf,
 	available = PAGE_SIZE;
 	read_size = min(count, available);
 	*ppos += read_size;
-	return simple_read_from_buffer(ubuf, count, &offset, htm_buf, available);
+	return simple_read_from_buffer(ubuf, count, &offset, htm_buf_data, available);
 }
 
 static const struct file_operations htmdump_fops = {
@@ -226,7 +226,7 @@ static int htmstart_get(void *data, u64 *val)
 static ssize_t htmstatus_read(struct file *filp, char __user *ubuf,
 			     size_t count, loff_t *ppos)
 {
-	void *htm_status_buf = filp->private_data;
+	void *htm_status_data = filp->private_data;
 	long rc, ret;
 	u64 *num_entries;
 	u64 to_copy;
@@ -238,7 +238,7 @@ static ssize_t htmstatus_read(struct file *filp, char __user *ubuf,
 	 * - last three values as addr, size and offset
 	 */
 	rc = htm_hcall_wrapper(htmflags, nodeindex, nodalchipindex, coreindexonchip,
-				   htmtype, H_HTM_OP_STATUS, virt_to_phys(htm_status_buf),
+				   htmtype, H_HTM_OP_STATUS, virt_to_phys(htm_status_data),
 				   PAGE_SIZE, 0);
 
 	ret = htm_return_check(rc);
@@ -255,13 +255,13 @@ static ssize_t htmstatus_read(struct file *filp, char __user *ubuf,
 	 * So total count to copy is:
 	 * 32 bytes (for first 7 fields) + (number of HTM entries * entry size)
 	 */
-	num_entries = htm_status_buf + 0x10;
+	num_entries = htm_status_data + 0x10;
 	if (htmtype == 0x2)
 		htmstatus_flag = 0x8;
 	else
 		htmstatus_flag = 0x6;
 	to_copy = 32 + (be64_to_cpu(*num_entries) * htmstatus_flag);
-	return simple_read_from_buffer(ubuf, count, ppos, htm_status_buf, to_copy);
+	return simple_read_from_buffer(ubuf, count, ppos, htm_status_data, to_copy);
 }
 
 static const struct file_operations htmstatus_fops = {
@@ -273,7 +273,7 @@ static const struct file_operations htmstatus_fops = {
 static ssize_t htminfo_read(struct file *filp, char __user *ubuf,
 			     size_t count, loff_t *ppos)
 {
-	void *htm_info_buf = filp->private_data;
+	void *htm_info_data = filp->private_data;
 	long rc, ret;
 	u64 *num_entries;
 	u64 to_copy;
@@ -284,7 +284,7 @@ static ssize_t htminfo_read(struct file *filp, char __user *ubuf,
 	 * - last three values as addr, size and offset
 	 */
 	rc = htm_hcall_wrapper(htmflags, nodeindex, nodalchipindex, coreindexonchip,
-				   htmtype, H_HTM_OP_DUMP_SYSPROC_CONF, virt_to_phys(htm_info_buf),
+				   htmtype, H_HTM_OP_DUMP_SYSPROC_CONF, virt_to_phys(htm_info_data),
 				   PAGE_SIZE, 0);
 
 	ret = htm_return_check(rc);
@@ -301,15 +301,15 @@ static ssize_t htminfo_read(struct file *filp, char __user *ubuf,
 	 * So total count to copy is:
 	 * 32 bytes (for first 5 fields) + (number of HTM entries * entry size)
 	 */
-	num_entries = htm_info_buf + 0x10;
+	num_entries = htm_info_data + 0x10;
 	to_copy = 32 + (be64_to_cpu(*num_entries) * 16);
-	return simple_read_from_buffer(ubuf, count, ppos, htm_info_buf, to_copy);
+	return simple_read_from_buffer(ubuf, count, ppos, htm_info_data, to_copy);
 }
 
 static ssize_t htmcaps_read(struct file *filp, char __user *ubuf,
 			     size_t count, loff_t *ppos)
 {
-	void *htm_caps_buf = filp->private_data;
+	void *htm_caps_data = filp->private_data;
 	long rc, ret;
 
 	/*
@@ -319,7 +319,7 @@ static ssize_t htmcaps_read(struct file *filp, char __user *ubuf,
 	 *   and zero
 	 */
 	rc = htm_hcall_wrapper(htmflags, nodeindex, nodalchipindex, coreindexonchip,
-				   htmtype, H_HTM_OP_CAPABILITIES, virt_to_phys(htm_caps_buf),
+				   htmtype, H_HTM_OP_CAPABILITIES, virt_to_phys(htm_caps_data),
 				   0x80, 0);
 
 	ret = htm_return_check(rc);
@@ -328,7 +328,7 @@ static ssize_t htmcaps_read(struct file *filp, char __user *ubuf,
 		return ret;
 	}
 
-	return simple_read_from_buffer(ubuf, count, ppos, htm_caps_buf, 0x80);
+	return simple_read_from_buffer(ubuf, count, ppos, htm_caps_data, 0x80);
 }
 
 static const struct file_operations htminfo_fops = {
@@ -482,6 +482,9 @@ static void __exit htmdump_exit(void)
 {
 	debugfs_remove_recursive(htmdump_debugfs_dir);
 	kfree(htm_buf);
+	kfree(htm_status_buf);
+	kfree(htm_info_buf);
+	kfree(htm_caps_buf);
 }
 
 module_init(htmdump_init);
-- 
2.53.0

