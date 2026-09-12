Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB3D4BEE5C;
	Sat, 12 Sep 2026 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223899; cv=none; b=CXT/Ry9V6RSczhPGwMnrYbTBIQqn4+UvkSE7ATjZyCwY4hZb8liKpYc7nmX7xEf8Spy+wZae2T7BHRwQXBfMIERcQ6E7JlS9iLqmNYmHQPVkgLN7TXrGlIeW8N9NiazpNJsfbc5M7H20mNcQ4x4IadAEQ40OQyu9Yte/6vQXJV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223899; c=relaxed/simple;
	bh=3tpTE9CNitvXqleOaYbU0xNhhE2n3Zr2f8NXiXNyHsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJQVfo9Ghk0hIH2avKdtWKAuaUuo3AttbAhQgArvDQNm8DeaS+Q2/WxNxPHxSxjTqilISudbs3x7Dkvd3j9ORDmQxeO1pt2UbcXcEuUvDiOb7EZLHml3uxVVQjKn3efuCyt7Jw5Z47HR1Ztc1yMfPPfHaB3gfxRtmIdCvVtIbOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpVz3Dma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpVz3Dma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF39C1F000FF;
	Sat, 12 Sep 2026 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223898;
	bh=PTBFnkIK8XsjPYrqy2kBLgEqMdaHtVIwMYQtPcSv5Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpVz3Dmamud2j14D22inJnTzO4WBZyfJx/7EiRMxU0T3FumQCMtxkJTXZRbmNCFhI
	 XWzYE3uBb4QX6g4RNZgDNB4/slspm1JkY7r7XFDcPtkNx5L1HJHBBopgNQV/P7Dgmc
	 hYGK2uRI5dq1hkVPi5LzPuwV/wKAR0adwLUd+Ee0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0883/1424] tools/build: Add bpftool-skeletons feature test
Date: Sat, 12 Sep 2026 08:55:15 +0200
Message-ID: <20260912065627.097610611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 8a635c3856ddb74ed3fe7c856b271cdfeb65f293 ]

Add bpftool-skeletons feature test, testing the presence of a bpftool
capable of generating skeletons.

This is to be used for tools that do not require building their own
bootstrap bpftool from the kernel source tree.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Link: https://lore.kernel.org/20250218145859.27762-3-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: d5a1d1270c89 ("tools/build: Allow versioning of all LLVM tools defined in Makefile.include")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature   | 3 ++-
 tools/build/feature/Makefile   | 3 +++
 tools/scripts/Makefile.include | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 934e2777a2dbc..b87d73bbcc307 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -109,7 +109,8 @@ FEATURE_TESTS_EXTRA :=                  \
          libbpf-bpf_create_map		\
          libpfm4                        \
          libdebuginfod			\
-         clang-bpf-co-re
+         clang-bpf-co-re		\
+         bpftool-skeletons
 
 
 FEATURE_TESTS ?= $(FEATURE_TESTS_BASIC)
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 17e03236e3461..9860dc8ed2236 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -402,6 +402,9 @@ $(OUTPUT)test-file-handle.bin:
 $(OUTPUT)test-libpfm4.bin:
 	$(BUILD) -lpfm
 
+$(OUTPUT)test-bpftool-skeletons.bin:
+	$(BPFTOOL) version | grep '^features:.*skeletons' \
+		> $(@:.bin=.make.output) 2>&1
 ###############################
 
 clean:
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index c006e72b4f434..620104eb3d3f1 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -91,6 +91,9 @@ LLVM_CONFIG	?= llvm-config
 LLVM_OBJCOPY	?= llvm-objcopy
 LLVM_STRIP	?= llvm-strip
 
+# Some tools require bpftool
+BPFTOOL		?= bpftool
+
 ifeq ($(CC_NO_CLANG), 1)
 EXTRA_WARNINGS += -Wstrict-aliasing=3
 
-- 
2.53.0



