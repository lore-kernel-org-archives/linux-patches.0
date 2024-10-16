Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3BF1D2F4A;
	Wed, 16 Oct 2024 21:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113168; cv=none; b=QswL5hJeXAr+RRRVGMEFDgf2SxUV/aCsn88OuQQWHQoxquAUfZEr90ilq6mMUMHn/ts3xFWz3lTdiqkJyGuL2gOQ9Xxd3xdkcbMiadxbcxYikHMPAqv/KKUZ27u7HVTDeBywURYTCydjko1AF5bz8QUCN1QdQ018bLxJH+2WN4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113168; c=relaxed/simple;
	bh=Tx5OAIRhuHpTGueX/fN7PxdVTqTqNhozXaD5BbCIjDA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JrGLlggZ6t2KxrC43PE4NwzMiemkNoXinIxjEwlIgMFI+zrzNus8ooHaEzU9NI6As5VS0a+lBp0mGTlbx2xlbezQ0KhMPCKQ7hvAdV+VtuJvvtYMOCdHLLXM9pF7XPQTQV0FljE3MApHYQklWQBdarTFKiYE7UqgvdIQH1dZR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IY+/U/Ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IY+/U/Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F412AC4CED0;
	Wed, 16 Oct 2024 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729113167;
	bh=Tx5OAIRhuHpTGueX/fN7PxdVTqTqNhozXaD5BbCIjDA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IY+/U/YaQ+GHR6P5Z7HHUVSFRkhLvT18LgLID1Zi9JO6JCYlb4soAQT8gkX0uzRyN
	 9k4WdN5mqNF82g8R5E1kdpKzKIPjY8I7a8KzznAYRh7tib49w0vPEDXUInmqT/DuPe
	 NTN10KXf3wQE8xxjZudaaGWTP1Jq40osfjJN9ACR6xDZcO6XpygX6qP0aa/sZuUS1Z
	 y0f8lJkookgf4JmUEeC4vaeYqcU/+jpyvxHKt5RFtx8fSEJx07NS2aS+Z0lWi7nk6d
	 MDih4wwBq75vhm9pHipCNP8Y+yy8xHmKrRarVebczynv1I+3esefwEdPtcghZvUedX
	 MMFx6zcnnlk4w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 16 Oct 2024 14:12:38 -0700
Subject: [PATCH 2/2] um: Disable auto variable initialization for
 stub_exe.c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-uml-fix-stub_exe-clang-v1-2-3d6381dc5a78@kernel.org>
References: <20241016-uml-fix-stub_exe-clang-v1-0-3d6381dc5a78@kernel.org>
In-Reply-To: <20241016-uml-fix-stub_exe-clang-v1-0-3d6381dc5a78@kernel.org>
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Benjamin Berg <benjamin.berg@intel.com>, linux-um@lists.infradead.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1734; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Tx5OAIRhuHpTGueX/fN7PxdVTqTqNhozXaD5BbCIjDA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOkCOr69m9aqV71aunTbjgB9zSLGfX4hN5VE3i55yFbMm
 7dQOPNVRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIdTMjwxzTLYtOP/s706bQ
 vOTp+4MdDw5mPS+2blv2uGye9KoKSxuG/8k7QpiUk23rz9kZJL9JErzYM4trAotg0+LrthPFH0j
 l8wMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When automatic variable initialization is enabled via
CONFIG_INIT_STACK_ALL_{PATTERN,ZERO}, clang will insert a call to
memset() to initialize an object created with __builtin_alloca(). This
ultimately breaks the build when linking stub_exe because it is a
standalone executable that does not include or link against memset().

  ld: arch/um/kernel/skas/stub_exe.o: in function `_start':
  arch/um/kernel/skas/stub_exe.c:83:(.ltext+0x15): undefined reference to `memset'

Disable automatic variable initialization for stub_exe.c by passing the
default value of 'uninitialized' to '-ftrivial-auto-var-init', which
avoids generating the call to memset(). This code is small and runs
quickly as it is just designed to set up an environment, so stack
variable initialization is unnecessary overhead for little gain.

Fixes: 32e8eaf263d9 ("um: use execveat to create userspace MMs")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/um/kernel/skas/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/um/kernel/skas/Makefile b/arch/um/kernel/skas/Makefile
index f93db893b8236cf805edd01b41501d51dd8f0a35..f6a219074772283f3c6c6d8d6ccaa8a1cfc24e33 100644
--- a/arch/um/kernel/skas/Makefile
+++ b/arch/um/kernel/skas/Makefile
@@ -39,6 +39,11 @@ targets += stub_exe.dbg stub_exe $(stub_exe_objs-y)
 
 CFLAGS_stub.o := $(CFLAGS_NO_HARDENING)
 CFLAGS_stub_exe.o := $(CFLAGS_NO_HARDENING)
+
+# Clang will call memset() from __builtin_alloca() when stack variable
+# initialization is enabled, which is used in stub_exe.c.
+CFLAGS_stub_exe.o += $(call cc-option, -ftrivial-auto-var-init=uninitialized)
+
 UNPROFILE_OBJS := stub.o stub_exe.o
 KCOV_INSTRUMENT := n
 

-- 
2.47.0

