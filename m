Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E042AF07;
	Mon, 28 Oct 2024 06:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098462; cv=none; b=R7A4BRZ9ibaRrh9hQiw0wVMmr5isyoD2KX2tlxFdRhTwoCGiT+s15i0Z1KcYkzQQ5nqAsPm5tLq3YgFT9021lBWxBa1Lt7vsLFlV7Gw3fn1FTl1ewKVY+6iYTkuztKiDh6Vloh4+EQdfhGRqGFpCdGxr5HhJBH60n9F8gfq+XPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098462; c=relaxed/simple;
	bh=SuTpHmX6G3XYhQztPJVPFVGiKEM88DsUP9VOcJhPk/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbVYk0Yql66HUZhlfwYy+uF53LAvuK015uVGkAn5ld/XwiYn0L77uDFKvNYvotktQe5Wag8dwKfrwL7UvbNwBcbT2/epWhamS3EoW8U8hKr8+hcYXgckeAOuP6EewHrMFVg/+eGeT5rGAUu2n3AeOdWUqLTHjaDlD+OH7Y4FYPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aU5m4/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aU5m4/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A52C4CEC3;
	Mon, 28 Oct 2024 06:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098462;
	bh=SuTpHmX6G3XYhQztPJVPFVGiKEM88DsUP9VOcJhPk/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0aU5m4/IdTnDAfzdSl3VYTE3ZbZUZaZpza2FgFbI0pnbivdyysyY98yJgQO/0sVSb
	 lF+f70UKOn2Yjh5erPU+ciBqu9V70x0hG1GgWyMKX/ksduixYZliVo5bl29xDRBtN2
	 PcaGoaiyN3ZfxkShroj8ij5RY+taAN1b1ZTluSvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 237/261] fgraph: Change the name of cpuhp state to "fgraph:online"
Date: Mon, 28 Oct 2024 07:26:19 +0100
Message-ID: <20241028062318.058301006@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit a574e7f80e86c740e241c762923f50077b2c2a30 ]

The cpuhp state name given to cpuhp_setup_state() is "fgraph_idle_init"
which doesn't really conform to the names that are used for cpu hotplug
setups. Instead rename it to "fgraph:online" to be in line with other
states.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/20241024222944.473d88c5@rorschach.local.home
Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 2c02f7375e658 ("fgraph: Use CPU hotplug mechanism to initialize idle shadow stacks")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fgraph.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index cd1c2946018c8..69e226a48daa9 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1255,7 +1255,7 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 	guard(mutex)(&ftrace_lock);
 
 	if (!fgraph_initialized) {
-		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "fgraph_idle_init",
+		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "fgraph:online",
 					fgraph_cpu_init, NULL);
 		if (ret < 0) {
 			pr_warn("fgraph: Error to init cpu hotplug support\n");
-- 
2.43.0



