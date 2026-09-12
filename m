Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD9947B43F;
	Sat, 12 Sep 2026 12:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216225; cv=none; b=jARrbKh4Yo3/PbLhPXe8ubuGeIq7r/q97vRYB8DFz6Itrn8kajBd+iWcifKU+l8xciEK4+15HiVewhs0M2NQ5toNt9wJ668WWm3r7BYA9k/VoH7mAVYDcAS0a9zyHlcGfyD085irxnH33mUmoAfrhrESaICE6sqbiZWoK7gAv04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216225; c=relaxed/simple;
	bh=lN8uGan6dDpGEqKb2NEUbLH3Houw33LJMUXTNBcZKys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHyxa6naO/XjQyEeeBaAAZTNDD8JjJfg1i03l6cnADu6piOmIc5C/H9LsQY0xudZh/GR9k8ICEeX8rVl99XutmlhSNNPRwWz+6QyhNz2B7YU1RH9yI96vAF6EA93u1DxaO1EOvKmXzDmtCaAg7uD61A8fIN887baqxyyoUf3xoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0bYKh7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0bYKh7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4121F000FF;
	Sat, 12 Sep 2026 12:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216223;
	bh=xjsvNuM5drlM+E5NEv0C0j0P2669RSJ9L+nbxHO+ICA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0bYKh7kWf8KGjUmvCezg8/9fd4Fy9H6poNKQE+4CYkrNqxtEDhQbyVx3d9SrQn8f
	 6avMLs1EY5YrmZvF2JnnUL71w0UPfZ8ooLeyRjcuuB6DuuYPJm/r3dKI/8bbzpyDjb
	 h8zTT4A3PoWQmQg9fS4Uw+wPqQeNSzji9PMcK/Ns=
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
Subject: [PATCH 6.12 0691/1376] tools/build: Add bpftool-skeletons feature test
Date: Sat, 12 Sep 2026 08:51:57 +0200
Message-ID: <20260912065622.947311130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ffd117135094c..24e9acf84708a 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -110,7 +110,8 @@ FEATURE_TESTS_EXTRA :=                  \
          libbpf-bpf_create_map		\
          libpfm4                        \
          libdebuginfod			\
-         clang-bpf-co-re
+         clang-bpf-co-re		\
+         bpftool-skeletons
 
 
 FEATURE_TESTS ?= $(FEATURE_TESTS_BASIC)
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 592ca17b4b74a..af33e3fe69eac 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -426,6 +426,9 @@ $(OUTPUT)test-file-handle.bin:
 $(OUTPUT)test-libpfm4.bin:
 	$(BUILD) -lpfm
 
+$(OUTPUT)test-bpftool-skeletons.bin:
+	$(BPFTOOL) version | grep '^features:.*skeletons' \
+		> $(@:.bin=.make.output) 2>&1
 ###############################
 
 clean:
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 5f2afd95de430..8a7a6f07a61af 100644
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



