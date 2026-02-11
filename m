Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97FF2AD35;
	Wed, 11 Feb 2026 12:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813078; cv=none; b=Cu+swiHsiuxYwCfHfwimblztsfAlWmQwRtaDBQ1ziLgAacK8b/8B0iIHwQ5Ms5hWkE8+av6iowDtLitP+1HmmNPPbMWwAhTe2iN1MtfRsbPlM2l1zoFtrrJ9q61Ukv8QFxGfR3JTCxDGGk/1EaByr7T6Tae8v5uLw9/pYt0lf9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813078; c=relaxed/simple;
	bh=PYy+vo3DcZ0NMq3ITwLdNWEhlm5HuivMSn6EHYGd65s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2O64/8Ay5ptZXGbBncZmAkbPZ3hSKMvIGwc3KPfCv8V9RUFXlOqZwz24Wr2E6Y24h9HWxOJXAKbaQrE0q4AfKPivpIUkKsoL7w8+2hgN4NE0LnCzQpLoRB22bRdwF1ZRZkMdy6B83GnC8zbiIAE9GA6oQCUor+S+U+GPxtSXAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3p9KokZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3p9KokZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69998C19421;
	Wed, 11 Feb 2026 12:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813077;
	bh=PYy+vo3DcZ0NMq3ITwLdNWEhlm5HuivMSn6EHYGd65s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3p9KokZn2I/yFg/PfoUkbSqiW9rPOdRDL5TGff0k0vQNfus1OgpySB8XwycLTn7Q
	 fs4ZliN8AhhEie0Y/eHXi3N4gFHUYXmoFUzDaEtVJFjUpZV50PJHWb9CbPJifL6752
	 6a9HWDIfbrsD9EYaor2ogpLCqxg0zgbVF5H+4RVymJpfLoxCRWRIRxFquJb2GmOi4o
	 41NCJKOZf0Bg36e1Io8BK+Sa8KXqosf5b2BummRnEMAeCItTxgfEWVutbqMx02Ajl1
	 LRtFmAObVcfczeVzYREze6uPBoFvEhTO1YWiKJfdmXDGq0zzOiJCZXHlUjucK+jRLa
	 TKc6Bqyc7ESew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jinqian Yang <yangjinqian1@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	dianders@chromium.org,
	shechenglong@xfusion.com,
	skolothumtho@nvidia.com
Subject: [PATCH AUTOSEL 6.19-5.10] arm64: Add support for TSV110 Spectre-BHB mitigation
Date: Wed, 11 Feb 2026 07:30:12 -0500
Message-ID: <20260211123112.1330287-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
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

From: Jinqian Yang <yangjinqian1@huawei.com>

[ Upstream commit e3baa5d4b361276efeb87b20d8beced451a7dbd5 ]

The TSV110 processor is vulnerable to the Spectre-BHB (Branch History
Buffer) attack, which can be exploited to leak information through
branch prediction side channels. This commit adds the MIDR of TSV110
to the list for software mitigation.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have all the information needed for a thorough analysis. Here is
my complete assessment.

---

## Comprehensive Analysis: arm64: Add support for TSV110 Spectre-BHB
mitigation

### 1. COMMIT MESSAGE ANALYSIS

The commit explicitly states that the HiSilicon TSV110 processor is
vulnerable to Spectre-BHB (Branch History Buffer) attacks. It adds the
TSV110 MIDR to the software mitigation loop list with k=32 iterations.
This is a **security vulnerability fix** — Spectre-BHB is a well-known
speculative execution side-channel attack (related to CVE-2022-23960).

