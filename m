Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C8336C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302246; cv=none; b=qdw4pipw2nRSoDHqqSVsXx0/xXtu7l+haelUOb6zzcCq8/vs21VcL5AOOQjTo7WgRzgPvCcFw6YOhRfhn/V2ofVaiU3Ss8JaQWs3tBnl2Y43giQhGI+Eh8n58ppUmpGJAr3dFwgjbmL+NH3L7TQX+qrP01zWM1Lm+/+R6qfQp1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302246; c=relaxed/simple;
	bh=hL2R4ut++MtFesiXlO+DIKl0ZXuACFPxyTtUORaoQXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7ktVR3RDW7lNzl+QBieM6ho9cZckgB+ohBZ/Gq7SyjHUzQhPrxtcZJVvWUWLq7yuEs0eRE4ZYdTSheTRMBKJ7pfrRPVqfJYt/lqxdVPHPPwgS+3TAeYzi4FO3zr9nAWNRYNIbD7OyxLSy85a+nMo7kv7qTsb2oQJnX1vuabTFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDdPwc4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDdPwc4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7730C19424;
	Sat, 28 Feb 2026 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302246;
	bh=hL2R4ut++MtFesiXlO+DIKl0ZXuACFPxyTtUORaoQXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDdPwc4MGycLxNcrF/AO4gUPd+MieAwdLk7/8Ys3kt7YN5XuZP1MOA7kxBfZpl92h
	 6gZhaWP2r3eYsKlNR7alu4Mm/pXpsKfsxG+bezUBEFn/5Fc/4Zvrkl1RC6Tr9kjbTD
	 VFMJLxF0zXskwPDI3h2WQ0nJMkvqDizYNu1URZDhFmNft+XaGW0fWljbwyF3oTdH0E
	 SHnapKz+Pfo8hNheOLU/r7IB0MxIpkGI1QnV64hO9Wq6BT+lqrwaKGWKkY9KQsnBxm
	 Dv1wnqHzJ2dt9f6ooz2Z/nphuCkWSXEXj6uEk5ww0fQjnOAbCOy4kR0u0evFY1C0XO
	 S4ev+UVCDprxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jens Remus <jremus@linux.ibm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/283] kbuild: Add objtool to top-level clean target
Date: Sat, 28 Feb 2026 13:06:41 -0500
Message-ID: <20260228180709.1583486-259-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 68b4fe32d73789dea23e356f468de67c8367ef8f ]

Objtool is an integral part of the build, make sure it gets cleaned by
"make clean" and "make mrproper".

Fixes: 442f04c34a1a ("objtool: Add tool to perform compile-time stack metadata validation")
Reported-by: Jens Remus <jremus@linux.ibm.com>
Closes: https://lore.kernel.org/15f2af3b-be33-46fc-b972-6b8e7e0aa52e@linux.ibm.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Tested-by: Jens Remus <jremus@linux.ibm.com>
Link: https://patch.msgid.link/968faf2ed30fa8b3519f79f01a1ecfe7929553e5.1770759919.git.jpoimboe@kernel.org
[nathan: use Closes: instead of Link: per checkpatch.pl]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile               | 11 ++++++++++-
 tools/objtool/Makefile |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b9c04d8271b94..1c7555ea8b06a 100644
--- a/Makefile
+++ b/Makefile
@@ -1356,6 +1356,15 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
 	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
 endif
 
+PHONY += objtool_clean
+
+objtool_O = $(abspath $(objtree))/tools/objtool
+
+objtool_clean:
+ifneq ($(wildcard $(objtool_O)),)
+	$(Q)$(MAKE) -sC $(abs_srctree)/tools/objtool O=$(objtool_O) srctree=$(abs_srctree) clean
+endif
+
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
 	$(Q)$(MAKE) O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
@@ -1509,7 +1518,7 @@ vmlinuxclean:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
 
-clean: archclean vmlinuxclean resolve_btfids_clean
+clean: archclean vmlinuxclean resolve_btfids_clean objtool_clean
 
 # mrproper - Delete all generated files, including .config
 #
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 83b100c1e7f68..e9a0f89e9c39a 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -7,6 +7,8 @@ srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
 
+RM ?= rm -f
+
 LIBSUBCMD_DIR = $(srctree)/tools/lib/subcmd/
 ifneq ($(OUTPUT),)
   LIBSUBCMD_OUTPUT = $(abspath $(OUTPUT))/libsubcmd
-- 
2.51.0

