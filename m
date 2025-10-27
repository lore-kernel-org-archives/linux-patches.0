Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E798F241663;
	Mon, 27 Oct 2025 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592777; cv=none; b=qe0y8Vftg39976u+2B6/jnmMc9eo5/Hjvf/ONG5xmJN36fBF0YWhegUBrYGtdR1aCht0gjlRqGUNYFHqBz9WXyv2MJ+jgFRQg8afJUozeO3lpTDw9/vOT5E7+85WYbarDhDaqUrCfexgsp9v3JgD+4wnkNvaU94FLCurISCQ9lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592777; c=relaxed/simple;
	bh=GUT2OYoUJNIsa0GlgNAmvnBaPF63FjxwCv77Ihboj7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWdw6SVbe3wtMZIWPWr5xEpYcPpm6ywZu20Yi9FyBGm0zpdg4TQjy3AuRkWrvj5AA2/qCNg8u7T+OYzuSxZuZIR6ILBruKKZrE2mJsr9jL39mZ5WZECGVipZwJS0iSwj6eSmc5fUIyRwCfPt1dl9IJkIGMYBhnJF+0pVeTK1QV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fE0OrlYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fE0OrlYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C60DC4CEF1;
	Mon, 27 Oct 2025 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592776;
	bh=GUT2OYoUJNIsa0GlgNAmvnBaPF63FjxwCv77Ihboj7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fE0OrlYZthVob/OjKdqm/SLfZd86Gf324miLzlsue4aYFl/nvBobIyVjlplEE8A3a
	 rlit0E99SE+8Zt4M0kdGLPqXR4e08iH5bTeYJqB5SHE9rMct4Yk2aXmplQ5gufULk6
	 75ZDGX5yJzE/j/djw7yGIIKDdNjGjHUUpY6Xuuv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 58/84] sched: Remove never used code in mm_cid_get()
Date: Mon, 27 Oct 2025 19:36:47 +0100
Message-ID: <20251027183440.364805080@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 53abe3e1c154628cc74e33a1bfcd865656e433a5 ]

Clang is not happy with set but unused variable (this is visible
with `make W=1` build:

  kernel/sched/sched.h:3744:18: error: variable 'cpumask' set but not used [-Werror,-Wunused-but-set-variable]

It seems like the variable was never used along with the assignment
that does not have side effects as far as I can see.  Remove those
altogether.

Fixes: 223baf9d17f2 ("sched: Fix performance regression introduced by mm_cid")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f7cb505ab337a..64634314a89ce 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3435,11 +3435,9 @@ static inline int __mm_cid_get(struct rq *rq, struct mm_struct *mm)
 static inline int mm_cid_get(struct rq *rq, struct mm_struct *mm)
 {
 	struct mm_cid __percpu *pcpu_cid = mm->pcpu_cid;
-	struct cpumask *cpumask;
 	int cid;
 
 	lockdep_assert_rq_held(rq);
-	cpumask = mm_cidmask(mm);
 	cid = __this_cpu_read(pcpu_cid->cid);
 	if (mm_cid_is_valid(cid)) {
 		mm_cid_snapshot_time(rq, mm);
-- 
2.51.0



