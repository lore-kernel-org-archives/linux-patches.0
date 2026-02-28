Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F82736C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302372; cv=none; b=qJpvcC2SVJajokMq8SVWPPYziiTaRjfFrR8GJrAKd06q9layUbfP0I/3T2EvNhK9U04T6qdVmBNe8wiKk04HUSI2kLJDYkfcRq/s8rjxt7CDKl1vFSGAlOkswsvbD7UgqU7FciGKKT19MbaBQzzesHlATiSojfmtGWWst5A7z+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302372; c=relaxed/simple;
	bh=Da+4LCE0/CDM00BoJU/7w68x3YE0I9JP7yTbYJhpKBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuYSziSIeut2TcAaCLehGFULz+KKrEJ2/EnExXvmfhiw0KShy4Quv5oHGtintfvRE06+f5CA9rGN/6OhslFXc0mogM6/Mx1/JuRs5cZ6R6qrpG/OicC2Treptt1rykoUVubhbgu0Nlic/wAkzBUbqnBwziKbHRFlFqlkuqqWBTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EuNdsq/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EuNdsq/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5683C116D0;
	Sat, 28 Feb 2026 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302372;
	bh=Da+4LCE0/CDM00BoJU/7w68x3YE0I9JP7yTbYJhpKBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuNdsq/E9wAFqJPMW85ZPuCL24XqE4m1gmkeApxRMTihvLFu56xUOpDiJAn3ZlvGN
	 CxZWJ9U5fZ2WZrLnr7CxgPgNqsyBKcpBO09L1Dqzoww3UIQXg2mgba6z4/dFsJY4cU
	 6Io2ZG/LJD6EYglo0gnMPr29RAwUPF4Mp1aubtAGjCz0N0CtTSKfRYathSFspTYr45
	 SufoyPauQIjUoMyWfTnNcI5hCsmCxnozaIt2a/E/fc5WVtkJPi/0OIxm2I+bLLKaXV
	 ray2SC8h/EZqMgFp8VKbKLE51Q5BPV2Zw5XmjeH0TH3luOR5SMAWBURYXd5uak1dih
	 fU6rX8iSR3HRw==
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
Subject: [PATCH 6.1 100/232] module: add helper function for reading module_buildid()
Date: Sat, 28 Feb 2026 13:09:13 -0500
Message-ID: <20260228181127.1592657-100-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 41c4c472ed175..a119d2d6c0cba 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -656,6 +656,15 @@ static inline void __module_get(struct module *module)
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
index 4523f99b03589..824265d6dd166 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -339,13 +339,8 @@ const char *module_address_lookup(unsigned long addr,
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

