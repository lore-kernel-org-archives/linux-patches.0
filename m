Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044234;
	b=IgW6Qv7CCMhefy3IofJyCoZyvJ5UdC8UZVV1Jp4ET6dQJOUbQ77B8LuKB/9N6BGVODAy
	 U7Rt3cco58LosJ+huza1KeJ8jxU+JyND1XACT+tWqfOsin7CtkoQF3w5Qlpb5qWH21eV1
	 mr5na+q6i+T5wQ04WqPFiEI3noA7R8n7rROw5fJwAzG0e4DXXbzfs9WzK8EL/hn1d04jS
	 /CwLEZjjT95emp+OFgNt34UzzJUxkIuvBeCjhKUgBu2kYgW6qpzrrjRKTGI2y5MdCYRmI
	 D7A4+6rIzKRnxpbpb1JrAr8D0grgBA77OxWc+fIo2+ZYkorr1BIMrLVLBGfnMm6vThg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BQJH47sqoyr9YfMXKDkRjx2jYPjblP78ovHLfxiAWsM=;
	b=5brMzQ0pxIbmAP1t5TxzoGScirT1n0+Rfc0exiD4atGqFbPtxp2xyvZxEQfq8TJ6K5Rl
	 ODetvoKt11t/1BcILAef5RqGf6/99eMenxSkCxepQUrzZwvFkaioTYHaLpcfFa4ZL8r+Q
	 F8D0hAn41BqaZfokYc/x6RkeacmUtbmNKLPu39+JLNuioWSncMLEIrMMdpn/pywJ63Qa4
	 OczFmQEV5RIj2Gh3h7s1hrGpNX0aa6kwxXTUqbD+z0uvKfJ2lmCXFfH/h3UJ17dL5curT
	 bcJQ61N6oD2y/cNbQiu/BRX/uwEotn8m1y6nT3xFRU7/+rnXU7FPsRJ2KXl5iOSQwbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xw76rDtd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020D606A330;
	Wed, 18 Nov 2026 23:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xw76rDtd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EEA1F000C4;
	Wed, 18 Nov 2026 23:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044233;
	bh=BQJH47sqoyr9YfMXKDkRjx2jYPjblP78ovHLfxiAWsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xw76rDtdqL6ygPOfdBLL/v54SKDsJXcSmHWWyiknSONqlQxhKXKKFhZhoa80y4gMe
	 RCYz14opEX/FwPIYplTbGi5p0gHcz2ADrsiEq8jbJ7sek522yor6FEuWIVcU/zs7K4
	 hul3o+e4qcQqDtjFfZM+2VDELAvWBhNZNJCHWXbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0494/2857] tracing: Use __free() for expr_str() buffer
Date: Wed, 18 Nov 2026 15:25:28 +0100
Message-ID: <20261118150219.240767468@linuxfoundation.org>
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

[ Upstream commit 988995c0552b6213b6bf16cea57258d4842c1488 ]

expr_str() allocates a temporary expression buffer and manually frees it
on some error paths.

Convert the buffer to __free(kfree) and return it with return_ptr() on
success. This keeps ownership handling separate from the later ERR_PTR()
conversion and string-bound change.

Link: https://patch.msgid.link/20260611055945.22348-2-pengpeng@iscas.ac.cn
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Stable-dep-of: a0777b9e5315 ("tracing: Fix NULL dereference when copying keys for a field variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index efec173e878ca..d733d979c1a39 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1736,7 +1736,7 @@ static void expr_field_str(struct hist_field *field, char *expr)
 
 static char *expr_str(struct hist_field *field, unsigned int level)
 {
-	char *expr;
+	char *expr __free(kfree) = NULL;
 
 	if (level > 1)
 		return NULL;
@@ -1747,7 +1747,7 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
 	if (!field->operands[0]) {
 		expr_field_str(field, expr);
-		return expr;
+		return_ptr(expr);
 	}
 
 	if (field->operator == FIELD_OP_UNARY_MINUS) {
@@ -1755,16 +1755,15 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
 		strcat(expr, "-(");
 		subexpr = expr_str(field->operands[0], ++level);
-		if (!subexpr) {
-			kfree(expr);
+		if (!subexpr)
 			return NULL;
-		}
+
 		strcat(expr, subexpr);
 		strcat(expr, ")");
 
 		kfree(subexpr);
 
-		return expr;
+		return_ptr(expr);
 	}
 
 	expr_field_str(field->operands[0], expr);
@@ -1783,13 +1782,12 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 		strcat(expr, "*");
 		break;
 	default:
-		kfree(expr);
 		return NULL;
 	}
 
 	expr_field_str(field->operands[1], expr);
 
-	return expr;
+	return_ptr(expr);
 }
 
 /*
-- 
2.53.0



