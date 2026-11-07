Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065276;
	b=hpP/zfjDIMgpMKNSpeCnrheQ4jE6P4Z2d7npjkBjzAJIjAZDZzUg3EfVBf1L+nbf6Gn/
	 PJFlh0OBjMLboP1Mt0dUDUEhUxUVJEZtPUKAj0BidTgT8mGeJVrLNWdYk4Z7T9PrRwx0F
	 LQg135Sh1iHpcRAFHMn+nLOBLuZnC7LPDbRh8NZ1FCHk88a4A8kFXJnsrqqPbKfkRw2+i
	 vSIryW0FihVeKcVB/pIw9JMHBnMj2z2U0XGqXew/rc0TIw3YazA2hp6IgqbwvYuHs6jc5
	 FFv29gAMYEl4lj2Jgj3OxmN7JozM4lORkSyAojgzvnRU8TvLShN+cOaSbox6SCKWzCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EOLAHHGBkelDAre/mfxA50LgSLtD73R5jsy33ZJKn/4=;
	b=pfJ6yf3k2s7qi8bLMJQpve6mhWef693gfh6vlMciMfU/lpC0YOnwoVkvmGtR2prJsdL/
	 JSerjQQQJxpDq3f0ebj3oYjUAj9BxyZyKhg+yboqXwQVeuA6W6ULoKhm4dn6jHfqrCjRz
	 BqM7Y9xyAw76Ayd+LTUt5d8NNs0xDRSREzq/O/dTxQiw9F/kSxBzcckmOeiXG3hstEJ5R
	 DtNOPqsBslLD52mGRRg645mqEQhcb8oogi5vSbP4oFmUr/dERGax55S7L/i0kBjvh3Ij/
	 x92cwFP0aAcjGmX6BJYsASPJASRsfZKQyYABaXmjdM/qXfXnjo8SHAtYisJsat01K1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUIMv2l9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3611606A339;
	Sat,  7 Nov 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUIMv2l9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E991F008A1;
	Sat,  7 Nov 2026 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065275;
	bh=EOLAHHGBkelDAre/mfxA50LgSLtD73R5jsy33ZJKn/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUIMv2l957D9Szr0PYVwWNqi7iqgSN3cx4xe3/EdLCAkJKTIW7L6q3ZvJj5hZg08X
	 VELY6/5J0I+cFt3vjL2L3r4f6uDu4YpyEAM2ufU9COmZr+Murxzzm4DB6UBNgOFLe5
	 2yIU9rkgHnHG5uRbLB8Omk5FgKYrAIkLooxnEi60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1038/1257] sched: fix stale get_pref_llc() stub for !CONFIG_SCHED_CACHE
Date: Sat,  7 Nov 2026 08:55:34 -0500
Message-ID: <20261107135007.987800177@linuxfoundation.org>
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

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit cac037a85c1971ec75c4d3edf5a28af9ec2a089c ]

Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
taking the task's struct sched_cache_group *, but only updated the
CONFIG_SCHED_CACHE definition and its caller: the stub in the
!CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.

Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp to fix UAF")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: <stable@vger.kernel.org> #v7.2.x
Link: https://patch.msgid.link/20261023023105.28829-2-laoar.shao@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b1e9ac883efae..b35e23f93bcd2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2194,7 +2194,7 @@ void init_sched_mm(struct task_struct *p) { }
 static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
 
 static inline int get_pref_llc(struct task_struct *p,
-			       struct mm_struct *mm)
+			       struct sched_cache_group *grp)
 {
 	return -1;
 }
-- 
2.53.0



