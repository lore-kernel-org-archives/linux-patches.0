Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6721B62D2E9;
	Mon, 19 Oct 2026 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418717; cv=none; b=PmaPicCLyzmvr0RPh1C3jufzSjGtBXUwj7uV7g3F7vPAswZgsDP5bBy9DarIz1NHbSn+88DQYaOFtbBbb9pKMxYp15WT26XBpavLJlbc4MXo83uPCyLgdOSPZIOEHsioeFCkf4QrW3pShliX+1Az9NEoTTK50CIjr4lKCHYBi/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418717; c=relaxed/simple;
	bh=6qCaAak29e/m9DOP9/fNNaRq273RRMrFKk1ouyTueQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOsOsPmF79xABBqzay/F5S91eI3Bjs0VaZeYSPoPkjVb5G1akGbEXR+CqjgflBuphiOaFLPKpPuF46G2aPN4tNTKbxWv85Yc5k/yLRjREnL/zF2XX37XQNOWX4oXEp9PTCkRwgfGjc4uignSv/3LQdsuuOnPmCWc1shJHgduI3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKPhEToI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKPhEToI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E321F000C4;
	Mon, 19 Oct 2026 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418715;
	bh=n/2d7V9fZV8ZTs8CxmLIW0KeoK82x9+TwbagsNYACiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKPhEToIIGYlJ1GAZjOBqWW3kFgcNACqEhOoiQa2K3OOZWs05jm5Sp1CbzDz8TJdE
	 qEu5uE4h+Dri4TxLT3SdjkN7A0dkzZM4pgWteCvK4NkWPIyeeKVLdhiOnp9pozFpb8
	 FwWgnzB3EaNzKUKRZGLUltGcKj12G64hhet/Cnu74c8NkOGt/UD71YpUr17J2yFyLd
	 TSjkS/Tt4UtElcs6lYTJkOLP8YflXnfpO/armSAnoJEkHc4JToomBv1ZMkx9mPwe3x
	 enfIIEAjcGlD8IPla8UpSRLHq0TQZ47wgBlti2GwmWN7ARutOlv9+kaxLXb6lw+1lt
	 /kZmSmHDMjrjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Eugeniy.Paltsev@synopsys.com,
	dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID
Date: Mon, 19 Oct 2026 09:52:15 -0400
Message-ID: <20261019135441.1420968-444-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 89aba9c39bdda8a973a6ffed7c9e93321edcfc16 ]

When writing the lli->ctl_hi, this is an __le32 type so the
value being orred should be convered to __le32 by cpu_to_le32.

Fixes 1deb96c0fa58a ("dmaegine: dw-axi-dmac: Support device_prep_dma_cyclic()")
--
Note, the call to axi_chan_irq_clear() is passing lli->status_lo
through which is also an __le32 but it does not seem to be set
anywhere. Is this also a bug?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260617084944.705266-1-ben.dooks@codethink.co.uk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `89aba9c39bdda` (`dmaengine: dw-axi-dmac:
fix __le32 on set of CH_CTL_H_LLI_VALID`)

