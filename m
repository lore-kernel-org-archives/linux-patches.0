Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028657;
	b=wEYKBj0rJkvMNNwqqedhuw9x/u/t817CFUvrI4tL2dDrmTR0uLuWd3FThx8EKJt3OUq9
	 nXDd3STWLodT+aEKVKaoqIJK5q/i+2GMHWXXMyWluS3+jrc8i8+WN8dvt/gCqJbM6ukOs
	 YUqDAJoNxFaN+PPDoygU1E+sHux+Vakc3PThZB6NAi6x6xnkkxmeviaczqUFEJNHFnK+H
	 Ps6KqwmtlywztWlYETsu1yIPoZ/ABwf6FPXODePbd6qi3zDsFAekhMx11gZc/Hv89TWuR
	 pORwzBk7pR/Z14KypYJXIyk1PYjYKiAraTA6qitmJXBKiRZFVjqxycxugIfz/MAbjlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyl6SafR2Z4Jk+TN0sodtSzhm6hFZfm9npV5UcoYSEc=;
	b=pSMwVLJ4iAVNDh1pAPgnh8arCRwqRffItlmOWRhxE0wWAF+44mQrl0sxc7InaBtxHIHG
	 XJbYxVKqfS8IgqrsuskIlWC10dIbpQ2I+nBrT3fIIXX+ts+UqKMTLc39Ks/dmcUJ9AgUj
	 8NS7KMu/MEmF8CSapI2Cv49ND6QQL00H0cei7glLWCyIRiCuwNf/JtZH0QRl5EBP/yiRT
	 AFS6uw7pDjphCgiN14XR+luZUAcvr8cO1/jd/Uk70VgiM2UutxE6OWTFUC3Omv8PsGMjd
	 JK7U1Hb2IekZFzfCH44volJHORUI+WFDLR2vkR26S0WkQiGGAr9Tt1X43Auy4XXBJ3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APhfZig6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D8E606A320;
	Wed, 18 Nov 2026 19:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APhfZig6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B031F000C5;
	Wed, 18 Nov 2026 19:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028657;
	bh=xyl6SafR2Z4Jk+TN0sodtSzhm6hFZfm9npV5UcoYSEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APhfZig6dnI7upw52PU8kiALW1XtPKMCx1e4CGXAmgWwks6FAhoY14IA1YTIwuVu4
	 422WyIKqbY7jNLl/eMtGSIpGhw0f/emdpaAPDKUpsSRe4tu+reFBZNTHjZgXOscElz
	 gBZcFrH9kNz5j9SsxNMSpJ1YGavc0L0yFmmsI/d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0066/1756] Revert "x86/mm/pat: Use pr_warn() for early W^X warnings"
Date: Wed, 18 Nov 2026 15:36:33 +0100
Message-ID: <20261118150010.968056171@linuxfoundation.org>
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

This reverts commit 091c44b2d3c3cdc943f0a1fdfe63f210cb1da0c4.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index de8f065706518..e3a20be305bdf 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -647,21 +647,6 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 		return new;
 
 	end = start + npg * PAGE_SIZE - 1;
-
-	/*
-	 * If the kernel text is still RWX, gently complain, this could be a
-	 * false positive.
-	 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
-	 * the warning can be removed completely.
-	 */
-	if (!kernel_set_to_readonly) {
-		pr_warn_once("CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
-		  (unsigned long long)pgprot_val(old),
-		  (unsigned long long)pgprot_val(new),
-		  start, end, pfn);
-		return new;
-	}
-
 	WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
 		  (unsigned long long)pgprot_val(old),
 		  (unsigned long long)pgprot_val(new),
-- 
2.53.0



