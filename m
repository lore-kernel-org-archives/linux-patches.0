Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217128;
	b=Swe1B70CWqZ6hRoGkwh1KAXyLGVk0Ypzf+6eAO386BNokgnjVKSKMxFQ3Ygrz+Tw1eE6
	 9CY4r5/MZq/d5GramCn4Qmpay8JhivREIsk/0gHxUrdqkF+yNwgDWst69W1/gDZWlTrnx
	 d891LNqxRZFK7SRdvTTq1k2vfErEVZCZ2MbZuRAmcMMgYEPRN3KLFqztM21d7F7gBpy3V
	 W2lcytHp0Q9pFjLF44dgrhi6s4rPBI5DRP2UTrpURT/8NH+NldiPJl/Gypbymg5Wup1SH
	 p2UgZh2br5NBtB+eBgBKhQtHYYcbxMtj+XF79PQsNaIWRElliL+lDGXHbj/wHGdxHkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WScSO/C1TiilABNKLZR4C23Wq0WCrLy18MZlvqs6wgo=;
	b=PKoPeDFtZTPvKYI8zEElMk7ep67Op5sfNhKX2vtVGDAWVsEliKZmjSOC4hVnZ5erJ0zA
	 c+cNu0o8v9ENtGtuWLc0R6Sw2i1aoiAffT7nu5sSDM6lW+l3WwSQWtidklrQVFm4QjL6l
	 R/k39oi1sx1UDcTxYZapjULT2Q7RmP6xVahxfR3pzPW1kZ+1lL0a337SiRGToxPsUZsrl
	 BCPpbXkLuyVIclF9FCG5PbPRm2oFGEjShVRAm+LF9zNGmKgsuk9RTPuOo8mUh5h4mEdyz
	 2byiz3SlmjgGP6e13bOh4jm7wNDwZy4NuVodmzetqHuBKLszAoFv1agfvLp2cgUK6kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRT9Pgwb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26742606A31A;
	Wed, 28 Oct 2026 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRT9Pgwb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777FC1F01825;
	Wed, 28 Oct 2026 19:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217128;
	bh=WScSO/C1TiilABNKLZR4C23Wq0WCrLy18MZlvqs6wgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRT9Pgwbvh7glPQvvxlyKEA9rDJdBj6cxjLw4WjFvctVeMKE8tL4jqNsAenLpqYDn
	 BP9ka9rvtKzn5YCPPuFDvbpJa1uLRf5tNwvFlk8N+WwMFx7Gwi/T+Yq2H5BiGU4p0B
	 if9uk+mKaEXTg466v+i+M2KBK9hJo1RJ/7viCcfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 1799/1887] Compiler Attributes: counted_by: Adjust name and identifier expansion
Date: Wed, 28 Oct 2026 18:04:55 +0100
Message-ID: <20261028170540.384927725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit c8248faf3ca276ebdf60f003b3e04bf764daba91 upstream.

GCC and Clang's current RFCs name this attribute "counted_by", and have
moved away from using a string for the member name. Update the kernel's
macros to match. Additionally provide a UAPI no-op macro for UAPI structs
that will gain annotations.

Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Fixes: dd06e72e68bc ("Compiler Attributes: Add __counted_by macro")
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230817200558.never.077-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler_attributes.h |   26 +++++++++++++-------------
 include/uapi/linux/stddef.h         |    4 ++++
 2 files changed, 17 insertions(+), 13 deletions(-)

--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -108,6 +108,19 @@
 #endif
 
 /*
+ * Optional: only supported since gcc >= 14
+ * Optional: only supported since clang >= 18
+ *
+ *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
+ * clang: https://reviews.llvm.org/D148381
+ */
+#if __has_attribute(__counted_by__)
+# define __counted_by(member)		__attribute__((__counted_by__(member)))
+#else
+# define __counted_by(member)
+#endif
+
+/*
  * Optional: not supported by gcc
  * Optional: only supported since clang >= 14.0
  * Optional: not supported by icc
@@ -145,19 +158,6 @@
 #endif
 
 /*
- * Optional: only supported since gcc >= 14
- * Optional: only supported since clang >= 17
- *
- *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
- * clang: https://reviews.llvm.org/D148381
- */
-#if __has_attribute(__element_count__)
-# define __counted_by(member)		__attribute__((__element_count__(#member)))
-#else
-# define __counted_by(member)
-#endif
-
-/*
  * Optional: only supported since clang >= 14.0
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-error-function-attribute
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -52,3 +52,7 @@
 		TYPE NAME[]; \
 	}
 #endif
+
+#ifndef __counted_by
+#define __counted_by(m)
+#endif


