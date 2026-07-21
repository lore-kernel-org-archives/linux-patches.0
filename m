Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40418379C32;
	Tue, 21 Jul 2026 18:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658252; cv=none; b=VzjXLTP9w8wacHYHljrnqRUWVfiMwwJdnvLc/SFo8WtPqDSgrQtSKp3FPyBebcvSocQ1gcc1p78Hr5AA3pnRi1bQ58d0FB76QJOTgrQtv9yT7jiXmlQViUcj2htN5ghsX6IhAoYPJCxKgPGQSA0pj2bbTS5CgbcmpxgYMG6gYNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658252; c=relaxed/simple;
	bh=pReT9n49+7AHlMHe3ce/YTt7kOJF7c48oico5xDIiLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIWkDo0h9URMop3rs0eQkN9yzW3etCo5H+qC5j+mIbE9222JOmX74ILYGKW4pAYZjc9/neiEiWPvStaIvkhPz0xs+3vhYRbIF8CwXT+7wmwOCOkiP8nWvJg3ZPDP9M0TIgVgFdPxyx9d8t3xlLDHrC6XwyNkKzswoHT2f6j3eNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZ5FJvRP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZ5FJvRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A691B1F00A3D;
	Tue, 21 Jul 2026 18:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658251;
	bh=Ael6MKzLDsRdaNdqmPIKtqn7unU/7B08a8JuFAel6Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZ5FJvRPcHbWe7NlecC0xxbyAIDeWbYXUumsEX4mwGz1kcSOFOCJKiRGXkVeUn36l
	 b4LtaFGjOGsotpdYyW+AWYssW00DTF37mBafMFZD0U1qZqbZgjPZpHD1OxnhmOnqhW
	 OYFu76yQ3yl1gaXWSlsmi2S8NxvBmjBYU1PxG2fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1066/1611] tracing: Make tracepoint_printk static as not exported
Date: Tue, 21 Jul 2026 17:19:42 +0200
Message-ID: <20260721152539.384171422@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit d5c6785f94ead7cd76b38af301ac63cb673485bc ]

The tracepoint_printk symbol is not exported, so make it
static to remove the following sparse warning:

kernel/trace/trace.c:90:5: warning: symbol 'tracepoint_printk' was not declared. Should it be static?

Fixes: dd293df6395a2 ("tracing: Move trace sysctls into trace.c")
Link: https://patch.msgid.link/20260617105822.904164-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 55c9f51a2fda09..5b1693d58af064 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -88,7 +88,7 @@ void __init disable_tracing_selftest(const char *reason)
 
 /* Pipe tracepoints to printk */
 static struct trace_iterator *tracepoint_print_iter;
-int tracepoint_printk;
+static int tracepoint_printk;
 static bool tracepoint_printk_stop_on_boot __initdata;
 static bool traceoff_after_boot __initdata;
 static DEFINE_STATIC_KEY_FALSE(tracepoint_printk_key);
-- 
2.53.0



