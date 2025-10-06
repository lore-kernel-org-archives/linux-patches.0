Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6272D5C74;
	Mon,  6 Oct 2025 18:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774747; cv=none; b=fiz41OVa7XrgVkFr/iiXw6Q4SG5FkNxTPgQkjX4pUrgafUXDDGbtrLxZ9Xcb8WOSeqhmqG8zVTILQJ6TH+vbKC8hLSkDsvGekOmBQiwR8podTBfaGmEYaJbDJ2Ujhyvbr4Dq9hT/KzO63IJHqOW2u+i716MHHJTD/u7YEqftFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774747; c=relaxed/simple;
	bh=m4Fpy/eWBeFnq1vn1TOoSnON6AnHjmMBWnutn6UkkzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BEkuwJtCe9HBQq/0a1cHveBIhK4Assi69uno6uf1Ku+94Neoy8mYyvk8JvaFM4n3jLNoUZIOWmm/AMAvdGWrVS/+/316QNyX8RzLUfaiS0I9C8dYuJzvp+bNhVwVgkZI84AlJ9s/3fHRUBVac1i5G8/vWdzFsxIAk+B+coUnW60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAy922mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAy922mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D3FC116B1;
	Mon,  6 Oct 2025 18:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774745;
	bh=m4Fpy/eWBeFnq1vn1TOoSnON6AnHjmMBWnutn6UkkzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAy922mGwl9NQdPSczyyqlQ2g6RAGaDJVUT2PsecxBRYRr+oVe5TrBHWlz6RB/Rch
	 vSy+wNeBY0kXQDL5rU+5dwB2sOTSJe699kuBA1zW8nEn1LfiW3mEKRDt0afaudfbGF
	 qH9HstRbRdHA/jeKn/tYX0V63wT4G+56dQwV+j/U4So7r3uHIj14lE4wFWe0BeLuEL
	 fpMBZUEEtMdTCBFhfqIf3R2lYJMTu7UuDrSciL387F4tsW+ODtQ4cKwOshiHtF2R+9
	 VAo3jmZ8ov0y2pgnhA1uYT/YqgI4fRVEJb7Yw3mG5yOQ/XSjY+d80to0S7Yl2crmn5
	 HFSgOCpSX3k5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org
Subject: [PATCH AUTOSEL 6.17] x86/bugs: Add attack vector controls for VMSCAPE
Date: Mon,  6 Oct 2025 14:17:38 -0400
Message-ID: <20251006181835.1919496-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Kaplan <david.kaplan@amd.com>

[ Upstream commit 5799d5d8a6c877f03ad5b5a640977053be45059a ]

Use attack vector controls to select whether VMSCAPE requires mitigation,
similar to other bugs.

Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## YES

This commit should be backported to stable kernel trees.

### Comprehensive Analysis:

#### Background Context:
**VMSCAPE (CVE-2025-40300)** is a recently disclosed Spectre-based
vulnerability discovered by ETH Zurich researchers that exploits
insufficient branch predictor isolation between guest VMs and userspace
hypervisors like QEMU. It affects AMD Zen 1-5 and Intel Coffee Lake
CPUs, allowing guests to leak arbitrary memory from the hypervisor at
~32 bytes/second with 98.7% accuracy.

The vulnerability was introduced with its mitigation (conditional IBPB
on VM-exit) in upstream commit 2f8f173413f1, and has been backported to
stable trees as evidenced by commit d83e6111337f3 in
arch/x86/kernel/cpu/bugs.c:3307-3315.

#### What This Commit Does:

**Code Changes Analysis:**

1. **In should_mitigate_vuln() (arch/x86/kernel/cpu/bugs.c:417+):**
   - Adds case for `X86_BUG_VMSCAPE` that returns true when
     `CPU_MITIGATE_GUEST_HOST` attack vector is enabled
   - This integrates VMSCAPE into the unified attack vector control
     framework

2. **In vmscape_select_mitigation()
   (arch/x86/kernel/cpu/bugs.c:3307-3316):**
   - **Removes** the `cpu_mitigations_off()` check from line 3307
   - **Replaces** unconditional AUTO→IBPB_EXIT_TO_USER assignment with
     conditional logic:
     ```c
     if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
     if (should_mitigate_vuln(X86_BUG_VMSCAPE))
     vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
     else
     vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
     }
     ```

3. **Documentation update:** Adds VMSCAPE to the attack vector controls
   table showing Guest-to-Host (X) as the relevant attack vector

#### Behavioral Changes:

**Before this commit:**
- VMSCAPE mitigation disabled if: `cpu_mitigations_off()` OR no VMSCAPE
  bug OR no IBPB support
- Otherwise in AUTO mode: **Always enables** IBPB_EXIT_TO_USER
  mitigation

