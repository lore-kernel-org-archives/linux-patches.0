Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC5738F654
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302205; cv=none; b=YQLmspOsBVs7qFxrtGhbDhrSVgLF7/igsCfHCrfWWQOV1QdyfN+Xw5gcu7zkUl4JUWzC34bGXEyX5A+aZWdkFKTEgEo414sAG+wIR756lZtsXdoeGwCmpaVhEkXAK8AGn5vz8AHmf8vPQ618xdjbe26jrr9QuyqjE4JHVDDSZig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302205; c=relaxed/simple;
	bh=hBpvVTT6KRZC8E0mQNepA4SHMddWToMQ7QOZHEb7t9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkbO3E1pWkC7NhbuUkEYg9XOytgPRxBflCrbWCEHBxIO17+5loxN079W/1iIWilOOFiIci2EArR9J9PwRNNELJ7yPd42VMM8wr3GuCQZsba+PPWHpoqmlWPQ/tW5rjm810QQKsOo8G27qoIo5M8CeeQuHlbUfy3j+qm6ReHoMA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIrGDabv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIrGDabv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B95C19423;
	Sat, 28 Feb 2026 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302205;
	bh=hBpvVTT6KRZC8E0mQNepA4SHMddWToMQ7QOZHEb7t9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIrGDabvzBOcYXfGWzvxE91KQbFIvUfiw/LyNv6k9G+ivDd5GL2NWkRrhbyyqDdpn
	 h5DDPFGppmRk05zbeluBupe8Ys3Y5wLzEaxE1V+Abp62fTNL7gYj+ehlD1/nuwGsL8
	 i/8Qb0flnkPazCcY3R9mPXnZUPm04dDa7In96ytbR61oqLt5kT+jS5eV4JbWlq03N+
	 sr60c65Jhk4Nlc5ZCqBD8o9u5Z2/5dQsihlo6s9oGt0AqCm6kaXM+VcdH8sJGGa10p
	 e3D3I7lAVmXyCOKRdD0QT02uO80wKbfTlc41tuTT4v1x5dCA+7hARlBBbzMzLxVRtG
	 UjD//fVj4GFog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/283] tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros
Date: Sat, 28 Feb 2026 13:05:52 -0500
Message-ID: <20260228180709.1583486-210-sashal@kernel.org>
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
index 382e07cd49f9f..b26d7bb07e113 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3575,11 +3575,6 @@ void trace_put_event_file(struct trace_event_file *file)
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

