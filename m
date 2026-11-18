Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035069;
	b=iOPWKXsq8E8U+tg4pRJfEfbOBlE6vhzYGYm5vMIT8tFKdRXiAo4j/U9EEkEyHCrB4wIq
	 7m2m4dJQ7xHtI4vgySSFB8fr52fCcmaxycRsQguYvfQO9a8l2EHaueKuiCTBNzzb5pJvK
	 BHnEsa4IDD7v8/aM+vZBE3l4mOgIUXN7BkMkxMDOLliIWFY/ImxMM24y/3gw1VI8x1QHC
	 FZShmCY67a9VeSxwcppMhZe8PEUi2jzDzigvTeJtS+B0hsx9DLkAwnEvG7BJp9czaGw6M
	 dh2Z4/87CajxgqHWHKPlDqPghrwQsMgBHYmUyucFdsi10RYOPjVnMT86RrujbyshseA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hsEmeN3FwGiF8mOdHha3BFQ2h5F8SZScp0/aqrCt8PY=;
	b=chCFTe9ioJZ/iDqHvH8NYMBqz3YQ3kjlvgEtFEmiIeUDsYazaFmsOdaQQ2q9cmvyHx2G
	 inlp9yij/g4iipkDdRVz9eI1q8VIBWk8hinnJ5G3R38AHUbk3CKMQ0zZH+5F5iVYnjuDF
	 cJ4pD0dgQPjgToWzPfYkXXpr0dkdzC0xLHLRyiVNvmqSYFXyxAfSgwACIBxzwyNgCGU1D
	 qRUA+/ZpPP2/yUp2mQng//Lwy1NgapZHN5Wzs0HXLBI2sjmtNoytxIoqrlSBSfQTvyHJB
	 QyEAyT/Wi/AqiYE1JDGQqwjm61YdTg4CwFLMGRRLhJ7IS0fu5nK3TGt8hEyvYDfgyAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVqi3nJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AEF606A320;
	Wed, 18 Nov 2026 20:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVqi3nJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D851F000C4;
	Wed, 18 Nov 2026 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035068;
	bh=hsEmeN3FwGiF8mOdHha3BFQ2h5F8SZScp0/aqrCt8PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVqi3nJKcrQGuEdcBC8YbydkiNwXCxrjFiZZFsnyY85aeR/lazIbAO2tEHuiAX2t8
	 v7b21s0gLdaN43Ml5sT58jAIj+v2sUzLzfgwYcfjf9ALxa4yZyZAuWPAzLcz6Jv23A
	 qogBItfswdkT+KUwvKJKjgF20PNJXfNueFib+spQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0544/3318] tracing: Use __free() for expr_str() buffer
Date: Wed, 18 Nov 2026 15:19:26 +0100
Message-ID: <20261118150333.600514239@linuxfoundation.org>
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
index 13b77b5900a3c..4b2a76584298b 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1751,7 +1751,7 @@ static void expr_field_str(struct hist_field *field, char *expr)
 
 static char *expr_str(struct hist_field *field, unsigned int level)
 {
-	char *expr;
+	char *expr __free(kfree) = NULL;
 
 	if (level > 1)
 		return NULL;
@@ -1762,7 +1762,7 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
 	if (!field->operands[0]) {
 		expr_field_str(field, expr);
-		return expr;
+		return_ptr(expr);
 	}
 
 	if (field->operator == FIELD_OP_UNARY_MINUS) {
@@ -1770,16 +1770,15 @@ static char *expr_str(struct hist_field *field, unsigned int level)
 
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
@@ -1798,13 +1797,12 @@ static char *expr_str(struct hist_field *field, unsigned int level)
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



