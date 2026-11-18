Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035066;
	b=4J/d27jfynq2If4BzS4vq4yuSEFroD82rvGJwllxTsAHlFG0/yLLlIFjEfu11REPI4Tu
	 RHyVi61pDRykya/wFUL5B3C/3OUgyq+VQuBCTtGmeNLysCbChxy2mAZ7h8g19eNFZIdn7
	 Cmjtp0PV2v7sglqUVfVxzx0LXxI00kPhR44ZS1CRA8BydlhPua4NTk1DFssit+G/VjuwY
	 KajH7jTCXg1dS8avtUTAbj2ifG2v03D1lPz4MZk2bfNWh+vdt04LK1uucJ95VqyyoVQx0
	 59gTJjBypSZtG02HXrK8tw/cLDfi85LS0C4pPd60CwDM7SoGljhuicQZzZOQ9zjVuuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HhhXicBVGiZhmaV8tn7frc5gxdWKsmw6SMZX/6+wx4A=;
	b=m0Ip/ZgjyoDbuNidCQOO1IPXvV8baX2a5I1hCJB6+Z1XKrhD5Io/wTjOmtlQBpRq/7s/
	 PaPBbpnmbUo0TwZ3cUzhGjVJ2Sr3voJYVbBLZwJB4v/QDPv/U3l/garz0EYcMyndlP9kR
	 Gjd5lEU3fqpxtIq2Qf8t5XA0HkUNhl1Z+zOnCmz5fNb6FpMgPFAN0G9OF9qPEZcdQf9+u
	 zhEP0ngg/f7/TC8WYb0QHOKmERy+wpQUIiLJ+gMRAIZ4XwQlzxfew/aB74wnNinq6mLZ/
	 lw0YBIWBqMYQ6io61j4GTP9uXCKCwfM22iGFyGv1c9eJUWocFLW25SEGyEaNgQx7kUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au6ZcqoK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043F1606A31C;
	Wed, 18 Nov 2026 20:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au6ZcqoK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D9E1F000D0;
	Wed, 18 Nov 2026 20:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035065;
	bh=HhhXicBVGiZhmaV8tn7frc5gxdWKsmw6SMZX/6+wx4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Au6ZcqoKUo8heWuZpjxMNgMqBYXZoQNNB9iRrzML1o21onwhLgc0uwsIP9Jb9k361
	 4dSgVaHfo5ltIoHlXOPTOgGWxenThSBWo7CzI6MHM+64hLWOnofHCYAOvzJVhv2lL0
	 bb/Zard57bEdzEd6xZQsZCk1zrdsaKFq4yy2wO3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0543/3318] tracing: Fix fully-qualified variable reference printing in histograms
Date: Wed, 18 Nov 2026 15:19:25 +0100
Message-ID: <20261118150333.567704146@linuxfoundation.org>
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
---
 kernel/trace/trace_events_hist.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 7ae8160bb8f92..13b77b5900a3c 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1342,9 +1342,12 @@ static const char *hist_field_name(struct hist_field *field,
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
@@ -1724,9 +1727,10 @@ static const char *get_hist_field_flags(struct hist_field *hist_field)
 
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
@@ -6138,7 +6142,8 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 	else if (field_name) {
 		if (hist_field->flags & HIST_FIELD_FL_VAR_REF ||
 		    hist_field->flags & HIST_FIELD_FL_ALIAS)
-			seq_putc(m, '$');
+			if (!hist_field->system)
+				seq_putc(m, '$');
 		seq_printf(m, "%s", field_name);
 	} else if (hist_field->flags & HIST_FIELD_FL_TIMESTAMP)
 		seq_puts(m, "common_timestamp");
-- 
2.53.0



