Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA015230981;
	Wed, 30 Jul 2025 09:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869206; cv=none; b=eWVL+9T8Jv7Dor0NDEfj7L+onv73doP92mcP2YYAhFj1D4qEw9By/GIauOedhy+pg9fn6Zfvjau6+AHs1VJ5NbSGqSP/2SPyxwUJESCwDdJkpIbQj6Jx/KZ2TdF7ZVbulsyiGm+h/CTm7MINohXcje43PIQ0Bspyor9NpxhsQKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869206; c=relaxed/simple;
	bh=CfmGNZWF9I/tqV7vd0OktedLdT8AUmConF4RvzTjHdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tai7UoWy8M/R9GlJtI+OyAi/7oYhKAQOW/VZQLEV5cgdsVjWL71N7b3H6veBM3/9m7xf9T0OsXQzo0HtFgjQzFBLXM1yxAsjq+bKnfBAK4FlTJ5qAyTfWuanxYOesA9ZvutXpU9tntmQ/YG7R+P/nlEdb3/w86v95XWSGPFiPWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+IIEQ//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+IIEQ//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9B7C4CEF5;
	Wed, 30 Jul 2025 09:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869205;
	bh=CfmGNZWF9I/tqV7vd0OktedLdT8AUmConF4RvzTjHdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+IIEQ//1pdMg7PN33xFLt8yrdY0eHXIM9miESb4XpH/nQy8VL8yU+2eSMDqn9H/1
	 uK+3tC8YdnoNIadT0a7o+0z8bnFQvNge7wgHvYG28IOmWMTnpPDI2peiUYO4qZgd+c
	 cHYLDJuiRC88vXDUcPVzdGVmV/UqrhgI/5OtZPaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andriy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 60/92] sprintf.h requires stdarg.h
Date: Wed, 30 Jul 2025 11:36:08 +0200
Message-ID: <20250730093233.077992246@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Rothwell <sfr@canb.auug.org.au>

commit 0dec7201788b9152f06321d0dab46eed93834cda upstream.

In file included from drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c:4:
include/linux/sprintf.h:11:54: error: unknown type name 'va_list'
   11 | __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
      |                                                      ^~~~~~~
include/linux/sprintf.h:1:1: note: 'va_list' is defined in header '<stdarg.h>'; this is probably fixable by adding '#include <stdarg.h>'

Link: https://lkml.kernel.org/r/20250721173754.42865913@canb.auug.org.au
Fixes: 39ced19b9e60 ("lib/vsprintf: split out sprintf() and friends")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sprintf.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/sprintf.h
+++ b/include/linux/sprintf.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler_attributes.h>
 #include <linux/types.h>
+#include <linux/stdarg.h>
 
 int num_to_str(char *buf, int size, unsigned long long num, unsigned int width);
 


