Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B4D46A5F7;
	Tue, 21 Jul 2026 19:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663106; cv=none; b=CAKavluz7c335hRHaczEajbvWheGQOGQHju7PhgprSLCuDRBqtSo+Nf/Se/G4+11DdDY0O/L+1RMbil693QdMUSJygmOYr+XWvgxxkrb6zrp0GWdPGp0BoK7esV6qtYSiOcRwvCemRN87vmm3VvLJyQbf5Ig3LBkn/XS+cZ63b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663106; c=relaxed/simple;
	bh=+by+DGsKSBIPUNBf7k5nxRd2z50Q8lzuV980IP/vlt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noMoOzgVEtL4GD8RhDLcoa6WfIIdnA7OYfF4wnXo04pSDWyPc/pQw/tCzFQWa6z/q63d0VJxncpFWWGsfyGZod5xThf5kzHPl8kcZ0JzCMRQqHOMpIbNpKafJTMW4FZi43guZV6wv9pTaCs1LN+kx+dh+Yoahz7yNLJ4ezxhInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSqPa8cZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSqPa8cZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A5B1F000E9;
	Tue, 21 Jul 2026 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663104;
	bh=6TbBK+9FWM+GJVDuiVyJYo63axVRaY1gN+ORk8Ouig4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSqPa8cZCMaYDEPvl7ZRpttHknc08JFZd33bomIry8iKX03By3zNili466dkNEBj5
	 nHfH8QQ6jYAp1dnCaqrUNidKCy3sr7LQz7p3/+SOJm5dMiRTCLyBRb9t2P6M30pRdy
	 tbjnf7qSPrJF2mWjXBk+HAw5I16FtH7mPb4lEO0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0690/1276] tracing: probes: fix typo in a log message
Date: Tue, 21 Jul 2026 17:18:53 +0200
Message-ID: <20260721152501.537282013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3d52d3c4d4957a..8f6d5fac0992f3 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -499,7 +499,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
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



