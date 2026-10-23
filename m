Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774695;
	b=G258J5bMO7JJg38PaGa/iaU5tn/XVr1Y2aqGIeSGgsyBWcSTVeWFToZIIwsWV4fvZHRb
	 6eF10nYazoW4Y/SKpF0zytiBRLQdmK1+82gi6ei65fYJepW+MiAv0Gp36i8CgZ4Fgnd+1
	 cSetZCi7hR2oTOreuTbTOjx9XEDwe0fZ6kmfiN6H63VlOsU6XJHePUliNTYyeRj46aps+
	 N3mNW9RwOn4RgiN/MLXbgINcpNa9XHk2Mp/P4FXK6+xeODzYpQvvU2HQavojf9U3tTpUM
	 HXAnKisl8htFsokPHKitofp+azWS3wRscLnGaiHa1NyPk+hGbeLmAvKbB3AHJqHtJCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=arjfsddaGsNquYVQI75TxBpBkpIhfgw0nKEwu48blj4=;
	b=fWQsbyXinm7XKw6B8m9R3MnXopu6cdASNlQruP/1hA1+37ZVeETguRT6i7UOmFfGNWON
	 6GFHv8GoKfCTCeZXq2IbdwgjkwRL1AeuZ94SS13BRlP80viMNPrg6URV8B961ZbxtCa4g
	 FE+vIyJjSnozjipDCqdpT8/Wt9cX/X0dUW6ZYJDQCnov/mRrH0WzFomZkCAQKJz9IemYo
	 9e2Yy9fgyjGoksfIEkMo8lwMB84vMiwlmfTLWt2L+J8oix6cm7XC/jEWj+e1KPGMnRfs4
	 dNSpi3HicwxnYBEUt+gVPNm1QIba/CvR+CrmH4mo0JjPEiIBdzltOUAD6xTbL5WDBFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xh0MWi3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FBA606A31B;
	Fri, 23 Oct 2026 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xh0MWi3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5331B1F01825;
	Fri, 23 Oct 2026 16:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774694;
	bh=arjfsddaGsNquYVQI75TxBpBkpIhfgw0nKEwu48blj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xh0MWi3D0WS7bvCC9PgVSYu0GQruhobfktF6NgGO3mh8/h53aZPQxKOuRj7uq3zFF
	 Cqbq4Hqmk1xl43FXAfY2iYyDuj3HL+6fzWjQ/Xe1m62+Rh11fzYgD9yHFLkBLmTjxg
	 QxXJdTkF+ZGUUF0oGtBiTj5Af3uDG9zZOBkxM+U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 090/242] ring-buffer: Use subbuf_order in available memory estimation
Date: Fri, 23 Oct 2026 18:38:52 +0200
Message-ID: <20261023163715.906838323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 13d530f2daeda9493f4d07ddc5ca13e21318fbeb ]

To avoid failing in the middle of an allocation of a ring-buffer,
__rb_allocate_pages() looks at the available memory estimation with
si_mem_available(). Use the subbuffer order with this estimation to fail
early if necessary for ring-buffers with an order > 0.

Link: https://patch.msgid.link/20261013102047.1488347-3-vdonnefort@google.com
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 4c0141d8e0622..6a3b4da37fc2e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2422,6 +2422,7 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		long nr_pages, struct list_head *pages)
 {
 	struct trace_buffer *buffer = cpu_buffer->buffer;
+	unsigned int subbuf_order = buffer->subbuf_order;
 	struct ring_buffer_cpu_meta *meta = NULL;
 	struct buffer_page *bpage, *tmp;
 	struct ring_buffer_desc *desc = NULL;
@@ -2443,7 +2444,7 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		 * not going to succeed.
 		 */
 		i = si_mem_available();
-		if (i < nr_pages)
+		if (i < (nr_pages << subbuf_order))
 			return -ENOMEM;
 
 		user_thread = current->mm != NULL;
@@ -2496,12 +2497,11 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			bpage->id = i + 1;
 			cpu_buffer->subbuf_ids[i + 1] = bpage;
 		} else {
-			bpage->page = alloc_cpu_data(cpu_buffer->cpu,
-						     cpu_buffer->buffer->subbuf_order);
+			bpage->page = alloc_cpu_data(cpu_buffer->cpu, subbuf_order);
 			if (!bpage->page)
 				goto free_pages;
 		}
-		bpage->order = cpu_buffer->buffer->subbuf_order;
+		bpage->order = subbuf_order;
 
 		if (user_thread && fatal_signal_pending(current))
 			goto free_pages;
-- 
2.53.0



