Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054962;
	b=RquMXTw6//PpqXFwVRuRSQB+AXGsYXJgYjy7PKWg2c9IROClYaREBxlXzjWLsN2M+g8/
	 8mB5+x97WspgPAs6DcrDHiKdlqe41cH4ydYgvPd2vddrThiBIua17a+xnWl5PYVkReU1w
	 6hEWZO7bK6a44HqiuaTYaeqE4CBtAVl3OgWdce3zp4Q49o7YsieyOfVtLu+2woCmxAcGO
	 M8v/DnkjthdSnJClZxTzz572aPPoOQJw0igYZ7v2uf5ScWEGo707GZmDstLn/sl1ArUw0
	 frVfEqRJYCHfXBqJFGFeQjsxLxA0vKk5MgmqhdYMto9PNsR/3B+Dk0JzZxt5zWAK+NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PZssWpdWL6QECNLs/TrUJgWqHZL0xwva4laV6s5F/Ew=;
	b=Aq+ochX0l/NcSQBlvxCETbyOPIhBwAHbW9Vr74ohtXMCWaG7JJ98rWOT8xikl5sJE1zP
	 NwnbUAWjNlz4NLIhcphCz720IHRQqSiaV3tuNT5vna4/PSyPawCiYIdA0q0tKEGu5I9ee
	 r1LjUCUeHdFznvoSWKO2NwJ+cpQ+gKTHfAKWo9bFMwm0kkX/IpVqKVUuOvuhNawE/gEAG
	 nFW26vGO+8nj8aL7OQP3ZGZ78Tp2uqG4bEGSai6IClVLjp+Vb/PHhqx+01Rrf11M4vM3v
	 6pxPzvaOBes4UeixsvhnRNKySxUCBprMS6Qnc6gw9fTu0eooW3QT3mpk0KlPhjJVMig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H+vXbNak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACD2606A320;
	Thu, 19 Nov 2026 02:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H+vXbNak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422461F000C4;
	Thu, 19 Nov 2026 02:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054962;
	bh=PZssWpdWL6QECNLs/TrUJgWqHZL0xwva4laV6s5F/Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+vXbNakTheL9k2OpFM2DZOv7E0AZgLRb0CNd5bvwhcOApG5DyGyAEF6prCt14hzb
	 4PCh5+r+lb59aja8vvEGLROrDYsX79J4UHfRwJ7P08LydG+l9ibwqfeebNjKja9/kD
	 pn5cC+kEyOav/DTa35GAkdE/2waEnJ1uOuqdlx50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marco Elver <elver@google.com>,
	Jani Nikula <jani.nikula@intel.com>,
	David Sterba <dsterba@suse.com>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Alex Shi <alexs@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1460/2214] Kbuild: move to -std=gnu11
Date: Wed, 18 Nov 2026 15:52:16 +0100
Message-ID: <20261118150109.471986365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e8c07082a810fbb9db303a2b66b66b8d7e588b53 ]

During a patch discussion, Linus brought up the option of changing
the C standard version from gnu89 to gnu99, which allows using variable
declaration inside of a for() loop. While the C99, C11 and later standards
introduce many other features, most of these are already available in
gnu89 as GNU extensions as well.

An earlier attempt to do this when gcc-5 started defaulting to
-std=gnu11 failed because at the time that caused warnings about
designated initializers with older compilers. Now that gcc-5.1 is
the minimum compiler version used for building kernels, that is no
longer a concern. Similarly, the behavior of 'inline' functions changes
between gnu89 using gnu_inline behavior and gnu11 using standard c99+
behavior, but this was taken care of by defining 'inline' to include
__attribute__((gnu_inline)) in order to allow building with clang a
while ago.

Nathan Chancellor reported a new -Wdeclaration-after-statement
warning that appears in a system header on arm, this still needs a
workaround.

The differences between gnu99, gnu11, gnu1x and gnu17 are fairly
minimal and mainly impact warnings at the -Wpedantic level that the
kernel never enables. Between these, gnu11 is the newest version
that is supported by all supported compiler versions, though it is
only the default on gcc-5, while all other supported versions of
gcc or clang default to gnu1x/gnu17.

