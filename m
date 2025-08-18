Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0B131A04F;
	Mon, 18 Aug 2025 13:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523610; cv=none; b=F1CO8ABV/POU34ND93NUM++TsFdibL3MaJ57Y4xXgkT/cVv/FyPBv4j+H0ByGaSEAq/NonZ43eCGAG4IohpLeyJ6NKEZ9W7nIDuRwoLM4eySsSFaQWyFtnpB6+J8BYcnE0cBGGv+CKn0Td1n8eQ49mhItqc+39DD8+G1lwtm++w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523610; c=relaxed/simple;
	bh=NsPfWvJy5RUBXP44+BZmAq26B3Pm0WuzI1P6UVC3pTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGf9F9W+2UR6mpfPzZh7T6ZJxYNwWUZNiNF37VwrUMsuFYMm1JMqcP0S5ak77mayXfNJccIVoWGODnj5mPdA/2hhrcTirAmdkIdv93ecNlcI8JxtMQ8pPWZ8K1Ans0xp0W5SYuRw5M1pb9xpgb671kdzwrac4RWSYvqV6SICGiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZIp3QLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZIp3QLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C06C4CEEB;
	Mon, 18 Aug 2025 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523610;
	bh=NsPfWvJy5RUBXP44+BZmAq26B3Pm0WuzI1P6UVC3pTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZIp3QLyG5lxX1p8M8Wvu20qjIl8+AhoykisxslJTvv8ZINuiIZGF25Z8qXrksAp5
	 NrcM+k0tP7rVKBeR5UB23QQBYFvf2k1bffBvnpcy0Nyufb4/42RHd5Yquvuuq76yOC
	 vZLg59tiMR5ms1U88lcjWx/uzjrSZdK27B9OR6hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Nam Cao <namcao@linutronix.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 192/515] verification/dot2k: Make a separate dot2k_templates/Kconfig_container
Date: Mon, 18 Aug 2025 14:42:58 +0200
Message-ID: <20250818124505.762225788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 214459699fd202c28b7b9f787e674acbd3af724a ]

A generated container's Kconfig has an incorrect line:

    select DA_MON_EVENTS_IMPLICIT

This is due to container generation uses the same template Kconfig file as
deterministic automaton monitor.

Therefore, make a separate Kconfig template for container which has only
the necessaries for container.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/d54fd7ee120785bec5695220e837dbbd6efb30e5.1751634289.git.namcao@linutronix.de
Reviewed-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/dot2/dot2k.py                          | 3 ++-
 tools/verification/dot2/dot2k_templates/Kconfig_container | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 tools/verification/dot2/dot2k_templates/Kconfig_container

diff --git a/tools/verification/dot2/dot2k.py b/tools/verification/dot2/dot2k.py
index 745d35a4a379..dd4b5528a4f2 100644
--- a/tools/verification/dot2/dot2k.py
+++ b/tools/verification/dot2/dot2k.py
@@ -35,6 +35,7 @@ class dot2k(Dot2c):
             self.states = []
             self.main_c = self.__read_file(self.monitor_templates_dir + "main_container.c")
             self.main_h = self.__read_file(self.monitor_templates_dir + "main_container.h")
+            self.kconfig = self.__read_file(self.monitor_templates_dir + "Kconfig_container")
         else:
             super().__init__(file_path, extra_params.get("model_name"))
 
@@ -44,7 +45,7 @@ class dot2k(Dot2c):
             self.monitor_type = MonitorType
             self.main_c = self.__read_file(self.monitor_templates_dir + "main.c")
             self.trace_h = self.__read_file(self.monitor_templates_dir + "trace.h")
-        self.kconfig = self.__read_file(self.monitor_templates_dir + "Kconfig")
+            self.kconfig = self.__read_file(self.monitor_templates_dir + "Kconfig")
         self.enum_suffix = "_%s" % self.name
         self.description = extra_params.get("description", self.name) or "auto-generated"
         self.auto_patch = extra_params.get("auto_patch")
diff --git a/tools/verification/dot2/dot2k_templates/Kconfig_container b/tools/verification/dot2/dot2k_templates/Kconfig_container
new file mode 100644
index 000000000000..a606111949c2
--- /dev/null
+++ b/tools/verification/dot2/dot2k_templates/Kconfig_container
@@ -0,0 +1,5 @@
+config RV_MON_%%MODEL_NAME_UP%%
+	depends on RV
+	bool "%%MODEL_NAME%% monitor"
+	help
+	  %%DESCRIPTION%%
-- 
2.39.5



