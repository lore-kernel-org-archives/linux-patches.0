Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F19C194AD7;
	Wed, 11 Feb 2026 12:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813133; cv=none; b=jMjtlUjn8uVOOJ5x83s1jNmRVLySrY99Vwe9yqomYrrMG1jvFbDn3V+P49P2bJM1PNMPvvgVSsrQ+pAWbhVlbvxbyjQ4noBjKN93ePKPxBFZsuR0ni3g6l/sVidhpIzvzEFzvVpu71v74FeZk3SWc5wQDflvkPZ86v8nzQIpzGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813133; c=relaxed/simple;
	bh=idBWF2zb6XEB59Tr2/abV7HXa0hVIyvwISGtDkK1SQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fSDUOwbftk5kk8jVA5yu+RWa4x0hjRZJruLyvwQefz1dJZ4hWtcFqLEQ6P42y/N9L+g9JfIf8d4E6ZiWrV+hdeB/k9LX7xxxWB4b9DKiHRiwJWl+e2vOW9eWs0seS3taHxv6ujDFKhglWd0NwZVkV0J9x2sE9PVbyGNxnMIsxZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmp934x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmp934x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E01C19421;
	Wed, 11 Feb 2026 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813133;
	bh=idBWF2zb6XEB59Tr2/abV7HXa0hVIyvwISGtDkK1SQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmp934x250kmRIkrZLWGQ94CTj5tm/yJu5BobSGVlEcx4ZG0/f2LEPv84wO1jZptU
	 fAV+qgsQ/XtlU3ciNc4EuueBZEQdeMGLNfO6LsL2gJoYUnYVHN/hatFWmn35vrbaqh
	 RQIPc8oYL4iCxN5/zQ4wjI+jciOTQvMPSyGQCvXLcoRP4OGkKprWBktW+n1qjkN92k
	 QFO9ka9eRmYhHTOrDeTdKuePnta5Oz5KmK294egyYStAXwNbPed/Tx1X8iE6ICIsJj
	 wywx44K1yANl1a8+BLXC3P1DiG1qUE0jZD2lcoe+IDl+6W4VofPX7vLIGb4oobSxnr
	 EdxZ0cFhH/4vQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	fj5851bi@fujitsu.com
Subject: [PATCH AUTOSEL 6.19-6.18] tools/cpupower: Fix inverted APERF capability check
Date: Wed, 11 Feb 2026 07:30:38 -0500
Message-ID: <20260211123112.1330287-28-sashal@kernel.org>
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

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 24858a84163c8d04827166b3bcaed80612bb62fc ]

The capability check was inverted, causing the function to return
error when APERF support is available and proceed when it is not.

Negate the condition to return error only when APERF capability
is absent.

Link: https://lore.kernel.org/r/20251126091613.567480-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write my analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is crystal clear: "The capability check was inverted,
causing the function to return error when APERF support is available and
proceed when it is not." This is a straightforward logic inversion bug
fix.

### 2. Code Change Analysis

The change is a **single-character fix** — adding `!` to negate a
condition:

```273:274:tools/power/cpupower/utils/cpufreq-info.c
        if (cpupower_cpu_info.caps & CPUPOWER_CAP_APERF)
                return -EINVAL;
```

becomes:

```c
        if (!(cpupower_cpu_info.caps & CPUPOWER_CAP_APERF))
                return -EINVAL;
```

### 3. Bug Origin and Root Cause

The bug was introduced by commit `26e16174f54d4` ("cpupower: Don't try
to read frequency from hardware when kernel uses aperfmperf"), authored
by Mario Limonciello (AMD) and merged for v6.14-rc1. That commit
intended to skip hardware frequency reading when APERF/MPERF is in use
(for amd-pstate), but the condition was written **backwards**.

### 4. Proof That the Condition is Inverted

The evidence is overwhelming:

**a) Consistency with all other APERF checks in the same codebase:**

In `nhm_idle.c` line 176:
```c
if (!(cpupower_cpu_info.caps & CPUPOWER_CAP_APERF))
    return NULL;
```

In `mperf_monitor.c` line 334:
```c
if (!(cpupower_cpu_info.caps & CPUPOWER_CAP_APERF))
    return NULL;
```

Both return error when APERF is **absent** (using `!`). The buggy
`get_freq_hardware()` was the only place doing the opposite — returning
error when APERF **is present**.

