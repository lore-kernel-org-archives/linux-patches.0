Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065341;
	b=ATI5SN71S7KoK60JH7YQgkXHmR5cDjfNL+0VRu7CKyonwQtjr/mWWsqm5h9NjqJQEam3
	 4oEllbnC9U4PN7oOp3NGBa5uKWMMKCM5Q86UVWBP1U+jvUNtutqKHK7fR2sQ9Ckw4oF5P
	 khOHtqGOlURlx15hvPGjxiB/GY51tVLF0/cYNczX+dKX+7yIETZhYSX7JthOM3K8SexEL
	 YAFzhHYWvRlNY9xcpNUrmUWxWsBq+m2apO8a2R2GBqGhnOMzhsYBA4Ph3n1CPcC2VP8ur
	 CCUd82yMW6c2IFET8qQYAqM8bE87MIMLRXuaLLsgQYlLomFB1dYUzQYC7zeOyZCi7wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=THt1Kv2G0woN18QVW/f36rw5CNthBbJyZTVxLhhe7MI=;
	b=PJHXOrexFY69I8EzARjyLU3rTNHCBbzdKzmiJ1e7CkIWIJJdK8VVZZEmQFpiCCSC9w9Y
	 hl7hw+Vk87WKcO/SGLgBVDV8vcEKu9ngLC69FwOBrppyDbcWfIJnfDXrWLG30I/Oa72mS
	 9RrghKwkTklBZ2kulhik/ZMRGalNzKespzORpjPA9e0jVEh+A+wHbdA+LM5teeX+mx/9w
	 r6lJIx8HYQXdcl2vEJ1VjeoaQdLFB9GIrhMFzW0HwHCjviHrUE2hn60cVhHo04I71NOyu
	 qxxfNIqT7RoypW3CjF2q4m6HqDPtgb4wAQJnC8+NIEjqTGowNzXtVZ6PEsoXrSipxCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVS78WBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8260606A32C;
	Sat,  7 Nov 2026 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVS78WBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194381F0089F;
	Sat,  7 Nov 2026 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065340;
	bh=THt1Kv2G0woN18QVW/f36rw5CNthBbJyZTVxLhhe7MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVS78WBOQEQdruvSkQa2LJWJO2iDrm6ERkA2JtAnpyPl56KUc3s0FCiD2BHp9WS+1
	 nE3apcWlnRu1hSyxqwGyqwwgVKfoDpSI92QeZdsS5prNgNP0ObmgUotBva2XnmpbCE
	 UDzF3PuJJYPSMtnktErKA74gRic4q3ClobM4u1rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1077/1257] mm/damon/core: preserve the quota passed to damon_new_scheme()
Date: Sat,  7 Nov 2026 08:56:13 -0500
Message-ID: <20261107135009.011457967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f73ecbc0589c8df8f18e444f5f633de01ebb0d98 ]

Patch series "mm/damon/core: preserve quota state when constructing
schemes", v3.

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates.  Constructing the
temporary schemes clears the running schemes' quota state because
damon_new_scheme() initializes the quota passed as a parameter before
copying it to the new scheme.  Even an update later rejected with -EINVAL
loses the running quota state.

Initialize the new scheme's copy instead, and add KUnit tests for the
constructor and for accepted and rejected context updates.

Note: below are test results and changelogs that could be removed from the
final commit log.

In the v1 live test with damo, a scheme with a plain 64 KiB size quota and
a 60-second reset interval uses its quota, and a full "damo tune" with
unchanged parameters then lets it try another 64 KiB within the same
window.  With the fix, sz_tried stays at 64 KiB.

KUnit was rerun after the rebase on x86-64 and i386. With only patch 2
applied, the two new tests fail. With the fix, all 46 DAMON KUnit tests
pass on both architectures.

The v1 DAMON selftests showed no new failures (QEMU TCG guest; the
wss_estimation test missed its accuracy bounds with and without the fix).

This patch (of 2):

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates.  When
damon_commit_schemes() creates the temporary schemes, it passes the
running scheme's quota as the quota parameter of damon_new_scheme().

damon_new_scheme() calls damos_quota_init() on that quota before copying
it to the new scheme.  This clears the running scheme's effective quota,
feedback input and charging state.  Even an update rejected with -EINVAL
loses the running quota state.

For a size quota, this discards the bytes already charged and allows the
scheme to use a fresh quota before the reset interval has elapsed.  For a
goal-driven quota, the consist tuner loses its accumulated input and
restarts from its minimum input.  A time quota loses its throughput
estimate and falls back to the initial estimate.

The end users will show DAMOS works more or less aggressively than
expected for online-commit updates of quotas.  DAMON provides best efforts
by default.  DAMON parameters online commit is supposed to be executed
only occasionally.  Hence, the issue wouldn't be critical on sane setups.
For user_input type quota goals, online commit of the user input score is
expected to be frequent.  But, for the case commit_schemes_quota_goals
command is recommended for optimal execution, and it doesn't have this
bug.

Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
destination") introduced this problem in v6.19 when sysfs validation began
committing the running context's parameters to a temporary context.
Commit b90408ef1163 ("mm/damon/core: safely validate src on
damon_commit_ctx()") later moved that validation into the core API,
exposing other callers including DAMON_RECLAIM and DAMON_LRU_SORT.

Sashiko reported the same side effect [1] on the RFC of the core API
change.

Copy the quota to the new scheme first, then initialize that copy.  Make
damos_quota_init() return void, since its return value is no longer
needed.

Link: https://lore.kernel.org/20260928085835.7675-1-sj@kernel.org
Link: https://lore.kernel.org/20260928085835.7675-2-sj@kernel.org
Link: https://lore.kernel.org/r/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
Fixes: 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic destination")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: <stable@vger.kernel.org>

only occasionally.  Hence, the issue wouldn't be critical on sane setups.
For user_input type quota goals, online commit of the user input score is
expected to be frequent.  But, for the case commit_schemes_quota_goals
command is recommended for optimal execution, and it doesn't have this
bug.

Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
destination") introduced this problem in v6.19 when sysfs validation began
committing the running context's parameters to a temporary context.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4290e2a1c7e8d..6dd2ad9636a34 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -668,7 +668,7 @@ static bool damos_quota_goals_empty(struct damos_quota *q)
 }
 
 /* initialize fields of @quota that normally API users wouldn't set */
-static struct damos_quota *damos_quota_init(struct damos_quota *quota)
+static void damos_quota_init(struct damos_quota *quota)
 {
 	quota->esz = 0;
 	quota->total_charged_sz = 0;
@@ -678,7 +678,6 @@ static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
 	quota->esz_bp = 0;
-	return quota;
 }
 
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
@@ -710,7 +709,8 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init(quota));
+	scheme->quota = *quota;
+	damos_quota_init(&scheme->quota);
 	/* quota.goals should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
 
-- 
2.53.0



