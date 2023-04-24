Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284067C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A128DC433D2;
	Mon, 24 Apr 2023 13:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342909;
	bh=n/w5OF3SZziTUVBEcMJfgelS+24erpL3mGQ9JlQEHsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kChT8q8Yb1gxjwOkCB3iWx75mVLE0887sUlNUEnLMJ06g7tsZwZi2gHklAwJPWw9x
	 TiNMj+KtcmeAmXdB7tJEU45CHdiXCijBmk7FM1KUdL4SyhskkdlEVqg5ES9PaM7SCt
	 OjyCXRnzqinx8tO4+zcSEzx9bT8fCq5VvQisyIvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 84/98] MIPS: Define RUNTIME_DISCARD_EXIT in LD script
Date: Mon, 24 Apr 2023 15:17:47 +0200
Message-Id: <20230424131137.142239983@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 6dcbd0a69c84a8ae7a442840a8cf6b1379dc8f16 upstream.

MIPS's exit sections are discarded at runtime as well.

Fixes link error:
`.exit.text' referenced in section `__jump_table' of fs/fuse/inode.o:
defined in discarded section `.exit.text' of fs/fuse/inode.o

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 #define EMITS_PT_NOTE
 #endif
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips


