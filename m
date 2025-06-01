Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423333012DD;
	Sun,  1 Jun 2025 23:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821008; cv=none; b=eroVttcf7M3wq0sMu7vtpvScIjoCa2tFnz8XxLB+BZ5ObFtQJquxd3XyPPgzGjehV9NfRMtP27CeVhZ5P0lMDftY7bSb5SSPG4PcBlAif62wGTH4ZFZOVA+ooKLJy3RVmNDn4RqDH59GB9KvTrywScc27R3bzPeGdmjbb4S21vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821008; c=relaxed/simple;
	bh=D91YgcZxIRCfR2mOCi2luDYBQF9vJuJWNdZL5R02rts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lA5esPZXlZijwF5BVfU4N5f+6ht/VEVmLUkzWHxGhv3mj8oXKdhDF9zzQy0rVKDg1oqOm2YvthOdeHbUcycGi74ypuEjnZJ+eDbKCy6lhrEWtaf4r/ZGW+xfnrTeutTU7Xyjs335vssFFxAkENB3IsF7tDcg9ZaU7mL2FdADAYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JwXMIZVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwXMIZVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE6EC4CEF1;
	Sun,  1 Jun 2025 23:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821007;
	bh=D91YgcZxIRCfR2mOCi2luDYBQF9vJuJWNdZL5R02rts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwXMIZVzRm1+xcFGWZWttifxYe65wQ3l8BaBeZrMKHDfBwUeSoDpmqrny+vhq7Gbu
	 0jssIWF7JMjN4bPOMCpcplHZDcgfUzm5E25EZbLgU02PZsI0OHcItm4llJPeEwmasq
	 xjqxS/RwHtGGFHJdZ5ATBOHKRUOe6FYdg3GJ7P5TAfCfrUFZ4/NiVPwaanevqoOGNz
	 lEoBJi/Q3TUKNqa8bab55FFDk2ky/m8uB7pMELOI8I5MSf6yrJ/0dBICLhEhx0jSP4
	 A9hVudq78job4eOE7aEIpUce95VAtwAN2EHdmHtyqH+8bPQBaAw8smKhGpHemTs4i/
	 V4jGGLgeDH0Ng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 64/93] drm/xe/uc: Remove static from loop variable
Date: Sun,  1 Jun 2025 19:33:31 -0400
Message-Id: <20250601233402.3512823-64-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 75584c8213d341ddd5b7c72abf822e62f4b3ab27 ]

The `entries` variable is used to loop through the array - it's supposed
to be const, but not static.

Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250307-xe-per-gt-fw-v1-1-459574d76400@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Commit Analysis **Type of Issue:** This commit
fixes an incorrect use of the `static` storage class specifier on a
local variable that should be a simple `const` pointer. **Code
Analysis:** - The problematic line changes `static const struct
uc_fw_entry *entries;` to `const struct uc_fw_entry *entries;` - This
variable is used as a loop iteration pointer in the
`uc_fw_auto_select()` function - The variable gets assigned from
`blobs_all[uc_fw->type].entries` and is used to iterate through firmware
entries - The `static` keyword is incorrect here because this should be
a local variable that gets reinitialized on each function call **Impact
Assessment:** - **Bug severity:** This is a subtle but real bug that
affects driver correctness - **User impact:** Could cause firmware
selection issues in Intel Xe GPU drivers, potentially leading to
graphics driver failures or incorrect firmware loading - **Risk:** The
incorrect `static` storage could cause the `entries` pointer to retain
stale values across function calls, leading to unpredictable firmware
selection behavior **Backport Suitability Criteria:** 1. ✅ **Fixes a
real bug:** Yes, incorrect storage class affects program correctness 2.
✅ **Small and contained:** Single line change, minimal risk 3. ✅ **No
side effects:** Pure bug fix with no behavioral changes beyond
correcting the error 4. ✅ **No architectural changes:** Simple variable
declaration fix 5. ✅ **Minimal regression risk:** Extremely low risk -
makes the code work as originally intended 6. ✅ **Follows stable tree
rules:** Important bugfix, minimal risk, contained change **Historical
Precedent:** This commit is nearly identical to the i915 commit
`5821a0bbb4c3` which was backported (marked as "YES" in the reference
commits). Both commits: - Fix the exact same type of bug (accidental
`static` on local variable) - Affect similar firmware selection code in
Intel GPU drivers - Have identical risk profiles and change patterns -
Were authored by the same team working on Intel GPU microcontroller
firmware **Conclusion:** This is a clear candidate for backporting - it
fixes a genuine bug that could affect system stability, has minimal risk
of regression, and follows the established pattern of similar fixes that
have been successfully backported.

 drivers/gpu/drm/xe/xe_uc_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_uc_fw.c b/drivers/gpu/drm/xe/xe_uc_fw.c
index d431d0031185e..16649652c8151 100644
--- a/drivers/gpu/drm/xe/xe_uc_fw.c
+++ b/drivers/gpu/drm/xe/xe_uc_fw.c
@@ -221,8 +221,8 @@ uc_fw_auto_select(struct xe_device *xe, struct xe_uc_fw *uc_fw)
 		[XE_UC_FW_TYPE_HUC] = { entries_huc, ARRAY_SIZE(entries_huc) },
 		[XE_UC_FW_TYPE_GSC] = { entries_gsc, ARRAY_SIZE(entries_gsc) },
 	};
-	static const struct uc_fw_entry *entries;
 	enum xe_platform p = xe->info.platform;
+	const struct uc_fw_entry *entries;
 	u32 count;
 	int i;
 
-- 
2.39.5

