Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA312D248B;
	Wed, 25 Feb 2026 06:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002633; cv=none; b=oq2WfaGRip3Mh3nF+aOWoejPMMkO/LXnKWmViIT8O5/uLSkbedhad7LnJ37ca80vrL9jLks2BotGv5ke1LwL1zxCpJB1Tzo8Yr7Bgf+KICKM5P1dcDxQ2+ngyw12fEC8nJsEauuCGo6Znt62IDVKFhoWxQxTFtiWbrQ7TWht3+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002633; c=relaxed/simple;
	bh=GuPqNh/SH2NExMFNgn3pJ+Rbd+5U+EoRJ1F3IVXEC7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7Jn3WU2ltHRwUSsIK7ij7I7Ju53NZD2FW8obv4Qtk1Q5qtlyzvKFW1PKYch1Zh/Jxqxg3q2Hdgfm83viYrAtCqM4pGtlI3IegM8A6qRshapzZgNnXLNFAhqUJcz9lYZUUzuGe98RhH5a79ilpO0c9OcNs06w4cnSEnKVZxQPcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHgm0aCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHgm0aCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F104C19425;
	Wed, 25 Feb 2026 06:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002633;
	bh=GuPqNh/SH2NExMFNgn3pJ+Rbd+5U+EoRJ1F3IVXEC7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHgm0aCKY3qipk76rHrZbg6JXXSJYRvQLpDWgGITBtnX8ygkFvkfQVafTI8/6DjDz
	 176Gjacvcy99gRw6hKw7Kk9Lkb2PaBZiPjMI58NMuUJnCySWPxgzj5gLFnTStMQWZU
	 SO1kHvfK+GsbY/jRT5mkjXsdzym9oELEGNpTHuqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 397/641] tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros
Date: Tue, 24 Feb 2026 17:22:03 -0800
Message-ID: <20260225012358.190825118@linuxfoundation.org>
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
index 099f081329021..5cf55a9c6fad4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3964,11 +3964,6 @@ void trace_put_event_file(struct trace_event_file *file)
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



