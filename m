Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831306;
	b=g1OXzL3wUH1nM34xqgUJKTHwxzV1lSCSx4FJWT3zCbXspbylvhYWqXgNQpabhUyYMroE
	 IaRMXV9iCMlBaomy6WQHQxgKA+vqLZ0jfYhT4kYDkl7xPxvTByuAXqquv1il/w94Y3/Nw
	 grvHr7HVk01jJOhZekEDA73V/taoeC1LRhn5pSLedH56jXpa2qEwlZnJp56RnEQhC0xiw
	 R70H0R/ApYvnNN0IP3Ae0Uns+FKXhEbzxOUxM3d9vxp0mXlMh9A6eLqRJMefV3Wo7RP1c
	 s2EQpVMC3LcFPUtLR3sPKrGiBrFnosBs/8Wc/wvO5iAhFNPf9pEpwTFGvJ+4Pz0kzAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iEoqogTst20l3WKmgX3/Lv++A1v7goWln2eSe9KiP1k=;
	b=TyoChQwRNb5XvKW7+LDZtyQV9DHufGF8EkX81uPWslxUYomOmeCofz4nwYcEDvs0BLxW
	 D0KmVyI7nsnUVOAbRn98OkxWjk7BGOAXwgYE2vcQLgVj/1BAOcRmPssUzEXb7X07cnsjN
	 WvSmtbNHk59ZCMqES+RX67Rh6AzjrxAWbzY3HEwx1RAw74TaqYw8/eQd6/bvqRoFke/um
	 mzqcTDOls/WVvjg6feib+NGAH+RyG4Mme/S0JgdPw1YYrlg8AyBh7N1qhYstAzuurWA05
	 COP/MqdDgCvR9L8yjl0Ab8sCitlA/2zRV22dDPPgQ4oDl0S83+qQK4SdYgQsmQmA0vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Fb7N7zu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1EF606B2F8;
	Wed,  4 Nov 2026 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Fb7N7zu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E211F000C1;
	Wed,  4 Nov 2026 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831305;
	bh=iEoqogTst20l3WKmgX3/Lv++A1v7goWln2eSe9KiP1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Fb7N7zutAp8zwa01YiP5rlwap1njJFl8ceqWC7j3aisF78LNdboFOW7lh+0xM4PF
	 iT6Hei3GZp6xAS368jX/wIU/pnXAom6E4SbrPn9UbZTVzgdLgEyIunJarQHEowF8b8
	 Cn4CjSwYiMfc848OoRJsK/XBuWvHZUc3nyUCkukY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0622/1005] tracing: Fix NULL dereference when copying keys for a field variable
Date: Wed,  4 Nov 2026 16:05:55 -0500
Message-ID: <20261104211101.236551980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit a0777b9e53157f1f6848a0fd0650f5465391ea81 ]

In event_hist_trigger_parse() where it needs to create actions like
"onmatch", it calls:

  event_hist_trigger_parse() {
    create_actions() {
      action_create() {
        trace_action_create() {
          trace_action_create_field_var() {
            create_field_var_hist()

Where create_field_var_hist() does a loop on the hist_data
representing the keys. The issue is, if the keys uses one of the
pseudo field types (like common_cpu), the hist_data field element
will have NULL for its field member causing a NULL pointer
dereference when accessing the key_field->field->name.

  # echo 'hist:keys=common_cpu:ts0=common_timestamp.usecs' > \
      events/sched/sched_waking/trigger
  # echo 'my_synth u64 lat; int prio' > synthetic_events
  # echo 'hist:keys=common_cpu:wakeup_lat=common_timestamp.usecs-$ts0:\
      onmatch(sched.sched_waking).my_synth($wakeup_lat,prio)' > \
      events/sched/sched_switch/trigger

  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:create_field_var_hist+0x771/0x1380
  Call Trace:
   trace_action_create_field_var+0x360/0x600
   trace_action_create+0x393/0xe80
   event_hist_trigger_parse+0x3e47/0x69e0
   trigger_process_regex+0x1a6/0x250
   event_trigger_write+0xce/0x160

Instead of accessing it directly, use the proper handler
expr_field_str() to get the name.

The three previous patches are prerequisites: without them a .buckets
key and a common_stacktrace key each render into a command that cannot
be parsed back.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914053443.981201-5-donggeunyoo.kernel@gmail.com
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 086a996c945b4..882e10e776fe4 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3096,7 +3096,7 @@ create_field_var_hist(struct hist_trigger_data *target_hist_data,
 		key_field = hist_data->fields[i];
 		if (!first)
 			seq_buf_putc(&s, ',');
-		seq_buf_puts(&s, key_field->field->name);
+		expr_field_str(key_field, &s);
 		first = false;
 	}
 
-- 
2.53.0



