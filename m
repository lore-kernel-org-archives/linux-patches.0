Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061459;
	b=q7bLJkSZDJ6oASMXqiM0JWQrIDPOyInd5Qv9p+6D10ovK6Cg6IGi9RhDt5lWJ73EywAp
	 b3Ggenr1ndTgAEy+169aGx7W6YeIx1kkbBNjvIHD3PDU16PGTP0byaZOxCd+fDvq6fkS/
	 6J/OjFi8ElK2ahi72VHVlcM17ca+3Y8kj9VwWjgQtY/8fauBbwvBWhEDcAIuqgNG5D1T4
	 x/4x3axft90utI9Nv48lkgfsKqSKbGpN8bzcsn5IBuxGUyC33W8uHLiPs0QraBe8EdYzS
	 7c5MXF2NJ7IcToPoIBqZNlXT9fLi62wMxxJV4WEzdt6h3JsJcUSnp85CLv6PEGj7FjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2b/BMPgLtbQZsFvbRmA0Swrssa+2pDAh73W4fYefRRE=;
	b=qQy21t6RVIyvJeFD087xlSA4nwPU1XeYwOR4zI45/igVaEEp1cUwapeqLVRZ1FtCoC6m
	 8dqFJH677CPhjGSJWDucJuV6hCniRfic0RDmqxdSV8AICgO2eQF0gaN2qpFW1fOjgY06A
	 NViNpRcTPSN8/btlR+An6FknOqXuVselYh957s0AzfMLXR3U7EkKsAmlIuzLvuNLMKcwB
	 4Aoh7h4ZagLPY6IK6fANoBVvIyE7vDplt6cIbf4mO//squKfK/R8tUylJDqzgnqC/j3jX
	 XDCXbqxl/bhDL0xOgWlyVG7qOAmT+DI4aNPKmSM0COAS5Z24utgDivWV+9CeTycJ2iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H/3pvacV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A56606A326;
	Sat,  7 Nov 2026 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H/3pvacV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F591F008A1;
	Sat,  7 Nov 2026 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061458;
	bh=2b/BMPgLtbQZsFvbRmA0Swrssa+2pDAh73W4fYefRRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/3pvacVzmsdqwZo4BiCa6PXtix/E6keVNEm8Qq7gwwS8LFSWZXH0V7y/hPkTLpRT
	 Ht3OopJobn2CE7H55q/TT9NzFGi+ugGBA8fkp0+M3UhQZDxtFdyBIlq04BOU2aWSb9
	 +N6p49ce5ZrZLT8EkkuRqcoKktIFS1UqD0BFYM8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0562/1536] tracing: Return ERR_PTR() from expr_str()
Date: Sat,  7 Nov 2026 08:42:58 -0500
Message-ID: <20261107135013.371229251@linuxfoundation.org>
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

[ Upstream commit a5ca27e8ff1c10e949af7cfe474d6d1a08fb5601 ]

expr_str() currently reports all failure cases as NULL, so callers cannot
distinguish invalid recursion depth from allocation failure or later
string construction errors.

Return ERR_PTR()-encoded errors from expr_str() and make parse_unary()
and parse_expr() propagate them. Clear expr->name before destroying the
hist field so the error pointer is not freed as a string.

Link: https://patch.msgid.link/20260611055945.22348-3-pengpeng@iscas.ac.cn
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Stable-dep-of: 935601a4276f ("tracing: Bound histogram expression strings with seq_buf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index c97c447cfd276..9dfa6a6155e3f 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1754,11 +1754,11 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 	char *expr __free(kfree) = NULL;
 
 	if (level > 1)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	expr = kzalloc(MAX_FILTER_STR_VAL, GFP_KERNEL);
 	if (!expr)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (!field->operands[0]) {
 		expr_field_str(field, expr);
@@ -1770,8 +1770,8 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
 		strcat(expr, "-(");
 		subexpr = expr_str(field->operands[0], ++level);
-		if (!subexpr)
-			return NULL;
+		if (IS_ERR(subexpr))
+			return subexpr;
 
 		strcat(expr, subexpr);
 		strcat(expr, ")");
@@ -1797,7 +1797,7 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 		strcat(expr, "*");
 		break;
 	default:
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	expr_field_str(field->operands[1], expr);
@@ -2603,6 +2603,11 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
 	expr->is_signed = operand1->is_signed;
 	expr->operator = FIELD_OP_UNARY_MINUS;
 	expr->name = expr_str(expr, 0);
+	if (IS_ERR(expr->name)) {
+		ret = PTR_ERR(expr->name);
+		expr->name = NULL;
+		goto free;
+	}
 	expr->type = kstrdup_const(operand1->type, GFP_KERNEL);
 	if (!expr->type) {
 		ret = -ENOMEM;
@@ -2815,6 +2820,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 		destroy_hist_field(operand1, 0);
 
 		expr->name = expr_str(expr, 0);
+		if (IS_ERR(expr->name)) {
+			ret = PTR_ERR(expr->name);
+			expr->name = NULL;
+			goto free_expr;
+		}
 	} else {
 		/* The operand sizes should be the same, so just pick one */
 		expr->size = operand1->size;
@@ -2828,6 +2838,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 		}
 
 		expr->name = expr_str(expr, 0);
+		if (IS_ERR(expr->name)) {
+			ret = PTR_ERR(expr->name);
+			expr->name = NULL;
+			goto free_expr;
+		}
 	}
 
 	return expr;
-- 
2.53.0



