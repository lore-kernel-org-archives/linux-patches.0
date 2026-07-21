Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C662382385;
	Tue, 21 Jul 2026 22:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673989; cv=none; b=m9TQTkNODXp/Eht0mKtcEkGf0gg4WNWnxuu0tZdz2VuePBi6HUTztDKgKUPDk9ldThAw/RMvU6Jf0sNoHNlXniOjQEU9PqcmlXeKlvKKr0zVRBmdIg2jCYqerBUzqG09CAQ+G+tsBDEI8KihirDvxI7aWINzWA7RdGUB/v81Qyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673989; c=relaxed/simple;
	bh=HGTr9U0aesD41GrDafF/Myd97OtcB3lFUvbPxMIg9hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkHQRhTzck1kAU758Ef88aABy3K/pyjDaetvO+bHk5GdMRuOhb8Jgj8YKHe0XX0C2iEb590pZPtEcw9E5zNcDt+/gw7+qdLz/9aQ6L38Ml0a91twEcEQLJXAGjxWyUrHIPtYszcTm7+R0W+WkTVIf4q/j9i1wdtOvYDscZF961I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6Fydv3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6Fydv3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AE31F000E9;
	Tue, 21 Jul 2026 22:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673988;
	bh=EsUGVmSWv9gM+sZgVV6XDa4eu0oy9YNg53XW5h3Rmf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6Fydv3W3XaQT7qRV2cJrDj5wL62I7xcujHG6F72MOg7faQIHWfI/ZC/arWlrZIkb
	 Anb5Lp++/cq9TLyfqtcVrLASmzh4poVwVb7p3C0yJZdNmelSYwJTwDb//t9NSJTGIH
	 xSFs5rBR/mLsSLCsCSDA35FLyi6TcR/wfRhqSrTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 372/699] tracing: probes: fix typo in a log message
Date: Tue, 21 Jul 2026 17:22:11 +0200
Message-ID: <20260721152404.086631333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5d4dc7ac3d198b..0f7a584ac21bfc 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -409,7 +409,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
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



