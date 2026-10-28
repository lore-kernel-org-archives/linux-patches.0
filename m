Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214323;
	b=InzrrtY6qQAxy9bxlM2Eg8WfYWJWukS+n+oRNXsEOwfy0umeCvA6enJdgw7z0hAKFS8u
	 nODc+5Jvn3UfceIZP+EgWEk06uIWDGgYY3k7vtxhcg5UEaw7TKJMJYTl0NEwij521t/Fa
	 2uWmmo44d7N8cXRkZBsTLZhmgVjeKWlAkb2Y+SgFKKZMIiEv/ZNUS8vy5gXghQNMqyWwO
	 IRFpRDkwdgL7cCtpz2nJKoAPDgkTR074PepVPNPrOiJ1NlnP1N3FYSXJa7mnorINdEuOW
	 VFbEyDnQ8p47s/bjv71Mj3+uq+g9Iq7RMtnwXhl0KiECx7rH526wimQnmafuF0Hmdew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dV235mNtpF1DtZ8sKKS77sPKO/CHA7joeHcY/AWQYVo=;
	b=BNI90AUpV1tmodkLf1AghapkWSEmVhvEZGqeB33QOQfveIcQisoNQVWVZsd5FD8+GZZY
	 2TmlvOzHiYa4/tGsZIliyAk3Bdomp5k3/YXJyXu3asWaAyMj2e0l1Tyv0HDUHd49l2HK3
	 +z9C9Y8mqENZyO/719l4Uf0PRfarJbeWST6GJoC+3VtsNdIERp5TRPr907gDNcyXn0p2C
	 iG781WPcoj17K7weGEo0bYKXo0uqJWLzSGgwYytIf2LA0dywpXF1raXH5sd9OkLN2dOxd
	 k44r+gd7PVStp3iv9X6BbiJeSw547+TlszsW6cDNH0rDum3m90SDCTwdZKEB51y2iOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eWAYhWG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72760606BFA1;
	Wed, 28 Oct 2026 19:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eWAYhWG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC11F01825;
	Wed, 28 Oct 2026 19:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214323;
	bh=dV235mNtpF1DtZ8sKKS77sPKO/CHA7joeHcY/AWQYVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWAYhWG40a2CfzijDXaubicmT0NDYSUvhIyuJAOK0qvyuGqBbeBsStVVsLsicHadw
	 5sPzT9Uze983mpmSIw+dJWLTMs++mEu/9hBlRP6lRKPO4ih58wZYE8pJGjPlRcLu5/
	 dpPzYX94Kat7LVwIe4VmWfnpSqEo+9OhJMQoh2vw=
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
Subject: [PATCH 6.1 0819/1887] rv: Use strings in da monitors tracepoints
Date: Wed, 28 Oct 2026 17:48:35 +0100
Message-ID: <20261028170518.062934474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 7f904ff6e58d398c4336f3c19c42b338324451f7 ]

Using DA monitors tracepoints with KASAN enabled triggers the following
warning:

 BUG: KASAN: global-out-of-bounds in do_trace_event_raw_event_event_da_monitor+0xd6/0x1a0
 Read of size 32 at addr ffffffffaada8980 by task ...
 Call Trace:
  <TASK>
 [...]
  do_trace_event_raw_event_event_da_monitor+0xd6/0x1a0
  ? __pfx_do_trace_event_raw_event_event_da_monitor+0x10/0x10
  ? trace_event_sncid+0x83/0x200
  trace_event_sncid+0x163/0x200
 [...]
 The buggy address belongs to the variable:
  automaton_snep+0x4e0/0x5e0

