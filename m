Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B233B47E2;
	Tue, 21 Jul 2026 20:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666862; cv=none; b=sVRH3Qbh1OrQn0yyulSRMZWjGl9Lgjha2/z94eUOS34BswxXnWUOr1usqwf4QavPqa+HX7boiyy2bWIJpCvHvqBW7VU5XytXOJyL6EeaMV/qYNJacZ8xnR2VtDujoiQ3RhOLR9QEwl20chS/Gn1hSy65QB95DMeCba59wJuKSf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666862; c=relaxed/simple;
	bh=djWEKKnh9QqPfXHU14rmnBSmHuyWTS8vyWucgixOtUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lI+OaRbXAj/55PYRbmnDHX/Tw7ZpdXg1o0tfCzTnEtAXCVdBX7Rp0a/yWXw0Bm1EkCEJj6L0clPqegwi5LX/DY5+KDSd50Qh/L9gvgOzwGdNPCUUdRRVWukn9M6d4n4oHY9eHZkksWt9Kho5a5vwFWQBDUA2MzjXswMkG0by+K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jf8hmFMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jf8hmFMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BC41F00A3E;
	Tue, 21 Jul 2026 20:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666861;
	bh=HonArMWXBhl1i9bTElvqPXGLaXDW6WsNiWCYwGVQ6AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jf8hmFMhkh792Vd29aM3TJb3P0sYqiOYekPT23vdCF8Ew3EnNbONpwkaidenOr68G
	 KLjFtjD3EIwkYNfP24aJ0o0oqRG1EmbFWlOQZLD61wqUcgs/KueXOFW3CMouOYfskG
	 6wFEIV9gyPuWnnWxL0fX0qzGRhDqZMhLyUxP7tWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Justin Stitt <justinstitt@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 6.6 0844/1266] selftests/hid: do not manually call headers_install
Date: Tue, 21 Jul 2026 17:21:21 +0200
Message-ID: <20260721152500.742335864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 89d024a7ba02b6b969f89ac057442b5d3bcb4272 ]

"make headers" is a requirement before calling make on the selftests
dir, so we should not have to manually install those headers

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com> # Build
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20230825-wip-selftests-v3-2-639963c54109@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: eebbef7c468a ("selftests/hid: Cover hid_bpf_get_data() size overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/hid/Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index 2e75fb30f3a5e0..dc4f4cc35e5ad5 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -24,7 +24,7 @@ CXX ?= $(CROSS_COMPILE)g++
 
 HOSTPKG_CONFIG := pkg-config
 
-CFLAGS += -g -O0 -rdynamic -Wall -Werror -I$(KHDR_INCLUDES) -I$(OUTPUT)
+CFLAGS += -g -O0 -rdynamic -Wall -Werror -I$(OUTPUT)
 LDLIBS += -lelf -lz -lrt -lpthread
 
 # Silence some warnings when compiled with clang
@@ -68,7 +68,6 @@ BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
 SCRATCH_DIR := $(OUTPUT)/tools
 BUILD_DIR := $(SCRATCH_DIR)/build
 INCLUDE_DIR := $(SCRATCH_DIR)/include
-KHDR_INCLUDES := $(SCRATCH_DIR)/uapi/include
 BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
 ifneq ($(CROSS_COMPILE),)
 HOST_BUILD_DIR		:= $(BUILD_DIR)/host
@@ -154,9 +153,6 @@ else
 	$(Q)cp "$(VMLINUX_H)" $@
 endif
 
-$(KHDR_INCLUDES)/linux/hid.h: $(top_srcdir)/include/uapi/linux/hid.h
-	$(MAKE) -C $(top_srcdir) INSTALL_HDR_PATH=$(SCRATCH_DIR)/uapi headers_install
-
 $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
 		       $(TOOLSDIR)/bpf/resolve_btfids/main.c	\
 		       $(TOOLSDIR)/lib/rbtree.c			\
@@ -234,7 +230,7 @@ $(BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(OUTPUT)
 	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
 	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked1.o) name $(notdir $(<:.bpf.o=)) > $@
 
-$(OUTPUT)/%.o: %.c $(BPF_SKELS) $(KHDR_INCLUDES)/linux/hid.h
+$(OUTPUT)/%.o: %.c $(BPF_SKELS)
 	$(call msg,CC,,$@)
 	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
 
-- 
2.53.0



