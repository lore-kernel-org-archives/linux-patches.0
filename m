Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7702EC54C;
	Tue,  5 May 2026 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974736; cv=none; b=t7OWUGoJHryGE/FQ1GZFzWlbfdHVbtmJA5ARonIpnR5G9ue/LYEvV4nqAsnmCK/QIXKRk0nLCPjayrpqHNvFXRQOry5bpqQsNa3xJtEFIUbmpejucgEFnNmFQFPU8ahRz3WaJQQVSWIxk+0BA5bNKYJmxz7PxmBQ0H3+dX6u0Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974736; c=relaxed/simple;
	bh=BTGhpdelrcdclE2S6o5MWzcjZDamk+MFHC82dtlZLAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P5CBZDUbeZ8Og6juSOfA/WcADQMInNTnaJGlsT5Kp2db7aJQzNTn2XgV5KqqvOKsG2M02h+jy7VYbNAxweVaAP6E7R25Fr5p+vpOzRM2OEuQbE+GXN9AybPcQ82HhRLG6PDPJMcI0M71zyyHEpSEyPE4p0p363HSFmgDNmqVdEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hS9Id0Mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS9Id0Mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A6FC2BCB9;
	Tue,  5 May 2026 09:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974736;
	bh=BTGhpdelrcdclE2S6o5MWzcjZDamk+MFHC82dtlZLAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS9Id0MmQEOgi6eYCvSJW7Dyz2e2oPPBbhkKKn3TMENlXugdyAS1ZdniBV28kV+nS
	 4KJZSJ3NtLrU5zqjmTsKfrw+OKDLE/625S4Cx1ynvK5BfDa5wHZ8oZeM+1GbYQwGFl
	 qlbf3c8PNq6evbTmgQLqzOupbzpXSDjGewnx/GTA1TTuH0rzmdPVDM19can2HZJsLY
	 0YQEGXCBDeoFNgscIUSrTlrvLRai1yfTcz4wbhV335m+O/49eIh57tIOd+NsEFRb4v
	 LNTjws/b/zb8Gk61360P73ROC++jQtx9nxin8oasTns1/+SqsY2LIAkBLD2iof10mZ
	 AACvq5ROLbspQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Flavio Suligoi <f.suligoi@asem.it>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] nvme-core: fix parameter name in comment
Date: Tue,  5 May 2026 05:51:24 -0400
Message-ID: <20260505095149.512052-8-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Flavio Suligoi <f.suligoi@asem.it>

[ Upstream commit e80e39f25567310c1c7392eed886890b5c6788ba ]

In the declaration of the structure "core_quirks[]", in the comment
referred to the devices "Kioxia CD6-V Series / HPE PE8030", the
parameter "default_ps_max_latency_us" is reported in a wrong way:

nvme_core.default_ps_max_latency=0

The correct form is, instead:

nvme_core.default_ps_max_latency_us=0

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `nvme-core`; action verb `fix`; claimed
intent is to correct the kernel module parameter name in a source
comment for the Kioxia CD6-V / HPE PE8030 NVMe quirk.

Step 1.2 Record: Tags present:
- `Reviewed-by: Christoph Hellwig <hch@lst.de>`
- `Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>`
- `Signed-off-by: Keith Busch <kbusch@kernel.org>`
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
stable@vger.kernel.org` tag was present in the commit inspected with
`git show`.

Step 1.3 Record: The commit body describes an incorrect parameter
spelling in a comment: `nvme_core.default_ps_max_latency=0`; the actual
module parameter is `nvme_core.default_ps_max_latency_us=0`. Symptom is
not a runtime kernel failure from the patch itself, but incorrect in-
source guidance for disabling APST. Version information was not stated.
Root cause is a missing `_us` suffix in the comment.

Step 1.4 Record: This is not a hidden runtime bug fix. It is an explicit
comment/documentation correction for a real module parameter.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `drivers/nvme/host/core.c`, 1
insertion and 1 deletion. No function body is modified; the changed
object is the `core_quirks[]` table comment. Scope classification:
single-file, comment-only surgical fix.

Step 2.2 Record: Before: the comment suggested booting with nonexistent
or incorrect `nvme_core.default_ps_max_latency=0`. After: it suggests
the verified existing parameter `nvme_core.default_ps_max_latency_us=0`.
This affects only source-code guidance, not execution.

Step 2.3 Record: Bug category is documentation/comment correctness. No
resource leak, race, refcount bug, memory safety bug, type bug, or
executable logic change is present.

Step 2.4 Record: Fix quality is obviously correct:
`module_param(default_ps_max_latency_us, ulong, 0644)` exists in
`drivers/nvme/host/core.c`. Regression risk is effectively zero because
only a comment changes.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the incorrect comment line was
introduced by `5a6254d55e2a9f` (`nvme-pci: add NO APST quirk for Kioxia
device`). `git tag --contains 5a6254d55e2a9f` shows it is present from
`v5.16` onward in mainline tags available locally, and stable branch
snapshots for 5.10 and 5.15 also contain the line.

Step 3.2 Record: No `Fixes:` tag exists, so there was no tagged
introducer to follow. I separately inspected `5a6254d55e2a9f` because
blame identified it as the source of the wrong comment.

Step 3.3 Record: Recent file history shows this patch is standalone.
`block-next` contains `e80e39f255673 nvme-core: fix parameter name in
comment`; nearby commits touch unrelated NVMe behavior.

Step 3.4 Record: `git log block-next --author='Flavio Suligoi' --
drivers/nvme/host` found only this NVMe host commit locally. The patch
was reviewed by Christoph Hellwig and committed by Keith Busch, both
verified from commit metadata and lore.

Step 3.5 Record: No dependencies found. The patch is a one-line comment
correction and `git apply --check` against the current stable checkout
succeeded.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c e80e39f255673` found the original thread:
`https://patch.msgid.link/20260408124522.2375297-1-f.suligoi@asem.it`.
`b4 dig -a` found only v1, so no later revision was missed. Lore mirror
showed Christoph Hellwig replied “Looks good” with `Reviewed-by`, and
Keith Busch replied “applied to nvme-7.1”. No NAKs or risk concerns were
found.

