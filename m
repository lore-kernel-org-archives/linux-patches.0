Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC5C10A35;
	Mon,  4 Mar 2024 21:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587685; cv=none; b=Azoztc7bWlWWHDAHDwK2u7fC37epyuugz85nP9LmxahwcpBEooYF4Ttaqy7gF4xvTir10eW91vKb9CjErF5V/bgCI1wGlDEqBsWN7l75ahiY1W8NBzQaBDBARvSZSiNyO2G3z61BTM65uHx2LrwrqE5HplBYsuviUThQy72usuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587685; c=relaxed/simple;
	bh=X79Lv/4jU8SrUl8gVZTdoIyNgo8Z8eJeT1ZNt4e/4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP717dXDm54A+dp0vx3+8mILQUrwP1EJdTB1szKCbsczxbjvA/vfrxxncp1QVED7hypGR7B2sCKOSmlUF5okHNhV7PPI691dhtf18f0VyCKLES9N+kJ2Nq3HQS3xc0BW6r0aTgIPM+vr8vq4B2QxzgL3NjcXPcDmz/cdCLzFSlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGGZ4w7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGGZ4w7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD7DC433C7;
	Mon,  4 Mar 2024 21:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587685;
	bh=X79Lv/4jU8SrUl8gVZTdoIyNgo8Z8eJeT1ZNt4e/4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGGZ4w7a95StQ2Nu2dDOBpvlxgJ9AmlcZwHaLc0HHxjCr0D24ltoGnBaxB9uPi6ja
	 3tdyc+qGYGRWUeIMS/daat3McV2hG+JlEmgwa14uWTq6dDAVFifEjqGCYdbiEepOns
	 qvLQrmBdk9ZdxhetqgOB+BQx0F/+gFH+kyxBufSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangyu Chen <cyy@cyyself.name>,
	Guo Ren <guoren@kernel.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 051/162] riscv: mm: fix NOCACHE_THEAD does not set bit[61] correctly
Date: Mon,  4 Mar 2024 21:21:56 +0000
Message-ID: <20240304211553.491595509@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangyu Chen <cyy@cyyself.name>

[ Upstream commit c21f014818600ae017f97ee087e7c136b1916aa7 ]

Previous commit dbfbda3bd6bf ("riscv: mm: update T-Head memory type
definitions") from patch [1] missed a `<` for bit shifting, result in
bit(61) does not set in _PAGE_NOCACHE_THEAD and leaves bit(0) set instead.
This patch get this fixed.

Link: https://lore.kernel.org/linux-riscv/20230912072510.2510-1-jszhang@kernel.org/ [1]
Fixes: dbfbda3bd6bf ("riscv: mm: update T-Head memory type definitions")
Signed-off-by: Yangyu Chen <cyy@cyyself.name>
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/tencent_E19FA1A095768063102E654C6FC858A32F06@qq.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable-64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 9a2c780a11e95..783837bbd8783 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -136,7 +136,7 @@ enum napot_cont_order {
  * 10010 - IO   Strongly-ordered, Non-cacheable, Non-bufferable, Shareable, Non-trustable
  */
 #define _PAGE_PMA_THEAD		((1UL << 62) | (1UL << 61) | (1UL << 60))
-#define _PAGE_NOCACHE_THEAD	((1UL < 61) | (1UL << 60))
+#define _PAGE_NOCACHE_THEAD	((1UL << 61) | (1UL << 60))
 #define _PAGE_IO_THEAD		((1UL << 63) | (1UL << 60))
 #define _PAGE_MTMASK_THEAD	(_PAGE_PMA_THEAD | _PAGE_IO_THEAD | (1UL << 59))
 
-- 
2.43.0



