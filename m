Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044231;
	b=1vcED9hhIteg5vSe1HQsvaraD35mc9tjHDrzWjNCELrtRuzXKm/JQ1+LA6sdKcJFmu5O
	 bq9D6ULoNB4i3A3OmNviYzFBgh94NV6ZVqd5/lKlOBzEqUacI3XV8s07stRV8KFo9kb37
	 oTnZw1Dg6AEYiKCbw8U6C6f89DxbMmjCW7pYZL9PhXAOjXG4dFWXAqeT5MFfWmJylhPRz
	 8KGqdZLzWQYYu0pDTBR1IqwGYNPwxnXk9suIDa4pCmyHGA654WEkJBEzvxdqHJAV+YR4s
	 xRbqzU+dQ8s+Ip10+ieffUwtBFEab1xAOxanZhb8hR9kwpzrP1IW+jLNCrvDgkVpUkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=815fzdn0faeiG9LOMSn05qbCQ2hcKG6nN2WYKo9bV6E=;
	b=WhwiJr0P7yskpmJkWwabR9FOeoWNpLTAUJG7GafVptGiXXb0X+67f1wxgkJs19MlAUIB
	 NBFwS+/NJPCjhy8u3cRjq2h8rqcQXCUANrhS/7cf3cDX5xDtMKMEsuMC6e7DXnlxmBJqP
	 5exQSzb3shkPNEMnXF7pCIJCPiGFc2PhKOCbc2ELJ84xg8UXsRnkEKctwgSuK7kfdSKcO
	 5lDjXiE58fo/ycTzgT0qbG4u6nZFI8qVF7vQaGtSL+tRYKtIhOoDMZSEUDJrp0plwNC6+
	 NlHoybjbL7pWIoReDbpj5xK2m8Z3XrRD0F54mDEwZjhgteADQ2arLhWdw2/bp0HqU2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9nhZ4IY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5DB606A32F;
	Wed, 18 Nov 2026 23:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9nhZ4IY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ECA1F000C6;
	Wed, 18 Nov 2026 23:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044231;
	bh=815fzdn0faeiG9LOMSn05qbCQ2hcKG6nN2WYKo9bV6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9nhZ4IYPM66emvMzF1XuYwmGu2tngeM/NbLwKzhpvOWJ8SYPUM9EK/MWm5pzNdaA
	 +qiX9qrRh7P/c3WZbpp8bfa4qM7TVPIg5XCyoY7ASczvUvG9dawD+4kPDtacmDzewz
	 eW22cHRNqSNttTsQB/h6CsISMPrfn/gTrD3kycOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0493/2857] tracing: Fix fully-qualified variable reference printing in histograms
Date: Wed, 18 Nov 2026 15:25:27 +0100
Message-ID: <20261118150219.202878654@linuxfoundation.org>
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
index a3b49b4b365aa..efec173e878ca 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1339,9 +1339,12 @@ static const char *hist_field_name(struct hist_field *field,
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
@@ -1709,9 +1712,10 @@ static const char *get_hist_field_flags(struct hist_field *hist_field)
 
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
@@ -5845,7 +5849,8 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
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



