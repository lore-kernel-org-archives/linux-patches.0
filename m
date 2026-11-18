Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033309;
	b=ZtLrPoLbArjHWfM7l0sqaI75o8mlxfOoTsfyMP0SZoLBLlc/fTes2/FCSzCq/QauKqQ9
	 aTdunFVAMNF6O3Ojvl3NFonTfs3P1SR/Og7k7M59wsArSYc9OLmDWoMy+Q10gIUiv1tLD
	 e31TQ/uTkbC2IHNilfbK4nEPYmdRjBTh5k8xIUzDvO+9My4ecLCSMDWQogb+7NfCWOn30
	 fR0LBtZ1L+afWph41EBQUQX93OymXPYBOSdNw/I/YFwxB3GIFsBr+LRdECaJZ6I+VOx2j
	 Q/PV2oh7VbqQYdBDf5IbZvIbjrS5rnmrbXw5Cmxs4ylSwhjIs1Hg3WxPRIXhCR/K6cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vYDoITqv0HFTz9AefZQkzZdwcHYmlc4taDvvJJZuEvs=;
	b=UyqYeM6pjZ7Yp37gEFS6aAI0q8rVUCYcfs/ayUktddUev0ei4SIXRsvFVcyt657XUYda
	 4Oowj4FHO3Kt6hbYIvFUcnohwPZEi5kVxnNmQ9C2T02wHYrhdQrFgwoIOHyrIttsjdc6q
	 YRPf+gHEmoxLdvNGx+x6KiKTo/ZZ2TMzQYJLrPEo3ElQKA5PhUf6ZQ4zngiR504Tnk2J/
	 ZpwEpQm9VjcWDTA/vHnP1fPcXiyirOUtKn59v3h35ruI6xx1ZsUh/BYlCYN2qGPbh4ZWV
	 2KwMlP8SWPQHjZVz/ceUXRMQiLharzrblShEDB4w/gyBsebXrzZniXFKkfWXNSyMUug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phuNGCGy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9867A606A32C;
	Wed, 18 Nov 2026 20:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phuNGCGy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9331F000C4;
	Wed, 18 Nov 2026 20:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033309;
	bh=vYDoITqv0HFTz9AefZQkzZdwcHYmlc4taDvvJJZuEvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phuNGCGy/uh8xkC0UE8mpOGEoLtiNIuLP8LkZ1vM/vbIa/oOiOgJM67q71dQM5taG
	 lPBv6GqyfRdGq+KWxXX2tWUMBdHUH7Ce2IWB+HVvwqJR7WVBjeILk0G2e3UF5yGpZF
	 9TH19tToYSfA+fB0NrG9rRfbfZ0n9WnjDDE8/vSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1722/1756] mm/damon/reclaim: use parameter context correctly
Date: Wed, 18 Nov 2026 16:04:09 +0100
Message-ID: <20261118150118.137241067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit fed48693bdfeca666f7536ba88a05e9a4e5523b6 ]

damon_reclaim_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is mistakenly
over-writing the monitoring attributes and the reclaim scheme on the
running context.  It is not causing a real problem for monitoring
attributes, but the scheme overwriting can remove scheme's internal status
such as charged quota.  Fix the wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250706193207.39810-7-sj@kernel.org
Fixes: 11ddcfc257a3 ("mm/damon/reclaim: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/reclaim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 9df096218beb7..254d84166131f 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -190,7 +190,7 @@ static int damon_reclaim_apply_parameters(void)
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		goto out;
 
@@ -198,7 +198,7 @@ static int damon_reclaim_apply_parameters(void)
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		goto out;
-	damon_set_schemes(ctx, &scheme, 1);
+	damon_set_schemes(param_ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
-- 
2.53.0



