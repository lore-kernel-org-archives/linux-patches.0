Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4C82EF67F;
	Thu,  9 Oct 2025 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025520; cv=none; b=WjRsH/YMoXEtwfb0fhwGVmRnqY5KL0NkKKm4TikpaaJSBqH3VOyBYLBb5+wwpJO0S8x+4CVKCPbxPerKNeJY/Dx4bKHb/qdJnYWYnmJjlOfJFLWTlg+pKs/lIvaGGPcygN0NmU2Iv+oliBYotjiIqhMxHG7FvwLuZpaqKgDQc80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025520; c=relaxed/simple;
	bh=H7KnZhwYsUdvCh2bJj+GL+r/EWZY/yvsnJSvk+JpiQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nH6i0RW+nBWCct2qtqWGIDOPz5rcGXocCJceC/TAD1FWzeyI5HJFGIn5K1/+TTMXepPIs791Brs2myb+JAnLz2nPJXkELFLdMvJjARpV5UDowCgf4B2ZnZ8sF7k7/33at/Zm2t3aGQIbX5I0IO7Kg5avrSjni2H/DD1ZVCzhu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsWP6SWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsWP6SWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F72C4CEF7;
	Thu,  9 Oct 2025 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025520;
	bh=H7KnZhwYsUdvCh2bJj+GL+r/EWZY/yvsnJSvk+JpiQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsWP6SWJKf6yuqdb7+itZJjszFONNuznymTloAOr8Jtbwy0vSJAYE314QuTt3seab
	 HyDRLmypOJmUnZiPfwJBGl9kqa5U+nVoaR/NYrZ43SDHrQwu8hPX/7b4MUgyHxdbLi
	 n9lLLVLgBWJcFkSb2Av5x/jrSit5nh23sk+8syLXtMdF4N5Sp1xygdOz26MZFEM5mW
	 K6uFKEWblCEQagFsNUpLWoJjSumHtnkbhLIAWRYfHG68KRQFwu/w5ZIvCZ+cCkdtAx
	 8rZuW+4eox+j5Z3y+21/YzZpJ2soDcx5FIPd+KMOt9QNOs37QnwTcYvihAg1kwZSs0
	 Df6QBvN7gRDJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	akpm@linux-foundation.org,
	wangyuli@uniontech.com,
	chelsyratnawat2001@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] thermal: intel: selftests: workload_hint: Mask unsupported types
Date: Thu,  9 Oct 2025 11:54:53 -0400
Message-ID: <20251009155752.773732-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 0115d063559fa6d25e41751cf455dda40aa2c856 ]

