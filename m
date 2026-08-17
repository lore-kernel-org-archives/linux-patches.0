Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A673B4417;
	Mon, 17 Aug 2026 14:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975474; cv=none; b=fckA9PmI7NkplHuwYQrRr2A7W0p3YB7tPekz2ToZpIYDJGyDfk3tkX8PZsmf/gzolslO0ze26aCf1HH6PqMZcn0/ts3Hfp+FcUh3A/LDeS4ntTUsTyC1X8txiha4grvale9RSqjBYlPJJZ3O3ntGGhWOYWzJjzlyWUiKjN+jE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975474; c=relaxed/simple;
	bh=v1+3KJikG4+/yxQ8idyJrrIhtkm3uOjKpadIMddIu34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjJL2XyopuaW3AN8HHFfC9RrNQgo7lwifSo5nwrrnsIzL4xnJHwDvw0MPus57s8IGYDgItQI40/iAmIcVgJ9KZYkeP9D4sp+mXHm/Af2U3ZJczc4kAZBN52fkXWQKvMJi08hzwlaLTWj+s6Rp5eJUiXhxtdAq9aK/A4Pzu0fI7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFegdQ7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFegdQ7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4891F000E9;
	Mon, 17 Aug 2026 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975473;
	bh=+tPUEitEj0hv/c2uu54glQ3AJKkesM7AT+mE8uCw5XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFegdQ7DwvLQ6SPeQGcnzvvz/l/+Otzil5zZ5eP8VAN+J/rEk2d+eJ5NHqfcU+D30
	 SjeN3TWVjhs4wziLNGFquE9hMFZt3s2tbHAB0i2Q6Sf9QfQ7O0C8OU9xkRbe0Zew5H
	 z/L7TZx34q6fDCOj/6pRLgr5EToxLXOlIOjBZq4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emre Cecanpunar <emreleno@gmail.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/389] drm/i915/selftests: Fix GT PM sort comparators
Date: Mon, 17 Aug 2026 15:28:00 +0200
Message-ID: <20260817132540.595864896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6180a47c1b5114..9ec66ef774cf56 100644
--- a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
@@ -17,9 +17,9 @@ static int cmp_u64(const void *A, const void *B)
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
@@ -29,9 +29,9 @@ static int cmp_u32(const void *A, const void *B)
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



