Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5A31EF1D;
	Wed,  2 Oct 2024 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879632; cv=none; b=MZcas3loegfGQTWat3BUdPv2MW2s3F4JIJFKOFYc/QbMenRf0u+YerdFOq6MNAlPt4DYW8rU6O8GCFy/1xbkZkJUshtiHFXVcdcHyCsLlIjVUqMEEbcP4F1GGDjarTrWeIwCoMEO+5Kfx2pQGmigL4DpUYz6N77yebqPhGHEdHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879632; c=relaxed/simple;
	bh=++f91PyN84qez40Kxw6CEpeoYqhmvx5qnVenTya3Yso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/LZ/OmlhbQ4bHCtFHs/rozvAtt2sDj5hqCHwYiE7n5IfAm0Ft7ZTsv/UiGhfVTpGpX5YHim0J0n79CZmSkKeKceShXfga4YiapZfH+JA4v3e+4w5Tb++SUHy7o0zRrxE/CFtpfln/+eF2dZ1Gmus12qHgZ4AVLtJB0SWpJl1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETpSMOhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETpSMOhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DC1C4CEC2;
	Wed,  2 Oct 2024 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879632;
	bh=++f91PyN84qez40Kxw6CEpeoYqhmvx5qnVenTya3Yso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETpSMOhhDq0QVP4jPo/mK1I3H+XW2wekuBo4trQVs1gKSk/zLDCDW0g4U4wxeBUVN
	 mdr8qGRoEcJmngBCaxtMMPi54YlNS3lJH0odh+huI//Y+qwTgkMhIK9O/51gvLcn2W
	 XvGa7IrblrzzHHbP8jwrlSD9heCLkSbqfj6/6v04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cupertino Miranda <cupertino.miranda@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/538] selftests/bpf: Add CFLAGS per source file and runner
Date: Wed,  2 Oct 2024 14:57:04 +0200
Message-ID: <20241002125759.562217965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cupertino Miranda <cupertino.miranda@oracle.com>

[ Upstream commit 207cf6e649ee551ab3bdb1cfe1b2848e6a4337a5 ]

This patch adds support to specify CFLAGS per source file and per test
runner.

Signed-off-by: Cupertino Miranda <cupertino.miranda@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20240507122220.207820-2-cupertino.miranda@oracle.com
Stable-dep-of: 3ece93a4087b ("selftests/bpf: Fix wrong binary in Makefile log output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 24b85060df779..0093d1161c6ee 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -60,11 +60,11 @@ TEST_INST_SUBDIRS += bpf_gcc
 # The following tests contain C code that, although technically legal,
 # triggers GCC warnings that cannot be disabled: declaration of
 # anonymous struct types in function parameter lists.
-progs/btf_dump_test_case_bitfields.c-CFLAGS := -Wno-error
-progs/btf_dump_test_case_namespacing.c-CFLAGS := -Wno-error
-progs/btf_dump_test_case_packing.c-CFLAGS := -Wno-error
-progs/btf_dump_test_case_padding.c-CFLAGS := -Wno-error
-progs/btf_dump_test_case_syntax.c-CFLAGS := -Wno-error
+progs/btf_dump_test_case_bitfields.c-bpf_gcc-CFLAGS := -Wno-error
+progs/btf_dump_test_case_namespacing.c-bpf_gcc-CFLAGS := -Wno-error
+progs/btf_dump_test_case_packing.c-bpf_gcc-CFLAGS := -Wno-error
+progs/btf_dump_test_case_padding.c-bpf_gcc-CFLAGS := -Wno-error
+progs/btf_dump_test_case_syntax.c-bpf_gcc-CFLAGS := -Wno-error
 endif
 
 ifneq ($(CLANG_CPUV4),)
@@ -451,7 +451,7 @@ LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(ske
 # $eval()) and pass control to DEFINE_TEST_RUNNER_RULES.
 # Parameters:
 # $1 - test runner base binary name (e.g., test_progs)
-# $2 - test runner extra "flavor" (e.g., no_alu32, cpuv4, gcc-bpf, etc)
+# $2 - test runner extra "flavor" (e.g., no_alu32, cpuv4, bpf_gcc, etc)
 define DEFINE_TEST_RUNNER
 
 TRUNNER_OUTPUT := $(OUTPUT)$(if $2,/)$2
@@ -479,7 +479,7 @@ endef
 # Using TRUNNER_XXX variables, provided by callers of DEFINE_TEST_RUNNER and
 # set up by DEFINE_TEST_RUNNER itself, create test runner build rules with:
 # $1 - test runner base binary name (e.g., test_progs)
-# $2 - test runner extra "flavor" (e.g., no_alu32, cpuv4, gcc-bpf, etc)
+# $2 - test runner extra "flavor" (e.g., no_alu32, cpuv4, bpf_gcc, etc)
 define DEFINE_TEST_RUNNER_RULES
 
 ifeq ($($(TRUNNER_OUTPUT)-dir),)
@@ -502,7 +502,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.bpf.o:				\
 		     | $(TRUNNER_OUTPUT) $$(BPFOBJ)
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS)         \
-					  $$($$<-CFLAGS))
+					  $$($$<-CFLAGS)		\
+					  $$($$<-$2-CFLAGS))
 
 $(TRUNNER_BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-- 
2.43.0



