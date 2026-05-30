Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4934041A;
	Sat, 30 May 2026 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163917; cv=none; b=KKt0w45BAdBQ62g87EUdA7WePY6Hhsz7BYQQBmEZBTZWTtr34fiFnR9u2LWI+iYjvzeLAWVOBRrYe4DicfPrl3XAQg10qua7Q1ukjB6kjVnudTA0GdPM99vzc1EoU/5exWHgxlP3JMANQrVob1eI+QucCgd4vBlgtEPOZJCEC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163917; c=relaxed/simple;
	bh=Ddx/Ko1RYXDnhu6URiWOydC/dMAEcNKw1bGVABGl3lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNSLI0v+FP4XP3X7NQ/uGvKMjSL8ZmYJxc3oAQ43CuQ+p/3+KuuQNBpZdO/DchjYv348HdZTmjsieGMrrLlQoEYkPCDZorTgY/KL7nRi0PdLBNJC1m3Thso307c2spttoZ/XG00oMHcUUKmS7LcIvWa3SCiXm3EMLawV1yhIi00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cG5HYePg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cG5HYePg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D95F1F00893;
	Sat, 30 May 2026 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163916;
	bh=8uao0kM0N3h3gSPGDnKuWp0PDpaOFwgmT7+oRE+sjCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cG5HYePgPqw00aw1wtqseFBDkGtv2tTy8vZmqutnTwWpgkWARRaN3gxiRH5lw2g21
	 nbwIfVtKBifcSVeI1RjwfIxI1mAXRpE5j95zgQ1qQ+oXtNt/K5GerVG7JVshINglZQ
	 2Sv1l4I/t1uVOp/TKpVvz7913pmQV6Ber8tFkc0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/776] params: Replace __modinit with __init_or_module
Date: Sat, 30 May 2026 18:01:55 +0200
Message-ID: <20260530160250.870413196@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 3cb0c3bdea5388519bc1bf575dca6421b133302b ]

Remove the custom __modinit macro from kernel/params.c and instead use the
common __init_or_module macro from include/linux/module.h. Both provide the
same functionality.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Stable-dep-of: deffe1edba62 ("module: Fix freeing of charp module parameters when CONFIG_SYSFS=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index cedda487df96b..9a76f556b898a 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -592,12 +592,6 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 }
 #endif
 
-#ifdef CONFIG_MODULES
-#define __modinit
-#else
-#define __modinit __init
-#endif
-
 #ifdef CONFIG_SYSFS
 void kernel_param_lock(struct module *mod)
 {
@@ -622,9 +616,9 @@ EXPORT_SYMBOL(kernel_param_unlock);
  * create file in sysfs.  Returns an error on out of memory.  Always cleans up
  * if there's an error.
  */
-static __modinit int add_sysfs_param(struct module_kobject *mk,
-				     const struct kernel_param *kp,
-				     const char *name)
+static __init_or_module int add_sysfs_param(struct module_kobject *mk,
+					    const struct kernel_param *kp,
+					    const char *name)
 {
 	struct module_param_attrs *new_mp;
 	struct attribute **new_attrs;
@@ -758,7 +752,8 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-struct module_kobject __modinit * lookup_or_create_module_kobject(const char *name)
+struct module_kobject * __init_or_module
+lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
-- 
2.53.0



