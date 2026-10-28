Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212218;
	b=SAQZzNRKI7BBSHcRvQv2YMXfPw3ugZx4TEU59Isp3kxyyxoXzLVq6rUCOxuwmwmTcF3x
	 537o1h6x19fJ/aaguHaz0p5dhANmV3fDS8fFnG2qFMZ8DGiCa+NL8CaOml+wo5oruqPcm
	 kqBfZae/mPXmv64qzYsWk1cVAW7/JhniUzyIN83FYiq4HJoML8aqcb5jPVqDumnfyzM2z
	 hZDHBChOkcDbYoKQnliekoourjn1em9cHPAzHmSesBc0In1QRpLxRoSFfkScJpuvQlfzs
	 M1BA8hnBo265janyDfV+36/s16Ig4fo6rpRiEITFIH/gipejVXh6U1X3s8szM7vonBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xo2xRiEt5ArxGWtGJrdL+qN8TCgKM392C5xmAcoVbh4=;
	b=t50ciSODpR6HU3fDtZ6D7LjuFtIzd6gk32muEI8PLYDGBo1cvZDSTko3Pp6j2WQ5Ii1n
	 pPnFimfkAkEzFkuJShMC0U+03a6DiFqbbsqy4domqpMAfifeJE1CFl3GyU3OELbbXzTgU
	 KvBO3Y/PBz1IFvWbrblhqD6Y8gLif77PF39cxW2bCTMedvd1ie5Qh6iCdjRmZw/YnltjD
	 Y1VKCmmR3A0+S5rpeH+VHcrDl6wJruVWZa4LvF1vob7cOqsy7Md22zyWRzzTn01jVgotj
	 10rgVz6alYlTqgSpgj8Jk6R1eNvCGpU7zjnWEKGRF4qPrgvmSJrIgdntEMQud5FEYtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQXJHEYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C6606A31C;
	Wed, 28 Oct 2026 18:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQXJHEYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A6C1F01825;
	Wed, 28 Oct 2026 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212217;
	bh=xo2xRiEt5ArxGWtGJrdL+qN8TCgKM392C5xmAcoVbh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQXJHEYF4cpu1M61ddQpvixcNlD6qfykX971omUvPgjd6pY7psxzCKsSX+P8PqoH4
	 oI59TOQZxSEkQon8xxf7c6Lyn35Xgcca5cknbMe0OUnOWftHmM1SSfwvYDN6PSqWA8
	 5HLDlOxVy9WeYlHuCicxwZn8Ndscqh9qN2orEgOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0080/1887] params: Fix multi-line comment style
Date: Wed, 28 Oct 2026 17:36:16 +0100
Message-ID: <20261028170501.055037602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c51ce17862ca..03443c99496c6 100644
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



