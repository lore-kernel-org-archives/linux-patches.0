Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019630;
	b=fNtguvuhXHgua7Y4ho/LAyOvbZp16e8+rmS2zCC77jTygA1prl/QvwWOf15OSIQIifnM
	 +wBWnLSxVCfkSdP5XZqSy4nb6+88xhYGOFBlme5iMCLuaagjZbgAzXr+PYbfsRMIr+uJB
	 +Ab4ThVCvsZx1n9D926WbEJcTyzlKbQsdwTJOgNx51lL96nat2Q2+2Q9Ee8CAjtes3SQR
	 0Vc2Pt0KsXLetCrs2Q8EQZ6bvBb2tAq1hZGY9ALlyF1v0Lh33/dTNpA9GdCBKPw2J3xIZ
	 TWO4N2DrN//6jdN7k1sBb8/rntg6UCm/PA1O7lerDW6Ri0C5o/h891SgGOn7SXV3pfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6rk7GajjiTwTmD2iPbfSQnuetiV3tGsngHVfVjCDZE=;
	b=PrOqVjq+tJz2F1apeJ7ROqoViOyqYRf8495x2oxl2A7aG6I/xZpkk+VRncyR2tMCqxfr
	 UscUnCMMa5NGdF0An0EIc2Fd2It6embpxpUxNr5f6OexGhCBxC8OrlQeeOfLew7YPPgPo
	 17Dug+0BnrnBA9K0HE96iXC5lmxPHy2JklRr9JFQJm9ri30IKjRLJ8JVrUWzQmB+K2n7z
	 ldsLYWb6Yc3MYXAWctr5/p6hAoGkPUoA71EsqwsFoHPhc6TXWGIsQo6ux745g3GxaDRbw
	 5oXaNYLtQIXBbYU5yXyQ4FupUPMoszUubSvoThd9ZIJNfG1OOtFQkBtHaQbDrpUvwwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/3PBxS+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C35606A7C1;
	Wed, 18 Nov 2026 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/3PBxS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D34A1F000C4;
	Wed, 18 Nov 2026 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019629;
	bh=v6rk7GajjiTwTmD2iPbfSQnuetiV3tGsngHVfVjCDZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/3PBxS+Pe/EPOORhYtF0EITuPv3ezFYbmWk7KLZ7s67GecoK9+E7XUKFyop4P6aE
	 BFjHapuyLaoACLG85rJ9OfMY77aWufc5lDwIiJqgr0LeDL6r2AWG4jXhPBST9Jh338
	 Qx5XMsWZ5hF4FCDiNZlOlnOIaxegBF/gxD9dc1dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1614/2651] seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()
Date: Wed, 18 Nov 2026 15:47:34 +0100
Message-ID: <20261118150345.956067992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/seq_buf.c             |   2 +-
 lib/tests/seq_buf_kunit.c | 132 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index a92093f346daa..35a5964370b43 100644
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
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index eb466386bbefb..0934dfb602ff6 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -6,7 +6,9 @@
  */
 
 #include <kunit/test.h>
+#include <linux/console.h>
 #include <linux/seq_buf.h>
