Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061460;
	b=jV78BvEt4zX8KdDdwGAAmU2K6T4690BeqR1R7xJSH34B5JTdthMEdT/H3MMJ7k6AiS7a
	 YG/+0K7Q4U7cml9kDUM63zoflpdegUVFYOQUpTZxQIPuUK+dzGys4T8o8TdiqRljWrLYn
	 6ULhSspJb1wbUEjEFxVARiKqVe9b5xptCAxpE8ACb3DGYs2/U/blviFYK87WG4uDMbbw2
	 kmfA5zMh8qYJ/BVCtFrKjTNf4xNUhXfQbPUR0+ZIO7/rIFSKat7T16HfZr3UEq203bwXq
	 YJtnmHt2wcgSnYFipmdStLJqZ4jC4+RZs8hdEHJZwki5sjmRRTi2FGlEHY+FeyR3KXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RNM/YhRqt0IN8Z6dsHmd/Q9crPWtPizaar4jBJTTPvo=;
	b=1gAQ2ZnUnXZpyPpPg4UuTifFy4bEQsurk5kVoD0LtAm3TQdJFIxE/Jl8GYxo3zxPq+KU
	 cL3xpAZgkUDSmqeM24WxUUicUY0M1XCn2EsR8MgwethBOTI1pmc7I2Y7OoYPel2eAH/58
	 CGiGPHVrbMK82/wha5PywKGHHrZ2lyHcOxJE1jwPonTfHWD1YQkIirIdWIaJP1gifyTjS
	 3DEtK2FHrr8QRF8nTMZ8qBBB6jcoAdNHyzRoJTixEqoaCETWrPXIZwEBnLE2sR9NGn0Gs
	 XTKP3cTPgAD6PCv/59b427UL1OHxThSCqg9gDqAgAusMmYg+TTLkIB5DbKrULv+7bZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUdw80Zf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BFD606A326;
	Sat,  7 Nov 2026 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUdw80Zf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B821C1F0089F;
	Sat,  7 Nov 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061460;
	bh=RNM/YhRqt0IN8Z6dsHmd/Q9crPWtPizaar4jBJTTPvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUdw80Zf3vkKHmaawObvjNyGuZn+97oXXvMsHzi0u+Rudu++O2DbRXTmGIM+0a+9E
	 WQ7okFYi7HsWOwt4b5ccWnAPcD9RuH04Q8L/eVSw9DUEyzX7t2BXMAwQxuJo8/Q3nX
	 EgXll4+QVlD91SmE6WU9b/zwhLQVd2axQ+s+aAGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0563/1536] tracing: Bound histogram expression strings with seq_buf
Date: Sat,  7 Nov 2026 08:42:59 -0500
Message-ID: <20261107135013.398167958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 935601a4276f28105498609f7f98aa66e86e9c96 ]

expr_str() allocates a fixed MAX_FILTER_STR_VAL buffer and then builds
expression names with a series of raw strcat() appends. Nested operands,
constants, field flags, and generated field names can push the rendered
string past that fixed limit before the name is attached to the hist
field.

Build expression strings with seq_buf and return -E2BIG when the
rendered name would exceed MAX_FILTER_STR_VAL. This keeps the existing
tracing-side limit while replacing the raw append logic with bounded
construction.

