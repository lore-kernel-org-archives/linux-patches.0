Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F2449EA9;
	Tue, 10 Mar 2026 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133327; cv=none; b=L6RwkqGvvrOfcehzR10dkOaJJwspv/YZ3CbgXRRKHasYuETB0Z8cm7YZt9+PEpnMCmtQPE06JaNZjO+R6ULC2VgXYPyLPOWTzQ8viCRVGkUhR8foVQ/CBAM1ryOuE9tmm8SKCkitjM/PRZQ1j/imBCsBVuxx9IX+qkczd6h2up0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133327; c=relaxed/simple;
	bh=r8WAD2F7D8WIgSmF8G5L9L+20YDFC2s8SrvwDgEwo+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NzuU41gxEowda0kJvLuBhCVEtDK6etFojodekBkUN/V5iSz/ywskJ5QVNu1O6jZ9KFUiz5nvgKZ0PnOWkW6kyiDfsFyhiNmV7J9EeL8GGJoK3Vi05N+EtF6uH0C6eJOTgru9ED6NfdRY67NaEn0FWmSAr5wWc38lMQHmSstXlag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnOwznEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnOwznEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DFAC4AF0B;
	Tue, 10 Mar 2026 09:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133327;
	bh=r8WAD2F7D8WIgSmF8G5L9L+20YDFC2s8SrvwDgEwo+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnOwznEQfNQFyozDBofhx/73Eb08XXRWmjZ7P7waNRnB2uenwdcthIDpkgSbit7l0
	 H8OLTIrJD6IsAjkQUdL6URmqF3bazleT0cLRMxIAKURXTccMY1mA9g538NYd+Z+hzU
	 8ZBxj+Qay/g/U9XCT0+BKSDFpAk1szcABD2t43X0ygWsiKbP+KUvvuWCtRX8rTXwNm
	 DtUd0GCPlNlXIhUl6L4+CGD74YS2ne26jiPWrLIfW0yrNarQg4dt0S7gsk0W1eVlo4
	 GIdHg2KLG6pii6RUg2MmYvU+vGQk5r4hiw4+jH+y2PmyT/lQU2XALcQnCh7pwh/k+r
	 50AM2i+urpxKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maarten Lankhorst <dev@lankhorst.se>,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	ray.huang@amd.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/ttm/tests: Fix build failure on PREEMPT_RT
Date: Tue, 10 Mar 2026 05:01:14 -0400
Message-ID: <20260310090145.2709021-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit a58d487fb1a52579d3c37544ea371da78ed70c45 ]

Fix a compile error in the kunit tests when CONFIG_PREEMPT_RT is
enabled, and the normal mutex is converted into a rtmutex.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602261547.3bM6yVAS-lkp@intel.com/
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://patch.msgid.link/20260304085616.1216961-1-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

**What the commit does:** Fixes a build failure in
`ttm_bo_reserve_interrupted()` kunit test when `CONFIG_PREEMPT_RT` is
enabled. On PREEMPT_RT, `struct mutex` becomes `struct rt_mutex`, so
direct `mutex_lock(&bo->base.resv->lock.base)` calls fail to compile.
The fix replaces the raw mutex calls with the proper
`dma_resv_lock()`/`dma_resv_unlock()` API, which correctly abstracts the
underlying lock type.

**Type of fix:** Build fix — prevents compilation failure under a valid
kernel configuration (PREEMPT_RT).

**Scope:** Extremely small — 2 lines changed in a test file. Changes
`mutex_lock` → `dma_resv_lock` and `mutex_unlock` → `dma_resv_unlock`.
The `dma_resv_*` API has been available for many kernel versions and is
the proper way to lock reservation objects.

**Affected versions:** The test file was introduced in v6.9-rc1 (commit
995279d280d1e). A similar fix for a *different function*
(`ttm_bo_reserve_deadlock`) was done in v6.11-rc1 (commit
f85376c890ef4), but it missed this second instance in
`ttm_bo_reserve_interrupted`. The buggy code exists in v6.12 and v6.13
stable trees. The file doesn't exist in v6.1 or v6.6 (pre-v6.9).

**Risk assessment:** Extremely low risk. This is a 2-line change in test
code only, using well-established APIs. It cannot cause runtime
regressions in production code. The `dma_resv_lock(obj, NULL)` call is
semantically equivalent to locking the underlying ww_mutex without a
context, which is what the original `mutex_lock` was doing.

**Stable criteria assessment:**
- Obviously correct and tested: Yes — uses standard API, reviewed by
  Jouni Högander, reported by kernel test robot
- Fixes a real bug: Yes — build failure with PREEMPT_RT
- Important issue: Build fixes are explicitly listed as stable-worthy in
  the rules
- Small and contained: Yes — 2 lines in one test file
- No new features: Correct

**Verification:**
- `git log --diff-filter=A` confirmed the test file was introduced in
  commit 995279d280d1e (v6.9-rc1)
- `git show v6.12:...ttm_bo_test.c` confirmed the buggy
  `mutex_lock(&bo->base.resv->lock.base)` exists at line 225 in v6.12
- `git show v6.13:...ttm_bo_test.c` confirmed the same buggy code exists
  in v6.13
- `git show v6.6/v6.1:...ttm_bo_test.c` confirmed the file does NOT
  exist in these older stable trees
- `git show v6.12:include/linux/dma-resv.h` confirmed
  `dma_resv_lock`/`dma_resv_unlock` API exists in v6.12
- Previous related fix f85376c890ef4 confirmed this is the same class of
  PREEMPT_RT build issue but in a different function
  (`ttm_bo_reserve_deadlock` vs `ttm_bo_reserve_interrupted`)
- The commit has `Reported-by: kernel test robot` and `Reviewed-by:
  Jouni Högander`, confirming it was properly tested and reviewed

This is a straightforward build fix — small, correct, zero runtime risk,
and applies to existing stable trees (v6.12, v6.13). Build fixes are
explicitly allowed in stable.

**YES**

 drivers/gpu/drm/ttm/tests/ttm_bo_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
index d468f83220720..f3103307b5df9 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
@@ -222,13 +222,13 @@ static void ttm_bo_reserve_interrupted(struct kunit *test)
 		KUNIT_FAIL(test, "Couldn't create ttm bo reserve task\n");
 
 	/* Take a lock so the threaded reserve has to wait */
-	mutex_lock(&bo->base.resv->lock.base);
+	dma_resv_lock(bo->base.resv, NULL);
 
 	wake_up_process(task);
 	msleep(20);
 	err = kthread_stop(task);
 
-	mutex_unlock(&bo->base.resv->lock.base);
+	dma_resv_unlock(bo->base.resv);
 
 	KUNIT_ASSERT_EQ(test, err, -ERESTARTSYS);
 }
-- 
2.51.0

