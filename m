Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363103E49DD;
	Tue, 21 Jul 2026 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653934; cv=none; b=OCoU0XZYvaH3HcHBZer0W4ig0isbmz+LLyQD/Jj+Akcawm3I4XuHtXczVL6AMO1FJUtZjpQJlk9uVgSOrvBmoMiYMaWEeBeByTn90JVa9JK+1/bLQYROK6kOhRzfAqRxkdIrlHuw4Wq/ICOMFsVOD9P/XHXEnAT2/Hl6SfVhVZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653934; c=relaxed/simple;
	bh=msoh5V021U6KXTA/0nTi6DsxNP86KeOzs+naVYx6qp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHlLS7HLZ5O8GVWGZr9Ub2aMO2+ozaCYiDl1b2v5WoYq5ujme8FmW5EKaEW/wZrpIxa8KKCjjLCjETEnx1dbK124KCqmn/aMrXG4Nt8cTSSP4TrdcWa2vpJRUnRKVX15WaEkoHHWuFP4L8YTjnmehIyh6vC1I9JH0f7CUOjZ188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgk6Slb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgk6Slb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBF61F000E9;
	Tue, 21 Jul 2026 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653933;
	bh=hCBF9MsMRGug9hwQTdMLcmHA4dm8TEbReylaoTKjt2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgk6Slb7PoQalHolU0pv9H5lzTWPyfIJ16j5/LCaJsCNYBkBlpOrebG2hglx8BccT
	 mMWKnow29MTL/gtKFbKH5PacqYn9G2c4ODYgBerNzeuSO2QXzPELtEF3Tevaj6HUC7
	 HTKmsKTNw2yErS6kAqypkHi5LtA+iHFEZI/d+J0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1477/2077] tracing: Make tracepoint_printk static as not exported
Date: Tue, 21 Jul 2026 17:19:10 +0200
Message-ID: <20260721152627.632144159@linuxfoundation.org>
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
index 6eb4d3097a4d54..4c3729c8d5e208 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -87,7 +87,7 @@ void __init disable_tracing_selftest(const char *reason)
 
 /* Pipe tracepoints to printk */
 static struct trace_iterator *tracepoint_print_iter;
-int tracepoint_printk;
+static int tracepoint_printk;
 static bool tracepoint_printk_stop_on_boot __initdata;
 static bool traceoff_after_boot __initdata;
 static DEFINE_STATIC_KEY_FALSE(tracepoint_printk_key);
-- 
2.53.0