Step 4.2 Record: `b4 dig -w` showed recipients included Keith Busch,
Jens Axboe, Christoph Hellwig, Sagi Grimberg, `linux-nvme`, and `linux-
kernel`, so the right subsystem maintainers/lists were included.

Step 4.3 Record: No `Reported-by` or bug-report `Link:` tag exists.
External search confirmed this is about correcting the APST parameter
spelling, not a separate crash report.

Step 4.4 Record: `b4 dig -a` showed this is a single-patch v1 series,
not a multi-patch dependency chain.

Step 4.5 Record: Direct `lore.kernel.org/stable` fetch was blocked by
Anubis, and web search did not find stable-specific discussion for this
exact patch. Stable-specific discussion remains unverified.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: No functions are modified. The changed text is inside
the static `core_quirks[]` data table comment.

Step 5.2 Record: Caller tracing is not applicable to the changed line
because it is non-executable. I verified `core_quirks[]` is used by the
quirk scan path in `drivers/nvme/host/core.c`, but the patch does not
alter table values or matching logic.

Step 5.3 Record: Callee tracing is not applicable because no executable
statement changed.

Step 5.4 Record: Runtime reachability is not applicable. The only
“reachability” is human/developer/user reading the source comment.

Step 5.5 Record: `rg` verified the actual parameter is declared as
`default_ps_max_latency_us`; the old comment text is the mismatching
pattern.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Step 6.1 Record: The incorrect comment exists in checked refs `v5.16`,
`v6.1`, `v6.6`, `v6.12`, `v6.19`, `v7.0`, and stable branch snapshots
`for-greg/5.10-201`, `for-greg/5.15-201`, `for-greg/6.1-201`, `for-
greg/6.6-201`, `for-greg/6.12-201`, `for-greg/6.19-200`, and `for-
greg/7.0-200`.

Step 6.2 Record: Expected backport difficulty is clean or trivial. `git
apply --check` and `git apply --check --3way` both succeeded on the
current checkout.

Step 6.3 Record: Local history did not show a different stable-side fix
for this exact comment. `git log stable/linux-7.0.y --grep='fix
parameter name in comment' -- drivers/nvme/host/core.c` returned no
match.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is NVMe host core under `drivers/nvme/host`.
Criticality level: important driver subsystem, but this patch’s actual
affected surface is source documentation only.

Step 7.2 Record: The NVMe host core file is actively maintained; recent
local history shows multiple NVMe core fixes and feature changes. This
specific patch was reviewed and applied through the NVMe/block path.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: Affected population is users/developers reading this
source comment for the Kioxia CD6-V / HPE PE8030 APST workaround.
Runtime users are not directly affected by the patch.

Step 8.2 Record: Trigger condition is consulting the source comment and
using the wrong boot parameter. I verified the correct parameter exists;
I did not verify kernel behavior for an unknown wrong boot parameter in
this investigation. Unprivileged runtime triggering is not applicable.

Step 8.3 Record: Failure mode of the patch’s target issue is incorrect
guidance, not a kernel crash, data corruption, deadlock, or security
issue. Severity is LOW as a code issue, but the guidance relates to a
real NVMe APST workaround.

