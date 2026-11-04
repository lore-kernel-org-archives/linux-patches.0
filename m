Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831300;
	b=jiMRaNaCooBMJsyCi2N78VjO6qhAfNAa6YEVt8TL6S7EAvPyVo+NAW8FxDDyThj2Ko4l
	 Hiyowd73sSwaKafF5KgBsP/P+ncdXvuYYOeu65hmrMX+Opo6ROJ6dUOwhGvjVuv7gTdDc
	 HVgv8fLofcrwEACXrPAbHlIXSc3KeV1SQxPXK+lFKq0H9ChUEAf+WU4ovKmNEivCHp+pw
	 DurADm+W5i71dW68wd19ed7zFIO5cYc8kvV1iQY/jzAYalKVOBH9dC9qgnrgTbpk5ie+J
	 RPMFTt0HiwENrXUMm9iZ6WSM0qxuw7W89UsNnQFkmiyRwf4O+vt8v2x2YB+z0MCxcvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ufy/2lO0RmNRHWdYQm41nWAu/WVV2WKf4kDsy/eahgA=;
	b=JL/kdMs0LdarFlCaUKb+8QuOELrJKcvUco81QyFm/nfAVxmR7jpUJBYq8cqoOIE3L/6P
	 siYfzbHS0LzOuR5NhBSfbWZOGPKAQ3qMIT0VYT+NvKE3/WbTecw2/H7kEWo1QRpwYwDXA
	 o+OYa+6o2doaApIrZJDHE2JkJZCIBzzFIjfJewUaVc+R7oX64A9GL6QIxg0QIPzRgOaVl
	 95ukBYtodhZ6A7En11QCvPHWtZs1IdB1B5zcC7s6lLMs9ZSkPfYaXu6u2E0EOrbX7rpMc
	 Zpw9AAr1p6PSdyeEq/TqH7nssCNKHfdJXMNvuUVdnSALtcmm2kK1TPVc14zApUYhBqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOD9kwdw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7E4606AC3A;
	Wed,  4 Nov 2026 22:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOD9kwdw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64281F000C1;
	Wed,  4 Nov 2026 22:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831300;
	bh=Ufy/2lO0RmNRHWdYQm41nWAu/WVV2WKf4kDsy/eahgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOD9kwdwnqzqnhIZ33bq+RCDA1lcsR+AbACUzULtwjoMB5aB8RpYUorW8q8UbC0y4
	 5ObWPacNdXfhxKoPBIxsFvj1Zql3LX1agW6jwDLS5cAqMMDWfpEbCZJ1cdR1Mzrg3A
	 5KjdxP7comtoiJVrVZD0A0ReO4ee+i7XQby1hw0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0619/1005] tracing: Use __free() for expr_str() buffer
Date: Wed,  4 Nov 2026 16:05:52 -0500
Message-ID: <20261104211101.159471835@linuxfoundation.org>
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
index cbeb3c146d8fa..b15e0b63dcf01 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1761,7 +1761,7 @@ static void expr_field_str(struct hist_field *field, char *expr)
 
 static char *expr_str(struct hist_field *field, unsigned int level)
 {
-	char *expr;
+	char *expr __free(kfree) = NULL;
 
 	if (level > 1)
 		return NULL;
@@ -1772,7 +1772,7 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
 	if (!field->operands[0]) {
 		expr_field_str(field, expr);
-		return expr;
+		return_ptr(expr);
 	}
 
 	if (field->operator == FIELD_OP_UNARY_MINUS) {
@@ -1780,16 +1780,15 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
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
@@ -1808,13 +1807,12 @@ static char *expr_str(struct hist_field *field, unsigned int level)
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



