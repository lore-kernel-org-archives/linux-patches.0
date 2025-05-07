Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDDC214813;
	Wed,  7 May 2025 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645224; cv=none; b=X+MXJubmlDo4VbJnufW2f1tVf7HJ+f/I3Ukvo9T8FCFAerp7RlvpJDjnk5bsBAtUieJhcfj7QaLJ9w075cI8WciGOSSpmwtpis0uXdhQUjcDjY6kHEEbIiPW0dZDgJ5T6/yyc8t7Abq1RBor0/8r2sel/YpTOVUZC6ZHCJlI5Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645224; c=relaxed/simple;
	bh=UPdRCDvEZ+ePrelRBXGK8n0C2JRBKcpcIwrD8fdCFGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4ejKVgcHbJ7QNU24eK1+wVo8sHDkG/4OZ+HoIUFbxGvahOlSSHKX+ozb3uF+bh091U/BFBs0vWOuM4aCNqtMkx55BBznchANptAlhPjTOYojsd8hkJDvLYUS5k5bfQe/dUIxesD1b4Akp+EsezOqYAtC1dVbrkxLzLJh88DELM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2KRMrYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2KRMrYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F78AC4CEE2;
	Wed,  7 May 2025 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645224;
	bh=UPdRCDvEZ+ePrelRBXGK8n0C2JRBKcpcIwrD8fdCFGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2KRMrYXknI2r8FqcEHb6O7BN4JjMiezgEy+v3OB/szlMa43S3aD6WQBE48da1VVH
	 6P0AHFqrcWf0wsMxQRSSAGeCsS105hJKw/5zSX5keuoWy1945dLpSg1u1vQuKjJtxF
	 deXZw6QV6DQy+nRY6aQyYmfPcptHj4+zJySRRRos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/129] kernel: param: rename locate_module_kobject
Date: Wed,  7 May 2025 20:40:57 +0200
Message-ID: <20250507183818.489488815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d4a0564697e8..8d48a6bfe68da 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -759,7 +759,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-static struct module_kobject * __init locate_module_kobject(const char *name)
+static struct module_kobject * __init lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
@@ -801,7 +801,7 @@ static void __init kernel_add_sysfs_param(const char *name,
 	struct module_kobject *mk;
 	int err;
 
-	mk = locate_module_kobject(name);
+	mk = lookup_or_create_module_kobject(name);
 	if (!mk)
 		return;
 
@@ -872,7 +872,7 @@ static void __init version_sysfs_builtin(void)
 	int err;
 
 	for (vattr = __start___modver; vattr < __stop___modver; vattr++) {
-		mk = locate_module_kobject(vattr->module_name);
+		mk = lookup_or_create_module_kobject(vattr->module_name);
 		if (mk) {
 			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
 			WARN_ON_ONCE(err);
-- 
2.39.5



