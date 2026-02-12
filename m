Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5409320FAB2;
	Thu, 12 Feb 2026 01:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858635; cv=none; b=er80p7RErD0NqpzHxQW+3NjQjHEyMheHfYVcAL5DHAnz4M9txb7c55fqWszkFLgYbiCZEpiZGmTNA1wKKhDkiw1EtGTxHu+BKkGCuti+tmD5NMcm1vG1hNFBuLJQ6MJHF2ktVBRXrfoCr5LYkXtTxCJzJFmiPC2uxYcEt5sBt+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858635; c=relaxed/simple;
	bh=nJnKuZt4twamPTg2f+NQtkwxo+/LuPCmOI2kXGT9XP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sG6aU4fBUruHQCS2bCH2jDim43ahWE2ysu7FWwR869rpBzNcnbp4dcIvrhkXRjUieG1qpGOpXGYIjQI3p6iHaMxLRzdJTbkCWD1FAK6brGy4dD5nULrNbiwVyji9rmudMF+osoE5eZG5POog8khgQJ648sOjrSX3qBgWd3fAIds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mH9pf9to; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mH9pf9to"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D41C19423;
	Thu, 12 Feb 2026 01:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858634;
	bh=nJnKuZt4twamPTg2f+NQtkwxo+/LuPCmOI2kXGT9XP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mH9pf9toZrUrInYmZei+9Fpi88CTsobnLDvWkVdiITHLDvFoO/D03JvU2sEKwuU2F
	 pT3ZPwIav5U7IcU7e7fXkDhiK6JGP7a3TMCPAcS/kW55MtI8MPHrpR8wW/gh41FH+1
	 HLegO/NqzA82avDCsXsvgHHc8Z+rHtAHLMuDWXNezu43GtrVgKsivTvSJzV/6nxf91
	 4m+Hl1mfa882TaaGZyWDZ3map1FTwyaztVD9ozUjV4VM0PZkzxOh1FCJq3HriI+N8Y
	 YWNCtytsFuTgQx7IvdI5mP+7Uj41EU3cjEVdrJ4hXQL4hOiM74Un1C509ko94vAfyV
	 yz6uE5HOLXWIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bhelgaas@google.com,
	jgross@suse.com,
	wangruikang@iscas.ac.cn,
	hans.zhang@cixtech.com,
	roger.pau@citrix.com
Subject: [PATCH AUTOSEL 6.19-6.1] PCI/MSI: Unmap MSI-X region on error
Date: Wed, 11 Feb 2026 20:09:45 -0500
Message-ID: <20260212010955.3480391-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 1a8d4c6ecb4c81261bcdf13556abd4a958eca202 ]

msix_capability_init() fails to unmap the MSI-X region if
msix_setup_interrupts() fails.

Add the missing iounmap() for that error path.

[ tglx: Massaged change log ]

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260125144452.2103812-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The bug is clearly present in v6.1, v6.6, and v6.12. In these versions,
the function structure is nearly identical to mainline — the same
missing `iounmap()` on the `msix_setup_interrupts()` error path exists.
The patch should apply cleanly (or with trivial context adjustments for
the `msix_mask_all` conditional in mainline vs unconditional in older
stable trees).

---

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear, concise, and directly describes a resource
leak bug: `msix_capability_init()` fails to `iounmap()` the MSI-X table
region if `msix_setup_interrupts()` fails. Thomas Gleixner (the irq
subsystem maintainer) massaged the changelog and signed off as the
subsystem maintainer applying the patch. The `Link:` tag points to the
mailing list submission.

### 2. CODE CHANGE ANALYSIS

The fix is surgical — just 3 lines of net new code:

1. Changes the `goto out_disable` to `goto out_unmap` (line 740) when
   `msix_setup_interrupts()` fails
2. Adds a new `out_unmap:` label with `iounmap(dev->msix_base)` just
   before the existing `out_disable:` label

