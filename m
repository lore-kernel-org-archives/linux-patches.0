Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E371CF5C6;
	Wed,  7 May 2025 19:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644829; cv=none; b=IFu0JMIXOAV1dEtL1LhQtlEcSPH4Kt7lkgFQr3yc4lYioeuPzoSOOgvi5tJyutUaYlNFW7mHWkgt5N5m33WzilXWMQJiu6YZbEhaLvV98YL0jKEkLFOPEzN8GyPuFX1dDRkiz21iMcj1dnBgQsrxNfBvCdw7gJvCT0LibD2FKnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644829; c=relaxed/simple;
	bh=oGP8apt2dECYp7qKBt5H4OhNQIGnhMHgPeQjykqldIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2E8P34LSOLlFiw8Wt5OOxCKJib5k0rdEfS3i/eHca2c3h+TS3VQpz8wp9DzlCi1Hm8eKkM6qMMVqs2tcA0CvDTnkQqtKp+DMg7exIZBx+hY+LAFw9iWPaHkePkOI9nCub6P2lCS7JBuVcldo7a/8daguNWzoaLqDmBeCq/I8Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOUm9NBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOUm9NBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CA6C4CEE2;
	Wed,  7 May 2025 19:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644829;
	bh=oGP8apt2dECYp7qKBt5H4OhNQIGnhMHgPeQjykqldIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOUm9NBLnn//Re8x0Oht8gytTNNYiEjYh7YO++BFa+XsM9AUYjXEB6xCdrk9DzJTu
	 iPWhlvVBSAQXWX5B5Eg1b6JUQWTsjHHD2yIBEIkRvZeUsqwgC6X7uiVioYAti5fBe0
	 l2SLF8lEf3eP57dmT6IycYZQzgWpw5nceU7f2QR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/164] kernel: param: rename locate_module_kobject
Date: Wed,  7 May 2025 20:40:45 +0200
Message-ID: <20250507183827.441287573@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2e447f8ae183e..d62a116918cd0 100644
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



