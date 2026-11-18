Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059300;
	b=pfnxYHpGRVOW67tPQOi26AW/vmbl9D0/+R5sgo8jk8tO1UC3ARhKia75NGRN0aDdlgVZ
	 /FLZwsylKIqJ9H/JRzntGM3NwuqTgW+4ICZod6uZL2Ng4IQesmHdQGKcY/RTX9ncvNeLq
	 Z1QQTXwaUuclGN8mKCIoNcFwVQAgP/aadKjwFgQ4By4AwuTOu0ImnV5oONASKFqIiFDg+
	 42uxO98vSEmpXHdMoHooGJyEpj9fDM/JrH5q9H6B6+reQ1ShwJFD/f88XoUpFEqpojF2L
	 qSSBia6h4gIpQ0VYiwaIK59O/7OwZFFkKWcsrNiMxzWrflrtwRJLThZns6+ve2dy8pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s0KR7lAIiOvaScML4fxlJFNUOKV0EsVk0uYoIgezVK4=;
	b=ZZP+2xGKb5xyH8YwYHJqsmFzfifY3R9LEskNVPrS+GM5gf4G7ECkC0GOvyrqRKRh/rug
	 UXmvgamP3A69bWYaPNtXGzGPbpqc0o6mwX8vzMC4JRLKtalHB9Jn1/nvgSymlqhjAEOhC
	 3UBXRxnTj2snrbbs4R602W0gZCKnzIiilJf6zIXNTTwRGjWVO/UY1kns2jD9updks9B+3
	 6lFWxGzMCe+RlMd4i7KtRdzbGydTQiC+QwHb9JiSjMJfmATweB0bHfxdFssbSpHLvIvym
	 EfYwaF8pu7Ogo/qIBL6rUbZxYw27QRzPWiZyjCC0OBJXEExPHEEzyGLcx98HYmr+Izw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gq2MjsEA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FB2606A326;
	Thu, 19 Nov 2026 03:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gq2MjsEA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26111F000C5;
	Thu, 19 Nov 2026 03:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059300;
	bh=s0KR7lAIiOvaScML4fxlJFNUOKV0EsVk0uYoIgezVK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gq2MjsEA1k0I5gfmtd8GSvFa1PpC1bF3TE1z7b2XqNjgSvjvuOqR6KlHcZIH4Ff/D
	 JODAhvDn/RT3OkaNkbTYFrjsyItAmHQAs2HshPx+uNON0ZNSROVJknBrcWOm2dwLBi
	 hc6G+S/otBLD2lbrYvuIG/3opzjBinziQh31hjx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0755/1848] x86/boot: Fix off-by-one error in sme_clear_pgd()
Date: Wed, 18 Nov 2026 15:46:33 +0100
Message-ID: <20261118145948.099469213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit cb319926808b1cca522d2087a13205e840beb45b ]

The mapping helpers __sme_map_range_pmd() and __sme_map_range_pte(), and
therefore sme_encrypt_kernel(), use exclusive end addresses and stop
before vaddr reaches vaddr_end.

However, sme_clear_pgd() treats vaddr_end as inclusive when calculating
the last PGD entry to clear. If vaddr_end is PGD-aligned, the first PGD
entry outside the range is cleared too.

Use vaddr_end - 1 to calculate the last PGD entry within the range.

Fixes: 6ebcb060713f ("x86/mm: Add support to encrypt the kernel in-place")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260918142714.242711-2-blum@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/mem_encrypt_identity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 5ec47af786ddb..7899448d46fe2 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -102,7 +102,7 @@ static void __init sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 	pgd_t *pgd_p;
 
 	pgd_start = ppd->vaddr & PGDIR_MASK;
-	pgd_end = ppd->vaddr_end & PGDIR_MASK;
+	pgd_end = (ppd->vaddr_end - 1) & PGDIR_MASK;
 
 	pgd_size = (((pgd_end - pgd_start) / PGDIR_SIZE) + 1) * sizeof(pgd_t);
 
-- 
2.53.0



