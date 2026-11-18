Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056004;
	b=348mVJvs3JBO1vaYgoI/URQxUo8ex5s4xMZQPgQI8Noq2RRyHveAJT9VRgLTtGFDPqS5
	 aUvxzB9fS9zFb3yQGv0PaBhpzuMjujR57J2Y48Ph7vLHOT6n6AALhPn/vdarbG6NmiaB9
	 4Rg1OnM/u/C4pxFXfPuJPcsY/xPPB6izpTXf8iHB2vPB8h21Jju77xfAQWqojjWoO7/aU
	 L3Jv2a29hNXEkOkIa+ZNY+FkLOGr/x1LvSI18bj4SkxFnuxJd1PN/juLNbl6Dcdl+lalo
	 lKB0YlC/5Kbq4Fx4/bSgnvtISU0bMwoh3LiBmZJTiH09aeIz08D/eGwU9VK7rVUaObQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QKzl7okVbgyl+OM52JAJ0j8FlO3IH362OWmoJwQq/Qc=;
	b=DOa0OM/Ph1+htFMhYtvls8YHnC8ogl6Vo3pz5k4lgc6RkHwp7t1YIurtubjvhsUCxg1M
	 aHUJXbNRDiUsc6gMOw7fQaS+KCwrOBVXYxU/4eVyhrPJs+a1xoCMtOIGa0HSOdUQrCcrZ
	 GXYDK4F3yxZ8CJAbFXRin5cfrXOiKMkTG0tg9GB9lWNsV89JL59ewJADROWCD5mihmhqp
	 Xjdg+EDCvyMnUeBdDhUxQhsTpaTH+8lMBi8+5O+Cbutd/X2hSigICePrnaXZGCrdN0mx8
	 03BWSh1/7EKYVHgVX8q26k8sbHSJSXwUZs8tZ8hM2LcpOmJ6spFNNqlJBn0kTRrIHyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbYtyC9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D738C606A31C;
	Thu, 19 Nov 2026 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbYtyC9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED251F000C4;
	Thu, 19 Nov 2026 02:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056004;
	bh=QKzl7okVbgyl+OM52JAJ0j8FlO3IH362OWmoJwQq/Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbYtyC9mmUjekwXAUEkGwrxmCr25HvlYcatIcmCzjWrPZcuLOY9wt6t9r5s/+lul5
	 wZN2n3AnqBJ5n+JKhgxwnyA0YHqZiAGj2jwyurxOW4WwL2r8FdMpMH0e+Y5tnzXjeS
	 2XXYWyVRDPI6e7+N29mew2Xdlan99seBLB2/P7qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1833/2214] seq_buf: Add seq_buf_do_printk() helper
Date: Wed, 18 Nov 2026 15:58:29 +0100
Message-ID: <20261118150124.761720094@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 96928d9032a7c34f12a88df879665562bcebf59a ]

Sometimes we use seq_buf to format a string buffer, which
we then pass to printk(). However, in certain situations
the seq_buf string buffer can get too big, exceeding the
PRINTKRB_RECORD_MAX bytes limit, and causing printk() to
truncate the string.

Add a new seq_buf helper. This helper prints the seq_buf
string buffer line by line, using \n as a delimiter,
rather than passing the whole string buffer to printk()
at once.

Link: https://lkml.kernel.org/r/20230415100110.1419872-1-senozhatsky@chromium.org

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: fa291d6429eb ("PCI/P2PDMA: Safely terminate ACS redirect lists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h |  2 ++
 lib/seq_buf.c           | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 5b31c51479694..515d7fcb9634b 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -159,4 +159,6 @@ extern int
 seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
 #endif
 
+void seq_buf_do_printk(struct seq_buf *s, const char *lvl);
+
 #endif /* _LINUX_SEQ_BUF_H */
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 0a68f7aa85d67..45c450f423fa8 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -93,6 +93,38 @@ int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(seq_buf_printf);
 
+/**
+ * seq_buf_do_printk - printk seq_buf line by line
+ * @s: seq_buf descriptor
+ * @lvl: printk level
+ *
+ * printk()-s a multi-line sequential buffer line by line. The function
+ * makes sure that the buffer in @s is nul terminated and safe to read
+ * as a string.
+ */
+void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
+{
+	const char *start, *lf;
+
+	if (s->size == 0 || s->len == 0)
+		return;
+
+	seq_buf_terminate(s);
+
+	start = s->buffer;
+	while ((lf = strchr(start, '\n'))) {
+		int len = lf - start + 1;
+
+		printk("%s%.*s", lvl, len, start);
+		start = ++lf;
+	}
+
+	/* No trailing LF */
+	if (start < s->buffer + s->len)
+		printk("%s%s\n", lvl, start);
+}
+EXPORT_SYMBOL_GPL(seq_buf_do_printk);
+
 #ifdef CONFIG_BINARY_PRINTF
 /**
  * seq_buf_bprintf - Write the printf string from binary arguments
-- 
2.53.0



