Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024141465B7;
	Thu, 13 Jun 2024 11:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279605; cv=none; b=jKqECB2BErNiPS+XQ3PWeGMXHI3B5o6SCLFOyJlHYFcs5p4yjkYqqel+nNmGX3Fa25rVp+Q6BCs7dU9P5D5JyjOpe/v4tmO/wlIBY1lanaVGqD7f37Anftc+O+cq+gwZ00otiBodXujOFhsX6RfqF5Bp/3ro5gUok4l+SaqVC20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279605; c=relaxed/simple;
	bh=wC6j2IdFveD85/Eieq1FfG7BIVCUIGe8knlGkSkEu9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNLgIbIOoVXJ5jxd/tj24aKCSP1hqO5XX4Pw2MR8nlSx39sMUzi7rMq25EOVgb0cVx6pKzEmpMoNWHy1nb1mUMQwjmuD6/aP/UFCn8rHhct0p+9A4oF6mttLPOdkXKgrxS98XqUQ5egNCfDXFgYtoGalU0ibsp1gjeTv9/3M+oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDOpzVv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDOpzVv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A768C2BBFC;
	Thu, 13 Jun 2024 11:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279604;
	bh=wC6j2IdFveD85/Eieq1FfG7BIVCUIGe8knlGkSkEu9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDOpzVv0CGZd7BJBD2DBO/P8JXJXjVQ1Q06+u6kkyNShx76SKhlKjMxqv3qlgAYf0
	 SNi6KPNIUbWwAWMdgmHWFFkBokGE7SEzzjsdJJy2POs4+pUPhspwuhddz4ANPL9XKK
	 HjzsmJb6RsbqT09i2vqxspnD149CAMQLS3RtjEqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.9 133/157] riscv: enable HAVE_ARCH_HUGE_VMAP for XIP kernel
Date: Thu, 13 Jun 2024 13:34:18 +0200
Message-ID: <20240613113232.551221329@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 7bed51617401dab2be930b13ed5aacf581f7c8ef upstream.

HAVE_ARCH_HUGE_VMAP also works on XIP kernel, so remove its dependency on
!XIP_KERNEL.

This also fixes a boot problem for XIP kernel introduced by the commit in
"Fixes:". This commit used huge page mapping for vmemmap, but huge page
vmap was not enabled for XIP kernel.

Fixes: ff172d4818ad ("riscv: Use hugepage mappings for vmemmap")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: <stable@vger.kernel.org>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240526110104.470429-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -103,7 +103,7 @@ config RISCV
 	select HAS_IOPORT if MMU
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMALLOC if HAVE_ARCH_HUGE_VMAP
-	select HAVE_ARCH_HUGE_VMAP if MMU && 64BIT && !XIP_KERNEL
+	select HAVE_ARCH_HUGE_VMAP if MMU && 64BIT
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE if !XIP_KERNEL
 	select HAVE_ARCH_KASAN if MMU && 64BIT