The commit follows the exact same pattern as `e18c09b204e81` ("arm64:
Add support for HIP09 Spectre-BHB mitigation") by the same author
(Jinqian Yang from Huawei), reviewed by Zenghui Yu and signed off by
Will Deacon (the arm64 maintainer). The authorship chain is highly
credible.

### 2. CODE CHANGE ANALYSIS

The change is a **single line addition**:

```c
MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
```

added to the `spectre_bhb_k32_list` array inside
`spectre_bhb_loop_affected()` in `arch/arm64/kernel/proton-pack.c`.

**What this does in detail:**

Without this patch, the TSV110 CPU goes through this logic:

1. `is_spectre_bhb_affected()` is called (line 972-992):
   - `supports_csv2p3()` → false (TSV110 doesn't support CSV2P3)
   - `is_spectre_bhb_safe()` → false (TSV110 is NOT in
     `spectre_bhb_safe_list` at lines 840-851)
   - Returns **true** — TSV110 IS considered BHB-affected
   - BUT `spectre_bhb_loop_affected()` returns **k=0** (TSV110 is not in
     any k-list)

2. `spectre_bhb_enable_mitigation()` is called (line 1024-1090):
   - `is_spectre_bhb_affected()` returns true → doesn't bail out
   - TSV110 is in `spectre_v2_safe_list` (line 157), so v2 state is
     UNAFFECTED, not VULNERABLE → continues past line 1033
   - `supports_ecbhb()` → likely false
   - `supports_clearbhb()` → likely false
   - **Line 1051: `spectre_bhb_loop_affected()` returns 0 (falsy) → loop
     mitigation NOT applied**
   - Falls through to `has_spectre_bhb_fw_mitigation()` → depends on
     firmware
   - If firmware doesn't support ARCH_WORKAROUND_3: **state remains
     `SPECTRE_VULNERABLE`**

**Result without patch:** TSV110 is recognized as BHB-vulnerable but
receives NO software mitigation (k=0 means the loop mitigation can't
activate). The system reports `Vulnerable` in
`/sys/devices/system/cpu/vulnerabilities/spectre_v2`.

**With this patch:** `spectre_bhb_loop_affected()` returns k=32, the
loop mitigation at line 1051 activates, `EL1_VECTOR_BHB_LOOP` vectors
are installed, and the system reports `Mitigated`.

### 3. SECURITY IMPACT

- **Spectre-BHB (CVE-2022-23960)** is a serious speculative execution
  vulnerability that allows information leakage through branch
  prediction side channels
- The TSV110 (Taishan v110) is the CPU core used in **HiSilicon Kunpeng
  920** server SoCs, which are widely deployed in data centers,
  especially in China
- Without this fix, these servers are **left unmitigated** against a
  known speculative execution attack
- The vulnerability is exploitable from userspace to leak kernel memory

### 4. DEPENDENCY ANALYSIS

The commit depends on the refactored code structure from commit
`e403e8538359d` ("arm64: errata: Assume that unknown CPUs _are_
vulnerable to Spectre BHB"), which:
- Has `Cc: stable@vger.kernel.org` and `Fixes: 558c303c9734`
- Is explicitly tagged for stable backporting
- Was followed by `0c9fc6e652cd5` (KRYO safe list), `a5951389e58d2`
  (newer ARM cores), and `fee4d171451c1` (missing sentinels fix) — all
  tagged for stable

The `MIDR_HISI_TSV110` macro was introduced in v5.1-rc2 (commit
`efd00c722ca85`, March 2019) and is present in **all active stable
trees** (5.4+, 5.10+, 5.15+, 6.1+, 6.6+, 6.12+).

The only dependency is that the `spectre_bhb_loop_affected()` function
needs to be in its refactored form (from `e403e8538359d`), which is
already bound for stable. If that dependency is present, this one-liner
applies cleanly.

### 5. SCOPE AND RISK ASSESSMENT

- **Size:** 1 line addition — the absolute minimum change possible
- **Risk:** Essentially zero. Adding a MIDR to an existing static array
  cannot break any other CPU. The MIDR matching is exact — only TSV110
  cores will match
- **Files touched:** 1 file (`arch/arm64/kernel/proton-pack.c`)
- **Pattern:** Identical to `e18c09b204e81` (HIP09 BHB, same author) and
  `a5951389e58d2` (newer ARM cores) — both already in the stable
  pipeline

### 6. USER IMPACT

- **Affected users:** Anyone running Linux on HiSilicon Kunpeng 920
  servers (Taishan v110 cores)
- **Severity:** High — speculative execution vulnerabilities allow
  kernel memory leaks from unprivileged userspace
- **Real-world deployment:** Kunpeng 920 is deployed in production data
  centers and cloud environments
- **Without fix:** Systems report `Vulnerable` for Spectre-v2/BHB and
  have no software mitigation

### 7. STABILITY INDICATORS

- **Reviewed-by:** Zenghui Yu (active arm64 reviewer)
- **Signed-off-by:** Will Deacon (arm64 co-maintainer)
- **Same pattern as HIP09 commit** that was already accepted
- The TSV110 MIDR has been in the kernel since 2019 — extremely well-
  known hardware
- The k=32 value is consistent with other ARMv8.2 era cores in the same
  list (A78, X1, Neoverse V1)

### 8. CLASSIFICATION

This commit is categorized as a **hardware-specific security mitigation
addition** — analogous to adding a device ID to an existing driver. The
Spectre-BHB mitigation framework already exists; this simply adds one
more CPU to the list of CPUs that need it. This falls squarely into the
"hardware quirks/workarounds for broken devices" exception category for
stable trees.

### Summary

This is a one-line security fix that adds the HiSilicon TSV110 (Kunpeng
920) processor to the Spectre-BHB software mitigation list with k=32.
Without it, TSV110 systems are left vulnerable to a known speculative
execution attack (CVE-2022-23960). The change is trivially correct
(adding one MIDR entry to a static array), has zero risk of regression
for any other CPU, follows an established pattern (identical to HIP09),
and was reviewed by the arm64 maintainer. It depends on the
`e403e8538359d` refactoring already tagged for stable. The affected
hardware (Kunpeng 920) is deployed in real production environments.

**YES**

 arch/arm64/kernel/proton-pack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 80a580e019c50..b3801f532b10b 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -887,6 +887,7 @@ static u8 spectre_bhb_loop_affected(void)
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
+		MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
 		{},
 	};
 	static const struct midr_range spectre_bhb_k24_list[] = {
-- 
2.51.0

