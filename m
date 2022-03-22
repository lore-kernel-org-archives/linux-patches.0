Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367316465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E62C340EC;
	Tue, 22 Mar 2022 21:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985667;
	bh=wSq2BlYXr458jeO5QBHmxSyrfGF3SPE45BMzWNlzMko=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=isH+xXdff08DAlM+70Z0mlENxEN3gISUMF4TQjVsHMYWY4mC2H5RCsPXWYS3yfVYq
	 m4ng2ogZHAvjdsSrdAgXxMeRSE2rbZYVaVifykHrhvs4cDFp4JU5EpYrCLQSLdrkPz
	 PcG3Q13WtnEMf0gHzebp6HDgoYmlfogqEgtFChUQ=
Date: Tue, 22 Mar 2022 14:47:46 -0700
To: steve@sk2.org,songmuchun@bytedance.com,linmiaohe@huawei.com,keescook@chromium.org,christophe.leroy@csgroup.eu,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 182/227] mm: remove usercopy_warn()
Message-Id: <20220322214746.F3E62C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: remove usercopy_warn()

Users of usercopy_warn() were removed by commit 53944f171a89 ("mm: remove
HARDENED_USERCOPY_FALLBACK")

Remove it.

Link: https://lkml.kernel.org/r/5f26643fc70b05f8455b60b99c30c17d635fa640.1644231910.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Stephen Kitt <steve@sk2.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    2 --
 mm/usercopy.c           |   11 -----------
 2 files changed, 13 deletions(-)

--- a/include/linux/uaccess.h~mm-remove-usercopy_warn
+++ a/include/linux/uaccess.h
@@ -401,8 +401,6 @@ static inline void user_access_restore(u
 #endif
 
 #ifdef CONFIG_HARDENED_USERCOPY
-void usercopy_warn(const char *name, const char *detail, bool to_user,
-		   unsigned long offset, unsigned long len);
 void __noreturn usercopy_abort(const char *name, const char *detail,
 			       bool to_user, unsigned long offset,
 			       unsigned long len);
--- a/mm/usercopy.c~mm-remove-usercopy_warn
+++ a/mm/usercopy.c
@@ -70,17 +70,6 @@ static noinline int check_stack_object(c
  * kmem_cache_create_usercopy() function to create the cache (and
  * carefully audit the whitelist range).
  */
-void usercopy_warn(const char *name, const char *detail, bool to_user,
-		   unsigned long offset, unsigned long len)
-{
-	WARN_ONCE(1, "Bad or missing usercopy whitelist? Kernel memory %s attempt detected %s %s%s%s%s (offset %lu, size %lu)!\n",
-		 to_user ? "exposure" : "overwrite",
-		 to_user ? "from" : "to",
-		 name ? : "unknown?!",
-		 detail ? " '" : "", detail ? : "", detail ? "'" : "",
-		 offset, len);
-}
-
 void __noreturn usercopy_abort(const char *name, const char *detail,
 			       bool to_user, unsigned long offset,
 			       unsigned long len)
_
