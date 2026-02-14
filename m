Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2856B194098;
	Sat, 14 Feb 2026 01:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031070; cv=none; b=trR22SOKJIEp5QbL1L5SnK9uM5FNX5Q/S+SdY7kNhtN99cLT29VrqJ2ymH1p2buQj5xoT4g/+1xN1vap3zihGeoBzT+UzBlv5TuFgV7ZHN/5u1i2fP1MDMxlN+RfsIYpcZI4Tbi662xfd70IMWn5CWFhms6iiXaBMPU96kT5mM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031070; c=relaxed/simple;
	bh=4OGFXhqXJXFwX8PmatMTNjBcR45Cii6fvFp3X5nSeNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=scn0t3ndo91Pdiw4g8pW06oWXYcOeXNd0m3Be+3nDZtYhgRETtaok16XzQhfC2fUpmTKM+77hz0bT2G1XGFLEAa6tMljxmXj/ttHGWz9EJRpGZ8RBhikdfyushBiH8eGMUObXgUNBQApFYN0w1A4WtavqsOdDpBWYEUzft2c7Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0Zmmd7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0Zmmd7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA3BC19423;
	Sat, 14 Feb 2026 01:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031070;
	bh=4OGFXhqXJXFwX8PmatMTNjBcR45Cii6fvFp3X5nSeNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0Zmmd7doeRMY6tLmoacEozs7uGMGwUbgQrg9D+A+PP6xQvIl9DNrDuuvNnw8j1aU
	 nFVDsSW9FIeqFV6QLf4meJ3vQ+MTleK79hjLSFwICEFHm2mNc/Gj6C2kgxp1zZ+YZZ
	 GXpgzcfjLsU6KzyYBkb3+3ICeSr09+XDcPQUWT02k2h95dQQacR5+p+uobOjItkaqg
	 P6OSsJMQuy/LsuMzza4kZA6W88s0STr+NWqZNpICjqA+xy/9GRowZtMMzKuQOHt1OH
	 f+eh5jcvi4kRIRmi+ayeSSZr6rzJFTPqfE1xswNxbHAZdR+catWPQbrUEHbryCq4+R
	 1MHZEt62uMRWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Hawking.Zhang@amd.com,
	YiPeng.Chai@amd.com,
	lijo.lazar@amd.com,
	xiang.liu@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.19] drm/amdgpu: mark invalid records with U64_MAX
Date: Fri, 13 Feb 2026 19:58:48 -0500
Message-ID: <20260214010245.3671907-48-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
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

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit 0028b86b52f7609e36af635ef6cb908925306233 ]

set retired_page of invalid ras records to U64_MAX, and skip
them when reading ras records

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of commit: "drm/amdgpu: mark invalid records with U64_MAX"

### Commit Message Analysis

The commit message is terse: "set retired_page of invalid ras records to
U64_MAX, and skip them when reading ras records." This describes a fix
for handling invalid RAS (Reliability, Availability, Serviceability) bad
page records in AMD GPU drivers.

### Code Change Analysis

Let me examine the two changes in detail:

**Change 1: `__amdgpu_ras_restore_bad_pages`** (the write path)

When restoring bad pages from EEPROM, if
`amdgpu_ras_check_bad_page_unlock()` returns true (meaning the page is
already tracked / is a duplicate), the old code would increment
`data->count` and decrement `data->space_left` but **leave the
`data->bps[data->count]` entry uninitialized** (or containing whatever
stale data was there). The new code sets
`data->bps[data->count].retired_page = U64_MAX` to explicitly mark this
slot as invalid before incrementing the count.

This is a bug fix: previously, when a duplicate bad page was detected
during restore, a slot was consumed in the `data->bps` array without
being properly initialized. This uninitialized entry could contain
garbage data — a stale or random `retired_page` value.

**Change 2: `amdgpu_ras_badpages_read`** (the read path)

