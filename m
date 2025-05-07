Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC3D1CF5C6;
	Wed,  7 May 2025 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644832; cv=none; b=g4vJizmyCZGpfWK9uu2bWBXqTg4k+svS7JzQIaNqnpkMgDSA3i2N2ywPmXE3v/w9f8BBcrxgfmB2KuFVHrUbccPcmVghRQGTkTcmtfyk4IjPLHVNVJDloHyF+XpxjplNJowZnqekKXmY0UkGHqCmDnoLk01MX82nl3jAFT0FKIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644832; c=relaxed/simple;
	bh=kn/Sjphatso3aWa6kQGTWjCl8sLdfyepkVHzRXoQoJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiLf0L9Q0JCGZnfzIkCHGR1nS4vdgJ8k7UKzoJyu+l7adh/G0687pkTWIlkC7yqiAyg1fi9+fUEzUpxo6N0Ou2rhZ1kspT5OTJEUTregq6v8dpgrvcWubmgEe5ZiHQRhMOYhNQg3clW5t7XrVWTRc6zlTm7Ya9pPgrvDXnjx+eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWPG47qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWPG47qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA60C4CEE2;
	Wed,  7 May 2025 19:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644832;
	bh=kn/Sjphatso3aWa6kQGTWjCl8sLdfyepkVHzRXoQoJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWPG47qxKQrGq4rug3nM8izE6ROXY6P+OQN6KfpVXVhvyR9bDA5PY3sUsJqnfQoe/
	 d6GgO7r0I9lFAhMZbinGnctlO+b2pemud3EoNt2408abPdzNyIG7DXPBY+NFtEllEz
	 M+pwQVSczgfYEnGiU1sFZwIwP0zlfkpCybq8HJGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/164] kernel: globalize lookup_or_create_module_kobject()
Date: Wed,  7 May 2025 20:40:46 +0200
Message-ID: <20250507183827.482637469@linuxfoundation.org>
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
Stable-dep-of: f95bbfe18512 ("drivers: base: handle module_kobject creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/module.h | 2 ++
 kernel/params.c        | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 88ecc5e9f5230..82a9527d43c76 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -162,6 +162,8 @@ extern void cleanup_module(void);
 #define __INITRODATA_OR_MODULE __INITRODATA
 #endif /*CONFIG_MODULES*/
 
+struct module_kobject *lookup_or_create_module_kobject(const char *name);
+
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
 
diff --git a/kernel/params.c b/kernel/params.c
index d62a116918cd0..33b2985b31c7f 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -763,7 +763,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-static struct module_kobject * __init lookup_or_create_module_kobject(const char *name)
+struct module_kobject __modinit * lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
-- 
2.39.5



