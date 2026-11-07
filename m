Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064473;
	b=EDHsipYtXeFWcnbDLtrLB/fvG0tIMSa+9bTQ8n6h1fhH4+xn55pzdLT61asuwFlrWy/4
	 oYrdI8iO/vO8SfPr5zW7oQjeox4WYc6hE2lNpoZC2ikRhzVkCUJusww13eh4a/9Ulqq/E
	 N+L7j8YB3ljddyVn79qDssor2z8wkj1tnRMWfhyi5mi855ypZevobJIxI/jK98Ana8vJe
	 nVH49EZOYUW/4DUCMRsKqQcy6cXxMZyD0ZuS5wSMqpXRzfITH4ViqgTQPjQaNIyK6AfCP
	 yQRpAO0Zk3SZr2ilvNK0kKORXFIbWzdoQ/cK9WxF0HHD+eLY9aQ9/37H8YYMQLB2JtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pH00ytQfhBBWE0IqymSDq1MD61CdVxpr/8LrZZ3kTLU=;
	b=i10ZWBjjunqehhjrokjhilxFDtyCKwPKEjPzE371YM7fQ7YjwUz3nTrn8gRTz1IoL1wh
	 DUVTsJpOKYM5QkKKHu2WK71UP7Zrd1n9fT24XTQOlOrVzA++x1wRr9ON9Fpk95nod0dDA
	 8Stc2Bz6w+5+EyqVqh3IA3qlV4UYtD+i2S0IfqeACnF7mwQ2LtCuKN4S+/x1M4Alwz0oU
	 zwNfvHeoCUAAZySB1LyJ3GrYWjx24nRh8h0lAPL+sCpNb5QoTbg3MUlKJFwnVDoQVvWg8
	 KLumicjGIkI26Fx9LKe80QCJtqP5MXuEYcjm9ohn6TMYdNzSby06dJwhMaL2RvEFxqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgrv3VzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D543606C015;
	Sat,  7 Nov 2026 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgrv3VzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410DE1F008A2;
	Sat,  7 Nov 2026 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064473;
	bh=pH00ytQfhBBWE0IqymSDq1MD61CdVxpr/8LrZZ3kTLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgrv3VzWYUleZ4mLFMl/R2aSwYRcDhGt3cRg3DqDayZY2bR+f1VWIoFskuo8ospol
	 vS9UgY4xcHGSzn5X82JA4jWj+0ZcVv/TCIApLfcupBBl4wfgeb87OxhUHxVkFfVBas
	 QXdUlRFt22IloIc1n3Yb01OhJ+vXbq/JRyxZVk/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0513/1257] mm/damon/tests/core-kunit: test committing psi goal to psi goal
Date: Sat,  7 Nov 2026 08:46:49 -0500
Message-ID: <20261107134953.603408620@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 938d5db367967e7dec5db0a6fd189112deafb8b6 ]

Patch series "mm/damon: fix misc bugs in kunit, quota goals and sysfs
refresh_ms".

DAMOS quota goals commit unit test is mistakenly not testing a test case
that was designed to test.  DAMOS quota goals and DAMON sysfs refresh_ms
file have bugs that can produce non critical but still unexpected
behaviors.  Fix the bugs.

Patch 1 fixes the DAMOS quota goals commit unit test to cover a mistakenly
uncovered case.  Patches 2 and 3 fix the bugs in DAMOS PSI goal
initialization and eligible_mem_bp online commit, respectively.  Patch 4
fixes the bug in DAMON sysfs refresh_ms file handling.

This patch (of 4):

damon_test_commit_quota_goal_for() is set to test committing a new psi
goal on an existing psi goal.  However, damon_test_commit_quota_goal() is
mistakenly not covering the test case.  Add the test case.

Link: https://lore.kernel.org/20260902002725.108635-1-sj@kernel.org
Link: https://lore.kernel.org/20260902002725.108635-2-sj@kernel.org
Fixes: 99f89debafc5 ("mm/damon/tests/core-kunit: add damos_commit_quota_goal() test")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2d..b643f9a83f14a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -787,6 +787,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 		.last_psi_total = 456,
 	};
 
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal) {
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
+			});
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
-- 
2.53.0



