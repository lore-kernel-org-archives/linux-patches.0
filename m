Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E765E39B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302610; cv=none; b=filGNCfx41nVM8GFnmi16zYIXyirOV+1ZkpvregZcmf8x8/9tN22DILYAU5oSfHVu3xg2PGj8hcDMqAjMqHzZxxk1dqsc23rpzP6wxAWyA9f0mud//scRTyVdGAWVF9HZceCVI+yGlZVX7nRry5wIiYBNg7uRpRncUIcP3Sci9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302610; c=relaxed/simple;
	bh=bN/644zBTSd900vC2SE3jke87FUYoA6ClsrCDeBiMuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBdxhHhfnuuldIpFc2Er3NRzQNnhyeCAdLqBsr4VVbzGgbw4Gbvl717NAUwCBes7BBuz3rFSpErblkkFYXOK/hqinLuL2M2StfycpZTkm9oM8YnXc+pY9Kuby3tnGAuBwpY5vJsnmXvJP4rB7EFE68EArpdeDiw0cx6Xe3e+aFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsbQoONZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsbQoONZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAA0C116D0;
	Sat, 28 Feb 2026 18:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302609;
	bh=bN/644zBTSd900vC2SE3jke87FUYoA6ClsrCDeBiMuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsbQoONZ6mK+7VTeHkqYEszg7RhfcO/q4Hilkc3DEHtnPBUQDSAWuAwDovfDNfkhd
	 4fU6LQLkbmo0Z4mk2+Glztg8HmrChG4GRbHfXUKnytrQpfQvYaXPTaImk6mhSiDLWg
	 14HxfHHtVA6zCPfDCoaTAGXCSXl4vh2cUoLMD4VRpgoLwJyj0XUbVZ1GTNkyQmbJD+
	 vlJZJ2DaGsfLZGOac692V3viZU8qzqJ+pkwRcFXC5tHjHYmqNfWTsY3yKxyno26u3C
	 eShyuJ+led3P13pSXCnH/w6OImYy6bCLLRYA3PtkiHd/a41kWA5YYOzmAkUKuVVzC3
	 HSoA2wPq9ZJjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/164] tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros
Date: Sat, 28 Feb 2026 13:14:24 -0500
Message-ID: <20260228181505.1600663-125-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 4e282deb6f787..1dfdbd365c8c2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3294,11 +3294,6 @@ void trace_put_event_file(struct trace_event_file *file)
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