**b) Logical analysis of `get_freq_hardware()`:** The function reads
hardware frequency via `cpufreq_get_freq_hardware()` which reads
`cpuinfo_cur_freq` from sysfs. APERF/MPERF is the mechanism by which the
kernel determines actual hardware frequency. When APERF IS available,
the kernel CAN report accurate hardware frequency — so the function
SHOULD proceed. When APERF is NOT available, it SHOULD return error.

**c) Caller context in `debug_output_one()`:**

```516:517:tools/power/cpupower/utils/cpufreq-info.c
        if (get_freq_hardware(cpu, 1) < 0)
                get_freq_kernel(cpu, 1);
```

With the bug: On ALL modern x86 CPUs (which have APERF),
`get_freq_hardware()` always returns -EINVAL, so `cpupower frequency-
info -w` (hardware frequency query) always fails, and debug mode always
falls back to kernel frequency. The `--hwfreq`/`-w` option is completely
broken on modern systems.

With the fix: The function correctly reads hardware frequency when APERF
is available, and returns error (falling back to kernel method) only on
systems without APERF support.

### 5. Impact Assessment

- **Who is affected:** Virtually ALL modern x86 CPU users (Intel and
  AMD) since they all have APERF/MPERF. The `CPUPOWER_CAP_APERF` is set
  when `cpuid_ecx(6) & 0x1` (CPUID leaf 6, ECX bit 0 = APERF
  availability), which has been present in x86 CPUs for well over a
  decade.
- **What breaks:** `cpupower frequency-info --hwfreq` (`-w`) always
  returns error on modern CPUs. The default debug output (`cpupower
  frequency-info` or `-e`) never shows hardware-asserted frequency and
  always falls back to kernel frequency.
- **Severity:** The `cpupower` tool is a userspace utility used for CPU
  frequency monitoring and tuning. This bug makes a core feature
  completely non-functional. It's not a kernel crash, but it's a real
  functional breakage of an important diagnostic tool.

### 6. Scope and Risk

- **Change size:** Minimal — one character (`!` added to a condition).
  This is about as small and surgical as a fix gets.
- **Risk of regression:** Essentially zero. The fix aligns the logic
  with the clearly intended behavior (matching all other APERF checks in
  the codebase) and restores a feature that was broken.
- **Files touched:** 1 file, 1 line changed.
- **Dependencies:** None. The fix is completely self-contained.

### 7. Applicability to Stable Trees

The buggy commit `26e16174f54d4` was merged for v6.14. It exists in the
v6.14 and later kernel releases. Therefore the fix is applicable to:
- 6.14.y (if still maintained)
- 6.15.y, 6.16.y, 6.17.y, 6.18.y, 6.19.y

The fix applies cleanly since no other code changes have touched this
specific condition.

### 8. Stable Kernel Criteria Assessment

1. **Obviously correct and tested:** Yes — the fix is trivially
   verifiable by comparing with the two other APERF checks in the same
   codebase and by logical analysis. It was submitted by Intel and
   accepted by the maintainer.
2. **Fixes a real bug:** Yes — inverted capability check that completely
   breaks the `--hwfreq` feature on modern CPUs.
3. **Important issue:** Yes — a core function of the `cpupower` tool is
   broken on nearly all modern x86 hardware.
4. **Small and contained:** Yes — single character change in one file.
5. **No new features:** Correct — this is purely a bug fix restoring
   intended behavior.
6. **Applies cleanly:** Yes — the buggy code exists unchanged in stable.

**YES**

 tools/power/cpupower/utils/cpufreq-info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/utils/cpufreq-info.c b/tools/power/cpupower/utils/cpufreq-info.c
index 7d3732f5f2f6f..5fe01e516817e 100644
--- a/tools/power/cpupower/utils/cpufreq-info.c
+++ b/tools/power/cpupower/utils/cpufreq-info.c
@@ -270,7 +270,7 @@ static int get_freq_hardware(unsigned int cpu, unsigned int human)
 {
 	unsigned long freq;
 
-	if (cpupower_cpu_info.caps & CPUPOWER_CAP_APERF)
+	if (!(cpupower_cpu_info.caps & CPUPOWER_CAP_APERF))
 		return -EINVAL;
 
 	freq = cpufreq_get_freq_hardware(cpu);
-- 
2.51.0

