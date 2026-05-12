Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAEC3EDE4B;
	Tue, 12 May 2026 17:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608463; cv=none; b=oJY/Hk6ZFziVvBkTYOJ+CojQrL1xCucNa8itX4gEDp1j5q6Pl1m487upXsbvR4l9dy0JsH86Tk/jSV14HPhL4XPIfGwRvDEBt0mwz2FWgQK5qOpd+oF8Df+9rFE/RXUN107P6M5alwZhOF1vFspACmBSe38B0H1cdAxEKuWcRy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608463; c=relaxed/simple;
	bh=N0sETkCNcr3hzhu0tAEYcHyunkCcaqXPmWLe1RZXFIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDAGBfPvpgbS+YJdG97pj0d9o1fMzJ2/kK21P1FruaTJE5p910U1BSGH9nq8GJI9h6Th6YB7rg+1N9ofia4ubryxTNwVu8bnktV1zad95KGZ1MDJg/o1UMOwlXN1TDehT5WQbBytsZkVB7Pf2KHOORXvLH1recGgWSU22KBSR0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL4GIexM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL4GIexM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6499CC2BCB0;
	Tue, 12 May 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608463;
	bh=N0sETkCNcr3hzhu0tAEYcHyunkCcaqXPmWLe1RZXFIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL4GIexM806dCQ+tUpeLraTgs++nZAGmeK/WTceX62HpmhtpsYYyi2ysjPMjQDpVr
	 peEc2WC0pxhPeobIURVedRjRYsfDS9EeRbVV/K6kERF2zmG/yKGhjwroFScnXq2QTh
	 MOa565znFZ3qAhM8LhcwhDMyAjjuk4Tw9BVGGm+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 090/270] LoongArch: Fix SYM_SIGFUNC_START definition for 32BIT
Date: Tue, 12 May 2026 19:38:11 +0200
Message-ID: <20260512173940.355853083@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 98b8aebb14fdc0133939fd8fe07d0d98333dc976 upstream.

The SYM_SIGFUNC_START definition should match sigcontext that the length
of GPRs are 8 bytes for both 32BIT and 64BIT. So replace SZREG with 8 to
fix it.

Cc: stable@vger.kernel.org
Fixes: e4878c37f6679fde ("LoongArch: vDSO: Emit GNU_EH_FRAME correctly")
Suggested-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/linkage.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/linkage.h
+++ b/arch/loongarch/include/asm/linkage.h
@@ -69,7 +69,7 @@
 		  9,  10, 11, 12, 13, 14, 15, 16,	\
 		  17, 18, 19, 20, 21, 22, 23, 24,	\
 		  25, 26, 27, 28, 29, 30, 31;		\
-	.cfi_offset \num, SC_REGS + \num * SZREG;	\
+	.cfi_offset \num, SC_REGS + \num * 8;		\
 	.endr;						\
 							\
 	nop;						\


