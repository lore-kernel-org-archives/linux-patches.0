Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052591;
	b=BZ2ROoDdTOo2uxLasgMQFtXk1C0xUcTf28X6B2OP2HGBwhO8wE1ApvFNHXLyTJ6TlZQF
	 dI7zIQkytBboHPSdn+gzpdqnAHqNV/A+wLXODx3AQ6d0R8kmWwJ+HI5zWFsKZvqCQ+WlN
	 sSCpT6Kk6TVqdM8BmR44rpgvJvBsJrvDDtizPeFlkzBKCL6uAmCLN3L2yTVaFzJKQ5bKw
	 JOM9NdmmsABOJz4EDy1AE/nEMCfWQRPVeWOIq5+f84Oc7KfjKc/gU4HkrfljO/3jz36DF
	 pZXZXOGUcKtyMEDXD1PEcUHP7i3+Fj+N8rJXxlObTtWM/n6AlFUgzxahltAbdiaWQ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7Yo5bdFgldaT/7wPZVsKWorzW9Nzr1mghT9Gm/1lvA=;
	b=DBBrzML9wsQT9+rTG029U6u9kskI/rY7fc74fCx0G7i+6R6Nj7xPtJiwMfcsZQJCIocO
	 e2S7hn0Bkom/vgsZMlyRQN6iJXYJhdSomPKKwfiXocQ7F7QbuVoy8WTHhS4lHaD+fbJ/K
	 kvIanstldtZ2+JEjac4usc6g3TQf3GNvPWQBXw8cNZx/3H4dO9dIC2DAwQ22/PbhX6am5
	 KLwjkQcNGYOyhRW9KpK3WlagEA4tXJrdzrs6oThXCv4n9CHt8XgAfpLU0KmH/Hy0lmt0W
	 zAXY0bJoiaXyGDTZGZ9Dho/Qc1wNEA3/3iJ3gHGmOzUeuEDrW+BQnJaPFP0sFb/eV2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzLBQVtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5E5606A32F;
	Thu, 19 Nov 2026 01:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzLBQVtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6FF1F000C4;
	Thu, 19 Nov 2026 01:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052591;
	bh=d7Yo5bdFgldaT/7wPZVsKWorzW9Nzr1mghT9Gm/1lvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzLBQVtmAOhqW0dbDjqjuugRsYBe3ifHGjyzVE6NzqbmNeKqQRmqvD1bxNtkUkmUS
	 JJ0ElJxewzfwQGuTW3GvqC8TD24rmSnAQdD15/oonUb1F7I3NZYNGN16JxaPuN7NuJ
	 0zuvtahzRzUaQT+WprReD6pFdudHQuBCjyO2TY68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0616/2214] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Wed, 18 Nov 2026 15:38:12 +0100
Message-ID: <20261118150036.031496982@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 215d7b6622733603751f546b9faf9b84b0c281d4 ]

set_permissions() sets PTE_RDONLY for regions that the Memory Attributes
Table describes as read-only, but leaves PTE_WRITE set.  PTE_WRITE is
the DBM bit, so when hardware dirty state management is enabled
(TCR_EL1.HD), such a descriptor is writable-clean rather than read-only,
and a write by the firmware will be permitted by the hardware (which
marks the entry dirty) instead of faulting.

Clear PTE_WRITE as well, as pte_wrprotect() does.

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/efi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 9669f3fa2aefe..0ab04aa73bf2f 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -101,8 +101,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 	efi_memory_desc_t *md = data;
 	pte_t pte = READ_ONCE(*ptep);
 
+	/*
+	 * Clear PTE_WRITE as well: it doubles as the DBM bit, and leaving it
+	 * set would permit the hardware to make the mapping writable again
+	 * when TCR_EL1.HD is set.
+	 */
 	if (md->attribute & EFI_MEMORY_RO)
-		pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
+		pte = set_pte_bit(clear_pte_bit(pte, __pgprot(PTE_WRITE)),
+				  __pgprot(PTE_RDONLY));
 	if (md->attribute & EFI_MEMORY_XP)
 		pte = set_pte_bit(pte, __pgprot(PTE_PXN));
 	set_pte(ptep, pte);
-- 
2.53.0



