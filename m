Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F78F1849CF;
	Wed,  3 Jul 2024 10:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003556; cv=none; b=Cbv+CrcgT6NkUZ/MvpN51/MujmAcMJt0jbhENdpc0ne1be4fDT37esRAg63AE91AvJfJ+V0bNmJi8VMs17yJx8IUs0XSiavWF+x9Zh3yGNXLY9PLuf3sBV0Rf1bhn9L5XUv8Tb4epWM7bRJb+RWWc1kOpPBwMU0GxoXqVEhMOO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003556; c=relaxed/simple;
	bh=SKRuPrun2IlBumS4bNYFuaul5Ou3wDhYeD7zET5xyOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR89VrqRzeSUEPEFwWZNcWG4icE7dDicmajAIgIDzxIO3z6eScBVdv6mFQAaMHvIzJ3BMuU56E5TtaC9jrE3OTaRdh/l1e4mO61YmtVOkqnw6jyf5qCjwA8waSAYcYATR5aoJqU1zsvoYsZ3BO78zpmmfnHzV0WPBX2gGhKbd0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFLTtI3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFLTtI3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4B2C2BD10;
	Wed,  3 Jul 2024 10:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003556;
	bh=SKRuPrun2IlBumS4bNYFuaul5Ou3wDhYeD7zET5xyOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFLTtI3BLgtjOZ84RlvvpRdmZrT4jWQi5TczhZaB3h4yF1pf+BEIopxuhzFZ/u1p4
	 Npfbu58p8Bg6vO721cer8CR3qLWAFvDLp3A9SpMp9Vx5rsvMLkvqSQI5czuJMxbWYe
	 8Ev4CMK2xmI1UJd+PrtsBaBqxumyEjA9gp2bPNEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/139] tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test
Date: Wed,  3 Jul 2024 12:39:43 +0200
Message-ID: <20240703102833.688485967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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



