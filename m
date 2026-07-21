Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DD746A5FB;
	Tue, 21 Jul 2026 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649006; cv=none; b=EP51iC8eRR14nEsFiovuc5iCUPPAfTGzqhpof9+eFDJdrKpG6AqtHQjRl3yXJdkdabWGK1oREKAQBDJYNmMdFesJdfzp+BDf/qNoo3RKbEJ6B3UfRlj+YoEes+gSYOQUmbyLfi7JB/QbcMrVnnVzyuh7yYH0DLexv5x3s4Fj9KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649006; c=relaxed/simple;
	bh=ipRm9qDKf7mvJKk6d1XjJGYdMvUQmlrkLmkjG5Mcexw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mstF9uGP32nH4+DaKSRBM0UXL5lUMXwD9FbfiWkLxNom5EIODAoeTwd2oFU2JNgxk/u3XncSEl7K/ySOvpl4U4uNKIl3nk8E0aiQxaH6O8dawMxttQ9sdxcB9gyysXfjH1j+dofkiZPu4LYWxsfTfgFB39GVKunLVcOCV8qE4V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uo/oLmHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uo/oLmHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FE01F000E9;
	Tue, 21 Jul 2026 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649004;
	bh=B27cdZKAyA4i4e0sT2qypAD3KHc5DRJ1iJ9jRr0Z5tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uo/oLmHHmai1RkkS7Y9NlmYx6fdZ3DTfYuyRPOYcuOfmjisrPRL/MMZR0R2+vi2M0
	 oHXULclhDUBUCiD1tSwLcK+VjOzHiwLcjXvp1aBZjYuwbKvp+5F15olI1LMV1BL9me
	 rdUkmjnymMNtvgyTY7IVmBVL80uAXVsTGNvDi2ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <ynorov@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Viktor Malik <vmalik@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0361/2077] uaccess: minimize INLINE_COPY_USER-related ifdefery
Date: Tue, 21 Jul 2026 17:00:34 +0200
Message-ID: <20260721152601.203246628@linuxfoundation.org>
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

From: Yury Norov <ynorov@nvidia.com>

[ Upstream commit bd99fcfc6219ebe36ae4d0bf5333b5ecc17b53df ]

Now that we've got the same config selecting inline vs outline
copy_to_user() and copy_from_user(), we can simplify the corresponding
logic in the uaccess.h.

Link: https://lore.kernel.org/20260425020857.356850-4-ynorov@nvidia.com
Fixes: 1f9a8286bc0c ("uaccess: always export _copy_[from|to]_user with CONFIG_RUST")
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uaccess.h | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index add9ceea7b1edb..9d39b640f0674b 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -190,10 +190,6 @@ _inline_copy_from_user(void *to, const void __user *from, unsigned long n)
 	memset(to + (n - res), 0, res);
 	return res;
 }
-#ifndef INLINE_COPY_USER
-extern __must_check unsigned long
-_copy_from_user(void *, const void __user *, unsigned long);
-#endif
 
 static inline __must_check unsigned long
 _inline_copy_to_user(void __user *to, const void *from, unsigned long n)
@@ -207,7 +203,13 @@ _inline_copy_to_user(void __user *to, const void *from, unsigned long n)
 	}
 	return n;
 }
-#ifndef INLINE_COPY_USER
+#ifdef INLINE_COPY_USER
+# define _copy_to_user _inline_copy_to_user
+# define _copy_from_user _inline_copy_from_user
+#else
+extern __must_check unsigned long
+_copy_from_user(void *, const void __user *, unsigned long);
+
 extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
 #endif
@@ -217,11 +219,7 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	if (!check_copy_size(to, n, false))
 		return n;
-#ifdef INLINE_COPY_USER
-	return _inline_copy_from_user(to, from, n);
-#else
 	return _copy_from_user(to, from, n);
-#endif
 }
 
 static __always_inline unsigned long __must_check
@@ -229,12 +227,7 @@ copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	if (!check_copy_size(from, n, true))
 		return n;
-
-#ifdef INLINE_COPY_USER
-	return _inline_copy_to_user(to, from, n);
-#else
 	return _copy_to_user(to, from, n);
-#endif
 }
 
 #ifndef copy_mc_to_kernel
-- 
2.53.0



