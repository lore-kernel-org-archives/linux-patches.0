Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9003A31354A;
	Wed,  3 Dec 2025 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776514; cv=none; b=eS8tDFPmov6sE7fgLI/OCD9eTxKGG+sQU7X1djTcEzrKuNAVC24HIacXn+LPSmjgGtuF+q/wA4XVe0v0w+hk7wa8aXX+Zal5Zs+xQ9h/5tO5kWHVTNUMvDdVXeu5my5BlTNKYr1FNxDVVyWvA6u4XYhHDB4sFDXyG8mT5s/x05g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776514; c=relaxed/simple;
	bh=zan1xZbjMJed59HePQyBs6VLfXxpsvJQz+o7026tpps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZrj9QJNQOmZRVpWQVvGgYYtN8QsdKhSQcbReCjDT3Gc0BLkyg3btkOK4ulBfQDACWrPmGcpdTl5AXfA79SV48JlQHq4ffZuTWjzusT2nDm32beVXHeIrjZSMu23fHrC0wDph343W5DoBVlPeoh8MKPsFRxFJVD0rWR4IsHeehk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCtXF/MO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCtXF/MO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1247C4CEF5;
	Wed,  3 Dec 2025 15:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776514;
	bh=zan1xZbjMJed59HePQyBs6VLfXxpsvJQz+o7026tpps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCtXF/MOKHO3SITzHQeP3KtPOzKfOOrfH/0yJeyGmoDwr71JhiuUia0dC5dnV3S0d
	 A2SCH0UbhMQ/G6YWR/4SSAPrS5xs/TbaB0dc2AWeRmMVMrYJbgU3QeUEBZQWBNsa4K
	 IfYXLUNPMlipxvuQ06fPHCxRZWiS9Rgfmeh3hysM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/300] compiler_types: Move unused static inline functions warning to W=2
Date: Wed,  3 Dec 2025 16:26:17 +0100
Message-ID: <20251203152407.030104046@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 9818af18db4bfefd320d0fef41390a616365e6f7 ]

Per Nathan, clang catches unused "static inline" functions in C files
since commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
inline functions for W=1 build").

Linus said:

> So I entirely ignore W=1 issues, because I think so many of the extra
> warnings are bogus.
>
> But if this one in particular is causing more problems than most -
> some teams do seem to use W=1 as part of their test builds - it's fine
> to send me a patch that just moves bad warnings to W=2.
>
> And if anybody uses W=2 for their test builds, that's THEIR problem..

Here is the change to bump the warning from W=1 to W=2.

Fixes: 6863f5643dd7 ("kbuild: allow Clang to find unused static inline functions for W=1 build")
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251106105000.2103276-1-andriy.shevchenko@linux.intel.com
[nathan: Adjust comment as well]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler_types.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index eb2bda017ccb7..9cecd02c1280a 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -158,10 +158,9 @@ struct ftrace_likely_data {
 /*
  * GCC does not warn about unused static inline functions for -Wunused-function.
  * Suppress the warning in clang as well by using __maybe_unused, but enable it
- * for W=1 build. This will allow clang to find unused functions. Remove the
- * __inline_maybe_unused entirely after fixing most of -Wunused-function warnings.
+ * for W=2 build. This will allow clang to find unused functions.
  */
-#ifdef KBUILD_EXTRA_WARN1
+#ifdef KBUILD_EXTRA_WARN2
 #define __inline_maybe_unused
 #else
 #define __inline_maybe_unused __maybe_unused
-- 
2.51.0