Local tree: **v7.3-rc4** (`7.3.0-rc4`, detached HEAD `f0100363d8c37`).
The cyclic DW AXI DMA path exists here (introduced in v5.12). Decision
is for this checkout only.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[dmaengine / dw-axi-dmac] [fix] [endian-convert
`CH_CTL_H_LLI_VALID` before OR into `__le32` `lli->ctl_hi`]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes 1deb96c0fa58a ("dmaegine: dw-axi-dmac: Support
  device_prep_dma_cyclic()")` — malformed (`Fixes` missing the colon),
  so it would not auto-route to stable. SHA is real:
  `1deb96c0fa58afe0f5c4aa8e5916baa9454979d6`.
- `Link: https://patch.msgid.link/20260617084944.705266-1-
  ben.dooks@codethink.co.uk`
- `Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>` (author)
- `Signed-off-by: Vinod Koul <vkoul@kernel.org>` (dmaengine maintainer)
- No `Reported-by`, `Tested-by`, `Reviewed-by`, `Acked-by`, `Cc:
  stable`, syzbot, or CVE.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `lli->ctl_hi` is `__le32`; the cyclic completion path ORs in
  host-endian `CH_CTL_H_LLI_VALID` (`BIT(31)`).
- **Symptom:** On a big-endian CPU the LLI_VALID bit is written as the
  wrong byte, so the DMA engine does not see the descriptor as valid
  when cyclic transfers re-arm. Little-endian is a no-op (`cpu_to_le32`
  is identity).
- **Version:** Introduced with cyclic support (`1deb96c0fa58a`,
  v5.12-rc1).
- **Side note in the message:** `axi_chan_irq_clear(chan,
  lli->status_lo)` also passes `__le32` as `u32`; that is a separate
  pre-existing issue, not changed here.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Subject and body say “fix”. Author later told
Frank Li this was a **sparse `__le32` cast warning**; that is still a
real endian/type bug in a hardware LLI, not style cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c` (`1` insertion,
  `1` deletion)
- Function: `axi_chan_block_xfer_complete()`
- Scope: **single-file, 1-line surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Cyclic IRQ path only (`chan->cyclic`). After matching the
current LLP, the old code did `hw_desc->lli->ctl_hi |=
CH_CTL_H_LLI_VALID`. New code uses `|= cpu_to_le32(CH_CTL_H_LLI_VALID)`.
Non-cyclic completion is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **(f) Type / endianness.** `struct axi_dma_lli.ctl_hi` is
`__le32`; `CH_CTL_H_LLI_VALID` is `BIT(31)` in `dw-axi-dmac.h`.
Descriptor setup already stores `ctl_hi` with `cpu_to_le32()`
(`dw_axi_dma_set_hw_desc()` ~line 715, memcpy path ~line 985). This
cyclic re-arm was the missed conversion from `1deb96c0fa58a`.

On BE, `|= BIT(31)` stores `80 00 00 00`; the LE engine reads `BIT(7)`
instead of bit 31, so LLI_VALID is not set and the cyclic ring does not
restart.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct** and consistent with every other `ctl_hi`
store in the file. Minimal. LE codegen is unchanged. No
API/locking/refcount change. Does not fix the `status_lo` IRQ-clear
question; that does not make this line wrong.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Cyclic block and the original `|= CH_CTL_H_LLI_VALID` are from
**`1deb96c0fa58a` (Sia Jee Heng, 2021-01-25)**. First contained in
**v5.12-rc1**. Long-lived, not recent.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: `1deb96c0fa58a` added `device_prep_dma_cyclic()` (ALSA-style
cyclic DMA). It is an ancestor of HEAD (`git merge-base --is-ancestor`
exit 0). No later LLI_VALID fix besides this commit.

**Step 3.3: CHECK FILE HISTORY**
Record: Recent work is PM, CV1800B, StarFive, per-channel IRQ — none of
it is a prerequisite for this one-line OR. **Standalone**, not `patch
X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ben Dooks has prior dw-axi-dmac fixes (`ignore interrupt if no
descriptor`, `do not print NULL LLI`). Not the subsystem maintainer;
Vinod Koul applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs cyclic support (`chan->cyclic`, `hw_desc->lli->ctl_hi`).
That is in this tree since v5.12. **Applies standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore / msgid: https://patch.msgid.link/20260617084944.705266-1-
  ben.dooks@codethink.co.uk
- **v1 only** (`b4 dig -a`); committed version is that v1
  (`89aba9c39bdda`).
- Frank Li: asked whether it would pass sparse.
- Ben Dooks: *“This was fixing a __le32 cast warning from sparse, forgot
  to put the actual warning in the commit message.”*
- Vinod Koul: **Applied, thanks!** No NAK, no `Cc: stable` request.
- Sashiko bot flagged **pre-existing** issues (`status_lo`,
  `descs_allocated` vs `nr_hw_descs`, cyclic period math) — not
  introduced by this patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Ben Dooks, Eugeniy Paltsev (Synopsys / binding
maintainer), Vinod Koul, Frank Li, `dmaengine@vger.kernel.org`, `linux-
kernel@vger.kernel.org`. Maintainer applied it. Frank commented; no
formal Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No user bugzilla/syzbot report.** Trigger was sparse, not a
field crash. Direct lore fetch of the msgid returned 403; the full
thread was recovered via `b4 dig -m`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Author asked about `status_lo`; that was **not**
patched here and is not required for this conversion.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore stable for this subject did not turn up a
prior stable discussion or an explicit rejection. **UNVERIFIED** that
every stable archive was exhaustively scanned (lore HTML is 403 /
Anubis-protected).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `axi_chan_block_xfer_complete()` (modified). Related:
`dw_axi_dma_interrupt()`, `dw_axi_dma_chan_prep_cyclic()`,
`dw_axi_dma_set_hw_desc()`.

**Step 5.2: TRACE CALLERS**
Record: Only caller is `dw_axi_dma_interrupt()` when
`DWAXIDMAC_IRQ_DMA_TRF` is set. Same handler is registered from probe
(`devm_request_irq`). **IRQ context.** Userspace reaches it via
dmaengine cyclic prep (ALSA and other slave cyclic clients).

**Step 5.3: TRACE CALLEES**
Record: `axi_chan_irq_clear()`, `vchan_cyclic_callback()`,
`axi_chan_enable()`, `vchan_next_desc()`. The important store is into
the DMA-visible LLI.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: userspace cyclic DMA → `dw_axi_dma_chan_prep_cyclic` (sets
LLI_VALID via `cpu_to_le32`, `set_desc_last`) → HW completes a block →
IRQ → re-set LLI_VALID → `axi_chan_enable`. **Reachable from userspace**
on boards that use this DMAC for cyclic audio/peripheral DMA.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Every other `ctl_hi` assignment already uses `cpu_to_le32()`.
This was the remaining `|=` of a host `BIT()` into `__le32`. No sibling
driver copy of this exact bug was searched beyond this file.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes, in this lineage.** Cyclic path is present; the bug was
the missing `cpu_to_le32` on the re-arm OR, from **v5.12**. Current HEAD
already has the fixed line (`ctl_hi |= cpu_to_le32(CH_CTL_H_LLI_VALID)`
at line 1129). Introduced after 5.12, long before 7.3.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Surrounding cyclic IRQ code is still the 2021 structure. **Clean
apply** on a tree that still has the unconverted `|=`. No conflicting
refactor in this function.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact conversion is the only LLI_VALID endian fix. No
alternate fix. Presence of `89aba9c39bdda` on 7.3-rc4 is expected for a
mainline commit and is **not** treated as “already selected for stable.”

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **dmaengine / Synopsys DW AXI DMAC** (`CONFIG_DW_AXI_DMAC`).
**IMPORTANT** for those SoCs, not core mm/VFS. In-tree users: StarFive
JH7110/JH8100, Intel Keem Bay / Agilex5, Sophgo CV1800B/SG2044, T-Head
TH1520, Canaan K210, **ARC HSDK** (`CONFIG_DW_AXI_DMAC=y` in
`hsdk_defconfig`).

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively maintained (StarFive, Sophgo, PM, per-channel IRQ).
Cyclic completion itself has been stable since 2021.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific**, plus **endian-specific**. Production DTs
are RISC-V/ARM64 (LE), where this is a no-op. ARC can be built
`CPU_BIG_ENDIAN`; HSDK defconfig is LE but BE ARC + this IP is a valid
config. Cyclic clients (ALSA) are the functional path.

**Step 8.2: TRIGGER CONDITIONS**
Record: Cyclic DMA block-complete IRQ. Common on audio; unused if the
channel is memcpy-only. Unprivileged users can trigger it if they have
the PCM/DMA device. Not a race.

**Step 8.3: FAILURE MODE SEVERITY**
Record: On BE, LLI_VALID is not set → cyclic DMA does not re-arm →
**audio/DMA stall or dropped periods**, not an oops. On LE, **no runtime
change**. Severity: **MEDIUM** on BE, **none** on LE. Not
UAF/panic/corruption.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Restores cyclic DMA descriptor validity on BE; matches
  the rest of the driver; zero LE behavior change.
- **Risk:** Very low (1 line, standard conversion).
- **Ratio:** Favorable. The strict “crash/security/deadlock” bar is not
  met; the recognized **endianness/type** class and zero regression risk
  still make it appropriate.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real `__le32` vs host `BIT(31)` mismatch in a DMA-visible LLI.
- Same file already converts every other `ctl_hi` store.
- Bug present since v5.12 cyclic support; that commit is in this tree.
- 1 line, obviously correct, maintainer-applied.
- BE cyclic DMA would fail to re-validate descriptors.
- Standalone; no new API.

**AGAINST:**
- Author described it as a sparse warning; no user/syzbot report.
- In-tree boards are LE, so this is a no-op for typical 7.3 users of
  JH7110/Keem Bay/Sophgo.
- Not a crash, UAF, deadlock, or security issue.
- `status_lo` concern left unfixed (out of scope).

**UNRESOLVED:** Exhaustive stable-list search (lore 403). Exact sparse
warning text was never pasted in the commit.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches existing stores;
   applied by Vinod Koul. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — wrong LLI bit on BE;
   type-incorrect on all builds.
3. Important issue? **PASS (low end of the bar)** — functional cyclic
   DMA failure on BE, not a panic. Endianness/type fixes of this shape
   are accepted stable material; this is not a warning-only whitespace
   change.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — cyclic path and `Fixes:`
   target exist; context is unchanged.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Closest: type-
correctness / sparse, but the runtime BE effect is a real hardware-
descriptor bug.

**Step 9.4: DECISION**
This tree has the driver and the v5.12 cyclic path the bug was
introduced in. The change is a one-line, obviously correct endian
conversion on a DMA linked-list field. Risk is negligible; on BE it is
the difference between a valid LLI_VALID bit and a silent cyclic stall.
That meets stable rules for this checkout.

---

### What the commit solves for this tree
Cyclic completion re-arms `CH_CTL_H_LLI_VALID` in an `__le32` LLI.
Without `cpu_to_le32()`, a big-endian CPU writes the wrong bit and the
DW AXI engine will not treat the descriptor as valid. Little-endian
machines (StarFive, Intel, Sophgo, default HSDK) generate the same code
as before.

### Risk vs benefit
Benefit is correctness of cyclic DMA on BE and type-safety of a hardware
descriptor. Risk is essentially zero. No dependencies beyond cyclic
support, which is already here.

---

## Verification
- **[Phase 1]** Parsed tags: malformed `Fixes 1deb96c0fa58a` (no colon);
  Link msgid; SOBs Ben Dooks + Vinod Koul; no syzbot/Reported-by/Cc
  stable.
- **[Phase 2]** Diff: 1 line in `axi_chan_block_xfer_complete()`;
  `ctl_hi` is `__le32` (`dw-axi-dmac.h:85`); `CH_CTL_H_LLI_VALID` is
  `BIT(31)` (line 256); other stores already use `cpu_to_le32` (lines
  715, 985, 1129 after the fix).
- **[Phase 3]** `git blame`: cyclic OR from `1deb96c0fa58a`; `git
  describe --contains 1deb96c0fa58a` → `v5.12-rc1~57^2~12`.
- **[Phase 3]** `git merge-base --is-ancestor 1deb96c0fa58a HEAD` → 0
  (present). `git merge-base --is-ancestor 89aba9c39bdda HEAD` → 0
  (commit is in this mainline checkout; not used as a circular “already
  selected” NO).
- **[Phase 3]** `git show 1deb96c0fa58a`: added `hw_desc->lli->ctl_hi |=
  CH_CTL_H_LLI_VALID` without conversion.
- **[Phase 4]** `b4 dig -c 89aba9c39bdda`: msgid
  `20260617084944.705266-1-ben.dooks@codethink.co.uk`.
- **[Phase 4]** `b4 dig -a`: v1 only.
- **[Phase 4]** `b4 dig -w`: Vinod, Eugeniy Paltsev, Frank Li, dmaengine
  list.
- **[Phase 4]** `b4 dig -m`: Frank Li sparse question; Ben confirmed
  sparse `__le32` warning; Vinod applied; Sashiko pre-existing notes
  only.
- **[Phase 4]** WebFetch lore URL: 403; thread recovered from mbox
  instead.
- **[Phase 4]** Stable lore search: no hit for this patch (UNVERIFIED
  exhaustive).
- **[Phase 5]** Callers: only `dw_axi_dma_interrupt()` on
  `DWAXIDMAC_IRQ_DMA_TRF`; IRQ from probe.
- **[Phase 6]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`.
- **[Phase 6]** Buggy cyclic path exists; `1deb96c0fa58a` is ancestor;
  apply context still the 2021 function.
- **[Phase 7]** DTs: `snps,axi-dma-1.01a` / StarFive / Sophgo / Intel /
  ARC HSDK; `hsdk_defconfig` has `CONFIG_DW_AXI_DMAC=y`, not
  `CPU_BIG_ENDIAN`.
- **[Phase 8]** Failure mode: BE cyclic DMA fails to set LLI_VALID
  (stall), not oops; LE no-op.
- **UNVERIFIED:** Exact sparse warning string; whether any production BE
  board actually ships this IP.

**YES**

 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index ea4e47ee0d710..343d32eeaa29a 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1128,7 +1128,7 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 				hw_desc = &desc->hw_desc[i];
 				if (hw_desc->llp == llp) {
 					axi_chan_irq_clear(chan, hw_desc->lli->status_lo);
-					hw_desc->lli->ctl_hi |= CH_CTL_H_LLI_VALID;
+					hw_desc->lli->ctl_hi |= cpu_to_le32(CH_CTL_H_LLI_VALID);
 					desc->completed_blocks = i;
 
 					if (((hw_desc->len * (i + 1)) % desc->period_len) == 0)
-- 
2.53.0

