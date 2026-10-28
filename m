Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209466;
	b=RN3NcDBa6/3rYLSyiI1zPVhFLzcFXF8UDl/EFpK0Rxc4p9FqTkq6/4HziXCHRWD/AvjQ
	 n20M6uU0NNCxRPLF/eMKsL9p0LZJ1uVH6kzs0nh+kn7XxnbBwQraqq0CV+qkfHmWzYVP2
	 HEvTbXj0cjzyus0s6fooR/EWrgOGp5MVmCuX8ml5jTs5lGoz9OoPbdkwj7fsRANh4PsCH
	 lTfzTpFHLpnhAiApPXVRWiYTS04ALCUGmcRf7qSl1CwEdXvOJfcK/ElgkrKlAy88U02Fv
	 Za6vf8JyNfUg/v8ZMuvGxuM3prOvY/FvIEbLosyRoRovTgmYq/rx3sTwMgtdDoPHD6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NPYWw1YBe1iTCMIuO9ZrbIo5VPlFZNfTQrFo9DGCmdc=;
	b=vw0bG4pWTZfl0oBZvAqLhCewGpLNtjftzK4i5A3RcTjOpKjE05WI4dR1Ap9lu97g6Wbi
	 uYdgdiGO1QXCI8T+gLSLsyxFPJ15bp0fXRGZp0AfhlPJyeehyCO/6liUM8u1ifODchF3C
	 eGif7ZlzrSMJRGnnFY7qrks5bANUtNu3CSDDdSEJx9by1FgjJFg96bV3obzwUVdJV5kaH
	 VWEojq7j3O64bi6gONGyYmE9WQNRcBHSkhM55MWn6PzpOtjmioS9SR32UFYHNsDXcR4Wu
	 JItpqOWCUjSi5/7/0FBLfIsb5sefSejnbgHqsEE2wOMJYaLS9KsicZHV8S21+7vVsAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiJi9d8a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907DF606A31A;
	Wed, 28 Oct 2026 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiJi9d8a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFC11F01825;
	Wed, 28 Oct 2026 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209466;
	bh=NPYWw1YBe1iTCMIuO9ZrbIo5VPlFZNfTQrFo9DGCmdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiJi9d8as65e1v1QLXROzIIhGnlbYV7EVxL0Ire7UNSBorYRSNhPkkHQymn3YJO1M
	 pnEroNK4mXuar1xqBLTfvofvOBaqac/y9c4Nv8BIBNhgX0DckORQYfzBXpJSfBn2pK
	 R+rfcwYGEWHAav9apqsK2FaWSB7bI4ylaNZGZu2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 482/516] tracing/histograms: Reject non-stacktrace fields for synthetic stacktrace fields
Date: Wed, 28 Oct 2026 18:00:34 +0100
Message-ID: <20261028170014.898133962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1751,7 +1751,8 @@ static int init_var_ref(struct hist_fiel
 	ref_field->size = var_field->size;
 	ref_field->is_signed = var_field->is_signed;
 	ref_field->flags |= var_field->flags &
-		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
+		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS |
+		 HIST_FIELD_FL_STACKTRACE);
 
 	if (system) {
 		ref_field->system = kstrdup(system, GFP_KERNEL);
@@ -2743,6 +2744,7 @@ static struct field_var *create_field_va
 		ret =  -ENOMEM;
 		goto err;
 	}
+	var->flags |= val->flags & HIST_FIELD_FL_STACKTRACE;
 
 	field_var->var = var;
 	field_var->val = val;
@@ -3354,7 +3356,10 @@ static int check_synth_field(struct synt
 	    && field->is_dynamic)
 		return 0;
 
-	if (strstr(hist_field->type, "long[") && field->is_stack)
+	if (!!(hist_field->flags & HIST_FIELD_FL_STACKTRACE) != field->is_stack)
+		return -EINVAL;
+
+	if (field->is_stack)
 		return 0;
 
 	if (strcmp(field->type, hist_field->type) != 0) {


