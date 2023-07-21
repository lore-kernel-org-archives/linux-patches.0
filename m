Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB331F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0075FC433C8;
	Fri, 21 Jul 2023 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956316;
	bh=I11NTMZ5rOLKRTwNUsLQGgizMy7fSb7nFUCmGBs7Lvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdlqaJ/HTRBXnMViiI1OjZr7UUNq7vxq+1/3TGqj80qOi+PDjz/Iy6NlGTG9oNWwi
	 aQTDJQE/ysFBT+v7CCaOWwUBnaVfKatiLwGweapK1gF7q1DhOiO3aAOQfDvA2mtFUQ
	 4Y/J/PzK99CoSPUBi+eNMMkrjZAjyUldAPUri8s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 136/292] kasan: add kasan_tag_mismatch prototype
Date: Fri, 21 Jul 2023 18:04:05 +0200
Message-ID: <20230721160534.691060399@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit fb646a4cd3f0ff27d19911bef7b6622263723df6 upstream.

The kasan sw-tags implementation contains one function that is only called
from assembler and has no prototype in a header.  This causes a W=1
warning:

mm/kasan/sw_tags.c:171:6: warning: no previous prototype for 'kasan_tag_mismatch' [-Wmissing-prototypes]
  171 | void kasan_tag_mismatch(unsigned long addr, unsigned long access_info,

Add a prototype in the local header to get a clean build.

Link: https://lkml.kernel.org/r/20230509145735.9263-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/kasan.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -646,4 +646,7 @@ void *__hwasan_memset(void *addr, int c,
 void *__hwasan_memmove(void *dest, const void *src, size_t len);
 void *__hwasan_memcpy(void *dest, const void *src, size_t len);
 
+void kasan_tag_mismatch(unsigned long addr, unsigned long access_info,
+			unsigned long ret_ip);
+
 #endif /* __MM_KASAN_KASAN_H */


