Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044030;
	b=407L9ChX2vzcL6dwHfbDq2sVEEueDM1Y//ClS/IJLDXgJcvDGfRNMbRKwlStUhVKtssj
	 koRg1xyG4JiiFoORwq4MB2XRpNPSM0XLqOeViD5M98y1EryQkiFtD8/qjBUrHbrOoFvw+
	 27pjiqLW0kunP1UAXalirJDJBSJl4DFEINzVYETXMBdni1xNV9ZwpAhZ+sNpZe39CU5lw
	 ROUYJ3puadz82DqAGAWOSe9Fy0jJuFfLEtURNBKbKFU1mNezyYe2IdnfK5lFKSM8xA5h2
	 oFI9wr0lrMxBM9uj5A/IZKcWJngh0pvQrnowwF3/2K43uFkP4/04nVDjU+XCG+GGxHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JShibXonc5tc8iG2Bn1QmO6NBM+aN0N7+xhNYSkkNo8=;
	b=00eOEmpkhW+hj0E11NyXkgTUyuGaDXrrOf2N28WU2NT8fXu9ooXX/x7sRw6ZvIlY/gN+
	 MyofC+UwS0B5tn50IJLKcsMh1A3cT/wHCuFvAfvjuX7vYSKCbOr9zxFXF2v8OCqkoqohu
	 hG2tT+FnrvzRZF0HeYjB5ZKwmA4Dk2tXsnmiujxEp5kT2lYqSMAQXZGZ1GjZRb6r+g9Gx
	 4G0kTS8HJ7rfBYiJyDF/uiBhoe22DKV0q7pZ9iAIV3PoMEzneIy0q2d0oxzgRNwLxwz3p
	 xTu5BDjBa4L/HJcJkE5iBR6xYQlqdMhxDJcqsQ1Kz8BaFrn03aUGxOkhiD4mYSVJg8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiFMnMgF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F8B606A31C;
	Wed, 18 Nov 2026 23:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiFMnMgF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171E71F000C4;
	Wed, 18 Nov 2026 23:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044030;
	bh=JShibXonc5tc8iG2Bn1QmO6NBM+aN0N7+xhNYSkkNo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wiFMnMgFUARscx54C5Kqiq4jKEgwTYSuMFafSQq3V8Jv2QqbW6Vxxo5HGelzjYkjR
	 fughzCsQbZ3GcJGDVlnPqJwxzk4I/XsU8kTBo02oufVTalvGP1Z+I0ookOim/z52Kn
	 rwFuYT0mYI6wChPN86Y0Uth8jK0fXYuIhQBct7ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0423/2857] tracing: Undo the registration when enabling the histogram trigger fails
Date: Wed, 18 Nov 2026 15:24:17 +0100
Message-ID: <20261118150216.616229478@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 92383cef66791a0c63a2f27755cadbdb2fbf270b ]

Commit 6f86bdeab633 ("tracing: Fix bad hist from corrupting named_triggers
list") described how a trigger that is registered but not on file->triggers
ends up freed while still on the global named_triggers list, and moved the
registration down so that hist_trigger_enable() follows it immediately. One
path still gets there. hist_trigger_enable() adds the trigger and takes it
straight back out when the event cannot be enabled:

	list_add_tail_rcu(&data->list, &file->triggers);

	update_cond_flag(file);

	if (trace_event_trigger_enable_disable(file, 1) < 0) {
		list_del_rcu(&data->list);
		update_cond_flag(file);
		ret--;
	}

so the list walk in hist_unregister_trigger() matches nothing, test stays
NULL, and the ->free() that would call del_named_trigger() is skipped.
out_unreg falls through to out_free, which frees the trigger anyway:

 BUG: KASAN: slab-use-after-free in find_named_trigger+0xac/0xc0
 Read of size 8 at addr ffff8880091d3160 by task init/1
  find_named_trigger+0xac/0xc0
  hist_register_trigger+0xc1/0xa00
  event_hist_trigger_parse+0x3146/0x6af0
  event_trigger_write+0xce/0x160
 Freed by task 69:
  kfree+0x154/0x420
  trigger_kthread_fn+0xfd/0x160

Leave the trigger where hist_unregister_trigger() can find it and let that
undo the registration, which is the only code that knows all of what
cmd_ops->init() took: the named list entry, the hist_pad reference, the
reference on the trigger a named histogram is shared with, and the copied
cmd_ops. It also pairs the failed trace_event_trigger_enable_disable(),
whose sm_ref and buffered event reference are otherwise left behind.

Since ->free() releases trigger_data and, for a trigger that does not share
its histogram, hist_data with it, out_unreg can no longer fall through to
out_free. For a trigger that does share, hist_register_trigger() has
already destroyed the caller's hist_data, so the fall-through was reading
freed memory there as well.

Move the enable_timestamps check in hist_unregister_trigger() above the
->free() call for the same reason: hist_data does not outlive it once the
trigger being removed is the one that owns it.

Cc: stable@vger.kernel.org
Fixes: 067fe038e70f ("tracing: Add variable reference handling to hist triggers")
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-trace-kernel/20260907092944.3950E1F00A3D@smtp.kernel.org/
Link: https://patch.msgid.link/20260907124420.607097-3-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ sashal: Used test->ops->free instead of test->cmd_ops->free in hist_unregister_trigger(), since ->free lives in event_trigger_ops here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index e97369d462c00..a3b49b4b365aa 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6302,11 +6302,12 @@ static int hist_trigger_enable(struct event_trigger_data *data,
 
 	update_cond_flag(file);
 
-	if (trace_event_trigger_enable_disable(file, 1) < 0) {
-		list_del_rcu(&data->list);
-		update_cond_flag(file);
+	/*
+	 * On failure the caller undoes the registration, and
+	 * hist_unregister_trigger() can only find the trigger here.
+	 */
+	if (trace_event_trigger_enable_disable(file, 1) < 0)
 		ret--;
-	}
 
 	return ret;
 }
@@ -6384,13 +6385,13 @@ static void hist_unregister_trigger(char *glob,
 		}
 	}
 
-	if (test && test->ops->free)
-		test->ops->free(test);
-
 	if (hist_data->enable_timestamps) {
 		if (!hist_data->remove || test)
 			tracing_set_filter_buffering(file->tr, false);
 	}
+
+	if (test && test->ops->free)
+		test->ops->free(test);
 }
 
 static bool hist_file_check_refs(struct trace_event_file *file)
@@ -6590,6 +6591,8 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 	return ret;
  out_unreg:
 	event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
+	/* The unregister frees trigger_data, skip out_free */
+	goto out;
  out_free:
 	event_trigger_reset_filter(cmd_ops, trigger_data);
 
-- 
2.53.0



