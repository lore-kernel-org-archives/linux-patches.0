Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA971465A8;
	Tue, 25 Jun 2024 09:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308789; cv=none; b=m45irvTPe9sM3qCf/kgE1O52lrIq4OC0INk+gFO+P7RgucoahOu3mLqoNd/S+g/g3cgxxEe/B1SZaMFV88aXynR/GBGqaIlSlIRfDdDK7c0aRN+kSxivdCGnxlehJDnObCko1PcdAIHEyGyF1yviifVqxZUcAQgmIcjoU+oJEls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308789; c=relaxed/simple;
	bh=nVULTblWCQ8rAmCE6S73aITzMUoz2IH6Eg1yYbBK9oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgsRmDqigG4djrr9MKnN73hJVmwjBAMQmqAP3U2fz/mMpanfQbYrbfvsfPlxzWQJ72naTf1Mskz41ootkWKAPaW/48Xcm0swZZrhkBYxCHzXkQzw+cWMNZUFi8w0Z2+FPSHLxx1rjZ08MqtGVaNeOV/KNoLbfT70zxo5iCoYQPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9+x2r7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9+x2r7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03956C32781;
	Tue, 25 Jun 2024 09:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308789;
	bh=nVULTblWCQ8rAmCE6S73aITzMUoz2IH6Eg1yYbBK9oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9+x2r7xo7r6GAHCL5D6M4jaGTX0F+c5ukoaL8NZt/LZTz5UnLsAWUR2cDR6aRss5
	 uDyWS20dVEmKjNg+yyEaUmzKWyBSKgvyH+fb0x2+Y9rmKqhFYTG6LjzBJbe+n9ARdJ
	 XbRddunN8/wYdR3loC5Gp94QAcXuzegEBLedtCn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 241/250] tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test
Date: Tue, 25 Jun 2024 11:33:19 +0200
Message-ID: <20240625085557.303804724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



