Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F21834752E;
	Sat, 12 Sep 2026 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211814; cv=none; b=RHsa2KCyd3fc6yHQ+u9YDnCKQQ9u87mfq4fIKVWXH359xHDPqLXh0JXY1BYGWX2SCbqY9m8WMcv7RgWNBm587PG6JmixHo8v0bhgHpzWNpXgl0XMaNvGvxrhS3lU21oPYEj5B0IS/BUVXNCXqEm26F0KuBs8hQeYXJWjJf6NG7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211814; c=relaxed/simple;
	bh=XPMawFBlHZsv1pB4coDy9cLE9prOsRVOK2MxJ9Wgs3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmGWSkoR2G6iFQ7M+ZnKy7GvEsJJXyxHn1sTxY8ml5UdJFx/HOoblfv9XJ8O8mpxC2aADdal6ioNNkj7qaC6UIvB5F+65FZSjdqY9DiHQoEDrin+iA26V7DLM25al+e89CUVEyi+YtQL0mkx8Fjxu0XcnNoytI2AOQlyPK+S2do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csumiHmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csumiHmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2CB1F00898;
	Sat, 12 Sep 2026 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211813;
	bh=jDtoOqNMEIEcXn9t1bjhf1b0hm6aCVjDSIQRjrGcMPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csumiHmhEieNGwMrrBkgdax5Z0xl0olS4ll2klKnRzc8b1lQkTfrERecaDzI0npeS
	 dIOZ4/bN5UVUG0jjQNK1w85tqrD4dvZ94X96LsVWv0OR/aVJPg+c3QqKmzhYSyacER
	 wz0GUgm8hZCURO7rJwJetd5gVQdA9wos0ITgGXTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1308/1518] lib/interval_tree: fix allocation warning messages
Date: Sat, 12 Sep 2026 08:57:57 +0200
Message-ID: <20260912065653.114654916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d9c0fd5533fb23bc445bd581feb140e966195936 ]

WARN_ON_ONCE() takes a condition, not a message.  The string literals are
always true, so the warnings still trigger but the messages are never
printed.

Use WARN_ONCE(1, ...) instead to print the messages and keep the once-only
behavior.

Found with a Coccinelle script.  Clang's -Wstring-conversion also flags
such calls but is not enabled in kernel builds.

Link: https://lore.kernel.org/20260808123608.73613-1-kmehltretter@gmail.com
Fixes: 82114e45131f ("lib/interval_tree: add test case for interval_tree_iter_xxx() helpers")
Assisted-by: Claude:claude-fable-5 coccinelle
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/interval_tree_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/interval_tree_test.c b/lib/interval_tree_test.c
index 5fd62656f42e3..c479d9176b759 100644
--- a/lib/interval_tree_test.c
+++ b/lib/interval_tree_test.c
@@ -139,13 +139,13 @@ static int intersection_range_check(void)
 
 	intxn1 = bitmap_alloc(nnodes, GFP_KERNEL);
 	if (!intxn1) {
-		WARN_ON_ONCE("Failed to allocate intxn1\n");
+		WARN_ONCE(1, "Failed to allocate intxn1\n");
 		return -ENOMEM;
 	}
 
 	intxn2 = bitmap_alloc(nnodes, GFP_KERNEL);
 	if (!intxn2) {
-		WARN_ON_ONCE("Failed to allocate intxn2\n");
+		WARN_ONCE(1, "Failed to allocate intxn2\n");
 		bitmap_free(intxn1);
 		return -ENOMEM;
 	}
-- 
2.53.0



