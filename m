Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A92592B66;
	Mon, 19 Oct 2026 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418426; cv=none; b=uhYblIfOA7wjOZEgxpKntsJvKi8wOW3DkUXFsusXs2wPXEoQCbT0G1qtz7rCyglw+hTM53FlgHpgM2XzuKxm829cPLlUVQJOxMQauMiYuzWtgIDxOmQu9Roi3iVRCQ6y1Fu0EcA4QRsvZlvnOIspESmwkUE8d3L8ETmWgCmV1pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418426; c=relaxed/simple;
	bh=TkZrjo6xVlumq1jbOYTlenERQ0hj2ghcIjoERJvITkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtPaw9r3nJTq6zFKsZnx7Q7weJDVD3zhaOC80ZyktMWKEcjgZThNQYDBLiz/0JkcNj4m3fCzF4JJE9hEVebLqRujOK1LNMpkVe78KupslvXnJc/8t8hBQ2Gd6RHZmTmDeOpBmDNSvs9JV2dQWoOGQ+cru9uPAbz1NC5Jr25CNUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOoy7u9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOoy7u9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3D31F000CA;
	Mon, 19 Oct 2026 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418424;
	bh=Is/weyjhHN0TXhDIYBdFZSl2+4NZZbpAoTjc+T+5k4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOoy7u9YnJNaQeecKAIfyo3sl2rFyfzpyT+l6QywIk4D3HG62X+/cad7CcRyLJL9N
	 drsXpwcWmbgZtxiP0IfFyO6TbRcHZO/6OjL4H9VLPMceLyUEbDhxVh4ioUrB55Fz0M
	 lg1y6pNrEAN/YzVFBrslxKqCNglnn2PN5MBHETJ82bFNwQFQ83Da6xxzBU412HVTKn
	 51vrEXvcfsf7+0vYEdPaZS8z/WGqp4D8jvIjmlsHZ4NgqXctN3B+bzlMY7Zq+7l9gj
	 u5m8qcH8aS9U4+TQgkHYbfn25ZYM6J/fyIsPHg2KjPdpO8VDdCLNGvYRt+ycqKdKUr
	 asYO+sJVjILgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mehmet Aysel <mehmet4ysel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI quirk
Date: Mon, 19 Oct 2026 09:48:50 -0400
Message-ID: <20261019135441.1420968-239-sashal@kernel.org>
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

From: Mehmet Aysel <mehmet4ysel@gmail.com>

[ Upstream commit 032bb633e0c34a88b70a4bfc65ebd4e2b510f706 ]

Add DMI match table entry for HUAWEI HVY-WXX9 board, product version
M1060, a MateBook D16 2021 (Ryzen 5 4600H) revision not covered by the
existing M1010/M1020/M1040 entries. This board uses the same
FLAG_AMD_LEGACY / ACP_PCI_DEV_ID configuration as the other HVY-WXX9
variants.

Signed-off-by: Mehmet Aysel <mehmet4ysel@gmail.com>
Link: https://patch.msgid.link/20260825092432.56292-1-mehmet4ysel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[ASoC/amd/acp-config] [Add] DMI quirk for HUAWEI HVY-WXX9
product version M1060`

**Step 1.2: Tags**
Record:
- `Signed-off-by: Mehmet Aysel <mehmet4ysel@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20260825092432.56292-1-mehmet4ysel@gmail.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)

**Step 1.3: Body**
Record:
- **Bug:** MateBook D16 2021 (Ryzen 5 4600H), board HVY-WXX9 / product
  version M1060, is not in the DMI table. Sibling revisions
  M1010/M1020/M1040 already are.
- **Symptom:** ACP legacy audio does not bind on this BIOS revision.
- **Root cause:** `snd_amd_acp_find_config()` only returns
  `FLAG_AMD_LEGACY` on exact DMI matches; M1060 is missing.
- **Version info:** same hardware family already supported; this is
  another product-version string.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. This is an explicit hardware DMI quirk. It is not
