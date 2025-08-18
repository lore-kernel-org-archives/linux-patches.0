Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1253D335BD5;
	Mon, 18 Aug 2025 13:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523666; cv=none; b=Fu4eyTpVGyExzwxgxkIOyw3xAOafTC3HFwa8RZYy3a6D8nF+ElmWa1p5nhmjvDUxpfM3nMOgIHqk6aCABUXbgYKcy7x+wINVTHKutFNXNaEfos467nVo84KZ85jmQtCQyXplVvGJLyMdI8lodLp3jEcy7/5qkjD0MuYkpgAbyoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523666; c=relaxed/simple;
	bh=6V36/dDB7p3DtZTgN6FKaBaQeDQSKykWbXARyMcYAmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFxBHa839z5rO+fDu43QMZRtD+YmVlVyT0GcwHrWGjWHwGsdlP/soo2MopYmiEz2qFn6ghsbJjfTnoOyrNDLHvNkI45LKyDg5A9ZHzOTkpmgHN8U0H9bnm4ax4j+Uml4I+mLSZvt4pHkKUMnnyAStHjonvz1zNF7nqwbfIog+/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePBttVoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePBttVoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B2DC4CEEB;
	Mon, 18 Aug 2025 13:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523665;
	bh=6V36/dDB7p3DtZTgN6FKaBaQeDQSKykWbXARyMcYAmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePBttVoR1eI0K7BTvMdpaLq9Oz/dDpEkeTnSRMEDLfABc+kKMdgX7K1cTbNB2oD+s
	 FfreWA/cg88pjDa0RSAIu9OTLZr6h5OyxUQsrtb8l2TuBPXpmRr9tzzov6i77TxtGp
	 Zf+HttFW2rzXJ0Cjo81FYu6sFqw9OKZxZ8l5FE6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Nam Cao <namcao@linutronix.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 241/515] rv: Add #undef TRACE_INCLUDE_FILE
Date: Mon, 18 Aug 2025 14:43:47 +0200
Message-ID: <20250818124507.664509924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 2d088762631b212eb0809e112642843844ef64eb ]

Without "#undef TRACE_INCLUDE_FILE", there could be a build error due to
TRACE_INCLUDE_FILE being redefined. Therefore add it.

Also fix a typo while at it.

Cc: John Ogness <john.ogness@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/f805e074581e927bb176c742c981fa7675b6ebe5.1752088709.git.namcao@linutronix.de
Reviewed-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/rv/rv_trace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/rv/rv_trace.h b/kernel/trace/rv/rv_trace.h
index 422b75f58891..99c3801616d4 100644
--- a/kernel/trace/rv/rv_trace.h
+++ b/kernel/trace/rv/rv_trace.h
@@ -129,8 +129,9 @@ DECLARE_EVENT_CLASS(error_da_monitor_id,
 #endif /* CONFIG_DA_MON_EVENTS_ID */
 #endif /* _TRACE_RV_H */
 
-/* This part ust be outside protection */
+/* This part must be outside protection */
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
 #define TRACE_INCLUDE_FILE rv_trace
 #include <trace/define_trace.h>
-- 
2.39.5