Step 8.4 Record: Benefit is modest but real: stable source carries the
correct module parameter spelling for affected hardware guidance. Risk
is near zero because the patch is comment-only. Risk-benefit ratio is
favorable under the stable exception for documentation/comment fixes.

## Phase 9: Final Synthesis
Step 9.1 Record:
Evidence for backporting:
- Corrects an objectively wrong parameter name.
- Correct parameter is verified in the code.
- Incorrect text exists across active stable branch snapshots.
- Patch is one-line, comment-only, and applies cleanly.
- Reviewed by Christoph Hellwig and applied by Keith Busch.
- Falls under the documentation/comment-fix exception with effectively
  no runtime regression risk.

Evidence against backporting:
- Does not fix executable kernel behavior.
- Does not address crash, corruption, deadlock, security, memory safety,
  or resource leak.
- No explicit stable nomination or stable-list discussion was verified.

Unresolved:
- Stable-list search was partly blocked by Anubis; no stable-specific
  discussion was found via web search.
- I did not verify the exact runtime handling of the wrong boot
  parameter, because the commit only changes a source comment.

Step 9.2 Record:
1. Obviously correct and tested? Yes for the text correction; the actual
   parameter declaration was verified.
2. Fixes a real bug that affects users? It fixes a real
   documentation/comment bug; user impact is indirect.
3. Important issue? Not important as a runtime kernel bug; LOW severity.
4. Small and contained? Yes, one comment line in one file.
5. No new features or APIs? Yes.
6. Can apply to stable trees? Yes on the checked-out stable tree; likely
   trivial elsewhere due the same comment text in checked stable refs.

Step 9.3 Record: Exception category applies: documentation/comment fix.
It corrects incorrect in-source documentation and has zero runtime
behavior change.

Step 9.4 Record: Despite not being a runtime fix, this is appropriate
for stable under the explicit documentation/comment-fix exception: it is
objectively correct, present in stable trees, useful for a real hardware
workaround, and essentially risk-free.

## Verification
- [Phase 1] `git show --format=fuller --stat --patch e80e39f255673`:
  verified subject, tags, author/committer, and one-line comment diff.
- [Phase 2] Diff inspection: verified only `drivers/nvme/host/core.c`
  changed, 1 insertion and 1 deletion, comment-only.
- [Phase 2] `rg default_ps_max_latency`: verified actual module
  parameter is `default_ps_max_latency_us`.
- [Phase 3] `git blame` around the quirk comment: verified wrong comment
  introduced by `5a6254d55e2a9f`.
- [Phase 3] `git show 5a6254d55e2a9f`: verified original Kioxia NO_APST
  quirk and wrong comment text.
- [Phase 3] `git tag --contains 5a6254d55e2a9f`: verified mainline
  availability from `v5.16` in local tags.
- [Phase 4] `b4 dig -c e80e39f255673`: found original patch submission.
- [Phase 4] `b4 dig -a`: verified single v1 patch.
- [Phase 4] `b4 dig -w`: verified NVMe maintainers and lists were
  included.
- [Phase 4] WebFetch of lore mirror: verified Reviewed-by from Christoph
  Hellwig and applied note from Keith Busch.
- [Phase 5] `rg core_quirks`: verified the changed line is in
  `core_quirks[]`; no executable behavior changed.
- [Phase 6] Ref checks with `git show <ref>:drivers/nvme/host/core.c |
  rg`: verified wrong comment exists in checked stable refs and
  corrected text exists in `block-next`.
- [Phase 6] `git apply --check` and `git apply --check --3way`: verified
  clean local application.
- [Phase 7] `git log block-next -- drivers/nvme/host/core.c`: verified
  active subsystem history and target commit in block-next.
- [Phase 8] Failure mode verified from diff: incorrect comment guidance
  only, no runtime code path changed.
- UNVERIFIED: stable mailing-list discussion, because direct lore stable
  search was blocked and web search found no exact stable discussion.
- UNVERIFIED: exact kernel warning/handling for the wrong boot
  parameter, because it is outside the changed code.

**YES**

 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 766e9cc4ffca5..ac5a7d9781f58 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3013,7 +3013,7 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
 		 *
 		 * The device is left in a state where it is also not possible
 		 * to use "nvme set-feature" to disable APST, but booting with
-		 * nvme_core.default_ps_max_latency=0 works.
+		 * nvme_core.default_ps_max_latency_us=0 works.
 		 */
 		.vid = 0x1e0f,
 		.mn = "KCD6XVUL6T40",
-- 
2.53.0

