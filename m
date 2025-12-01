Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11696264A92;
	Mon,  1 Dec 2025 11:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588752; cv=none; b=F2VahqCxbIQc62ZRVLi+WpJ0aMBjVPQGgYURwmgAaT8Ym6kd09Rc8tNH/O0I4huN5bx593xxKVs56q1YtRhlUPMd1UdtbFXt0ALIgyMtdM/U5KkaO13zcWxUkCYjfp4owuGJACPt8TMnG5Psb3jnhB+yNobSFCsNyBugFoOa8dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588752; c=relaxed/simple;
	bh=gv3vIlTydVZ5sSjw6cNOK5c6quYUaP4k4lgPouDC3jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1BSnp7hwBcbqICnn5gklkfYKkUx76KVFjsybWo2/fskBmpiLBxnAH52VfTZtbJSCNu5Np9aiNqQ4KChyejMrLqFOt9Iv/izmDfWvtaofeJYlGbxLUKhPJ2xOIfqiQkCI00TQbSjatlVQ+ZVqZJaEsWbLUFEQMB+ZtTkFjsj/Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/EN1uGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/EN1uGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9049DC4CEF1;
	Mon,  1 Dec 2025 11:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588751;
	bh=gv3vIlTydVZ5sSjw6cNOK5c6quYUaP4k4lgPouDC3jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/EN1uGFbEyU4A6YrLMThjLaw5yhohbtKJE114k7x/OyLlmkTMJPPxjcEG08zgIxv
	 Yi9teiGbJjb0Co616YTJl7vgXso4zS7EX5CpQEzZ1vyNFmdq71/CYYR/HtQT5lnZLO
	 0OwvCFqEOda6T1gmg+g/B2uyaOAxiUJH3+eF6m/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/187] compiler_types: Move unused static inline functions warning to W=2
Date: Mon,  1 Dec 2025 12:23:53 +0100
Message-ID: <20251201112245.745208882@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b94d08d055ff5..a428104c5e777 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -165,10 +165,9 @@ struct ftrace_likely_data {
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



