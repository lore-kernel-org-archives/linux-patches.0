Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33DB18C025;
	Tue, 10 Sep 2024 10:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963221; cv=none; b=QYQQftv/Xuy7ZkclWD2OSgFUg3Tn6NLOtAUAemJg78+KOt6o2Q7unPzn4R2a2bAGeUasUYX/UmtlHp5wJIKnfRTaNQMOsVzXTUGkpA9fXjH95AO8PXyaJRku2DGskGCgmVXQuWw/3k0dpa0+xHUwJzebebCJxmGWv1bzvkN3dcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963221; c=relaxed/simple;
	bh=MW/og9XKeam60W0qQ/2kjLNMGmZAvksY1djwfPEi16w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbjYVs1b3I8FT7J7Jp2j9diHwUg+qrtAzfWp/oXZYVx2ky0OZSLTRckbMB+8Wo64z85c0xcK/HaYe0DIOQQKE/Semmmzcw6RCa7S+JE03OemayewkWgpuQI2TmFcCet7bAFvKY4mzk6/8XOr1bEwZTaFHAe5HNTiljzdbb62i1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4ECJFNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4ECJFNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C49C4CEC3;
	Tue, 10 Sep 2024 10:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963221;
	bh=MW/og9XKeam60W0qQ/2kjLNMGmZAvksY1djwfPEi16w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4ECJFNpysLo8eoEY4GivixulE1pw+hB4QibNHbWALJGI+OSrzshfVVaxePFGJEQr
	 KNnFNmJnHQz6ZZYIJnSC72vqjW//X7wtyQidbzFzG4rNvbb5lXxET0YAL5OLe83n1a
	 9y7wJdveyuVv5VtxlREBHtQowZ2+2fEYL2Lojsoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/192] powerpc/64e: Define mmu_pte_psize static
Date: Tue, 10 Sep 2024 11:33:21 +0200
Message-ID: <20240910092605.129200003@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit d92b5cc29c792f1d3f0aaa3b29dddfe816c03e88 ]

mmu_pte_psize is only used in the tlb_64e.c, define it static.

Fixes: 25d21ad6e799 ("powerpc: Add TLB management code for 64-bit Book3E")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408011256.1O99IB0s-lkp@intel.com/
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/beb30d280eaa5d857c38a0834b147dffd6b28aa9.1724157750.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/nohash/tlb_64e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/nohash/tlb_64e.c b/arch/powerpc/mm/nohash/tlb_64e.c
index 1dcda261554c..b6af3ec4d001 100644
--- a/arch/powerpc/mm/nohash/tlb_64e.c
+++ b/arch/powerpc/mm/nohash/tlb_64e.c
@@ -33,7 +33,7 @@
  * though this will probably be made common with other nohash
  * implementations at some point
  */
-int mmu_pte_psize;		/* Page size used for PTE pages */
+static int mmu_pte_psize;	/* Page size used for PTE pages */
 int mmu_vmemmap_psize;		/* Page size used for the virtual mem map */
 int book3e_htw_mode;		/* HW tablewalk?  Value is PPC_HTW_* */
 unsigned long linear_map_top;	/* Top of linear mapping */
-- 
2.43.0



