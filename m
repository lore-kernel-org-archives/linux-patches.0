Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597F92ECE8A;
	Tue, 17 Jun 2025 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174830; cv=none; b=jAw4Thc5sSqhwlnQZp/ieaLUt+9CzMb/bnni0EBiBQB/bvVX4ZL4dAryoU6tvHbNWQ2dLneks3YCJdz55E8yCjYhSes1QcHD3fpRV9uXF1Y2wHuGnYsNv6SQECNuqX/PWzyMbIKYm2taoZ/hny+qZ1Wk0F1+jG/GwLqbGy64v9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174830; c=relaxed/simple;
	bh=hl/6G8HslsznIIFdLFS3GdlW1afyPwI54NuaKXrM038=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqj1lSLRgyMjp+Ai+juEXd3B3cDcO14/QNw2PN6hNRl+OGTYMR+UlTGYe+mVFQzYXW1qnPQDsXnDhv3+dqFlpL72bYSwkPFDr/VRcriPdYrkJmHJoYQq8BN0Ywgq+cMCl+hBvL2icztlj96LB0eA9K5jKsHmPtS/BnZh41FDMYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qidDkMjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qidDkMjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4578C4CEE3;
	Tue, 17 Jun 2025 15:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174830;
	bh=hl/6G8HslsznIIFdLFS3GdlW1afyPwI54NuaKXrM038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qidDkMjB8o9rWQvt+i6OiSEEjEKgLYYlHfrFvTW0vf3du6PggAMPGrJPrCVCGKhxg
	 0qTXL3EMnv4YmWGdijm5OMjw5q3dBgK/Xox+ZulbHu9Edm55rlg8UPiqrC3LaxDrcH
	 79x06LGTD9XOKKQDaGiLluG670SI4du2xEGG6zuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/356] tracing: Rename event_trigger_alloc() to trigger_data_alloc()
Date: Tue, 17 Jun 2025 17:23:52 +0200
Message-ID: <20250617152342.936923372@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit f2947c4b7d0f235621c5daf78aecfbd6e22c05e5 ]

The function event_trigger_alloc() creates an event_trigger_data
descriptor and states that it needs to be freed via event_trigger_free().
This is incorrect, it needs to be freed by trigger_data_free() as
event_trigger_free() adds ref counting.

Rename event_trigger_alloc() to trigger_data_alloc() and state that it
needs to be freed via trigger_data_free(). This naming convention
was introducing bugs.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://lore.kernel.org/20250507145455.776436410@goodmis.org
Fixes: 86599dbe2c527 ("tracing: Add helper functions to simplify event_command.parse() callback handling")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.h                |  8 +++-----
 kernel/trace/trace_events_hist.c    |  2 +-
 kernel/trace/trace_events_trigger.c | 16 ++++++++--------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index faf892aecdf49..e3afb830fbcc7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1643,6 +1643,9 @@ extern int event_enable_register_trigger(char *glob,
 extern void event_enable_unregister_trigger(char *glob,
 					    struct event_trigger_data *test,
 					    struct trace_event_file *file);
+extern struct event_trigger_data *
+trigger_data_alloc(struct event_command *cmd_ops, char *cmd, char *param,
+		   void *private_data);
 extern void trigger_data_free(struct event_trigger_data *data);
 extern int event_trigger_init(struct event_trigger_data *data);
 extern int trace_event_trigger_enable_disable(struct trace_event_file *file,
@@ -1669,11 +1672,6 @@ extern bool event_trigger_check_remove(const char *glob);
 extern bool event_trigger_empty_param(const char *param);
 extern int event_trigger_separate_filter(char *param_and_filter, char **param,
 					 char **filter, bool param_required);
-extern struct event_trigger_data *
-event_trigger_alloc(struct event_command *cmd_ops,
-		    char *cmd,
-		    char *param,
-		    void *private_data);
 extern int event_trigger_parse_num(char *trigger,
 				   struct event_trigger_data *trigger_data);
 extern int event_trigger_set_filter(struct event_command *cmd_ops,
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 29fcd8787344f..88985aefb71ff 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6806,7 +6806,7 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 		return PTR_ERR(hist_data);
 	}
 
-	trigger_data = event_trigger_alloc(cmd_ops, cmd, param, hist_data);
+	trigger_data = trigger_data_alloc(cmd_ops, cmd, param, hist_data);
 	if (!trigger_data) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 2c233c0d38fa9..4c92def8b1143 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -809,7 +809,7 @@ int event_trigger_separate_filter(char *param_and_filter, char **param,
 }
 
 /**
- * event_trigger_alloc - allocate and init event_trigger_data for a trigger
+ * trigger_data_alloc - allocate and init event_trigger_data for a trigger
  * @cmd_ops: The event_command operations for the trigger
  * @cmd: The cmd string
  * @param: The param string
@@ -820,14 +820,14 @@ int event_trigger_separate_filter(char *param_and_filter, char **param,
  * trigger_ops to assign to the event_trigger_data.  @private_data can
  * also be passed in and associated with the event_trigger_data.
  *
- * Use event_trigger_free() to free an event_trigger_data object.
+ * Use trigger_data_free() to free an event_trigger_data object.
  *
  * Return: The trigger_data object success, NULL otherwise
  */
-struct event_trigger_data *event_trigger_alloc(struct event_command *cmd_ops,
-					       char *cmd,
-					       char *param,
-					       void *private_data)
+struct event_trigger_data *trigger_data_alloc(struct event_command *cmd_ops,
+					      char *cmd,
+					      char *param,
+					      void *private_data)
 {
 	struct event_trigger_data *trigger_data;
 	struct event_trigger_ops *trigger_ops;
@@ -994,7 +994,7 @@ event_trigger_parse(struct event_command *cmd_ops,
 		return ret;
 
 	ret = -ENOMEM;
-	trigger_data = event_trigger_alloc(cmd_ops, cmd, param, file);
+	trigger_data = trigger_data_alloc(cmd_ops, cmd, param, file);
 	if (!trigger_data)
 		goto out;
 
@@ -1787,7 +1787,7 @@ int event_enable_trigger_parse(struct event_command *cmd_ops,
 	enable_data->enable = enable;
 	enable_data->file = event_enable_file;
 
-	trigger_data = event_trigger_alloc(cmd_ops, cmd, param, enable_data);
+	trigger_data = trigger_data_alloc(cmd_ops, cmd, param, enable_data);
 	if (!trigger_data) {
 		kfree(enable_data);
 		goto out;
-- 
2.39.5