When reading bad pages, the new code skips entries where `retired_page
== U64_MAX`. This ensures that the invalid/placeholder entries created
in Change 1 are not reported to userspace or used downstream.

### Bug Mechanism

The bug is:
1. During `__amdgpu_ras_restore_bad_pages`, duplicate bad pages cause a
   slot to be consumed in the `bps` array with uninitialized content
2. When `amdgpu_ras_badpages_read` later iterates over entries, it would
   read these uninitialized entries, potentially reporting garbage
   retired page addresses
3. This could lead to incorrect bad page tracking — the RAS subsystem
   might try to retire pages at wrong addresses, potentially causing
   data corruption or incorrect memory management on the GPU

### Classification

This is a **bug fix** — it fixes uninitialized data in the RAS bad page
tracking array. The RAS subsystem is responsible for tracking pages with
uncorrectable memory errors on the GPU. Incorrect tracking could lead
to:
- Reporting wrong bad pages to userspace
- Failing to properly isolate bad memory regions
- Potential data corruption if bad pages are not properly retired

### Scope and Risk Assessment

- **Files changed**: 1 file (`amdgpu_ras.c`)
- **Lines changed**: ~6 lines of new code (2 comment lines + 4 code
  lines)
- **Risk**: Very low — the changes are additive (adding a sentinel value
  and a skip check), don't change control flow for valid entries, and
  are confined to RAS error handling
- **Subsystem**: AMD GPU RAS — important for data center and workstation
  users with AMD GPUs that have ECC memory

### Dependency Check

The change uses `U64_MAX` which is a standard kernel constant. The
functions modified (`amdgpu_ras_badpages_read` and
`__amdgpu_ras_restore_bad_pages`) are well-established in the amdgpu
driver. No dependency on other recent commits is apparent.

### User Impact

Users with AMD GPUs (especially data center GPUs like MI-series with ECC
memory) rely on the RAS subsystem to correctly track and retire bad
memory pages. If bad page records contain garbage data:
- The GPU driver may attempt to retire incorrect pages
- Bad pages may not actually be retired, leading to repeated
  uncorrectable errors
- System reliability for GPU compute workloads could be affected

### Stability Indicators

- **Reviewed-by: Tao Zhou** — subsystem reviewer has approved
- **Signed-off-by: Alex Deucher** — AMD GPU maintainer has signed off
- The fix is straightforward and the sentinel value approach is a well-
  understood pattern

### Concerns

- The commit is small and surgical
- The sentinel value `U64_MAX` is a valid choice since no real page
  address would be `U64_MAX`
- The fix addresses both the write path (marking invalid) and read path
  (skipping invalid), so it's self-contained

### Verdict

This fixes a real bug: uninitialized data in the RAS bad page array that
could lead to incorrect bad page reporting and handling. The fix is
small (6 lines), self-contained, well-reviewed, and low-risk. It meets
stable kernel criteria: it's obviously correct, fixes a real bug
affecting data integrity in GPU RAS handling, and is small in scope.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 3d51a3c8852ad..a2a0a7b994d16 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2777,6 +2777,10 @@ static int amdgpu_ras_badpages_read(struct amdgpu_device *adev,
 			if (!data->bps[i].ts)
 				continue;
 
+			/* U64_MAX is used to mark the record as invalid */
+			if (data->bps[i].retired_page == U64_MAX)
+				continue;
+
 			bps[r].bp = data->bps[i].retired_page;
 			r++;
 			if (r >= count)
@@ -3083,6 +3087,8 @@ static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 
 		if (amdgpu_ras_check_bad_page_unlock(con,
 			bps[j].retired_page << AMDGPU_GPU_PAGE_SHIFT)) {
+			/* set to U64_MAX to mark it as invalid */
+			data->bps[data->count].retired_page = U64_MAX;
 			data->count++;
 			data->space_left--;
 			continue;
-- 
2.51.0

