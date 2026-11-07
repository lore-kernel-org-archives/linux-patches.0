Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064918;
	b=lUocbVAT6RCk2hMIDZMoM4dQoDXIdhN1p/khrX2/qt7vDow1u6uc69zMhiUUdJ31QGkP
	 w5I94QOwL+j6u1/lN9xdK5ULHnnhUa/sZtJpVq2XCm/GDXM2AlRkD1IqKRaDU0ydZvTaZ
	 sMcJW82VDxQ6ZUzO7M4p26SnNjrc9jYBWTsAfr6xDzS6WDbEFABgv5toQGf2MF1mnac2d
	 6m+G7C6ZrqfViBPuFU10jNPCyLcgCy169H6bfHq9Sl+z/H1P3/vG3Z6Hu+V5oounpG1ps
	 EiZtxoj3OiSPaB6pr3sLSM6r2SyEMx9YRsaWu6E9ydYXQv/2Fgf/Om+mo0LfE3XY/gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WUGMSN4eurK0FXC5F2UXsh/PQemfTRfI1MmmhK4yLM=;
	b=k93x/AW278izq/Z5Tj1G+hOdAzu/RU4BkFrkMyXcHdjv0WIMvFo1Kdv9nL4vP3piHxGj
	 9A4h7m71+iU52VxQToHAmhhlBOi7NESu5UCiH+2qnssk06v0+MFVJnJI1VDxOWYtChOVW
	 pywzaEujrO7h4nM1zaz2u6k+mFAhN6BPvknZjqlJea9xEOhY6KmHw5QPlCC+peQQZQbrX
	 O/7wBOT3ucFANpsp4p3HyRmor//YhVUrWqBqjCm9mV2yWoKqD0Avsc8ICzXN2QgrjhXEK
	 mKJcRNX+7ixZeqh0AFCK6TPOe290lrLAjxl++QSwMic0abUDg+tYbet0wpbJDVdYmdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5mAXaOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBA0606A33E;
	Sat,  7 Nov 2026 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5mAXaOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929DC1F0089F;
	Sat,  7 Nov 2026 15:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064917;
	bh=9WUGMSN4eurK0FXC5F2UXsh/PQemfTRfI1MmmhK4yLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5mAXaOpsmG59IPB74eQF8B/N6zkE0IOIUk3E0iLWLVok0Lg83vovm4cCZjmellj/
	 HO4Sfgjjm2izxWNoYr6hKZTl3N0PE+XECtPjwlIx1cDM6t6n2g/tzfOLI6grWMQiXo
	 nZughOhPgx9siuZ/YWacqYmr2/A6dv5toQ0ElEQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0816/1257] ring-buffer: Take cpus_read_lock() when changing the subbuf order
Date: Sat,  7 Nov 2026 08:51:52 -0500
Message-ID: <20261107135001.882491202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 453d0f47b174cac387af48d303c503b84f82212e ]

A CPU coming online for the first time gets its per CPU buffer allocated
by trace_rb_cpu_prepare(), which then adds it to buffer->cpumask. If that
happens while ring_buffer_subbuf_order_set() is running, the CPU shows up
after the allocation loop and the install loop walks it with an empty
new_pages list, corrupting the buffer.

Take cpus_read_lock() as ring_buffer_resize() does.

Cc: stable@vger.kernel.org
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Link: https://patch.msgid.link/20260916192628.274136-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9c4e40847e430..1a1219b6d0fc0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7466,6 +7466,8 @@ int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order)
 	if (psize > RB_WRITE_MASK + 1)
 		return -EINVAL;
 
+	guard(cpus_read_lock)();
+
 	/* prevent another thread from changing buffer sizes */
 	guard(mutex)(&buffer->mutex);
 
-- 
2.53.0



