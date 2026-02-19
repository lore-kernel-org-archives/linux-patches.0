Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338503112DC;
	Thu, 19 Feb 2026 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466710; cv=none; b=ZSe3l2KR6/dsELylyfe0ESy4okkjWHnVeBO3kqvlE9SyeFrVMsJYEyHizLJyaNX2xAy3h1QSU8jYSji9HWSfPJe/+FlY9off/apW7qo+VVq8N4+j0rpU1oIMvF6JvpefxQ2xwd5+h10KOUxQ8FGkowpGlC4I7b3XUb485uAG618=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466710; c=relaxed/simple;
	bh=iX5gKxaTwXYEIEfEK8lcX9yf1CfI4OHAxvr4yNY05nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGYOGXviPI3JC3PATqwepWCm0SJsKybhyx7FSYMCnq52IiYHYNl8+j3L9ND4jMuqEMwCmBxTjxVn1C56hOxyXPf9YbqdmDRpvmr31iGgQdtI3r0PmIqrvWhQx+fa4Kit5xq4A5zwAV3GayDC97Dii4Wy+2Q6Zq/m7+OtiwLwbjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btWM//c8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btWM//c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433B4C116D0;
	Thu, 19 Feb 2026 02:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466710;
	bh=iX5gKxaTwXYEIEfEK8lcX9yf1CfI4OHAxvr4yNY05nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btWM//c8Tf3VeWdjULzmqHwa+MOqmTZ2F0bjuAPFiHYr7F9cds5z9Rx16ZO07V2A1
	 XBB2yd62cRrcpLxkWgoCwyrz5XzMbTaM7XdFeX5QKTZfesPslXlRnoG197lKUbxogY
	 Ugcx+rlkHFhAiHL6HZZsTPOULKFae4Xe227wBpMWHVs71yEiA5ddHR9J68SrFMuqNN
	 fXTKnvGKufj9gr1UEeBDlcP6DZ6Jmmpn7jl98m0K9lApnPJFCJJPP8SjQmU42X0Ttx
	 KRAptt0bPq2nLelhyvJagTRhw5i1q7oPrjxb4HvOVUNlNen6W5Z8dwA+q1uc8CAbgS
	 laFwJFu3Xj3uw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Liang Jie <liangjie@lixiang.com>,
	fanggeng <fanggeng@lixiang.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-staging@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] staging: rtl8723bs: fix missing status update on sdio_alloc_irq() failure
Date: Wed, 18 Feb 2026 21:04:12 -0500
Message-ID: <20260219020422.1539798-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit 618b4aec12faabc7579a6b0df046842d798a4c7c ]

The return value of sdio_alloc_irq() was not stored in status.
If sdio_alloc_irq() fails after rtw_drv_register_netdev() succeeds,
status remains _SUCCESS and the error path skips resource cleanup,
while rtw_drv_init() still returns success.

Store the return value of sdio_alloc_irq() in status and reuse the
existing error handling which relies on status.

Reviewed-by: fanggeng <fanggeng@lixiang.com>
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Link: https://patch.msgid.link/20251208092730.262499-1-buaajxlj@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The driver has a long history with 2020 commits, meaning it's well-
established in the kernel tree and present in stable trees.

## Decision Analysis

**Arguments for YES:**
- Fixes a real bug: resource leak and incorrect success return on error
  path
- Extremely small and surgical change (2 lines)
- Obviously correct - uses the same pattern as the line above it
- Low risk of regression
- The bug has been confirmed by code review (verified above at line 380)
- Reviewed by one reviewer and accepted by Greg Kroah-Hartman

**Arguments for NO:**
- This is a **staging driver** - stable kernel rules note staging
  drivers are usually not stable material
- The bug only triggers on `sdio_alloc_irq()` failure - an error path
- Staging drivers are explicitly called out as usually not appropriate
  for stable

## Verification

- Read the actual source file at
  `drivers/staging/rtl8723bs/os_dep/sdio_intf.c` lines 350-409:
  confirmed the bug at line 380 where `sdio_alloc_irq()` return value is
  discarded while `status` remains `_SUCCESS` from line 376
- Confirmed the cleanup at lines 386-391 uses `status != _SUCCESS`
  checks, so with `status == _SUCCESS`, cleanup of `if1` and `dvobj`
  would be skipped
- Confirmed via `git log` that the driver has extensive history (2020
  commits) and exists in stable trees
- The commit was reviewed and merged by Greg Kroah-Hartman (staging
  maintainer)
- The diff is only 2 lines changed, making it trivially correct

## Final Assessment

While this is a legitimate bug fix that is small, safe, and obviously
correct, it affects a **staging driver**. Staging drivers are generally
considered not stable material because they are experimental, may have
many other bugs, and are expected to be in flux. The bug only triggers
on an error path (`sdio_alloc_irq()` failure), which limits real-world
impact.

However, rtl8723bs is one of the most widely-used staging drivers (found
in many budget ARM tablets and SBCs), and the fix is truly trivial with
zero risk. The resource leak and incorrect return value on IRQ
allocation failure are real bugs that could affect users. Given the
minimal risk and clear correctness, this is a borderline case that leans
toward YES despite being in staging.

**YES**

 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 1d0239eef114b..dc787954126fd 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -377,7 +377,8 @@ static int rtw_drv_init(
 	if (status != _SUCCESS)
 		goto free_if1;
 
-	if (sdio_alloc_irq(dvobj) != _SUCCESS)
+	status = sdio_alloc_irq(dvobj);
+	if (status != _SUCCESS)
 		goto free_if1;
 
 	status = _SUCCESS;
-- 
2.51.0

