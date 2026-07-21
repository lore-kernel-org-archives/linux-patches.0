Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37192449B0B;
	Tue, 21 Jul 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649309; cv=none; b=l6CzZ7npgkBuxht8dWAJLwdEd/gxRjflP1NGGlRjoFBBrPra48I1WwF8kDEdWG3a4/IwH997YunzVad6QxKdlzIc0FNaVrhRt4gr4ML5nP6xDR14DYKIcL00VVzm1FPp9AwDZFHPIzzbL8vIlwZEbZIOCiyW+xljYN4J2YHX/kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649309; c=relaxed/simple;
	bh=4tH2PBUrf39LXWKNjyNXok4zUChx/n7UFWVhCoNaxaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmZ9Brd2k3VU+vv3wxGSHakHArf8dg1vmiM3TeVNXqSClTYNF/q4KYSrj5v5YS2xu4+w9oxquRCcCLyDDDqfltP7NUqpDGFo2L5JBfTQSZXojEJrPb2vMdMQVluZT4PUf2NSS4sdkzXF1R3uVoW/YYnT7PypXa6TzTy+MueOL2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTMvCxUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTMvCxUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6907B1F000E9;
	Tue, 21 Jul 2026 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649307;
	bh=6Hcv07ePB9yzbSkQPLgO3jrecPRBTAuq9eEUwIz2c4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTMvCxUO+GfVvU673ZViVrb6xysna4W3Q3vrlD9jZdZrxupbCCLdBZAXF7mqsHHrv
	 z0UoG8lmXwLW3IX6AmNK8d1pt1s/4tFpvT7CmdVQ6M97JQqdgFULuq1WFYy7UVec75
	 NhNjyycBdNLMfuX86ZLai7z365pQK08DBlantCr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0529/2077] riscv: alternative: Pass vDSO start as parameter to apply_vdso_alternatives()
Date: Tue, 21 Jul 2026 17:03:22 +0200
Message-ID: <20260721152605.282647705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 6386161abb02880ace2cc965e73f7857b351706c ]

The dedicated vDSO with CFI should also be patched in the same way.
To prepare for that move the currently hardcoded vDSO start symbol
into a parameter.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260504-riscv-cfi-vdso-alternative-v1-3-bcdf3d37f62e@linutronix.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Stable-dep-of: d3e0634787a2 ("riscv: alternative: Also patch the CFI vDSO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/alternative.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 59991922a5dca5..89c283a5cec7ff 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -173,14 +173,14 @@ static void __init_or_module _apply_alternatives(struct alt_entry *begin,
 				stage);
 }
 
-static void __init apply_vdso_alternatives(void)
+static void __init apply_vdso_alternatives(void *start)
 {
 	const Elf_Ehdr *hdr;
 	const Elf_Shdr *shdr;
 	const Elf_Shdr *alt;
 	struct alt_entry *begin, *end;
 
-	hdr = (Elf_Ehdr *)vdso_start;
+	hdr = (Elf_Ehdr *)start;
 	shdr = (void *)hdr + hdr->e_shoff;
 	alt = find_section(hdr, shdr, ".alternative");
 	if (!alt)
@@ -204,7 +204,7 @@ void __init apply_boot_alternatives(void)
 			    RISCV_ALTERNATIVES_BOOT);
 
 	if (IS_ENABLED(CONFIG_MMU))
-		apply_vdso_alternatives();
+		apply_vdso_alternatives(vdso_start);
 }
 
 /*
-- 
2.53.0



