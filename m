Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57FD415F14;
	Tue, 21 Jul 2026 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661864; cv=none; b=EHfGvEGD5d7DBd4xSy/athBES3BQ66LVR6dzoZ4zBYBLoafgtl6+i2Sna+80ez+nj5ij89AIiaSPHqkdjtV9j0GdnbSNVsHZzvbvRGTpgplwOeUe+jxFpDcVoDZ1RFbGEhdFs0ncgtqUnRxgBioT9v1jFJ9n8+1RhBNmyUwRzb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661864; c=relaxed/simple;
	bh=hz9EpsbYUJDnPoSwQqlQZCtfy1q6DefJ8mKlbOnDxF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usmL5pGqvtlfFMipcO1hqqr1apxC3VZ0AiBIrKO7rmG0YaoYJavDmMPSb5i0n2SN4irJ6HdfTJ8COSpQq/syCMkyPjMAqCGf2Myl5uaA8qmSbyY3jrwKdGOf84E45IVhtIppTsSlgpMvGrUAI5F5w3yJvbCKQHD2QlJX9e9mufw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0ytyoUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0ytyoUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278321F000E9;
	Tue, 21 Jul 2026 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661863;
	bh=xI5GJcNM+WUWnWlQQgSbDD+IxFpWOLiCShNrV4cn7Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0ytyoUXK3khsHAhsBG3FKJWxUtOI+95HkoU9rciAwkfBU4YBV/hEHQSa+EKvsACG
	 nNaV3oCfG8+7lYNrPKZulX74KaHjvCM/osP58yoGLRcJ1t+FEYtI8KBtYd7nimg6mm
	 fzS2CogSpdbRIg7JThqFqt+Dgc1fhD8wUt0rCJgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0225/1276] lib/test_meminit: use && for bools
Date: Tue, 21 Jul 2026 17:11:08 +0200
Message-ID: <20260721152451.126901248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6298f66c964bb1..d028a6552cd61c 100644
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



