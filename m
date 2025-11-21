Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5710D346FCA;
	Fri, 21 Nov 2025 13:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730896; cv=none; b=mDzAeMLA0LQo6DKECRxMwuUPS0R9BrMCEaP1IxK5ZvmhxzeLKJH03AdeMXwgG3HQ+h7OMGPC1zn9r3f7JToe3m3K6ZgccxGizT+wBAUohIIRlEbyXnPpYGQp99lNE4zEWRdOcJnVgGZA522EwZ1d7Nd1avMhpIduEknCkXopt60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730896; c=relaxed/simple;
	bh=gqokv+UAu0E4pn07Bry2AcFuHfNIfx+kbscdjzFSn+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkbSt1ojv9XW6BCwp3ZJ5ukDANu37asePhkTw2LWzynITh77zWj4I/YldDqasYOI2rTfMSAd+T0Er9c2WjEGZJ+W+zszdJ8GLgm4xoCfiRfW8B6O74zMFu4EvjjRQZ7DJC0c1WDSb72OVDFlRc4Z99KBVAbyHser7OJ/RyhTrXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRGbWA8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRGbWA8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47487C4CEF1;
	Fri, 21 Nov 2025 13:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730895;
	bh=gqokv+UAu0E4pn07Bry2AcFuHfNIfx+kbscdjzFSn+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRGbWA8DvgaMMPBSHkylAbDeZFXWVKYT++8wL8Ufl34IFHku2VzSJylhgDT/Ii3Nl
	 zPaFyPwXYnqfkOXXUa4Kn/gq1mROjHXRaAMiecL4casx/0vcGH4cWT2MTlsG8HY1Y3
	 UnLsd52EOcmYAmKDXuxhkVSonsTNLda7Ili4Oe58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 020/247] compiler_types: Move unused static inline functions warning to W=2
Date: Fri, 21 Nov 2025 14:09:27 +0100
Message-ID: <20251121130155.327287171@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 16755431fc11e..e768d2c693662 100644
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



