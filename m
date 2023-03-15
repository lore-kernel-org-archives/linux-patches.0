Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AE64431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BB1C433EF;
	Wed, 15 Mar 2023 12:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883050;
	bh=rhxdufBm4e5kulz1JA4K+9qV2V4DEANXj5Xbx4cjepw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TGiev0oyYHDXMu2fdRg8Pw7SVpfsijkV816PjHiB8oplVAanqBfMUuNAlx8qqrVG
	 Rd2TaTzQ4tyblHuA8Cn9VPUxs5kGD+X3+JzBxOT7xNXOqbar2wgZTk6bhz0dPj/wyr
	 GXhiz3HGref4WpwVX9S4PAyGvahNgRHHY+rbEbXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 100/104] UML: define RUNTIME_DISCARD_EXIT
Date: Wed, 15 Mar 2023 13:13:11 +0100
Message-Id: <20230315115736.242436945@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

commit b99ddbe8336ee680257c8ab479f75051eaa49dcf upstream.

With CONFIG_VIRTIO_UML=y, GNU ld < 2.36 fails to link UML vmlinux
(w/wo CONFIG_LD_SCRIPT_STATIC).

  `.exit.text' referenced in section `.uml.exitcall.exit' of arch/um/drivers/virtio_uml.o: defined in discarded section `.exit.text' of arch/um/drivers/virtio_uml.o
  collect2: error: ld returned 1 exit status

This fix is similar to the following commits:

- 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
- a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
  with GNU ld < 2.36")
- c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT")

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/kernel/vmlinux.lds.S
+++ b/arch/um/kernel/vmlinux.lds.S
@@ -1,4 +1,4 @@
-
+#define RUNTIME_DISCARD_EXIT
 KERNEL_STACK_SIZE = 4096 * (1 << CONFIG_KERNEL_STACK_ORDER);
 
 #ifdef CONFIG_LD_SCRIPT_STATIC