Link: https://patch.msgid.link/20260611055945.22348-4-pengpeng@iscas.ac.cn
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Stable-dep-of: a0777b9e5315 ("tracing: Fix NULL dereference when copying keys for a field variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 57 ++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 9dfa6a6155e3f..cb2dcc7c9b762 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -94,7 +94,6 @@ typedef u64 (*hist_field_fn_t) (struct hist_field *field,
 #define HIST_FIELD_OPERANDS_MAX	2
 #define HIST_FIELDS_MAX		(TRACING_MAP_FIELDS_MAX + TRACING_MAP_VARS_MAX)
 #define HIST_ACTIONS_MAX	8
-#define HIST_CONST_DIGITS_MAX	21
 #define HIST_DIV_SHIFT		20  /* For optimizing division by constants */
 
 enum field_op_id {
@@ -1725,33 +1724,36 @@ static const char *get_hist_field_flags(struct hist_field *hist_field)
 	return flags_str;
 }
 
-static void expr_field_str(struct hist_field *field, char *expr)
+static bool expr_field_str(struct hist_field *field, struct seq_buf *s)
 {
+	const char *field_name;
+
 	if (field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (!field->system)
-			strcat(expr, "$");
-	} else if (field->flags & HIST_FIELD_FL_CONST) {
-		char str[HIST_CONST_DIGITS_MAX];
+			seq_buf_putc(s, '$');
+	} else if (field->flags & HIST_FIELD_FL_CONST)
+		seq_buf_printf(s, "%llu", field->constant);
 
-		snprintf(str, HIST_CONST_DIGITS_MAX, "%llu", field->constant);
-		strcat(expr, str);
-	}
+	field_name = hist_field_name(field, 0);
+	if (!field_name)
+		return false;
 
-	strcat(expr, hist_field_name(field, 0));
+	seq_buf_puts(s, field_name);
 
 	if (field->flags && !(field->flags & HIST_FIELD_FL_VAR_REF)) {
 		const char *flags_str = get_hist_field_flags(field);
 
-		if (flags_str) {
-			strcat(expr, ".");
-			strcat(expr, flags_str);
-		}
+		if (flags_str)
+			seq_buf_printf(s, ".%s", flags_str);
 	}
+
+	return !seq_buf_has_overflowed(s);
 }
 
 static char *expr_str(struct hist_field *field, unsigned int level)
 {
 	char *expr __free(kfree) = NULL;
+	struct seq_buf s;
 
 	if (level > 1)
 		return ERR_PTR(-EINVAL);
@@ -1760,47 +1762,54 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 	if (!expr)
 		return ERR_PTR(-ENOMEM);
 
+	seq_buf_init(&s, expr, MAX_FILTER_STR_VAL);
+
 	if (!field->operands[0]) {
-		expr_field_str(field, expr);
+		if (!expr_field_str(field, &s))
+			return ERR_PTR(-E2BIG);
+
 		return_ptr(expr);
 	}
 
 	if (field->operator == FIELD_OP_UNARY_MINUS) {
 		char *subexpr;
 
-		strcat(expr, "-(");
 		subexpr = expr_str(field->operands[0], ++level);
 		if (IS_ERR(subexpr))
 			return subexpr;
 
-		strcat(expr, subexpr);
-		strcat(expr, ")");
-
+		seq_buf_printf(&s, "-(%s)", subexpr);
 		kfree(subexpr);
 
+		if (seq_buf_has_overflowed(&s))
+			return ERR_PTR(-E2BIG);
+
 		return_ptr(expr);
 	}
 
-	expr_field_str(field->operands[0], expr);
+	if (!expr_field_str(field->operands[0], &s))
+		return ERR_PTR(-E2BIG);
 
 	switch (field->operator) {
 	case FIELD_OP_MINUS:
-		strcat(expr, "-");
+		seq_buf_putc(&s, '-');
 		break;
 	case FIELD_OP_PLUS:
-		strcat(expr, "+");
+		seq_buf_putc(&s, '+');
 		break;
 	case FIELD_OP_DIV:
-		strcat(expr, "/");
+		seq_buf_putc(&s, '/');
 		break;
 	case FIELD_OP_MULT:
-		strcat(expr, "*");
+		seq_buf_putc(&s, '*');
 		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
 
-	expr_field_str(field->operands[1], expr);
+	if (seq_buf_has_overflowed(&s) ||
+	    !expr_field_str(field->operands[1], &s))
+		return ERR_PTR(-E2BIG);
 
 	return_ptr(expr);
 }
-- 
2.53.0



