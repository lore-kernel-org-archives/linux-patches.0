Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B623D34BA42;
	Sat, 30 May 2026 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160846; cv=none; b=qGOfr1yyupHlLu9Z15QYhz++AsgZjx6fL+t6yqCRFsmVNZATsr8Q3LjMzdIS+ZYBvowAp4X1D9Td7ztr0TIq4LtJc/J96hqanT2AkQia4xxve/ASTONU6nTdZnrWaa0EvAyQtT8PqBH3wIGulNFo07SYBi4qL0Jlt2N5K/t0wUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160846; c=relaxed/simple;
	bh=JYbY0Vqeq2fytn7TBEU4m2cCn90Z12kXA3LBdSPvoJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMg+0YVKpsa+Jh24btE1A67k8IOhOJ3Wm8nfSGBHOtqCYtr04frTILhwnKOmOinoQNbPcX65KeIKZmdaNbj/W0nyhxWL8wR4SqHZaJ824e6cvmrENzXRkdEnpVXP4ioLu6MsWrynHJHRrK5fjQJGjJl2QjgNE+jLq0HQ89BC+zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zdHdYZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zdHdYZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077D81F00893;
	Sat, 30 May 2026 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160845;
	bh=QDRAJVYg+MGAijF474NkfBXZsqWA1763PBJPwj44uqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zdHdYZtWixnsKgzqPumg4oayInv7bzhUx6ueMVPqAZPvosCpZPs2Dv/gPekSVMjK
	 W1fMp3uDm/caryjNLePIE/ayysRdO2NUUZKNRNir2UlhxqRfZ0PM9nEwGiw72FKlEt
	 iseDiXfx4a38SlXqi/0ZL77RtKbnxFGMWSQYQBPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 452/969] kernel: param: rename locate_module_kobject
Date: Sat, 30 May 2026 17:59:36 +0200
Message-ID: <20260530160312.759064988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Saini <shyamsaini@linux.microsoft.com>

[ Upstream commit bbc9462f0cb0c8917a4908e856731708f0cee910 ]

The locate_module_kobject() function looks up an existing
module_kobject for a given module name. If it cannot find the
corresponding module_kobject, it creates one for the given name.

This commit renames locate_module_kobject() to
lookup_or_create_module_kobject() to better describe its operations.

This doesn't change anything functionality wise.

Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250227184930.34163-2-shyamsaini@linux.microsoft.com
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Stable-dep-of: deffe1edba62 ("module: Fix freeing of charp module parameters when CONFIG_SYSFS=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 27954dfe3d204..6e41ecc54b534 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -758,7 +758,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-static struct module_kobject * __init locate_module_kobject(const char *name)
+static struct module_kobject * __init lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
@@ -800,7 +800,7 @@ static void __init kernel_add_sysfs_param(const char *name,
 	struct module_kobject *mk;
 	int err;
 
-	mk = locate_module_kobject(name);
+	mk = lookup_or_create_module_kobject(name);
 	if (!mk)
 		return;
 
@@ -871,7 +871,7 @@ static void __init version_sysfs_builtin(void)
 	int err;
 
 	for (vattr = __start___modver; vattr < __stop___modver; vattr++) {
-		mk = locate_module_kobject(vattr->module_name);
+		mk = lookup_or_create_module_kobject(vattr->module_name);
 		if (mk) {
 			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
 			WARN_ON_ONCE(err);
-- 
2.53.0



