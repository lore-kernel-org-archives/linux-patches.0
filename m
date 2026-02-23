Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B24366562;
	Mon, 23 Feb 2026 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850278; cv=none; b=WsRwk4fTbmykxdY66RQJHOmlvqLN6HGFcraoCNAu5L+vHc5njA037rN7m0RvO1E+ShUBagxMSo+qGPQ3IvvCH3LE9Pg9Ff7JOp1EEDkVxVIMOon7vPOmNYCcBcM3C70n8K64/X44gkscE6STxvVWJuxjSawZ9I3YhQutD7tfjXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850278; c=relaxed/simple;
	bh=1S7CCT5hTU6hbmGT9oij8/dhMm2j+yuXL+cRd3wT9rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTH1GWLwOdweKGxlYxJ0yk0k0hmE9S1lWlIts1nQLyp2z6Mg3vpysWDslerl3jmCwV/bZEu6+uNJ/yzuxV/Ju0netfru1tXE1/Uyloi/zWK4muE9KREPPBKyFQ8Jw9nfXtm32wod6GKs0LWn69CYPSAfzsBSmkiB+kp1I5rtZuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OvxhdQxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvxhdQxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A1DC19424;
	Mon, 23 Feb 2026 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850275;
	bh=1S7CCT5hTU6hbmGT9oij8/dhMm2j+yuXL+cRd3wT9rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvxhdQxctWJMLPapfGhhik1H2/hxXrNYl5hC2yZ+w6Jp49a7tKGMUakMzA4jK/YU/
	 JwDlPpsfzllqmTsYKW81K94Uu2TJ61g1yf205+C719WjADh2UwFz6HUfTKx6aGRGO9
	 4BWKr3v3Yd/KGrAiIJ9H1P18OPl1+8Ff2WomyfV+k13GJtpDiH4bdUhzsf6XS6Km+M
	 lDxHlj7D8eF0InEHxUflhN1lUk/zJtEjiakakm4nES1CUYEweYQ2vQQ3FIw6kFmCDQ
	 aj9b4vxc7ge1rBBXE/W16jFq2CHtMUPWYkGBeyduFYqHCEWxEId53GqeW5qUAARLW+
	 ZrUgCRzwBsZrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amdgpu: return when ras table checksum is error
Date: Mon, 23 Feb 2026 07:37:15 -0500
Message-ID: <20260223123738.1532940-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Transfer-Encoding: 8bit

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit 044f8d3b1fac6ac89c560f61415000e6bdab3a03 ]

end the function flow when ras table checksum is error

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear picture. Let me analyze this commit:

## Analysis

### What the commit does

The commit fixes a missing early return in `amdgpu_ras_eeprom_check()`
when the RAS EEPROM table checksum verification fails for the
`RAS_TABLE_HDR_VAL` case (valid header).

**The bug:** When `hdr->header == RAS_TABLE_HDR_VAL` and
`__verify_ras_table_checksum()` fails, the original code logs an error
but continues execution. This means the function proceeds to check if
bad pages exceed 90% of the threshold and eventually returns 0 (success
via `return res < 0 ? res : 0;`, since `__verify_ras_table_checksum`
returns positive for checksum mismatch). The caller then treats the
corrupt table as valid.

**The inconsistency:** In the other branch (`RAS_TABLE_HDR_BAD`), the
same checksum failure already results in `return -EINVAL` (line 1728).
The fix makes both code paths behave consistently - returning an error
on checksum failure.

### Why this matters

If the RAS table has a corrupt checksum and the function returns
success:
1. The caller `amdgpu_ras_load_bad_pages()` proceeds to use potentially
   corrupt bad page data
2. Corrupt bad page tracking could lead to incorrect GPU memory
   management decisions
3. Pages that should be retired (due to hardware errors) might not be,
   or vice versa, potentially leading to GPU errors, data corruption, or
   instability

### Stable criteria assessment

- **Fixes a real bug:** Yes - using corrupt EEPROM data when checksum
  fails is a genuine bug
- **Obviously correct:** Yes - the `RAS_TABLE_HDR_BAD` path already
  returns `-EINVAL` on checksum failure; this is making the
  `RAS_TABLE_HDR_VAL` path consistent
- **Small and contained:** Yes - adds `return -EINVAL` and wraps the
  existing `if` in braces, 4 lines changed
- **No new features:** Correct - purely a bug fix
- **Risk:** Very low - only affects the error path when checksum is
  already corrupt

### Verification

- Read the full `amdgpu_ras_eeprom_check()` function (lines 1670-1762)
  confirming the two parallel branches and the inconsistent handling
- Confirmed `__verify_ras_table_checksum()` returns positive for
  checksum mismatch, negative for I/O error (lines 1429-1437)
- Confirmed the return statement `return res < 0 ? res : 0` at line 1761
  means a positive `res` (checksum mismatch) would be returned as 0
  (success) - this is the core bug
- Confirmed the `RAS_TABLE_HDR_BAD` branch already returns `-EINVAL` on
  checksum failure (line 1728), confirming this is an oversight
- Confirmed the caller in `amdgpu_ras.c` uses the return value to decide
  whether to proceed with loading bad pages (`if (ret) goto out;`)
- The patch has been Reviewed-by two AMD engineers (Tao Zhou and Kent
  Russell)

The fix is small, surgical, obviously correct (matching the existing
pattern in the parallel code path), and prevents using corrupt EEPROM
data. It meets all stable kernel criteria.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 64dd7a81bff5f..710a8fe79fccd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -1701,10 +1701,12 @@ int amdgpu_ras_eeprom_check(struct amdgpu_ras_eeprom_control *control)
 		}
 
 		res = __verify_ras_table_checksum(control);
-		if (res)
+		if (res) {
 			dev_err(adev->dev,
 				"RAS table incorrect checksum or error:%d\n",
 				res);
+			return -EINVAL;
+		}
 
 		/* Warn if we are at 90% of the threshold or above
 		 */
-- 
2.51.0

