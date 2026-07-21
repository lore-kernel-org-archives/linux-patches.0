Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951AA34F279;
	Tue, 21 Jul 2026 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653381; cv=none; b=B1F/04hKGA18V0JEDQRvyDqLnIJog1Fi++dT568aCs/AQBIXj/JKhq7mDPKgmFpeslgE8ZHxwk0WtiSaTg3yrHfW50koTq0+7wDkwiqO4WuTnZ7BS0m+BpayQSgwIWSXNNl/0TvOVTFJrouYPRoDHeoLW13KT6WAAQUF50on4UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653381; c=relaxed/simple;
	bh=wc4elAG4c/uuGLFifh/qBzPBaDUp5bLn76fnANWBZBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW6DnoMp8Y3WsXO6vhxtpq6ElU83SIynLpFemsBd5ggWdw1jXzW/VKtG+n1oMcbCCGuD58L5xhddStlaN4fgRe70RgKPTrrVC49StTgeMwb3G2Nle15qk2ES8+I9SKxT4ABC4JyJIbM1BZ0N7evhbUVv4smekTwAMp0YdPLF9Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIIG+X/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIIG+X/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D571F000E9;
	Tue, 21 Jul 2026 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653380;
	bh=h3ZaMvFGOuo/7+6dh2NXJofiE64R2Zaqrx7LmFrqTUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIIG+X/+7inFlRZLzlaIi0E3/wyez6ylnuIeIIaTJmvbBUsn9ftgCPLFW2OQGdPBB
	 yYTa6XRzz34AqsZi8SIY4N0BbRB/CNY9Ho9Bpx0R9F1hkAJQrperaAKfBUng43ALx3
	 XV/zDUbPKAPZowNyCZSxNo9KVZMGk/I3nMXslmN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1306/2077] tracing: probes: fix typo in a log message
Date: Tue, 21 Jul 2026 17:16:19 +0200
Message-ID: <20260721152623.621572574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 262d8707a3df79..df68d40de1610c 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -509,7 +509,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(NO_RETVAL,		"This function returns 'void' type"),	\
 	C(BAD_STACK_NUM,	"Invalid stack number"),		\
 	C(BAD_ARG_NUM,		"Invalid argument number"),		\
-	C(BAD_VAR,		"Invalid $-valiable specified"),	\
+	C(BAD_VAR,		"Invalid $-variable specified"),	\
 	C(BAD_REG_NAME,		"Invalid register name"),		\
 	C(BAD_MEM_ADDR,		"Invalid memory address"),		\
 	C(BAD_IMM,		"Invalid immediate value"),		\
-- 
2.53.0



