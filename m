Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064517;
	b=tjdiDuVqzCbJkewKGjTQ8DIPP/mrC2uDARx6lF5suTiOCsKgxDcQ55MXj/4jp7qEjsVo
	 pQnmHrovmtUogZVMpwUP/405fod68Y8fRqUGUEqF3cDA0TnEucPQBCK9ozxXGcFOXQlDY
	 1kW6VW73sEpfFuxUk+g6GEVqxyowcdxzbVRJfIaQqYajDilXd1Ech0rNMnLJEJqRFFm43
	 JF6JkR7HUm3wC8GWlKgVvh4bU2cxOAITlj3GDUpfGPcWtDXw9opKSxn4pAnUE3cKxOqP+
	 nWUFxYAv3Qf8NFarWG8pcS4REeVD1TyiK7AOEMo6ZHXOs3nGjn5/ghk6brDIxld5Q3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H0qRvJLa+Xx9/ps4gEfRBwmqS3LvViowoldM8AvGCeI=;
	b=XukqMDB38AakPq9pNlqn4fM+hLj8pA5If/d1JBbSpEuDQaW7F9olhULZyWTlHZkvyJzI
	 TEvE8nec0ntZgbLiB4vv2b0xBlPh+1aCZaIDqiSNUKb/wvj4Cw13OhTHp14j4wVJkXNr0
	 3QVnU+nftQvf7EEJZ5KJHjL7O2id7OkRxGg5c8DkTEFz9KgVSv+1hRKteocudXYbGKumk
	 TdF2uuNU6IbvY065b1Hhf6rnwFeMPhwKcNOS/SMoqs9grwRJJNel+O75xSC+wrzo0CJW9
	 UjnRRJRT2huC/c2J215Kv71l78iaXRogox/f0UF+RFcbTip911P69wy8sty2TFRekwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Di18cMbm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8EA606B894;
	Sat,  7 Nov 2026 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Di18cMbm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6B21F0089F;
	Sat,  7 Nov 2026 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064517;
	bh=H0qRvJLa+Xx9/ps4gEfRBwmqS3LvViowoldM8AvGCeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Di18cMbmtGCNXRM3CWhPk1P3oOb3t63QqfBWOJTMRrhUqgL8QkCQBidYoORZHChgs
	 s7OpBNp7u9WEWZssws+YJDD8Wp5lHKd6zjb/Gg6horZPdqN/y/JVZ/doamZTUQMLOA
	 ei1nhVJL5NJ5f8cx/KTYgdKWah7kid6ESY/8oWck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0510/1257] mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
Date: Sat,  7 Nov 2026 08:46:46 -0500
Message-ID: <20261107134953.520524794@linuxfoundation.org>
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

[ Upstream commit c4b1ae3837ff381795f1fcc18d827fce48c4e89b ]

In extreme unlikely situations, total memory might be zero.  In less
extreme but still very unlikely situations, lruvec_page_state() calls
might let the caller show used memory larger than total memory.  In the
two cases, damos_get_node_memcg_used_bp() could cause division by zero, or
return underflowed value, respectively.  Handle the cases by respectively
returning 100% and 0% for used and free memory queries in the corner
cases.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-8-sj@kernel.org
Link: https://lore.kernel.org/20260329154813.47382-1-sj@kernel.org [1]
Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c00f1651b04a6..f4b586188c68a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2876,6 +2876,12 @@ static unsigned long damos_get_node_memcg_used_bp(
 	mem_cgroup_put(memcg);
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < used_pages) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 0;
+	}
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
-- 
2.53.0



