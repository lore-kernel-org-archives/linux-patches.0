Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4F146A5FB;
	Tue, 21 Jul 2026 15:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649085; cv=none; b=PvuolsTO4HTL+datn4y3Mv9gfXnQNcgg+cmsFyc4xOqJENxxNBuDnZgPL5wvYluaoAQuW0wZQAEsiio64bmA3TMlumO4c/W8XPFdl/e0NcU6y+iG9YbIxrCit+97Xy1QyOh2GsfLT+XlOf3dWAksiOPM+JP7wRxm6dg/GA16Ey0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649085; c=relaxed/simple;
	bh=FZj8QfvqzNoPueLVBa47CmrCdE0RrhFWDsocy0p5H0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tY+0OfncPxTt5zrk3SUS/z0pEb2rjRVDwC7Fo3u2huE5+VZVrqg4bDBJaH5oqD8WIHMfqsXi8r4b9NtjpB4oKipoH12A2zKpmS3rCymaCoB1YKlBDFculLRSnHBD1HZUM3iLQ0mTpORsvl4HZ072Bu014olbMuDwccZotFs+E6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg7N75AU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg7N75AU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954531F00A3E;
	Tue, 21 Jul 2026 15:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649084;
	bh=krQzNgugkcXoFPEmwDEnXh//abEuNDgnag26PirLkg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tg7N75AUTBTnILmfwoHpu6j4A0TdUfSUDXrLNARLtfYoEGB+laz9auYOiLiafloE+
	 ei06TMnLey9mXq2HLwwSMCZ/TS84ZWi43JqiyHh5IdNl4jaxAx4xdErW63KyfAcsf5
	 /JhOSIZmDtP98ZCn306k5vTSp687Vh6ZigNizF2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0443/2077] lib/test_meminit: use && for bools
Date: Tue, 21 Jul 2026 17:01:56 +0200
Message-ID: <20260721152603.212750542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



