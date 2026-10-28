Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211867;
	b=yBpJgInjqtWdpX2NKC5o+Gmt+uctF62AFWYryPAsptZWjhzzc0UckLXuCOhsaAq7srd5
	 jR9GpeULhtjIu5gv2n3EyQlF1TPgjkLGkxBn38bOWjNkpAy1tO8MfBkegwzTp8LhrpZLA
	 3e36sCLyr/nRi0A+k7fb/f8jaC1Izi+BGycjFwjVqwrZEgCy8cqdrrO8yrTyUUVar3cbI
	 BDwUljD1vpWtNaRDFUASHUjFwqXqycgUjDmOO92w8ojIrp3lW7MCMCWkgCM3MVWcT9LEh
	 EPlITf2D5fxi0RpIaKlsH40stAR3SlxIDdLmQUFmMD+PfDmeljBWiQggrGM0dSsYpSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0VoHttG9kmL5ShlKjJ57AQXyhulufrswW50b0FuFs8=;
	b=yjlt+rI5+vzPDK1rdeidfcCoecGrUbtfJFo/9v81/1kPuAvzKBoJCAwe+aIPkWqW+NGE
	 vKCCHBIpMv6vOlMy8lxwDOzXi0o4fQhiMFSuXh8TTuU8iCAXUmUVopJ4qo+Nz7gLwo33y
	 SvenYO1oB/1cFcKd9nOY+NU/hQoGlaoCXGrXcQj2QGWqUbF2oITbNzq7KPeOt11vMKuHN
	 Fm5eA9OAztYNLTtmsK0Z8CVdAqN+hFHFymgEu9ly0fPPYQOHnRXQhBm3G4aQ0VbMb3eD0
	 q5Dju+IQgWLlYuXf0rQLrIk4w0MFYgycZ491vPaAODtGxUfNoNp1nftkZVkiUcWDiIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh+5No5Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD67606A322;
	Wed, 28 Oct 2026 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh+5No5Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179141F01825;
	Wed, 28 Oct 2026 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211866;
	bh=y0VoHttG9kmL5ShlKjJ57AQXyhulufrswW50b0FuFs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nh+5No5Q1MygvdUmu7q1NkYs5HU+6LNx46kybZMd07ulRGCD8Z7Os8Ex1HIS6F6Z0
	 t70m9buCdfbh4iMbnYLCERsSEVXphrfswPmJLxRgExkWTfitLXPmHHCWiZQww6L6Mr
	 LwRHCzBP/GNoaVwAo87KNYEcvHSs3TYhLqECjQ1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 529/571] tracing/histograms: Reject non-stacktrace fields for synthetic stacktrace fields
Date: Wed, 28 Oct 2026 18:01:16 +0100
Message-ID: <20261028170020.583160004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

commit a244c241593b5b38a08f0df2cb43c26574efbdcb upstream.

In check_synth_field(), when a synthetic event field is a stacktrace
(field->is_stack) and the histogram field is not a "long[" stacktrace
array, validation falls through to the generic size and signedness
comparison.

Because parse_synth_field() sets a stacktrace field's type to
"__data_loc unsigned long[]", its size is sizeof(u64) and
synth_field_signed() marks it as signed.  Consequently, any 8-byte
signed scalar histogram field passes the fallback check, and its scalar
value is subsequently dereferenced as a kernel stacktrace pointer in
get_field_size() and trace_stack().

Furthermore, checking strstr(hist_field->type, "long[") is insufficient
because tracepoint fields defined with __bitmask() or __rel_bitmask()
also have type "__data_loc unsigned long[]" or "__rel_loc unsigned
long[]", whilst create_hist_field() treats them as 4-byte scalar values
without HIST_FIELD_FL_STACKTRACE.

Propagate HIST_FIELD_FL_STACKTRACE to variable references and field
variables (whilst excluding variable aliases from per-element
stacktrace capture), and reject any mismatch between
HIST_FIELD_FL_STACKTRACE and field->is_stack in check_synth_field().

Cc: stable@vger.kernel.org
Fixes: 00cf3d672a9d ("tracing: Allow synthetic events to pass around stacktraces")
Link: https://patch.msgid.link/20261013112449.1006088-1-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[Lee: Omit create_var_field() and hist_trigger_elt_update() hunks as
      288709c9f3b0 ("tracing: Allow stacktraces to be saved as histogram
      variables") is not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1800,7 +1800,8 @@ static int init_var_ref(struct hist_fiel
 	ref_field->size = var_field->size;
 	ref_field->is_signed = var_field->is_signed;
 	ref_field->flags |= var_field->flags &
-		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
+		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS |
+		 HIST_FIELD_FL_STACKTRACE);
 
 	if (system) {
 		ref_field->system = kstrdup(system, GFP_KERNEL);
@@ -2812,6 +2813,7 @@ static struct field_var *create_field_va
 		ret =  -ENOMEM;
 		goto err;
 	}
+	var->flags |= val->flags & HIST_FIELD_FL_STACKTRACE;
 
 	field_var->var = var;
 	field_var->val = val;
@@ -3429,7 +3431,10 @@ static int check_synth_field(struct synt
 	    && field->is_dynamic)
 		return 0;
 
-	if (strstr(hist_field->type, "long[") && field->is_stack)
+	if (!!(hist_field->flags & HIST_FIELD_FL_STACKTRACE) != field->is_stack)
+		return -EINVAL;
+
+	if (field->is_stack)
 		return 0;
 
 	if (strcmp(field->type, hist_field->type) != 0) {


