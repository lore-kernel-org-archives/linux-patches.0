Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F180B330315;
	Tue,  5 May 2026 09:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974739; cv=none; b=TBPHCZoUZPzc/h16ecScXe0CQ/AdRkZqNcu2CYBV1wHeJDuEfk9bzQHAGtRLKv9f+kV/NJjxxCCrqojAef7ySq+wC8tRV6G214K+G0l5KVfB5JlAebFG8e8Hm+zNgN/Ctl+M08bo5v7XZjjw3YsYpjue9k9vHc6yOx1x9Apbmjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974739; c=relaxed/simple;
	bh=4HHNwhM9rkNTzt77ncTNacHwaILxsgmXt1kG8ubs97E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGv+rhgJgHPI5Ic0CW1XYTaNwX522Tzo6xJVbTTKXYvQVjxgksFTOkUJ53cKJaDDiF0idr4NU2VzO/EEip4y12u22VI+VCX0vDi1D4N8SAxCSIALNx2ddTr8Tvyj6eWTV1VuTK6eJU7/nDELAJFiOkfdqUvDh1FsjogmbPRmeq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dN3QLX1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dN3QLX1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB565C2BCC7;
	Tue,  5 May 2026 09:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974738;
	bh=4HHNwhM9rkNTzt77ncTNacHwaILxsgmXt1kG8ubs97E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dN3QLX1uQVeWcYi8zj+j6GOQIDU+lyvPc0GS2xbcKeNvod+s9OGzLdeibFWBZDlud
	 UlXNSLfJ95zipN3+wP+cGYFDLCE9FxxlzdH0yB2+euZDSHFHk3IMTk4ST+lZdgvNKB
	 VG0E0/a4vUy9Cjl/sk5VxPMKoZtzqccjFntfBZTLW+wHP09I4A9bbGd8To54r9+/in
	 LYzpTqnPYf0Z6rO7oJglbvP0tYU3fa55SX3wHElxt7Jx6w2quzQTomXdtu89eF6iU5
	 GnW5JlBqut2jabTzAMJHaBwjQe4HrSviXeqh0YpdkvZRM6pD8NgaehnCHPiw7E2c+o
	 83EtIYdsrO/mQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alan Cui <me@alancui.cc>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] nvme: add quirk NVME_QUIRK_IGNORE_DEV_SUBNQN for 144d:a808 (Samsung PM981/983/970 EVO Plus )
Date: Tue,  5 May 2026 05:51:25 -0400
Message-ID: <20260505095149.512052-9-sashal@kernel.org>
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

From: Alan Cui <me@alancui.cc>

[ Upstream commit 7f991e3f9b8f044640bcb5fa8570350a68932843 ]

The firmware for Samsung 970 Evo Plus / PM981 / PM983 does not support SUBNQN.
Make quirks to suppress warnings.

# nvme id-ctrl /dev/nvme1n1
NVME Identify Controller:
vid       : 0x144d
ssvid     : 0x144d
sn        : ***
mn        : Samsung SSD 970 EVO Plus 500GB
fr        : 2B2QEXM7

mcdqpc    : 0
subnqn    :
ioccsz    : 0

Signed-off-by: Alan Cui <me@alancui.cc>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
1. Phase 1: Commit message forensics
  Record: subsystem `nvme`, action `add quirk`, intent is to add
  `NVME_QUIRK_IGNORE_DEV_SUBNQN` for Samsung PCI ID `144d:a808`. Tags
  present: `Signed-off-by: Alan Cui`, `Signed-off-by: Keith Busch`; no
  `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Link:`, or
  `Cc: stable`. Body says Samsung 970 EVO Plus / PM981 / PM983 firmware
  leaves `subnqn` empty; supplied `nvme id-ctrl` output confirms
  `vid=0x144d`, model `Samsung SSD 970 EVO Plus 500GB`, firmware
  `2B2QEXM7`, and empty `subnqn`. This is a hardware quirk, not a hidden
  memory/race/resource bug.

2. Phase 2: Diff analysis
  Record: one file, `drivers/nvme/host/pci.c`, 2 insertions. Modified
  object is the `nvme_id_table` PCI ID table. Before: Samsung
  `144d:a808` matched the generic NVMe PCI class entry and got no
  `IGNORE_DEV_SUBNQN` quirk. After: it matches a specific PCI ID entry
  and sets `NVME_QUIRK_IGNORE_DEV_SUBNQN`. In `nvme_init_subnqn()`, that
  quirk skips device-provided SUBNQN handling and suppresses the
  “missing or invalid SUBNQN field” warning while still generating the
  synthetic NQN. Fix quality is surgical and consistent with nearby
  quirks. Regression risk is low, with the main caveat that the quirk
  applies to all `144d:a808` devices.

3. Phase 3: Git history investigation
  Record: target commit is `7f991e3f9b8f0`. There is no `Fixes:` tag.
  `NVME_QUIRK_IGNORE_DEV_SUBNQN` was introduced by `6299358d198a0`,
  described as handling firmware that reports invalid/non-unique SUBNQN,
  first contained around `v5.0-rc2`. Existing `144d:a808` handling for a
  suspend quirk was introduced by `1fae37accfc587`, around `v5.6-rc3`,
  confirming the PCI ID is already known in NVMe PCI code. Recent
  history shows this commit is standalone, not part of a required
  series. Author history in this subsystem showed only this commit;
  Keith Busch committed it.

