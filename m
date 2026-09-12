Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E7E208D0;
	Sat, 12 Sep 2026 09:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204576; cv=none; b=PTBF6Tc4/wdt4NtusO8J9nOcE6r7pijhVO0mxZLVzvtWZtOuxMfYoD1tiIksYDLMtPo34E4fn3fTip2FXFLagXAFyUtR9hMm+AO6uGRhgHSk3+o3CtXZKMI3Oc1wJ9ztRs4AXTJkrxR7Wr9zebn+pwhBJ6SQy6vsvRMJO5q03uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204576; c=relaxed/simple;
	bh=PKspyNkK3n4SbMSNyeUCHK70S66/PDnkvzKXSi2vzLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mX45O7GO60Sx7wxh9OGJ/F4TCj9Vjcqh0OqfJYu2bcX1zRfjXHYOxqoRO3SWgcO6XKpv5eqQBYbnwCjiqdXDDTTkWSFVAjprsursiH7iPSO92fmYWVr8hGlFONuMxjDk3/0HSGLDC37X+53PSvH6VzX8pWxdMKmAKlBcpH78d7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=128kK1y9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="128kK1y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9181F000FF;
	Sat, 12 Sep 2026 09:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204575;
	bh=JYYO5RJoXJ5E32cf8ywIBjWIYrC3lhCCOntNuUNvL/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=128kK1y9M8+xjNTz67Xz+apZhdGk3FMLcFNtfKE+htadJPnxe7J+quxE4yTWm/1SN
	 Qa0Zzzs04WPuWu1+Dljn0B/wjstH5Nx9hGD9YUovU/6Sreka/liYNwHizj1iN71F9u
	 7JrqVww9RY8FOt+FDON+NLiacj2QrwGlJM7esT7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1639/1815] lib/interval_tree: fix allocation warning messages
Date: Sat, 12 Sep 2026 08:56:29 +0200
Message-ID: <20260912065727.470098123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index eba2d3e289800..b0b07270ce7c3 100644
--- a/lib/interval_tree_test.c
+++ b/lib/interval_tree_test.c
@@ -140,13 +140,13 @@ static int intersection_range_check(void)
 
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



