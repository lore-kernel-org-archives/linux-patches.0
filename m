Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DB18F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D94C433C7;
	Sun, 16 Jul 2023 20:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539240;
	bh=PZb9GWddQADOiJrKrzADKUB01skpQR8H/5gD991yoPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdoXA4ztK0OcJMpCtq01eB7FqN9ogsCrL/1yYR4YkX5CrpswxA46UtsViWU8XkVqI
	 qq1vWUEGO4Sbq0b6RdpfsnuOSHehlceFjyik6hEkOBUun0bcl8uOta3FMZ3bxA0PJU
	 6m+XGSXvFbZSBGRswXCEiLGeKcFI/ZuuYHnhELso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	linux-um@lists.infradead.org,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.4 738/800] um: Use HOST_DIR for mrproper
Date: Sun, 16 Jul 2023 21:49:51 +0200
Message-ID: <20230716195006.258998624@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit a5a319ec2c2236bb96d147c16196d2f1f3799301 upstream.

When HEADER_ARCH was introduced, the MRPROPER_FILES (then MRPROPER_DIRS)
list wasn't adjusted, leaving SUBARCH as part of the path argument.
This resulted in the "mrproper" target not cleaning up arch/x86/... when
SUBARCH was specified. Since HOST_DIR is arch/$(HEADER_ARCH), use it
instead to get the correct path.

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: linux-um@lists.infradead.org
Fixes: 7bbe7204e937 ("um: merge Makefile-{i386,x86_64}")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230606222442.never.807-kees@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -149,7 +149,7 @@ export CFLAGS_vmlinux := $(LINK-y) $(LIN
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
 CLEAN_FILES += linux x.i gmon.out
-MRPROPER_FILES += arch/$(SUBARCH)/include/generated
+MRPROPER_FILES += $(HOST_DIR)/include/generated
 
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \


