Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA911199230;
	Mon,  3 Nov 2025 18:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193004; cv=none; b=htZf548UB8o3RNBwdVPWATU1GtIyMK/E0isalkWjAiymgcS4Sd/TYfScwPoNQOVoowxXcwKDa+c56jZFrg8RZlzt3L/J9sCnKqHU1QWmlLa2djiSl+OgqIENVch4fVRcrRtTcxmg99KvX4+jubV5RdsGthaMB8r5d/Q6wgNIOK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193004; c=relaxed/simple;
	bh=jmGEaZf4AYi4I/lNyEdbjBZMHllthImoE14viZT5lp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mWALZSsIlWmYO+DDyHbbK0GimnYovh1n1v79lT6a3Xkzh/OpKmiCKZRdnIJDNeC8k0+/Pd3hFHOSa978yKzUufCLhrrDmj6R2Qg5key3GWtG4Sf0oTkzEYz6mOkqH1lVgpvG8cD5ZUedDOItTQ4ueFNKOWqdrnt2q0ZNcs7QQas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GDSu/v5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GDSu/v5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE2C113D0;
	Mon,  3 Nov 2025 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762193004;
	bh=jmGEaZf4AYi4I/lNyEdbjBZMHllthImoE14viZT5lp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDSu/v5MKF/LD14rOdo8ntC1n9b3LsB2i3H6c69FhJflVJ2u5tn6aXyq9AuIz48R2
	 /mMvfWPJCIK9ZUD5PhpOtDVKwlSX1lNT/yPcJj40H3S8mddEYPVidIEci5pNYKbo7r
	 onBzQCsnxDEKvusPnPlSF9de/3EJfNuc0hdFMtwDN1e0ML3/44NU55qGzN5jkA3kCO
	 g6fKywHtb2hCbK3kw2DTEY7+Yd5wfb4hktG40Yv14tHRrKaueH+XYH3tDnQ++AMVcr
	 Jx/Dhv1hPDRxnWwScpJ1OaXyh3ADP+vok/CslkkGQCrB9zcNA/Fx8JQ1BySvoWnX/x
	 wARyFrfEqr4ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	dave.hansen@linux.intel.com,
	mario.limonciello@amd.com,
	riel@surriel.com,
	yazen.ghannam@amd.com,
	xin@zytor.com,
	alexandre.f.demers@gmail.com,
	darwi@linutronix.de,
	sandipan.das@amd.com
Subject: [PATCH AUTOSEL 6.17] x86/CPU/AMD: Extend Zen6 model range
Date: Mon,  3 Nov 2025 13:02:31 -0500
Message-ID: <20251103180246.4097432-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

[ Upstream commit 847ebc4476714f81d7dea73e5ea69448d7fe9d3a ]

Add some more Zen6 models.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251029123056.19987-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me compile my comprehensive analysis:

## ANALYSIS RESULTS

**ANSWER: YES**

This commit should be backported to stable kernel trees.

### Detailed Analysis

#### 1. Semantic Code Analysis Performed

**Tools Used:**
- `mcp__semcode__find_function`: Located the `bsp_init_amd` function
  (arch/x86/kernel/cpu/amd.c:421-542)
- `mcp__semcode__find_callers`: Determined that `bsp_init_amd` is called
  indirectly via function pointer in `amd_cpu_dev` structure
- `Grep` and git analysis: Examined usage patterns and historical
  context

**Key Findings:**
- The function `bsp_init_amd` is called during early CPU initialization
  as part of the AMD CPU detection chain
- No direct callers found by semantic analysis because it's invoked via
  the `.c_bsp_init` callback in the CPU vendor structure
- X86_FEATURE_ZEN6 is currently only set by this detection code and not
  yet actively consumed by other subsystems

#### 2. Code Change Analysis

The commit modifies a single line in `arch/x86/kernel/cpu/amd.c`:

```c
case 0x50 ... 0x5f:
-case 0x90 ... 0xaf:
+case 0x80 ... 0xaf:  // Extends range to include models 0x80-0x8f
case 0xc0 ... 0xcf:
    setup_force_cpu_cap(X86_FEATURE_ZEN6);
```

This extends the Zen6 model range from `0x90...0xaf` to `0x80...0xaf`,
adding 16 new CPU models (0x80-0x8f) to the Zen6 detection.

#### 3. Impact Without This Fix

On Zen6 CPUs with models 0x80-0x8f running stable kernels without this
patch:

1. **CPU Misidentification**: The CPU won't be recognized as Zen6
   architecture
2. **Kernel Warning**: The code falls through to the `warn:` label (line
   541), triggering: `WARN_ONCE(1, "Family 0x%x, model: 0x%x??\n",
   c->x86, c->x86_model);`
3. **Missing Optimization**: X86_FEATURE_ZEN6 won't be set, potentially
   causing the CPU to miss Zen6-specific optimizations, workarounds, or
   features
4. **Future Code Impact**: Any future kernel code that checks for
   X86_FEATURE_ZEN6 won't activate for these CPUs

#### 4. Historical Precedent

Analysis of similar commits shows a clear pattern of backporting:

**Commit 3b491b102cd2c** (Zen5 model addition):
- Added models 0x10-0x1f to Zen5 range
- Contains `Fixes: 3e4147f33f8b` tag
- Was backported to stable (upstream 2718a7fdf292b)

**Commit b348eac11cb3f** (Zen5 model addition):
- Added models 0x60-0x6f to Zen5 range
- Contains `[ Upstream commit bf5641eccf71b ]` indicating stable
  backport
- Signed-off-by Sasha Levin for stable

**Pattern**: AMD CPU model range extensions have consistently been
backported to stable kernels.

#### 5. Backport Suitability Assessment

**Meets Stable Tree Criteria:**
- ✅ **Bug Fix**: Fixes CPU misidentification for existing hardware
- ✅ **Hardware Enablement**: Enables proper detection of new Zen6 CPU
  models
- ✅ **Small & Contained**: Single-line change, minimal scope
- ✅ **Low Risk**: Only affects CPU model detection, no architectural
  changes
- ✅ **No New Features**: Doesn't add functionality, just extends
  existing detection
- ✅ **User Impact**: Users with new Zen6 CPUs will see kernel warnings
  without this

**Risk Assessment:**
- Change is trivial (range extension: `0x90` → `0x80`)
- No dependencies on other commits
- No behavioral changes to existing code paths
- Cannot cause regressions on CPUs outside the 0x80-0x8f range

#### 6. Why No Stable Tags?

The commit lacks explicit `Cc: stable@vger.kernel.org` or `Fixes:` tags,
likely because:
- It was committed recently (October 29, 2025) as v6.18-rc4 material
- AMD maintainers may expect autoselection for stable based on
  historical patterns
- The fix addresses newly released hardware that may not yet be in
  users' hands

However, the pattern of similar commits being backported and the nature
of the fix (hardware enablement for released products) strongly
indicates this should go to stable.

### Recommendation

**Backport Status: YES**

This commit should be backported to all stable kernel versions that
contain the X86_FEATURE_ZEN6 infrastructure (introduced in commit
24ee8d9432b57, first appearing in v6.15). This ensures users with new
Zen6 CPU models receive proper hardware support without kernel warnings.

 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a11e17f3b4b1b..e7e3a6fc6153a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -516,7 +516,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		case 0x50 ... 0x5f:
-		case 0x90 ... 0xaf:
+		case 0x80 ... 0xaf:
 		case 0xc0 ... 0xcf:
 			setup_force_cpu_cap(X86_FEATURE_ZEN6);
 			break;
-- 
2.51.0

