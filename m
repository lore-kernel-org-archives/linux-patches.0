Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041860;
	b=DS8FSGzoh1YjSiC7v0PnSG62e7ob+07BnN4skRwBDemckIwQhToj7l9T86F2Lxvw7xnP
	 KMrnNdfhpxJpoIoAHe2kBmi16z+LIQgoziJ7ybmru57Ihu9/btvdmpKi8r0JpWAIRXcp2
	 etJDy/W7a1KzjjrETPT/9pfQRM1n4JTya/0HGRC1Lfae9WJt0Qv90KuM3FrcADH8+N4o/
	 Oz9wna8ynqH98MLukvvWU8YzmLm5gzMvoAV2WRZKGLL4gi7refc/Rc/pUkuKsAF8C5fiT
	 7sc4U1TZfR9jE/cQTG7siECvSGvykChCHSAedZuyxdFCukJPFEbxcs4hRz3aW5c4FEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9qIt62f554fIaL/jFeLPEMiqGqgKbdydr4JdCqdGU0A=;
	b=2m5O+4cYTu55F5v+NqjteZTVJ4may2baX05n+vCGn4saAxIzZiHhKL2S+THN8U867J5Y
	 RZZ0T8rvGIguVLJPXB0arrmTYrFZeaakbSBBKgQpiqZtMA/WRH9WRCPOgxvl3spYunScv
	 UrlcqqOyZgxwQkcxbUBBuydQ/GZ5BDqQr1tBif8nn6/CUfX3QJtxy9ZsE1aCj9c89UhLG
	 WJb5LshpcNgxvQ8833IxsIRG0ftzAIP82clNgQFOVrUw3hAH4koW2vBYtAF6R0rHr/OZq
	 9zaZWOY20JXSutrHW4DurkZwOU9Yhx61eZkmaAZtiwuooaUM76sSAdrv8XSbDSCiVRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncCcL2uN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF41606A325;
	Wed, 18 Nov 2026 22:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncCcL2uN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACA01F000C4;
	Wed, 18 Nov 2026 22:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041860;
	bh=9qIt62f554fIaL/jFeLPEMiqGqgKbdydr4JdCqdGU0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncCcL2uNPwifRFjJX6n8cUV8YKh9bxm3C8TAHZw2Y7UjYu8+wsiL6QkmgYTaw0I6H
	 DtJM/nhwmEXkh1AplsJ6JEqFKIgOH5BTPW1+87Ukb7/Vocwd8ZfbAISCZYkCsaEZBa
	 zJqBgMB5Q6evukNRo3YJ9T/6jRifsSIeDPzzBOXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2964/3318] tracing: Only report the stacktrace modifier on a real field
Date: Wed, 18 Nov 2026 15:59:46 +0100
Message-ID: <20261118150449.213769105@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 18bb005845b78e0c0eb44b7f231c29d138552438 ]

get_hist_field_flags() returns "stacktrace" for any field carrying
HIST_FIELD_FL_STACKTRACE, including the common_stacktrace pseudo-field,
which has no ftrace_event_field behind it. parse_field() no longer takes
the modifier there:

	if (stack_modifier &&
	    (!field || field->filter_type != FILTER_STACKTRACE)) {
		hist_err(tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));

so expr_field_str() renders "common_stacktrace.stacktrace", a spelling
that cannot be parsed back.

Report the modifier only when there is a field to report it for.

hist_field_print(), the other caller of get_hist_field_flags(), excludes
HIST_FIELD_FL_STACKTRACE before it calls, so this is confined to
expr_field_str(), whose only key renderer arrives in the next patch.

Link: https://patch.msgid.link/20260914053443.981201-4-donggeunyoo.kernel@gmail.com
Fixes: a5e70ba87ca8 ("tracing: Fix memory corruption from the histogram stacktrace modifier")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index e6259e04ea663..c3fb3cc447e31 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1718,7 +1718,7 @@ static const char *get_hist_field_flags(struct hist_field *hist_field)
 		flags_str = "percent";
 	else if (hist_field->flags & HIST_FIELD_FL_GRAPH)
 		flags_str = "graph";
-	else if (hist_field->flags & HIST_FIELD_FL_STACKTRACE)
+	else if (hist_field->flags & HIST_FIELD_FL_STACKTRACE && hist_field->field)
 		flags_str = "stacktrace";
 
 	return flags_str;
-- 
2.53.0



