Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215612;
	b=wBa5kpUdouuaXMXYdUVtaWb/OH1DN8x0K33s6QjoggCmvKcW3SwQlwC42cASCf5lYGpj
	 ya+uxIuUJGZdOzLUP+mK8kwGuXleywBFLOMJ/pUcmtr/DsQ5kwbyYfThu/5fgo+Ma1rPH
	 u65ePAO/i+JerVjFe46c/DU8yZ6sMMPb3R6k17cEfhDDLL3AmgDnpe5nJLHa/HNHVUNE+
	 m8ZRE+0pO2SAuwvfJzeIeYNn+wHUGDXYofYxm4hYv8ob4SRhEvxFggnRNnfCqPKdJFKtV
	 rc6ueex8nsuc3Wbgxza6xU9zEZTowFg9U8WUL6o3HWO16LMlg9jxb+d+/K9OUgSiQvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3VmFQAcrnBaCEzqjW5Fi38HOKsv0CgO5eYnTrKpEklg=;
	b=HK5dmiVCCU6sA/b1Bztu9WG+uK1978mkmofrxS/jXUs1OqJJhNgXfOgRVMHjG7XW/yDj
	 6mY1wrKHU+o6YVlnlRB7LCb28DJLYuQHV3nZRqrnAnaWIgmavoO++kX2qTM2ueCz1wAXT
	 wGM3VanG/f7ULU6c+rpNjbc7Sdz1UtMWDnmoVggP5TbEBFYwIrubCYs7pdrj5weS1dpn2
	 I/PHSJwr+FEz9U2My+Cjd8jMmPUqp0mZyjq7mn83EjBz9smlAlfhCRbc6fKH7PtLsezhh
	 1xjFTH6KHTjwnP1EJN6AfzrQ4a9ujT4SU+6veYIHDbZxgav9TfS3K39Uy2F0U9qYD3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtcdDaCx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28225606A31F;
	Wed, 28 Oct 2026 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtcdDaCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7F71F01828;
	Wed, 28 Oct 2026 19:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215612;
	bh=3VmFQAcrnBaCEzqjW5Fi38HOKsv0CgO5eYnTrKpEklg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtcdDaCxInkC6m0nVwq1bL/ub4XUSRVweUrACa1InzABVf5/VJrywbnUgZkzoAB57
	 tgpqIjkvKMcGL9kQ7eQtKoGHKd660z3qRdSb9E5MH9NytYQobQODwOLbJr3Bd51xBC
	 Ms7snKW27h2vomNph6UYJUOE+/G4M11gcqJc4BRo=
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
Subject: [PATCH 6.1 1269/1887] seq_buf: Add seq_buf_do_printk() helper
Date: Wed, 28 Oct 2026 17:56:05 +0100
Message-ID: <20261028170528.299363964@linuxfoundation.org>
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
Stable-dep-of: f07883450eb1 ("tracing: Bound synthetic-field strings with seq_buf")
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



