Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858E21CC43;
	Thu,  2 Oct 2025 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419043; cv=none; b=n1FkY0OiYNCmJX8ANMnWna9c1ZSHhMaveonrV0ZoLuoelYGSA7gVFY6xoh6jOhl6aKJYMXvYxo5SVzPhz9f1M3oC5qYovC4WEbkNUa9SGPr7MII91QIxjmw/7Seuxx6ewhlBe8hcVsoGSnepq2YbCdgPm7utJnuHUteRiOEGeaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419043; c=relaxed/simple;
	bh=h6k+Nnl7KCqJB4WMcYNUaBEbIVUSbrYTxL/+Vy0+N8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ktPjy1qtCoanboCtSM1P1SAn0EuNE/sEagidMjGXiWQ//KomcHVHjqXVl36WpMY+nOnVo9h1/6bz40EOYbW/JF0Lvi7VMB/hMINVg/h3LNM1HadIIuNPeQ3bKt4zrSn9QnCJqweG/5HcZ53WLu5bwuURtV6zCbGZ+mQWwUEePgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYAIEwPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYAIEwPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A27DC4CEF4;
	Thu,  2 Oct 2025 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419043;
	bh=h6k+Nnl7KCqJB4WMcYNUaBEbIVUSbrYTxL/+Vy0+N8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYAIEwPMqqRUEsVSKjSI0JDkm/dHUoxELDumfNytlToq8UYAVuNybxwjhpahwlYDY
	 Kh/dN1cSvGjjm+e2U9uwSgaMNVLaXOOb35m1LtD1JxUGl1BJqtMHGt9uWKpq0Z7xuW
	 fvvNh7l4vweKExbK3HHRFZn4iZSo9FRu4pSjljvq5eT2yDnDeZppvLm+kszKb01CTx
	 cWwcpUsdWy7sJ4BdMo7qifDkJv3o5RXnkJxiNx1Zf5FHaJu1PgWWGLzsVASfR/YSHh
	 hqIm5OGD1QGm0UeBS+EOWT/jHXRklzjRUDpt2SyhiDuZFVTI0+XyQ/fDmyfPJVxlxB
	 FMyOqMSEFq+yA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Junhui Liu <junhui.liu@pigmoral.tech>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.16] riscv: mm: Return intended SATP mode for noXlvl options
Date: Thu,  2 Oct 2025 11:30:00 -0400
Message-ID: <20251002153025.2209281-13-sashal@kernel.org>
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

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit f3243bed39c26ce0f13e6392a634f91d409b2d02 ]

Change the return value of match_noXlvl() to return the SATP mode that
will be used, rather than the mode being disabled. This enables unified
logic for return value judgement with the function that obtains mmu-type
from the fdt, avoiding extra conversion. This only changes the naming,
with no functional impact.

Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Link: https://lore.kernel.org/r/20250722-satp-from-fdt-v1-1-5ba22218fa5f@pigmoral.tech
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive investigation of this commit and its context,
here is my analysis:

## Analysis Summary

**Backport Status: YES**

## Detailed Explanation

### 1. **This is a prerequisite for an important bug fix**

While the commit message states "This only changes the naming, with no
functional impact," this refactoring is **part 1 of a 2-patch series**.
The follow-up commit (17e9521044c9b "riscv: mm: Use mmu-type from FDT to
limit SATP mode") fixes a real hardware issue:

> "Some RISC-V implementations may hang when attempting to write an
unsupported SATP mode, even though the latest RISC-V specification
states such writes should have no effect."

The bug fix depends on this refactoring to work correctly.

### 2. **Code changes are functionally equivalent**

Examining the specific changes:

**In `arch/riscv/kernel/pi/cmdline_early.c`:**
- OLD: `no4lvl` returns `SATP_MODE_48` (the mode being disabled)
- NEW: `no4lvl` returns `SATP_MODE_39` (the mode to actually use)
- OLD: `no5lvl` returns `SATP_MODE_57` (the mode being disabled)
- NEW: `no5lvl` returns `SATP_MODE_48` (the mode to actually use)

**In `arch/riscv/mm/init.c`:**
- The comparison logic changes accordingly to match the new semantics
- OLD: `if (satp_mode_cmdline == SATP_MODE_57)` → disable L5
- NEW: `if (satp_mode_cmdline == SATP_MODE_48)` → disable L5

The end result is identical - both code paths result in the same page
table configuration.

### 3. **Enables unified logic with FDT mmu-type**

The refactoring allows the follow-up patch to use
`min_not_zero(__pi_set_satp_mode_from_cmdline(),
__pi_set_satp_mode_from_fdt())` to combine both sources of SATP mode
limits. This unified approach prevents writing unsupported SATP modes
that cause hardware hangs.

### 4. **Low regression risk**

- Self-contained changes to only 2 files
- Both files modified consistently with matching semantics
- No change to external APIs or behavior
- Simple, straightforward logic transformation

### 5. **Affects stable kernels 6.4+**

The `no4lvl`/`no5lvl` command line options were introduced in v6.4
(commit 26e7aacb83dfd), so any stable kernel from 6.4 onwards would
benefit from having both patches backported together.

### 6. **Already being backported together**

I can confirm that both commits are already being backported to
6.17-stable as a pair:
- f3243bed39c26 → b222a93bf5294 (this refactoring)
- 17e9521044c9b → f64e5a29ae1a2 (the bug fix)

This indicates the maintainers recognized these should be backported
together.

## Conclusion

**YES**, this commit should be backported to stable trees because:
1. It's a necessary prerequisite for fixing hardware hangs on some
   RISC-V implementations
2. The refactoring is functionally equivalent with no behavior change
3. It has minimal regression risk
4. It should be backported together with its follow-up patch
   17e9521044c9b
5. It benefits all stable kernels 6.4+ that have the no4lvl/no5lvl
   feature

 arch/riscv/kernel/pi/cmdline_early.c | 4 ++--
 arch/riscv/mm/init.c                 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/pi/cmdline_early.c b/arch/riscv/kernel/pi/cmdline_early.c
index fbcdc9e4e1432..389d086a07187 100644
--- a/arch/riscv/kernel/pi/cmdline_early.c
+++ b/arch/riscv/kernel/pi/cmdline_early.c
@@ -41,9 +41,9 @@ static char *get_early_cmdline(uintptr_t dtb_pa)
 static u64 match_noXlvl(char *cmdline)
 {
 	if (strstr(cmdline, "no4lvl"))
-		return SATP_MODE_48;
+		return SATP_MODE_39;
 	else if (strstr(cmdline, "no5lvl"))
-		return SATP_MODE_57;
+		return SATP_MODE_48;
 
 	return 0;
 }
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 15683ae13fa5d..054265b3f2680 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -864,9 +864,9 @@ static __init void set_satp_mode(uintptr_t dtb_pa)
 
 	kernel_map.page_offset = PAGE_OFFSET_L5;
 
-	if (satp_mode_cmdline == SATP_MODE_57) {
+	if (satp_mode_cmdline == SATP_MODE_48) {
 		disable_pgtable_l5();
-	} else if (satp_mode_cmdline == SATP_MODE_48) {
+	} else if (satp_mode_cmdline == SATP_MODE_39) {
 		disable_pgtable_l5();
 		disable_pgtable_l4();
 		return;
-- 
2.51.0