cleanup or refactoring.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record: `sound/soc/amd/acp-config.c` only; **+14 / -0**. One new
`config_table[]` entry. Single-file surgical change. Functions: none
changed; static table data only.

**Step 2.2: Code flow**
Record: **Before:** HVY-WXX9 + M1060 does not match;
`snd_amd_acp_find_config()` returns 0. `acp_pci_probe()` then does `if
(flag != FLAG_AMD_LEGACY && flag != FLAG_AMD_LEGACY_ONLY_DMIC) return
-ENODEV`.
**After:** Same board matches and gets `FLAG_AMD_LEGACY` /
`ACP_PCI_DEV_ID`, like M1010/M1020/M1040. Probe path only; no error-path
or locking change.

**Step 2.3: Bug mechanism**
Record: **Hardware workaround / DMI quirk.** Missing exact DMI match
left a real MateBook D16 2021 revision without ACP legacy enablement.

**Step 2.4: Fix quality**
Record: Copy of the existing M1040 entry with version `"M1060"`.
Minimal, obviously correct, no API or lock changes. Regression risk is
limited to that DMI triple (HUAWEI / HVY-WXX9 / M1060).

## Phase 3: Git history

**Step 3.1: Blame**
Record: M1010 HVY-WXX9: `b5338b1b901e4` (“Add support for a new Huawei
Matebook laptop”, Marian Postevca, Dec 2023). M1020/M1040:
`54fcd9dd44b2c` (Aug 2023). Table itself: `f1bdd8d385a80` (Nov 2021).
All are ancestors of this 6.12 tree. The gap is only the M1060 string.

**Step 3.2: Fixes: tag**
Record: No `Fixes:` tag. Not applicable.

**Step 3.3: File history**
Record: Last `acp-config.c` change on this branch is `e17de785850e3`
(ACP 7.0 ACPI machine id). Huawei DMI rows have been unchanged since
v6.7-era additions. Standalone table append; no prerequisite refactor.

**Step 3.4: Author**
Record: Mehmet Aysel has no other commits in `sound/soc/amd/` on this
tree. ASoC maintainer Mark Brown applied the series. Related historical
work is Marian Postevca’s HVY-WXX9 entries, including `5513c5d0fb3d5`
(“Fix support… must also update acp3x-es83xx DMI table”).

