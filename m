Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024027;
	b=yyloukpM9v/GYVs9UBN/wmudiLSsMP8oFt+Qx2dRGb9IDIMfJ46CxCkea1aG3PqArm/4
	 Gt8doxDdTNDD5/nc6IfEEgFV2Ra1/Gyuc7FV+z3ur1qwhUrOXbDIxrRTkav0rojVgrfpA
	 0EkRnGEbmBPvMSC3zd92EmHdo3KKqRnOCEaNzNGmYeDGFDH9FBKepRmU1ATbq5fZtWs6I
	 6woPSTXv7X/8KGF/Xo0yQRIjbqHZBFR5/YbtfnUDpKVNEPZC4CVSoazTA69bwuNeUqCBg
	 BGyKB6nq5J/12nsYUgzuHqst+GC2OjE7/bqep3EYdS5KLWBMYKouwgmBGYmtmO15P/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CewhjLnd4g+HFW3nQMr4c1GNl1LOnlgCuFE0n2WcUWc=;
	b=AunVbMgmlj3Rv1VZFdtJG2spekol0HNJcPN+sxtbL6oau4axVY1vIlJAFNw8K/KgJhVx
	 wtncU34GJNXuwZB3tZD09hjl0opSPuBSqThwBI3vAfz71AFGQwvRzD+JnCoHunPGzAeN+
	 JHEDQL0ON+5PGn8fInjE2RKQTtT5wWZ8U5I5jB8wCbnD7AqxGNnSjoFy2KepeQdQKVsXp
	 6/kFu4tSdF72u+N8hDvMgYGS9Id4rS3NzR/Sx6XvRzIn+uF89useto5z2ireEt43vUMsI
	 QwMLUv4GRDsiyaffft95W7vqUFAv5VA6mcWn4g2JGD1TAXeMd0abHM8+Fxn9IGnJE+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pRq5licu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF2606A32C;
	Wed, 18 Nov 2026 17:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pRq5licu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB05F1F000C6;
	Wed, 18 Nov 2026 17:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024027;
	bh=CewhjLnd4g+HFW3nQMr4c1GNl1LOnlgCuFE0n2WcUWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRq5licuswf+myIH/fpQ4j1ZzfVV4ZP7CBYmd0XGMIfAxcTNMZvUV3FKC0tkK+9uY
	 VnsR0pKxnr7ufdywRTvPdE+IAQMStJ4QYPeXaEFzhy15DxZNamb/ddUIsJBvd4czI0
	 1RY2tfOAkVG0ge3Cc0I6b/+Rkl0pqa2Ztw4tWjLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0579/2151] perf build: Use the given CC rather than clang in clang builds
Date: Wed, 18 Nov 2026 15:38:34 +0100
Message-ID: <20261118150143.045382007@linuxfoundation.org>
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

[ Upstream commit bd874cd8356166d8fb262d32f368c0e460910d5d ]

The clang block is entered when CC_NO_CLANG has determined that CC is
clang, but it then ignores CC and hard codes $(CLANG), which defaults to
plain "clang". Building with a versioned compiler silently switches
compiler:

  $ make CC=clang-19		# actually builds with "clang"

Worse, the target triple is probed with $(CLANG) too, so on a machine
that only has versioned binaries installed the probe produces nothing
and the build stops:

  $ make CC=clang-19
  *** Specify CROSS_COMPILE or add CLANG_TARGET_FLAGS for x86_64

Use $(CC) in both places. Within the block CC is known to be clang, and
for "make LLVM=1" CC is already $(CLANG), so nothing changes there.

$(CLANG) is left as it is for BPF skeletons, as bpf_skel.mak builds
those with "$(CLANG) --target=bpf" whatever CC happens to be.

Fixes: 4772e66cb45e0dd2 ("perf build: Support build with clang")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 1941700ed6ef0..1f96a1dd8dae8 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -37,7 +37,7 @@ ifeq ($(CC_NO_CLANG), 0)
 
   # Default to host architecture if ARCH is not explicitly given.
   ifeq ($(ARCH), $(HOSTARCH))
-    CLANG_TARGET_FLAGS := $(shell $(CLANG) -print-target-triple)
+    CLANG_TARGET_FLAGS := $(shell $(CC) -print-target-triple)
   else
     CLANG_TARGET_FLAGS := $(CLANG_TARGET_FLAGS_$(ARCH))
   endif
@@ -52,7 +52,7 @@ ifeq ($(CC_NO_CLANG), 0)
     CLANG_FLAGS += --target=$(notdir $(CROSS_COMPILE:%-=%))
   endif # CROSS_COMPILE
 
-  CC := $(CLANG) $(CLANG_FLAGS) -fintegrated-as
+  CC := $(CC) $(CLANG_FLAGS) -fintegrated-as
 
   # CC being clang says nothing about CXX: "make LLVM=1" overrides both, but
   # "make CC=clang" leaves CXX as g++. Probe CXX the way Makefile.include
-- 
2.53.0



