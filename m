Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF6C34A3DC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302746; cv=none; b=NWquKBul7onoW+bqeKWXwnfireXjQyTevfMu9cQ07jm99/hJu/A1uMhjYZHhdrYmDooeGdzCPjmdhtNitkfvE9WXwpLXM6U2i1IJuHZEMZ8tg2SymsVVQTqMzGmNBsIMVV2lV4tcb0/3Wjs/9bKuYhF3YOD/G4C6kZfHdVJCcas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302746; c=relaxed/simple;
	bh=SRcJYIiPHgNcX++h5ts6pKI9n8QHuDf7pQ2WkzU2DAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9Dox6KAtyY7MA/hrbi+Mk8TC0rs8jUCCKaj4EuUuHc0cJ85P7K9VFSVpNAe56IaovPkVeFDsssPNF1qhSZ4ueie07qpOu7SyB0jsBSuHZFRZoNC40cAMC0iwXfdnEiUCkEYnIXudQVT1Q4P6sTAOR47jG1ZQ2PTF+s++F0mcOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCeoM4IC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCeoM4IC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0655C19423;
	Sat, 28 Feb 2026 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302746;
	bh=SRcJYIiPHgNcX++h5ts6pKI9n8QHuDf7pQ2WkzU2DAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCeoM4ICEHQ5I/HvEP/8KT+ckAnoWOnv1e+ilwwmDlY4+COuDUNtIczoJBxGGOPmx
	 E/yDyn4MvN3dm2gSLxdOqIzje3NwaMpTEF+tgnkA3UMrskNfIAhJP056+HlzcRorIn
	 X8QaUcN7xfI2JFBLTCwqnMAgnRXBe08xuzY5L39h7NfRDmTiOiRizYwWtJC/yjT1+5
	 wvMQwXhbk8FYYHhzd+iHFo9msEZd5DpssKUswF58ogMQftYYAVglqwSsd/XQliZ0Zx
	 0Su4NJsyCdlowopz8G3B8+Y3l+FuUoLNdH3ZzDBWO/0P8iKI+Zjzr+TFp7Q7RfP7Kc
	 jlMGqHJAGJy4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/147] tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros
Date: Sat, 28 Feb 2026 13:17:01 -0500
Message-ID: <20260228181736.1605592-113-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 9df0e49c5b9b8d051529be9994e4f92f2d20be6f ]

The macros ENABLE_EVENT_STR and DISABLE_EVENT_STR were added to trace.h so
that more than one file can have access to them, but was never removed
from their original location. Remove the duplicates.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://patch.msgid.link/20260126130037.4ba201f9@gandalf.local.home
Fixes: d0bad49bb0a09 ("tracing: Add enable_hist/disable_hist triggers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c9fc3c442681a..da4a69e1929c5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2848,11 +2848,6 @@ void trace_put_event_file(struct trace_event_file *file)
 EXPORT_SYMBOL_GPL(trace_put_event_file);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-
-/* Avoid typos */
-#define ENABLE_EVENT_STR	"enable_event"
-#define DISABLE_EVENT_STR	"disable_event"
-
 struct event_probe_data {
 	struct trace_event_file	*file;
 	unsigned long			count;
-- 
2.51.0