**Step 3.5: Dependencies**
Record: Compiles and applies alone. This is **patch 1/2**. Companion
`c1a39c228ace` (“ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI quirk”)
is also not in this tree. Without 2/2, `acp3x_es83xx_probe()` still
returns `-ENODEV` if ACPI exposes ES83xx but DMI does not match. 1/2 is
still required: ACP PCI will not bind without `FLAG_AMD_LEGACY`. Same
two-table pattern as M1010 (`b5338b1b901e4` + `5513c5d0fb3d5`).

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c 032bb633e0c3` →
https://patch.msgid.link/20260825092432.56292-1-mehmet4ysel@gmail.com
`b4 dig -a`: **v1 only** (no v2/v3). Mark Brown applied both patches to
`broonie/sound` `for-7.3`
(https://git.kernel.org/broonie/sound/c/032bb633e0c3). Included in the
sound fixes pull for 7.3-rc1 (`git describe --contains` →
`v7.3-rc1~17^2^2~4`). No NAK found.

**Step 4.2: Recipients**
Record: `b4 dig -w`: Liam Girdwood, Mark Brown, Jaroslav Kysela, Takashi
Iwai, linux-sound, linux-kernel. Right ASoC/sound maintainers.

**Step 4.3: Bug report**
Record: No Bugzilla/syzbot link. Author describes a specific board/SKU
not covered by existing exact matches. No user-count beyond that machine
class.

**Step 4.4: Series**
Record: Two-patch series. [2/2] adds the same DMI triple to
`acp3x-es83xx.c` with `ES83XX_ENABLE_DMIC`. Both should be backported
for working speakers/mic; this commit is still a valid standalone quirk
and a prerequisite for 2/2.

**Step 4.5: Stable list**
Record: No stable-list discussion found for HVY-WXX9/M1060. Lore search
from this environment is 403-limited; lkml/openwall mirrors were used
instead.

## Phase 5: Semantic / call-graph

**Step 5.1: Functions**
Record: No function bodies edited. Data consumed by
`snd_amd_acp_find_config()`.

**Step 5.2: Callers**
Record: `snd_amd_acp_find_config()` is called from PCI probe:
- `sound/soc/amd/acp/acp-pci.c` (`acp_pci_probe`) — **this is the path
  that matters** (`FLAG_AMD_LEGACY`)
- `sound/soc/amd/renoir/rn-pci-acp3x.c`, `vangogh/pci-acp5x.c`, `yc/pci-
  acp6x.c`, `ps/pci-ps.c`
- SOF: `pci-rn.c`, `pci-rmb.c`, `pci-vangogh.c`, `pci-acp63.c`, `pci-
  acp70.c`

**Step 5.3: Callees**
Record: `dmi_check_system()` on each `config_entry`. Match sets
`acp_quirk_data` and returns flags.

**Step 5.4: Reachability**
Record: Yes — PCI enumeration on AMD ACP `0x15E2`
(`CONFIG_SND_SOC_AMD_ACP_PCI` / `CONFIG_SND_AMD_ACP_CONFIG`,
X86+PCI+ACPI). Userspace does not trigger it; missing audio on that
laptop is the user-visible effect.

**Step 5.5: Similar patterns**
Record: Same table already has HVY-WXX9 M1010/M1020/M1040 and other
Huawei KLVL/BOM entries. This tree has many post-v6.12 AMD DMI quirk
backports (e.g. `6599a33c97f45`, `33680092d71b4`).

## Phase 6: This tree (6.12.y)

**Step 6.1: Buggy/missing code**
Record: Local tree is **6.12.111** (`git describe HEAD` →
`p-6.12-3-gc504cf0baa3d8`, `make kernelversion` → 6.12.111). M1060 is
**absent**. Sibling HVY-WXX9 entries are at `acp-config.c:120-161`.
`032bb633e0c3` is **not** an ancestor of HEAD.

**Step 6.2: Backport difficulty**
Record: `git show 032bb633e0c3 | git apply --check` → **Hunk succeeded
at 159 (offset -50 lines)**. Clean apply.

**Step 6.3: Related fixes already here?**
Record: No M1060 entry in `sound/soc/amd/`. No substitute fix.

## Phase 7: Subsystem context

**Step 7.1:**
Record: ASoC AMD ACP machine config. **IMPORTANT** for owners of these
Huawei AMD laptops; not core mm/fs. Driver already exists here.

**Step 7.2:**
Record: ACP config table is mature (since ~5.17/6.7 Huawei work). This
6.12 tree continues to take AMD DMI quirks.

## Phase 8: Impact and risk

**Step 8.1:**
Record: Driver-specific, DMI-specific: HUAWEI HVY-WXX9 / M1060 (MateBook
D16 2021, Ryzen 5 4600H).

**Step 8.2:**
Record: Trigger is boot/ACP PCI probe on that SKU. Not unprivileged-
attack surface. Common for that machine; zero effect on others.

**Step 8.3:**
Record: Failure mode is **no audio** (`-ENODEV`), not oops/UAF. Severity
**MEDIUM** for those users; this is the hardware-quirk exception, not a
crash fix.

**Step 8.4:**
Record: **Benefit high** for that SKU (audio enablement, same as
IDs/quirks already taken here). **Risk very low** (14-line DMI row,
exact match, existing flag). Ratio strongly favors backport.

## Phase 9: Synthesis

**Evidence FOR:**
- Documented hardware-quirk / device-ID exception
- Real laptop revision omitted from exact DMI matches
- Sibling M1010/M1020/M1040 already in this 6.12 tree
- +14 lines, one file, no new API
- Applies cleanly with line offset
- Applied by ASoC maintainer; in v7.3-rc1 sound pull
- This tree already backports AMD DMI quirks after v6.12

**Evidence AGAINST:**
- Not a crash/security/corruption fix
- Full speakers/mic also need companion 2/2 (`c1a39c228ace`), not in
  this tree
- Author is not the subsystem regular (mitigated by Mark Brown applying
  it)

**Unresolved:** None that change the verdict. Stable-list 403 on lore;
mirrors showed no NAK and no prior rejection.

**Stable rules:**
1. Obviously correct and tested? **PASS** — copy of existing entry;
   maintainer applied
2. Real bug affecting users? **PASS** — missing audio on M1060
3. Important (crash/security/corruption/deadlock)? **PASS via quirk
   exception** — device enablement
4. Small and contained? **PASS** — 14 lines, one file
5. No new features/APIs? **PASS** — DMI row for existing driver/flags
6. Applies to this tree? **PASS** — verified `git apply --check`

**Exception category:** Hardware DMI quirk / device-ID-style addition to
an existing driver.

The patch makes ACP legacy bind on a MateBook D16 2021 BIOS revision
this tree already treats as supported for M1010/M1020/M1040. That is
exactly the class of quirk 6.12.y already takes. Companion
`acp3x-es83xx` M1060 should be backported too for a complete card, but
this commit is self-contained, applies cleanly, and is the PCI-bind half
of that enablement.

Verification:
- [Phase 1] Tags: author SOB, Mark Brown SOB, msgid link; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +14 lines in `config_table[]` only; `FLAG_AMD_LEGACY`
  + `ACP_PCI_DEV_ID` + DMI triple
- [Phase 3] Blame: M1010=`b5338b1b901e4`, M1020/M1040=`54fcd9dd44b2c`;
  both ancestors of HEAD
- [Phase 3] `5513c5d0fb3d5` documents that acp-config alone is
  incomplete without es83xx DMI
- [Phase 3] Author has no other `sound/soc/amd` commits on this tree
- [Phase 4] `b4 dig -c 032bb633e0c3`: msgid 20260825092432.56292-1; v1
  only; Broonie applied both
- [Phase 4] Recipients: lgirdwood, broonie, perex, tiwai, linux-sound
- [Phase 4] Included in sound fixes pull for 7.3-rc1; `git describe
  --contains` = `v7.3-rc1~17^2^2~4`
- [Phase 5] `acp_pci_probe()` returns `-ENODEV` unless flag is
  `FLAG_AMD_LEGACY`
- [Phase 5] `acp3x_es83xx_probe()` also requires its own DMI table
  (companion 2/2)
- [Phase 6] `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` = 6.12.111
- [Phase 6] `git merge-base --is-ancestor 032bb633e0c3 HEAD` → not
  ancestor; `M1060` absent
- [Phase 6] `git apply --check` of 032bb633 → success at line 159,
  offset -50
- [Phase 6] Companion `c1a39c228ace` also not an ancestor of HEAD
- [Phase 7/8] Post-v6.12 AMD DMI quirks already present (e.g.
  `6599a33c97f45`, 2026-09-21)
- UNVERIFIED: full lore.kernel.org thread body (HTTP 403); used
  lkml.iu.edu / openwall / b4 instead

**YES**

 sound/soc/amd/acp-config.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index 365209ea53f36..653e8ce946082 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -159,6 +159,20 @@ static const struct config_entry config_table[] = {
 			{}
 		},
 	},
+	{
+		.flags = FLAG_AMD_LEGACY,
+		.device = ACP_PCI_DEV_ID,
+		.dmi_table = (const struct dmi_system_id []) {
+			{
+				.matches = {
+					DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "HUAWEI"),
+					DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "HVY-WXX9"),
+					DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "M1060"),
+				},
+			},
+			{}
+		},
+	},
 };
 
 static int snd_amd_acp_acpi_find_config(struct pci_dev *pci)
-- 
2.53.0

