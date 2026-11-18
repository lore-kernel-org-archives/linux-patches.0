Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036576;
	b=vHAf4GddqgjX+Zx8MtBCt5iC1Rlp+giHG6SoFXaejAuHyOEq3FaJWkT+hRZuJNFp9pkC
	 qyv35x/1BILXlXeXTCn418dKcvdev3MtqJmwldpY3chwREyOviDPzTFUDjyQVCrRt38b+
	 1OUgiOzPCdquLXmkRyyYtiJYUl/J8fEBA9Pl4pItXYyFVLqeKakhfgtlwHu7RZfGg4d3E
	 gyfJJVTPWDiR+t/4AFjGB8SqmAyDZeCaAqcQ4UORhzA3ADAtc98nBg6iAzgIxf49uPVO1
	 L3SgfH1Y9Xx/h3z9p7lTpJbcNk6+WtCUomiMW2cAWVU+Yb6cErrlxDMco5KjXBRWN8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XxV2f9LEIkh4u+to5u//GIMQ2Fu9Lt64MHDVhvyoSFQ=;
	b=pOTzxPGeh8btsLNKei/uKuWD1vDpZ8x93oP+zCKXaDajd1wFSHY6Pk3tkVXERL4WRz9p
	 bfzJ59wppvLxxNAa9HocB/iEmz0zV8FweAqXoDfPoyxSiIjmzcv+4ASO5i6MXDa9BGg99
	 f7ZtO014XhE7G91vSGaKLIw62yYY8+XfyIIQXG9YHCC3sQXjC3MTMjnKr6N3HmkG326w+
	 wgkXAQIqhWlU3qgtqaCJDMYN7a9AqN1YSWl2jJcswwZ1SqFIimHg6XicgYfn3jbYnBSek
	 Ew6/5hv4hGeTbSwOv8QAMnVfdO2XHwC9yaCEe6wN0xU1npxvQYIPnuoU9f50OFcVrDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdSik+nY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA15460A2604;
	Wed, 18 Nov 2026 21:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdSik+nY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED841F000C4;
	Wed, 18 Nov 2026 21:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036576;
	bh=XxV2f9LEIkh4u+to5u//GIMQ2Fu9Lt64MHDVhvyoSFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdSik+nYRDsdvQPvMp9K4RHHxMLlIkMGS908cdozXARq4UjpTWnL0IfbcWfoVhEaw
	 e/kiqJDpd4jcEoZK0b1pWuASF+tl4l4XV2BnDU5fY0R1o/I+/zdWNEE/ovjXsxcOKL
	 Z+JAKUu3q9GSU3gHRltrd9NnUGEo6Rc4eoa2RNfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1066/3318] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Wed, 18 Nov 2026 15:28:08 +0100
Message-ID: <20261118150351.941008796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e72d62416b1a0..5f16da6f12b40 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -109,8 +109,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 	const efi_memory_desc_t *md = spd->md;
 	pte_t pte = ptep_get(ptep);
 
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
 	else if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) &&
-- 
2.53.0



