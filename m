Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7265F320CAD;
	Sat, 30 May 2026 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163914; cv=none; b=RBuw+0ifGyQOx9V2U6TBNFFxExOeotKlAG4fOEt3ob1qzc5Rwm0RIYI8lDzISKBurrvSPphPEMyrE16vmD/rfAe/c03p7qMFYN5csbYEuF8afpN3N1fedJvTuW02YqWsQTVdax0XYAsy6ToPXY0Yp31QGy/hjfPLtMNTbucVtK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163914; c=relaxed/simple;
	bh=8KV8psHX+CMuc3lcdvxbet2u+NAWvgxb6DfUq/eX5Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMzcJrT0Rm+n151ns7+J0HqG3KhbXPmkY4ojkDIS7LXh1+0Cww87+NlGj6L3bUqQib/CTgt0VKmuElw4oQoWnuSA62Rd9Yern0RuVGBNWMBwZWYh5MBfOrk85QrVu70OmAZiNhglESsXqAbSocaH+LB6NYKCxbu2LxVfXkJxPxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeFU/EMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeFU/EMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83311F00893;
	Sat, 30 May 2026 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163913;
	bh=xtHv4odBHA7wrRaJ02fwRfO3vqwAmNynLwfQwVmABNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeFU/EMKodWdWtWgtP5GW8CZAh+9lbanBYfxvd+N2uuKpEeS/3r3zXLqs6iapKNWV
	 p7fDGpCSxWveVmMa7r6A8DJ3BZVIsv5X8VpH/NdG7pBWdVPFID868QwZsaFXTslSb9
	 opxH8gyuyLCep4h50W77V9N4edjtH0Sy/Oxq0Dzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/776] kernel: globalize lookup_or_create_module_kobject()
Date: Sat, 30 May 2026 18:01:54 +0200
Message-ID: <20260530160250.843457882@linuxfoundation.org>
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
index 8e629b03ed1e4..440a2d08f7e02 100644
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
index 2c1b9559ff9b6..cedda487df96b 100644
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



