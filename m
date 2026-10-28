Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210595;
	b=roaDrLxXczWT8S77vKgSAbpZHZnZEl11fDKrZIUO3n2MEuCcLn6CU9wTFNGwbhulfMVx
	 W7V9I8g+fntIAttJXSMBu0xIia+tIlB7W6IlFSjxmByDa0dxjpOpFol7lByBZN8SPDL1T
	 OkFYJfvvKayJvyBlUADFBcwlEUkeaC6fwe0ZbovsbJrKiJ0PPMiS9tnqliwgu185ucNpw
	 K6NG5oO+/mQaE0Qs407VnvFBx0DKeMY1VeQCpma1qi9oAdDweQjGEyyZBbJtL8HLUFUTi
	 7AfDrwnKxxou8EtAkr3kxJwBe6ntQR5270qAyXu7lUfdTRWoy774u1EVCGl2agPJPgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OV4kgtp19ypS/WvAeIrS0yr5jptEh85sQDUIeR57iz0=;
	b=bvlDwvYa9T9u355m4sQ5xUvGeYtg1JBW9sVMulyhcmAYrX+Rz9wxIgobcpxm4Kl4Oyv3
	 Q8RXO9xr9pJ54IH58gTN80N7InOF2Glrp857tFokWa6tvm+FyU+pbPeqrzwVILXUh6cr3
	 4GtqmQquMaj1DF2cVN3/2xA2ejXAoJyGh3FggsO3jzH4DHlLrthbRGlCjYaPFSs/o+pKH
	 NwazmjRh+VaNZqEqykflqV2JedhOgjntrc61Xm8ppYHBOu20h8KKSj/c4TJPoGBf0orDP
	 PVJTnl6C0qmYi7Ih7H2vpydTxXh4j83wWc0mWkp3LUSdl+BAMbp8ZZNY1+si5uvetfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpUlURRO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57994606A31C;
	Wed, 28 Oct 2026 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpUlURRO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B361F01825;
	Wed, 28 Oct 2026 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210595;
	bh=OV4kgtp19ypS/WvAeIrS0yr5jptEh85sQDUIeR57iz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpUlURROHGYLvTmBUwE7MZetkAVS/+BReY77v+YT8OMTr6JqwThw2imrQr4AergYW
	 V0vVYVuA4Y7xhE+BUJQ52DoIiAL9p1mxK1Fd0Rn/7cSvk5+UakE9hUvFgqdK/kDDGj
	 L8YuuiEh+KRQpYU9qgNmziJutuBmb1NymwRMj6Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Chris Zankel <chris@zankel.net>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@kernel.org>,
	John David Anglin <dave.anglin@bell.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Russell King <linux@armlinux.org.uk>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/571] arm64: allow pte_offset_map() to fail
Date: Wed, 28 Oct 2026 17:53:46 +0100
Message-ID: <20261028170009.901738426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 52924726f4c06b3f77de75fb665e6efd8e777d07 ]

In rare transient cases, not yet made possible, pte_offset_map() and
pte_offset_map_lock() may not find a page table: handle appropriately.

Link: https://lkml.kernel.org/r/35e46485-8499-4337-c51f-b8fa495a1a93@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: a77644d009de ("arm64: mm: Fix the lockless page-table walk in show_pte()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d293aac8c554c..39f03d18717eb 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -176,6 +176,9 @@ static void show_pte(unsigned long addr)
 			break;
 
 		ptep = pte_offset_map(pmdp, addr);
+		if (!ptep)
+			break;
+
 		pte = READ_ONCE(*ptep);
 		pr_cont(", pte=%016llx", pte_val(pte));
 		pte_unmap(ptep);
-- 
2.53.0



