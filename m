Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DB25381A;
	Tue, 10 Sep 2024 10:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964624; cv=none; b=XbkP4BH9kpIQOklG9LhqYA9ILig/GGrrtcDzh45+r4RNSb0M0vZOfyKFj71FNd51hXFSwOVLFLZi5KiV6URKLhDIfORGUZBlgxGAJGXue11ko3VHQDvGbjeTVkoqJWXBIiEg++papuMTh4KZIhmnSIZhbS7tnqlF8rFaZ762OIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964624; c=relaxed/simple;
	bh=iAFiErD9U2gxLZFmNGfvXdjsx4WTgw462COKJklc14M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u41j+n5+D7uzzJ9ZC+HJplQgXPrYeatpF0i0nxs+ke3i5bKDmePrF6YCO6DjyeXikyUXY5tvyh/fTB9BJ4uOkeckzuhiTrofIr0w4SZ+OYlnM/kDummzBE1WQJ3n4w0NCIvr/8G5bwuNFWjBSgBZ+pKa/sg+/n/XCfdJ7ZsQZkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uySGrs7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uySGrs7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4936C4CEC3;
	Tue, 10 Sep 2024 10:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964624;
	bh=iAFiErD9U2gxLZFmNGfvXdjsx4WTgw462COKJklc14M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uySGrs7RlTxV+E+F+j86ijsRKOO4EXNyzcBODdvP/zMl6XRZYXCjJluALdmJsuerS
	 xQl/xUvyZmhP9hX1YLvnXeCrOtEILZGnUZGmrEU4Up/s3+CVKl6XQxFJsfiuY5Ef9X
	 f0QyCNBl8NeRQzvZn5U9GMejo8ijQca5MUu+vIrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/269] powerpc/64e: Define mmu_pte_psize static
Date: Tue, 10 Sep 2024 11:33:53 +0200
Message-ID: <20240910092616.607821233@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



