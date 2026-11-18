Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024025;
	b=lWVn/9vgbI2cq/Wcfxci3kq+bnOvk5qkuIfVveDl8vAMYoNBqzKEnmMK9blas060mFb1
	 563kA4ieoV0Umj2bNlWt7OTG3GpqPRVUot7s3IZ0QQiv3PaNki52MgeNa4ydCVSxzJgNY
	 T/uEH2FmHwnh2l7U7qWtwG47ADYMfM4nUb1WO7fjqsAXAyXmMziOAjTA8UM79gB2WyZ3f
	 Yo/FGlfIRdJ4dOnCfSukYafWt4bQFk1EAIxjaZ1csZQSz0EsJM6B+z8kzS7Xnqdl738V1
	 J1JXcBZYSLZe5Pdfa0QLdN+6i3hxmVMu6Ce53irO/xNGhn+Fojw8sLED+4a1rBtAAjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUGXwzux1QHCRDrit0Dpm3xJqI+dvmfrcIsGiAeiT9k=;
	b=zvO4rrc4FswC2z3BxkJfqXH1oLTECMgdnGdrqfwCnq801MqaQzdenfAyOvx/Ssg2QnXh
	 bLviENWM+Q1oexrCvAVKC/wIaHXcPhxLrV6NAm8p5+0XNKGfd6sWEm9YOdTTTTDAQdb81
	 xhZnzJqvIdK983KApCgdsQFPWSiiIhuRiJwCNFES/1zqqhOFV6IecfAJTKbdPHdTn3mmy
	 Pf/32cDjZSQGpam51t/8RTtdPZ6OWFA2UITq2LS0ykj+TTD1InzXd50BsO9xHWeSuCEOL
	 jM9MK4wfeD2dUisaIWX3Fm4ZmUb4mhm5c5FHA+RlyO87BwilU7ABWZsXJQtYHxJxNSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObSyS3Gt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9435606A320;
	Wed, 18 Nov 2026 17:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObSyS3Gt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E081F000C4;
	Wed, 18 Nov 2026 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024024;
	bh=LUGXwzux1QHCRDrit0Dpm3xJqI+dvmfrcIsGiAeiT9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObSyS3Gtj2W1SV2ugoilW3PxWd4Z73E/++D7cbNZ0JfXdEdsigvp/d3PmvlGH9Edm
	 vP3YUfjRWjtVqle9ruroZVBSuIYcp58t+KZVpEEnSGCHwlcm/x/veM01Dn/D23lSBx
	 TnKjqJrnOzJ4tj6T/mzgOXBsTs5bLe7pjW72LoCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0578/2151] perf build: Only pass clang flags to CXX when CXX is clang
Date: Wed, 18 Nov 2026 15:38:33 +0100
Message-ID: <20261118150143.009620001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c8592f8da838a07ddd0011eeb444771b64193a0f ]

Building with "make CC=clang" appends clang's --target= and
-fintegrated-as to CXX, but CXX is only set to clang++ by "make LLVM=1".
With just CC=clang, CXX is still g++ and every C++ feature test dies:

  g++: error: unrecognized command-line option '--target=...'
  g++: error: unrecognized command-line option '-fintegrated-as'

The failures are silent, as feature tests are allowed to fail, so the
build quietly loses libllvm and C++ demangling support:

  $ make CC=clang && grep LIBLLVM .config-detected
  (nothing, whereas a gcc build reports CONFIG_LIBLLVM=y)

The block is entered when CC_NO_CLANG says CC is clang, which says
nothing about CXX. Probe CXX the same way tools/scripts/Makefile.include
probes CC, and only add the flags when CXX really is clang++.

Mixing a clang-built C with a g++-built C++ is fine here, the C++ code
is linked with -lstdc++ already.

Fixes: 4772e66cb45e0dd2 ("perf build: Support build with clang")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 06b6b4ce903c4..1941700ed6ef0 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -53,7 +53,14 @@ ifeq ($(CC_NO_CLANG), 0)
   endif # CROSS_COMPILE
 
   CC := $(CLANG) $(CLANG_FLAGS) -fintegrated-as
-  CXX := $(CXX) $(CLANG_FLAGS) -fintegrated-as
+
+  # CC being clang says nothing about CXX: "make LLVM=1" overrides both, but
+  # "make CC=clang" leaves CXX as g++. Probe CXX the way Makefile.include
+  # probes CC rather than assuming the two match.
+  CXX_NO_CLANG := $(shell if command -v $(firstword $(CXX)) >/dev/null 2>&1; then $(CXX) -dM -E -x c++ /dev/null; fi | grep -Fq "__clang__"; echo $$?)
+  ifeq ($(CXX_NO_CLANG), 0)
+    CXX := $(CXX) $(CLANG_FLAGS) -fintegrated-as
+  endif
 
   # Enabled Wthread-safety analysis for clang builds.
   CFLAGS += -Wthread-safety
-- 
2.53.0



