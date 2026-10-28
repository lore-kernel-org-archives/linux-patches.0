Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208383;
	b=vQK6ELGEQHe38fXvgba89stHtb0boApMb+ZcAggQssKQ6U6tE94dWytSGSQ06l/d2M3+
	 v4GylWXnRhNAjPx5IgoLoPAtVSwewAcUmZVJ+0TdxRdRm9EGPr7xZIxQPaMig2XQcBonx
	 7f+sq/GmWT5ST+UqDgeqnfYpdTXrQgW/Dox99P30R4tWe4hFrvKs5iDhwfg9dZ+VFnwjR
	 7RBhCeZwh/KNlwvT2HC8YyF1NiDz1Jbw+28jxD2X0hBNxJ6pdqv6W3eP9NMemfxCTbMRO
	 zG6UI9zsqvhiarBg7fXNsyEfA2lkUxSFoOkH5dN6f4YcS50PQ+R/ARrN5GWgZGitFPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vNt/ZzOf5EAKONW7nqQGd+c7T0a1duhc7msPNVSAOJM=;
	b=5SZp+xxMb5jLk+1y3gqxnIYwdKptD51/dYG+B/mFpKkUk2DyGRFqbcDf6DKnTpr3ek9J
	 XVWwxHgQvEBcb5ULKc/Gd3YfC1KIy5HnPFNjCui8Y7eE4j1ZpyIw1KqDOhxgaP9EbXZM2
	 8YrXKtX7+cwPzgtRQIzhy4HAptnNOSkYD0OsQ+zhIsxYaeGkBn+abOeClOQkK+VgjPI7Y
	 CL7Fg8aQto08J54O+PSFkmGWp8M4Z34lUtzfV7YUOtTSYsIy2NK+PefRmqK/OE01sr6Uq
	 UjUyHYXGM47pUE3uxImrU9Up8rEjQb9+rXLPB/GTL/y5UKHkWeB7w90e4LDUuQFYwxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dy+aM331;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949DB606A31D;
	Wed, 28 Oct 2026 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dy+aM331
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7751F01825;
	Wed, 28 Oct 2026 17:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208383;
	bh=vNt/ZzOf5EAKONW7nqQGd+c7T0a1duhc7msPNVSAOJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dy+aM331meFWbOTT4mAuA1ixCInDCd4xaTEb7Vu7gaEvNcD35vYeEMxkEC8bKO1uu
	 P81rFk6OH7DHM4wkX/wF5hoxKhvqc4m0G0RIlQq3D9DRgTZpkz9kmjldanyA7EbZcG
	 kSfhiP55E9icHEfIMUfzeXLOk+OZ2xgZ6mQKgUKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/516] params: Fix multi-line comment style
Date: Wed, 28 Oct 2026 17:53:29 +0100
Message-ID: <20261028170004.879117083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 94ee86e6f8fe1..e6d96f84ac1b5 100644
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
@@ -747,8 +749,10 @@ void module_param_sysfs_remove(struct module *mod)
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



