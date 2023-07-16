Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADB49441
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1400C433C7;
	Sun, 16 Jul 2023 20:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539439;
	bh=KBaWHvdpa1Gayz7SI8/K6JFhee0Tf+x2yfJBKTGQPj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHD+j+PkkscTpOzy78TK3zsNhcz2OyZUP0BUQyoQ4UhgYP4CTWSGfgx3TDAPgMkeg
	 Kcy+PX9ZFMI6cvmeODIwH8Tu4/bNrpT/vlYXSnG9Nf7l8VD0jVuT5Xbov/K+nSMN8q
	 nZjYl5eVBzligvsorz3gvjnlV9dIDljmvzl8J2QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.4 786/800] LoongArch: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation
Date: Sun, 16 Jul 2023 21:50:39 +0200
Message-ID: <20230716195007.405079242@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: WANG Xuerui <git@xen0n.name>

commit 5ddc7a3794ddd3470635ebd325fa1dffea5b18c0 upstream.

This is a port of commit 08f6554ff90e ("mips: Include KBUILD_CPPFLAGS in
CHECKFLAGS invocation") to arch/loongarch, for fixing cross-compilation
of Linux/LoongArch with Clang, where previously the `--target` flag
would no longer be present for the CHECKFLAGS cc invocation leading to
build failure.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1787#issuecomment-1608306002
Signed-off-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -107,7 +107,7 @@ KBUILD_CFLAGS += -isystem $(shell $(CC)
 KBUILD_LDFLAGS	+= -m $(ld-emul)
 
 ifdef CONFIG_LOONGARCH
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif


