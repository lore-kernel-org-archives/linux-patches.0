Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064635;
	b=qvO/SQ+T8Zqh9JQ+4x+4T35ZZz34Ewmu4kp1jBTNKeJy+qQqyEwqOjfmmk2k0o64tL5p
	 BNnXP6bAYmB1AzI1p7zdv+lFHal24jp3F3ZRmzT23iY3eteBaqOau6whWvQz/AecL2O07
	 2ccvakMC6UkHFCV11bxaq912fYitY6Cbva7MOJZU2SdL9QyeJxRZ5EEsf9dbMu8DsbbrM
	 P0GaBiDp7VDG2DkcztGas2EcpyDC74PYWbQL3aPnO7JCc9GTkaoIVVa3JRIqHIkz9UbSv
	 WtyN0h2LJZ8UGrkwRHt3h6X7Vhj7qiDWEWft7AoPZXmwJu2QQ0IvQVuh7g9yN4YSuRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G5RV1R0MzUX73Pf3WCAii1oYbdTM7xQDPjg5FodOVvc=;
	b=DmAyZ4Y9OKzfAD0ORBfjCUln9TLt19MswSDeUZvMjPv+wXUcJjkS9ZkfhDd3TTkVHvGN
	 TSdYWLXnbYNDREg1XIQ96TdMP42SCnaM5OX3DRAJM5EKDSC8fOi+KcNR3aezzCdTdT3tr
	 khdmhO52t2qbetfVS4i1rMiYZGcgWT9l7UkXmRMTJ3BqNfe+pMWyeqZLk9zh1VNLCJVVJ
	 GB6XO2c3EFQYq0U9DoRseJS+z44LxDo3Ts6zw/EIRcueStB1IYpFhTQvJSV42rzK7kbQ3
	 z71MhgTxTF0bNVLW0mTibFI+XoCPaa1J964noaT3AiNSiwhqejCO7jRfgPWRj+aIj2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G0gGESbs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFAD606A33D;
	Sat,  7 Nov 2026 15:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G0gGESbs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6681F0089F;
	Sat,  7 Nov 2026 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064635;
	bh=G5RV1R0MzUX73Pf3WCAii1oYbdTM7xQDPjg5FodOVvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0gGESbsesYjBTtvtWSCVIh1bBfxqFYKT2dQHotvP1+3u5BHFz0ZLAyxYJPf7/eK1
	 42w8O1IeFgtPgrjbMNlPeLlGcTLUcqSrBAJdWKg30M4GLkFk9axXvd5YghGcHHrY4P
	 V5exsIcBRd0M2BeY611aEbrlm/UgKlNMqrGwVQTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0642/1257] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Sat,  7 Nov 2026 08:48:58 -0500
Message-ID: <20261107134957.007843079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0ec90fd1754ed..6f34aef3d04ef 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -117,8 +117,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
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



