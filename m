Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A271CAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6B6C433C1;
	Thu, 27 Oct 2022 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890453;
	bh=FKKvkqNRc7pYspgvaaCwQhYHDiVriFgsESp9i+j7g5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gv00+Tz4neQ5dqYTqvqJmwjJkyq5IBSI7G5lHI+fqo+RPylS8kqaOIb+X36ECmebz
	 91z4OGsp+g/db9oRyJBT1piEfpdwXY8z245Y+MiCBFx7UNI7dMrNuC8plqslvGjV6A
	 nQJ/eXsUOBYhWZEUKpw1bx6nQgQNrX/cUxl5MhBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.10 76/79] Makefile.debug: re-enable debug info for .S files
Date: Thu, 27 Oct 2022 18:56:26 +0200
Message-Id: <20221027165056.896260482@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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

This is _not_ an upstream commit and just for 5.10.y only. It is based
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
@@ -842,7 +842,9 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
-ifneq ($(LLVM_IAS),1)
+ifeq ($(LLVM_IAS),1)
+KBUILD_AFLAGS	+= -g
+else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 


