Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C93B1034;
	Tue, 21 Jul 2026 20:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665912; cv=none; b=AWfG50ZLMMPhpI8DFEtfRib3YQf3poh+0zMsfyW9jqpUyppxZ/3ThbAoSQVbjbYyWDUpzISJl3LslF55vyzR6YEnujwucMFrjofL7GkkiiwZmL2TjIg5PwcrZAi6sBVNgvA1OKnv2gCy94Xt3JrJH+rl29aG91oEWTgNfJ6c5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665912; c=relaxed/simple;
	bh=3vWo4lnh4bxQh0I8G4ceUtyJ89iVaulSZXmT3L1XqiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/lVNS6NLU7SffRKgnrQfjGVytGXPuyTdGNSLuxYor8w+wvuELh2JK2dvzRihJj2Y/ZC5zWESOLA4yEL9X6J8Ph0TpnYS3ePKhuQy1wVYTLK4jpuexyrF8MNKmnRvLhmOgXOuSaJFcBv5iuSw98WCjsg6Wi5+Mt4+MpfOV0nhpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQRbVzFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQRbVzFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322C91F00A3A;
	Tue, 21 Jul 2026 20:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665911;
	bh=HIyoMBnP7rq8Tre+os8mm1o90EOXj1+V8B65iWlb/rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQRbVzFudVX/rjoW+GSC9zcBZr2t6l4arXB5xpROgJJHJA23y3fFboUJqIViOmYtH
	 wjMctV6o1FK7G5l0YaEJ1HrB3ecfXs1+czVUdP63QPEy6ZCi8Upbb0BajvLDdF6EKd
	 aT7YS5Jba/fpv7uO4oeiVdtdIcj856NVzJiyEFEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0483/1266] lib/test_meminit: use && for bools
Date: Tue, 21 Jul 2026 17:15:20 +0200
Message-ID: <20260721152452.647164153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Alexander Potapenko <glider@google.com>

[ Upstream commit 8e0c2085c978ed6d9764d79fc785920360096f21 ]

As pointed out by Dan Carpenter, test_kmemcache() was using a bitwise AND
on two bools instead of a boolean AND.  Fix this for the sake of code
cleanliness.

Link: https://lore.kernel.org/20260504100637.1535762-1-glider@google.com
Fixes: 5015a300a522 ("lib: introduce test_meminit module")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/kernel-janitors/afOcIan1ap9kD26M@stanley.mountain/
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_meminit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_meminit.c b/lib/test_meminit.c
index 0dc173849a5420..d0aa0acd4e0109 100644
--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -387,7 +387,7 @@ static int __init test_kmemcache(int *total_failures)
 			ctor = flags & 1;
 			rcu = flags & 2;
 			zero = flags & 4;
-			if (ctor & zero)
+			if (ctor && zero)
 				continue;
 			num_tests += do_kmem_cache_size(size, ctor, rcu, zero,
 							&failures);
-- 
2.53.0



