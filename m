Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F3E3BD63B;
	Tue, 21 Jul 2026 22:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671560; cv=none; b=dJbBLGVE7bFdEATCDxh/lp+3amaBJGMTDU/n3CqJ4LoY3/wgdm6fo9MdWbdp+mog5wakiUf18+lFoOQY8BYsTJzxolDks2ExV9Qp93bTF1QdBwSVhuLMv03w7aKa8f64PRdlSpRQMX1NLVhdfQcZWbLOG5c78Iz6ELNtqXvLLTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671560; c=relaxed/simple;
	bh=lxZdTxbq20Z291rrIw9KadWjDWWM0/xmoG7lzh6IZPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HARlj9rteBvBxxFT/Z0SagWQuxrO0I2skhI+5V0iSU08G+ZdiIYixBgO7D8XVX1n2luBQ/N4vnhVpsABnxWEtio8R8/iYhf+N9TAn7uu3zhqD92qUS60wPZWfyEVtpXFLEgCnEUAFS9cy9kQk8XErZW4/H5D0wv3tSJcA83ZfOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJ2UIyFH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJ2UIyFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F7F1F000E9;
	Tue, 21 Jul 2026 22:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671559;
	bh=tXm41WVNG5uO9rqFgMDt9tBPB0Pqu63P5dVuLFDact0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJ2UIyFHUQvaTeChlP/k960kRw7JJ+/gIqcJRPuawb61ZsfWk0wEJLvS0LgKhIhh4
	 6z2Nc4S5Z8IuSI8Sh8fx2AsFiQ3tSN3dImyo1j5SI5I4I3zoDIJ9xQTb0digHW0bCP
	 hnHDGA/QhwcNUWSi0yAnBAZsy8XODsdJH63L/+FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 292/843] lib/test_meminit: use && for bools
Date: Tue, 21 Jul 2026 17:18:47 +0200
Message-ID: <20260721152412.598523575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



