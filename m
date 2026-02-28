Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261902DECB2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301872; cv=none; b=bgkZu5DfBRiBn3HURLsE6Bn1q4j9B0xX11nEdwTWmm1LBgwzJMhmk2k+i715ZxDEzdCUXMyffKhJT7tV1ZSVZDQ+LmLYNpC0orPaAVC30ZS/VeUZmy5QuaSMEt+P2zD2Gsc77a812aLFU8COlN2LbDy4Nmj2pz3p1eMEZzZ45lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301872; c=relaxed/simple;
	bh=lsfku1hShHfoFe2ERSsC17TXYNb3iKbdtWGP6fMGWRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAZPRfVdZrjS+w1q95auvP50anHcg3RsJTYN4ldcVL+PUdCAwPLDl4i1y5iFIb4/R3Uq7299hybApCDsL8MtYUaO6mhFMAmrBRi6r/NByopK1/b5MAP0llmWjzxe2e2ligvnduQVYaIPQvqQQ8H/A2pGRdlD1tgoxc5viBrJDDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iw3r+lHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iw3r+lHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AF9C116D0;
	Sat, 28 Feb 2026 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301872;
	bh=lsfku1hShHfoFe2ERSsC17TXYNb3iKbdtWGP6fMGWRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw3r+lHtFrrYuXhW6BB3VIMnDleIX7Yjh4/yk8Vug1vVZ4JD/6vLGoOb0PqSdIrMr
	 hwia2B7rnhRdJ788jpiRLJ7GmuvRuMqMJBw7UctYlewYf1hqe/4X7DlUDrAKrCtogY
	 GAUNlmhj55+P+QAFVMVWTKhyygEpbaHXuTKvt5ufGja7NnfyvPAGjDSlJ0h6Jc9QyD
	 Dm7ve4VJ7YDRemnGbZz50KeVO94tmj9LfhqFqlbQR7D1uf/zBDyDRRBF7PzDbYLuZR
	 NTJlon1JlHDSgvTZa4hX09W+GDr7iP/WxyDyPvFsebVBtlCpqs2P0Wl2EFj3Dp0E7u
	 146mCKwB4qMTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/385] tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros
Date: Sat, 28 Feb 2026 12:58:38 -0500
Message-ID: <20260228180011.1568201-296-sashal@kernel.org>
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
index a3d7067eae654..284ea3c3f46a7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3609,11 +3609,6 @@ void trace_put_event_file(struct trace_event_file *file)
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

