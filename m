Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044237;
	b=PqVBhE4bfT2XOCAcjUxJTnGA8xzhk1SyIPCaveVI5YDuP9t8ChgCwZ2ocYdBKksMPydb
	 nRYKx83tEE/2p2viTqRCFpTL3s2MqxkhTdgaL31DEgW/BgNylDiyBkLy9nCv2y9SXFKwE
	 OS0nyrexEdMQNKV97TrvdTtSmvCPwYEUHepkNYydMFULs2YKo7Fk0UEJEUxvJV99wRHzd
	 O9NHFTTQnYOjkc/1xE1PP/L2gwV3bXZA6JcpL21e86Cl51uXjikhDMz+KyK/pKT8EJ+dk
	 SuJ/8ik4MatG61umGzcHgQU+z/33XYVbtXCuM16LyAzx7ImFK9icvtyXDu+5whvzagw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sosg9k0hcyYYZ6cRFL1oPD20D8yS+7b/vNbKHq6pCfU=;
	b=j90WMkhAjfblYI7naGStrJXDmaHhTrRbe/TkCIU6Mu0+MV5ADnio0sy79P8Gbkxv0jmW
	 KFpCMB2+Avk1iucQPuN0us0kbSrpelBePnfadsvfJZo5jDqX/nCDQ2epPhTboriPxsCsr
	 Rj+hdIwu9Gs817ajgf9fZ5NZFPBZgy7rvBV5qmOy1+RFhz4ZYqP4dBihetbkEmculhQ5D
	 FG3Y25UALNKGHzu4TKObRFnPbjYKoUB7/pe/T0ftGA8Pg/orEr03B9S8HvdOmrLbn/Q1B
	 Yv+7XWhhnIXqHAnUDHu11EqeUwg63cWGDmkwUVUV0kQyPSNw/siL12or98cakvmu5EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wr1oom3j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BA6606A325;
	Wed, 18 Nov 2026 23:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wr1oom3j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB171F000C5;
	Wed, 18 Nov 2026 23:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044237;
	bh=sosg9k0hcyYYZ6cRFL1oPD20D8yS+7b/vNbKHq6pCfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wr1oom3jIImudv/bEAhNJLBDSYfij4EDk70qdn2Lzd5uPhuqdGWLN4Q/iOp2PB1Yw
	 RLi34Cu9VvY4BzLGkdW1s8V7JyiEj8G91vPuSd52XYXm1iA4+D4PiC++TTpCkwggCl
	 XB0BHb7XPwWNTdLGISa6/oOQJcXLJor/aV1G2Kgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0495/2857] tracing: Return ERR_PTR() from expr_str()
Date: Wed, 18 Nov 2026 15:25:29 +0100
Message-ID: <20261118150219.277277290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index d733d979c1a39..5aab82a17a4f4 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1739,11 +1739,11 @@ static char *expr_str(struct hist_field *field, unsigned int level)
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
@@ -1755,8 +1755,8 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
 		strcat(expr, "-(");
 		subexpr = expr_str(field->operands[0], ++level);
-		if (!subexpr)
-			return NULL;
+		if (IS_ERR(subexpr))
+			return subexpr;
 
 		strcat(expr, subexpr);
 		strcat(expr, ")");
@@ -1782,7 +1782,7 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 		strcat(expr, "*");
 		break;
 	default:
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	expr_field_str(field->operands[1], expr);
@@ -2553,6 +2553,11 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
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
@@ -2765,6 +2770,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
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
@@ -2778,6 +2788,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
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



