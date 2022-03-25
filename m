Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B0E1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1581C340EE;
	Fri, 25 Mar 2022 01:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170734;
	bh=ziV40QzvrV9ly03fJJHDWWsvddu6N2Q7MaUkm1c7iqE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=kFbMbVEFQ2rTr1uvhYH4rvIVvX5NMsrybcbBafRSE/JbJrWUomed2tNRmXy++vK01
	 YK5QPWK1YCbPU1v9dpndNg5JInoeTl+laNpHpIr7S/98zTg/FbMOrWr1pRrFiOLXn1
	 FBbyKBVFdwq0Es2Uxo5IH1aJRUVBEIEm900W3YGA=
Date: Thu, 24 Mar 2022 18:12:14 -0700
To: ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 073/114] kasan: drop addr check from describe_object_addr
Message-Id: <20220325011214.D1581C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: drop addr check from describe_object_addr

Patch series "kasan: report clean-ups and improvements".

A number of clean-up patches for KASAN reporting code.  Most are
non-functional and only improve readability.


This patch (of 22):

describe_object_addr() used to be called with NULL addr in the early days
of KASAN.  This no longer happens, so drop the check.

Link: https://lkml.kernel.org/r/cover.1646237226.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/761f8e5a6ee040d665934d916a90afe9f322f745.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/kasan/report.c~kasan-drop-addr-check-from-describe_object_addr
+++ a/mm/kasan/report.c
@@ -162,9 +162,6 @@ static void describe_object_addr(struct
 	       " which belongs to the cache %s of size %d\n",
 		object, cache->name, cache->object_size);
 
-	if (!addr)
-		return;
-
 	if (access_addr < object_addr) {
 		rel_type = "to the left";
 		rel_bytes = object_addr - access_addr;
_
