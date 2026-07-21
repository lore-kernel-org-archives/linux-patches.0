Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C51413D69;
	Tue, 21 Jul 2026 22:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673715; cv=none; b=F8aFOM4OHwF2lbascsOPEu+OmZB7zPqzc6vAJlC3IrcONbnCxqOra361enO0LzDCOZuxVpvFH5DXkjY3d55kHHIwN6Lk7qLiqNSTPsMlSZZ6tBQQcADQwuWBLiUdZQtnJdMT/Gx0u9RW+lUrO0SUXjcWRQoBDO3VEfjL7af1YnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673715; c=relaxed/simple;
	bh=zOUYamlBGjB8FuTxKtZ9WbHt7fRipO97OaqcC6P2kjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBzRwlnes6mNKO2Acx9fcN/mLnfYNrPWDz/boGnLlsZn4OmGhCLiDWwTiQtNZ37OMjxEvexZLSEMu7vQh4PiVx8LCDwdtFaZu2wZ776wscE/9Pa1NOug1BfKwKxSszm4zPZpJCmAbCVBTcgcScgJP5YbeZ92Zze0TlXYi+KjDAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9Pie2RY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9Pie2RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD251F000E9;
	Tue, 21 Jul 2026 22:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673714;
	bh=KdRAHhHo6bnQI2z06BE5+F0aScG+7e7V01H5cDgr1Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9Pie2RYQBHfNTB7rGKtMIevsPlU1gA9+4vlG+o/82/tAlyqTb1oW/N0sLb4GLkyB
	 mY84zrgZs8GZwjrnIXVycnYqXle+isutrjvwud9aTg0vAvRKzAAF+HeFMFDdgZCKJ3
	 Zh9zBs6Z6xUz2oROyTV4QMCR7gl0GVak11mhjmxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/699] lib/test_meminit: use && for bools
Date: Tue, 21 Jul 2026 17:19:43 +0200
Message-ID: <20260721152400.753518319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0f1a3bd09b7b5c..9e031f4c39b64f 100644
--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -358,7 +358,7 @@ static int __init test_kmemcache(int *total_failures)
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



