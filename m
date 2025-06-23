Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DA3253F30;
	Mon, 23 Jun 2025 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685344; cv=none; b=Jj0AVRSuMGkqmUlai4XsQ7geSEMkiA0dVKlvKFNR4dgTrFKSD0BegmPQvqz8PcfFFM1zpdoMR+c5XfTKC4lrfTh7PbZoLxEggOMiKk+NjDlgEvqX/TjuUwLDlOfPMOcXIJTT9/fv6A1h5/XeXIIOWzYOL4a+Jfap2qi8hbx18bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685344; c=relaxed/simple;
	bh=jAizF0WEhlSfLjUKgUXfJtF00dm2ByZvXN05Vb64dIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6jiA9hnYPW+9qpL6V0cMXrhjKo+4hen3LJZWr289/el+ohbGsOMTN8d6+qpB8fC2aHvzHxAJ+4uJc/wpqM2WkSR59FkH6XpFNxNNgDWkeb8h1zEqt4SqCoUwG1tn5G7jk3lVcN0up+QExPbPIFSLz+Xg7iK1G1/zEKTKlZPm20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YX4AWovH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YX4AWovH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922D1C4CEEA;
	Mon, 23 Jun 2025 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685343;
	bh=jAizF0WEhlSfLjUKgUXfJtF00dm2ByZvXN05Vb64dIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YX4AWovHj+lBknO/QhJwiCK+yFYTaBce5jWbNXkETwEStjBXGkgtsOqWO6Hq6fcht
	 9ZONOymYWoa3p2TKf9mYFoldLP0VM3ML22LeVby1q8ZtngkBtYv4mMgcjBnD2VmYrh
	 3JxPjs7urLnHuWNkXoIoi1s9PdxTSaG+CMIOoWbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.4 087/222] x86/boot/compressed: prefer cc-option for CFLAGS additions
Date: Mon, 23 Jun 2025 15:07:02 +0200
Message-ID: <20250623130614.718063127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Desaulniers <ndesaulniers@google.com>

commit 994f5f7816ff963f49269cfc97f63cb2e4edb84f upstream.

as-option tests new options using KBUILD_CFLAGS, which causes problems
when using as-option to update KBUILD_AFLAGS because many compiler
options are not valid assembler options.

This will be fixed in a follow up patch. Before doing so, move the
assembler test for -Wa,-mrelax-relocations=no from using as-option to
cc-option.

Link: https://lore.kernel.org/llvm/CAK7LNATcHt7GcXZ=jMszyH=+M_LC9Qr6yeAGRCBbE6xriLxtUQ@mail.gmail.com/
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -39,7 +39,7 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += $(call cc-disable-warning, gnu)
 KBUILD_CFLAGS += -Wno-pointer-sign
 # Disable relocation relaxation in case the link is not PIE.
-KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
+KBUILD_CFLAGS += $(call cc-option,-Wa$(comma)-mrelax-relocations=no)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n


