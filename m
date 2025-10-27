Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BD531B83D;
	Mon, 27 Oct 2025 19:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593487; cv=none; b=IyU5nYvOSAtixa1xNmE03D5h7IU7zkgMAUPB5/WR7DT9U5W/9zah4F/4MHuy1QKHkEY9YPSybIm5Z0K+jwfIRem+kiVRCGXMBuuyxXsw9YQwSNm2YxCBMAvTPLV54n5vqUCDG1g/t4dl9p6mm+cGT7wp6IKyLtmqzNjveczpuOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593487; c=relaxed/simple;
	bh=bPTU8EpHX9ppSRlclruzqetrzsOoc3JdhS/fxBoofK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV0z9LuuGGmsH8w6NG36uN/vtt/M3sx3dydgPZSF6pT4yL7y+Qh3n4+0vujygJ/OxhAuWCqp3WmSUJ2ESnqwDBTeW0/5kdZaRhLlaZRZPN9fMEFvx+/U8rdqDDQ2MxARlzHEF3LNjS1avo7ocX/6UQX2yhPHHL+n0qQ/HU+ewnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWHv4rNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWHv4rNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC980C4CEF1;
	Mon, 27 Oct 2025 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593487;
	bh=bPTU8EpHX9ppSRlclruzqetrzsOoc3JdhS/fxBoofK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWHv4rNRi43rXeQ+WsKmpJLzXmMr2G0+JZhSG4mfwQri0b4ZXyLaeFCADuhBgnCEM
	 YFJuYzJb1Z3dojSsYlgdTwkhJmAJuVVPUClfLe0s3m7kkuOSUNq/OlDqiLVyKcIxu5
	 72Rj/5yPaVQf44Gmv3pDLF8YGAbEYDzX674Napr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 148/184] sched: Remove never used code in mm_cid_get()
Date: Mon, 27 Oct 2025 19:37:10 +0100
Message-ID: <20251027183518.923533165@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index cf2109b67f9a3..72fb9129afb6a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3735,11 +3735,9 @@ static inline int mm_cid_get(struct rq *rq, struct task_struct *t,
 			     struct mm_struct *mm)
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



