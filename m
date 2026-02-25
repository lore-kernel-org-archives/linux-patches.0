Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE09D25A642;
	Wed, 25 Feb 2026 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983568; cv=none; b=jtW2F4pgtvVtOC+9Ecff58y6G7kha3yekUcn4yqNMYVJGvUkDb/3pFrtY0rJQx2+onhVlnhUlGifF6BahZwdzgljn3PDbqJMKE1GzjXpUY6N6N7LaHGhfJPxwkW9FKsB3MkAjrnOstkELPefly/1QcMUTlAul85Ahn/rYpNMw3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983568; c=relaxed/simple;
	bh=fEGyEByCqX2E+bhb3pgJ2fjc1bgQULVtvCAkCOr5yhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfZnqrxdJiF1Er2rLzqg0p4NjR2D4IkEHi/+qRYA7CEO0dpX5vKYBBpHgHsS3IcjiiXEhpvMm31DPAketZI0fGXs3xU8nWt1wWjs9H2aWMg2HsgURYJGBcy6vXrmzCBoRy9W6aTamQFENwvLcMpNgLkxz2c125KqJYkJqW7JTik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwsglv1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwsglv1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6C1C19423;
	Wed, 25 Feb 2026 01:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983568;
	bh=fEGyEByCqX2E+bhb3pgJ2fjc1bgQULVtvCAkCOr5yhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwsglv1sYIPCeqRIMyLjBftJNW6XYgVJxVx1P3DcnSbOrMFvb9cgLdtZMWtJJAvCc
	 TidT7GmtlQSVMl0z2lKWG7yK9tYCgn/LxnhW5nRiX7sxUEbds+g1uptfibooT3L0Me
	 0iHIKFNDdjEGiu1KOeDqMjN0/FI4jCH2Ei3hrA60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 626/781] kbuild: Add objtool to top-level clean target
Date: Tue, 24 Feb 2026 17:22:15 -0800
Message-ID: <20260225012415.167110696@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 21df635071198..7e34042743d9e 100644
--- a/Makefile
+++ b/Makefile
@@ -1474,6 +1474,15 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
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
@@ -1637,7 +1646,7 @@ vmlinuxclean:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
 
-clean: archclean vmlinuxclean resolve_btfids_clean
+clean: archclean vmlinuxclean resolve_btfids_clean objtool_clean
 
 # mrproper - Delete all generated files, including .config
 #
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index a40f302329291..6964175abdfdf 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -29,6 +29,8 @@ srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
 
+RM ?= rm -f
+
 LIBSUBCMD_DIR = $(srctree)/tools/lib/subcmd/
 ifneq ($(OUTPUT),)
   LIBSUBCMD_OUTPUT = $(abspath $(OUTPUT))/libsubcmd
-- 
2.51.0



