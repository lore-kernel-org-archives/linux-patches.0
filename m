Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD102010FA;
	Wed,  6 Nov 2024 12:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896804; cv=none; b=E2WRNOlUxvZK4FpmcszJ+aksdWBIB1+Yo/jzPMwL1PzNzYzz7LfF+o2GY7BDPC9DVAMjXR5fqWDutbqm0QhHFrhl+Gvmh4sK0cAdCnv9bbS0Z4jGgqZzW4XION9+dNuQDSXdgEPFnpnzDTbeLLITNtH7rN5Vlc1loY4qemsVB4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896804; c=relaxed/simple;
	bh=24Qc7d9dp8PA+ZfkTGNqJY5AASkJ5+OfifXlSPUqvyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnNnM0UTPpVAEVvCy6QkuWHNcFh31m4kRUbCGNcudzEI9ZOI2/AztP/XRGo/a9tv1FfE2RZx3GFHR9sCM7hYArKMMU5XVbpffl/nMIzV+7kFCtlxXXvmFI4KYL7N0bMOAl4FLm0aegCPOg1lSJvK6ea8+9wmelNe0vLVZ/mPK90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8I8CHcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8I8CHcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C752BC4CED3;
	Wed,  6 Nov 2024 12:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896803;
	bh=24Qc7d9dp8PA+ZfkTGNqJY5AASkJ5+OfifXlSPUqvyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8I8CHcq/OqlgqiakPu3D7EFC1Ehfrj04UIcPK82ZpEQZkuKCwhpRIhI0Pkrjmev2
	 CvvgY3+sKOq8F9ph/zAxnoB5QNqn3X4FcuVtZ8kveBpxBmF0lEQJBBy0PWqO+p2x5j
	 7otyuucnNcz4P6poPSLzYhgfev8iCSVgk8zu8xFo=
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
Subject: [PATCH 5.10 078/110] compiler-gcc: be consistent with underscores use for `no_sanitize`
Date: Wed,  6 Nov 2024 13:04:44 +0100
Message-ID: <20241106120305.343252014@linuxfoundation.org>
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
index ae2de4e1cd6fa..f8333dab22fa8 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -117,25 +117,25 @@
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



