Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058493;
	b=3FzC6KfK3rFhtWDtjhRattyu3GQEsSC/13rWzQWVpmFVRl3v5JYKe3rndujYfSRKSYwn
	 lleSULropurjrbcJ0QFG2iVXjbYbaWgfEBlyEWp0TFHeCmFOOjBEkImd5rRVVHck1oXJx
	 O7n1wc6ZJP3TGBsLmGGaHQtg1PBkn69xpOqmaEHXemRIkfKJJ29+vNBF6dMawGafr8MEb
	 +3EtORaKD3L8XHSIfaipdpguZu20dmz/NDQZfyKkZcoMdePzH0Mbtf/1Lc3SuCh2jmVuA
	 3WMAxxM+rnwtfpZQn1jzR3bOslCfKCphCjUagmDuDEPcXoq+c/Kl3rucVVVGdgkrZ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AbPVMfyusRH+3Wy4fd5w0TpxskUGN5L7iku8YnIS9JI=;
	b=Y9LjkfkG/5kfcwwQFYR942jbvGqIcjiVh4uyc9RAE8XWXbXIRNdtwIo/a2rQYR0b/hqm
	 XwW5iz/Koo0kUzoOhzfAXu2rI4xdpNVZPBK0c15YxRfWjZ+k6H2L1BpZH+QSscHEb2Zw3
	 Fy8OxE8FNaHauIWR7zSDfT5d1+5IbNIA0mHKEzNwcikTz19AAe3TIayREfut/dcwIykRM
	 gy+OTHFIwx0lNHJ3t4ORsWU8U+U7PJNYpDwi+N4Y13PsCREjS6O/VMuzY8dWtQnQmZksp
	 OdEBq3GSAR5SYodRlNxv+I3hzInvO9s0XDvy2s5Md5nEwdHfrMyePdn4+H5myKcN09Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SmkzjTyh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0B3606A320;
	Thu, 19 Nov 2026 03:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SmkzjTyh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F53D1F000C4;
	Thu, 19 Nov 2026 03:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058493;
	bh=AbPVMfyusRH+3Wy4fd5w0TpxskUGN5L7iku8YnIS9JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmkzjTyhc4jvXJq+WpfJ8cGNPzJjflxnI7BaZ+mYPAn6086yLxSCQ2yuT4loDknQa
	 Vi9j5sY2OCwGj66Wjgy6PZ1s0z7DnphFcHnRA0q631gv18E7SvQCjhP9CdrRH/sfxT
	 6T7NIUomUFyfDO9XaeWFml0z3qEDujsMq6C04TfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0505/1848] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Wed, 18 Nov 2026 15:42:23 +0100
Message-ID: <20261118145935.935095990@linuxfoundation.org>
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
index 3ee3b3daca47b..30f51f27fd069 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -100,8 +100,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
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



