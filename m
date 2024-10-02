Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860CC1D12F8;
	Wed,  2 Oct 2024 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879635; cv=none; b=emPBOlnCxuo8zdrHCYd+Y3XcacTO/bGLtbGU0Hp2DMn/B0PSDW8T6quv5fp1Z7Vt2p95Jl//BJKVlVIF5E4fHT7QiJW5kF7QkPJgXs6/fjbcndo5mpHKVOrYDuSLFyt+qx7FmbJNzlC7Cr00fwqHKRPLdNoKOz4kuUsTA0IpuVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879635; c=relaxed/simple;
	bh=fXuwxMNuD9GWQJ7JWJSSvtHHVwRJ6LJjmJzWMYEvl4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z87dqOfLsosk68ZMqMsZMbtn6qBP92mGNqzV+aUb8tl78UcaO7zN8ReGcnn+0q+Jv8WNj1jfUShl5Vjr1Zw9GUnGY/kYdrDPO/vCF2P7Lt4sc3nnxU3ljsjR7J/MrEzEfMdDbOxLV6eMeiVhwxry88Hk5MAyvTnSxRghq8HjBRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsDyoU66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsDyoU66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8690AC4AF0C;
	Wed,  2 Oct 2024 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879635;
	bh=fXuwxMNuD9GWQJ7JWJSSvtHHVwRJ6LJjmJzWMYEvl4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsDyoU666F7T0oT+RuoASE9g9xeZN0+MWfPJ6xxpIaL7OAHkU3mi+4gO/2ko3LFtZ
	 WTSHLHJcunRbnbGFXRL9PxwcCPFgvAj7GPAsKOzDaIOImbAfC5Y8BPeo91OzRO5O9L
	 p/rr4GMTaL6+nlp3Qn4FWA2hX7FMvo4Epc8DpBc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/538] selftests/bpf: Fix wrong binary in Makefile log output
Date: Wed,  2 Oct 2024 14:57:05 +0200
Message-ID: <20241002125759.601847491@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 3ece93a4087b2db7b99ebb2412bd60cf26bbbb51 ]

Make log output incorrectly shows 'test_maps' as the binary name for every
'CLNG-BPF' build step, apparently picking up the last value defined for the
$(TRUNNER_BINARY) variable. Update the 'CLANG_BPF_BUILD_RULE' variants to
fix this confusing output.

Current output:
  CLNG-BPF [test_maps] access_map_in_map.bpf.o
  GEN-SKEL [test_progs] access_map_in_map.skel.h
  ...
  CLNG-BPF [test_maps] access_map_in_map.bpf.o
  GEN-SKEL [test_progs-no_alu32] access_map_in_map.skel.h
  ...
  CLNG-BPF [test_maps] access_map_in_map.bpf.o
  GEN-SKEL [test_progs-cpuv4] access_map_in_map.skel.h

After fix:
  CLNG-BPF [test_progs] access_map_in_map.bpf.o
  GEN-SKEL [test_progs] access_map_in_map.skel.h
  ...
  CLNG-BPF [test_progs-no_alu32] access_map_in_map.bpf.o
  GEN-SKEL [test_progs-no_alu32] access_map_in_map.skel.h
  ...
  CLNG-BPF [test_progs-cpuv4] access_map_in_map.bpf.o
  GEN-SKEL [test_progs-cpuv4] access_map_in_map.skel.h

Fixes: a5d0c26a2784 ("selftests/bpf: Add a cpuv4 test runner for cpu=v4 testing")
Fixes: 89ad7420b25c ("selftests/bpf: Drop the need for LLVM's llc")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20240720052535.2185967-1-tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 0093d1161c6ee..ab364e95a9b23 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -395,23 +395,24 @@ $(OUTPUT)/cgroup_getset_retval_hooks.o: cgroup_getset_retval_hooks.h
 # $1 - input .c file
 # $2 - output .o file
 # $3 - CFLAGS
+# $4 - binary name
 define CLANG_BPF_BUILD_RULE
-	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
+	$(call msg,CLNG-BPF,$4,$2)
 	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v3 -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
 define CLANG_NOALU32_BPF_BUILD_RULE
-	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
+	$(call msg,CLNG-BPF,$4,$2)
 	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v2 -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with cpu-v4
 define CLANG_CPUV4_BPF_BUILD_RULE
-	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
+	$(call msg,CLNG-BPF,$4,$2)
 	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v4 -o $2
 endef
 # Build BPF object using GCC
 define GCC_BPF_BUILD_RULE
-	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
+	$(call msg,GCC-BPF,$4,$2)
 	$(Q)$(BPF_GCC) $3 -DBPF_NO_PRESERVE_ACCESS_INDEX -Wno-attributes -O2 -c $1 -o $2
 endef
 
@@ -503,7 +504,7 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.bpf.o:				\
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS)         \
 					  $$($$<-CFLAGS)		\
-					  $$($$<-$2-CFLAGS))
+					  $$($$<-$2-CFLAGS),$(TRUNNER_BINARY))
 
 $(TRUNNER_BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-- 
2.43.0



