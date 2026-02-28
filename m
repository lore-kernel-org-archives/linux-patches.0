Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DA033A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301925; cv=none; b=j1/Oqbz+FtyarfHUbIjT1D8To7KBsWmW7g30rTcCIej1ynvfL7gSf79nhH5RMUrpya6zx9VWo4axYnPRN+eFVqm56yNeiDSPUPiWBVIBnoaDIUR0npai6BQtH4FSogOXG7urDfG644+1DYy7nI2apneixeiIhj+lEdtmWjXyxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301925; c=relaxed/simple;
	bh=p3AGt44M1lvKrDTWBzqFIKI9DiVPHFLOny5VlXsnriM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlPChVHsrA6OcmlMVjX9ChiMwwZ+VRkCMhgmR99kYb79equYwwIGPMXlrERNAOcz7BrC15jqJOpYkiC8taVv142nI2viHmPY1NbGD3Co/VjQIg93Kzg7u6z3/n5U3ShgdTCSZ9EIoA3U6fvhHbFCbIYSKCQbSfNdW4Wte8dBuBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSKDx46q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSKDx46q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1BAC116D0;
	Sat, 28 Feb 2026 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301925;
	bh=p3AGt44M1lvKrDTWBzqFIKI9DiVPHFLOny5VlXsnriM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSKDx46q6fhuLt+um4fvmHz2Z1Dxf9y76xCN/CAfj/3zhouO57qpzTkX7uZdp6mWJ
	 LyrIe8hgGvWiIRXzA4ydZD4I4D+ceiG0FBRxN7M5zIGB3rDuC7Hy1VIZ3Cv3RK3lvU
	 tbyPXPGh2oW3NZS8m0Zzc9rG0RhxzVazG+9usET7ZdUEUbnppiz41YAa+/8XwzK+kj
	 XN0VW2Nl9NWutySwanEfDf1LmdGkhmRWlsQ08YH+bQcbLq/v6zqX4M1kGgTp3YG94R
	 i3Bj/BDIJ+fXENTKTknvEXwSv7oOrVL8kf+TikZzY6UMQnKPWHhELI8FDRfWrCKeR1
	 TUs/vUZ+6jvig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jens Remus <jremus@linux.ibm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/385] kbuild: Add objtool to top-level clean target
Date: Sat, 28 Feb 2026 12:59:42 -0500
Message-ID: <20260228180011.1568201-360-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 94c1c8c7f899f..4193928df50c8 100644
--- a/Makefile
+++ b/Makefile
@@ -1370,6 +1370,15 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
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
@@ -1527,7 +1536,7 @@ vmlinuxclean:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
 
-clean: archclean vmlinuxclean resolve_btfids_clean
+clean: archclean vmlinuxclean resolve_btfids_clean objtool_clean
 
 # mrproper - Delete all generated files, including .config
 #
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index bf7f7f84ac625..02d1fccd495f4 100644
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