This is caused by the tracepoints reading 32 bytes __array instead of
__string from the automata definition. Such strings are literals and
reading 32 bytes ends up in out of bound memory accesses (e.g. the next
automaton's data in this case).
The error is harmless as, while printing the string, we stop at the null
terminator, but it should still be fixed.

Use the __string facilities while defining the tracepoints to avoid
reading out of bound memory.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tomas Glozar <tglozar@redhat.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Link: https://lore.kernel.org/20250728135022.255578-4-gmonaco@redhat.com
Fixes: 792575348ff7 ("rv/include: Add deterministic automata monitor definition via C macros")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rv.h | 76 +++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/trace/events/rv.h b/include/trace/events/rv.h
index 56592da9301c0..da213b91da330 100644
--- a/include/trace/events/rv.h
+++ b/include/trace/events/rv.h
@@ -16,23 +16,23 @@ DECLARE_EVENT_CLASS(event_da_monitor,
 	TP_ARGS(state, event, next_state, final_state),
 
 	TP_STRUCT__entry(
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
-		__array(	char,	next_state,	MAX_DA_NAME_LEN	)
-		__field(	bool,	final_state			)
+		__string(	state,		state		)
+		__string(	event,		event		)
+		__string(	next_state,	next_state	)
+		__field(	bool,		final_state	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		memcpy(__entry->next_state,	next_state,	MAX_DA_NAME_LEN);
-		__entry->final_state		= final_state;
+		__assign_str(state, state);
+		__assign_str(event, event);
+		__assign_str(next_state, next_state);
+		__entry->final_state = final_state;
 	),
 
 	TP_printk("%s x %s -> %s %s",
-		__entry->state,
-		__entry->event,
-		__entry->next_state,
+		__get_str(state),
+		__get_str(event),
+		__get_str(next_state),
 		__entry->final_state ? "(final)" : "")
 );
 
@@ -43,18 +43,18 @@ DECLARE_EVENT_CLASS(error_da_monitor,
 	TP_ARGS(state, event),
 
 	TP_STRUCT__entry(
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
+		__string(	state,	state	)
+		__string(	event,	event	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
+		__assign_str(state, state);
+		__assign_str(event, event);
 	),
 
 	TP_printk("event %s not expected in the state %s",
-		__entry->event,
-		__entry->state)
+		__get_str(event),
+		__get_str(state))
 );
 
 #ifdef CONFIG_RV_MON_WIP
@@ -76,26 +76,26 @@ DECLARE_EVENT_CLASS(event_da_monitor_id,
 	TP_ARGS(id, state, event, next_state, final_state),
 
 	TP_STRUCT__entry(
-		__field(	int,	id				)
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
-		__array(	char,	next_state,	MAX_DA_NAME_LEN	)
-		__field(	bool,	final_state			)
+		__field(	int,		id		)
+		__string(	state,		state		)
+		__string(	event,		event		)
+		__string(	next_state,	next_state	)
+		__field(	bool,		final_state	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		memcpy(__entry->next_state,	next_state,	MAX_DA_NAME_LEN);
-		__entry->id			= id;
-		__entry->final_state		= final_state;
+		__assign_str(state, state);
+		__assign_str(event, event);
+		__assign_str(next_state, next_state);
+		__entry->id		= id;
+		__entry->final_state	= final_state;
 	),
 
 	TP_printk("%d: %s x %s -> %s %s",
 		__entry->id,
-		__entry->state,
-		__entry->event,
-		__entry->next_state,
+		__get_str(state),
+		__get_str(event),
+		__get_str(next_state),
 		__entry->final_state ? "(final)" : "")
 );
 
@@ -106,21 +106,21 @@ DECLARE_EVENT_CLASS(error_da_monitor_id,
 	TP_ARGS(id, state, event),
 
 	TP_STRUCT__entry(
-		__field(	int,	id				)
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
+		__field(	int,	id	)
+		__string(	state,	state	)
+		__string(	event,	event	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		__entry->id			= id;
+		__assign_str(state, state);
+		__assign_str(event, event);
+		__entry->id	= id;
 	),
 
 	TP_printk("%d: event %s not expected in the state %s",
 		__entry->id,
-		__entry->event,
-		__entry->state)
+		__get_str(event),
+		__get_str(state))
 );
 
 #ifdef CONFIG_RV_MON_WWNR
-- 
2.53.0



