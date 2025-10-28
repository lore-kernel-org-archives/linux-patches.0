Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90231BBBE5;
	Tue, 28 Oct 2025 00:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612016; cv=none; b=Q/ovxtDxFpHktuHU5Uy5wl87UsEyGIyzPDk4hED6Yx6Tx5VGEuMyBn5JJ6Gx4KUefj5gZdOhmskn59LojVe7oFymDmVPGs1aDQyew6YixAY2L/ezEHMDO3kbK6uxMcmgKKFa5Sjbj4HuJ+9idVq2LrPTlGpq5hlkrtl/CrHrgoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612016; c=relaxed/simple;
	bh=BodBvqDB7jhvZgAQ9ASDmDnRWRvu6gw3TrHXIPrOYKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sw4hWd8foS8OAOPzbiKdhEO8mGrZ/qqCg8BI1jAPOVNr0FWCXQ/S3bYWcQfwDK1cEDZQaSPcTjqkcHQ5lnh7IALrmGHaJrTwVqFoKy6zti7+MU2rgW/21aj1uwb8ThnXNeQWo+0sXUvGZ/ws+eTqqb2Ax+CJQlNqdrc0OBxnzJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPbxyGBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPbxyGBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCAAC113D0;
	Tue, 28 Oct 2025 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612015;
	bh=BodBvqDB7jhvZgAQ9ASDmDnRWRvu6gw3TrHXIPrOYKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPbxyGBFHyxnOSlNgRB3eEM1lzqqXbcmj6OeNn7HgeqnOWP1EAO0sVMWNgislF+gP
	 qkGm5qvYUnZkcVWqOLn+ndN5YGCG80lR7owYr2newfjesSAIWZPiTMfxckNecj2/1o
	 izXpg2DQKaIacchELUJtFAeR1zhVeeLUky4gZx0blH5MOimy7uKC0u9hOBo0kXw3eR
	 /kALh2JZ5eeOd1XSFkjtW43ST05Y77z6OwAuSeLGQ1Mm8GnGw0qph0fQmXntCzSr4P
	 ZAWHzECkyRhrmHFX4mWW6UpI9dQFgjIXPguiAg8JtOVPllhan5oS+tli75AvGsqNgt
	 Voq46WW7IG1cA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Han Gao <rabenda.cn@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alexghiti@rivosinc.com,
	bjorn@rivosinc.com,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	visitorckw@gmail.com,
	alexandre.f.demers@gmail.com,
	pulehui@huawei.com,
	guoweikang.kernel@gmail.com,
	sycamoremoon376@gmail.com,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] riscv: acpi: avoid errors caused by probing DT devices when ACPI is used
Date: Mon, 27 Oct 2025 20:38:59 -0400
Message-ID: <20251028003940.884625-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Han Gao <rabenda.cn@gmail.com>

[ Upstream commit 69a8b62a7aa1e54ff7623064f6507fa29c1d0d4e ]

Similar to the ARM64 commit 3505f30fb6a9s ("ARM64 / ACPI: If we chose
to boot from acpi then disable FDT"), let's not do DT hardware probing
if ACPI is enabled in early boot.  This avoids errors caused by
repeated driver probing.

Signed-off-by: Han Gao <rabenda.cn@gmail.com>
Link: https://lore.kernel.org/r/20250910112401.552987-1-rabenda.cn@gmail.com
[pjw@kernel.org: cleaned up patch description and subject]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my semantic code analysis and repository examination, here is
my determination:

**YES** - This commit should be backported to stable kernel trees.

## Detailed Analysis:

### 1. Semantic Tools Used:
- **mcp__semcode__find_function**: Located the `setup_arch`,
  `unflatten_device_tree`, and `unflatten_and_copy_device_tree`
  functions
- **mcp__semcode__find_callers**: Identified all callers of the device
  tree initialization functions across architectures
- **Git log analysis**: Traced the history of RISC-V ACPI support and
  similar fixes in other architectures
- **Code repository examination**: Verified the commit context and
  impact scope

### 2. Bug Description:
The commit fixes a correctness bug where both ACPI and Device Tree (DT)
are initialized during boot on RISC-V systems when ACPI is enabled. This
causes "repeated driver probing" errors because hardware devices get
enumerated from both sources, leading to conflicts and initialization
failures.

### 3. Key Code Change:
The fix wraps the device tree initialization calls in an `if
(acpi_disabled)` conditional block at arch/riscv/kernel/setup.c:333-340,
ensuring device tree is only processed when ACPI is not being used.

### 4. Impact Scope Analysis:
- **Affected kernel versions**: All versions from 6.5 onwards (where
  RISC-V ACPI support was introduced in commit 724f4c0df7665)
- **Affected systems**: RISC-V systems booting with ACPI enabled
- **Severity**: Medium - causes driver initialization errors on ACPI-
  enabled RISC-V systems
- **Call graph analysis**: The change only affects the RISC-V
  architecture-specific boot path; no cross-architecture impact

### 5. Precedent:
This follows the exact same pattern established by ARM64 in commit
3505f30fb6a98 (March 2015), which has been stable for nearly 10 years.
ARM64 faced the identical issue and resolved it the same way.

### 6. Backport Suitability Indicators:
✅ **Bug fix**: Corrects driver probing errors
✅ **Small and contained**: Only 7 lines changed in one file
✅ **No new features**: Pure bug fix
✅ **No architectural changes**: Simple conditional logic
✅ **Low regression risk**: Established pattern from ARM64
✅ **Clean apply**: No complex dependencies
✅ **Stable kernel compliant**: Fits all stable kernel rules

### 7. Dependencies Check:
Using semantic analysis, I verified that the only dependency is
`acpi_disabled`, which has been available in RISC-V since ACPI support
was added in v6.5. The fix is self-contained and requires no additional
changes.

### 8. Recommendation:
Backport to **all stable trees from 6.6.x onwards** (6.6.x, 6.12.x, and
any LTS versions), as these include RISC-V ACPI support and are affected
by this bug. The fix prevents real errors on production RISC-V ACPI
systems and has minimal risk of regression.

 arch/riscv/kernel/setup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index f90cce7a3acea..d7ee62837aa4f 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -330,11 +330,14 @@ void __init setup_arch(char **cmdline_p)
 	/* Parse the ACPI tables for possible boot-time configuration */
 	acpi_boot_table_init();
 
+	if (acpi_disabled) {
 #if IS_ENABLED(CONFIG_BUILTIN_DTB)
-	unflatten_and_copy_device_tree();
+		unflatten_and_copy_device_tree();
 #else
-	unflatten_device_tree();
+		unflatten_device_tree();
 #endif
+	}
+
 	misc_mem_init();
 
 	init_resources();
-- 
2.51.0

