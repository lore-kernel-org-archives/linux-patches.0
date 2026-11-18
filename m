Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028688;
	b=ERIWUECpp9TfwM3uUaGSDo297h3/BcImHgU0briIYM8ay/b2R2LSW4Tq//SdGZSqJ1rG
	 UD5FXFTRkpwkBSFvm7CGhYVCGzc+1792TrT2/PgwXUuSV/NZruvMixP976h+5Slrd5uUf
	 V71Gh0TqyUEUhSfDa6PNeoVVF7ZiLswEp8BEBqm96tlx3JuPtd2pLs+41npY3CsvwJD8T
	 6inDEvBqg1EBvACNQuyHbBlkQvUosVs2AHwj7bQSRyT49zW0uLZqNM2g5FHIl9d9aM3EV
	 tiKQJCEpHcjd1KtQoPRs+BN2B0c0Xot597ElLD3nIrUvHjWsMV1d4GP2e/7/ZJKERMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nrHawzwic7e4QyZHyeEjoc/ISfoPAMafIvU41pFoamg=;
	b=pzG44RyO+77XLZqJTcoku4Xw8uzKrsqOwuybesw11UMuZgGlME3ZNywMRL5iKW40jNfB
	 n5evnhhwdyLz/cxvOc3viq4WviCR7+YCAER6sKrr+midpA3tkbWUX9pOWTHSZYsSPS+Lt
	 Er7LFtrVLF9uvBeGzeaifD2N5rgDZJSjTt58jWfveBeEkESxGfBWTl5BArDF/tBDNw9gI
	 XKf7WnAwBtc7rALPyUnEVADHRG4zCihpnIp7BtB3SFd4AU4x8C8XY/CUlv3CVg1rXEgE2
	 Rlh/agRxwxnpbT/zh+Fa13Gmu0ldipuAqefEuqRoHNPskagD3liGhR7AX2yZSNfT7dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpiKoJPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551C5606A31C;
	Wed, 18 Nov 2026 19:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpiKoJPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28341F000C4;
	Wed, 18 Nov 2026 19:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028688;
	bh=nrHawzwic7e4QyZHyeEjoc/ISfoPAMafIvU41pFoamg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpiKoJPfzRh5cQz9q0idbgJ8MEe+6+seMjVlCirpAoxNFSjhubxnuqnIGK67nhLvU
	 VUDXBzQmtsVzq/l3A9xAEdGNZLFfdUCf2zTTUMA7lGZHOVJ9zNFxglfXlI4KGHtnjM
	 r9pK6+jXOsp8pimCGQdRMpOBpQ0QKbHajho0l4zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0067/1756] Revert "x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()"
Date: Wed, 18 Nov 2026 15:36:34 +0100
Message-ID: <20261118150011.003658127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 11d1ba991c0754b2c3c1e31aa63b0818afc6e4f7.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index e3a20be305bdf..69ceb967d73e9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -682,7 +682,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_512G;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
+	*rw &= pgd_flags(*pgd) & _PAGE_RW;
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -693,7 +693,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_1G;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
+	*rw &= p4d_flags(*p4d) & _PAGE_RW;
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -704,7 +704,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_2M;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
+	*rw &= pud_flags(*pud) & _PAGE_RW;
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -715,7 +715,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_4K;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
+	*rw &= pmd_flags(*pmd) & _PAGE_RW;
 
 	return pte_offset_kernel(pmd, address);
 }
-- 
2.53.0



