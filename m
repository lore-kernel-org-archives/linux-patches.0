Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737662FE593;
	Tue, 12 Aug 2025 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024166; cv=none; b=G1BLM9Ap2FDfughBrw4xC2HKbNthGM7aVqk1WZ41zPW/x3ffBWn1fgzuIbYf+UL3cf2emJeziumqjeoSehF+tHaQgbd2wRFa3atIOyt2GnJ7+/C5BVUseXZtszYOw/FEfCmdEuhkZgoHpDgEmvr7SQMR1LB9wdbDH8dvqx4K50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024166; c=relaxed/simple;
	bh=UTuqIYkLt3YSUCUKMuLk2XwHURssXZDtj0IQ9q8c1xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np1MB1Y7C7R3OpAqBUUmkMwk8mmZAzh+OJiOAb47hQCb16o5fA/xqB7KWnN/Z+CymSpwKEfz3MJOxhA1KWpElDttPUPJoCDFzRjRT+fTkbbODa8CFdytRfgzwt6ihXUmdas2WOOTudsf0+VAbHMv7+y54WvkW2MU1lDcck5QQMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJqcOMdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJqcOMdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5258C4CEF0;
	Tue, 12 Aug 2025 18:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024166;
	bh=UTuqIYkLt3YSUCUKMuLk2XwHURssXZDtj0IQ9q8c1xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJqcOMdkGhcYqdWqIr+n2HRK07QoWIoYU8iYBvncZAHOgMBXRjfUrLxIQu1FrIZXg
	 dSKzCfJ8E4t7zblltyrM1OcnTmBQyDSdK4r1HrUxQ5NFRishJVLvsfZ5R2GXyvky9A
	 Rsgvb7cH+aNYw7JV5E8ZECz/XfMtCknBaMiz4S8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tomas Glozar <tglozar@redhat.com>,
	Juri Lelli <jlelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	John Kacur <jkacur@redhat.com>,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 293/627] rv: Remove trailing whitespace from tracepoint string
Date: Tue, 12 Aug 2025 19:29:48 +0200
Message-ID: <20250812173430.455484242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 7b70ac4cad2b20eaf415276bbaa0d9df9abb428c ]

RV event tracepoints print a line with the format:
    "event_xyz: S0 x event -> S1 "
    "event_xyz: S1 x event -> S0 (final)"

While printing an event leading to a non-final state, the line
has a trailing white space (visible above before the closing ").

Adapt the format string not to print the trailing whitespace if we are
not printing "(final)".

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tomas Glozar <tglozar@redhat.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Link: https://lore.kernel.org/20250728135022.255578-3-gmonaco@redhat.com
Reviewed-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 7f904ff6e58d ("rv: Use strings in da monitors tracepoints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/rv/rv_trace.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/rv/rv_trace.h b/kernel/trace/rv/rv_trace.h
index 422b75f58891..18fa0e358a30 100644
--- a/kernel/trace/rv/rv_trace.h
+++ b/kernel/trace/rv/rv_trace.h
@@ -29,11 +29,11 @@ DECLARE_EVENT_CLASS(event_da_monitor,
 		__entry->final_state		= final_state;
 	),
 
-	TP_printk("%s x %s -> %s %s",
+	TP_printk("%s x %s -> %s%s",
 		__entry->state,
 		__entry->event,
 		__entry->next_state,
-		__entry->final_state ? "(final)" : "")
+		__entry->final_state ? " (final)" : "")
 );
 
 DECLARE_EVENT_CLASS(error_da_monitor,
@@ -90,12 +90,12 @@ DECLARE_EVENT_CLASS(event_da_monitor_id,
 		__entry->final_state		= final_state;
 	),
 
-	TP_printk("%d: %s x %s -> %s %s",
+	TP_printk("%d: %s x %s -> %s%s",
 		__entry->id,
 		__entry->state,
 		__entry->event,
 		__entry->next_state,
-		__entry->final_state ? "(final)" : "")
+		__entry->final_state ? " (final)" : "")
 );
 
 DECLARE_EVENT_CLASS(error_da_monitor_id,
-- 
2.39.5



