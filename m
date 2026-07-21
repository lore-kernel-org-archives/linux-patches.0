Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA6544AB62;
	Tue, 21 Jul 2026 21:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668962; cv=none; b=HF08o8E87NwT4+c2BZ9+B8ZEzgvMSy6UW8qN5aZUu/C7f5VdSWbdx+FzovmhnCrujHQjtFn+JYUKzgrAwCJm1Qqbt01cW56prbalq/eFx/+K0YnQAcZ4uZUYbYX7C76vH0fXDnNt6MXv4b+ixWjfnPzNAre5IjVDWoEVLpzqruU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668962; c=relaxed/simple;
	bh=j2cWO4Dze9/ijjiUKcuBF9w07jw7Z80+F2CXZFHAEjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/acFT7jC9JWhUjVXqOqUZf5f1pJfdQ4bGrGN8+sjSX9h1+RNbd/19Hl2p701MZjl/Nx51c3/Q4rK2eqdMeOk9pQDfq32iuN3+kTIdCM09By1RH0jXxe/7qVIkgmMdSZ5FG1lLTyJN1yLpU0Oyy1pSWTmB4BxBrmooDz3oiNkFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbVviIyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbVviIyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270281F000E9;
	Tue, 21 Jul 2026 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668960;
	bh=uGFUkZRlqkL1rn2/9R1GWSW0JDTrA+8hv/kpvRsqIIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbVviIynEyoUL0FUokIDGeKVprsn0Ua6Gka66dSKMZsEfSph/JP8/1UxNEOOyx9Om
	 /8zZrJzbRRS3yMHN95L90tD4QUCz7AGJ5lEypOq+/mvg5AnIC1TJPaK6Xqg9qnZDxb
	 +L5Y6rNZTqFXqR1a8+UmPrJUtlUhp7FmIzqWyEUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0372/1067] lib/test_meminit: use && for bools
Date: Tue, 21 Jul 2026 17:16:13 +0200
Message-ID: <20260721152432.944377176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 85d8dd8e01dc45..503c7637be5d90 100644
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



