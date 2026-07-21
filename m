Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A793C10A7;
	Tue, 21 Jul 2026 21:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669691; cv=none; b=nzmjd8i6hBfM2WnEMieeGurOCC9aUxyupnVUC328QLY8rfBlRtKm+Hag/O1PqdmnGmD+VOFI6juQyMlmtZ2Aarc//u7vk3fzqkv60zn7KHoPDpT7HoEWqbeni6HLEsfymxS/m/w6GUaCD0oMkIjgE8sxggzxJM+oG8bdXOgPUkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669691; c=relaxed/simple;
	bh=EkNbdte4UWbQQ4b06AlfaS6v4A7snTlqlvsLULgy6qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXKcSZKIXy768h1+xbtO/09gzwLUM36HvcThgnodzJNqIh3VmFvWNSpwvP8GXjm92+PUB4JnBa6uurh0YFCsWsFvYYYHEO3TK21oudW+6vgbOqatrHKOTM2dHMPhTYW0CxEy2snSBz6Gq/0y7SaLsT9bBDx8mxuMhTRKfzceAmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA0c9Lr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA0c9Lr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149CB1F000E9;
	Tue, 21 Jul 2026 21:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669687;
	bh=5agEpWOOWZ/ZfDOv35jm/13UnsZ65lycpDd5/6OtbAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA0c9Lr2O+ftn+w+DQ+tHboGRAW9SwzCry7fRizMT5cbb2dpB0tjtI3JRfkNdHXFA
	 A6JE3llVtzEMCERUWCvLs2u/t8frU1XbnH6n1lP2+ebVapeVKkuSMMgxY40cdrSUCI
	 8U/ZKLdk43xIKJXOyPANMqyHv/ydhmtwacWwdtNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0647/1067] tracing: probes: fix typo in a log message
Date: Tue, 21 Jul 2026 17:20:48 +0200
Message-ID: <20260721152439.066273895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 72c8646956ffc8050bb8be5988a0f28fc37e1ac4 ]

Fix a typo ("Invalid $-variable") in a log message.

Link: https://lore.kernel.org/all/20260507081041.885781-4-martin@kaiser.cx/

Fixes: ab105a4fb894 ("tracing: Use tracing error_log with probe events")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index eef819796fceb5..aef19096b4dd03 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -423,7 +423,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(RETVAL_ON_PROBE,	"$retval is not available on probe"),	\
 	C(BAD_STACK_NUM,	"Invalid stack number"),		\
 	C(BAD_ARG_NUM,		"Invalid argument number"),		\
-	C(BAD_VAR,		"Invalid $-valiable specified"),	\
+	C(BAD_VAR,		"Invalid $-variable specified"),	\
 	C(BAD_REG_NAME,		"Invalid register name"),		\
 	C(BAD_MEM_ADDR,		"Invalid memory address"),		\
 	C(BAD_IMM,		"Invalid immediate value"),		\
-- 
2.53.0



