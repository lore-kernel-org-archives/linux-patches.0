Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024564;
	b=HhAFkAgBAFeUqYXXvxmTBCmE7loatuWB9pD0EYIRiC9QajUF5fvwhgASFTsU4vqxKe5Y
	 g/wqEPWp5OghRGmHfONvO3rK4mDo2mnDQ6nvl1dj7kEHhzkFOig5+zAPHfIMdRaJBHK0c
	 yz0rqs8VVGgVITPYgAl+RJsExYVqOMvqtjANjd6EmXbzLOcO5drbfHrq91IOmXaZtANVL
	 8frVgTNxKbec3N5gxcTkTHHLt6ToSVKzeHrDedMUxkQgPKBDzwDhjaKgcNWHzlf9hk3j6
	 l04DpPBiTsXL9FCbcb1oR4xVClCEYTpKlI1lxZyXL95CJJCzucVYxRwzgzh6nvoCA0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZm836/8A/42OHFsjED2LyJBROTZ9JeRSEb4k9ujqac=;
	b=YyinepJVWwlKY/4wZB0NEqoy2q0vugGkP8U1PkySQtEShO3uwBOFEv2BLNrqMcJQYkVJ
	 IkgsQnJcRzse0JEhr1EVPNQZPfQ9WJpwYsO9VdV7KE+BbukQs/RJc+pBhlLMIo/xsdSD6
	 0y5J726wD3qpeWGvX2rI18IOQkLoj5IPv67m+uBW+bhJFcIHbjd2xCal7jdAkb38/r9Wt
	 W8RSbjHvfDagzWVVDdbU7tdy+US1G5ofdN3d3FyqhcVqjKfwEVyCVUcOMoow0BwxJkyKO
	 +HtbZaFmC/cx3pq2lsZBlXS+4/tSTGgCx1mA3TFf6BnnA9U7ImmtgRfcbk8cmK7qP1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iMpxttX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E3606A320;
	Wed, 18 Nov 2026 17:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iMpxttX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62CA1F000C4;
	Wed, 18 Nov 2026 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024564;
	bh=KZm836/8A/42OHFsjED2LyJBROTZ9JeRSEb4k9ujqac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iMpxttXdP/eMDOzabxc0quyFjFVh0Z+8OxtS2oNU6+xYHMU7Hvm4p4CwNzroVJHd
	 N2A0Ya5lkIfaztWl/LL9cZSQJD6IyY+4QXihqlBeQ5oHNYH4FzzlHezhD9uh3ylsXf
	 TmsuJkp2HgDziS66SnWdTM7Hh9kfm0IRCtTG56R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0769/2151] bitmap: bitmap_parselist(): dont wrap around on a huge group size
Date: Wed, 18 Nov 2026 15:41:44 +0100
Message-ID: <20261118150150.105954674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



