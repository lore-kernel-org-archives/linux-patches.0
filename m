Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9C134252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301784; cv=none; b=T6uCfMWdKSdPuM29MXomiJa2d4G+AyoKUCwr5c5QiaYuk7+IuL+784m3vA/M0cQOc9ATrgeUlj4mAQrjTJ4xFguvl4+EBLqXZY8Qls2I403q+x/V9weFmLKKQZPu8VMSSso1aMW+jd3akYlvLqnsdQ3qY6JHWmHCuJ50B4RtuQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301784; c=relaxed/simple;
	bh=e/vVCd6i5rZHmoSBEhVKKNRvJpV8gsU3NjQVKGw6GqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuQKkfYRDK81b2kOTE+Fc8MnezmDtVeZrsqNMGuDJjeoY1sMVZw8r6RbLRPbAm1AYxR0kXw2hTwXbQpFmbiEgXgIM3i1DOJAgbUQvCVFFxgHRRFP+T0SXRnUxWqPjbdxj/n0BkjJPT7mb+cXFOuo/0iumj8y/AiNznenc+fypb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1+t0nmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1+t0nmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5D0C19424;
	Sat, 28 Feb 2026 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301784;
	bh=e/vVCd6i5rZHmoSBEhVKKNRvJpV8gsU3NjQVKGw6GqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1+t0nmCOapmDVwSwQYR98jvPNl+qx8K2gCYbBvWYdJz5Ry9SrdPgJ64RfJj1Et9K
	 UQeDGS1kbSOmmvbfw8UaCGdkNEJGL+ohI/tJVBQDPWvZySvlI0a2aK/QV26bdFJpE3
	 FTXr7i/K1rHmstfCbsE4iXe5OZkaOJnAz/jS3prWpjqNMLtrOFZXZ2zZPjVV+gdqwD
	 yqe4EAtueXhkeutCVFWMMYjD+qoUGru7UhQvSk9wlnOF8iebLITeA1IqTTKWmrXpQW
	 wonaTNl7gShEBS0ikEsWMtl9Kl/YcEQWguZEDmQStCzJUi+f80RYPPJRauM1w6KrvZ
	 hGZ4Ua/64eqJA==
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
Subject: [PATCH 6.12 194/385] module: add helper function for reading module_buildid()
Date: Sat, 28 Feb 2026 12:56:56 -0500
Message-ID: <20260228180011.1568201-194-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 7886217c99881..1cb6f80e1b485 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -750,6 +750,15 @@ static inline void __module_get(struct module *module)
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
index bf65e0c3c86fc..30d0798f114f1 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -337,13 +337,8 @@ int module_address_lookup(unsigned long addr,
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