**After this commit:**
- VMSCAPE mitigation disabled if: no VMSCAPE bug OR no IBPB support
- In AUTO mode: Enables mitigation **only if** CPU_MITIGATE_GUEST_HOST
  attack vector is enabled
- Respects attack vector controls like
  `mitigations=auto,guest_to_host=off`

This change allows users to disable VMSCAPE mitigation via attack vector
controls (e.g., `mitigations=auto,guest_to_host=off`) instead of
requiring the global `mitigations=off`, providing **more granular
security control**.

#### Why This Should Be Backported:

1. **Completes Security Infrastructure:** VMSCAPE was already backported
   to stable (commit d83e6111337f3), but without attack vector control
   integration. This creates an **inconsistency** where all other
   vulnerabilities (Spectre_v2, Retbleed, L1TF, ITS, SRSO, SSB, etc.)
   use attack vector controls while VMSCAPE still uses the deprecated
   `cpu_mitigations_off()` approach.

2. **Small, Self-Contained Change:** Only 15 lines changed across 2
   files, with all dependencies already present in stable:
   - Attack vector framework: Already in stable (commits 2d31d2874663c
     and later)
   - VMSCAPE bug definition: Already in stable (X86_BUG_VMSCAPE)
   - should_mitigate_vuln() function: Already in stable

3. **Part of Coordinated Refactoring:** This is followed by commit
   440d20154add2 "x86/bugs: Remove uses of cpu_mitigations_off()" which
   removes the now-obsolete `cpu_mitigations_off()` checks. Without this
   commit, VMSCAPE would be the **only** vulnerability still using the
   old approach.

4. **Security Control Improvement:** Enables proper Guest-to-Host attack
   vector control for CVE-2025-40300, allowing cloud providers to make
   informed risk decisions rather than requiring all-or-nothing
   mitigation choices.

5. **No Regression Risk:** The change is confined to the VMSCAPE
   mitigation path. Default behavior remains secure (mitigation enabled
   in AUTO mode with default attack vector settings). Users who
   explicitly disabled mitigations will see consistent behavior across
   all vulnerabilities.

6. **Follows Stable Tree Criteria:**
   - ✅ Fixes important functional issue (inconsistent mitigation
     control)
   - ✅ Small and obviously correct
   - ✅ No major architectural changes
   - ✅ Security infrastructure improvement
   - ✅ Already selected by AUTOSEL (commit c853b338b012a in linux-
     autosel-6.17)

7. **Merged for 6.18:** The commit was merged via tag
   `x86_bugs_for_v6.18_rc1` (commit d7ec0cf1cd79a), indicating it's part
   of the stable security infrastructure for upcoming releases.

#### Dependencies Met:
All prerequisites are already in stable trees:
- ✅ Attack vector control framework (2d31d2874663c and subsequent
  commits)
- ✅ VMSCAPE vulnerability enumeration (d83e6111337f3)
- ✅ VMSCAPE mitigation infrastructure (510603f504796)
- ✅ cpu_attack_vector_mitigated() helper functions

**Recommendation: YES** - Backport to stable kernels that have VMSCAPE
mitigation (6.17+) to complete the attack vector control integration and
maintain consistency with other CPU vulnerability mitigations.

 .../admin-guide/hw-vuln/attack_vector_controls.rst |  1 +
 arch/x86/kernel/cpu/bugs.c                         | 14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst b/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst
index 5964901d66e31..d0bdbd81dcf9f 100644
--- a/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst
+++ b/Documentation/admin-guide/hw-vuln/attack_vector_controls.rst
@@ -218,6 +218,7 @@ SRSO                  X              X            X              X
 SSB                                  X
 TAA                   X              X            X              X            *       (Note 2)
 TSA                   X              X            X              X
+VMSCAPE                                           X
 =============== ============== ============ ============= ============== ============ ========
 
 Notes:
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 36dcfc5105be9..e817bbae01591 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -434,6 +434,9 @@ static bool __init should_mitigate_vuln(unsigned int bug)
 	case X86_BUG_SPEC_STORE_BYPASS:
 		return cpu_attack_vector_mitigated(CPU_MITIGATE_USER_USER);
 
+	case X86_BUG_VMSCAPE:
+		return cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST);
+
 	default:
 		WARN(1, "Unknown bug %x\n", bug);
 		return false;
@@ -3304,15 +3307,18 @@ early_param("vmscape", vmscape_parse_cmdline);
 
 static void __init vmscape_select_mitigation(void)
 {
-	if (cpu_mitigations_off() ||
-	    !boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
+	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
 	    !boot_cpu_has(X86_FEATURE_IBPB)) {
 		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 		return;
 	}
 
-	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO)
-		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
+	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
+		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
+			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
+		else
+			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+	}
 }
 
 static void __init vmscape_update_mitigation(void)
-- 
2.51.0