4. Phase 4: Mailing list and external research
  Record: `b4 dig -c 7f991e3f9b8f0` found the original submission at
  `https://patch.msgid.link/9600680.CDJkKcVGEf@alanarchdesktop`. `b4 dig
  -a` showed only v1. `b4 dig -w` showed recipients included `linux-
  nvme`, `linux-kernel`, and Keith Busch. The fetched mbox contained the
  same patch and no review replies or objections. Web research found an
  earlier 2021 linux-nvme patch proposing the same `144d:a808` quirk for
  Samsung 970 EVO Plus/SM981/PM981/PM983, plus Debian and Proxmox user
  reports of the same warning. No stable-specific discussion or
  rejection reason was found.

5. Phase 5: Code semantic analysis
  Record: changed data structure is `nvme_id_table`. PCI core uses that
  table through `nvme_driver.id_table`, then calls `nvme_probe()`.
  `nvme_probe()` calls `nvme_pci_alloc_dev()`, which initializes `quirks
  = id->driver_data`, then passes those quirks to `nvme_init_ctrl()`.
  Later identify flow calls `nvme_init_identify()`,
  `nvme_init_subsystem()`, and `nvme_init_subnqn()`. The affected path
  is normal PCI NVMe device probe at boot or hotplug, not a syscall-
  triggered path. Similar `IGNORE_DEV_SUBNQN` quirks already exist for
  Intel, ADATA, Samsung PM1725a, Lexar, Phison, and other devices.

6. Phase 6: Stable tree analysis
  Record: checked `v5.4`, `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`,
  `v6.17`, `v6.18`, and `v6.19`. All have the generic NVMe PCI class
  match and the `NVME_QUIRK_IGNORE_DEV_SUBNQN` infrastructure; none had
  the specific `144d:a808` `IGNORE_DEV_SUBNQN` entry. The insertion
  context around Memblaze `0x1c5f:0x0540` and Samsung PM1725/PM1725a
  exists in all checked tags, so backport difficulty should be clean or
  trivial.

7. Phase 7: Subsystem and maintainer context
  Record: subsystem is NVMe PCI host driver under `drivers/nvme/host`,
  important storage hardware support. It affects users with Samsung
  `144d:a808` NVMe SSDs, not all users. The subsystem is actively
  maintained; recent history shows multiple NVMe fixes and quirk
  additions. Keith Busch, an NVMe maintainer, committed the patch.

8. Phase 8: Impact and risk assessment
  Record: affected users are Samsung 970 EVO Plus / PM981 / PM983 /
  related `144d:a808` NVMe users. Trigger is device probe, typically
  boot. Verified failure mode is a persistent kernel warning for
  missing/invalid SUBNQN; for the empty-SUBNQN case, code already falls
  back to a synthetic NQN, so I did not verify a crash, data corruption,
  or probe failure for this exact firmware. Severity is low-to-medium,
  but it is a real firmware compliance issue on real hardware. Benefit
  is modest but real: suppresses a misleading warning and applies the
  established firmware workaround. Risk is very low: two lines, device-
  specific, no API changes.

9. Phase 9: Final synthesis
  Evidence for backporting: hardware quirk for an existing driver; real
  user-visible firmware issue; exact device ID; tiny and contained;
  infrastructure exists across stable trees; maintainer accepted
  upstream; stable context appears present across checked LTS tags.
  Evidence against: the verified symptom for this exact commit is
  warning suppression rather than a crash/data-loss fix; no `Reported-
  by`, `Tested-by`, or review tags; broad PCI ID match could affect all
  `144d:a808` variants. Stable checklist: obviously correct yes; real
  bug yes, as firmware reports empty SUBNQN; important issue only weak
  under normal criteria, but it fits the stable exception for hardware
  quirks; small and contained yes; no new API or feature yes; expected
  to apply cleanly yes.

## Verification
- Phase 1: `git show --format=fuller --stat --patch 7f991e3f9b8f0`
  verified subject, body, tags, author/committer, and 2-line diff.
- Phase 2: Read `drivers/nvme/host/core.c`, `drivers/nvme/host/nvme.h`,
  and `drivers/nvme/host/pci.c`; verified quirk definition, PCI table
  use, and `nvme_init_subnqn()` behavior.
- Phase 3: `git blame` around the quirk table and `144d:a808` suspend
  handling; `git show` and `git describe --contains` for `6299358d198a0`
  and `1fae37accfc587`; `git log` on `drivers/nvme/host` for related
  commits.
- Phase 4: `b4 dig -c`, `-a`, `-w`, and mbox read verified original lore
  submission, single v1 revision, recipients, and lack of visible review
  objections. WebFetch verified the older 2021 same-quirk patch and user
  reports.
- Phase 5: `rg` and file reads traced `nvme_id_table` through
  `nvme_probe()`, `nvme_pci_alloc_dev()`, `nvme_init_identify()`,
  `nvme_init_subsystem()`, and `nvme_init_subnqn()`.
- Phase 6: `git grep` and a Python `git show
  <tag>:drivers/nvme/host/pci.c` check verified stable tags have the
  infrastructure/context and lack the new `144d:a808` quirk.
- Unverified: I did not test-build or boot the patch, and I did not
  verify a functional failure beyond the warning for this exact Samsung
  firmware.

This should be backported because it is a classic low-risk hardware
quirk for a real, reported firmware non-compliance on an existing NVMe
driver path, even though the confirmed symptom is warning noise rather
than a severe failure.

**YES**

 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b78ba239c8ea8..d59340982520a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -4104,6 +4104,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x1c5f, 0x0540),	/* Memblaze Pblaze4 adapter */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
+	{ PCI_DEVICE(0x144d, 0xa808),	/* Samsung PM981/983 */
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x144d, 0xa821),   /* Samsung PM1725 */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x144d, 0xa822),   /* Samsung PM1725a */
-- 
2.53.0

