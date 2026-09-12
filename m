Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D4B5475F;
	Sat, 12 Sep 2026 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224169; cv=none; b=itwVdxcBx6dy1kfhTsZyFN0WpK/jyctVsVM953a5in1ibN40QEsF9kXP6p1AwXy09D0VSUZveYtE+sa3A1VYjuFT9pCJm1nIVGa//wxXggIaQLVZWKLNu6UGp0Mn+UkJ7rEkO3FaMUzJb2wY2vC+KQrrSUzbGu3TLkJmzaddPnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224169; c=relaxed/simple;
	bh=8Swn+/nc63nvfZzXmTbHkRPJi0Rud7IZ3vCbt+RnuV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2SCIMZ+LEu+yru5hiKy1q/AI9ZpvyJ03HoZ//BHI/8IJjDWyjqUM6qVHhtfTH5S0lbg0Y6dZSJNV8PDYWHqlhS9jhtCu2uWDD4nj03wmxF8szjWXTT6REBCNg3jAl++iAu9FEPBIsXLEICs4/ELyI1sGUc5YSCZDBq6YbKv1O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euLqy74J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euLqy74J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE1D1F000FF;
	Sat, 12 Sep 2026 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224168;
	bh=18a+BFqt+8yCc+J18w5zr4iiIU/7snrOE2T4TNVFfWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euLqy74JlwNPhrmNWYMjKz8iqGavWCO6pwudNFaIR3r8Nx/XmrNl7tdzA1YXaQ48Y
	 i9yKdcFNDpF1/oiuu1J7LlG3GPytRBdsN2PPCtut9tExYx1i6sFlLR24l9n0ZV3JZH
	 kU0HsyMIIUcaLjKAGH7ruDL8Die/zUQRVfLqi/gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0937/1424] rcu: Remove unused function declaration rcu_eqs_special_set()
Date: Sat, 12 Sep 2026 08:56:09 +0200
Message-ID: <20260912065628.304816808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 559f758bf2eaa..daa94d3b458d7 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -37,7 +37,6 @@ void synchronize_rcu_expedited(void);
 void kvfree_call_rcu(struct rcu_head *head, void *ptr);
 
 void rcu_barrier(void);
-bool rcu_eqs_special_set(int cpu);
 void rcu_momentary_dyntick_idle(void);
 void kfree_rcu_scheduler_running(void);
 bool rcu_gp_might_be_stalled(void);
-- 
2.53.0



