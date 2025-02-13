Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD122222A9;
	Thu, 13 Feb 2025 14:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458569; cv=none; b=HHGfgx0YInEBAXVyx6kKmY7t9TM9bxcc2NHPbPN6JEEDwnlYRJSVa8ZgFjPpmKvFSyUK9bGmuvzEI7VRp+Dk8pmenAFjwVS0YvaUBvxNPhghVtJME8WsiS8jJksz/70dFI+cefBJs6uobfkFcgr3Rvo7yMAm7v2/GWCtEZx2QR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458569; c=relaxed/simple;
	bh=k1M2SdBNwhjwRnXH1xpilcwcG+Zfd6XhOYuTZOkhhps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASpnmnsBbm50J+DoTsvsZHpgQQrP5qMCkSKIxDss/2LjL4pvF3UdfBVLV/JqFZd0mfPr5xVN0pFqSj2ZivqyWyEHQH2KW88+rR2BtHyE9mEjnawGgqxWkv6iOcyc1httu820amMcx0O1kitm1hyr5vesOL2G8fRoUGeF1VZnLIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAqhPoXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAqhPoXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0687EC4CED1;
	Thu, 13 Feb 2025 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458568;
	bh=k1M2SdBNwhjwRnXH1xpilcwcG+Zfd6XhOYuTZOkhhps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAqhPoXSZFgAG02Gp06DvPbGJ0q/ifNx5GZnUFp3EHprY994PaC5yx22wikWangTo
	 666y7Dl0HJKIB0dVf78nE6y4irzeuiuRkcziD/28+BLndQu6X4K6X7c7XXNADDCC5l
	 Ta9gHS1h2l4LHLg1br3pKNRduKsz1941CXIh1l3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Waiman Long <longman@redhat.com>,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 016/443] locking/ww_mutex/test: Use swap() macro
Date: Thu, 13 Feb 2025 15:23:01 +0100
Message-ID: <20250213142441.248890929@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

[ Upstream commit 0d3547df6934b8f9600630322799a2a76b4567d8 ]

Fixes the following Coccinelle/coccicheck warning reported by
swap.cocci:

  WARNING opportunity for swap()

Compile-tested only.

[Boqun: Add the report tags from Jiapeng and Abaci Robot [1].]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reported-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=11531
Link: https://lore.kernel.org/r/20241025081455.55089-1-jiapeng.chong@linux.alibaba.com [1]
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20240731135850.81018-2-thorsten.blum@toblux.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/test-ww_mutex.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/test-ww_mutex.c b/kernel/locking/test-ww_mutex.c
index 5d58b2c0ef98b..bcb1b9fea5880 100644
--- a/kernel/locking/test-ww_mutex.c
+++ b/kernel/locking/test-ww_mutex.c
@@ -404,7 +404,7 @@ static inline u32 prandom_u32_below(u32 ceil)
 static int *get_random_order(int count)
 {
 	int *order;
-	int n, r, tmp;
+	int n, r;
 
 	order = kmalloc_array(count, sizeof(*order), GFP_KERNEL);
 	if (!order)
@@ -415,11 +415,8 @@ static int *get_random_order(int count)
 
 	for (n = count - 1; n > 1; n--) {
 		r = prandom_u32_below(n + 1);
-		if (r != n) {
-			tmp = order[n];
-			order[n] = order[r];
-			order[r] = tmp;
-		}
+		if (r != n)
+			swap(order[n], order[r]);
 	}
 
 	return order;
-- 
2.39.5



