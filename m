Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619595;
	b=aX3qOhmYjhLsYwMHM+YQAZOG6JbLRBgwd63/MLBWJjQs62Ce7DCWI/notrYO1kW5sQFO
	 Ww8RjZ+xWnasMoT6csEzue2Ai2OMnsXs2JGEbFpa6ZXIiAzYXPzIigJ+DlSriw09u6khb
	 ukIncYRRSIo4o4UUUbCoB6UHO31OP2dqpcEzEHRB1JCSRZjJ0yZAv/d3CWQPEo6uH9HDb
	 zO9iZWKqseu+OqbIeZfOZ70T73NhyiPAx4hQryaHn6ozgCg54nhBijtZdR9csbWVqB/aI
	 I3cLgvwpW+kUQY+iU9IrHD5Dl8yvsNmAhE3K19YG/GywdmyieDkxQGWprWv68fM+ItQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5WyPQqVN9jdxKlAlfEJK6fAt9FP51o2KVvPMbzvr5Ds=;
	b=tNzpbXSNz8qC4kv5xVxbY29kJ0vyL/tbHDSoFIJMexwIS7cC5t5X9uh/OYU4Bf0tS1x/
	 BwbW4/nGbCagrMds66Ry1pLU8Hk6NHq2QDMSpWHj8Z8LSFuRn6oqXY/2UJNQL6kXAUKzy
	 MszlGpDtK9LPr0NJuz6zxtvVVWrnOlBvHyJ4CYTYCpTSnFwEnQBVw1tRTTEEqwQxbOYW0
	 Fghr9527PGt5DNZDiyQmhG3h5kcZdYdjncHN7jNy8p+U0BWkfoaPfie6BKOm8jTr4WWoH
	 c2JaPnycH0baDaCfiiIqC0caz4q/s4nGrTcFzP5E/ViMg0SyH8+wENactooE02G4ZTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shHU32VE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3010606A323;
	Wed, 25 Nov 2026 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shHU32VE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B991F000C4;
	Wed, 25 Nov 2026 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619594;
	bh=5WyPQqVN9jdxKlAlfEJK6fAt9FP51o2KVvPMbzvr5Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shHU32VEyTbpJTX9ywCDhy9/MJopEQzFngoxxS1/v8OaHC8oMc0QrkdM8aHjQum2l
	 xjfyQpAigKALOZcvZQhjXxW0xTpHVC2QolUXBf8gSKqQqZbz/KXBe9RBucoOknpOOt
	 cBXbxN7/UW3DkY87nzNZgRJu7zx3tTnJvWpfFf8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0602/1005] mm: page_isolation: do not take slab pages for free
Date: Wed, 25 Nov 2026 15:32:20 +0100
Message-ID: <20261125143835.847287658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 213268869301f747d19ca00a391757a6cf2d4fa8 upstream.

page_is_unmovable() regards a page with a reference count of zero as free
or about to be freed. Since slab allocates frozen pages, they will
be wrongly considered to be freed if order 0 (higher-order compound
pages are caught earlier).

If such slabs are the only unmovable pages of a memory block, memory
offlining now isolates the block, this can lead to offline_pages()
looping without progress.

Thus detect the slab pages as removable to return -EBUSY, as would
happen before commit 9aec2fb0fd5e ("slab: allocate frozen pages").

Fixes: 9aec2fb0fd5e ("slab: allocate frozen pages")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://patch.msgid.link/20261103-pgalloc-ai-hotfixes-v2-3-e0d2890ab74f@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |    7 +++++++
 mm/page_isolation.c |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1835,6 +1835,13 @@ static int scan_movable_pages(unsigned l
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
+		/*
+		 * A page that was allocated, but was not a slab page yet, when
+		 * its pageblock was isolated.
+		 */
+		if (PageSlab(page))
+			return -EBUSY;
+
 		folio = page_folio(page);
 		if (!folio_test_hugetlb(folio))
 			continue;
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -75,6 +75,13 @@ bool page_is_unmovable(struct zone *zone
 	}
 
 	/*
+	 * Slab pages are frozen: do not take their reference count of zero
+	 * for that of a free page.
+	 */
+	if (PageSlab(page))
+		return true;
+
+	/*
 	 * We can't use page_count without pin a page
 	 * because another CPU can free compound page.
 	 * This check already skips compound tails of THP