The workload hint may contain some other hints which are not defined.
So mask out unsupported types. Currently only lower 4 bits of workload
type hints are defined.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250828201541.931425-1-srinivas.pandruvada@linux.intel.com
[ rjw: Subject cleanup ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT RECOMMENDATION: **YES**

### Executive Summary
This commit should be backported to stable kernel trees. It fixes a real
correctness issue in the Intel thermal workload_hint selftest that can
cause false "Invalid workload type index" errors when firmware sets
undefined upper bits in the workload hint value.

### Detailed Analysis

#### Code Change Analysis
The commit adds a single line (`index &= 0x0f;`) at line 147 of
`workload_hint_test.c` that masks the workload type index to only the
lower 4 bits before validation. This occurs in the main polling loop
after reading the workload_type_index from sysfs.

**Location in code flow:**
```c
ret = sscanf(index_str, "%d", &index);
if (ret < 0)
    break;

index &= 0x0f;  // NEW LINE - masks to lower 4 bits

if (index > WORKLOAD_TYPE_MAX_INDEX)
    printf("Invalid workload type index\n");
else
    printf("workload type:%s\n", workload_types[index]);
```

#### Technical Context

1. **Feature Background**: The workload_hint feature was introduced in
   v6.7 (August 2023) for Intel Meteor Lake and newer processors. The
   firmware predicts workload type (idle, battery_life, sustained,
   bursty) and exposes it via MMIO register bits 47:40.

2. **Driver Implementation**: In `processor_thermal_wt_hint.c:73`, the
   kernel driver extracts the workload hint using:
  ```c
  wt = FIELD_GET(SOC_WT, status);  // SOC_WT = GENMASK_ULL(47, 40)
  ```
  This extracts all 8 bits (0-255 possible values) and exposes them to
  userspace via sysfs without any masking.

3. **Specification**: According to the commit message, "Currently only
   lower 4 bits of workload type hints are defined." This means:
   - Bits 0-3: Defined workload types (0=idle, 1=battery_life,
     2=sustained, 3=bursty)
   - Bits 4-7: Undefined/reserved (may be used by firmware for future
     extensions or debugging)

4. **The Bug**: Without the mask, if firmware sets any upper bits (e.g.,
   returns 0x12 = 18):
   - Test reads index=18
   - Check `18 > WORKLOAD_TYPE_MAX_INDEX (3)` triggers
   - Prints "Invalid workload type index"
   - **Incorrect behavior**: The actual workload type is 0x12 & 0x0f = 2
     (sustained)

5. **With the Fix**: Same scenario with mask:
   - Test reads index=18
   - Masks to `18 & 0x0f = 2`
   - Check `2 > 3` passes
   - Prints "workload type:sustained"
   - **Correct behavior**: Properly identifies the workload type

#### Evidence of Real-World Impact

1. **Platform Expansion**: The feature has been extended to Lunar Lake
   and Panther Lake processors (commit b59bd75a4b098, December 2024),
   increasing the likelihood of encountering firmware variations.

2. **Already Selected for Backporting**: The AUTOSEL process has already
   selected this for stable backporting (commit 61100458645b2, signed by
   Sasha Levin on Oct 3, 2025), indicating it meets automated stable
   selection criteria.

3. **Firmware Behavior**: The commit message states "The workload hint
   may contain some other hints which are not defined," indicating this
   is based on actual firmware specification knowledge, not theoretical
   concerns.

#### Stable Kernel Rules Compliance

✅ **Rule 1 - Already in mainline**: Commit 0115d063559fa is in mainline
✅ **Rule 2 - Obviously correct**: Simple bit mask operation, well-
understood
✅ **Rule 3 - Size limit**: 2 lines added, well under 100-line limit
✅ **Rule 4 - Fixes real bug**: Prevents incorrect "Invalid" errors for
valid firmware values
✅ **Rule 5 - User impact**: Affects selftest correctness, important for
validation on stable kernels

#### Risk Assessment

**Risk Level: MINIMAL**

- Single line addition with clear purpose
- No changes to kernel driver code (only selftest)
- No dependencies on other commits
- Cannot cause regressions in kernel functionality
- Makes test more robust against firmware variations
- Simple bitwise AND operation with well-defined behavior

#### Backporting Priority

**Priority: MEDIUM**

- **Not critical**: Doesn't fix a crash, security issue, or data
  corruption
- **Important for correctness**: Ensures selftest provides accurate
  validation
- **Growing relevance**: As feature extends to more Intel platforms,
  correct test behavior becomes more important
- **Low risk, high value**: Simple fix that improves test reliability

### Recommendation Justification

This commit should be backported because:

1. **Fixes incorrect behavior**: The test currently can produce false
   "Invalid" errors for legitimate firmware values
2. **Based on specification**: The fix aligns with the documented bit
   layout (only lower 4 bits defined)
3. **Defensive programming**: Properly handles firmware that sets
   reserved bits
4. **Active feature**: Being extended to new platforms, making correct
   testing increasingly important
5. **Already selected**: AUTOSEL has identified this as worthy of
   backporting
6. **Precedent**: Other selftest fixes are regularly backported to
   stable kernels
7. **Zero risk**: Cannot introduce regressions in kernel functionality

The fix ensures that users running stable kernels can accurately
validate their Intel thermal workload_hint functionality without
encountering spurious "Invalid" messages when firmware follows the
specification by using all 8 bits while only the lower 4 are currently
defined.

 .../selftests/thermal/intel/workload_hint/workload_hint_test.c  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c b/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
index ba58589a11454..ca2bd03154e4d 100644
--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
+++ b/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -144,6 +144,8 @@ int main(int argc, char **argv)
 			ret = sscanf(index_str, "%d", &index);
 			if (ret < 0)
 				break;
+
+			index &= 0x0f;
 			if (index > WORKLOAD_TYPE_MAX_INDEX)
 				printf("Invalid workload type index\n");
 			else
-- 
2.51.0

