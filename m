Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF8213C90B;
	Tue, 25 Jun 2024 10:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309757; cv=none; b=ZTVnIEViFV0156mcrCVgsK//OLd3YCs815T5Lmne/N+3A9g9pInPMHXN0d2uPSYt8TZNNtkTD5sGfe2PJAThuj94x3QKwzghPJU1BRiupG+uF7rybqvYqF4rpElRWnT8S6AJArCm/OrnSq2uAxnC41OhNixaKM3UE5S6lIyWqQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309757; c=relaxed/simple;
	bh=FIJJ+s3979M8KKir29EjRJ33aD8FKUSIkBdPqQd//iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtL+ZWLSjelBdfF2WEHco8iBfgDqEIiqkpFUUpf7+lbMkn1NjWpiWWjgRIJQLQas/TIaTt4dpzLM4/3C9oBEdAt0IMFeeAfZ2P8oKnxQTaitjZnldCkLz4OKTAP6zah7W9v7HLHTilGcznhFRlFL3cCorJCesWqPHv+Lld0bUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH7nIStM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH7nIStM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619DCC32781;
	Tue, 25 Jun 2024 10:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309756;
	bh=FIJJ+s3979M8KKir29EjRJ33aD8FKUSIkBdPqQd//iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CH7nIStM9tpm6gn6b0KFqaUPHWJpR7fE9cy34sndXFokDFN7sj087oIsNPaKGl38e
	 Mq44BObMVYd6XQ06uFzN1x9i2Zw6gFGYqDK7BCUe8SPU6iDHv0snsWVv1FH1aL2gG+
	 rwDV96+UNG6/ETuTjvhApQXIka+L+sz/FPjrhU+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/131] tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test
Date: Tue, 25 Jun 2024 11:34:38 +0200
Message-ID: <20240625085530.610658125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit 23748e3e0fbfe471eff5ce439921629f6a427828 ]

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/trace/preemptirq_delay_test.o

Link: https://lore.kernel.org/linux-trace-kernel/20240518-md-preemptirq_delay_test-v1-1-387d11b30d85@quicinc.com

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: f96e8577da10 ("lib: Add module for testing preemptoff/irqsoff latency tracers")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/preemptirq_delay_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index 8c4ffd0761624..cb0871fbdb07f 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -215,4 +215,5 @@ static void __exit preemptirq_delay_exit(void)
 
 module_init(preemptirq_delay_init)
 module_exit(preemptirq_delay_exit)
+MODULE_DESCRIPTION("Preempt / IRQ disable delay thread to test latency tracers");
 MODULE_LICENSE("GPL v2");
-- 
2.43.0



