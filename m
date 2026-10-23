Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774253;
	b=pALXrdzWkVSpfnoWaUf74Bzq6KI0AS+9SX3LWvHMf7+OC/5SfNT5afa2GumOTjj9uV7y
	 czw0YDFg/S94ti+vdVz/YMskgneBz53yS8FhqaXxvw7eVAkUqhY220mjQ0CPQsZcDR/xx
	 PK8MwZWavq8X1tCsFPERDOwknOgMSjn6plBTva7I7eIM5q2bYjm/1ZzfYFj4LTEysRj26
	 BzV9haZg/mFgrbPw02/+G2JlzMqiYwCb9ebzYfkRtDRTCYkEyjll4ouoFSnKvu+XD/HQx
	 gFtFUY59oAXMMqMuo6IDUWYZ9U4GSU0gT5d/uYxvZUK+CxwqDecqtU/F9VNvHdgiKjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zd5L/oRzP1wg1gCNP4Fs3twhQBNTWi8+eqtm354A3a0=;
	b=pD7MR4UWdZCtnk3tc41M2GvnfiVD4R5rx4QXGsAxHAdTLSCHcGkNeDAB9nE5J2hGyKO3
	 r+kvCNtQ6jSmAmcISp9EmcfknWFxv9HLg1RkXseQrfY28+ClAYHTbIV0jaWIMKBw3Ncya
	 GciPAIS7+gPe51fbKUqDfr93nGpTuh+Ki+w53Hi8XUb2v1xAQ1JhNpAnV8YbfIc8+9lsA
	 u37TYdJ7f21Vp5FuoziS/dqgHIudrEcPIAniTShosc8P1oFyTFhBNhqONbINt+GeleWWA
	 OKAaT9VQYLIx773rjQSuJ2yCqoq4WThBQi1pelRFBkVxJrqy/82wQnQ67Hv+gN3bqyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fga+KQpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96C7606A328;
	Fri, 23 Oct 2026 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fga+KQpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F69E1F01825;
	Fri, 23 Oct 2026 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774252;
	bh=Zd5L/oRzP1wg1gCNP4Fs3twhQBNTWi8+eqtm354A3a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fga+KQppwYL5l9OuPRVwtx0CZMBVXJh++WsR6Nd81Htd+c3F++RQ1/AYUsYM2U77C
	 arHAzBWWLBZp17DW08RXfSqNkKgBsz7crAbNmA9D+lLAQDUqi3Ngfbm2il9MWS0e3I
	 dZRGl/v3Hps8ph5yLls9GSjiViWhGbWrMlKKpw1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/193] tracing: Fix fully-qualified variable reference printing in histograms
Date: Fri, 23 Oct 2026 18:37:28 +0200
Message-ID: <20261023163718.260677513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit 9236eebd138aa2753f7b30fc6cee7b7202841247 ]

The syntax for fully-qualified variable references in histograms is
subsys.event.$var, which is parsed correctly, but not displayed correctly
when printing a histogram spec. The current code puts the $ reference at
the beginning of the fully-qualified variable name i.e. $subsys.event.var,
which is incorrect.

Before:

trigger info: hist:keys=next_comm:vals=hitcount:wakeup_lat=common_timestamp.usecs-$sched.sched_wakeup.ts0: ...

After:

trigger info: hist:keys=next_comm:vals=hitcount:wakeup_lat=common_timestamp.usecs-sched.sched_wakeup.$ts0: ...

Link: https://patch.msgid.link/5dee9a86d062a4dd68c2214f3d90ac93811e1951.1776112478.git.zanussi@kernel.org
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: a0777b9e5315 ("tracing: Fix NULL dereference when copying keys for a field variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1355,9 +1355,12 @@ static const char *hist_field_name(struc
 		 field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (field->system) {
 			static char full_name[MAX_FILTER_STR_VAL];
+			static char *fmt;
 			int len;
 
-			len = snprintf(full_name, sizeof(full_name), "%s.%s.%s",
+			fmt = field->flags & HIST_FIELD_FL_VAR_REF ? "%s.%s.$%s" : "%s.%s.%s";
+
+			len = snprintf(full_name, sizeof(full_name), fmt,
 				       field->system, field->event_name,
 				       field->name);
 			if (len < sizeof(full_name))
@@ -1734,9 +1737,10 @@ static const char *get_hist_field_flags(
 
 static void expr_field_str(struct hist_field *field, char *expr)
 {
-	if (field->flags & HIST_FIELD_FL_VAR_REF)
-		strcat(expr, "$");
-	else if (field->flags & HIST_FIELD_FL_CONST) {
+	if (field->flags & HIST_FIELD_FL_VAR_REF) {
+		if (!field->system)
+			strcat(expr, "$");
+	} else if (field->flags & HIST_FIELD_FL_CONST) {
 		char str[HIST_CONST_DIGITS_MAX];
 
 		snprintf(str, HIST_CONST_DIGITS_MAX, "%llu", field->constant);
@@ -6167,7 +6171,8 @@ static void hist_field_print(struct seq_
 	else if (field_name) {
 		if (hist_field->flags & HIST_FIELD_FL_VAR_REF ||
 		    hist_field->flags & HIST_FIELD_FL_ALIAS)
-			seq_putc(m, '$');
+			if (!hist_field->system)
+				seq_putc(m, '$');
 		seq_printf(m, "%s", field_name);
 	} else if (hist_field->flags & HIST_FIELD_FL_TIMESTAMP)
 		seq_puts(m, "common_timestamp");


