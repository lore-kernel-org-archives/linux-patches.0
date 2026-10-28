Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207926;
	b=4u57iDo9vNwUez8OAXxz4oDyQipDDWHLIShO6E3inqaKUqqRU5jg4AEEsZWtSg/OnGi+
	 06S0Ap63BJ2fsLDLNO5l+MZhmmwRmKGC+QsLQTPmbbzTpaOs/WM0d3gGxkWItywzRmzmL
	 5tCZ8vGTkU/j7lUQbVla4tBMpf+36cB6Gm+AQ0aekkfScCzMB9BZAoqTkkbeC5OuMW4sE
	 Li5Om0pHCdUY14jKVmuuSGOl52HlHoHi5lD8ArShL9sYyQxGplpO/F5e5Kyh5Fnw1weXf
	 rNs+s5iOQjOfIACRbhOlm/RWWd+9M4Y5ryURsxBPExX1ufWmsb6X/P1DXHJ7HZMKvzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y/+Va4pp0fMvk3R7MY8CkpT3g2yoQXKI+fmktMZEA1Y=;
	b=EvKiKLS4tFiCYB0THKDifBq6Zi5v/lwCZG2Tj7l+He+C10hqmWs2eCNTKt7HM50EEFec
	 lZXYziMHQMSkr4d6jx1ZcfjgvyRiVOLXtgyJIq0I4d0HHXQvDMO+5aFbcxCvEDZ/xLsqV
	 THwAvNbcSgK5onEt10omonGhQFy3eOuM5T4HR9+slLSuqq5pf2JAD6fa1d/4EaP/q1xy3
	 Agtxmn50LwdVrvD9o5bQSUqGvJeDLVA+tRCYwwAy5xNUGm4/bh0OeiSh5ASM0FzOcHHau
	 qe2sJnVFoPYf76O/CYRX27190BBhkR5uWWJBl1BMzLUV5OdKImZ/so0AofczFo/z8Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIkGkoT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A76606A325;
	Wed, 28 Oct 2026 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIkGkoT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E101F01828;
	Wed, 28 Oct 2026 17:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207926;
	bh=y/+Va4pp0fMvk3R7MY8CkpT3g2yoQXKI+fmktMZEA1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIkGkoT7FdMRJHcnpvtmi/JlS8AXfriCdha12I7+GBBrXPVxKlgiMNonDgHsv+dJQ
	 qia1KU+SwCX3Iuknfy293ikZSwsjrjpd3JpgInecpTr+hIfBgOrnArSGd7gvthB0q0
	 5tYAcUX0PahCG+bwsIymmNSlL8U0xD3CQCXM5u1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 189/247] tracing: Unregister field variable histograms when the command fails
Date: Wed, 28 Oct 2026 17:59:52 +0100
Message-ID: <20261028165951.894449201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -3093,20 +3093,18 @@ create_field_var_hist(struct hist_trigge
 
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
 
@@ -6915,6 +6913,8 @@ static int event_hist_trigger_parse(stru
 
 	trigger_data_free(trigger_data);
 
+	unregister_field_var_hists(hist_data);
+
 	destroy_hist_data(hist_data);
 	goto out;
 }


