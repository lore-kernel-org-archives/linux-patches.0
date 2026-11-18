Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017493;
	b=LPaP7iZI0fXzlSAp2Dm0nfLubZtbGCMnlyYl5iqt4juwi+yqELfHEIIcWRMzecNmK5Vc
	 g11ypLd4kOq1tpjHNBJwGS9zTKaMuhBJbYNZI/ilQ0nzZeZO2AOIhRKGWQ/e8iC7L1d2O
	 Byvu6vvirLtoIBtdfkrU31ZXNeHn0lRaiFlefVgGB85wlfiO7+H52RYehq18bpCoNGC4f
	 kLbwKJikMCaMBzEFfZE7F1ElFBUoZOF36YiTvsqQTQLnuH/vMqEKwMRDwRdqr6alQ7q+O
	 kNhCiZ3KwayqEVozRJnt2o6nO27AjWLY+buaaIeCkvlY2DTuWDVmq0jfbmNjOsZjwgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MSRWNWQiwqN+SmdpM1qklp0zB7x2d1W+iVI9mO1ifvM=;
	b=2DWCvedIjDhA45LpYXmqicWf7A7+kDEPCsBOmsF9JGM7WQKbaCkAkJaiTl4a0qYMiADi
	 1iL/WHUzG1MCrboBOxytjJfOl1KAUU3/l6vDHgq+Ql8Kqlp0e9kPWBwfv36Wr5o+YJxnE
	 d4MnmlLv7RErnDGESypQUfBcRNU9lt+FViYHUzuTOlX1EbkLMV5Baf9uth9GfJiB/FBSR
	 t03qova9A6xe6IO14LMhDqAYfc+ZP3QRGoALtLji34MgV1WvoiN0bvKAf/I02+bHrv3XK
	 thp5ATDJ9R/svF6DfBQF9Kn0JgywGpkAwskRf9s7Dsb06yj8/X1InKoI676KdXwjXww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvyXgesl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C751A606A32A;
	Wed, 18 Nov 2026 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvyXgesl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CF01F000C5;
	Wed, 18 Nov 2026 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017493;
	bh=MSRWNWQiwqN+SmdpM1qklp0zB7x2d1W+iVI9mO1ifvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvyXgeslKckF+SuIB6kF0oFJUW6Apc/Z7lqNSoeDavY6tF1mxX+bXudingn6TfugM
	 KDgGJq9YV6EIdS6C1ClPhX47BKYZnALzUOptj+I3HMwKNTWXJ957tuchH7WJ/mJRSe
	 4RZKGjO9rx4wpPthWecv44M9KTS08oUqZdJMhnCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0903/2651] bitmap: bitmap_parselist(): dont wrap around on a huge group size
Date: Wed, 18 Nov 2026 15:35:43 +0100
Message-ID: <20261118150320.380243812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Mohan Jain <jain.sm@gmail.com>

[ Upstream commit d075c4dc0b3c8ed91a4f67ebdf3384aa59fd4fbb ]

In the "range:used/group" form bitmap_set_region() walks the range with

	for (start = r->start; start <= r->end; start += r->group_len)

where all values are unsigned int.  bitmap_getnum() accepts any group
size up to UINT_MAX, and bitmap_check_region() only requires it to be
non-zero and at least the used size.  If start + group_len exceeds
UINT_MAX, start wraps around to a small value that is still <= end, and
bits below the start of the range get set:

  "1-1:1/4294967295"    -> bits 0,1 (expected bit 1)
  "15-15:1/4294967281"  -> bits 0,15 (expected bit 15)

The loop still terminates, because start keeps decreasing until it
wraps past zero again, but the resulting mask contains bits outside
the requested range.

This needs a group size within 'start' of UINT_MAX, so it is unlikely
to be hit by accident; all bits set stay below the end of the range,
so there is no out-of-bounds write.

A group larger than the range simply means that the range contains a
single group, so stop the walk when the next group would start beyond
UINT_MAX.

Fixes: 0a5ce0831d04 ("lib/bitmap.c: make bitmap_parselist() thread-safe and much faster")
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bitmap-str.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap-str.c b/lib/bitmap-str.c
index b589668646574..cafd6388892f0 100644
--- a/lib/bitmap-str.c
+++ b/lib/bitmap-str.c
@@ -8,6 +8,7 @@
 #include <linux/hex.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/overflow.h>
 #include <linux/string.h>
 
 #include "kstrtox.h"
@@ -186,10 +187,12 @@ struct region {
 
 static void bitmap_set_region(const struct region *r, unsigned long *bitmap)
 {
-	unsigned int start;
+	unsigned int start = r->start;
 
-	for (start = r->start; start <= r->end; start += r->group_len)
+	do {
 		bitmap_set(bitmap, start, min(r->end - start + 1, r->off));
+	} while (!check_add_overflow(start, r->group_len, &start) &&
+		 start <= r->end);
 }
 
 static int bitmap_check_region(const struct region *r)
-- 
2.53.0



