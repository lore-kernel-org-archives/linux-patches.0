Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016759;
	b=2mHCArusU9og9oo/InV/ZvC2Q9Z2KmDWrslPb99xCGsc3W3hzU0U0zHU9ACGtFPJ3qP2
	 Smtx57xOVsR2a57gmArTD3kNLRvvc4/wWzLP4WZ4bUyVkCvDOiPTOwlPqsxXVUjrP7QRB
	 ykqrNOK6aX8PamBsSlA7HlLHLWTcCQtA61knpcKqVpe7hjyAJ3LCdc6Y5ttpsa1E9KUw9
	 1aGhtVIxBPaR1Jch3/0opNfAq3ihUrco67ElsIn94HbLxxXY0jzOGpNYtS8Ba3Wl3A1i8
	 1yYK2W9mpotEivPp/zeK6lljJep5szWF2qtdj9Qcqk6Pce0fp0N+9Wd6LiXYtXgCHmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRT7sWcchbc3BlikkMaj0d7EK/0aiaTf9c5c9OIWDdA=;
	b=hi4LyPLzetnbOk65Q9b0kV6fAOgLnS4LA/FW0cFcdiHYwFYZwWwFkV7nnPXVTQw5xNCs
	 h0M7FnPDQ0r5We4F9fCNKd2Vx1BvUWIwaq1sOEEN9uvUgFDFgj9rUml05Uu2HxPE83gtR
	 idgihEw/fPOYdwzLB+JDEvSgj7KkuVdZfhG6lyENUZKM1hNsHSmqGFF/4mQuxrj1fYiNP
	 3DqF7hWZxpO0QnGikPjjhxH/0Rc/4MJaWCAZ5vv4BLqNLmD0Fpg51/Xd5Qxslv60RNOnf
	 cUdVNCZ96F7sdqS4ofqfcx/Q4B9cIuj89hLzMa28J3BDyCt0HW+Y5UIKmXjz+SPP4Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDHeMj9d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8367606A31C;
	Wed, 18 Nov 2026 15:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDHeMj9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDD81F000C5;
	Wed, 18 Nov 2026 15:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016759;
	bh=iRT7sWcchbc3BlikkMaj0d7EK/0aiaTf9c5c9OIWDdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDHeMj9dlE59Gf5gvdGK0GCTNmJCJePwjR4rbImrO/Dlic4ZXDs5QwZukRUXD9hQ3
	 03+kemdwghF63/DS8YY8xaaG8zo2/iWSKwlcpxA3jtcXDHOu5YBkPK+Fh1Gdf3Obpz
	 lzvqqKQNt0VPeMOl9nNR+UBkDBf0Odly+yPze9JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0642/2651] perf build: Only pass clang flags to CXX when CXX is clang
Date: Wed, 18 Nov 2026 15:31:22 +0100
Message-ID: <20261118150310.796483222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4d5993da9f945..3f84e6548c0f5 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -54,7 +54,14 @@ ifeq ($(CC_NO_CLANG), 0)
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



