Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6DB31F9B1;
	Sat, 12 Sep 2026 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230259; cv=none; b=utrkmz8Y+FFZ0sAK/jhk0pP4lZkqRiGXlQCR1T8KWIM2LY8IZ/3mpZLyu34d/3WAW2zMVfFIccVexRYxEZQ1HfQv/VHdvEWwwMWkR/ua8j9dA0LXKJaEhwgZhtkJDz4RdIOqAeLF55Z9sST94EvsnwAKmTLBqLNPHGswnqw41kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230259; c=relaxed/simple;
	bh=4X2/bll13uNVYbh+NCeiO0v3+4bTh4i1vSPFWZLchRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEOW/WXruC6E+mnJucqJl5Sa5agYlUW2y8fvhbmsIIQO/0AjNI436yeQLkRkkvLazNHvzNppQVcCHosxBbM6wAoVmx14rLpD/SLxQzNnIimCxlGhprwSH2bC+isKRmdrNe+O1RyfrcvmInVomgg56X0Be0ZR6+sNh2kSMFD9+mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsqwLduV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsqwLduV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645371F000FF;
	Sat, 12 Sep 2026 16:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230258;
	bh=lTAcOEHhY0ESlhqEQW6fypYE8VdgxbOrSYiaISquuBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsqwLduVDhJXuo15UN+v6MjiM4OfzRufsTZJooYZIIX4Af6gHT7JlxL0unzUnpoWQ
	 HYI0kwzERCPJFhoJfsiT0Hw23ekYySuLlGCHlj7Pc0qprRp9C1RsqQStBECOdei2/b
	 +GhBkdSo+gk0hG8v3Kb7SMFWHSxHEXPiOBzXrNE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0757/1191] rcu: Remove unused function declaration rcu_eqs_special_set()
Date: Sat, 12 Sep 2026 08:58:05 +0200
Message-ID: <20260912065605.280904713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit b93c5fe16e4aa177cd072c1c4652cbe1b19a7812 ]

Commit a86baa69c2b7 ("rcu: Remove special bit at the bottom of the ->dynticks counter")
left behind this, remove it.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Stable-dep-of: 27d73e81195b ("rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcutree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 54483d5e6f918..dd68a841dcbd9 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -36,7 +36,6 @@ void synchronize_rcu_expedited(void);
 void kvfree_call_rcu(struct rcu_head *head, rcu_callback_t func);
 
 void rcu_barrier(void);
-bool rcu_eqs_special_set(int cpu);
 void rcu_momentary_dyntick_idle(void);
 void kfree_rcu_scheduler_running(void);
 bool rcu_gp_might_be_stalled(void);
-- 
2.53.0



