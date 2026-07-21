Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5946D407CDA;
	Tue, 21 Jul 2026 22:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672072; cv=none; b=GBgeW9CjQBNUtKq03u99vITnRzeezw/Y/o/MvMDvEe2KzZz1gfCvMlvY6F4W/p3Myw9Yv5psvgE7i2YU/BlUp+D4ey/32JIqXZj8D2zsWCkBWLekGZ7RcHyF6SibnqbnjhIE24VFqZdd33rJsuxhG8gWMiFbW7uuE70oH5+Kqz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672072; c=relaxed/simple;
	bh=ZqV0rTnluxF4ae30Sb/qRFE97idwPyWCpFp5oz+wEqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq1dRDg2gqWcIePKofjxla4rIawbYPxKbPDD/fT5pLoY+Vcv6SiA4mImtPgfoFxmNUDUTGzL0mWLngLBUTLagLEeturJ6JNE69p/r3hq0JlFRMEKvUs9/Vad1GuFMjxardcqhiOwVydMZOmiAzmDNFwcUrhEFgdJmqR0jvJSWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tggnMeYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tggnMeYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B1C1F000E9;
	Tue, 21 Jul 2026 22:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672071;
	bh=BDhczdaAD5hRdB17cIgTN+1KR/XhGDVCNc+aLb0b4n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tggnMeYYa9wBVCcVjSqms+KbR2UnVHKXsE3PLRz5m46HKLXM1MwnS7LGAoQHdEvvL
	 Pm44kdlRhUjelBICfNOBudx3v5NYZCilQz+H0T6t8XVeufvwU2wLJeeVdt9CBZMfpl
	 6OcoKbuV3RIlT4P0jheqrhjYEMKfqDUjIQo4LBkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 485/843] tracing: probes: fix typo in a log message
Date: Tue, 21 Jul 2026 17:22:00 +0200
Message-ID: <20260721152416.939379037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 97003a41b6c13f..cd8f568fb61f51 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -424,7 +424,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
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



