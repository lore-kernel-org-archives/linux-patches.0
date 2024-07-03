Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67A8171095;
	Wed,  3 Jul 2024 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005927; cv=none; b=reT3pP12Vys3YJI86QfUfXj6YDdvy7Slbd43E1Rmo+Gna9tksxcIHrz9Rfd5jOUMqsRSFrO75kSwVzrwFfDv06Ek/xvgOeddeMzJqEpQruWrqU3WlnT0dpY+ux1mZ86vMuQddncfCjr+IwRMJoZGKBbAQcBFAk/SsRmqZbXcPms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005927; c=relaxed/simple;
	bh=9J4mZ66D5dh0eufQ+owZHqPvmj+8Y42nzivjMl4f9LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo9iJb3q/LTHJEneK3hd9Ew0900vTskSo7ZJpwEomWOYcnbfJl3XvBd6xJQZRVJ2F/GOkT7qtTuBTpjeDq2V/Aziq7hMzVkgCFGqUUofjWcoI+uVjFGO4tnMPKeNDWYGv2y7y7Uf7WGBA6e//Zo2OOaQP5rpX+gBW5k3IvW8q40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyDfdZmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyDfdZmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D52C2BD10;
	Wed,  3 Jul 2024 11:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005927;
	bh=9J4mZ66D5dh0eufQ+owZHqPvmj+8Y42nzivjMl4f9LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyDfdZmQN06ljtKSXlm2gKpkyJRAt0w4F7S3GgicTHEn4vj1zVhd4pL6DgqLqaJ5E
	 pNPqD2V5XRBuNFBe+fsqwIWmb4kSNCLhmDcRUMzW5x9D74zob/O7pc91G4/fEgFQrV
	 eM6AceNeZk3t2qNOPicjZWch0Tlm6smrIscjavYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/356] tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test
Date: Wed,  3 Jul 2024 12:39:37 +0200
Message-ID: <20240703102922.231800953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



