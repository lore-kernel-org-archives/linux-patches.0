Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040256;
	b=XcaA1f/rfQ9i2upstUqISJ/rbjm/eI7EswBa1YwNDVH62+YppNCMnut1GC9gpeGNKkjM
	 WIDAB5WPbXt4JzmVd+MPnhocKu3WdJUKCgythYIO22MA0wYt44qlpXbgE5bXBWLfXxs+V
	 iNi3cJptFL7ylZYXDgsUFUVJE7+vfQZvJB49DQG5MQmtEO4NCg+nPYTgG6G6OoetttiNK
	 9kj4eP4neR1oMQWvycSFVSGsYL2L7OtEwpRzjxKtniRUGYQZMmIzzB8jjpSvUNCyQCBgG
	 hIWsRszWGdUKipmLJhNPIBZJeVkEgU1v6ieWitxpz/dfMhy/+psAjLZyLQwP8mk4d/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wOjNtlUK8Wh0Rg1rA8F2owyD71o6pvdv2UDj32lp0N0=;
	b=tCJyuHuH3dHJBtMJzkjBPVa94NjgOjoN3+dLgWHE2haBo6Pz4CPUvVa7HGxmfAdqW/cK
	 i0hI60ealN6lzyMusoP1hqGOb0Jj9p7D4niI6kqI+spb7IguRO//xDdKibl9fWcOn2xSt
	 q1xanM1uuzfk2Rrz2m8IZaERyzFEod9slIX573CZtHEgQYFgoV1X8Hl/o6w1Oc2JEpoWG
	 37oWVmjRLp9amQCpmWHu/46kpPNt+vhIXgvyuQvqbfzb9uZcVSxOqodDrUiU7cOKxhB/H
	 ey4130Mjs0zTNnMHgZnf+DlYSlab+SqKE20nBrQ2daCajZIMV5b6z2euiCYBK24D2Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQwtZV4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCAD606A31C;
	Wed, 18 Nov 2026 22:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQwtZV4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF381F000C4;
	Wed, 18 Nov 2026 22:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040256;
	bh=wOjNtlUK8Wh0Rg1rA8F2owyD71o6pvdv2UDj32lp0N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQwtZV4KaUqJy0S9opnf3VbnLYxqbcWPuClAlD2KvY9yAJ1veqsjTiJ3Ok/6deJvB
	 jc2J0eI/8ic6wR6LmsM1x+AWlpNN4P5E+Xmkq6E0mnBInry93m9yurZLjcRz6hjrlx
	 WZeQiukI+q9orMh+vN5mo/yKkXgnaPB+oR8UyWV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2391/3318] bitmap: bitmap_parselist(): dont wrap around on a huge group size
Date: Wed, 18 Nov 2026 15:50:13 +0100
Message-ID: <20261118150433.250139640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65cd6f60d4360..777c89bc772cd 100644
--- a/lib/bitmap-str.c
+++ b/lib/bitmap-str.c
@@ -8,6 +8,7 @@
 #include <linux/hex.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/overflow.h>
 #include <linux/string.h>
 
 #include "kstrtox.h"
@@ -219,10 +220,12 @@ struct region {
 
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



