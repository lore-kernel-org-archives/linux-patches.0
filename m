Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE8519AD5C;
	Wed,  7 May 2025 18:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644278; cv=none; b=nLvz101ppNRoV8Ddf6oJfpy5MeDysuFzE6kWcIXwUWn9scnoJ0yDcMXoh1y9+8E2oKsy6Zz+pOwyZ2F6N4Z586R9tKdnR/fLA/Nbwr+8WjOYP8hb8ySpj417tA10W7ObVyEkxCJTeG9v+GQ5MUJT5uhIzTWYA3OCWw42k/qkGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644278; c=relaxed/simple;
	bh=BoKTwrcRBuV80Ns9TtmaeMdyF1TTOosJMhAd4ZiZYII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxdCP2kvNd5G4X1+EL5fyKahBjC/snES5FhytRfSfJ4LZSPgR5evKeLTDgZHyY0wsnf0Rp27tRhMKJ9Sf5qjY1kgUJn8TXaFHnG9hQ9LffO+Sf3sJnC8zPFNYVQDjftgdUhcgXmws1BR8kIIxUc3YNg0iVXcd8y9a5z5GLJf4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08cMmnEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08cMmnEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A10C4CEE2;
	Wed,  7 May 2025 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644278;
	bh=BoKTwrcRBuV80Ns9TtmaeMdyF1TTOosJMhAd4ZiZYII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08cMmnEycTLrhHHeNQT8mOdey+enQ6U8TOrT5ucbN7Uc6QGstn5ZJNBSZBBSHwrDL
	 j5znirisBVuHXko5bRkwdSS2BqXm5+G7vl9iciis/coYIFNRCtJtdmhjAo3Qhd9LBC
	 lePFHrA6+AMLDXkOOSIYsPtQe8o8OJ0h4xHzyYJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 174/183] kernel: param: rename locate_module_kobject
Date: Wed,  7 May 2025 20:40:19 +0200
Message-ID: <20250507183831.907841301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: f95bbfe18512 ("drivers: base: handle module_kobject creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 0074d29c9b80c..de1e64cc202b9 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -763,7 +763,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-static struct module_kobject * __init locate_module_kobject(const char *name)
+static struct module_kobject * __init lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
@@ -805,7 +805,7 @@ static void __init kernel_add_sysfs_param(const char *name,
 	struct module_kobject *mk;
 	int err;
 
-	mk = locate_module_kobject(name);
+	mk = lookup_or_create_module_kobject(name);
 	if (!mk)
 		return;
 
@@ -876,7 +876,7 @@ static void __init version_sysfs_builtin(void)
 	int err;
 
 	for (vattr = __start___modver; vattr < __stop___modver; vattr++) {
-		mk = locate_module_kobject(vattr->module_name);
+		mk = lookup_or_create_module_kobject(vattr->module_name);
 		if (mk) {
 			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
 			WARN_ON_ONCE(err);
-- 
2.39.5



