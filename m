Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053473;
	b=JbS2ryEixWT6NQzU8DoDyH5APkBrGB98OnvRLbbGX9bex7TZxestt/Tj+8eYZdsZR1bJ
	 QJOmy8sWbGLXJ3YoZa60LSxJb/+hFZESK0I2gdzryw7tNzc+xr2GJY44no0Qzj6WKnAoJ
	 BbjD494E/mN9ki1Av2mYvdpiyAsYNWC56DiZwpP7Vv/tzDKTix+T4D2ekt1dzrQ3XF3an
	 eHn5OwsI3ZKiHGLk4RQShFW3WSg0aWO0okwvsVX36sdJI9RA5ANfCWRbKZjRr7I86OW8K
	 xvg2f5LuDBfsO2kZ08BVaL3MqF1T8uymGDQvh/2NpHYwgvDQTrHmV3Xkud/UkbdtO4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yyOZSuK3WR3ZnppLW/raw5VJojDRvHzPCrH+8Gt90R0=;
	b=0D1JetbaG4EfeZe4Ro2/1iOlj0BTQJlP2nWofjgFhiFgVCSwQPDhiac3JbhEeEGq6SD8
	 50N1JYVJF75Nq4I4Mlw4QRcV0vV2Gr3jCeLs7negQiA4ohJ8FnrvvGoVkpRIg55+r/uvd
	 20Vq4Z4WIRVgjzUM2wbp44djL4WO84UhovlJQBpLonhfQ9ppVswhDkbFPjsfKl77/PV/E
	 2y9VtZW5fpmiBFZgk7CPufhc/aTkDHp2vcPrjnYwNr/FbW8swbLUII61byuVGpO1DkY/M
	 QPPrv63WD0IWQIwEe590B70YeS87Y7w/dmT6A+TkyM5W/6p9jSbFDl73sQJxSzyfdnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylQ6fRkU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DB0606A32F;
	Thu, 19 Nov 2026 01:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylQ6fRkU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027A91F000C4;
	Thu, 19 Nov 2026 01:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053473;
	bh=yyOZSuK3WR3ZnppLW/raw5VJojDRvHzPCrH+8Gt90R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylQ6fRkUluPyPVDWuBlcMMfAHE9PSrjrXQkJCmxqxydt3XwXq7f6leqwJ8Lunfjut
	 GjS01amFvNWuSjc0y0GD2gkoBTmGEJOu2XGpPDMpxpZAHzABLZD+iB2FoDK0DYnjL3
	 cgRRK0AeX1vwTU5gBsz8JJJHk+PH4VQIGnNhKi/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0930/2214] x86/boot: Fix off-by-one error in sme_clear_pgd()
Date: Wed, 18 Nov 2026 15:43:26 +0100
Message-ID: <20261118150049.572209516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c7e9fb1d830d2..e408412c23602 100644
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



