Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064477;
	b=p/9b/4vgHo/Z+ZepU2Nt4nVIFJQ7l+rg1TL+rStNCdHEXYXVGcRgrYN5mHf6b5PLuoRG
	 s/JldOeLMlJBgrutkGIMF/b8fJk9/gfdoz0saiYKb8t7ANbeaLmT3WCDDEYFc/s3cjBp1
	 +XwzYJM+oEkrnpEXG5WMZRbuxvtAPBuJBLKB2EoAdTVugw92Y9mMxk0dtde0wjZ7rNOzq
	 1Iny78mxXBfypGH5dQk2pxtILIMdkxUWZv75AlcTnagn+p4X1H5pqtCEPiYsMG9VfQIcc
	 +zrJ7h9uT0WhkBkzZRPF9CjUYRu0C27YD9UMqlLRnxBoPSQCgEC0QxMcduiZkzvhxWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AYwh7xz20CiAchhQjglcu+9TTmV+tFuC5d5EWY/rx8w=;
	b=r2+p+voLlLJJnHvA5783R2pS+O9XHniO57FuJ9BvdhDldFQBV2mmUgMNkdtmVUyjvway
	 WDVrx0IJEzMwh6K56O+yFHf/Y3ItntQoxdVPZT7xqO4XcFUB6dj6RzMo1MHlVBNBhAr/F
	 oL0gCRX01ZKMObFZ4zmpUxq4UngrG7EyBpSytDHWBusJKfNTjB1Mmr4d3aXVLT6iwMVy2
	 31eJyq7PccwHTcKbfPp0Nlgdt13ks+WFZSsEHb43/Q9XuzTcIq8IDw9p+0WTm0NbVJQZj
	 y8KE28n0qaYRTwixdQIKzVBLmzSSewlMiD4vYEMpKbKR9R6/CNrMSy5dXv5LGqa1T7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUJHAtHt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31605606C01E;
	Sat,  7 Nov 2026 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUJHAtHt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D850F1F008A5;
	Sat,  7 Nov 2026 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064477;
	bh=AYwh7xz20CiAchhQjglcu+9TTmV+tFuC5d5EWY/rx8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUJHAtHttMieyoRxv2mJ4ekrxoRvifbN9jTO7asC7Xb1UbtCxbw9Hl7/qkjZt6PI1
	 R2DdpTzvSWUjdpsAfIFjrWex8k+2wo+YSWIFpJnJ/0Z7GR7i/jclc8OQFQwuZ4Go2B
	 CTuBF356+RQVT3QjiLfeyPuVsF4rBALqmGfw30es=
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
Subject: [PATCH 7.3 0516/1257] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Sat,  7 Nov 2026 08:46:52 -0500
Message-ID: <20261107134953.683579440@linuxfoundation.org>
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

[ Upstream commit d4a8b5ac2ec28f55bba9fad07b69bf375cd42704 ]

damos_commit_quota_goal_union() is not updating the ->nid union field when
the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP.  Hence, if a DAMOS
quota goal of the type is online committed in a way that it will reuse
other quota goal's memory space, the new goal will work with a garbage nid
value.  As a result, the DAMOS scheme can show unexpected aggressiveness.
Do the update.

The user impact is not catastrophic.  No leak or crash happens.  Doing the
quota goal online commit that can reproduce the issue is expected to be
not common.  This issue was not found by real users but the AI review.
That said, the issue can reliably be reproduced.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-4-sj@kernel.org
Link: https://lore.kernel.org/20260827045035.94611-1-sj@kernel.org [1]
Fixes: 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 7.2.x

value.  As a result, the DAMOS scheme can show unexpected aggressiveness.
Do the update.

The user impact is not catastrophic.  No leak or crash happens.  Doing the
quota goal online commit that can reproduce the issue is expected to be
not common.  This issue was not found by real users but the AI review.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2edd906787a35..0a0fdff279d86 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1136,6 +1136,9 @@ static void damos_commit_quota_goal_union(
 		dst->nid = src->nid;
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		dst->nid = src->nid;
+		break;
 	default:
 		break;
 	}
-- 
2.53.0



