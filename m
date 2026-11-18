Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032171;
	b=LuErEVJYPVQ0x6FI8QT860nLv7CmCxcSiXVNzP1JtPmHxxMrGDJavkiNHyva4cacbY5Q
	 t299kHwjdkpG9nuFKVVxhc/QNwCC1TC5oIPATqi3cPPRLEw9dZNHmrrVAJC6yLe8+ewH+
	 iZizrhuJXvZjg6N51l8j48k/qrOT+RVAnLFzoNEkHiwXZ4bqeP7C21CLSMJqrOraWRQIt
	 G20KlIEm/pmtrx7uCGpM/CwKmfNltT4iTQIHG2J5Hp9pjHP9MfsuR6Oi5EktlM8MQiZ76
	 53D77jKCYA7nmwA3zTkD6vDmgfK+HlAn3sHtIkcE6antZOCO6ruPFvYFhcAV9kFSChg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SU4UXiV0ejM6PaLcyxwRLq80cEVab96BvQv/zfttbMc=;
	b=KYtYVjiFqOhoD21GcCN7xSLG9OAC0eyVTHwaDmHX0alIps9gi1ZyncChvVavB2Tw44Fx
	 lHY3uUzrUYiRjbhGznB6GakhHtmeOj0fAOIN58rnyE9CUHXKidAUZAHUMQkucqnQWyOIE
	 +3kjdeTz7MFNvoyrkqs92zABDYyfxxJ6oP+j7SsnHaBg3muL6bl/1+wD/+7TkIAwhV1RZ
	 sTdzAS0hQgMoKlCubgSLxPreHfsNhvY039Ky1XU0AJVSekFGFVMLlQQejwmMdc5EXDTnd
	 twD5NrrX6sK6kzGYQMrVYzoc4ab1yunADz7tEwUYE/0pmjCATSFsdqL3MLGFNeipCUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAju+ryv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CC2606A31C;
	Wed, 18 Nov 2026 20:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAju+ryv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50171F000C5;
	Wed, 18 Nov 2026 20:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032171;
	bh=SU4UXiV0ejM6PaLcyxwRLq80cEVab96BvQv/zfttbMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAju+ryvUNNlfEknP2jl/QcqSGTxGMhfg4X0dR1mmJkxRYlTd6dL5O+KCRtSWTLqU
	 PJUt/XE+MAVINgMEbtF85HFJ3cqm0vw2WW/D5cIrXRY4O93xI6ux9EQgUOhNNz9Ffr
	 N00NWtVulc8g2QqcaQioanETENBC8qDgYdqYpw/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1316/1756] tracing: Only report the stacktrace modifier on a real field
Date: Wed, 18 Nov 2026 15:57:23 +0100
Message-ID: <20261118150101.844864403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 9dcb8978d3d13..4ad9c0da7984c 100644
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



