Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A5C185E68;
	Wed,  3 Jul 2024 10:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004166; cv=none; b=bWoh2azO/m0792ssIR3hq2ccSeZBwgTCbbJQJrpn9cag/P7NVrNMIfKfignB3YFbL9bSqdn3lkm9VakrQUmaaqUw2QnYGMVgHwTkrlA+vY5fagW04f90SlD3xxgn8fpf0m4Ub4oTdfZWyZsrI/OvmwX4SYL/u8rSDEdLwzNdqw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004166; c=relaxed/simple;
	bh=obetsHjYY1zOtJiXj2MBBFqr69bQ954hvvGQd4+jHo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpdbNigKdQ1s4kogz400onZVWqzBNRfzSCVOowczmI+FIVjY+A68TWke1kZu8GDgwvU7ZpS80h5D2JBVt19gmX1DSJOhAe7pWgnqXBFrqCe9/NNkFanstqWk0Brpugb5l0izlaFCCy4qWv6mZ82G5XpSm0rTpwLU11QAnkk+csM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhrLPkSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhrLPkSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAA4C4AF0D;
	Wed,  3 Jul 2024 10:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004166;
	bh=obetsHjYY1zOtJiXj2MBBFqr69bQ954hvvGQd4+jHo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhrLPkSY09kFqmVN6xkKy76+sgEcKiJHbOOpJpJcIemFQFTQv2zL5WaJPi6oM8JIZ
	 PUVnCdH8uxjTm2DX4RM6TNilPUHbeeirhxzw4lEti1IHHH9say3WkxVQcwfc0KDqPZ
	 GQVgI7wGWh/nKUjJgVgFS96/QaHpFp3Dmqec4xnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/189] tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test
Date: Wed,  3 Jul 2024 12:39:46 +0200
Message-ID: <20240703102846.212350586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d8765c952fab3..4692c87d4b69c 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -69,4 +69,5 @@ static void __exit preemptirq_delay_exit(void)
 
 module_init(preemptirq_delay_init)
 module_exit(preemptirq_delay_exit)
+MODULE_DESCRIPTION("Preempt / IRQ disable delay thread to test latency tracers");
 MODULE_LICENSE("GPL v2");
-- 
2.43.0



