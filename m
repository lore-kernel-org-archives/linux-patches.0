Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056010;
	b=oCV+6ReJGg5gziphFKF4oEB/Qu0EKIrDhdPX2Pg46AGlEfqCCAtoKbnmZDjW1UZuBPpl
	 0qI68qmULnbCKdvtWZnRUxJVkyHPh3WwNwSJLbvX6jnsvYVh7t3b6CjGz4b/wOcM8Ew3j
	 GSz1beAuEGLbJwJdg/c8flCcFyyyLp8qYkqTisP2U7kFXXpw6h/P5ahx75TLnmCxrKV1c
	 w+JvAqiJ3WTbcRXKp6MnwZSP71PubBIsdogexPM9o0Ybw7vGo/rYma6KHmIQQPN0nH3GR
	 ybeTKqGehaAm0fYfke/lERR9zyaiCXOmqqODr3Jr3N/InVvMsnAOo1XBTcxlUP4dT8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lz0UMRo5eUQwDWmgPitH0ayldRbSh5/5Pi0WMhKYUXE=;
	b=hZQt9CRFpdtZS/jTs+l4tC17zWY/7FsJCnUHrTBUBbFBUzFgE4CTSHBnWx5NiwqYdI1L
	 VNhs6Oi/ZJwKtO8lXVFLQOb8F1Ezxp/DFz5O1i5Wrua72cyJAXy1c+INuAIDI+YXglvmk
	 UZJwmAH1TiYF/SgD4efqWtfklnP3QPFFWlIqYUbSNtZZpeqbY+zGlejB/q1dUiGzZjenv
	 dIvy/1pB6AkcziLgvJgS/abllUP+p5rYtOHmU+fHpkGloleEDb9aIX9YczPFcRDX7bpEz
	 I3zTrdBfjrGL2IOrQnpMfm3PcLdtlclh7oa5UtRSwQ0/GZPe3VyjWZItsrXEdVVVTvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRKOsViT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62312606A31C;
	Thu, 19 Nov 2026 02:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRKOsViT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478E21F000C4;
	Thu, 19 Nov 2026 02:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056010;
	bh=Lz0UMRo5eUQwDWmgPitH0ayldRbSh5/5Pi0WMhKYUXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRKOsViTaeJdq2rUD/J2VcIqntSEmLkkcLdN6/X4etNf1DMhe6oQT5WDEGpgzgxOR
	 TxkY6NH48UTdeF3m+oObSzMgQmHPWqlg4AX3M46Te++cRKUEfgi/6I9A955s/NxFPk
	 VH113yIdcDuWt7mcVahDljfXu7PHAeGgG85S2uK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Justin Stitt <justinstitt@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Yun Zhou <yun.zhou@windriver.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Kees Cook <keescook@chromium.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1835/2214] seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()
Date: Wed, 18 Nov 2026 15:58:31 +0100
Message-ID: <20261118150124.840704105@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit dcc4e5728eeaeda84878ca0018758cff1abfca21 ]

Solve two ergonomic issues with struct seq_buf;

1) Too much boilerplate is required to initialize:

	struct seq_buf s;
	char buf[32];

	seq_buf_init(s, buf, sizeof(buf));

Instead, we can build this directly on the stack. Provide
DECLARE_SEQ_BUF() macro to do this:

	DECLARE_SEQ_BUF(s, 32);

2) %NUL termination is fragile and requires 2 steps to get a valid
   C String (and is a layering violation exposing the "internals" of
   seq_buf):

	seq_buf_terminate(s);
	do_something(s->buffer);

Instead, we can just return s->buffer directly after terminating it in
the refactored seq_buf_terminate(), now known as seq_buf_str():

	do_something(seq_buf_str(s));

Link: https://lore.kernel.org/linux-trace-kernel/20231027155634.make.260-kees@kernel.org
Link: https://lore.kernel.org/linux-trace-kernel/20231026194033.it.702-kees@kernel.org/

Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yun Zhou <yun.zhou@windriver.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: fa291d6429eb ("PCI/P2PDMA: Safely terminate ACS redirect lists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h | 21 +++++++++++++++++----
 kernel/trace/trace.c    | 11 +----------
 lib/seq_buf.c           |  4 +---
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index a0fb013cebdf2..d9db59f420a49 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -21,9 +21,18 @@ struct seq_buf {
 	size_t			len;
 };
 
+#define DECLARE_SEQ_BUF(NAME, SIZE)			\
+	char __ ## NAME ## _buffer[SIZE] = "";		\
+	struct seq_buf NAME = {				\
+		.buffer = &__ ## NAME ## _buffer,	\
+		.size = SIZE,				\
+	}
+
 static inline void seq_buf_clear(struct seq_buf *s)
 {
 	s->len = 0;
+	if (s->size)
+		s->buffer[0] = '\0';
 }
 
 static inline void
@@ -69,8 +78,8 @@ static inline unsigned int seq_buf_used(struct seq_buf *s)
 }
 
 /**
- * seq_buf_terminate - Make sure buffer is nul terminated
- * @s: the seq_buf descriptor to terminate.
+ * seq_buf_str - get %NUL-terminated C string from seq_buf
+ * @s: the seq_buf handle
  *
  * This makes sure that the buffer in @s is nul terminated and
  * safe to read as a string.
@@ -81,16 +90,20 @@ static inline unsigned int seq_buf_used(struct seq_buf *s)
  *
  * After this function is called, s->buffer is safe to use
  * in string operations.
+ *
+ * Returns @s->buf after making sure it is terminated.
  */
-static inline void seq_buf_terminate(struct seq_buf *s)
+static inline const char *seq_buf_str(struct seq_buf *s)
 {
 	if (WARN_ON(s->size == 0))
-		return;
+		return "";
 
 	if (seq_buf_buffer_left(s))
 		s->buffer[s->len] = 0;
 	else
 		s->buffer[s->size - 1] = 0;
+
+	return s->buffer;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 73c0a0c9ff977..6d296ed08d6d3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3716,15 +3716,6 @@ static bool trace_safe_str(struct trace_iterator *iter, const char *str,
 	return false;
 }
 
-static const char *show_buffer(struct trace_seq *s)
-{
-	struct seq_buf *seq = &s->seq;
-
-	seq_buf_terminate(seq);
-
-	return seq->buffer;
-}
-
 static DEFINE_STATIC_KEY_FALSE(trace_no_verify);
 
 static int test_can_verify_check(const char *fmt, ...)
@@ -3864,7 +3855,7 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		 */
 		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
 			      "fmt: '%s' current_buffer: '%s'",
-			      fmt, show_buffer(&iter->seq))) {
+			      fmt, seq_buf_str(&iter->seq.seq))) {
 			int ret;
 
 			/* Try to safely read the string */
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index b7477aefff537..23518f77ea9c5 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -109,9 +109,7 @@ void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
 	if (s->size == 0 || s->len == 0)
 		return;
 
-	seq_buf_terminate(s);
-
-	start = s->buffer;
+	start = seq_buf_str(s);
 	while ((lf = strchr(start, '\n'))) {
 		int len = lf - start + 1;
 
-- 
2.53.0



