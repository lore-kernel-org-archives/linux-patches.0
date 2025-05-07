Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45191214813;
	Wed,  7 May 2025 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645227; cv=none; b=hcn9ot05oK5QDKdiKPocGqAUqhU8TLem3p1KVt8ciFwrOXTSxuJx5d6+1s0QzT2S4ybWlVlFv08WcVAzEiY35eRy7Zcw2NrhllDaZCXLuy9mA+ro2YGn/OpTCPniaCRu8VmslTVovdvUeA7QqL3N0ZILxpX2FPRtnarDKF+5YiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645227; c=relaxed/simple;
	bh=hyC4ovd5ROo8voeu2XxxP8dn/qDcZOC+rhWEhxCMb+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtaMJv7Fit+xLS4Qe7CsXxu0ryvHxlW/lo27K7Jr5rD2XsG1uT7aEWd4kGKxrkb7qW1snBtupY+q+cU/pbHRGst6iEePPvyg2PQlRgFeEPlVDW7J9lI4m4UK0isptw3SRmtGDPPHV9POFdtJb+FQ28Z0aXwNuzulKgF09LiX5bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zn979jBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zn979jBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9956C4CEE2;
	Wed,  7 May 2025 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645227;
	bh=hyC4ovd5ROo8voeu2XxxP8dn/qDcZOC+rhWEhxCMb+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zn979jBdyk3nd7R31BtaOi17ek329zSPxAD4914znq7nRqBpDE2gb/LvXAETnSQ7I
	 xZqUP3F3MlBEcCH9KRt8XSHMZ6iB9b8xCmuKPfPM2dNdHODw8VNkQcd4Co0S/aJ/m5
	 SvJaJjeNhGMSVffieU59vLl1nCeXSHTL6uLD00Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/129] kernel: globalize lookup_or_create_module_kobject()
Date: Wed,  7 May 2025 20:40:58 +0200
Message-ID: <20250507183818.529262421@linuxfoundation.org>
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
index a98e188cf37b8..f2a8624eef1ec 100644
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
index 8d48a6bfe68da..c7aed3c51cd53 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -759,7 +759,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-static struct module_kobject * __init lookup_or_create_module_kobject(const char *name)
+struct module_kobject __modinit * lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
-- 
2.39.5



