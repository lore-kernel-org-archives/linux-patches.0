Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408D22108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E70C433EF;
	Mon, 24 Apr 2023 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343083;
	bh=73SbislDn2ykqWBi2Vto4uDZIf5XFY6WGsgFTYN6mgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHuYnzSZdxDYMxS65hHzQnBK9abWaCnwDm7kT2p5agDGI7AJNHbva0eu2pA1vWCGK
	 W/uoFla30chUo7A9GHVbiIZ6+4JsbbrvYUVHUpqPdOsF02pEMSA72+mPEzXvrngnCG
	 YJ0E5qvXBeH31huJCPJSiuUnd0R8C7k1HOLbEDUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Chong Qiao <qiaochong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.2 063/110] LoongArch: module: set section addresses to 0x0
Date: Mon, 24 Apr 2023 15:17:25 +0200
Message-Id: <20230424131138.692313747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

commit 93eb1215ed794a18ba8753e0654f069d58838966 upstream.

These got*, plt* and .text.ftrace_trampoline sections specified for
LoongArch have non-zero addressses. Non-zero section addresses in a
relocatable ELF would confuse GDB when it tries to compute the section
offsets and it ends up printing wrong symbol addresses. Therefore, set
them to zero, which mirrors the change in commit 5d8591bc0fbaeb6ded
("arm64 module: set plt* section addresses to 0x0").

Cc: stable@vger.kernel.org
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Chong Qiao <qiaochong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/module.lds.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/module.lds.h
+++ b/arch/loongarch/include/asm/module.lds.h
@@ -2,8 +2,8 @@
 /* Copyright (C) 2020-2022 Loongson Technology Corporation Limited */
 SECTIONS {
 	. = ALIGN(4);
-	.got : { BYTE(0) }
-	.plt : { BYTE(0) }
-	.plt.idx : { BYTE(0) }
-	.ftrace_trampoline : { BYTE(0) }
+	.got 0 : { BYTE(0) }
+	.plt 0 : { BYTE(0) }
+	.plt.idx 0 : { BYTE(0) }
+	.ftrace_trampoline 0 : { BYTE(0) }
 }


