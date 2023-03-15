Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472F8538D
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 13:53:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F9EB1FD79;
	Wed, 15 Mar 2023 13:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678888395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MOPh0muXJMBra7JZNI3t/z2XlH5ZqBP5RrIbmuie1yI=;
	b=QKY7ReI4YqUdmQ7e0+BHWBqf9m7ixDyOjxCoGENb2xA+1wj7zrm7TjjNGEiobjrXHUVxKf
	v53hJZpSJX+rpnCBg7mAaf3z3f8Yim7fGJd9aL8fVK4WoJCxBzWUTw1Dsl/FN/k5G2FEEw
	E4xb1+MFU0eMEOGLtwSgV0hC1IMmwFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678888395;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MOPh0muXJMBra7JZNI3t/z2XlH5ZqBP5RrIbmuie1yI=;
	b=hfK1YuSXzjNyczsp8N+D3Am3mFL+dYrF8UhS3D3/wzfYSwo9B843Z8eGEzC2/Le+8zOIq+
	7n6wutSBx1+NMzAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B86A13A2F;
	Wed, 15 Mar 2023 13:53:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id qcwkAsvNEWSPNgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 15 Mar 2023 13:53:15 +0000
Message-ID: <3018fb77-68d0-fb67-2595-7c58c6cf7a76@suse.cz>
Date: Wed, 15 Mar 2023 14:53:14 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>,
 Mike Rapoport <mike.rapoport@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 netdev@vger.kernel.org, linux-doc@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Frederic Weisbecker <frederic@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mike Rapoport <rppt@kernel.org>,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Paolo Abeni <pabeni@redhat.com>,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <ZA2gofYkXRcJ8cLA@kernel.org> <20230313123147.6d28c47e@gandalf.local.home>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230313123147.6d28c47e@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/13/23 17:31, Steven Rostedt wrote:
> Just remove that comment. And you could even add:
> 
> Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")

Thanks for the analysis. Want to take the following patch to your tree or
should I make it part of the series?

----8<----
From 297a8c8fda98dc5499cfe0eac6ffabfb19d1b70f Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 15 Mar 2023 14:45:15 +0100
Subject: [PATCH] ring-buffer: remove obsolete comment for free_buffer_page()

The comment refers to mm/slob.o which is being removed. It comes from
commit ed56829cb319 ("ring_buffer: reset buffer page when freeing") and
according to Steven the borrowed code was a page mapcount and mapping
reset, which was later removed by commit e4c2ce82ca27 ("ring_buffer:
allocate buffer page pointer"). Thus the comment is not accurate anyway,
remove it.

Reported-by: Mike Rapoport <mike.rapoport@gmail.com>
Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 kernel/trace/ring_buffer.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index af50d931b020..c6f47b6cfd5f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -354,10 +354,6 @@ static void rb_init_page(struct buffer_data_page *bpage)
 	local_set(&bpage->commit, 0);
 }
 
-/*
- * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
- * this issue out.
- */
 static void free_buffer_page(struct buffer_page *bpage)
 {
 	free_page((unsigned long)bpage->page);
-- 
2.39.2



