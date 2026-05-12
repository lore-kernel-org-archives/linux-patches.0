Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A511342509;
	Tue, 12 May 2026 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609182; cv=none; b=Qv+DNIXhun+vlsgKuT5bKiaSJ7MK5AifRSGBE1imqCi7NBr/8FLYySZQNM5pF8cTnjZ558BkI5mlA4Rsybc6TRSqOlmD/RvDv1bhWNvwfgvZOrPKwdo/akb9Knv3ImqnxyYFFg43eNsLEzC+QvJAIv2Aws+FB0xwfuBCTu+eLko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609182; c=relaxed/simple;
	bh=QMyr1/4xYSttMz4VSfQjxuLKMMyP1EafPteJt1xSn9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTfIu28zokopYjXcw0O7SuNK/MoOqm9ZgKTcUqwVG+VVAhX8tmj05DRifsZCB0GXH+kYrc+94CpEDQ+IA+yKMqJA8j9XZyzlTR3Q1te+o5pjqNn54TzwKRzuVYind69dKeUwX6gWAg0BuZOcCL4RUVdXNrqOvjboRRECJjPoHqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riLAyl7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riLAyl7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7F6C2BCB0;
	Tue, 12 May 2026 18:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609182;
	bh=QMyr1/4xYSttMz4VSfQjxuLKMMyP1EafPteJt1xSn9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riLAyl7WRo7SyxHNILvbpUW6/N2xgtzbQnpSwSPX8SPJj7m06x2Tsv5BfAuriAKqO
	 uRq9jdJ2C96izqkjVc5iS4j8x+dfpQ695aFisLQywsAIjwMdQljw+z/pkXN8jTf4Ca
	 U0ODwXt0ERu/fr7ccaCPf2ezuoX7JCKntNf3Sx4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 097/307] LoongArch: Fix SYM_SIGFUNC_START definition for 32BIT
Date: Tue, 12 May 2026 19:38:12 +0200
Message-ID: <20260512173942.174193920@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


