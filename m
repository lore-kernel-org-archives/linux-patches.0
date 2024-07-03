Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9A183093;
	Wed,  3 Jul 2024 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004856; cv=none; b=NZj/JDsKbReQcWURAcWrqvjNavZ3/qhLCgp7MmmlWEWWs0DtVL9EzgpFH3KuycpzJ67VShkid4m/4JqOwHqp5g12XREquY1rroaIac//pH0cjcOftO3D5puSodb1PQ0lkmwS3QPiipXcQU5RjNQIXgo6TLUteERoywNhy0tm35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004856; c=relaxed/simple;
	bh=U5k6+X/VYuU6BJEWzlrzswTP3C+IZWKbryi1uFELyuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiNWe8eay39iqTfqbuMY4VMPU6ypNEUOeGRusTW6fRjL4gK9TtUIvhCAfSBAAf42p5rdNxKvsrCCNKxZwdJHbx5PP6TBJTfYdxPHOurIi9GKvT5SyTFiHQbzX6NBEIECwrJyTOQ3RLq1GwRVlSflM4vkoX/9QHGadGdLp+igEHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytOoFb7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytOoFb7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9489AC4AF0B;
	Wed,  3 Jul 2024 11:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004856;
	bh=U5k6+X/VYuU6BJEWzlrzswTP3C+IZWKbryi1uFELyuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytOoFb7qok6P0vm5cu+G75gm+mdInFrnsmxJXMU1bTk4JQeGeOPcrkFTEJP2/SsJj
	 D82LwqWnOLKQIPIaihK/AWhA5voRYGCnnjx/ar1sahmWU95OVdTb1SRMNpuoNzLx1q
	 C8s7Ilio1h9HOI7JynKCbuta2qHVEq6PWJNHE620=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/290] tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test
Date: Wed,  3 Jul 2024 12:39:22 +0200
Message-ID: <20240703102911.008285073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 312d1a0ca3b60..1a4f2f4249961 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -201,4 +201,5 @@ static void __exit preemptirq_delay_exit(void)
 
 module_init(preemptirq_delay_init)
 module_exit(preemptirq_delay_exit)
+MODULE_DESCRIPTION("Preempt / IRQ disable delay thread to test latency tracers");
 MODULE_LICENSE("GPL v2");
-- 
2.43.0



