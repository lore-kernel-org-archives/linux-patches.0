Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D10127B70;
	Tue, 30 Apr 2024 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473782; cv=none; b=shYtFSk3ETRic2Oh0OqZkw+Ubiti7OpyZtbc4S+gYo4Fb4Ovn5Rp8QrO9jlyyzswdgjKmcHwfaAkahg80fgKxuaiuOS/g3drKW5YI61C4wcblUvB8LCwfXrrUl3Ysre4EE5z//iyFGj9BBefAjvHpaiy4GIEFQAa1CsfP/aC1dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473782; c=relaxed/simple;
	bh=kb/hTpWciQV7sh/kaX9X8fy8d2xJAKOTo2aRweUeomA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfwEE2fdKj/GMsS+XnRKuL2924parcKvbZIFdOLygqIC2jehEhB4be7m8Enl92YSNz95o996JsFeWb6jmDWZ5IFKmjiDO+hH6Y/ri9M/wCjsoEQD6bBjD1msMQqg9cYHmI8wrXmIUTkvVbc+klt+p0fZPmTGvO5uLewCE9s0gRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpSeRItx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpSeRItx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9544DC2BBFC;
	Tue, 30 Apr 2024 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473782;
	bh=kb/hTpWciQV7sh/kaX9X8fy8d2xJAKOTo2aRweUeomA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpSeRItxt1qO63oyXLUqqPVyrWVro1bLJNjRFU8JvMfvSjDS/QFns320h0mtKjFZI
	 6Lb/jkkHRTcaZgn70zogHgLLv5J2CyMkqnSg1I5vxH8+6VFq4aGM3dC+VK5r/84XuS
	 MsYQRcL0q6qIuBLJYTefp+aBZX6C+/K+EnE/0/ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 36/77] tracing: Remove hist trigger synth_var_refs
Date: Tue, 30 Apr 2024 12:39:15 +0200
Message-ID: <20240430103042.198391759@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Zanussi <tom.zanussi@linux.intel.com>

commit 912201345f7c39e6b0ac283207be2b6641fa47b9 upstream.

All var_refs are now handled uniformly and there's no reason to treat
the synth_refs in a special way now, so remove them and associated
functions.

Link: http://lkml.kernel.org/r/b4d3470526b8f0426dcec125399dad9ad9b8589d.1545161087.git.tom.zanussi@linux.intel.com

Acked-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -280,8 +280,6 @@ struct hist_trigger_data {
 	struct action_data		*actions[HIST_ACTIONS_MAX];
 	unsigned int			n_actions;
 
-	struct hist_field               *synth_var_refs[SYNTH_FIELDS_MAX];
-	unsigned int                    n_synth_var_refs;
 	struct field_var		*field_vars[SYNTH_FIELDS_MAX];
 	unsigned int			n_field_vars;
 	unsigned int			n_field_var_str;
@@ -3708,20 +3706,6 @@ static void save_field_var(struct hist_t
 }
 
 
-static void destroy_synth_var_refs(struct hist_trigger_data *hist_data)
-{
-	unsigned int i;
-
-	for (i = 0; i < hist_data->n_synth_var_refs; i++)
-		destroy_hist_field(hist_data->synth_var_refs[i], 0);
-}
-
-static void save_synth_var_ref(struct hist_trigger_data *hist_data,
-			 struct hist_field *var_ref)
-{
-	hist_data->synth_var_refs[hist_data->n_synth_var_refs++] = var_ref;
-}
-
 static int check_synth_field(struct synth_event *event,
 			     struct hist_field *hist_field,
 			     unsigned int field_pos)
@@ -3884,7 +3868,6 @@ static int onmatch_create(struct hist_tr
 				goto err;
 			}
 
-			save_synth_var_ref(hist_data, var_ref);
 			field_pos++;
 			kfree(p);
 			continue;
@@ -4631,7 +4614,6 @@ static void destroy_hist_data(struct his
 	destroy_actions(hist_data);
 	destroy_field_vars(hist_data);
 	destroy_field_var_hists(hist_data);
-	destroy_synth_var_refs(hist_data);
 
 	kfree(hist_data);
 }


