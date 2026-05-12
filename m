Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2FF385D85;
	Tue, 12 May 2026 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607895; cv=none; b=Hir2Gv68jfbAIFPE51zgZ3cLv2CfLkWeHjGlojWVrBhJODcj/L4lWUce3E5AnKd91zqEwnbeNEKAxSJxmg9LSVei+pkrTAEUeRungmo4U0OEz38MXF0meQM0Uj8lA5qYhrZS/HeLexlTCaN/ANYKHv3oG5YQrbZWrsCXaQAMIE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607895; c=relaxed/simple;
	bh=XH5ZwYTWjluBvvllSiaC+TkkUeWE/oX07iXqG200BKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqdBdCK/xUrTwQRrTtrGlVoGEx7/2yIIGmB2ujizKHB814rnD18CdTQ7c7PlI35STdwXwyYm/9JajFfF9mRoXBz/szbsI06J+/fyLt89MnqFQAwSoRSqxz/lwEKBiuDXfTRuWZ3F7LdKfs+2e9acDC2pmh5EVaGuiwLYLDpZUik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBcvnqCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBcvnqCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D74C2BCB0;
	Tue, 12 May 2026 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607895;
	bh=XH5ZwYTWjluBvvllSiaC+TkkUeWE/oX07iXqG200BKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBcvnqCj3oHqHAy7eyM0RKqqbB+RwPB+a+mX6808DIrzYItKpoufYkmxUbayUpKm+
	 MYvhOIpAe4CfUSzfwQjkoTWk3Yq15zWrS3UbseVkfFtBnP4w+J+EHk6cpKjZsR6G/6
	 /VpKZgWrvcm6MVx02thNzw8zsybcLpEYt2jP1nhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 077/206] LoongArch: Fix SYM_SIGFUNC_START definition for 32BIT
Date: Tue, 12 May 2026 19:38:49 +0200
Message-ID: <20260512173934.482313799@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/loongarch/include/asm/linkage.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/linkage.h b/arch/loongarch/include/asm/linkage.h
index a1bd6a3ee03a..ae937d1708b2 100644
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
-- 
2.54.0



