Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A991FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5196CC340EE;
	Fri, 25 Mar 2022 01:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170784;
	bh=sBga4iICZt57zQq9x4WZawmwLtWQKl78sRfaOI+sIYI=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=wJcc2VQ5MeS2QdDxJu0jRgQhntVPnzXIhQ3A3GUy0bQQ+nNrrzYz+mHQSWV7s2FWu
	 z0qNpGGqFAB95OM7MEaOCyf1E7xh6GEHIGIjt3Zd7I7DaCSY1K6Och6l9jpfTRIKGE
	 VJgKZOZXM4uBjId59OVNQV5lDnIlZrHJ0CO7RY6U=
Date: Thu, 24 Mar 2022 18:13:03 -0700
To: ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 090/114] kasan: add comment about UACCESS regions to kasan_report
Message-Id: <20220325011304.5196CC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add comment about UACCESS regions to kasan_report

Add a comment explaining why kasan_report() is the only reporting function
that uses user_access_save/restore().

Link: https://lkml.kernel.org/r/1201ca3c2be42c7bd077c53d2e46f4a51dd1476a.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kasan/report.c~kasan-add-comment-about-uaccess-regions-to-kasan_report
+++ a/mm/kasan/report.c
@@ -430,6 +430,11 @@ void kasan_report_invalid_free(void *ptr
 	end_report(&flags, ptr);
 }
 
+/*
+ * kasan_report() is the only reporting function that uses
+ * user_access_save/restore(): kasan_report_invalid_free() cannot be called
+ * from a UACCESS region, and kasan_report_async() is not used on x86.
+ */
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
 			unsigned long ip)
 {
_
