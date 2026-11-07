Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061458;
	b=3gNxNnzD+6rO/VT5udJeVtB9hPuyyylFYmSdishUa/cV/alx+yaBYUYUqDgsxoeAl5Q5
	 lsAOyJCn2xVCVRex8D1rUfqxcgzlFgWQ4ixg4ZJcYc1Fq/XEgwXYX0lEXHih7/7hCfgKj
	 YN8OXySDdCTCcpsdBalp/dXXp72u+yO9zIqSkYYccx/mzEQ9XyWu4kGpcec77DO8awBop
	 mT+v6+7J9GGIdNBixt9Z9tcgJuEaky0Na83cC7FAXhAAvHsILQkAPGWFP6ZNQrVD+SjYp
	 4L4SMSoeyXQo2gKX4d4LMFCmXRYTMfL2aICjs7Ed5KD/rpbba2N4o2IjnKxUmnk4X/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nOfQo67/zEliS6v1dNEUrgCO7Nc2LOWpKyEOsFGhg/o=;
	b=k8Zaq3Y5YRIrDR2gRw4/9TNLPaBDCAv9W6r26/9PWt2MsR6XFIvepTLwffBoWhIVH9mB
	 uF3HUbQcF3i8n+C3GQKD7mnHzt8AeDK1pNNNtis6t2SHrz/B14WlHwBB4DqHE3zrhsfrz
	 fpz/w+1l0l4iniGVXQrrTDo0xuFQxi3KwTB9LWvNXBj6ouOCPeo0CqCiOwsmz6xTBXKpe
	 hHMJCwacUo2EOY/rAPVRnchtLMBfXjDhHMd7LTrh6jHQWGB1C76frCeOz+pLGSzq2X5GO
	 YFN8hVAHZuRQSCv+UtehBh4Lh837LvXN6gBxXnbH+3NOfEb+QCr74LhUTYMBjBU/qCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ss15PVBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428A606A326;
	Sat,  7 Nov 2026 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ss15PVBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B131F0089F;
	Sat,  7 Nov 2026 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061457;
	bh=nOfQo67/zEliS6v1dNEUrgCO7Nc2LOWpKyEOsFGhg/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ss15PVBa/V8XJwmY2Ve0GznAFlBrEb79pPjo7EW2QI1IO0MMLyNwzNU61h9feOVn9
	 YeI7X/lxEa1pMsWwPp5/h5lqVU9mSklj+ENSx6K5s8VWU9m3Xg5pcDunKFPYzcIk9h
	 4aQ7RyveA1f2wZTtdFCKDqeMBic4rF7NSGFgA/Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0561/1536] tracing: Use __free() for expr_str() buffer
Date: Sat,  7 Nov 2026 08:42:57 -0500
Message-ID: <20261107135013.344052683@linuxfoundation.org>
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
index 63e6e9028a6df..c97c447cfd276 100644
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



