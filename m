Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020600;
	b=hmEWRb7ZuVq0SODijQ2vG3ECJosKNhTt0d+80aycnX/vRLQ6fajx6xXFH661LSn0211H
	 HvfNojF+ANTVqIhaHBmbq5tznYDZyUCt5QyTAxj2V2aXCeX8foAbP+YMHsNBKv3RgJF47
	 7855j1LQUGKRJZZp/AvoxYCoEPjfmWZARrwHp8/zdvIt9LQya3Khs8Z9c3TFcppwBKg/6
	 3erlySziuCHJ+emVmG54/ik9W96jmXZAKqkWf15PRlq4qlafFM1CTcxBJLyPJf+4Cb+Ex
	 OJqso72IJB3UBCXZPUtRv8DgYzST1AVF4jAuE6BpIBYOQ2nShMbzhUOYi4vwcKnLk3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+mW5QGtxdWem48z8Zw/Siz4tVWQOm6d4zoPoEFFqeV4=;
	b=R0NajyjJicKUCW56oFESse1v4tV4h5mx930bC13LyzrJ8i8q9B2+s/vJa5MwJeMseGLX
	 HGF85SKf+isFBjLWCGbubGQZGPEE+SQ+oFq3mE6McfslFDclS1Z6YA5Ukjrx6Nb1z7dTB
	 ZJ5R27+dPhH9TxEmg4chDVvKAbOUS3ODjDIWb+ScGdWIke+D9JgsNKkdNEKe6jtAl5P5W
	 nzZ2tGWas6PVGF6bZ5SzqJCgqnjYrsJQDMC5ukOAp1u02tlz6T6WY+4vCzo1UDxhHfDB9
	 EqOq+fK17DL02VP4WCLOQpEjCCYP3GfIh10hWxAJ0Iak7pQQDJ4FouaigePGpmtXYJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwjjCQzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A22560A2601;
	Wed, 18 Nov 2026 16:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwjjCQzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645FF1F000C6;
	Wed, 18 Nov 2026 16:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020599;
	bh=+mW5QGtxdWem48z8Zw/Siz4tVWQOm6d4zoPoEFFqeV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwjjCQzI7tnf7WVyb9m5rhD9lhPU/dWDwu6+dXlOZBjqaIvfM0z8MFRS1xoFEulva
	 h2/hFMjtuIK1ebqqqjV0969T5z8UNHWt3u0rqcXrz6YfVs9+0w1mbZkguvM/sjfgCD
	 Bz4Zr5lAc1ohgp2FyXuPpVASnG2sjEr7cDEgKk5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2007/2651] tracing: Only report the stacktrace modifier on a real field
Date: Wed, 18 Nov 2026 15:54:07 +0100
Message-ID: <20261118150358.531642910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1cd3d0552db83..64d89f5fb9d93 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1725,7 +1725,7 @@ static const char *get_hist_field_flags(struct hist_field *hist_field)
 		flags_str = "percent";
 	else if (hist_field->flags & HIST_FIELD_FL_GRAPH)
 		flags_str = "graph";
-	else if (hist_field->flags & HIST_FIELD_FL_STACKTRACE)
+	else if (hist_field->flags & HIST_FIELD_FL_STACKTRACE && hist_field->field)
 		flags_str = "stacktrace";
 
 	return flags_str;
-- 
2.53.0



