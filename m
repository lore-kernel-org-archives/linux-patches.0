Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672233C1406;
	Sat, 30 May 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164030; cv=none; b=mNx47n+j/JPlAaehXSsEt/RKcSK1zyoDxy0jh1utaY3tQv5ll4aY74tIUkwcmvlcByo5cNl3pZOwYushT3GqzqG5XpVy9qICTNn/T59FcUOoO+yNBQJH/252ru7Yy2A+IyKnW+147ktD28hcEo1G1v7tcGIP4+nw07P52qNTfR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164030; c=relaxed/simple;
	bh=otAQXdqr9SE/QIC5N4cboCgiEGS7dL+PH7gfXQJG1FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBLG5ryqMgltkD0SycxSXhY4joPITcGMc0IqgUxLjbNjn0l+heRHXSradaqcSBEoSZ1kuH/01QUsV6wHhv+YnVj4u3BzGBMlkL+4oxPivCkyNg/9+XqW9jrkK3wRRVV13qJ9zBZ3i0okNJe9mtFL8KyZG5PcPZk9cO3m5WCLtYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCSXdgdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCSXdgdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A758A1F00893;
	Sat, 30 May 2026 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164029;
	bh=NxZ3pnhzp06bGxewpfk9RTtAo7l688jcLyC4fAPl+nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCSXdgdHfwqKblEq0krldBVZI5nNFNX9ikdn4VyqDk3934gnn/1+W74bdzaNwk0bm
	 6Rm22VUBba7qGhj2IiGP5grj/B76wU2nyUIp2WjtkGnAI3ektZbh6bqCWO8rHZ3v6C
	 xTVHBoRk9h0sIs/udYvLArZ+CKRRvp+qH9XL47vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/776] kernel: param: rename locate_module_kobject
Date: Sat, 30 May 2026 18:01:53 +0200
Message-ID: <20260530160250.818993528@linuxfoundation.org>
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
index 1b856942d82d4..2c1b9559ff9b6 100644
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



