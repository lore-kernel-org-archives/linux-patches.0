Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F214273
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXrzT5lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B103C433C8;
	Wed,  4 Oct 2023 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444467;
	bh=jYVPHaBHKAhtJNSmXtfYPhckC5HORPuJPMovxDkdLyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXrzT5lJVznpO5iHAPyVzNSVDtBV+OhHqBsllOVABDReokKlyThd2kHXGALCUeTBM
	 rwSUuE0li6hg7F1lynkTwWOQcxtS7/cj9jXQ/iLd7FxkuolXWbt03kVPBocs8mntu8
	 33ujoXLCgITCDDImeYWUQyRqjz52VfPVynkVrQ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.5 260/321] LoongArch: Define relocation types for ABI v2.10
Date: Wed,  4 Oct 2023 19:56:45 +0200
Message-ID: <20231004175241.307982642@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 2761498876adebff77a43574639005b29e912c43 upstream.

The relocation types from 101 to 109 are used by GNU binutils >= 2.41,
add their definitions to use them in later patches.

Link: https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=include/elf/loongarch.h#l230
Cc: <stable@vger.kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/elf.h |    9 +++++++++
 arch/loongarch/kernel/module.c   |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/elf.h
+++ b/arch/loongarch/include/asm/elf.h
@@ -111,6 +111,15 @@
 #define R_LARCH_TLS_GD_HI20			98
 #define R_LARCH_32_PCREL			99
 #define R_LARCH_RELAX				100
+#define R_LARCH_DELETE				101
+#define R_LARCH_ALIGN				102
+#define R_LARCH_PCREL20_S2			103
+#define R_LARCH_CFA				104
+#define R_LARCH_ADD6				105
+#define R_LARCH_SUB6				106
+#define R_LARCH_ADD_ULEB128			107
+#define R_LARCH_SUB_ULEB128			108
+#define R_LARCH_64_PCREL			109
 
 #ifndef ELF_ARCH
 
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -382,7 +382,7 @@ typedef int (*reloc_rela_handler)(struct
 
 /* The handlers for known reloc types */
 static reloc_rela_handler reloc_rela_handlers[] = {
-	[R_LARCH_NONE ... R_LARCH_RELAX]		     = apply_r_larch_error,
+	[R_LARCH_NONE ... R_LARCH_64_PCREL]		     = apply_r_larch_error,
 
 	[R_LARCH_NONE]					     = apply_r_larch_none,
 	[R_LARCH_32]					     = apply_r_larch_32,