**The bug mechanism:** `msix_map_region()` (line 732) calls `ioremap()`
to map the MSI-X table into kernel virtual address space and stores the
result in `dev->msix_base`. If `msix_setup_interrupts()` then fails
(line 738-740), the error path goes to `out_disable` which only resets
`dev->msix_enabled` and the PCI MSI-X control register — it never calls
`iounmap()` on `dev->msix_base`.

**Why it's not cleaned up elsewhere:** The caller
`__pci_enable_msix_range()` simply returns the error code — there's no
cleanup for the ioremap'd region. The only function that calls
`iounmap(dev->msix_base)` is `pci_free_msi_irqs()`, which is only called
from `pci_disable_msix()` and `pci_disable_msi()` — but those are never
called on the failed init path.

**When the error occurs:** `msix_setup_interrupts()` can fail for
multiple practical reasons:
- `msix_setup_msi_descs()` fails (memory allocation for MSI descriptors)
- `pci_msi_setup_msi_irqs()` fails (no available IRQ vectors, domain
  allocation failure)
- `msi_verify_entries()` fails (device restrictions not honored)

### 3. BUG ORIGIN

The bug was introduced by commit `438553958ba192` ("PCI/MSI: Enable and
mask MSI-X early") which was merged in v5.14-rc6. Ironically, that
commit has `Cc: stable@vger.kernel.org`, so it was backported to older
stable trees, bringing this leak bug with it.

### 4. AFFECTED STABLE TREES

I verified the bug exists in v5.15, v6.1, v6.6, and v6.12 — all
currently maintained stable trees. The code structure is nearly
identical across all of them:
- **v6.6, v6.12**: Uses `dev->msix_base = msix_map_region()` directly —
  identical structure to mainline.
- **v6.1**: Uses local `base` then `dev->msix_base = base` — same bug,
  same missing iounmap.
- **v5.15**: Uses local `base` variable with the same missing iounmap —
  will need minor adaptation.

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 3 net additions (new goto label, iounmap call,
  changed goto target)
- **Files changed:** 1 (`drivers/pci/msi/msi.c`)
- **Risk:** Extremely low. The fix only adds cleanup on an error path.
  It cannot affect the success path at all.
- **Subsystem:** PCI MSI-X — core PCI infrastructure used by virtually
  every modern PCI device driver

### 6. USER IMPACT

The resource leak (ioremap virtual address space leak) occurs every time
MSI-X setup fails and the driver retries or the device is reprobed. In
hot-plug scenarios or with drivers that unbind/rebind (e.g., VFIO
passthrough, driver reloading), this could compound over time. While not
a crash or security issue, it's a real resource leak in a core subsystem
path that can lead to eventual `ioremap()` failures.

### 7. STABILITY INDICATORS

- Authored by a contributor who has multiple accepted fixes for similar
  resource leaks in the kernel
- Applied and changelog massaged by Thomas Gleixner (irq subsystem
  maintainer)
- The fix pattern (adding iounmap on error path) is a textbook leak fix
  with zero ambiguity

### 8. CLASSIFICATION

This is a **resource leak fix** — a missing `iounmap()` on an error
path. It fixes a real bug, is small and contained, introduces no new
features or APIs, and follows the standard kernel error handling
pattern.

The fix is small, surgical, obviously correct, and meets all stable
kernel criteria. It fixes a genuine resource leak in core PCI MSI-X
initialization that affects all currently maintained stable trees.

**YES**

 drivers/pci/msi/msi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 34d664139f48f..e010ecd9f90dd 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -737,7 +737,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	ret = msix_setup_interrupts(dev, entries, nvec, affd);
 	if (ret)
-		goto out_disable;
+		goto out_unmap;
 
 	/* Disable INTX */
 	pci_intx_for_msi(dev, 0);
@@ -758,6 +758,8 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	pcibios_free_irq(dev);
 	return 0;
 
+out_unmap:
+	iounmap(dev->msix_base);
 out_disable:
 	dev->msix_enabled = 0;
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
-- 
2.51.0

