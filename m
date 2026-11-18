Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056007;
	b=LUyyq5X11FPm5pSTq0guGXbwkOS+2i/2MGvXCerS12t28w43wRvq286cPtoMZ8seHhOC
	 U56xTecnV2jv4HdZWIIBCFupgtPHK9kusiCOKHvBY+AcewVI+Cb29TDc2MZCk/CgemcsH
	 fVo2XM4THeZ1QJILKf6JSq8lTd2baw8FpqzRsA0+9TMW9Ro17cccbruiwp4L3IDNiWJcS
	 TvIjZTpG59EX/9L9ArDry5wA73qxK6D69xc7fcr44a+pGmHo9W3bksRhAgd74nJsxWzaG
	 2Jpep+UCqP7lEYHnqgPtOclGDjM5heR/IdLTzfnQg0Y0a63y5WMUQLg2etrFnvfoTAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hDce0yAlNIEgLKMYCMF0679tv/vGIimr6em+aWprPY=;
	b=NhdSHytXO/j9h1UC25uifK2wSYO10v+T0nitPoyahW8wKyrT93rWWsJkmTZdpRefRuFj
	 xlncVkWtczc4lZ6q72v82FbGl13t3kRoS9rDNtoY+m2ZUib5rgB4eyc/dFGwchU72+6Vc
	 19xLGRWG1lmPdA8SIs1/wnuIWbRUyP/GNByfhGyWecemKQjqWbaxc/AKQkHreKdVgKps+
	 xTbIq+QdP7zHG7OTKyGRdcfm8ZHkuh80FF0LgLDarMObHLPWXf+GDctzbXASUj/2pGzy7
	 kT57BJyHLoJ7sM3bNoRY09Uo+qwbMqP8s0vW5NrVhe7nlJ2wINhBrazPHgLEv5JNMqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIFmqgU2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC45606A325;
	Thu, 19 Nov 2026 02:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIFmqgU2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956571F000C4;
	Thu, 19 Nov 2026 02:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056007;
	bh=4hDce0yAlNIEgLKMYCMF0679tv/vGIimr6em+aWprPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIFmqgU2SDV0R+/hCg/gGx9e63WowdtjjxoPymu4vFTaOaxWGNltoYo1VmTLTWwDZ
	 beOlMcoqfiPqByutRaZH5BeBCpvCZgEbMOMTcQiunZk8EvQ2/2Rmg/CZYd97N7OOXk
	 YTRIjpNKTm4+RKgOSYcv5f/5jkaH8BT8bnoCE/l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1834/2214] tracing: Move readpos from seq_buf to trace_seq
Date: Wed, 18 Nov 2026 15:58:30 +0100
Message-ID: <20261118150124.806044422@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit d0ed46b60396cfa7e0056f55e1ce0b43c7db57b6 ]

To make seq_buf more lightweight as a string buf, move the readpos member
from seq_buf to its container, trace_seq.  That puts the responsibility
of maintaining the readpos entirely in the tracing code.  If some future
users want to package up the readpos with a seq_buf, we can define a
new struct then.

Link: https://lore.kernel.org/linux-trace-kernel/20231020033545.2587554-2-willy@infradead.org

Cc: Kees Cook <keescook@chromium.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: fa291d6429eb ("PCI/P2PDMA: Safely terminate ACS redirect lists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h   |  5 +----
 include/linux/trace_seq.h |  2 ++
 kernel/trace/trace.c      | 10 +++++-----
 kernel/trace/trace_seq.c  |  6 +++++-
 lib/seq_buf.c             | 22 ++++++++++------------
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 515d7fcb9634b..a0fb013cebdf2 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -14,19 +14,16 @@
  * @buffer:	pointer to the buffer
  * @size:	size of the buffer
  * @len:	the amount of data inside the buffer
- * @readpos:	The next position to read in the buffer.
  */
 struct seq_buf {
 	char			*buffer;
 	size_t			size;
 	size_t			len;
-	loff_t			readpos;
 };
 
 static inline void seq_buf_clear(struct seq_buf *s)
 {
 	s->len = 0;
-	s->readpos = 0;
 }
 
 static inline void
@@ -143,7 +140,7 @@ extern __printf(2, 0)
 int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
 extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
 extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
-			   int cnt);
+			   size_t start, int cnt);
 extern int seq_buf_puts(struct seq_buf *s, const char *str);
 extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
 extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index c230cbd25aee8..93dc6ea8d0020 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -14,6 +14,7 @@
 struct trace_seq {
 	char			buffer[PAGE_SIZE];
 	struct seq_buf		seq;
+	size_t			readpos;
 	int			full;
 };
 
