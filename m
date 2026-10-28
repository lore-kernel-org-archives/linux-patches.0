Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215635;
	b=iAlqZBYIkYUG6dWhKhnOEut4d3utle3phITqf4uCrGZyGEeM6WNsAZxQIqNRX20mI6tD
	 CvTQ1cfdGXxnF5YswRxEwswIoVGDiF7I3fXZGiN3d8pio1+sDVMZKts+BgAsmubySUNhE
	 B4DNQaiDRMupC7mTj5xboKdk3PKLbEIvJajq4dneNQAqESZZQjP/QVyAqH/xdo2JbPvKQ
	 dVoRC+kNy/NTvG4ncnd3uYdJxbhrCr9n05g6WiTTlbZiJNCkEuGIoZlmki/DJQg59oeQg
	 bzAB6NcK2SXI5rmgoJUc5DYcNAyqkG1TYZK2OeGrPiZuMrC0JlhRHL6e4Kx1tj1uQ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S4FF7vctiglWvJnIxlxN/hivEE06tQM1+uQUi2GbujA=;
	b=wYZYSQY150uW+34TDdkVjnqhplDEivMm/VrX4wJaDsPsoHNUluhFQ942XmTxkR8nOcWE
	 Z1UyumjdVNEkFhsAQan95iugVrkZp7wyctIwsGgaVy8poI+p/C2b1QI5Jm7zYbDnIAZo2
	 7VOGHwpVL3eheF00EbhuRTrYWJJcL3PUvL3PdmS0hmjgBdpQzRm7mlM4iexPYlM+eLhuJ
	 DBl9uVfaUywrKvYuIlbYhMOME6fWbcp8JenEojq3dYYT82fjPSWKtJk/r4OemiiLDUz5v
	 QNfwHmoEX/P0DEhFkXwvs3MWfCqJowFicO9OYUYgwiRH/TBSmQToyJxLkuCtkfPXIPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKqhNE2J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBBE606A31C;
	Wed, 28 Oct 2026 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKqhNE2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3EA1F01825;
	Wed, 28 Oct 2026 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215634;
	bh=S4FF7vctiglWvJnIxlxN/hivEE06tQM1+uQUi2GbujA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKqhNE2J8U9gmO5daunK0mN2MtMwUlii0EBEWu5OWS+qmH3GI8zglWJzLovQx3dds
	 4Yb+2jtlkUnw/FFnZpw2be4MhOchPkT5useqJBgVpj59rfSmckFmFP62Rxy/FLbc9Y
	 yKzuiEQwXu5g50MHgf67lMcPJGS6ZNgYvjcMUD+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1272/1887] tracing: Bound synthetic-field strings with seq_buf
Date: Wed, 28 Oct 2026 17:56:08 +0100
Message-ID: <20261028170528.367843896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit f07883450eb14d1cf020b55d9f3a7ec5683bcd26 ]

The synthetic field helpers build a prefixed synthetic variable name and
a generated hist command in fixed MAX_FILTER_STR_VAL buffers. The
current code appends those strings with raw strcat(), so long key lists,
field names, or saved filters can run past the end of the staging
buffers.

Build both strings with seq_buf and propagate -E2BIG if either the
synthetic variable name or the generated command exceeds
MAX_FILTER_STR_VAL. This keeps the existing tracing-side limit while
using the helper intended for bounded command construction.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: https://patch.msgid.link/20260430043350.57928-1-pengpeng@iscas.ac.cn
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
[ sdr: Moved struct seq_buf *s for upside-down x-mas tree formatting ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 41 ++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 7753a024829b8..40d9de933fc85 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/security.h>
+#include <linux/seq_buf.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
@@ -2882,13 +2883,22 @@ find_synthetic_field_var(struct hist_trigger_data *target_hist_data,
 {
 	struct hist_field *event_var;
 	char *synthetic_name;
+	struct seq_buf s;
 
 	synthetic_name = kzalloc(MAX_FILTER_STR_VAL, GFP_KERNEL);
 	if (!synthetic_name)
 		return ERR_PTR(-ENOMEM);
 
-	strcpy(synthetic_name, "synthetic_");
-	strcat(synthetic_name, field_name);
+	seq_buf_init(&s, synthetic_name, MAX_FILTER_STR_VAL);
+	seq_buf_printf(&s, "synthetic_%s", field_name);
+
+	/* Terminate synthetic_name with a NUL. */
+	seq_buf_str(&s);
+
+	if (seq_buf_has_overflowed(&s)) {
+		kfree(synthetic_name);
+		return ERR_PTR(-E2BIG);
+	}
 
 	event_var = find_event_var(target_hist_data, system, event_name, synthetic_name);
 
@@ -2934,6 +2944,7 @@ create_field_var_hist(struct hist_trigger_data *target_hist_data,
 	struct hist_field *key_field;
 	struct hist_field *event_var;
 	char *saved_filter;
+	struct seq_buf s;
 	char *cmd;
 	int ret;
 
@@ -2978,28 +2989,34 @@ create_field_var_hist(struct hist_trigger_data *target_hist_data,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	seq_buf_init(&s, cmd, MAX_FILTER_STR_VAL);
+
 	/* Use the same keys as the compatible histogram */
-	strcat(cmd, "keys=");
+	seq_buf_puts(&s, "keys=");
 
 	for_each_hist_key_field(i, hist_data) {
 		key_field = hist_data->fields[i];
 		if (!first)
-			strcat(cmd, ",");
-		strcat(cmd, key_field->field->name);
+			seq_buf_putc(&s, ',');
+		seq_buf_puts(&s, key_field->field->name);
 		first = false;
 	}
 
 	/* Create the synthetic field variable specification */
-	strcat(cmd, ":synthetic_");
-	strcat(cmd, field_name);
-	strcat(cmd, "=");
-	strcat(cmd, field_name);
+	seq_buf_printf(&s, ":synthetic_%s=%s", field_name, field_name);
 
 	/* Use the same filter as the compatible histogram */
 	saved_filter = find_trigger_filter(hist_data, file);
-	if (saved_filter) {
-		strcat(cmd, " if ");
-		strcat(cmd, saved_filter);
+	if (saved_filter)
+		seq_buf_printf(&s, " if %s", saved_filter);
+
+	/* Terminate cmd with a NUL. */
+	seq_buf_str(&s);
+
+	if (seq_buf_has_overflowed(&s)) {
+		kfree(cmd);
+		kfree(var_hist);
+		return ERR_PTR(-E2BIG);
 	}
 
 	var_hist->cmd = kstrdup(cmd, GFP_KERNEL);
-- 
2.53.0



