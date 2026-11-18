Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053509;
	b=5g7HzxXIWTDVE7AYR4Ev3f5RZOTXRI8/p85eXgcEnDqY3rVYBBqwv52yMlV546/gmJOG
	 nHxzfevtUU5jYmB9OiMiR86j6oSQhtw3H4SBYGHkRdku46jHQnmNWL5tEoxLRjmLJ4Jx2
	 kOepsmzwiENPyKcV6PTX7BzrLmpcd7ah88h48Oalmy41QGOYvAV1tC1N9GzSeONcNa8jc
	 8iJawBicGtCNyAQVy2kXNFNcXS3tsQ2HhEhk4ZfU5Q8DT1FDai51az3s1A/dNgSe4lpK/
	 UM/zUz1wlszW99jjt9OzYm4W1AHMoGNhY7wXnP9hlm7eUF31JGUW3p50OpS945IGUOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p/ZsVrQa6L8VeENPQPfvOcWz1lVqiFg8Uvopv2pipOM=;
	b=HfOMvlr4I44cceK/ejQmzT9vExLpSxiLl2iYEWw4/s9jEqasdq3zv570tO1FhcPGeX2+
	 C1fb54x6V6Eb0N9+tdIyas2TecErXOAjJU51g3O5deQ4wVJJ9ZO44kdf3obDw+ICQ+o2e
	 6O8+V+nsoR6t8wPJY3UBuy2I0HPZnJamN7+SszgjOPzRl5bLo1eE3rrQ/Q5cXXV5vFulM
	 dysqPcAl4FhjrMi0PIZfD65MTHQsGYbvgCOTdymjk2pIV/yyaSuzQRgzm3gEYkJcWac5V
	 1t+1eKNUtRW2YZUyKOXZZ7bSUiK579BOrob8LyD+1mVEHaCpjP3BZ15o0EW27cz3Bkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HEjMZb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDF7606A31C;
	Thu, 19 Nov 2026 01:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HEjMZb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113F71F000C4;
	Thu, 19 Nov 2026 01:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053509;
	bh=p/ZsVrQa6L8VeENPQPfvOcWz1lVqiFg8Uvopv2pipOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HEjMZb7FGKNKmZmcpa/Z7j3lxNdHYkbo63uV0biJFTK5EiGGZ9DGnDXIHqXO4wp2
	 CCP5F27Ykh70YIDLC2ehQsRs8nXiQ+vgEBmv4v7AEm9Z9vED87RjpzSobRgJgm37nW
	 aP8o96DiQ7EPibEM366vEsvWCE4xXV396+TO43KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0946/2214] tracing/histograms: Verify event_call identity when updating synth_event refcount
Date: Wed, 18 Nov 2026 15:43:42 +0100
Message-ID: <20261118150050.186471893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 3403d9bb27ebc3572bd048620746b4414e073bf9 ]

In event_hist_trigger_parse() and hist_unreg_all(), the histogram
registration and unregistration paths look up find_synth_event() using
trace_event_name(file->event_call) and adjust se->ref if a match is
found.

Because find_synth_event() only compares the event basename, registering
or removing a histogram on a non-synthetic trace event whose basename
matches a synthetic event erroneously modifies the synthetic event's
reference count.  If a histogram is registered on the non-synthetic
event before the synthetic event is created and removed afterwards,
se->ref is decremented without a matching increment, allowing the
synthetic event to be freed while an active histogram action still holds
a pointer to it.

Introduce find_synth_event_call() to verify that &se->call matches
file->event_call before adjusting se->ref.

Fixes: 4b147936fa50 ("tracing: Add support for 'synthetic' events")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261019120730.2342739-1-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[Lee: Context conflict in event_hist_trigger_func() - no functional change]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c  | 11 +++--------
 kernel/trace/trace_events_synth.c | 10 ++++++++++
 kernel/trace/trace_synth.h        |  1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 223b38f9ac0e4..c8e57b6e28fdb 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5797,7 +5797,6 @@ static void hist_unreg_all(struct trace_event_file *file)
 	struct event_trigger_data *test, *n;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 
 	lockdep_assert_held(&event_mutex);
 
@@ -5810,8 +5809,7 @@ static void hist_unreg_all(struct trace_event_file *file)
 			list_del_rcu(&test->list);
 			trace_event_trigger_enable_disable(file, 0);
 
-			se_name = trace_event_name(file->event_call);
-			se = find_synth_event(se_name);
+			se = find_synth_event_call(file->event_call);
 			if (se)
 				se->ref--;
 
@@ -5834,7 +5832,6 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 	struct event_trigger_ops *trigger_ops;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 	bool remove = false;
 	char *trigger, *p;
 	int ret = 0;
@@ -5931,8 +5928,7 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 		}
 
 		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
-		se_name = trace_event_name(file->event_call);
-		se = find_synth_event(se_name);
+		se = find_synth_event_call(file->event_call);
 		if (se)
 			se->ref--;
 		ret = 0;
@@ -5973,8 +5969,7 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 	if (ret)
 		goto out_unreg;
 
-	se_name = trace_event_name(file->event_call);
-	se = find_synth_event(se_name);
+	se = find_synth_event_call(file->event_call);
 	if (se)
 		se->ref++;
 	/* Just return zero, not the number of registered triggers */
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 62d146254f470..ba5647204d3e5 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -848,6 +848,16 @@ struct synth_event *find_synth_event(const char *name)
 	return NULL;
 }
 
+struct synth_event *find_synth_event_call(struct trace_event_call *call)
+{
+	struct synth_event *se;
+	const char *name;
+
+	name = trace_event_name(call);
+	se = find_synth_event(name);
+	return se && &se->call == call ? se : NULL;
+}
+
 static struct trace_event_fields synth_event_fields_array[] = {
 	{ .type = TRACE_FUNCTION_TYPE,
 	  .define_fields = synth_event_define_fields },
diff --git a/kernel/trace/trace_synth.h b/kernel/trace/trace_synth.h
index 43f6fb6078dbf..d4ebf01b70492 100644
--- a/kernel/trace/trace_synth.h
+++ b/kernel/trace/trace_synth.h
@@ -37,5 +37,6 @@ struct synth_event {
 };
 
 extern struct synth_event *find_synth_event(const char *name);
+extern struct synth_event *find_synth_event_call(struct trace_event_call *call);
 
 #endif /* __TRACE_SYNTH_H */
-- 
2.53.0



