Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D33633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B81C433D6;
	Wed,  2 Nov 2022 03:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359865;
	bh=6vsnFrj4QkMyEu1BoXGfX6S0+ttc6x5EMOUd+7r9q8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqVYEP5t9OJf5i8x7lRZwDHqGkr8fMJfXusBcABpgbbAxhk76Rsyt7zebHM03XYel
	 lj2W6yI/JlHNyh2isthHjPp/wa01t06EyIqyidtfrbA4282Qqqg5E741IDbdJrRItR
	 A1SOeY71OmezcFRcfpH43Sa+gfLbb4RmR5924DJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 23/78] Makefile.debug: re-enable debug info for .S files
Date: Wed,  2 Nov 2022 03:34:08 +0100
Message-Id: <20221102022053.666879382@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Desaulniers <ndesaulniers@google.com>

This is _not_ an upstream commit and just for 4.19.y only. It is based
on commit 32ef9e5054ec0321b9336058c58ec749e9c6b0fe upstream.

Alexey reported that the fraction of unknown filename instances in
kallsyms grew from ~0.3% to ~10% recently; Bill and Greg tracked it down
to assembler defined symbols, which regressed as a result of:

commit b8a9092330da ("Kbuild: do not emit debug info for assembly with LLVM_IAS=1")

In that commit, I allude to restoring debug info for assembler defined
symbols in a follow up patch, but it seems I forgot to do so in

commit a66049e2cf0e ("Kbuild: make DWARF version a choice")

Fixes: b8a9092330da ("Kbuild: do not emit debug info for assembly with LLVM_IAS=1")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -744,7 +744,9 @@ KBUILD_CFLAGS   += $(call cc-option, -gs
 else
 KBUILD_CFLAGS	+= -g
 endif
-ifneq ($(LLVM_IAS),1)
+ifeq ($(LLVM_IAS),1)
+KBUILD_AFLAGS	+= -g
+else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 endif


