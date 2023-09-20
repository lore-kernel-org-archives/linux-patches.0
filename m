Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BC32AB5E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCAEC433C8;
	Wed, 20 Sep 2023 12:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211861;
	bh=WAgPlw7j3JrqMVr4GLnrNdys5drP9S4+DEGf7LUWvTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIYZlR5rb8PxmWjeLselA7h8QizhEyIv4diklExtnf3QWD23Pr/J6fscbQ3WdXdRZ
	 xKxFb8Tlqz2IfLxYzwt6r/iKNpNXSR1BYMMGrIYyICAAYroLPNGablfj1U5gdzznwJ
	 SvmeYxJZsXgopVWBIA/ZfRFkwc7gOlzxlidQtzW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Alan Modra <amodra@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 4.19 037/273] powerpc/32: Include .branch_lt in data section
Date: Wed, 20 Sep 2023 13:27:57 +0200
Message-ID: <20230920112847.570819791@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

commit 98ecc6768e8fdba95da1fc1efa0ef2d769e7fe1c upstream.

When building a 32 bit powerpc kernel with Binutils 2.31.1 this warning
is emitted:

 powerpc-linux-gnu-ld: warning: orphan section `.branch_lt' from
 `arch/powerpc/kernel/head_44x.o' being placed in section `.branch_lt'

As of binutils commit 2d7ad24e8726 ("Support PLT16 relocs against local
symbols")[1], 32 bit targets can produce .branch_lt sections in their
output.

Include these symbols in the .data section as the ppc64 kernel does.

[1] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commitdiff;h=2d7ad24e8726ba4c45c9e67be08223a146a837ce
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Alan Modra <amodra@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -328,6 +328,7 @@ SECTIONS
 		*(.sdata2)
 		*(.got.plt) *(.got)
 		*(.plt)
+		*(.branch_lt)
 	}
 #else
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {


