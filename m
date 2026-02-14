Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C821D5ABA;
	Sat, 14 Feb 2026 01:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031050; cv=none; b=pw1p1xaZG33t9Ejw0YY9cXyFNPqcSiNHyOPzGrerC4DUuvKc+rdUA6MzCWtI1nKby9InWJaXWo6/hOf3yEPiRNqt6/QOK3uq7QNXPRG/EG/uMtfg+k0hr5LW8rIZWHxU43krjG2LtxWK9ALXF9DFeiaE/kWQgW12fYF2oPw8pUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031050; c=relaxed/simple;
	bh=HyUgO3SQrg908EG9h2tA9s5sqw4zLrBqrdo4d9Qk1TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn2p8bZkfKibcKxG7eShTFCANm64PSvuAq8OE7Se/jFREGDVn6G9GzuHtpJ4pavmWQ7qvxAjHrf731GYiurfdJiR36Goy17TFGwkDNB47qrgVczEUOlD52T5FShEzzFvEsDaUjZCI+XTBrjPeqiQd55KcOgZncwCcqIDb8DLhpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdGcKfs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdGcKfs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412CAC19423;
	Sat, 14 Feb 2026 01:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031050;
	bh=HyUgO3SQrg908EG9h2tA9s5sqw4zLrBqrdo4d9Qk1TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdGcKfs/KCofUjQejmmqBME5MT0K7oLz8XBqsKi/5CS56AmLrOBvF3/h1DCyS5n9Y
	 N1QlIVKa5HYKK+T4JakD8WvyB9gM218BprrdP/jp/TlJqPa+poPee9XjzIPAzRFoAt
	 xnoZVkYIe4m8a6FQjEY7UoRtfTXl4ZnqzlTqlwHg97SBL/BzkCcLHqWi5mN6ff0MAG
	 v+4jBeouwhiPWXCZZvyD+S86vyg//U1pZaCeulN2EWZOjn2Lt5Xq2Uuy6F+hXabEwR
	 QaVJRBdgLXSOY42k861lSPvbuaIrJb+VhVpNyY2kEm2TPoO1kJcZ0WNYagwkF1BQTz
	 w+GP91iFdCIag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	YiPeng.Chai@amd.com,
	ganglxie@amd.com,
	xiang.liu@amd.com,
	lijo.lazar@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amdgpu: fix the calculation of RAS bad page number
Date: Fri, 13 Feb 2026 19:58:38 -0500
Message-ID: <20260214010245.3671907-38-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit f752e79d38857011f1293fcb6c810409c3b669ee ]

__amdgpu_ras_restore_bad_pages is responsible for the maintenance of bad
page number, drop the unnecessary bad page number update in the error
handling path of add_bad_pages.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. Commit Message Analysis

The subject "drm/amdgpu: fix the calculation of RAS bad page number"
clearly indicates a bug fix. The body explains that
`__amdgpu_ras_restore_bad_pages` is the authoritative maintainer of the
bad page count, and the error-path decrements in
`amdgpu_ras_add_bad_pages` are incorrect. Same author (Tao Zhou) as the
commit that introduced this accounting code. Reviewed by Hawking Zhang
(AMD RAS expert).

### 2. Code Change Analysis - The Bug Mechanism

The fix removes two incorrect `con->bad_page_num -=
adev->umc.retire_unit` blocks from the error paths. Here's the detailed
trace of why they are wrong:

**How `bad_page_num` is incremented (the only place):**

```3094:3098:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
                memcpy(&data->bps[data->count], &(bps[j]),
                                sizeof(struct eeprom_table_record));
                data->count++;
                data->space_left--;
                con->bad_page_num++;
```

This happens inside `__amdgpu_ras_restore_bad_pages()`, which is called
as the **last step** by both `__amdgpu_ras_convert_rec_array_from_rom()`
and `__amdgpu_ras_convert_rec_from_rom()`:

```3157:3158:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
out:
        return __amdgpu_ras_restore_bad_pages(adev, err_data->err_addr,
adev->umc.retire_unit);
```

```3207:3208:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
        return __amdgpu_ras_restore_bad_pages(adev, err_data->err_addr,
adev->umc.retire_unit);
```

**What happens on error:** When these conversion functions fail (return
`-EINVAL` or `-EOPNOTSUPP`), they return **before** reaching
`__amdgpu_ras_restore_bad_pages()`. Therefore, `bad_page_num` was
**never incremented**. But the error handling in
`amdgpu_ras_add_bad_pages()` then does:

```3252:3253:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
                                                if (ret)
con->bad_page_num -= adev->umc.retire_unit;
```

and:

```3266:3267:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
                        if (ret)
                                con->bad_page_num -=
adev->umc.retire_unit;
```

This **subtracts** `retire_unit` from `bad_page_num` when nothing was
ever added! Since `bad_page_num` is declared as `int` (signed), this
causes a negative value or incorrect undercount.

### 3. Impact - Why This Matters

The corrupted `bad_page_num` propagates through several critical paths:

1. **EEPROM save logic** at line 3321: `save_count = con->bad_page_num -
   control->ras_num_bad_pages`. A negative or wrong `bad_page_num`
   produces wrong `save_count`, potentially preventing new bad page
   records from being written to EEPROM.

2. **RMA (Return Merchandise Authorization) decisions**:
   `ras_num_bad_pages` (derived from `bad_page_num`) is compared against
   `bad_page_cnt_threshold` in multiple places in `amdgpu_ras_eeprom.c`.
   An incorrect count could either:
   - **Prematurely declare GPU RMA** (counter wraps/underflows
     significantly)
   - **Fail to declare GPU RMA** when threshold is actually reached
     (counter too low)

3. **User-visible reporting**: `amdgpu_ras_badpages_read()` uses `*count
   = con->bad_page_num` to report bad pages to userspace. Wrong count
   means wrong userspace visibility.

4. **HBM reporting**: `amdgpu_dpm_send_hbm_bad_pages_num()` sends the
   count to firmware - wrong count leads to firmware making wrong
   decisions.

### 4. Affected Versions

The `bad_page_num` field was introduced by commit
d45c5e6845a76169ef3d6076f0f04487e5776905 ("drm/amdgpu: adjust the update
of RAS bad page number") which first appeared in **v6.18-rc1**. I
confirmed:
- v6.12 through v6.17: `bad_page_num` does NOT exist (old counting
  scheme)
- v6.18+: `bad_page_num` exists AND the buggy decrement lines exist

So this fix is only relevant to the **6.18.y stable tree**.

### 5. Risk Assessment

- **Size**: Extremely small - removes exactly 4 lines (two `if (ret)
  con->bad_page_num -= ...;` blocks)
- **Risk**: Very low - removing an incorrect decrement cannot break
  anything; it can only make the counter more correct
- **Backport complexity**: Minor context difference in v6.18 (one
  condition check is slightly different), but the lines being removed
  are identical; trivial to adjust
- **Subsystem maturity**: AMD GPU RAS is mature production code used in
  datacenter GPUs

### 6. Classification

This is a **clear bug fix** for an accounting error. It fixes incorrect
bad page number tracking in the AMD GPU RAS subsystem that can lead to:
- Wrong EEPROM bad page records
- Incorrect GPU end-of-life (RMA) determination
- Wrong userspace reporting of bad pages
- Wrong firmware notifications

The fix is small, surgical, obviously correct, fixes a real bug with
concrete consequences, and carries minimal risk. It meets all stable
kernel criteria.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 2a6cf7963dde2..d79b41ce21240 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -3249,8 +3249,6 @@ int amdgpu_ras_add_bad_pages(struct amdgpu_device *adev,
 						/* deal with retire_unit records a time */
 						ret = __amdgpu_ras_convert_rec_array_from_rom(adev,
 										&bps[i], &err_data, nps);
-						if (ret)
-							con->bad_page_num -= adev->umc.retire_unit;
 						i += (adev->umc.retire_unit - 1);
 					} else {
 						break;
@@ -3263,8 +3261,6 @@ int amdgpu_ras_add_bad_pages(struct amdgpu_device *adev,
 		for (; i < pages; i++) {
 			ret = __amdgpu_ras_convert_rec_from_rom(adev,
 				&bps[i], &err_data, nps);
-			if (ret)
-				con->bad_page_num -= adev->umc.retire_unit;
 		}
 
 		con->eh_data->count_saved = con->eh_data->count;
-- 
2.51.0

