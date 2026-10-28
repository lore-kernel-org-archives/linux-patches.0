Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211567;
	b=jJXr4E4grw9F/DAVtwWIOOnTv99crPBAHDC/joxfsTac1+mEz8BbUHmd7inuUnNr3x6s
	 X5IcBtiARVhNUKYRZC7VSGVLkFZ9/i3EfKl0FrDYNdp5scNkUGBlkrSd+grwPfEwjHH+z
	 ZJOD4J+p9YF5k+X/EXB4H2elVcCGsUiyJDZz98vUcDGtkuQVYN2yNPCQxtVnPRsIMbJPm
	 h624iiPJYKW+N5LAZ8OUiDzpg4OdqEgsuy2I3bE2QxLGZdVskJHZjN43pMQtcHuxs4zL3
	 cWJEBaKRW13tsDD80Q70QHlmbzCV0yEb6xro/W0WDC8mFgmndsw9dIs6HWGjDOEkp+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I17q1oKLVYL/q8vbFWRp847vc+wT8NOUiKXY7Pn+VLI=;
	b=lvCq/lPU5ZdQbhO2x7xMaNqPn2BhTpOTVqATozeIIIlTGnJNAK96AoKV2M7Sv9q9z0DG
	 g1EqhrnWvpAlTpJZLglvckh4NIxejUs5N33xrK3ky+vh+/yRiS06gxEGYDKlWL71av8ji
	 VupOlIZmi7dYUJ/qBrGFSVDyMGrLHCRL4grz9AfftpLe4sQj2qiowPat8CX1c4gePYU79
	 0y8QUFfq4tytLxJw1Dc9eAbSnUBSpiC/uxSam8xj/FhXTXl+CQievGB5UINxbCqIBQ5Ot
	 sG52FTqt2eGKb0JwE/1jWy4p/+pT0tsJMwdEelfEWkV8XT1oWBC1JUubBzY35BAMZFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gO0caLjb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505B3606A31A;
	Wed, 28 Oct 2026 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gO0caLjb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBB01F01825;
	Wed, 28 Oct 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211567;
	bh=I17q1oKLVYL/q8vbFWRp847vc+wT8NOUiKXY7Pn+VLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gO0caLjbnvP7wFE6Pu2Xsgcu0i5qAz7SO1x8At3+f46pt6SAtzpJ6m2KNFpInkLW9
	 /SIQ2x2EHs4utJRTa9dVfSGc2uvZusACeILTjX16qMEksIrawzJt+mfCu+MLnjdX+L
	 Gr0X+WKAWkgHadgToth1eW+4jlOgC6XHNiP68Sik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/571] tracing: Set the trace clock before registering the histogram trigger
Date: Wed, 28 Oct 2026 17:59:31 +0100
Message-ID: <20261028170018.076567853@linuxfoundation.org>
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

[ Upstream commit 6ede78d0563a2a3ae3e46f9c07cedb5d79645429 ]

hist_register_trigger() puts the trigger on the global named_triggers
list in cmd_ops->init(), and only then sets the trace clock:

	if (data->cmd_ops->init) {
		ret = data->cmd_ops->init(data);
		if (ret < 0)
			goto out;
	}

	if (hist_data->enable_timestamps) {
		ret = tracing_set_clock(file->tr, hist_data->attrs->clock);
		if (ret) {
			hist_err(tr, HIST_ERR_SET_CLOCK_FAIL, errpos(clock));
			goto out;
		}

The clock string is not checked anywhere before that call, so a named
trigger using common_timestamp with an unknown clock fails after it has
already become findable. event_hist_trigger_parse() then frees it
without taking it off the list, and the next lookup by name reads the
freed object:

 ~# cd /sys/kernel/tracing/events/sched/sched_switch
 ~# echo 'hist:name=foo:keys=common_pid:ts=common_timestamp:clock=bogus' > trigger
 bash: echo: write error: Invalid argument
 ~# echo 'hist:name=foo:keys=common_pid' > trigger

  BUG: KASAN: slab-use-after-free in find_named_trigger+0xac/0xc0
  Read of size 8 at addr ffff88800915d760 by task init/1
   find_named_trigger+0xac/0xc0
   hist_register_trigger+0xc1/0x900
   event_hist_trigger_parse+0x3146/0x6af0
   event_trigger_write+0xce/0x160
  Freed by task 63:
   kfree+0x154/0x420
   trigger_kthread_fn+0xfd/0x160

Set the clock before the trigger is registered, so that nothing which
can fail runs after it is published, the way commit 6f86bdeab633
("tracing: Fix bad hist from corrupting named_triggers list") moved the
registration below the rest of the setup.

tracing_set_filter_buffering() is reference counted, so the init failure
path has to drop the reference that the clock block now takes first.

Cc: stable@vger.kernel.org
Fixes: a4072fe85ba3 ("tracing: Add a clock attribute for hist triggers")
Link: https://patch.msgid.link/20260907091415.554535-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[Lee: Call data->ops->init(data->ops, data) as b052d70f7c9c ("tracing:
      Merge struct event_trigger_ops into struct event_command") and
      476705419518 ("tracing: Remove redundant trigger_ops params") are
      not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 69a7e83926a28..3105208e517c7 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5641,12 +5641,6 @@ static int hist_register_trigger(char *glob, struct event_trigger_ops *ops,
 		data->ops = &event_hist_trigger_named_ops;
 	}
 
-	if (data->ops->init) {
-		ret = data->ops->init(data->ops, data);
-		if (ret < 0)
-			goto out;
-	}
-
 	if (hist_data->enable_timestamps) {
 		char *clock = hist_data->attrs->clock;
 
@@ -5659,6 +5653,15 @@ static int hist_register_trigger(char *glob, struct event_trigger_ops *ops,
 		tracing_set_filter_buffering(file->tr, true);
 	}
 
+	if (data->ops->init) {
+		ret = data->ops->init(data->ops, data);
+		if (ret < 0) {
+			if (hist_data->enable_timestamps)
+				tracing_set_filter_buffering(file->tr, false);
+			goto out;
+		}
+	}
+
 	if (named_data)
 		destroy_hist_data(hist_data);
 
-- 
2.53.0