+#include <linux/string.h>
 
 static void seq_buf_init_test(struct kunit *test)
 {
@@ -216,6 +218,135 @@ static void seq_buf_putmem_hex_overflow_test(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
 }
 
+/*
+ * Counters for the console that seq_buf_do_printk_test() registers while it
+ * runs. Only records carrying the marker are counted, so unrelated kernel
+ * messages do not disturb them.
+ *
+ * An empty record carries nothing to recognize it by, so count one only
+ * where the flaw puts it: directly after a record of ours, with nothing in
+ * between. That still misreads a bare line feed printed by another CPU in
+ * exactly that gap, but no longer counts one printed at any point while the
+ * console happens to be registered.
+ */
+#define SEQ_BUF_PRINTK_MARKER	"sbdpkx"
+
+static unsigned int seq_buf_printk_marked;
+static unsigned int seq_buf_printk_empty;
+static bool seq_buf_printk_last_was_ours;
+
+static void seq_buf_printk_capture(struct console *con,
+				   const char *s, unsigned int count)
+{
+	const char *text = s;
+	const char *prefix;
+
+	/*
+	 * Skip what printk() puts in front of the message: a timestamp,
+	 * and the caller id as well under CONFIG_PRINTK_CALLER, so strip
+	 * every bracketed group rather than just the first.
+	 */
+	while (count && text[0] == '[') {
+		prefix = memchr(text, ']', count);
+		if (!prefix)
+			break;
+		count -= prefix + 1 - text;
+		text = prefix + 1;
+		if (count && text[0] == ' ') {
+			text++;
+			count--;
+		}
+	}
+
+	if (strnstr(text, SEQ_BUF_PRINTK_MARKER, count)) {
+		seq_buf_printk_marked++;
+		seq_buf_printk_last_was_ours = true;
+		return;
+	}
+
+	if (seq_buf_printk_last_was_ours &&
+	    (count == 0 || (count == 1 && text[0] == '\n')))
+		seq_buf_printk_empty++;
+
+	seq_buf_printk_last_was_ours = false;
+}
+
+static void seq_buf_printk_run(struct console *capture, struct seq_buf *s)
+{
+	seq_buf_printk_marked = 0;
+	seq_buf_printk_empty = 0;
+	seq_buf_printk_last_was_ours = false;
+
+	/*
+	 * register_console() will not take an unmatched console without
+	 * CON_ENABLED, and unregister_console() clears it, so set it on
+	 * every run to keep the test repeatable.
+	 */
+	capture->flags = CON_ENABLED;
+	register_console(capture);
+	seq_buf_do_printk(s, KERN_INFO);
+	unregister_console(capture);
+}
+
+static void seq_buf_do_printk_test(struct kunit *test)
+{
+	/*
+	 * A registered console is a global object: printk() reaches it
+	 * through the console list from any CPU, and the console code writes
+	 * back into it, so keep it out of this function's stack frame the
+	 * way every other console in the tree does.
+	 */
+	static struct console capture = {
+		.name = "sbufcap",
+		.write = seq_buf_printk_capture,
+		.index = -1,
+	};
+	DECLARE_SEQ_BUF(s, 8);
+	DECLARE_SEQ_BUF(t, 16);
+	DECLARE_SEQ_BUF(u, 8);
+
+	/*
+	 * Fill the buffer exactly, so that the NUL takes the place of the
+	 * last byte and the string ends with the line feed before it.
+	 */
+	seq_buf_puts(&s, SEQ_BUF_PRINTK_MARKER);
+	seq_buf_putc(&s, '\n');
+	seq_buf_putc(&s, '!');
+	KUNIT_ASSERT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_ASSERT_EQ(test, seq_buf_used(&s), 8);
+	KUNIT_ASSERT_EQ(test, strlen(seq_buf_str(&s)), 7);
+
+	seq_buf_printk_run(&capture, &s);
+
+	/* The one line that was written, and nothing after it. */
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 1);
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_empty, 0);
+
+	/* Check that lines without a trailing newline are shown. */
+	seq_buf_puts(&t, SEQ_BUF_PRINTK_MARKER "\n" SEQ_BUF_PRINTK_MARKER);
+	KUNIT_ASSERT_FALSE(test, seq_buf_has_overflowed(&t));
+
+	seq_buf_printk_run(&capture, &t);
+
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 2);
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_empty, 0);
+
+	/*
+	 * The buffer above was exactly full, where "len" equals the size. A
+	 * buffer that actually overflowed reaches the same bug by the other
+	 * route the old test had, with "len" one past the size.
+	 */
+	seq_buf_puts(&u, SEQ_BUF_PRINTK_MARKER "\n");
+	KUNIT_EXPECT_EQ(test, seq_buf_puts(&u, "yy"), -1);
+	KUNIT_ASSERT_TRUE(test, seq_buf_has_overflowed(&u));
+	KUNIT_ASSERT_EQ(test, u.len, u.size + 1);
+
+	seq_buf_printk_run(&capture, &u);
+
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 1);
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_empty, 0);
+}
+
 static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_init_test),
 	KUNIT_CASE(seq_buf_declare_test),
@@ -228,6 +359,7 @@ static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_get_buf_commit_test),
 	KUNIT_CASE(seq_buf_putmem_hex_test),
 	KUNIT_CASE(seq_buf_putmem_hex_overflow_test),
+	KUNIT_CASE(seq_buf_do_printk_test),
 	{}
 };
 
-- 
2.53.0



