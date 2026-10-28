Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211977;
	b=el9g1I01vqQzPH1wNU4OARncarIiOJwxv3/AheTZzQCxz+YgSVqbkp6gL/uom6gStCcJ
	 oSUrQfd5Bxi7t9FcNgdJCW6qI/laY8qvR9uxVkbOkWUkCQdM5+VV2m5MzeNXBQEcQ4ldJ
	 4U28IVYsKruexDnz3QMZ6daV674jo/iWyBpi4EFjyfElPpAbfRanNWusuK2x3ZmpCTwLG
	 FspzQp4IA9j4sfiJ6vKoMPnMvvvN/mcqr/XYbgu8oZ7y5gsZBnY7p9tgXzvWQaDWX6VTS
	 qC7O7bhqPGejtoDOlMilA7Yu6ELBaxz9TN/ob37cVuuaIw01o92L6TpcXDrUDNODVdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=747KpoAtOlTM+DZcTA8WT3eOFE9n6w8CthT6WbzCt7c=;
	b=T8TsWxtMl9afCIjwEmYu2K9aXJRTYzk15YTsZWShO6DZ7sR2OT+tYc3pmSFxS4qKmmpR
	 oPxD10EQaZCOQWk9R0Io9KjcJj6IfyPTQhB7LFNSZ6CweQCskLfdGXIpnOt0d0RtCcTbm
	 VcNmbCjYZKmcYzCtWav7s7dRqyqWrQmSA4EcQzbLpkzQsOtQ6sYXel/9ybAhDHaPWMkVF
	 c2PYRHkrgzfd3tadHI1MwSs1ppSFbIQFRLb9rscirRTA8PmF7eMg0prJ+5KrgzPU9A1ck
	 hkIfdi+t4AFk+A5ENXSHdT3O7ldHL/dPwgthoVxyYWwpY5Z7b+TH0QteN9+TUilfqfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsfYc5t8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A82606A31A;
	Wed, 28 Oct 2026 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsfYc5t8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65A11F01828;
	Wed, 28 Oct 2026 18:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211977;
	bh=747KpoAtOlTM+DZcTA8WT3eOFE9n6w8CthT6WbzCt7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsfYc5t8J63oDDtZ62RqlulhZlKmPTZAi38FzIog/iAF9FPHKQrRMZA9HACSO9lX6
	 Ly5C7sYC596aRNJl/pgcJu/fGxwNYDBoRYqhJq4k9DFTnlASuGgwabOtwGdqHA/+z1
	 jOEVEa1FiCKWENiK5CB8aTTad9GRqUiOTfOvsQE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 560/571] tracing: Unregister field variable histograms when the command fails
Date: Wed, 28 Oct 2026 18:01:47 +0100
Message-ID: <20261028170021.322797189@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 91c14d6c13096091c56304120aaa26e479130b8b upstream.

An action that names a field on another event needs that field as a
variable, so create_field_var_hist() registers a second hist trigger on
that event to provide it, and records it in
target_hist_data->field_var_hists[].

If a later part of the same command fails, create_actions() returns an
error and event_hist_trigger_parse() jumps to out_free. The write fails
with -EINVAL and sched_switch gets no trigger, but:

  # echo 'hist:keys=pid:ts0=common_timestamp.usecs' >> \
      events/sched/sched_waking/trigger
  # echo 'my_synth u64 lat; int a; int b' >> synthetic_events
  # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0:\
      onmatch(sched.sched_waking).my_synth($wakeup_lat,prio,nosuchfld)'\
      >> events/sched/sched_switch/trigger
  # cat events/sched/sched_waking/trigger
  hist:keys=pid:vals=hitcount:ts0=common_timestamp.usecs:sort=hitcount:size=2048:clock=global [active]
  hist:keys=pid:vals=hitcount:synthetic_prio=prio:sort=hitcount:size=2048 [active]

The second histogram is the one created for 'prio'. It is still active and
still counting.

out_free reaches destroy_field_var_hists(), which frees the
field_var_hists[] entries, but never unregister_field_var_hists(), which is
what removes the triggers and runs only from event_hist_trigger_free(). The
entry is freed and the trigger is left with nothing tracking it.

Unregister the field variable histograms in out_free as well, and record
each one as soon as its trigger is registered rather than after the lookup
that follows it, so no exit can leave a registered trigger untracked. The
entry then belongs to field_var_hists[] and is released by
destroy_field_var_hists(), so freeing it on that exit would be a double
free.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914104036.1768529-1-donggeunyoo.kernel@gmail.com
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260913204302.DB2551F000FF@smtp.kernel.org/
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2634,20 +2634,18 @@ create_field_var_hist(struct hist_trigge
 
 	kfree(cmd);
 
+	n = target_hist_data->n_field_var_hists;
+	target_hist_data->field_var_hists[n] = var_hist;
+	target_hist_data->n_field_var_hists++;
+
 	/* If we can't find the variable, something went wrong */
 	event_var = find_synthetic_field_var(target_hist_data, subsys_name,
 					     event_name, field_name);
 	if (IS_ERR_OR_NULL(event_var)) {
-		kfree(var_hist->cmd);
-		kfree(var_hist);
 		hist_err(tr, HIST_ERR_SYNTH_VAR_NOT_FOUND, errpos(field_name));
 		return ERR_PTR(-EINVAL);
 	}
 
-	n = target_hist_data->n_field_var_hists;
-	target_hist_data->field_var_hists[n] = var_hist;
-	target_hist_data->n_field_var_hists++;
-
 	return event_var;
 }
 
@@ -5996,6 +5994,8 @@ enable:
 
 	kfree(trigger_data);
 
+	unregister_field_var_hists(hist_data);
+
 	destroy_hist_data(hist_data);
 	goto out;
 }


