Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831302;
	b=zaxT3X8otQ60t4F99ds9LnwWEtugjAKhqqD4JJTEjj2qtE5gSfHVpiLZREsVPLJJXjOq
	 JgioX4ol7bF3tNwPuI/sjETL607r7jGn9p2tB8OROLXMkBi0FeOlpX+TdzwkidWjPD420
	 rPPbDWN9J4fecWSbvHv1je2VPsjBQo25Oo/1hY6zbwTkdM0zTBBrgl4UqUaF2aZku59hd
	 Kf2oXmSou02HtaOGnthgTXIkyb4eoQyQtaGwHEA2+eKUFXMTRSqbTzhsrSm2wcoCSh0lv
	 26FHzwPabPIevF6UTArgfJAOXqdcHXiQ0knczoTtt5sFPZ+TBZQAXqyuM9Nnfu6tg7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJ6/BZ4VMRK2qFd3Dpk4Idjubx4/ofAEhWEii7SJN5A=;
	b=PdmJDI+gROxm+di8zU4GQ4yN5VLiNYlwDtdZQs/N+x3hywtfYAcYw+pz8y0g1PfZ74Ye
	 Ve54uw633VTBRrtJQb30DXcsg3uRNJ83Q0N8ycWgXLVCP54wzl2H23r1UDK/El3JNlU5g
	 rPLLkU6EBps8YtvgVQtB3q6JrzeOGHB5DR+OLPmmyhSwglrhrfwFYdyVmuWl0ORqOaOPr
	 RQNP4kqXZSGEM2EtnnByPyrIxzUemXyQ71j77E3RkipWiTIieqA/ae4Axb2bSFeQ0LuJ7
	 aLBoRXPrsudn0qmC+YBOpKBDtkJ94qqwY5Iv/bHk/qb/0UJAgvdOF6boAfhZ3l9/xZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XJfUaPB/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD732606B2DF;
	Wed,  4 Nov 2026 22:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJfUaPB/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4491F000C1;
	Wed,  4 Nov 2026 22:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831301;
	bh=rJ6/BZ4VMRK2qFd3Dpk4Idjubx4/ofAEhWEii7SJN5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJfUaPB/CZe+GwkWd4zObHhEpHqT0W6bCm1fqqgU2/xR18nmYFMUx0ijFB148qsoo
	 UdrjTqnRuL1w2ELT8wrK6V2EBgmjzgVyyR79UD/KvGH3Y586Cmbsy4A3ThcZUcbXEj
	 7MWxIl5vaFrstsBE8zYuItKqK92in/MmmV+f4uB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0620/1005] tracing: Return ERR_PTR() from expr_str()
Date: Wed,  4 Nov 2026 16:05:53 -0500
Message-ID: <20261104211101.184510148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index b15e0b63dcf01..511548b75ad89 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1764,11 +1764,11 @@ static char *expr_str(struct hist_field *field, unsigned int level)
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
@@ -1780,8 +1780,8 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
 		strcat(expr, "-(");
 		subexpr = expr_str(field->operands[0], ++level);
-		if (!subexpr)
-			return NULL;
+		if (IS_ERR(subexpr))
+			return subexpr;
 
 		strcat(expr, subexpr);
 		strcat(expr, ")");
@@ -1807,7 +1807,7 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 		strcat(expr, "*");
 		break;
 	default:
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	expr_field_str(field->operands[1], expr);
@@ -2624,6 +2624,11 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
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
@@ -2836,6 +2841,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
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
@@ -2849,6 +2859,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
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



