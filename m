Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210538;
	b=4eguDRrkqVpkZN5OtfiVQlDHhdweENp/QuC4SG3pYa6oYlD3nUJTjucTTlyDxoQ1hA1v
	 mkG0OQtJ9iEdOZpnL1wp8gg64WmMJjBHRr/LYiIAnLslH9TxPXOH9RB5DKqa8EUVuYgVp
	 Nl+KMDLEZWAGtE45bNwgiKkhm459mCCOqrgs91QimFQqGjrWaLE1nl+30nJLSqK+cBkUm
	 XRzjJcmlinxIkPIn41iGpUwVjOEXpY0z2XYPFGuscFj8PwQU4wL8d+rr5wpbpmQtpTTcu
	 y2vOUKfLL74kLPWcTk6JOoEr6+6PTImSe4PQdnEhldYWtjVFLte0FiK7gVC9YiGBPIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XSCSQBQe/uRUUl3Z2BwKwfuu1l2NnDrEC84so8NqORE=;
	b=EjKK/9yUBu5BWv+2iVih2eFZhzy4+z0BkR2pG8EPYSCIcLAKM2ZbUgZJ8w/rNTTMlyMj
	 CipaG2KOb7PdhFE9E4SymWMHkRV6zTduygZw0SZPXyLRiGYCsX3jJ1DRE8xaNUmC7ZSYK
	 W39VwZd2zQ2F+rkSneXJKWpkWQAa1jh7nfC/6w6zdZY2TmvSSx0K9FCcwS6A8tGeenfPQ
	 PjTL6okC9zgNkScOWVY+fS68Pyrck5l/fS4tf/WbApewwCtn7S46JzIsJCgzGXplW0u8N
	 SieIAAU97K3a86QnuIyM9sZ/tT4iQNNVil99qPqXOGU7FJfWWYhvbK1UfEZgAocmkxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jw7Zg8WC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084E8606A31A;
	Wed, 28 Oct 2026 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jw7Zg8WC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A0C1F01825;
	Wed, 28 Oct 2026 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210537;
	bh=XSCSQBQe/uRUUl3Z2BwKwfuu1l2NnDrEC84so8NqORE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jw7Zg8WCQ1hlWP5jeqxqJRA/bBB/Y9YnuVr5+Zhn/qToi35EUE7g1g7pmIb24p7u1
	 vEx9k7jUJAVxGIRnhleGfMasfNGLhHzV4DG0mLrjChzlw3TVZlA68FQ7544F0OG8F7
	 CDgpqlJC5VhXykfqwjbTGqX2uAIB9W0OkL44cnlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/571] params: Fix multi-line comment style
Date: Wed, 28 Oct 2026 17:53:28 +0100
Message-ID: <20261028170009.474583577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b5e3f86a47d34f7b8af899f8cc70520f6daf8b53 ]

The multi-line comment style in the file is rather arbitrary.
Make it follow the standard one.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-6-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index dc714a1c67cc4..e1eba5b8230c1 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* Helpers for initial module or kernel cmdline parsing
-   Copyright (C) 2001 Rusty Russell.
-
-*/
+/*
+ * Helpers for initial module or kernel cmdline parsing
+ * Copyright (C) 2001 Rusty Russell.
+ */
 #include <linux/ctype.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -275,8 +275,10 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 
 	maybe_kfree_parameter(*(char **)kp->arg);
 
-	/* This is a hack.  We can't kmalloc in early boot, and we
-	 * don't need to; this mangled commandline is preserved. */
+	/*
+	 * This is a hack. We can't kmalloc() in early boot, and we
+	 * don't need to; this mangled commandline is preserved.
+	 */
 	if (slab_is_available()) {
 		*(char **)kp->arg = kmalloc_parameter(len + 1);
 		if (!*(char **)kp->arg)
@@ -741,8 +743,10 @@ void module_param_sysfs_remove(struct module *mod)
 {
 	if (mod->mkobj.mp) {
 		sysfs_remove_group(&mod->mkobj.kobj, &mod->mkobj.mp->grp);
-		/* We are positive that no one is using any param
-		 * attrs at this point.  Deallocate immediately. */
+		/*
+		 * We are positive that no one is using any param
+		 * attrs at this point. Deallocate immediately.
+		 */
 		free_module_param_attrs(&mod->mkobj);
 	}
 }
-- 
2.53.0



