Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D77213233;
	Thu, 13 Feb 2025 14:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457088; cv=none; b=eziyT0insAIhNvOPU2pyztLi5iLuRxxvDhX08QH/Hzv1F+BKq6O35DTZ/d3SUBEZ/mwEDi8BrnIj+L+YoL05nrIQUMjaO8TfB7cBwL+ZvKQ7HJBzRNMpQdTezGxPGIH4ofvfARRLjMyhFKTYK1dAGbR8ExnozrTREr7xCI2Sg80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457088; c=relaxed/simple;
	bh=tDxqJArnYOoMPTrMEkQqv7Rrs0d8B/ql8Gl50Pa45UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJc9dhVJwKh6Fn5ufR6Gzhfi5II2k//fHL1hm8SHBcc0uBcXPrVV6nTMJRrhGCmlCwxS5L+HdEjt3+bSU8BUenBh9pzAl9obArr36DX9yKUTTf98jLEtm8XlY0XFHfLSViU1U12BOR9D9GGfo2sBVv+wJr4DDF56VXRNbqrACdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHhL67o7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHhL67o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A52CC4CED1;
	Thu, 13 Feb 2025 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457087;
	bh=tDxqJArnYOoMPTrMEkQqv7Rrs0d8B/ql8Gl50Pa45UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHhL67o7CX2D+k1g9LjWHP9SDONpK9yGHeIRB/kksgwlXCCZVpusbKVGwz+1cxcNF
	 bIL3uyuenVXHfvm9HwngkbgvkKHZuUeMAyEXIjGEkSpw5DX5pEcS6j8Kjuqkct2Jul
	 cuM0y0efdLKF1YxYRqsouol2+kwRWLdmALzGmVMw=
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
Subject: [PATCH 6.12 014/422] locking/ww_mutex/test: Use swap() macro
Date: Thu, 13 Feb 2025 15:22:43 +0100
Message-ID: <20250213142436.982124280@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 10a5736a21c22..b5c2a2de45788 100644
--- a/kernel/locking/test-ww_mutex.c
+++ b/kernel/locking/test-ww_mutex.c
@@ -402,7 +402,7 @@ static inline u32 prandom_u32_below(u32 ceil)
 static int *get_random_order(int count)
 {
 	int *order;
-	int n, r, tmp;
+	int n, r;
 
 	order = kmalloc_array(count, sizeof(*order), GFP_KERNEL);
 	if (!order)
@@ -413,11 +413,8 @@ static int *get_random_order(int count)
 
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



