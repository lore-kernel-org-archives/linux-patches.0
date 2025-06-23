Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E63222562;
	Mon, 23 Jun 2025 21:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713387; cv=none; b=GCjvy7ugjVOhSrSfaZ3GSfvykKgNb6Znqi8hW/BSE/62d0CtPKM/AGBQ+/HmJj3soAlLsysxKLfOFUoeWi3O4epaX2UiyDWgqBdEvVxbqEWxYyUtww31WorjWFnw4WNmCcCX5DxwTdhecy2NFxzOdMawQU+YnZCW489Gchh9bFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713387; c=relaxed/simple;
	bh=2PgrAxkl5qvLDnoDEvmy9/9CiD2vZQp9/8QLQRlx7vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVgcCXP5i823iT65ggSRyyXOKxhjuVkaR+JgFqBW9lhYmReCOJTSkhIuSh/aA+X3K4FemQ+saXGtqirA71gwGxya+Dj7PcuFs6shok8yGKsS2qRb+dK8vS+806SZ/udTo0bvhjnsbSSaKvwYa1ln7EIBM5vfPRu036qVnbXTUBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYE4h9IX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYE4h9IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F653C4CEEA;
	Mon, 23 Jun 2025 21:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713387;
	bh=2PgrAxkl5qvLDnoDEvmy9/9CiD2vZQp9/8QLQRlx7vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYE4h9IX7vJQXlHPtiHvlpYUkN9k0t/HplAfgGgS7i1Z1sRb2Xg57LqvLv8UoHSjg
	 k9JwjubCjXSMSaoUPwXPciXgr7B6nSxpR4w6VHEvnE6PZzMVEPIoPzbBZ0Iei9Dhw5
	 1TW3Zj9BDu3Nr40ljVXpfNMwgjHjhUJOw6+vEGwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.10 141/355] x86/boot/compressed: prefer cc-option for CFLAGS additions
Date: Mon, 23 Jun 2025 15:05:42 +0200
Message-ID: <20250623130630.957403633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -49,7 +49,7 @@ KBUILD_CFLAGS += $(call cc-option,-fmacr
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS += -D__DISABLE_EXPORTS
 # Disable relocation relaxation in case the link is not PIE.
-KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
+KBUILD_CFLAGS += $(call cc-option,-Wa$(comma)-mrelax-relocations=no)
 KBUILD_CFLAGS += -include $(srctree)/include/linux/hidden.h
 
 # sev-es.c indirectly inludes inat-table.h which is generated during


