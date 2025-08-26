Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B143A1ACEDA;
	Tue, 26 Aug 2025 13:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213567; cv=none; b=sAbE8KB9qpeMSTqhPtJU+GHRuJ/fb/0NF5Dn8m1Nf+0Ly+x74c+sSYsTq82FbOKujPB/RzEaMhn1ba2JwAasidXlbTk8ZkiEMxnj2bWTfqXDY2Rp+6jZu1vdDp0VU4BWtI3nFc+ZoLMPSGfgs7OcTenQPZcVSNbYnAgJjhQCnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213567; c=relaxed/simple;
	bh=94zF0hKpzaXuVaRxt8UWaWRPN0TOpn6bmEd2NGoJKSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAlxq6u0KgGiZSYcqx84x3nbBC4L41U1RK+rLO5FGrMMOWNkyyioM2YeArm6su7QM8gO0wABMGi1N6F6BC+U7U58QE2D4N7s9eKr1cpb+JUUz5kAuErZKL958IiVRQOCF7feiyXiETAUVzoEQcxraI3Xoa6g8jPShMTij1ENM0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxWtrEER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxWtrEER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4736BC4CEF1;
	Tue, 26 Aug 2025 13:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213567;
	bh=94zF0hKpzaXuVaRxt8UWaWRPN0TOpn6bmEd2NGoJKSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxWtrEERBWwS7A2nLw7CTBnYKGaJe7+hM2n4sU2/6Ih4nw0zYzgSASKydxID5y6/h
	 hfUjRuLKBDn/ieOIObPF9rc6uTpezMJNlymrC477m22NCfH/wczfYVntl5PRlK8vQ2
	 7ql2XwITHGTsvo48puMPelCaBtF4f5Zsh7RTgxBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 396/587] parisc: Rename pte_needs_flush() to pte_needs_cache_flush() in cache.c
Date: Tue, 26 Aug 2025 13:09:05 +0200
Message-ID: <20250826111002.997764612@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 52ce9406a9625c4498c4eaa51e7a7ed9dcb9db16 upstream.

The local name used in cache.c conflicts the declaration in
include/asm-generic/tlb.h.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -425,7 +425,7 @@ static inline pte_t *get_ptep(struct mm_
 	return ptep;
 }
 
-static inline bool pte_needs_flush(pte_t pte)
+static inline bool pte_needs_cache_flush(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_NO_CACHE))
 		== (_PAGE_PRESENT | _PAGE_ACCESSED);
@@ -630,7 +630,7 @@ static void flush_cache_page_if_present(
 	ptep = get_ptep(vma->vm_mm, vmaddr);
 	if (ptep) {
 		pte = ptep_get(ptep);
-		needs_flush = pte_needs_flush(pte);
+		needs_flush = pte_needs_cache_flush(pte);
 		pte_unmap(ptep);
 	}
 	if (needs_flush)


