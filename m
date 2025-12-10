Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689DF28FFF6;
	Wed, 10 Dec 2025 06:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348515; cv=none; b=MJQDvEL8eYdyKM2fDbbu8aLqd94hkdoHUEQq2Nr2kJNZIREcIsP3o7cmF/VYU2yd0q76MOrHQx32igkarfumDbMQw5U9/8tA9tNJfjQdXHJmTJcq0nHxF8zuv6+R7N2kJq0llu/cQ2OTuVSmYGNC2icJpg4wvO7NHDZVrmzH5c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348515; c=relaxed/simple;
	bh=vpqBjFxS2tCn1qmGhUgdhnHKuO1yGyehv0knWmhmibs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtzQDjgp9iDolv3Br/sxFgWJw7Y7EhQuaXW42m/kr543Btg360KNITE72RWN3WPSfFaXYiiRlzggf+hlmRgX00kT6WtYg3zIP4qYQ8SF1cNIXwkC9JSAI6H6ALpH4/9ptxT1AL+I1V2xRjzoj7WH8QBEMSpyTI4cIST9qFW0nrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iV/JvpFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iV/JvpFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E226EC4CEF1;
	Wed, 10 Dec 2025 06:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348514;
	bh=vpqBjFxS2tCn1qmGhUgdhnHKuO1yGyehv0knWmhmibs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iV/JvpFI/RbwQ6NTqWsvgwbkrRHEZbLGU3a4g4R6vLcTs79Zzg5kXSam2TS/WsUzD
	 /CexocqD6u02rukHD9Sc2lYYFgke5+4k5nQDVe6dCgDhpC4qE5JQ8oyzzK9+pfOkn8
	 A5Q30kHh0Ayidz9GJVZ9nt51SImiqlhUFIIGCoCMKQS7WFzO5TmN5RfFjEz+8ZpdxZ
	 mYX/4FG60tg5C9t27JzmpdeXH9+KvoyG3R0qSjdGYEwESZHSbwqwYx3nenaY1UCRz+
	 OcA3WmLajviXcMf0daOXNa0dPEWUQQLwuJIM0RTY0uzvLyR/pLnYWXIveJ6x2IrzV2
	 H/wy2rsGMNloA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] libperf cpumap: Fix perf_cpu_map__max for an empty/NULL map
Date: Wed, 10 Dec 2025 01:34:36 -0500
Message-ID: <20251210063446.2513466-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210063446.2513466-1-sashal@kernel.org>
References: <20251210063446.2513466-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit a0a4173631bfcfd3520192c0a61cf911d6a52c3a ]

Passing an empty map to perf_cpu_map__max triggered a SEGV. Explicitly
test for the empty map.

Reported-by: Ingo Molnar <mingo@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/aSwt7yzFjVJCEmVp@gmail.com/
Tested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: libperf cpumap: Fix perf_cpu_map__max for an
empty/NULL map

### 1. COMMIT MESSAGE ANALYSIS

- **Subject**: Clearly indicates a bug fix for `perf_cpu_map__max()`
- **Bug type**: SEGV (segmentation fault / crash) - a severe issue
- **Tags present**:
  - `Reported-by: Ingo Molnar` - reported by a prominent kernel
    developer
  - `Closes:` link to mailing list bug report
  - `Tested-by:` from two people (Ingo Molnar and Thomas Richter)
  - `Signed-off-by:` from maintainers
- **Missing tags**: No explicit `Cc: stable@vger.kernel.org` or `Fixes:`
  tag

### 2. CODE CHANGE ANALYSIS

**Before the fix:**
```c
return __perf_cpu_map__nr(map) > 0
    ? __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1)
    : result;
```

**After the fix:**
```c
if (!map)
    return result;

// The CPUs are always sorted and nr is always > 0 as 0 length map is
// encoded as NULL.
return __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1);
```

**The Bug Mechanism:**
The old code attempted to check `__perf_cpu_map__nr(map) > 0` before
accessing the map, but this check **itself** dereferences the `map`
pointer. When `map` is NULL, calling `__perf_cpu_map__nr(map)` results
in a NULL pointer dereference, causing a SEGV.

**The Fix:**
- Adds an explicit NULL check at the function entry point
- Returns the default result (`cpu = -1`) for NULL maps
- Simplifies the logic based on the invariant that a 0-length map is
  encoded as NULL (so if map is non-NULL, it has at least one entry)

### 3. CLASSIFICATION

- **Type**: Bug fix (NULL pointer dereference causing crash)
- **Not a feature**: Doesn't add new functionality
- **Not a quirk/device ID**: Pure crash fix in existing code

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | ~10 (very small) |
| Files touched | 1 file |
| Complexity | Very low - simple NULL check |
| Subsystem | tools/lib/perf (perf userspace tooling) |
| Risk level | **Very low** |

The fix is defensive - adding a NULL check cannot break anything that
was previously working.

### 5. USER IMPACT

- **Affected users**: Anyone using perf tooling
- **Trigger condition**: Passing an empty/NULL cpu map to
  `perf_cpu_map__max()`
- **Severity**: Crash (SEGV) - high severity
- **Reproducibility**: Reliably reproducible per the bug report

### 6. STABILITY INDICATORS

- ✅ Tested by Ingo Molnar (original reporter)
- ✅ Tested by Thomas Richter (IBM)
- ✅ Signed off by maintainer Namhyung Kim
- ✅ Simple, obviously correct fix
- ✅ Well-documented reasoning in updated comment

### 7. DEPENDENCY CHECK

- Self-contained fix - no dependencies on other commits
- Uses existing internal functions (`__perf_cpu_map__nr`,
  `__perf_cpu_map__cpu`) that would exist in stable trees
- Should apply cleanly to stable trees

### STABLE CRITERIA EVALUATION

| Criterion | Met? |
|-----------|------|
| Obviously correct | ✅ Yes - simple NULL check |
| Fixes real bug | ✅ Yes - SEGV crash |
| Important issue | ✅ Yes - crash in widely-used tool |
| Small and contained | ✅ Yes - few lines, one function |
| No new features | ✅ Yes - purely defensive |
| No new APIs | ✅ Yes |

### CONCLUSION

This commit is an excellent candidate for stable backport:

1. **Fixes a real crash**: SEGV when passing NULL/empty map is a serious
   bug that users can hit
2. **Obviously correct**: Simple NULL check at function entry is
   textbook defensive programming
3. **Minimal risk**: Cannot cause regressions - only affects the
   previously-broken case
4. **Well tested**: Multiple test acknowledgments from respected
   developers
5. **Small and surgical**: Touches only one function in one file
6. **No dependencies**: Self-contained fix

The missing `Cc: stable` tag appears to be an oversight rather than an
indication the fix isn't appropriate for stable. The perf tooling is
widely used, and crash fixes in it are important for stable users.

**YES**

 tools/lib/perf/cpumap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
index b20a5280f2b33..2bbbe1c782b8a 100644
--- a/tools/lib/perf/cpumap.c
+++ b/tools/lib/perf/cpumap.c
@@ -368,10 +368,12 @@ struct perf_cpu perf_cpu_map__max(const struct perf_cpu_map *map)
 		.cpu = -1
 	};
 
-	// cpu_map__trim_new() qsort()s it, cpu_map__default_new() sorts it as well.
-	return __perf_cpu_map__nr(map) > 0
-		? __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1)
-		: result;
+	if (!map)
+		return result;
+
+	// The CPUs are always sorted and nr is always > 0 as 0 length map is
+	// encoded as NULL.
+	return __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1);
 }
 
 /** Is 'b' a subset of 'a'. */
-- 
2.51.0

