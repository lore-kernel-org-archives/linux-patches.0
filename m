Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061461;
	b=lT1rNkws+RifqWcDxTRjSa8u7N05Pybt0YRBLD1GcP4PGm5XkcAe+oc/IwwelWuYnzoc
	 0h9sBKwy2K1dhSv0Kt6jvadC2MRV62H4XEZh4CQ2mMNkKgNundYskOmyZqAkIkcrlmZwh
	 6gFKokqfpoLDP+NNjx6iUDKuRvW0TX+pQVNQx9W3CDf5wxEUeikM+NWzV2vxRlSNFzVaf
	 3CUO+H0JA9DOuKg8LJH3K5qCQOeRViW9O2UgDF8GVJj0b3oC0eGo23EdYSnqSfI88OuG7
	 iZRd6Aae8LribnMCGFICNsVc99tzgpP2CcE7VUX6xchB8+S9RCg8xGc3wKC3sW8pfBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8gM4q3cGLl8ZUxcEhE6bii4ooeO2PUe9YdxDxZdDps4=;
	b=ASx/BlZsDmXUOyjEgXBfcelKyBE27FGFhQsHI8rGDSIMx7SC0Ho8OUYKLgRrMmh1ZUzn
	 BuRbLVpaRV3m3U9+LwAbc2Hej0XwJBedgxEJRGvWVD2WcOHbuh92jxCxQ844GAbxuobbA
	 npWNwkYpWNWuYW5pQ0L9hG+6BtM/X3TFIHXPeEAXF6WW4PMdPI4wKZueus7oGbyYzCUI5
	 sLLBdJ2HeYqlZQp2ew+zXH43Tx9iaGJ4W2LJs55ZbcafKq2jq5ErXE4I/uTNlhrHOdcwp
	 pEHC7NdmwdOHwSiGPvA7g83NPgDrCDONcXk/UElCGNKsvij1d+wtokqKuK6SfBhULFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMM+EqT1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D69B606A326;
	Sat,  7 Nov 2026 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMM+EqT1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E211F0089F;
	Sat,  7 Nov 2026 14:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061461;
	bh=8gM4q3cGLl8ZUxcEhE6bii4ooeO2PUe9YdxDxZdDps4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMM+EqT15oA2eTm0Ks/8VaP9MedMkhVVX+A2iDSC/59yZkVBeYSQkJHt1he5s29F2
	 IvWnX9W7FHaFV/3dt9qM2h5VRD9kd12am9X7cob5TZdfTXkgubns7ALRNsLMp/X/Y3
	 l78v5LHnHfNmFFT7UDzd3sAxPg96e4d51YJAAPq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0564/1536] tracing: Fix NULL dereference when copying keys for a field variable
Date: Sat,  7 Nov 2026 08:43:00 -0500
Message-ID: <20261107135013.423027805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cb2dcc7c9b762..171f3a13cd6b0 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3075,7 +3075,7 @@ create_field_var_hist(struct hist_trigger_data *target_hist_data,
 		key_field = hist_data->fields[i];
 		if (!first)
 			seq_buf_putc(&s, ',');
-		seq_buf_puts(&s, key_field->field->name);
+		expr_field_str(key_field, &s);
 		first = false;
 	}
 
-- 
2.53.0



