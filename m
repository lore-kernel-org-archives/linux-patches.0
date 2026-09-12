Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA2C4BEE38;
	Sat, 12 Sep 2026 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230082; cv=none; b=rJTaw/swmyyGn+o/jlf2UHrq+U6b7a+qcdSrnX68VPRaXSt8WgxTKL9AbAHPWoyskje/6Ug68iFCILYsBJaEC/Ad2mSULw5ealmFdNFPvbRLJNKyO5II2ut9ZrMVpHS2FkGwYKtsD5z+RUyXcfTkxsqfYyYP9reQCJ2TarwXNrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230082; c=relaxed/simple;
	bh=qGGCzyj5yL4XM5Ikn5ZoMM4BHTzQ9Mzv2oi5kmfLO6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+LpqUWGrxJXQXf30SZt/bTP6iilkB0kitxkgVY/IsP0+3snv5o+pZfw0m7zvN01ll6hgzxEKUhwdNme0prcQBKoPAWeitU8Avabiy0lE4WHPX2hS4JqTvrWeVa4KizONK7Co7ixxdUcXkFi0t00TH1LBKj/Q64Meb9FD4j76Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM75pI6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM75pI6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728A91F000FF;
	Sat, 12 Sep 2026 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230081;
	bh=YfKtX3gkT3S/LFIUl61PReKa3IVxPkcNR/ftCJ/dHBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM75pI6mpM1ift9owmYaC0hu4DDS5L4pZemR868Qgzj+QWeX6PZ2z+f9zoCM47PkW
	 njT/7VLAlExNCawAlgY+xiCuzgOjWjEfzVhDDQcGIlrwO6IS2qBWpqSb2cvotfZw16
	 QzzxCW24JVfGT+5fZot08ZcOD5p3dr6/MgJvrs1U=
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
Subject: [PATCH 6.1 0720/1191] tools/build: Add bpftool-skeletons feature test
Date: Sat, 12 Sep 2026 08:57:28 +0200
Message-ID: <20260912065604.452318332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38f8851bd7cbd..486fc0404bc9b 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -107,7 +107,8 @@ FEATURE_TESTS_EXTRA :=                  \
          libbpf-bpf_create_map		\
          libpfm4                        \
          libdebuginfod			\
-         clang-bpf-co-re
+         clang-bpf-co-re		\
+         bpftool-skeletons
 
 
 FEATURE_TESTS ?= $(FEATURE_TESTS_BASIC)
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 1b7886cbbb65a..d6a6a4e584aab 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -380,6 +380,9 @@ $(OUTPUT)test-file-handle.bin:
 $(OUTPUT)test-libpfm4.bin:
 	$(BUILD) -lpfm
 
+$(OUTPUT)test-bpftool-skeletons.bin:
+	$(BPFTOOL) version | grep '^features:.*skeletons' \
+		> $(@:.bin=.make.output) 2>&1
 ###############################
 
 clean:
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 5607e2405a72f..0a1b11e51fd69 100644
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



