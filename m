Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057089;
	b=mXHMtCtd5QYwuI0dDuPEd/D6Ac+MCDawkMN18ENK68ufx/tSm3t4Dp3zuJB8caJC8CKD
	 MD30qnAtpbTP601X4frWBECSLIbrFZDo74P5/xbVqyDWnMWwEXCgwWiOY9J5ThVIsdyvL
	 QsbR0UQqfKrHyY5eF98jWePd9VbgXLzm8i+y3eZzfpRwMms2UMCNfCJgloCB2y0kICXUo
	 Q9v8r6xGKe/c2eJ9HywRMR+7ikQGQ5fbyI3M9F09KfqzEgZUNofhFyN2ntD/6/0AMHoGD
	 jHQ8CJ9hyRfYHztCCml+P5TAZorW6Ny1BMPqo49xQBDa3VCaiJIELgtItxa/YWLsmDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApjKfpUtg+D8XtQ8LUKb0NdPNM5QeYh9upX9owTX5l0=;
	b=LRbBZHXWNNYIG7AD2El5X4wwU1eGO8xVfRwqJU+/P1A3vDCXAXAatTAUKqMQFPNhBVdZ
	 ZVBm+PDbT/y8ZoXkqtjuv43kNAOLA/qcb+ZlqhRubkK+SPbcsU8N9DCZFredC+1mGAVuO
	 Vqjaf6TfoPJ6dNecsJuGofugrQbZnCuoN9J+0DgqMj9sykkNeUgblXRW2I9skh+2Kuu1v
	 ZFnVpqzTlLB4OBc3mhWP0/j3h7jROu2LlzR8+7e24eZwKKkB+ME15ukLBK/kIZoG3RYqp
	 yGIKB6ufI9gr8XMcr4RFUsLARPL55KvSWihOL69ak4iU3a+ozRQa1Fu0s2+zYDGcWmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrMTmW2J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E9606A32F;
	Thu, 19 Nov 2026 02:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrMTmW2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6EE1F000C9;
	Thu, 19 Nov 2026 02:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057089;
	bh=ApjKfpUtg+D8XtQ8LUKb0NdPNM5QeYh9upX9owTX5l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrMTmW2JqyqerLNG8diShVewOtHqWY1nY5afHR2irLJ29T0Ow7qHzupjcC5LxzoeF
	 vJ6ey/sKsd/jPecN1liBBMdUQgRNSmFqulnGhToJHWU8DDxnU5q8+B6IC3yabNJZQG
	 H9ccyJ3ZrRiMUSQ/7bpNq0Ulil+Jk3JIBUYfX1T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 5.15 2213/2214] seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()
Date: Wed, 18 Nov 2026 16:04:49 +0100
Message-ID: <20261118150138.765559805@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

commit a09fb764832dd7dbb9ccc38a9830f7294889c8ae upstream.

seq_buf_do_printk() prints a buffer line by line, then prints whatever
follows the last newline. When a string has overflowed at exactly a
newline, an empty line is printed since the pointer hasn't reached the
overflow mark of the seq_buf. Switch to just check if the string is
already empty and only print if not.

The only caller is the memory cgroup OOM report, so this could only ever
add a blank line to a report whose statistics already did not fit.

Add a test that registers a console to count the records that
seq_buf_do_printk() emits. It counts the records carrying the test's
marker, and the records holding nothing but a line feed that arrive
after one, so that unrelated kernel messages do not disturb it. Both
states that reach the flaw are covered: exactly full, and overflowed.

Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0.

Fixes: 96928d9032a7c ("seq_buf: Add seq_buf_do_printk() helper")
Assisted-by: LLM
Link: https://patch.msgid.link/20261005155708.1471260-1-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/seq_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -118,7 +118,7 @@ void seq_buf_do_printk(struct seq_buf *s
 	}
 
 	/* No trailing LF */
-	if (start < s->buffer + s->len)
+	if (*start)
 		printk("%s%s\n", lvl, start);
 }
 EXPORT_SYMBOL_GPL(seq_buf_do_printk);


