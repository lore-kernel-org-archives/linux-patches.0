Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831808;
	b=b2TI1YsMwgm1rNS6dX5dMgFJ6ed2o1HBqYdyA1KP9kZtjts3DccGJK0QRuE9iLD0HwW9
	 dElvJmjrSSW3v/odRGRRsbVnSAqEdpZLUQYW3Bw9wxXdjb1WQgA30L6uA+7XkiW3clQKw
	 Afm6E8vhUIECDSeZcLokVYVhFI2j4m4qbus/vWw8/ivXvSeEOogA81FAUUQElzqF8UWBF
	 viQzfs306gDn9gl2rAMf8wIByMZTnEGf56C5wAkRQ5nb/8P7ex2lQvuKwVkRfmqVh4P0L
	 bCija5I/5358kQiT2FL7mcwNfHOigImjs4Ui1bzb/wpm/qiD9kKb2j7yJq4wePJEYQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/QZpiuOF1IqIVVOiuXpKoO1PhvYx5cUt6Z0EiGAc+SI=;
	b=ZfePnvMOYpe4e/EbPIsouduzj3jZaOHdpOLRktZZ8FtFpogJsDO5k30Kr615Yv/Y4Pzt
	 LEqiG8ab6vnPkOTl6gwk6Bmw9yGNVRb6idA4m2S4TdFpvI50lFgxAamGOmvfOOvNG0ZgU
	 x/amOozQI24xOYqDN/z3iIC70fYajZ7DsMCqGeAATwEkgfMWpQNHMWOzI6LDZUdAfF0S+
	 GJM9H6hkh5GBciyzovEO8m7N/NhBm4EAE7wWgGhhnbSrfGvLVp4ZuCn2sN8JioOWJXP+i
	 PlkgdYhEzdaH565zZRjjT/sax1KqRaFlQ7qaf+6FD0SJvytyLd+rjUhcrC+bFd56u1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnTvTe3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9432D606A33D;
	Wed,  4 Nov 2026 22:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnTvTe3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FF81F000C1;
	Wed,  4 Nov 2026 22:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831808;
	bh=/QZpiuOF1IqIVVOiuXpKoO1PhvYx5cUt6Z0EiGAc+SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnTvTe3IePh0j6ZslZtj8yu/2cdgDe4FGSCqrlnUQrDn8twe/oB9PLkRV9UfDtuGM
	 hRUWm3J2k7Qjx1XnHO/fhkRABbKiRb7dQYRbYBPxLuBeOsqq8fjoih7aLXVJn0rFoR
	 mQTwNXLuleLfsruwx1IVNT9o2/7B0OP6ew/ig7I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	syzbot@syzkaller.appspotmail.com,
	Atish Patra <atishp@meta.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH 6.18 0924/1005] x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()
Date: Wed,  4 Nov 2026 16:10:57 -0500
Message-ID: <20261104211109.026460924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482 upstream.

lookup_address_in_pgd_attr() accumulates the effective NX and RW bits of
the walked page table levels so that verify_rwx() can detect mappings that
are both writable and executable.

The RW bits are folded into a bool with

	rw &= pXd_flags(*pXd) & _PAGE_RW;

but _PAGE_RW is 0x2. So consider the accumulation line:

        rw &= pXd_flags(*pXd) & _PAGE_RW;

where rw=0x1 and the right side evaluates down to 0x2. It'll end up doing:

        rw = 0x1 & 0x2

and rw always ends up 0.

This way rw becomes false at the first level walked, regardless of the
actual permissions, and verify_rwx() treats every mapping as non-writable
and never reports a W^X violation.

Add double negation to the right side to normalize the _PAGE_RW flag to
0 or 1.

Assisted-by: Copilot:claude-opus-4.8
Fixes: ceb647b4b529 ("x86/pat: Introduce lookup_address_in_pgd_attr()")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Tested-by: Atish Patra <atishp@meta.com>
Tested-by: Nikunj A Dadhania <nikunj@amd.com>
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260813-cpa-fixes-v2-5-39b4ff90f91d@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -753,7 +753,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_512G;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= pgd_flags(*pgd) & _PAGE_RW;
+	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -764,7 +764,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_1G;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= p4d_flags(*p4d) & _PAGE_RW;
+	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -775,7 +775,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_2M;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= pud_flags(*pud) & _PAGE_RW;
+	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -786,7 +786,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_4K;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= pmd_flags(*pmd) & _PAGE_RW;
+	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
 
 	return pte_offset_kernel(pmd, address);
 }


