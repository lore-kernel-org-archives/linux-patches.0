Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045440;
	b=O6QkaIu6s8gKUfsSaesUMIlJMj5T5NNz10KHfoT+mgDg8mvFOiuwVzRFOgSOuzgK5deW
	 SYTrW7Wf3zYIjk+VaZ49zeS73FqdTWwJJ0VOeLx1S68D88iF7+q4zzx0eIWk6yjfjrZq1
	 t5g1M/GIIgBSNv6hGpAVzWdF2JsUN1rmlSuk0e9nY01nmXwhdaHuu6IF+FoZWQuZqnNDs
	 ztjwYT3rL2usUVrypTP5LNh4B7CfBhfQ3k8HCClVmgXL8LhGzmqgnbOzp+F9+xbYTfkQm
	 s5iNYbiTamkw/yq5HoBU7CSZiVd61vWepHvtJPHKnDreSfaKcV1pHl7BgSkle17n+Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7S3t7bEZ9jEBQgr7EyszluWITgPLnXeaayYjTWTxi4M=;
	b=X4pe2IDch4fK9y9pQt8GpzSLl5eN2SLMUFKBrxcFqS+3UDgjuNJLYDGtw2iMCmnZYJBS
	 0qjPTbnGonDlIZ0PmO8iF+w/DBizVKgBZNGKXugQXTeBYkQvo4OVC0rFapuGW2juWYOHm
	 RF4tbo7SyhQCmlsk1wqrksbGzKGbYy/THAq7hncM67EdzIDehbqN4pXY2iHQp5UxdmM1s
	 V2S3DLwod4lmmZEEJtbALC0k9TDHlxHB+POZg8Wgl9kr3Yynua1CEOuEZSGUkvRraEDzw
	 Sr2lFAn9pOvibwtLpafREbETRa3MEawdsKzSMEepjABNDZCaBZc2Xy6LEpc1Jv2TZkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFQBgIG1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCCE606A32F;
	Wed, 18 Nov 2026 23:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFQBgIG1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653F11F000CA;
	Wed, 18 Nov 2026 23:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045440;
	bh=7S3t7bEZ9jEBQgr7EyszluWITgPLnXeaayYjTWTxi4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFQBgIG16PzlqrQc1acQRtbTgA1O90WqhZPjcsmDFzhjv2ZNYJ4IkgDH9SKqC1ZF4
	 SdPToR8aysJsNIKW9GicVSSa4q+hsDliLm+yYUlSPRNtgsxyMdQd7wk54SkOEMubl+
	 EbgdoxlfotIMkQ1cGgrkT2sy8s2BtUSSt7xHDorY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0923/2857] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Wed, 18 Nov 2026 15:32:37 +0100
Message-ID: <20261118150234.819360840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a30dbe4b95cd3..7b66f2c1e3b6b 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -102,8 +102,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
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