Link: https://lore.kernel.org/lkml/CAHk-=wiyCH7xeHcmiFJ-YgXUy2Jaj7pnkdKpcovt8fYbVFW3TA@mail.gmail.com/
Link: https://github.com/ClangBuiltLinux/linux/issues/1603
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: David Sterba <dsterba@suse.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Alex Shi <alexs@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: e6b49f8016ee ("dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/process/programming-language.rst              | 6 +++---
 .../translations/it_IT/process/programming-language.rst     | 4 ++--
 .../translations/zh_CN/process/programming-language.rst     | 3 +--
 .../translations/zh_TW/process/programming-language.rst     | 3 +--
 Makefile                                                    | 4 ++--
 arch/arm64/kernel/vdso32/Makefile                           | 2 +-
 6 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/Documentation/process/programming-language.rst b/Documentation/process/programming-language.rst
index ec474a70a02fa..5fc9160ca1fa5 100644
--- a/Documentation/process/programming-language.rst
+++ b/Documentation/process/programming-language.rst
@@ -5,9 +5,9 @@ Programming Language
 
 The kernel is written in the C programming language [c-language]_.
 More precisely, the kernel is typically compiled with ``gcc`` [gcc]_
-under ``-std=gnu89`` [gcc-c-dialect-options]_: the GNU dialect of ISO C90
-(including some C99 features). ``clang`` [clang]_ is also supported, see
-docs on :ref:`Building Linux with Clang/LLVM <kbuild_llvm>`.
+under ``-std=gnu11`` [gcc-c-dialect-options]_: the GNU dialect of ISO C11.
+``clang`` [clang]_ is also supported, see docs on
+:ref:`Building Linux with Clang/LLVM <kbuild_llvm>`.
 
 This dialect contains many extensions to the language [gnu-extensions]_,
 and many of them are used within the kernel as a matter of course.
diff --git a/Documentation/translations/it_IT/process/programming-language.rst b/Documentation/translations/it_IT/process/programming-language.rst
index 41db2598ce119..c1a9b481a6f99 100644
--- a/Documentation/translations/it_IT/process/programming-language.rst
+++ b/Documentation/translations/it_IT/process/programming-language.rst
@@ -10,8 +10,8 @@ Linguaggio di programmazione
 
 Il kernel è scritto nel linguaggio di programmazione C [it-c-language]_.
 Più precisamente, il kernel viene compilato con ``gcc`` [it-gcc]_ usando
-l'opzione ``-std=gnu89`` [it-gcc-c-dialect-options]_: il dialetto GNU
-dello standard ISO C90 (con l'aggiunta di alcune funzionalità da C99).
+l'opzione ``-std=gnu11`` [it-gcc-c-dialect-options]_: il dialetto GNU
+dello standard ISO C11.
 Linux supporta anche ``clang`` [it-clang]_, leggete la documentazione
 :ref:`Building Linux with Clang/LLVM <kbuild_llvm>`.
 
diff --git a/Documentation/translations/zh_CN/process/programming-language.rst b/Documentation/translations/zh_CN/process/programming-language.rst
index 2a47a1d2ec20f..fabdc338dbfbc 100644
--- a/Documentation/translations/zh_CN/process/programming-language.rst
+++ b/Documentation/translations/zh_CN/process/programming-language.rst
@@ -9,8 +9,7 @@
 ============
 
 内核是用C语言 :ref:`c-language <cn_c-language>` 编写的。更准确地说，内核通常是用 :ref:`gcc <cn_gcc>`
-在 ``-std=gnu89`` :ref:`gcc-c-dialect-options <cn_gcc-c-dialect-options>` 下编译的：ISO C90的 GNU 方言（
-包括一些C99特性）
+在 ``-std=gnu11`` :ref:`gcc-c-dialect-options <cn_gcc-c-dialect-options>` 下编译的：ISO C11的 GNU 方言
 
 这种方言包含对语言 :ref:`gnu-extensions <cn_gnu-extensions>` 的许多扩展，当然，它们许多都在内核中使用。
 
diff --git a/Documentation/translations/zh_TW/process/programming-language.rst b/Documentation/translations/zh_TW/process/programming-language.rst
index 54e3699eadf85..144bdaf81a416 100644
--- a/Documentation/translations/zh_TW/process/programming-language.rst
+++ b/Documentation/translations/zh_TW/process/programming-language.rst
@@ -12,8 +12,7 @@
 ============
 
 內核是用C語言 :ref:`c-language <tw_c-language>` 編寫的。更準確地說，內核通常是用 :ref:`gcc <tw_gcc>`
-在 ``-std=gnu89`` :ref:`gcc-c-dialect-options <tw_gcc-c-dialect-options>` 下編譯的：ISO C90的 GNU 方言（
-包括一些C99特性）
+在 ``-std=gnu11`` :ref:`gcc-c-dialect-options <tw_gcc-c-dialect-options>` 下編譯的：ISO C11的 GNU 方言
 
 這種方言包含對語言 :ref:`gnu-extensions <tw_gnu-extensions>` 的許多擴展，當然，它們許多都在內核中使用。
 
diff --git a/Makefile b/Makefile
index 5a3fb7729baaf..577eefed806f7 100644
--- a/Makefile
+++ b/Makefile
@@ -524,7 +524,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
 		   -Werror=implicit-function-declaration -Werror=implicit-int \
 		   -Werror=return-type -Wno-format-security \
-		   -std=gnu89
+		   -std=gnu11
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
@@ -808,7 +808,7 @@ KBUILD_CFLAGS-$(CONFIG_WERROR) += -Werror
 
 ifdef CONFIG_CC_IS_CLANG
 KBUILD_CPPFLAGS += -Qunused-arguments
-# The kernel builds with '-std=gnu89' so use of GNU extensions is acceptable.
+# The kernel builds with '-std=gnu11' so use of GNU extensions is acceptable.
 KBUILD_CFLAGS += -Wno-gnu
 # CLANG uses a _MergedGlobals as optimization, but this breaks modpost, as the
 # source of a reference will be _MergedGlobals and not on of the whitelisted names.
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 50cb1ec092ae5..d7f5b140a5d2a 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -77,7 +77,7 @@ VDSO_CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
                -Werror-implicit-function-declaration \
                -Wno-format-security \
                -Wdeclaration-after-statement \
-               -std=gnu89
+               -std=gnu11
 VDSO_CFLAGS  += -O2
 # Some useful compiler-dependent flags from top-level Makefile
 VDSO_CFLAGS += $(call cc32-option,-Wdeclaration-after-statement,)
-- 
2.53.0



