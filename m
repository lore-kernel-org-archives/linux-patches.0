Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AA938D01D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302129; cv=none; b=rKwTdHFWstrcf81MdZW1FL5kCgwGODJVbIxuCr84tI72nTXG2tbWeXVvDwFX7pX1e1wfyp27cUHdDbCbOsyeqUOY48I3r80NGEdxdesqBebHnJiHjA7HOeV88Q/G7LbIPOf941xmLSqWO5mKq9jT4JesTG+9jbzC6SnvL27EZSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302129; c=relaxed/simple;
	bh=GkzjuzH8H3IohTasl/8HxdKUayanOBPPg8LESQes8Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHXE+yS+B/igAnqNycMrFUJkEda7FGqkSyjRV4Ka6VeohHxqNT1vsVUokJiYbEp0Bh1K6Hid1dYT00EdJNlybPqb3SmjI0F0hnGNuBK4IE0Gvcxe6s696dQ9eC2AGy9/Tev+bjdbU3AQzvyeqf12mFRekFLwqrgEFMjEdW1CX4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQ4dem6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQ4dem6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A50C19423;
	Sat, 28 Feb 2026 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302128;
	bh=GkzjuzH8H3IohTasl/8HxdKUayanOBPPg8LESQes8Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQ4dem6P7Rzyd3BoFB0cnj77DcvKe8SlcPCMttipCoHt+HVg9AIdRpRYfx3Q+C0li
	 iznY9myQZ8Q1RL/d7we5dKk1cgm82ThC32hK+77ZH5vEH9sJiBbe/eh1VXz5fi2CMW
	 ms92RyLiUfrbMdHVIeGr65uEV0Z0rPkY9YM82Mi0pG19fYKzHcU8NsbXCtERwTjU3S
	 RBEc/VsHYRPQOgwxp2NN03jVOud9NBU1yehVDVn3P4BADGqI9K39SsVVcGN9wykFOS
	 9aDCI1uq8Zez6F/ZvnDBjE/+j4A1lddsvyNjVImFq+7jt/G4SVIyxjHy8bRYRSrC4r
	 9Zstf4XxOk/5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Mladek <pmladek@suse.com>,
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
Subject: [PATCH 6.6 120/283] module: add helper function for reading module_buildid()
Date: Sat, 28 Feb 2026 13:04:22 -0500
Message-ID: <20260228180709.1583486-120-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index f58d1eb260fa9..10603f725cae5 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -735,6 +735,15 @@ static inline void __module_get(struct module *module)
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
index ef73ae7c89094..8428089791133 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -336,13 +336,8 @@ const char *module_address_lookup(unsigned long addr,
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
 
 		ret = find_kallsyms_symbol(mod, addr, size, offset);
 	}
-- 
2.51.0

