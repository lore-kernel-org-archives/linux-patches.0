Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0A782D98;
	Mon,  6 Jan 2025 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177318; cv=none; b=mMB9DgACJxTQPpRYxwr7lo9peShKNQ2F4ssTCPvX125B1nWF6egrftOu566Pqu5BfGwZskuQCrgiK1Jvlhn5okydcEUwTOvSVV1nLLrcjFPj5RDLzs2BBhpYGoOySO9AVc6vNQwseDoDjDW+durFd5p6m5wTKB/1gIcc6/Dff9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177318; c=relaxed/simple;
	bh=YOx1wtp08iybp4cRQhbjkFxLIwZT8iYio33AZjJ99+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN5XaEGoAdz+EMa0wp0lgaP8R7Koi9DUOuLHKRyGt1sCz6QdS0t7c2B9Prn7wxLj0sIIA9JwRBfxrivTyj6tIDJ7hiX6Os0T/5rDzdMibBJXOGMEsQsgy6QxFV2RH7/3KlWBbhGqlofGZGI0FMj1/tltaJrMHfibq5G0OTVMwqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHS54C7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHS54C7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA58AC4CED2;
	Mon,  6 Jan 2025 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177317;
	bh=YOx1wtp08iybp4cRQhbjkFxLIwZT8iYio33AZjJ99+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHS54C7GbFMrAO4nvVb/IhZKe27f6MkI4ihvt4SozGhqD5bAigyAjACl7kZbDtWoN
	 EQS8MoV8nyH9GMtzYeVrRd1wNwvZREvnf6f8GVxhfEOd8aiSC+IW7tozwP9AWHEskp
	 2XEf5//Swe9Jk/g09rJ4O55nVQ4IpfZb4vPc6zvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Justin Stitt <justinstitt@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Kees Cook <keescook@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/222] powerpc: Remove initialisation of readpos
Date: Mon,  6 Jan 2025 16:15:26 +0100
Message-ID: <20250106151155.227307401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 0f7f544af60a6082cfaa3ed4c8f4ca1a858807ee ]

While powerpc doesn't use the seq_buf readpos, it did explicitly
initialise it for no good reason.

Link: https://lore.kernel.org/linux-trace-kernel/20231024145600.739451-1-willy@infradead.org

Cc: Christoph Hellwig <hch@lst.de>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Kees Cook <keescook@chromium.org>
Fixes: d0ed46b60396 ("tracing: Move readpos from seq_buf to trace_seq")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/setup-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index d43db8150767..dddf4f31c219 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -601,7 +601,6 @@ struct seq_buf ppc_hw_desc __initdata = {
 	.buffer = ppc_hw_desc_buf,
 	.size = sizeof(ppc_hw_desc_buf),
 	.len = 0,
-	.readpos = 0,
 };
 
 static __init void probe_machine(void)
-- 
2.39.5



