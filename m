Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212282;
	b=e6uvIa84mhK8DrWlftowjipHpzKbqixp0C/tcyBDsPQBEGrzAsK80ViT30JFEWW9IHYW
	 WcjRgmbPZbHMf53xZjkC8rI/9ahhRdUfATJz79nuhZGn5kHWjHIjbQiKxin1/1wd1pciV
	 c3xraAdKnFAYOhez7iOWkPpltcAkdU7TPciPK4WaqUYvuTPJeFPbJpc/lrzm8wF9qPBY1
	 VUZd7nEx5bOILLkKjhJe/vqDDlgFBIe+OiEnPRl20rILo7iv9gFLoQpHV21D+mJInK+rw
	 wD+PsIllbsXnl+X47oStQQWbjvg+kBTqjLrlQJQv0r2brSjavBdyFanlxc3EhWoBmJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zUaZ0zA+ZB0J07dtrDGYpXBD3vCRGeZlpxsINbtQjIU=;
	b=ftMiWR/t+7bd7WKtfYhsjqS+b3X7JXZ4g+UvTnKYpVoJVTP1OUM7CzEQ2B/iH4PWV6wz
	 Exsed0TBF8VXzHS0xCGQ0f79gOD70U9qSKHNg+3kWopSaJhGojMY4KFo8xmtQcfST4veM
	 722Vjoj2py2KK5gAeYWnVAhShJamx/pf3PzbZ1ycPdfPR8xBhG50g2XvrkmKkiFlSqZVM
	 12alYWYgNfAuiQvKDTpw2AvhpjjWrBBCFabMIV3a4x6cwUhTPf/1h6hJtulBYFxmD3BP9
	 nE9OjBwOSOv3gcmOQjZsO0gDw3teb5byi4blGgt31gu8LqktAyxCpEPA/kzEvHa6gIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBBwb0p6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5158606A31C;
	Wed, 28 Oct 2026 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBBwb0p6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2931F01825;
	Wed, 28 Oct 2026 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212281;
	bh=zUaZ0zA+ZB0J07dtrDGYpXBD3vCRGeZlpxsINbtQjIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBBwb0p6tJFD/ue+7rCBTnAjZOmV9FePI1rbgnR/pfWlSxIDsp4SYOKriYrQv8X5r
	 eFCxFn4LYJ5roBNPq6JgrC72rYIqCtZO3tlyisqoKMVmMW2D4jW2OIynU6F26SPc5Z
	 kr6cBE1KPvk5WeyfduUQk0reMudZ8ZxhqG+t7WIs=
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
Subject: [PATCH 6.1 0100/1887] arm64: allow pte_offset_map() to fail
Date: Wed, 28 Oct 2026 17:36:36 +0100
Message-ID: <20261028170501.509169345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index 0776c98ad27f1..c4120bd80a9b4 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -177,6 +177,9 @@ static void show_pte(unsigned long addr)
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



