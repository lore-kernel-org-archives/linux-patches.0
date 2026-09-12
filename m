Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE441384233;
	Sat, 12 Sep 2026 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203403; cv=none; b=efmcTho67ld2CPR3nfTMvOEV9SfdQ9RmgodHc57xmfcop/1j7vlxhQ/eJ+uvxLDtJMBpOFmQKfrsd39lrQE+aGAwjcd9G4IdFgR00AfaLKmvQd/dGvNlaXG25KjBDZCltkQNQM0JqDCW/z3O47cTl9+dMEuZaYnQrYMD7ssCJhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203403; c=relaxed/simple;
	bh=8EYIiyh0ubXyDGxFfLGsIO74N+grYCBqcMqxY7XjuHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVBNiSs5bv55OD4wNk8/T1oxuzZNo8H+9Hc9UfN7alGNoK4h7G2+BZNlSnPWkxRYvhVynrFvcIgtcV9gGV9SUiT/JBFaZAf+Y7f8s2oyL2FWA4+GCWC43CPof9FQATdY4zg8zCObvYHsFCE9fyQkJR3e9Gy09QaUuU9OqfVa23Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zygwvw6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zygwvw6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B341F000FF;
	Sat, 12 Sep 2026 08:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203401;
	bh=+ck6V6W7bf1O0bg2TVVYtDXKi+JAU1xGxN3WVR7G5Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zygwvw6g4xSN8ZHIwOKFmuIPnLTubYVhzLvlsQ0n1aiyY6kJFX8h1US5/K7XeFMDv
	 YBSlhsFlFZQLIONIZZKJfyOnWNkBLqCGoR7U3n7xhPBWy5/6b1t95R/FxloY+j39qe
	 xCRtN+JAe3bYS4gKF8HAFhRYlkPr5F9WCbKeywSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1400/1815] perf build: Remove leftover feature tests for removed cxx and clang support
Date: Sat, 12 Sep 2026 08:52:30 +0200
Message-ID: <20260912065721.889674737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b60f6bc128b972e018de6bcfa7007b4021f4a31a ]

56b11a2126bf2f42 ("perf bpf: Remove support for embedding clang for
compiling BPF events (-e foo.c)") removed the test-cxx.cpp and
test-clang.cpp sources, but left behind their entries in the feature
test FILES list, the build rules and the cxx and clang entries in
FEATURE_TESTS_EXTRA.

Since the sources no longer exist, those rules would always fail,
making the artificial feature-cxx and feature-clang results to be
perpetually disabled/absent, remove the leftover entries, making the
feature test scripts list match the available sources.

Fixes: 56b11a2126bf2f42 ("perf bpf: Remove support for embedding clang for compiling BPF events (-e foo.c)")
Cc: Ian Rogers <irogers@google.com>
Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature |  2 --
 tools/build/feature/Makefile | 14 --------------
 2 files changed, 16 deletions(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index ed1374af31c16..99eb0ea095375 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -123,9 +123,7 @@ FEATURE_TESTS_EXTRA :=                  \
          libbfd-liberty-z               \
          libopencsd                     \
          libperl                        \
-         cxx                            \
          llvm                           \
-         clang                          \
          libbpf                         \
          libpfm4                        \
          libdebuginfod			\
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 62909a9c799d3..7d165018116a5 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -55,7 +55,6 @@ FILES=                                          \
          test-bpf.bin                           \
          test-libbpf.bin                        \
          test-sdt.bin                           \
-         test-cxx.bin                           \
          test-gettid.bin			\
          test-jvmti.bin				\
          test-jvmti-cmlr.bin			\
@@ -63,7 +62,6 @@ FILES=                                          \
          test-sched_getcpu.bin			\
          test-setns.bin				\
          test-libopencsd.bin			\
-         test-clang.bin				\
          test-llvm.bin				\
          test-llvm-perf.bin   			\
          test-libaio.bin			\
@@ -335,9 +333,6 @@ $(OUTPUT)test-libbpf.bin:
 $(OUTPUT)test-sdt.bin:
 	$(BUILD)
 
-$(OUTPUT)test-cxx.bin:
-	$(BUILDXX) -std=gnu++11
-
 $(OUTPUT)test-gettid.bin:
 	$(BUILD)
 
@@ -363,15 +358,6 @@ $(OUTPUT)test-llvm-perf.bin:
 		$(shell $(LLVM_CONFIG) --system-libs)		\
 		> $(@:.bin=.make.output) 2>&1
 
-$(OUTPUT)test-clang.bin:
-	$(BUILDXX) -std=gnu++17					\
-		-I$(shell $(LLVM_CONFIG) --includedir) 		\
-		-L$(shell $(LLVM_CONFIG) --libdir)		\
-		-Wl,--start-group -lclang-cpp -Wl,--end-group	\
-		$(shell $(LLVM_CONFIG) --libs Core option)	\
-		$(shell $(LLVM_CONFIG) --system-libs)		\
-		> $(@:.bin=.make.output) 2>&1
-
 -include $(OUTPUT)*.d
 
 $(OUTPUT)test-libaio.bin:
-- 
2.53.0



