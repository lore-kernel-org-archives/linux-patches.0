Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6FD1EABA1;
	Wed,  6 Nov 2024 12:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897035; cv=none; b=nR+JDgSMLmiAIr3PhK8kRriTNoIINutjL7JDXK2PqqOiejkY4mSlllvtj47/y/itya/SLbKY9ytTjusZrIf1M083sFHfJNbLY0yShaX2wdSKUWidbFPrJnZEOM5ZcfhLulmiqInH7rv9al7uhIvp/nAOTX2BBPuw2Ax4EYAo03A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897035; c=relaxed/simple;
	bh=CcpT3ygnMOFoIn++BT0g8+IL11Pr7GjX44rahjfR0sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EU9nBNuqnB5mSKtE+iLCQYcUrhAC116+8+Cf6+sJNZNwobUKNPMPh14SY7Cp6XuB0YiQKOLmH1sHmgFYN0eknJVopSuy5BE/poQZhQ6ikWBD1nBbW6rKAIvVTLsfrMhybBlsTP2J+04DEMroWBQ/lSVU9tsXorTgGvgdBguyC2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/VQMr3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/VQMr3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE618C4CECD;
	Wed,  6 Nov 2024 12:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897035;
	bh=CcpT3ygnMOFoIn++BT0g8+IL11Pr7GjX44rahjfR0sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/VQMr3RpgCUhstjTMzrMjHwNItOL9d1OznQU09lNOBs3nWg6WE24Y1p52f3xHmS0
	 XEGAX1sYZt2hzXUESsQ745/Y0jcwq+fGiox2VhlJz5LHpxeEGisP15HMwALX493CvE
	 LilROGkbBH098+Xesrglfxz9+C1/gCHHZWGNFoHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Li <ashimida@linux.alibaba.com>,
	Kees Cook <keescook@chromium.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/126] compiler-gcc: be consistent with underscores use for `no_sanitize`
Date: Wed,  6 Nov 2024 13:04:06 +0100
Message-ID: <20241106120307.325248248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 6e2be1f2ebcea42ed6044432f72f32434e60b34d ]

Patch series "compiler-gcc: be consistent with underscores use for
`no_sanitize`".

This patch (of 5):

Other macros that define shorthands for attributes in e.g.
`compiler_attributes.h` and elsewhere use underscores.

Link: https://lkml.kernel.org/r/20221021115956.9947-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Li <ashimida@linux.alibaba.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 894b00a3350c ("kasan: Fix Software Tag-Based KASAN with GCC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 149a520515e1d..e6474899250d5 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -103,25 +103,25 @@
 #endif
 
 #if __has_attribute(__no_sanitize_address__)
-#define __no_sanitize_address __attribute__((no_sanitize_address))
+#define __no_sanitize_address __attribute__((__no_sanitize_address__))
 #else
 #define __no_sanitize_address
 #endif
 
 #if defined(__SANITIZE_THREAD__) && __has_attribute(__no_sanitize_thread__)
-#define __no_sanitize_thread __attribute__((no_sanitize_thread))
+#define __no_sanitize_thread __attribute__((__no_sanitize_thread__))
 #else
 #define __no_sanitize_thread
 #endif
 
 #if __has_attribute(__no_sanitize_undefined__)
-#define __no_sanitize_undefined __attribute__((no_sanitize_undefined))
+#define __no_sanitize_undefined __attribute__((__no_sanitize_undefined__))
 #else
 #define __no_sanitize_undefined
 #endif
 
 #if defined(CONFIG_KCOV) && __has_attribute(__no_sanitize_coverage__)
-#define __no_sanitize_coverage __attribute__((no_sanitize_coverage))
+#define __no_sanitize_coverage __attribute__((__no_sanitize_coverage__))
 #else
 #define __no_sanitize_coverage
 #endif
-- 
2.43.0



