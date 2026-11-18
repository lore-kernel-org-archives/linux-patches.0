Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026146;
	b=tLCqladMS7a4umqPzg3rpzSmAXE1BW02uD50bOsp5Lu3XOWDI3FBO8P5Pxfsr/umjB6S
	 TFKMeoS7XZDe8blzOdZnGxJhXIKIK0EjN9lC3fcr4rKzxopi1WZ1O8mlupqPvD7Q+RPbF
	 K2D//6Q27b7zmaSvPCfm2W5VI49phkKmy3ZWhK5VDxvB/Ts/WK9Q6KZ87gBKsYXo9+K93
	 f4S1DToiYYfLI6EQxu63O3xxBlXlVJeGHQ6pdYym/Bjy/PM10YftXyyiyvTZN8MA6DHuF
	 yXNDt90os7E1NkMpCAKb48OB5m7IGL46G1Ip/nB7M09Rd5tZ75wwfmwvzeMeQkF3pWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s1gnT2lFsCcWxhy8cmVOSrF6dcymL5iCxvIqjwtIRO4=;
	b=nVccAdQncYKJJb0FrGsPaNYhSWXm/YChDvGkdLxp0yYaUDVSvABI8p12KiIptscD6i7e
	 BxhFWK1bPETg/LxbSPh+2xp9qv+0Zp5bVwp2PlbXyEOu0PPGi/dNJ4jN43CkOyISVh3S1
	 Pn7xFjmdt900oMgUexCMaCdiuPkKRsb3wX8V+qGbr/C21RPM3wA1d7Bt60V0umvf08wnN
	 crcRgwlETmdSsEYP1aFupiKsCDHBahYvYgsixUT1FXD82zMM38u9u9fHey2qWGu6SfACr
	 jK3S0/qJA9GmBzp5ZfiEKRMnro20kwXOqA06SJPOfVD/bXw9BL/fEb5yV7nYYuFBtaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VeRaSofq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93CF606A325;
	Wed, 18 Nov 2026 18:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VeRaSofq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F7C1F000C4;
	Wed, 18 Nov 2026 18:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026146;
	bh=s1gnT2lFsCcWxhy8cmVOSrF6dcymL5iCxvIqjwtIRO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeRaSofqAx+XdocxGeNE+1q23aObiU1980rLo1meXP0o5LAFIXLScOFcKzzVg4dl7
	 /3nhlphUR+PoaYh7a2AAM29flCxXjdOmIlevH/dlzQMNRdV5I+D31vmLDAGE8Lpxq9
	 WP0g/QEDiRxikKXItvBPfSuE71kLQ/jqUeUfDPJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Gow <david@davidgow.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1329/2151] seq_buf: Export seq_buf_putmem_hex() and add KUnit tests
Date: Wed, 18 Nov 2026 15:51:04 +0100
Message-ID: <20261118150210.485364473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit ae3197ee07cc8ec66261d891b2b5bf3879e7b852 ]

The seq_buf KUnit suite does not exercise seq_buf_putmem_hex().

Add one test for the len > 8 chunking path and one overflow test
where a later chunk no longer fits in the buffer.

Export seq_buf_putmem_hex() as well so SEQ_BUF_KUNIT_TEST=m links
cleanly. Without the export, modpost reports seq_buf_putmem_hex as
undefined when seq_buf_kunit is built as a module.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Gow <david@davidgow.net>
Link: https://patch.msgid.link/20260408202351.21829-1-shuvampandey1@gmail.com
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Stable-dep-of: a09fb764832d ("seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/seq_buf.c             |  1 +
 lib/tests/seq_buf_kunit.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index f3f3436d60a94..b59488fa8135c 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -298,6 +298,7 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(seq_buf_putmem_hex);
 
 /**
  * seq_buf_path - copy a path into the sequence buffer
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index 8a01579a978e6..eb466386bbefb 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -184,6 +184,38 @@ static void seq_buf_get_buf_commit_test(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
 }
 
+static void seq_buf_putmem_hex_test(struct kunit *test)
+{
+	DECLARE_SEQ_BUF(s, 24);
+	const u8 data[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
+#ifdef __BIG_ENDIAN
+	const char *expected = "0001020304050607 0809 ";
+#else
+	const char *expected = "0706050403020100 0908 ";
+#endif
+
+	KUNIT_EXPECT_EQ(test, seq_buf_putmem_hex(&s, data, sizeof(data)), 0);
+	KUNIT_EXPECT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), strlen(expected));
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
+}
+
+static void seq_buf_putmem_hex_overflow_test(struct kunit *test)
+{
+	DECLARE_SEQ_BUF(s, 20);
+	const u8 data[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
+#ifdef __BIG_ENDIAN
+	const char *expected = "0001020304050607 ";
+#else
+	const char *expected = "0706050403020100 ";
+#endif
+
+	KUNIT_EXPECT_EQ(test, seq_buf_putmem_hex(&s, data, sizeof(data)), -1);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 20);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
+}
+
 static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_init_test),
 	KUNIT_CASE(seq_buf_declare_test),
@@ -194,6 +226,8 @@ static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_printf_test),
 	KUNIT_CASE(seq_buf_printf_overflow_test),
 	KUNIT_CASE(seq_buf_get_buf_commit_test),
+	KUNIT_CASE(seq_buf_putmem_hex_test),
+	KUNIT_CASE(seq_buf_putmem_hex_overflow_test),
 	{}
 };
 
-- 
2.53.0



