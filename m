Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361981482F5;
	Wed,  7 May 2025 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644328; cv=none; b=qCMyZXTBXmmJECfD/u1Lf0d+7+59RIsrm8cmhwFUubRLF7hn5FC+9qmGFTbj9AaraqDFPew0BbdALRpO9OrfbIlcQ4gSdXbLsBynLPAj05HVNDhM3MKBZeeJrzJqGCfyW1+Iqg7GWatcVX+NOUj9IvAm7CAuF9AO210ywQS/HJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644328; c=relaxed/simple;
	bh=OBuoHEyXB3RMe5pgH9CtYgLZZyt7pfjTKvkpvdUPjAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mY8QlTvHprEBZXKqGPkoxbIpKSRBAUzB8WdHj/teJEV/KxCcRD9S2zKeklfYRckBD9N5qdloGdE0UIBrMDLD7GuGMa/J8Uwkf0T/suHqKSNH5PGWBtMdiSYAKldV0VVERZW1nckjR6jQdSQQqJeKq1CbBCWFfCm2fizEd79OGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3wwa8hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3wwa8hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF09C4CEE2;
	Wed,  7 May 2025 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644328;
	bh=OBuoHEyXB3RMe5pgH9CtYgLZZyt7pfjTKvkpvdUPjAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3wwa8hSQxzxdoYly+Ww7F4SZKNFwmjdfg8XB2yT5FMFJaWJR/knwe8510DyFQzkd
	 cUp9tDSbJGembhbM21kIMbR8GU8eMfG3iWOKw4yzU2setVQ75jcd2MJ0IBgQ+kiUYQ
	 T9oj7YOzdURlNwhhjyJUo6MPYVxioYRjSy4tKWI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 175/183] kernel: globalize lookup_or_create_module_kobject()
Date: Wed,  7 May 2025 20:40:20 +0200
Message-ID: <20250507183831.947236920@linuxfoundation.org>
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
index 30e5b19bafa98..ba33bba3cc742 100644
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
index de1e64cc202b9..c417d28bc1dfb 100644
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



