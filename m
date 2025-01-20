Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA111DF257;
	Mon, 20 Jan 2025 12:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737376172; cv=none; b=B4+3wcxYEOdkjkilLDpLyu5zAD4RsktAMFkBlUQL6gwpKUASZmJIHAD/p43WZzbR6O8bZokKXQTHvK0TgtrneiSxRGlMaESHzdONzrAeBhJAJz/Dlepc9v7iV5IxSsZ+LyGEVzT6ZMA/iHTjyItmLXK1ylzXFqsJwBrEm/muEig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737376172; c=relaxed/simple;
	bh=2Tv1ry/n+QJXnO0d2oWFSgenQrO7SpDhoSbrCv14hvo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=rBVIaMdzY1V802ZoW1qBsnNpRxWJut8xPtVmrr5/J0kJSUnyJfsNBOLtckMsJel8O8wvjmzM9ZqgJGzfn57mozXwSuvX8meK8vwlDyTHp+NVNrM4FVgqKs3mzmBkT/G7zRDpbZLq96WrE2ZrkzHSwguet4T2Bbssd8ldH1RMLsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWfEwF6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWfEwF6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9721C4CEDD;
	Mon, 20 Jan 2025 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737376171;
	bh=2Tv1ry/n+QJXnO0d2oWFSgenQrO7SpDhoSbrCv14hvo=;
	h=From:Date:Subject:To:Cc:From;
	b=aWfEwF6ETjUWi4gCMTMWsAm6fVtdIy4FSLpVvqRm8sjozIOMPgkQ57RGPOCMh0O/M
	 7D9lquyrXutwWmkSqDtBGxxcvLtJfa5ZB1byITL4646dC5evLWkmqMBZFVth7J44n3
	 tQCXuTiE+HXvNR9kXxCkkgjJYVGA9mfxQAA1sEVYMCHaIniI+9IuvtvtpDiAmySP8v
	 JqVAdhtQtHeBdLRIYW5mUQSA22MoxTsRWfASWmjaAYloQChBTZYxaYa+TsAr1tKxQR
	 zWDLMjGaPR+r9RarzfLq1ihofWHV8FYSOwStFqF3VkYKi8v+MWn8lgvnuBsuLoADwm
	 g0CYpnvsYKQbg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 20 Jan 2025 05:29:24 -0700
Subject: [PATCH] tracing: Fix -Wundef around 'struct event_mod_load'
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-trace_events-fix-wundef-v1-1-61259cbbaa75@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKNBjmcC/x2MSwqEMBAFryK9tiEdCYJXGQYJ8UV7EyXxMyDef
 YLLoqi6qSArCg3NTRmnFl1TBWkbCotPM1inymSNdUas4T37gBEn0l446o+vI02I3HsR14lx0UW
 q9ZZR7Xv+fJ/nDxsk/e1pAAAA
X-Change-ID: 20250120-trace_events-fix-wundef-7a1153105f5f
To: Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1239; i=nathan@kernel.org;
 h=from:subject:message-id; bh=2Tv1ry/n+QJXnO0d2oWFSgenQrO7SpDhoSbrCv14hvo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOl9jiuXZeS6rDGY3nbwFFPY77MfLPzV3R6qyP++PS99l
 /UFjTtiHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi1YEM/2zl1Ng/G15ec3CD
 D89l5r/WOo+aVixg+7gvVsjsWdOliQGMDCe89NcqR/dyqJxa/Cb1a/NCuTk8b9I/3HosYXRofSm
 nKxsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When CONFIG_MODULES is disabled, clang warns:

  kernel/trace/trace_events.c:872:5: warning: 'CONFIG_MODULES' is not defined, evaluates to 0 [-Wundef]
    872 | #if CONFIG_MODULES
        |     ^

Use '#ifdef' to resolve the warning.

Fixes: b355247df104 ("tracing: Cache ":mod:" events for modules not loaded yet")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501190121.E2CIJuUj-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 kernel/trace/trace_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ab04994e4510..de934332ba36 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -869,7 +869,7 @@ static int ftrace_event_enable_disable(struct trace_event_file *file,
 	return __ftrace_event_enable_disable(file, enable, 0);
 }
 
-#if CONFIG_MODULES
+#ifdef CONFIG_MODULES
 struct event_mod_load {
 	struct list_head	list;
 	char			*module;

---
base-commit: 9f3ccaeedbe0088f1b89474bcf4187c49cfe8de2
change-id: 20250120-trace_events-fix-wundef-7a1153105f5f

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

