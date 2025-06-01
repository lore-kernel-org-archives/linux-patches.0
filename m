Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E2B2D3228;
	Sun,  1 Jun 2025 23:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820941; cv=none; b=sahcCHBfehZ3GhAamPwY60xeBb9ZWcc+/QODvklnLxD359wzIpUwJjn55t4ugr/inZLGdhY7ksrL8W8nz8dwdUhZSFwCArJi6QPqLW08DRxg7Q8Tzv53ZComNexyPxj0uefbpXxVy7R/moi3Fy9JYA70wZ0Pz6YN4VY2EzE1AbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820941; c=relaxed/simple;
	bh=XAOaciCUl5jhuLC4G0bmlDcKEezu/xBOhWFKf9Sa+jA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DS9ReQiPs5srb6atIf7q8fxTaajX+t+ESr9I5JQKZZf5qd8asPvzVtpWbdqrHedY1UbObtR6Yi7yhGiDuc2foNN3eJrDjB1SZx9OUmDbbr3KhgRBaeqmMtMJJTo43hXLXClECxvgh+H3PL6IfHrQ8CP53SPylWDUvmwdKC8hXMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izJvB12x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izJvB12x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24BDC4CEE7;
	Sun,  1 Jun 2025 23:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820941;
	bh=XAOaciCUl5jhuLC4G0bmlDcKEezu/xBOhWFKf9Sa+jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izJvB12xjqKgDi7A8EXgV7TBLOZfFHNvcnOYYttuswKzHDwX66aCasWVQYW/w82gW
	 /Hcqhga14sAiMzea3dHtxh0gEvDk96vh4mItkyMm0cdVMjJF4Gd2wO5DoZDwrsDPbn
	 pustDtM15CpqWgCSgiYGlzPBca73i14EDcWRS1RXGclN+SyS9P32seHCk7rE5VvoUp
	 keOUqQf6l1baU7roXdw3YpFYZAfg2voWNv/HYA53XxnPjssiknj779cO8uEvp61VcU
	 PnXuAZO4xNWZ12LOSlenprVSdF9IYG2xyVHkq/+nRGHrgX3KU7ygevGQSbf4wvFWBz
	 SPwe3QzxYfAyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qasim Ijaz <qasdev00@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	ray.huang@amd.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	thomas.hellstrom@linux.intel.com,
	Arunpravin.PaneerSelvam@amd.com,
	karolina.stolarek@intel.com,
	jeff.johnson@oss.qualcomm.com,
	mingo@kernel.org,
	bigeasy@linutronix.de,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 39/93] drm/ttm/tests: fix incorrect assert in ttm_bo_unreserve_bulk()
Date: Sun,  1 Jun 2025 19:33:06 -0400
Message-Id: <20250601233402.3512823-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit 878516a9e62cd220379e511d43dcf58df3a6ca9f ]

In the ttm_bo_unreserve_bulk() test function, resv is allocated using
kunit_kzalloc(), but the subsequent assertion mistakenly verifies the
ttm_dev pointer instead of the resv pointer.

Fix the assertion to properly verify the resv pointer.

Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250313161424.10688-1-qasdev00@gmail.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Let me check the commit message in the analysis: Based on my thorough
analysis, I can now provide a comprehensive assessment. **YES** This
commit should be backported to stable kernel trees. ## Detailed
Analysis: ### Nature of the Bug: The commit fixes a simple but
significant bug in the TTM (Translation Table Maps) test code. In the
`ttm_bo_unreserve_bulk()` test function, there's a copy-paste error
where: ```c resv = kunit_kzalloc(test, sizeof(*resv), GFP_KERNEL);
KUNIT_ASSERT_NOT_NULL(test, ttm_dev); // BUG: should be 'resv', not
'ttm_dev' ``` The assertion is checking the wrong pointer. It should be:
```c KUNIT_ASSERT_NOT_NULL(test, resv); ``` ### Why This Should Be
Backported: 1. **Important Test Infrastructure Bug**: This bug affects
TTM test validation, which is crucial for GPU driver stability. While
it's "only" test code, broken tests can mask real bugs or give false
confidence. 2. **Small, Contained Fix**: The change is minimal and
isolated - it only affects a single line in a test file with zero risk
of breaking production code. This matches the stable tree criteria of
minimal, low-risk fixes. 3. **Clear Bug Pattern**: This is an obvious
copy-paste error that was introduced in commit 588c4c8d58c4 when the
`resv` variable was added but the assertion wasn't updated accordingly.
4. **Follows Stable Tree Rules**: - Fixes an important bug (broken test
validation) - Extremely low regression risk (one-line change in test
code) - No architectural changes - Confined to a single subsystem 5.
**Historical Precedent**: Looking at similar commit #1 in the examples,
which was marked "Backport Status: YES", it also fixed TTM test code
with similar characteristics - a small, contained fix to test
infrastructure that ensures proper validation. 6. **Test Code
Importance**: Properly functioning tests are essential for kernel
stability. Broken tests in TTM could lead to GPU driver regressions
going undetected. ### Comparison with Similar Commits: - Similar to the
"YES" example which fixed TTM test warnings and was deemed suitable for
backporting - Unlike the "NO" examples which involved more complex logic
changes or reverts The commit message is clear, the change is minimal,
and it fixes a genuine bug in important test infrastructure without any
risk to production code.

 drivers/gpu/drm/ttm/tests/ttm_bo_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
index f0a7eb62116ca..06a9b8e1d5bb5 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
@@ -340,7 +340,7 @@ static void ttm_bo_unreserve_bulk(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, ttm_dev);
 
 	resv = kunit_kzalloc(test, sizeof(*resv), GFP_KERNEL);
-	KUNIT_ASSERT_NOT_NULL(test, ttm_dev);
+	KUNIT_ASSERT_NOT_NULL(test, resv);
 
 	err = ttm_device_kunit_init(priv, ttm_dev, false, false);
 	KUNIT_ASSERT_EQ(test, err, 0);
-- 
2.39.5

