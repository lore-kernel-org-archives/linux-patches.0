Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D4359A65
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302431; cv=none; b=B8GgZika/Wgnym99HCdvmYOclk2dBRg6qdhxAvCELE4MPTFeZEIo1zsFANZLq6dSkshdi+n9ZT/eqEulESZaLhjO2u5nN+xpLQb7+ypvehKCRrn0qPsYWwH7ZEi8MOSO1mSEkxS3mVekEsc1Bfl+5c4yvHHLyzM5ZM82U5lAo+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302431; c=relaxed/simple;
	bh=LzjNOhzoE3uUPij+HZ4md5ycBTHE53V27rhrmGOIQus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1nMMaiY8JX7RvBPrPR7DMzuaXr3C/b7PH1+zhz4QTBXoeP49uc4HkN5qt+F12ZQZTqeg00uj/0+168icbqLv8pDODjaieqUuu4pSxOwltT049H+kUJNk4c/mtHtmpO/4GANAPO7xd95PN/2sagNSfiMYusvJWUTR+VB6ms1oKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jm80B4Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jm80B4Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDE5C116D0;
	Sat, 28 Feb 2026 18:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302431;
	bh=LzjNOhzoE3uUPij+HZ4md5ycBTHE53V27rhrmGOIQus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jm80B4CcnGra4sJN/8j43VN5LV3SsYoYxU+VdoC5n7r3I78QjdKfK/GgKFsFJtJMh
	 Bdqf9J3x8HjnDT/Swr7mA+zljU6+svPJvpL49fRkedZHp741xIu+UBVc/MdiXUYktK
	 jEUFcWyATrVlsZPSaIc+qKLlDVVn0iP0Op7wTBTz1uXP6/QiwHDtaOjmEGfPA0SehL
	 maKyFw2J+4nAonlG+1AnIxIe6WsDQwzAj5eNusRYq5S8J+BhuyxlTkceX/gr2qbYuv
	 4c7OKAO0eUgHNyoJ6xz2DhYZSgNjXxdek3dKejcWjO85ze88QbypKDMzAyq7Mnm9wL
	 y/b4eb2jwzOiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/232] tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros
Date: Sat, 28 Feb 2026 13:10:21 -0500
Message-ID: <20260228181127.1592657-168-sashal@kernel.org>
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
index 6a146dfbbd7e5..55623a9bb64ac 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3327,11 +3327,6 @@ void trace_put_event_file(struct trace_event_file *file)
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

