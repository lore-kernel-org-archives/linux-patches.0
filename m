Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E37719E82A;
	Mon, 18 Aug 2025 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525369; cv=none; b=U1dWcbRgmbwOKb3CiWGJgH57pJVlp4/3z/9diJw2FRAjucNmDJS61LY3+ApYQnLC4dmZc+6HzRh5ZZdmWcG3wZW4Kto6AikSe3EHTNCNzyY0YdvQ2DRrG0ChvoOaA/AuTD2tDjjUbZGS/Tuj/C3K1gorPJ8liTGlC5E/f4Sqr4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525369; c=relaxed/simple;
	bh=anCvD88NKyArOGq68kMwGRcTnsT8oZ8eO3ADi2IIGGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAiop8PoOaOPHt6y6h3fMOebuKQQBvvP8Y0pLzP8YcWc34r+asSetLKeIdwxYlzIYpOXDoNl8HH86OEQDyOV3nEO31cHO6B7ULnmIqgBL+VoiSBMXKSA8lYw+5kUf21wpl57BZIEUHrHKBrmRVu85GWY6MqL/tRgEWzmZeoQ9cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNtAwEmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNtAwEmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71DBC116C6;
	Mon, 18 Aug 2025 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525369;
	bh=anCvD88NKyArOGq68kMwGRcTnsT8oZ8eO3ADi2IIGGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNtAwEmRhbo0EubV5u7z5hZ9/5f/yQm1O3SA814yNGFSjaCEb20LKl5ahiKlsYLWo
	 lOiPcalOPdJsoKwnTKPQbiuyHH3dEqisqKopFXEeVGH2gKVhxlr2VEWJ8GqoO2Hd+j
	 MqKkhhZ6Tr/dbcKKlTg5vg89wjSNh9HU9LDS6pRc=
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
Subject: [PATCH 6.16 208/570] verification/dot2k: Make a separate dot2k_templates/Kconfig_container
Date: Mon, 18 Aug 2025 14:43:15 +0200
Message-ID: <20250818124513.817610183@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



