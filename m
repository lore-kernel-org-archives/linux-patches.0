Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6C246762;
	Fri, 21 Nov 2025 13:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731712; cv=none; b=ELBlj/nuBlUV9EGMpYoHB2qKLQ+Z/FHhxfusP9yqk2fTXWsXRo7ZC4rSfoRSlHjY54WKd8YSpgXJneEb2LRUowpofDNRw7i936kpNQ02oFmStIAJv43/m80iyyFIUsc9EjAbKqQdVs1zR7z6uoMZG8Lxh4gEYoEPq22g+RdL8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731712; c=relaxed/simple;
	bh=jNdaTD/V796o4U57/FmLTSe7hlCT3ErVQxGIh3p3LJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9J6Ilo4Py8gLixg+SwC6Yeh46+5FBVRg4xY8DdTbdVJBzeocRiqiTfTkcwtKWIIuJHgCQWM6dIOrT2Q5HsQJZ6/FImuzOw6WZqyOQYFNBpbi5+MnRx+bfb0HL+Ex1qfbH9C3MkASShDQ4gwfcsod+tEY2OdID5Zjj02zkgSJ6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEUX1Adi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEUX1Adi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0549AC4CEF1;
	Fri, 21 Nov 2025 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731712;
	bh=jNdaTD/V796o4U57/FmLTSe7hlCT3ErVQxGIh3p3LJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEUX1AdiUpjKHaGxrdbx0u511kbWKweKMdnCK0EN7DFA2Sqw+wlnpiyveMQPliVn2
	 k/T7utHUhf9K5AjvruNQUnzNcmQAOXF0M7Vxgs30K/t73Wy1ZrxZj9MS2wsS88oI3p
	 VHTjfgcLzuBZvTboVLcuQGo35taeIodYQTBbgDP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/185] compiler_types: Move unused static inline functions warning to W=2
Date: Fri, 21 Nov 2025 14:10:38 +0100
Message-ID: <20251121130144.283282117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index 639be0f30b455..beb2a1e1bac53 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -250,10 +250,9 @@ struct ftrace_likely_data {
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



