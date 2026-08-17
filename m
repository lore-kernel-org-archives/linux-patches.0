Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320D313790B;
	Mon, 17 Aug 2026 14:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976654; cv=none; b=m1QXQrscviksqVNN1w8/26OFY5dUdqFx6Yj33QkGROvZ2qb3H+9Leix81+3M7BFWZwlW5o0oQu3wqY/uzeSnnC3amTTB+wzYKrGFMqr7PwN5rKTqz84h93odU0fiZVNRyfzEwY48Jw7SdAnzGY03bes2LIRZ3Jf+/TJ6jMk2V/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976654; c=relaxed/simple;
	bh=Efr/TXteRGHkh6d+RQjQ49XstxReXdUERs9NtpR/ntA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqIsYZ94pljKRfBbl2A5m2D8ooQ9XjTpz1prV5T7ATUAirZ+StMF09j0S8/4OMpzh5pAGVnZdU2vPrktBGw1IX5ORp9hSDY23mPZQOPQN8Y3MLfZOtCsrtUrqCkqlq+3YTmhZJjkAwyidzHKT4apmZdwSACfFUZqarqM/eJzUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqYWIz67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqYWIz67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10A61F000E9;
	Mon, 17 Aug 2026 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976651;
	bh=s+N73hka3qPcJ5V4CsGtzWhvhTLrizSMrBBiH7BRO8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqYWIz67EjQJQGui/VNqPBAvg+u9JzfdrIpSkP1n+n0Wkt7AXoBmrEdGtFE9erZj8
	 giZZRcC6NYQnutkayVcEXTWLLSX6pqFiGOWSf1nabHnnh//xBAr9BDoMBVvyfUQD/d
	 FFkC+/3bUjUm0RJhdXbJ7/wO13M7b17QtnOgL6NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emre Cecanpunar <emreleno@gmail.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/456] drm/i915/selftests: Fix GT PM sort comparators
Date: Mon, 17 Aug 2026 15:27:25 +0200
Message-ID: <20260817132542.198780225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b9441217ca3d4d..f8f66beca5340b 100644
--- a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
@@ -15,9 +15,9 @@ static int cmp_u64(const void *A, const void *B)
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
@@ -27,9 +27,9 @@ static int cmp_u32(const void *A, const void *B)
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



