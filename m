Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062294;
	b=NQrPxyAPmi8IPZnWgMU+BO18hlg+1QXMuoSpCBgPQ7hCXZsp1IbGngAPcG/MwQ/HidUw
	 Xbv4Jwn7MAfB/1bWAjAvx5eoMMfD+h2FPvm9HYKLIUCTIVKh3t+GmKijCEHKuJexh6/c8
	 4UJTmjIKdbBJYLFAg/7mIY0b/MQ15k69tVeYq4XGfxbcfvDSNroTDyI5UtNXQtIgXIDJf
	 xHo+jUjWUy0se7FTyOVpv/IG0KZx18r52CMV3nbDe0M17tSCJ/NtQPBJ1Qf8UlL0SMdGi
	 G3VsjsJHmh6VxQwofrLaNLej3JXefUyJdTb3NJ+jaDxRVFFVRjXyFzitMRivxpA5FEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HKe1PqKMm80iNmUhh3vx2T8xZMZGhKm1CztsCDeXTgo=;
	b=vnAeRODrpnodhA+ZTcLFvdphLR95Zq5RUI2F8cx93raGbEs4GKrq9vHFs7K0NMlnRL7s
	 M2FhS0oqY+ctRybBrs34scEJTAv3EgWVVP2Ql/YZKBmAjg/ObMN10ndgFJiHttd/zXeA+
	 h4eRO0gxlHy+r2o0hgJ2np8DsIW+XrSzIBvG9oPkqU6Ot9AcRwnpxZOddnBUckoy3Q1jl
	 7eMO3nHgi7pWvPUIuj1v1csFWF0r/9khQHCTjE2q3ZEcNWGBLlgkkABzW2dajeEx/hrXy
	 QMDABnHcnb/kBzaYlwudgo7AE+OBIJ7vD8s+xRBXc+RIO7l+PCJU9Hrw9o72u3FJvvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6tH7dzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BC3606EE98;
	Sat,  7 Nov 2026 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6tH7dzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C001F0089F;
	Sat,  7 Nov 2026 14:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062293;
	bh=HKe1PqKMm80iNmUhh3vx2T8xZMZGhKm1CztsCDeXTgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6tH7dzRgyoPTnHkdpLpFcSv9Xg2AeV1gs6V19ztONh17HG5UDzv6A4gvYQuNAt6o
	 sPBaSQ7/X49lKsgVdT7VLLKzi+W6qEwzSAH7Xym5xOByKokxb1HHK3yWPA412pktz3
	 dvgIgRXkEwB4rz0biQcHpSCgftwrjDzcCuVKkRok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1230/1536] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Sat,  7 Nov 2026 08:54:06 -0500
Message-ID: <20261107135032.305000898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 712718aed5dd9..f054c28fdd6e1 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -107,8 +107,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 	const efi_memory_desc_t *md = spd->md;
 	pte_t pte = __ptep_get(ptep);
 
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
 	else if (system_supports_bti_kernel() && spd->has_bti)
-- 
2.53.0



