Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212013;
	b=KMqzwWtHz991qnhiLawkqgL1yB6l0wST7scU2MZ/F1xm/IsLFIKFdCTX+4YbABFo6yj+
	 6bcfVkSWpKEMBwFs+91+P7g/ibh1iJSmAxwwNW+my5MjUajdqMGLhAFF+NekkcbCCv7gc
	 ByKN6vHeQW+A95Socx2Lu4oFZj7mP3sLfe/Pkc6/eI7Lmm5vWxRQb7FN5ppAcTfo4MQ+i
	 6htFNGW8+1ROZDt7tN1D8fqzMl40KzAAVyD3L0VAk1gARshGV4P+FcUtH+lM+9iCOjT4x
	 sH1FdKIO2hDpMssVYmCYLcZuFwfaV0AIVy07qvODqAIIWLxrHiaThsCw/aM/LEBBpkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yGKwAPGzanb6Zsh+woF8PWStn2Qe9I/vkKxeRrh9JNM=;
	b=vKw91nAz3ng/Opbr5DQ58OZKC/462gV47svMj8uCL7XFMyjv2P6CfCr7/h+IeV9KhzBa
	 UArkcnzBaqFVa0q17cQufzcXmWleGXNs6ToA8Iw/5STkIRugyVDDh8qCZA74gJtAwJMUS
	 eg7Inet1Mz+tJ3k34fnG8TElVZlfC8wTZcpwj6qZ9dasYhG+cB/UMbK08FLKkdQpxw2IR
	 4EUspUZiytmrq6JxTNc8ClW3g2Xt1pYP4n3xRMJBMxbT5ZlWc4bHr/EMuP0/LqYj8Cg+L
	 8H2WeUoFfFHDAkS0uH5SQYXM4RyK4qSXoGL9OmH8wZzO8ot/9Adqkt3NDfF159QVqhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZZKzEjh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A579F606A31A;
	Wed, 28 Oct 2026 18:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZZKzEjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AA31F01825;
	Wed, 28 Oct 2026 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212012;
	bh=yGKwAPGzanb6Zsh+woF8PWStn2Qe9I/vkKxeRrh9JNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZZKzEjhTjuMROgGmHjF62H+Hbf25NlgaNMuf6Q1ZEC8PhVoQ5OgngI4UT9YfLGKA
	 MjnM4HDq9qChBA2/2owN4ucavK/awQ6pumiEjd6ytLXEyAn8o4dLtw3MIlkyUruz68
	 3k0a+jmj292tABjIvi65piMgNNqzvPjFijmyPFps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 559/571] tracing: Save the event file instead of the compatible histogram
Date: Wed, 28 Oct 2026 18:01:46 +0100
Message-ID: <20261028170021.299703218@linuxfoundation.org>
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

commit d5c42664fc094899af9aae5300b27fe8fdb658ef upstream.

create_field_var_hist() creates a histogram on the matched event to
supply a field variable, and records it on the target so it can be torn
down later:

	hist_data = find_compatible_hist(target_hist_data, file);
	...
	/* Save the compatible histogram information */
	var_hist->hist_data = hist_data;

hist_data is not the histogram it creates. It is one that was already
there, whose keys the new one copies. The saved pointer has a single
user, unregister_field_var_hists(), which runs when the target is
removed:

	file = hist_data->field_var_hists[i]->hist_data->event_file;

find_compatible_hist() matches on keys alone, so it can pick one with no
variables of its own. check_var_refs() then returns false and the user
can remove it while the target still points at it:

 BUG: KASAN: slab-use-after-free in event_hist_trigger_free+0x2b2/0x320
 Read of size 8 at addr ffff8880093b90e0 by task init/1

 Freed by task 1:
  kfree+0x154/0x420
  event_hist_trigger_free+0x1d5/0x320
  event_hist_trigger_parse+0x35f3/0x69e0
  trigger_process_regex+0x1a6/0x250

Save the event file instead. It is all the dereference ever wanted, and
it does not go away when the user removes a trigger.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260914110753.221E61F000FF@smtp.kernel.org/
Link: https://patch.msgid.link/20260914234754.3676905-1-donggeunyoo.kernel@gmail.com
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Acked-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -372,7 +372,7 @@ struct field_var {
 };
 
 struct field_var_hist {
-	struct hist_trigger_data	*hist_data;
+	struct trace_event_file		*file;
 	char				*cmd;
 };
 
@@ -2618,8 +2618,8 @@ create_field_var_hist(struct hist_trigge
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* Save the compatible histogram information */
-	var_hist->hist_data = hist_data;
+	/* Needed to remove the histogram when the target goes away */
+	var_hist->file = file;
 
 	/* Create the new histogram with our variable */
 	ret = event_hist_trigger_func(&trigger_hist_cmd, file,
@@ -5404,7 +5404,7 @@ static void unregister_field_var_hists(s
 	int ret;
 
 	for (i = 0; i < hist_data->n_field_var_hists; i++) {
-		file = hist_data->field_var_hists[i]->hist_data->event_file;
+		file = hist_data->field_var_hists[i]->file;
 		cmd = hist_data->field_var_hists[i]->cmd;
 		ret = event_hist_trigger_func(&trigger_hist_cmd, file,
 					      "!hist", "hist", cmd);


