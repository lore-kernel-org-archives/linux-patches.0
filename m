Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035071;
	b=RYWKLqYrenh2wh9wtm87WVlW6AlR5p+wVrQXUttXbX5V0DGNKXuP4bXug2im/ujYCDSQ
	 1qO280OQgqnhlC7VOtooNzb/XeKqiJKGgiZxIEhCfVMADGHte2ivH1qYLEtr73UBbsYN3
	 SgSx/gXzV4AD34Ofyv8X0BBXHv3HRzG/RzEv5/W7G9oeOoauPCfVrkr9BrIIG8FvlSYLd
	 IxTzLXBv0RsCAaKWgay0KvrKx1UyW2jCFQyvHkiBT6ffNqkvEMPhTUOU9pI9GsHrEj5kz
	 yQvAVoLol9HfNiIsxVA4k326oWsfQMEmhwouWFUzZpBxyFlpYq12pycxvTRQN65PvLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i7cYXXhtjTOnYnII5BQAGendhd8uDXAUSd2guZZDMlo=;
	b=bDHvb4SK52UbiYvQ2wZjA4igj/zYfE/WYRElMOa9TnLMvTfZauk99rMun7MOuiHvDWRi
	 3iMTjD3jo9ytJevE4Pt+Czn+vwvulDPt/eD4Unzv0dLCFXMOFFR5s6CVzznLGCI4y0cTd
	 DUb9RV37xIbkdw8pOWaYNVXJfZQS9bGA77D+6IlZvxF/n4/KO+uGpyn1J+SDXCH5XRyF1
	 vlcqb+bVTotxkcXXKaYR74NUs4l5L0H5jlWac68MVn1+jpairi+/TGLmWsudsBy0NGmS2
	 UxTXQHlSQekcV/gcEuuiPvTih6yj+olX3rnHK0Ja6UUQvPnkM8Uuc5VgGNpPZtuMDVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgQbq7Ow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66358606A31C;
	Wed, 18 Nov 2026 20:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgQbq7Ow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFDF1F000C4;
	Wed, 18 Nov 2026 20:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035071;
	bh=i7cYXXhtjTOnYnII5BQAGendhd8uDXAUSd2guZZDMlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgQbq7OwloM2uWLZ5fqmLmwtL93ssUF2DChvMuNz0bADGeDd67YtIo5aXU0Ra5p8J
	 BrGeSTzh4ZCzMEAP6pHYAK+U+f3Fy7cphxLHIvTX6bNUMHVbHw88f4GbSA1VHKuSti
	 B2ufiqEsKvRg4vA8+X+BiCZILVaKfq1oJoMCvoPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0545/3318] tracing: Return ERR_PTR() from expr_str()
Date: Wed, 18 Nov 2026 15:19:27 +0100
Message-ID: <20261118150333.633373304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b2a76584298b..d7c2cf3fe02fc 100644
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



