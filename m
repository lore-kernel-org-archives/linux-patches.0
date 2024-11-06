Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F541E0DB1;
	Wed,  6 Nov 2024 12:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896806; cv=none; b=ARI/Wnw3KUG/XE2C8l+q8qAVii2nCUNS/sxxsrO6+G8gkr7HAp9jJei21Ux8lzJNR/TydxSCn9g24S9Z6rdRbUPJUTrBWwb5MHv/MmDE7sBqNVecZwHYbB921faMmmDt5T+gf+1CyqvPZ+FRyjSCxvw3FrYYW0VUHTyGChyFlJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896806; c=relaxed/simple;
	bh=n2bTqXeqRzyON80CelVQVh88d9sNWbadLPh2PT/XtuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pqfe/EsmX9aMavB3HFKic96wWl2YrEors/xL6DDB2Z+CBSbPjQaHIIExOWQKSkOp02yhjIhFUcO5SwQXjt2EBkqkVH/RaHVdHyDsh00Atdc5sSD+mRaitcvvYaOkC2M/iyHlIvatAc2bWLYYXIMl8j1eG8g1nxS76PcwxOrlVYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUECSMO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUECSMO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AE9C4CED5;
	Wed,  6 Nov 2024 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896806;
	bh=n2bTqXeqRzyON80CelVQVh88d9sNWbadLPh2PT/XtuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUECSMO+DmNWFy1lTCKFLQ/3YtSS6HDLbOY44Ta63QhrOvlLKaD99ELy42jftN+xf
	 sqLtL10q7alFbmrzDzHk+dL73tkA2AdqYx1V1QZsS2XAdfabdwW7om/v3uKtiBx+5E
	 uQF7q9X0ArYd18wykjh/5SgvCF/w0pDMnycZYubE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Li <ashimida@linux.alibaba.com>,
	Kees Cook <keescook@chromium.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Marco Elver <elver@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/110] compiler-gcc: remove attribute support check for `__no_sanitize_address__`
Date: Wed,  6 Nov 2024 13:04:45 +0100
Message-ID: <20241106120305.369505633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit ae37a9a2c2d0960d643d782b426ea1aa9c05727a ]

The attribute was added in GCC 4.8, while the minimum GCC version
supported by the kernel is GCC 5.1.

Therefore, remove the check.

Link: https://godbolt.org/z/84v56vcn8
Link: https://lkml.kernel.org/r/20221021115956.9947-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Li <ashimida@linux.alibaba.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 894b00a3350c ("kasan: Fix Software Tag-Based KASAN with GCC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index f8333dab22fa8..bf78da28e8427 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -116,11 +116,7 @@
 #define KASAN_ABI_VERSION 3
 #endif
 
-#if __has_attribute(__no_sanitize_address__)
 #define __no_sanitize_address __attribute__((__no_sanitize_address__))
-#else
-#define __no_sanitize_address
-#endif
 
 #if defined(__SANITIZE_THREAD__) && __has_attribute(__no_sanitize_thread__)
 #define __no_sanitize_thread __attribute__((__no_sanitize_thread__))
-- 
2.43.0



