Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212402;
	b=i8Vynbbyw+ms1AjYmwyuG3oEK4GHSvjxS0mo8+zj6ZQ7QZ98f2VCtWzHA9/oaZ2bBl1S
	 LQKA8zN+ty835F28FiM5Izi7+jIoWfyyNr20dBIWuEXIaPi0j7rZRD/tLXVWQUqAkP+QO
	 tX2zum5t5u8XHJm2LVAlxarQwxUhRGuil9ZAluvLK6/RCRJHLDl9YxiNFMJzzdwEHET6k
	 8YNiaovOVnIPLUWUHB9GTP0mVBO15tN/92Z9IXalCasykeAnEzGN2A5AZnuj0MGjI3nwX
	 gzhKCOwynwX9UxIpQDxmPdHYNr1YYEf/g9VhXSsMg4ONts62UEsA7JaLnZkMCEsATtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lyO+Lthi9LY6kv16BEf2YQCh+dJL/I6jBLVkhBoZ4FU=;
	b=MWeQ/Jh9LSBb4cVQ0eIrAg4pKYsJnE6FpMIHGI4pMocMDw6YMuTygjClpviuiX0EllBv
	 2RcEIVc2NcwzhchpcRzikNlcKIMQXtAPwllWR3mYf2L2haJ+wkg8KLSFNEpl54w9OG0/G
	 jaINF2zKHsfsRbN7KhUHKEnQNvGzdXKxTDyWXw66+AX6FtXMipHcQju/amhW7tywFM7jI
	 b3dj37nQNj4wEb1e8bvmIqkc6shPQETEUA6HzZxrqOSVI6QcVBbeY7tIQOdQ6/zMiSgB3
	 cqlvJ6EwuFA3UD1rEBeSKbcwGeNEz+XIHudAq2E4Brp6PuetyWxSP+DT28wFMDr0B4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3PSAKcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F076B606A325;
	Wed, 28 Oct 2026 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3PSAKcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E58A1F01825;
	Wed, 28 Oct 2026 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212401;
	bh=lyO+Lthi9LY6kv16BEf2YQCh+dJL/I6jBLVkhBoZ4FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3PSAKcg5f3bYrtzJKTH4az0fnJ/OqIj3Rl/URfWLWteHardsCykq0NRSmQpjGBG/
	 v417eLgEJNNtrmXcXn/DsJRxjsx+TyjJKKrXB+usXykZg6+q5Dj+2nb4ea0BwQ+KAy
	 sknyNAj0C6Fv/qqzgILrg2oHA7WeJYyoz3K93GWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0140/1887] tracing/user_events: Dont destroy fields when event removal fails
Date: Wed, 28 Oct 2026 17:37:16 +0100
Message-ID: <20261028170502.420552359@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 2deb753127d7b7035e893955c5e91875e767d1f8 ]

destroy_user_event() destroys the event's fields before attempting to
remove the trace event call. If user_event_set_call_visible() fails,
e.g. because the event is still enabled and trace_remove_event_call()
returns -EBUSY, the event is left registered with an irreversibly
destroyed field list. Any subsequent interaction with the event then
operates on an empty field list while it is still fully visible in
tracefs.

Move the field destruction after the call removal, and splice the
field list back onto the event when the removal fails so the event
remains in a consistent state.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260904115223.2976446-1-bsdhenrymartin@gmail.com
Fixes: 7f5a08c79df35 ("user_events: Add minimal support for trace_event into ftrace")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Adjusted context for the missing lockdep_assert_held(&event_mutex) in destroy_user_event(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index bff699fe9e712..6186474c027fa 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -430,10 +430,9 @@ static void user_event_destroy_validators(struct user_event *user)
 	}
 }
 
-static void user_event_destroy_fields(struct user_event *user)
+static void user_event_destroy_fields(struct list_head *head)
 {
 	struct ftrace_event_field *field, *next;
-	struct list_head *head = &user->fields;
 
 	list_for_each_entry_safe(field, next, head, link) {
 		list_del(&field->link);
@@ -821,15 +820,30 @@ static int user_event_set_call_visible(struct user_event *user, bool visible)
 
 static int destroy_user_event(struct user_event *user)
 {
+	LIST_HEAD(fields);
 	int ret = 0;
 
-	/* Must destroy fields before call removal */
-	user_event_destroy_fields(user);
+	/*
+	 * Detach the fields before removing the call. Removing the event
+	 * frees the field list memory (trace_destroy_fields() is run on
+	 * successful removal and kmem_cache_free()s the fields), but the
+	 * fields here are allocated and owned by user_events. Destroy
+	 * them separately once removal has succeeded.
+	 */
+	list_splice_init(&user->fields, &fields);
 
 	ret = user_event_set_call_visible(user, false);
 
-	if (ret)
+	if (ret) {
+		/*
+		 * Removal failed and the event stays registered, recover
+		 * the fields so it is left in a consistent state.
+		 */
+		list_splice(&fields, &user->fields);
 		return ret;
+	}
+
+	user_event_destroy_fields(&fields);
 
 	dyn_event_remove(&user->devent);
 
@@ -1360,7 +1374,7 @@ static int user_event_parse(struct user_event_group *group, char *name,
 put_user_lock:
 	mutex_unlock(&event_mutex);
 put_user:
-	user_event_destroy_fields(user);
+	user_event_destroy_fields(&user->fields);
 	user_event_destroy_validators(user);
 	kfree(user->call.print_fmt);
 	kfree(user);
-- 
2.53.0



