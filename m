Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625342;
	b=5CWRqiped25aT15zddhAJtZ0o6rHLRrhZR6RU608cvZziC/wWaHMN4xPj5mYSo9/w+OW
	 hy5o8qJ2pA+J2retigGgyldAtCn2ZYKgpGU5lngg1o4CXjOy1rIFjtJnvRSAKnRMkaSuR
	 /D7O1dAewN0pzTeM7WSQcU7VXWT9LJMeJDnsWZwK/BJ2hmuchwdhwRnSZWSZlevetmJsW
	 NT8nEN/yQ0tJfrNKhy7ad1oQlJraZWSKhP4/tGSlksvMulQKK7WpuSOm4uEupy9U8DLFm
	 VWUVg9SOFaKB1Lp8Vl5+VJWU8+EXi3yU8bLMbmqbW8u8sjnmLYTGNkFeOLR8yNRUCyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oy/lstsQwBov9Iqtuw1nsxTE2SdNbpREqYnQEAlHm6U=;
	b=QFy2ifmnNj/XfhTwHSy14iNF7RD5lbkfd544b0uiK92f5D8mOon1J9h/WH4ZgyqsFJFO
	 IXJJV5492K4+CeYoQSAwgLlRF0M+yu/Jn3B9rf2XDg2E9L7LjDAgK3RQTyRTFDE59m309
	 hNHy1iCUSTgwVz7Qi6bxh75dINZR7yB6FwCzJMbovxqnb2drwl2eldUG4IjiceY66RdDx
	 b+O+/Pmjzi5ZpnKuSCjTx9/FWrBn8xxhpjpyn5OeJ+ByZRDmpdK0uMHAt0BHnWMftM8yl
	 o6IzMcz2tY9N1A7waNmVaMsHQYOiAQJ3u3hESauFIomakKNKUa/98jHsaPfxfq/n3rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmO7shwg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24C9606A31E;
	Wed, 25 Nov 2026 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmO7shwg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048381F000C4;
	Wed, 25 Nov 2026 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625342;
	bh=oy/lstsQwBov9Iqtuw1nsxTE2SdNbpREqYnQEAlHm6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmO7shwgY3uG7YI9VrCwYRXlwFUyJPpVU+PNT4bU5Oq3D5QXlviUnexELDQ0zXUrn
	 zaQ6f/ryu0y3jm7gVjQ7KQ62FQQjQqFQmrt8yj4wsXFrQbNsRgqkLMJeOcIkrfvQQ8
	 xJur5Xlg5/cMSkfBwFFFt/PCF87BT0QKZxVmiCtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 485/816] seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()
Date: Wed, 25 Nov 2026 15:33:53 +0100
Message-ID: <20261125143900.420301652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit a09fb764832dd7dbb9ccc38a9830f7294889c8ae ]

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
[ sashal: Dropped the new KUnit test hunk because the test file doesn't exist in this tree; the one-line fix in lib/seq_buf.c applied unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/seq_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index f3f3436d60a94..12082f042ff72 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -128,7 +128,7 @@ void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
 	}
 
 	/* No trailing LF */
-	if (start < s->buffer + s->len)
+	if (*start)
 		printk("%s%s\n", lvl, start);
 }
 EXPORT_SYMBOL_GPL(seq_buf_do_printk);
-- 
2.53.0



