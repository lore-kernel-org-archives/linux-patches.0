Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EC8390CB0;
	Thu, 30 Jul 2026 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423687; cv=none; b=r5kx2cX6sNSG3+W+x+HHY7hBQbYOPvLyZuIdEeVQBJ4iBWyAy7MutsAtBy+99agNZtXSknniTBkwCCp9jWxPjJkCJsHiJc1MwhSLMQt7JC3ihm8S982t4l2BgUjlEG9x9RhD8VsPeN14g43LOGf6PmPcnAacm3n7N33DZyliKac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423687; c=relaxed/simple;
	bh=GrMW0n3XAQ0b34aFJNMTdkhaPgx6s05YtBKnLugPdUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOyVUzrnZ+3EKmkFe9I4dnv1ifCgaMw4AcDWpvqHurEFWeBmvxm07+ui9LQL5CClc2UIQeBKQJFbvgZNKVZyLtnchTMSuZmq/96/w7csQL6eOm7IQgHFrhF+waWNSVLoYHBmB3mdowNyK8R1QolwztcSsAet5xeOYVsmPzQkIAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fx2DM+YQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fx2DM+YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C88B1F000E9;
	Thu, 30 Jul 2026 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423686;
	bh=RmN+4zoduAql38usvGEzivvBpdjpa5/Ru77Dim3S3qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fx2DM+YQk9uwH/y544STI1B2wG58i3kboEJ3mqjuCeB+Gft0HKZc+Btap1lVjVys3
	 i2H1O2hYlnjtUXBDT20P5XYurc34l/JtygsOLRuuDsb6TgPJErjV9VSE88U7RUvQZd
	 0n5ItFzLgq+ila0K4EyAENGWoR+wlppquWb0f2E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emre Cecanpunar <emreleno@gmail.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/675] drm/i915/selftests: Fix GT PM sort comparators
Date: Thu, 30 Jul 2026 16:07:42 +0200
Message-ID: <20260730141447.949222559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emre Cecanpunar <emreleno@gmail.com>

[ Upstream commit 612978b83f45bf7018815209db5395d759db6f26 ]

Compare the sampled clock values instead of their addresses. Comparing
addresses leaves the samples unsorted, preventing the code from discarding
the minimum and maximum samples.

Fixes: 1a5392479207 ("drm/i915/selftests: Measure CS_TIMESTAMP")
Signed-off-by: Emre Cecanpunar <emreleno@gmail.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260714220430.238433-1-emreleno@gmail.com
(cherry picked from commit 682ea2d28d18bb06f9fc663cb5ab7e80dc0e606a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
index 33351deeea4f0b..07eaf71955c447 100644
--- a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
@@ -16,9 +16,9 @@ static int cmp_u64(const void *A, const void *B)
 {
 	const u64 *a = A, *b = B;
 
-	if (a < b)
+	if (*a < *b)
 		return -1;
-	else if (a > b)
+	else if (*a > *b)
 		return 1;
 	else
 		return 0;
@@ -28,9 +28,9 @@ static int cmp_u32(const void *A, const void *B)
 {
 	const u32 *a = A, *b = B;
 
-	if (a < b)
+	if (*a < *b)
 		return -1;
-	else if (a > b)
+	else if (*a > *b)
 		return 1;
 	else
 		return 0;
-- 
2.53.0



