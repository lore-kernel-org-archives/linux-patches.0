Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710C2263C7F;
	Wed, 25 Feb 2026 01:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984013; cv=none; b=hBo98SFF4kX0jAvQZsLGxFMa6T906hXhqZKIPnBuNZfFr/mXPX07HHI2CfbLmF3CthkmZ+6QqZ2peX/BCUjQvxTBghL/iJL0G+OCgUtYyR5ZZceuJLGfpVIdNWq24hlkry3b+z8pMvLC9rqyTCbZVdmX4ThAlw+E/6PVS+8G078=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984013; c=relaxed/simple;
	bh=7W2vQhCSO79d2Yl2vRJv7NHIFd4F1ttOFPOC6n7+miQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTMrJb0Eqw8qKLoUtA7J4+YPoTgwmFpnxblZodsv/ZOA9r+i2UeTfmLOMcZvWrneKhM6Bo4lrqNWDzF9blbLVw4YniU7eoUeGh22iraoDDjSeTi8+oKugLL0o19tgfy6Wf5MZy3kUiqYtXbS5UNmeuqTI2KNiR7fGwVPuaIn7JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjem3DW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjem3DW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7B6C116D0;
	Wed, 25 Feb 2026 01:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984013;
	bh=7W2vQhCSO79d2Yl2vRJv7NHIFd4F1ttOFPOC6n7+miQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjem3DW4nu1pkBqHUUgcFbRiQlE/Eu7ksOp60vinYQbMc4gNodRNNKCRRYPjlvP1u
	 tebILSBL+ZJbvUe6pQ7fb7fpRQ/Nd0KEhLgXEKh9JhK4ArMPHKt4Tn1bnmYgdO8/4M
	 5i5Vu5zX1wx4XSWYTX7/QqrGoZfDYtE9LRgWyi5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkman <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Marc Rutland <mark.rutland@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 262/641] module: add helper function for reading module_buildid()
Date: Tue, 24 Feb 2026 17:19:48 -0800
Message-ID: <20260225012355.167524030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit acfdbb4ab2910ff6f03becb569c23ac7b2223913 ]

Add a helper function for reading the optional "build_id" member of struct
module.  It is going to be used also in ftrace_mod_address_lookup().

Use "#ifdef" instead of "#if IS_ENABLED()" to match the declaration of the
optional field in struct module.

Link: https://lkml.kernel.org/r/20251128135920.217303-4-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: e8a1e7eaa19d ("kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/module.h   | 9 +++++++++
 kernel/module/kallsyms.c | 9 ++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e135cc79aceea..4decae2b16755 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -747,6 +747,15 @@ static inline void __module_get(struct module *module)
 	__mod ? __mod->name : "kernel";		\
 })
 
+static inline const unsigned char *module_buildid(struct module *mod)
+{
+#ifdef CONFIG_STACKTRACE_BUILD_ID
+	return mod->build_id;
+#else
+	return NULL;
+#endif
+}
+
 /* Dereference module function descriptor */
 void *dereference_module_function_descriptor(struct module *mod, void *ptr);
 
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index 00a60796327c0..0fc11e45df9b9 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -334,13 +334,8 @@ int module_address_lookup(unsigned long addr,
 	if (mod) {
 		if (modname)
 			*modname = mod->name;
-		if (modbuildid) {
-#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
-			*modbuildid = mod->build_id;
-#else
-			*modbuildid = NULL;
-#endif
-		}
+		if (modbuildid)
+			*modbuildid = module_buildid(mod);
 
 		sym = find_kallsyms_symbol(mod, addr, size, offset);
 
-- 
2.51.0