@@ -22,6 +23,7 @@ trace_seq_init(struct trace_seq *s)
 {
 	seq_buf_init(&s->seq, s->buffer, PAGE_SIZE);
 	s->full = 0;
+	s->readpos = 0;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 151348435861c..73c0a0c9ff977 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1675,15 +1675,15 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
 
-	if (trace_seq_used(s) <= s->seq.readpos)
+	if (trace_seq_used(s) <= s->readpos)
 		return -EBUSY;
 
-	len = trace_seq_used(s) - s->seq.readpos;
+	len = trace_seq_used(s) - s->readpos;
 	if (cnt > len)
 		cnt = len;
-	memcpy(buf, s->buffer + s->seq.readpos, cnt);
+	memcpy(buf, s->buffer + s->readpos, cnt);
 
-	s->seq.readpos += cnt;
+	s->readpos += cnt;
 	return cnt;
 }
 
@@ -6907,7 +6907,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (iter->seq.seq.readpos >= trace_seq_used(&iter->seq))
+	if (iter->seq.readpos >= trace_seq_used(&iter->seq))
 		trace_seq_init(&iter->seq);
 
 	/*
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 9c90b3a7dce2c..6e6faeb542af5 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -369,8 +369,12 @@ EXPORT_SYMBOL_GPL(trace_seq_path);
  */
 int trace_seq_to_user(struct trace_seq *s, char __user *ubuf, int cnt)
 {
+	int ret;
 	__trace_seq_init(s);
-	return seq_buf_to_user(&s->seq, ubuf, cnt);
+	ret = seq_buf_to_user(&s->seq, ubuf, s->readpos, cnt);
+	if (ret > 0)
+		s->readpos += ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_to_user);
 
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 45c450f423fa8..b7477aefff537 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -324,23 +324,24 @@ int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
  * seq_buf_to_user - copy the sequence buffer to user space
  * @s: seq_buf descriptor
  * @ubuf: The userspace memory location to copy to
+ * @start: The first byte in the buffer to copy
  * @cnt: The amount to copy
  *
  * Copies the sequence buffer into the userspace memory pointed to
- * by @ubuf. It starts from the last read position (@s->readpos)
- * and writes up to @cnt characters or till it reaches the end of
- * the content in the buffer (@s->len), which ever comes first.
+ * by @ubuf. It starts from @start and writes up to @cnt characters
+ * or until it reaches the end of the content in the buffer (@s->len),
+ * whichever comes first.
  *
  * On success, it returns a positive number of the number of bytes
  * it copied.
  *
  * On failure it returns -EBUSY if all of the content in the
  * sequence has been already read, which includes nothing in the
- * sequence (@s->len == @s->readpos).
+ * sequence (@s->len == @start).
  *
  * Returns -EFAULT if the copy to userspace fails.
  */
-int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
+int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, size_t start, int cnt)
 {
 	int len;
 	int ret;
@@ -350,20 +351,17 @@ int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
 
 	len = seq_buf_used(s);
 
-	if (len <= s->readpos)
+	if (len <= start)
 		return -EBUSY;
 
-	len -= s->readpos;
+	len -= start;
 	if (cnt > len)
 		cnt = len;
-	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	ret = copy_to_user(ubuf, s->buffer + start, cnt);
 	if (ret == cnt)
 		return -EFAULT;
 
-	cnt -= ret;
-
-	s->readpos += cnt;
-	return cnt;
+	return cnt - ret;
 }
 
 /**
-- 
2.53.0



