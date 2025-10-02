Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853BC9478;
	Thu,  2 Oct 2025 15:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419071; cv=none; b=sO+jZRTDb550yj5lh7w/Pzi7pRX+89ZNACCwnNvN8I7/IB6DyMH0xv+lRTKHJc/ZjhybiKLkW/bQx1Elvg4PdZ4zgRh2kddgiK14pw3rlb0tcBd/UiFeVbW3NAVn0IK4g7H6UHmSHm0S8M7y9DuzG0jVxL0+UozvjSXetS2r1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419071; c=relaxed/simple;
	bh=vkZan2sA3q3Zpt91HGXqtJTHqqZKLrjcgTqhPBKawuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hv+BqjwMTjrdVjzLiCyhi6fD9TuXGAkmKe9XsB7q02GQQD6fLOa6U6MxCPAW3nJ2TtBKLvJkLf+gXawL8XvdxByLKZgHUzh9uNGEiaz9v0sU4fFpcu7sfn2pouEconWc/MbQnPnappc2v81bZxojsXBkhJTvtGRJ4VRyhJkVowo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXGZB8GV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXGZB8GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FE1C4CEF9;
	Thu,  2 Oct 2025 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419071;
	bh=vkZan2sA3q3Zpt91HGXqtJTHqqZKLrjcgTqhPBKawuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXGZB8GVEqmrly6BJ9gCsZkTGpZ+05lTNCQlZpPwuWSPqqggpP0drBVMr244U+XvV
	 1zoKol7xdUtuwbaDKTHLQHBfmRcD79Xqkfuriyq85IxgAeG0QZaYdXj9rIGa8if3bR
	 dY9AL1NtiGkNPrjpaQfdJHrmF7xmJfMa4OlnfAf4h0EEuYrTGloTuHjsuZbSTGlMjq
	 p0Te4crEiGB4SzHSjAToUEMk2GN+4B3O9dwpTB1rucWRG182YKl5IJdwAvEKRjZSwL
	 qTjSKDPnWEzFVQBJPv1gqbpS3nIw4tqIHnAWJE+V4x2DKpFew0hgLGzQlZ6ZZNaf0A
	 qkSAN5lVSZPkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.16] arm64: errata: Apply workarounds for Neoverse-V3AE
Date: Thu,  2 Oct 2025 11:30:19 -0400
Message-ID: <20251002153025.2209281-32-sashal@kernel.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 0c33aa1804d101c11ba1992504f17a42233f0e11 ]

Neoverse-V3AE is also affected by erratum #3312417, as described in its
Software Developer Errata Notice (SDEN) document:

  Neoverse V3AE (MP172) SDEN v9.0, erratum 3312417
  https://developer.arm.com/documentation/SDEN-2615521/9-0/

Enable the workaround for Neoverse-V3AE, and document this.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, here is my determination:

## **Backport Status: YES**

### Detailed Analysis

#### 1. **Nature of the Fix**
This commit adds ARM Neoverse-V3AE to the existing workaround for
erratum 3194386/3312417, which addresses a **speculative execution
vulnerability** related to SSBS (Speculative Store Bypass Safe). The
erratum description states: "MSR SSBS, #0 instructions may not affect
subsequent speculative instructions, which may permit unexpected
speculative store bypassing." This is a security-related issue similar
to Spectre v4.

#### 2. **Code Changes Analysis**
The changes are **minimal and surgical**:
- **Documentation** (`silicon-errata.rst`): Adds 1 table entry
  documenting Neoverse-V3AE erratum 3312417
- **Kconfig** (`arch/arm64/Kconfig`): Adds 1 line to the list of
  affected CPUs in the ARM64_ERRATUM_3194386 help text
- **Errata code** (`cpu_errata.c`): Adds 1 line
  `MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3AE)` to the
  `erratum_spec_ssbs_list[]` array

This simply registers a new CPU variant to an existing, well-tested
workaround infrastructure.

#### 3. **Established Backporting Pattern**
The erratum 3194386 infrastructure has a **clear history of being
expanded and backported**:
- Base erratum introduced in v6.10 (commit 7187bb7d0b5c7)
- First expansion in v6.11 (commit 75b3c43eab594) - **backported to
  v6.10.x**
- Second expansion in v6.11 (commit adeec61a4723f) - **backported to
  v6.10.x**
- Third expansion in v6.12 (commit 081eb7932c2b2) - **backported to
  v6.11.x**

The backport commits show `Signed-off-by: Sasha Levin
<sashal@kernel.org>`, confirming stable team involvement. This
establishes that ARM errata workarounds for speculative execution are
**routinely backported**.

#### 4. **Risk Assessment: VERY LOW**
- **No architectural changes** - uses existing workaround mechanism
- **No new code paths** - just adds a CPU ID to a matching list
- **Zero impact if hardware not present** - the MIDR check only triggers
  on affected CPUs
- **Well-contained** - changes are confined to ARM64 errata subsystem
- **Already tested** - the workaround logic is proven on 20+ other ARM
  cores with the same erratum

#### 5. **Dependencies**
This commit depends on `3bbf004c4808e` ("arm64: cputype: Add
Neoverse-V3AE definitions") which adds the `MIDR_NEOVERSE_V3AE`
constant. Both commits are part of the same September 2025 patch series
and should be backported together as a pair.

#### 6. **User Impact**
- **Security**: Users with Neoverse-V3AE CPUs are vulnerable to
  speculative store bypass attacks without this fix
- **Hardware availability**: ARM has published SDEN v9.0 for
  Neoverse-V3AE (MP172), indicating this hardware exists or will exist
  in production systems
- **Protection**: The workaround places speculation barriers after SSBS
  changes to prevent information leakage

#### 7. **Stable Kernel Criteria Compliance**
✅ **Fixes important bug** - Security/speculative execution vulnerability
✅ **Small and contained** - 3 single-line additions
✅ **No new features** - Just hardware support
✅ **Minimal regression risk** - Uses proven infrastructure
✅ **Clear benefit** - Protects affected hardware

### Recommendation
**STRONGLY RECOMMEND BACKPORTING** this commit along with its dependency
(3bbf004c4808e) to all stable kernels that contain the base
ARM64_ERRATUM_3194386 infrastructure (v6.10+). This follows the
established pattern for ARM errata workarounds and provides essential
security protection for Neoverse-V3AE hardware.

 Documentation/arch/arm64/silicon-errata.rst | 2 ++
 arch/arm64/Kconfig                          | 1 +
 arch/arm64/kernel/cpu_errata.c              | 1 +
 3 files changed, 4 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index b18ef4064bc04..a7ec57060f64f 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -200,6 +200,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-V3AE   | #3312417        | ARM64_ERRATUM_3194386       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | ARM_SMMU_MMU_500_CPRE_ERRATA|
 |                |                 | #562869,1047329 |                             |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a64..93f391e67af15 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1138,6 +1138,7 @@ config ARM64_ERRATUM_3194386
 	  * ARM Neoverse-V1 erratum 3324341
 	  * ARM Neoverse V2 erratum 3324336
 	  * ARM Neoverse-V3 erratum 3312417
+	  * ARM Neoverse-V3AE erratum 3312417
 
 	  On affected cores "MSR SSBS, #0" instructions may not affect
 	  subsequent speculative instructions, which may permit unexepected
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 59d723c9ab8f5..21f86c160aab2 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -545,6 +545,7 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3AE),
 	{}
 };
 #endif
-- 
2.51.0

