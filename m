Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769A91D04A8;
	Wed,  2 Oct 2024 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875995; cv=none; b=nRBuIkNKinaB8/O4qjxi21U7w//z1fxRoxHeVdFjyhm6uJU1+GphaYQH8hy+puZy+MFRnJzTVPfTseoHfujoCkwh8muNKj4MT27m7mjBZlcgoXKvm2rYUcK8MCiT5/eG1WntgGgA47WqJiMIyY2KXdtV9jl0I3td6lPXpP+wGk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875995; c=relaxed/simple;
	bh=bBQWtMm8m/B7cV9ecLAUflJFt4gLxZmpsNvTyVNJa0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJuc4iiJGfdiRCld0C/M84GF+y3GP8MrKcITffr4igt4vvN7OePC833P3XfT4oYL8zK05m6N9hcVHR8rp/C9np+BmeiMOGBGft2Ku3kWTl8CL8cED2LadPo3hEkyBdHhkwtYYtscb5pSLEgw06GuQpbaRHSvZlGGteDDIHMhYak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7UCas5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7UCas5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B62C4CEC5;
	Wed,  2 Oct 2024 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875995;
	bh=bBQWtMm8m/B7cV9ecLAUflJFt4gLxZmpsNvTyVNJa0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7UCas5+S+46OzQ9WJB+HFMooI7pnfrl39j/FTyOLVfL17OF0BDVPPC3JUY+rHF/B
	 Kb+5M0kP4Pvn7BduPK2duX7jy8oWn+9BHIv7rhRhFGxz37DRHzqO56k0HpwX3lMIHo
	 SKbeXwLoOaKrcgQXBt0Ll7eOlM9hBaly+LWRMlws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 261/695] selftests/bpf: Fix wrong binary in Makefile log output
Date: Wed,  2 Oct 2024 14:54:19 +0200
Message-ID: <20241002125832.865182939@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9351f37b720cf..848fffa250227 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -427,23 +427,24 @@ $(OUTPUT)/cgroup_getset_retval_hooks.o: cgroup_getset_retval_hooks.h
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
 
@@ -535,7 +536,7 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.bpf.o:				\
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS)         \
 					  $$($$<-CFLAGS)		\
-					  $$($$<-$2-CFLAGS))
+					  $$($$<-$2-CFLAGS),$(TRUNNER_BINARY))
 
 $(TRUNNER_BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-- 
2.43.0



