Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8512034D385;
	Thu, 30 Jul 2026 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422834; cv=none; b=HJkfPeBqNmqOEbR61iglywUztOLpz+G/mxaO71QZlZjrGUh4Yn2XMS431C/MkcrYamG3+QQ+MP2rnNCAIXIMZewaeXlmHsmUVXIoQYu/n39yuy1eNHg57pUJeFegoE+X9xyLoAEGmgVSK96KjGHcXwYHBldV2Sw2uUgpRwb+y34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422834; c=relaxed/simple;
	bh=cG53a6UGUYKp4M6FzAv+nrj78GfiexhQpN9qNprJqBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5+XQRUVSIajnwIQ26yVjUMZF3H3wEfJNdu2NUFFFeJ5qi+k4mEXdlwtmeZmpVJARUufB57OulCgRzrSGbvDs9st2OUsLbevjsyw8T9+yCYmzDsA0XbpUtYnJx2U9O90Lr0Q1so/WdUeDt8ZIwvpojMp12fUX0M0okIQw0rouJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBaguijI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBaguijI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1BC1F000E9;
	Thu, 30 Jul 2026 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422833;
	bh=iaUzCc29PB8TZmOcNvCSFxKeSnHsyJ7xa6GH4maOcn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBaguijIYJobNPrZqr8+Wz47P2DLZW5Vtur0Z6ywAfeyuhJil04ooXJjNUtxyQfas
	 X5O92gcztMczsNUGmSCt2rzu8c7xB81/iHUMMmigm3lqf6f6AzeanTHDhjQhQdhOoK
	 60vMYElb9zFDhPpDlFtNDBg+aub7f+0WYYZ5UVBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 572/744] LoongArch: Increase TASK_STRUCT_OFFSET up to 2040 for 32BIT
Date: Thu, 30 Jul 2026 16:14:05 +0200
Message-ID: <20260730141456.443825847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 7917d16d14fb512f8ffe3815b7940b6c93ff4fde upstream.

THREAD_INFO_IN_TASK increase the size of task_struct, which casuses a
build error for the 32BIT kernel if RANDSTRUCT is enabled. So increase
TASK_STRUCT_OFFSET as big as possible (2040), but can still be aligned
and be fit in the addi.w instruction.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/asmmacro.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/asmmacro.h
+++ b/arch/loongarch/include/asm/asmmacro.h
@@ -14,7 +14,7 @@
 #ifdef CONFIG_64BIT
 #define TASK_STRUCT_OFFSET 0
 #else
-#define TASK_STRUCT_OFFSET 2000
+#define TASK_STRUCT_OFFSET 2040
 #endif
 
 	.macro	cpu_save_nonscratch thread


