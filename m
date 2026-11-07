Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064516;
	b=TPaX0sh3sTipX/VmN7uHYOeIJSH5nyJ+NzshM90rRv9OPYA6dGK+QXAZqUvBIlp7i4Nx
	 0BAE064YczSUw2MbI5CkPArpvMJnnyMreTvtEzEDXkPZC32rWchTsLmoGGXD95mapNwCw
	 JnB7YVesPQKnjiELn0/+KoNfKYBAHqjVKWqVvTCyh1Q9wOwHyaoxiCTw/FvvtjMga3vVX
	 sga9B0nflDMS9gyBi9msRDH9aP6Glmtc+Jm2KR0pURfQTO8xQSwSRYB5nOMH9kxpPr0CM
	 ogtojjJOP6ZHv4aE3gvoz9e90Q+6X91cOqRNnQDlXZjArfZXHfLcm7otuCcoXdAiUPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=snKA++2JFXRI5IAZBfT0P+WB5t6c7XX9OU0gHIFWCmE=;
	b=2pElS0f8dcdUTuRATE+m2OOrAep9bmVQ6vemhxdw9pJ01Zh9yGZ8UhYDWrGR3kwmkLc4
	 GOoegaaM59KeaTHCgS/C6tpqxIsPWmWhaoQuxjw7Bn9p7cpeN8JvxJTfOjvWSVEq7U0MU
	 ftHmRcG3gLUf8Lp4JlSq1xHKN4Nw0ItTxOzbKUJZhmsRqzqnc6ssEIX2fLdTwA+X9bmk9
	 IMFRk/s0nIhUEnk2Xy7KUG8RGPx0Qjk4fEnsKZ5Vt8UZZgzyOmxIiP4t/b9kotnJ2+bJ6
	 Z75YjVNN5avO2CnJnx0J9B15nSQ9k93a2PuXxO10ctBS+yHyMqUl5kjukn6Xs45bg0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pne6j9m4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B75C606B894;
	Sat,  7 Nov 2026 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pne6j9m4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1EE1F0089F;
	Sat,  7 Nov 2026 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064515;
	bh=snKA++2JFXRI5IAZBfT0P+WB5t6c7XX9OU0gHIFWCmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pne6j9m4SIxJWMe1egjz9+guXVNcH+sLeRaYEmYF4fyW3Vglik0q4RtN5TN2QrNYf
	 qC+4bBY8e4swnkDQyy9jbYXhPwB8QlwxtquUZGV+ksoTDWCRLsEpDThX37GGRGAAZO
	 rF3PHXiKm2Uqx8hI6Dwb+jyF4gg9HvcDA0c2Xi+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0509/1257] mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Sat,  7 Nov 2026 08:46:45 -0500
Message-ID: <20261107134953.493924680@linuxfoundation.org>
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

[ Upstream commit 485a9149ad406e00949327a3231b9084d7073706 ]

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  It could also show free memory larger than the
total memory.  This could cause underflow and make DAMOS temporarily make
unexpected behavior.  Thanks to safety guards in the auto-tuning feedback
loop, that should not be a real problem, though.  Fix the problems by
respectively returning 100% and 0% for used and free memory queries in the
corner cases.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-7-sj@kernel.org
Link: https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org [1]
Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b3390978581a6..c00f1651b04a6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2829,6 +2829,13 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	}
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < i.freeram) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 0;
+	}
+
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
-- 
2.53.0



