Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B55934BA42;
	Sat, 30 May 2026 17:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160850; cv=none; b=tTTrDtZ+b+zC1G8lcTFA1Mbm7u/gluski7UJTX2FgFtBTae7W5fbeSira1PQSIekhXvjSqzLNajURxEDMwHYFK0ifvw7a/NN5V44H9/k4kLEUBXrTAjQ7M3zGAQUQtyaOPKZ2nAM9RktDgcWTR5qIfSLfoDmzbOxn4h5RtDW1rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160850; c=relaxed/simple;
	bh=egaLjmGiErvE/5G/6PCHDLqImyu9uho13FZPmIqOvSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a49pY2c1x+IhAQ4YGP3ktpoPy2VfkGNEK/gr8SnLHZrWvBAz7QvjTjT2js8fWA6oqoO8NFvJagg2ietVEdQ/VJIHndoNiYhgpf07O/vcw5tCulydemTxKQJXxMSmj6xyVpKlbbIGGyKXr+qsG0/cOSEcbIwY2UXXTzc4hgnQSp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOmttpJz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOmttpJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505A21F00893;
	Sat, 30 May 2026 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160848;
	bh=MrHf7RUpgdrjMs4q2gKxZgUBZ+ECoDmQpPiZVI+AymI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOmttpJz6w8IBALakTNutPeUyMl5TZR6GgV4DivKhTHo6m/34IZQaGOmmPFxzZ7+J
	 fGCRUm8MsyAfEW8DmUG/I06BIcI50LPfoia/VzK1S4tKvjJEVev/G4gtMHQCXfAfnU
	 ZEwvqnHpWJ6CwbexdDE7KSvX1/BvQl8C0kgiNOAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/969] kernel: globalize lookup_or_create_module_kobject()
Date: Sat, 30 May 2026 17:59:37 +0200
Message-ID: <20260530160312.786438232@linuxfoundation.org>
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

[ Upstream commit 7c76c813cfc42a7376378a0c4b7250db2eebab81 ]

lookup_or_create_module_kobject() is marked as static and __init,
to make it global drop static keyword.
Since this function can be called from non-init code, use __modinit
instead of __init, __modinit marker will make it __init if
CONFIG_MODULES is not defined.

Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250227184930.34163-4-shyamsaini@linux.microsoft.com
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Stable-dep-of: deffe1edba62 ("module: Fix freeing of charp module parameters when CONFIG_SYSFS=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/module.h | 2 ++
 kernel/params.c        | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index a119d2d6c0cba..92f6d8d6dcab0 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -161,6 +161,8 @@ extern void cleanup_module(void);
 #define __INITRODATA_OR_MODULE __INITRODATA
 #endif /*CONFIG_MODULES*/
 
+struct module_kobject *lookup_or_create_module_kobject(const char *name);
+
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
 
diff --git a/kernel/params.c b/kernel/params.c
index 6e41ecc54b534..587d9cdafd118 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -758,7 +758,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-static struct module_kobject * __init lookup_or_create_module_kobject(const char *name)
+struct module_kobject __modinit * lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
-- 
2.53.0



