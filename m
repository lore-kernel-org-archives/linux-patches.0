Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F8447124D;
	Tue, 21 Jul 2026 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657922; cv=none; b=oRiY0Ueg4hKygbNQLARKhzQorgGpNFSMilzg+l130YwrTTCazgAgLG9RPZ9rTWVnw58D+BvkgaIP6tA01AvqSrWbbBMk7eEQgNE6CLMYly8CsIIoF5mEnSMBdbIXffHUQq//2oUYh/UqwN1FbtPxq2i72QmX/SAbjNmYgXTHv1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657922; c=relaxed/simple;
	bh=TqIcRkBdDmdUV+YVSmZ1M/6/LZEBW3SHBwIrv7O1u1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K51hpcLYc+2vdFtoEb8MXaTE9VHXIoqjm4WpkHNy3r9SXO4D05YGfAz4TS+IXkItYyq2OrgXKAr0cHjXrTJsWC0ZptVhqUqdKWooffawk4K8jC8lWL9LccOelKv0hAgln8AO5DP+w59sVS/GvRJSi/tCsjYEcyxeyt/htX/q/eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb5k+pA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb5k+pA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5010B1F000E9;
	Tue, 21 Jul 2026 18:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657920;
	bh=fzaCa/H1/LXGekYkrClLGGvRchTzGgv0ecFa+6NSM9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zb5k+pA6tmldZqrPB6DurADu2UWEGFmjBGH8wdceDUxektOW7KMg1p4vOU3loKY/S
	 kQ/BkT/KE85ozuZZFrEFxiEHGHyLIO+oQ95EttmPAjJszM6rTwERdFYW/u+UMNXmk9
	 lLl8gg1FUXdYq60XZ8FNljVt28nB1OyzEkIw7Otc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0948/1611] tracing: probes: fix typo in a log message
Date: Tue, 21 Jul 2026 17:17:44 +0200
Message-ID: <20260721152536.713103288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6149c4850382cb..37447784a8fb4b 100644
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



