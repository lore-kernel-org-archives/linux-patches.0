Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB112E8DEA;
	Mon, 17 Aug 2026 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979094; cv=none; b=OtvriGC0m0pfYznivQtx0MooJTCumpCYn4LFhiEFudPSPuT+ig3bOi35wf2/xzymUtqtEZyxP4Ys2OOvMU/iUZLDFOKNFF4PFcEAql9kHGQwhx9VhYRcdR+p5KOI5AkJuMeMmu/P96V2BSw8QS7ghLtugwM1T5MBICAfx25q5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979094; c=relaxed/simple;
	bh=4EjA/qMgSDUobzBRc3+dE/+Z7/jbaseRAa0vVTv6oNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrLCvFhEZKYRSmEUBJDedrlzu/tmOo5A08c/DsHuyXqfzCmSa3U4j5tkm+S193+zBko7DDLIhXfLxjboMfTvSMtvZgiy/ERUSLAfkbcqiWw6T2f4cD8Vrw136HbY9oIDkF3sqDCZPTuDxsTzhjJyOevflLJPwITMqiQ3/tzk4Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=om+yw89k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om+yw89k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FFD1F000E9;
	Mon, 17 Aug 2026 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979093;
	bh=UEaY7cuShk+aN+u2Yk2FdVFAgG8/xCqVuId5eMCCptY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=om+yw89kYuJLT7NtUPE7083ha9KCZRLmxIeDj1VMELhRXpgvcF9DYdF9EyBpIP8jQ
	 MnvPUJAYu91gVUkm1DcjbzdKqPXMsGg3zJL1gQypUzwQKUk2biZESVFk9Pcg9+Equc
	 aJtnIGPvq1nRbG9t6Tdn6Wx3FlwSA1RXZ+ZADNH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emre Cecanpunar <emreleno@gmail.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/609] drm/i915/selftests: Fix GT PM sort comparators
Date: Mon, 17 Aug 2026 15:26:05 +0200
Message-ID: <20260817132545.803847966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index be94f863bdefff..0e237bcf324a83 100644
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



