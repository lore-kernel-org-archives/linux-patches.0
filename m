Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FC2646;
	Wed,  6 Nov 2024 13:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899289; cv=none; b=LfzSR+ahL8DeVi0D2j+qzeWKdfRuGVRndZY3biC6gv0+1kKgItJ0j92DihyGUSaczYz4H5Hq9OeRlydjIM9ZTVUvo0FSCKwFUcfXZ7ZRYgrWl3NjsVfyamGersn1lLSqQgWahqIzOOJKJxetyhehYh6KFqVm1d6orxn0AqWlag0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899289; c=relaxed/simple;
	bh=MretOLmhZCiOZQseEV3sfoQB/Jb6nJSN3oR9vfL514o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaZVf6MG9fqo0V5b7XzMenwFqZRxrsRAy1LLEOBcnwJRqItUXgliiZJ1+ApGjuKzt8rWJAb81ET8BPZWrwjwDbE0fNMD4gPgtNLRv33WzVg7c+BM9tngsGg3eCzbZTf4SYAU8s8jQqXi2usWywA1DV01Vj3ftx1gEQNvLKXXz9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtpPcnwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtpPcnwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37F9C4CECD;
	Wed,  6 Nov 2024 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899289;
	bh=MretOLmhZCiOZQseEV3sfoQB/Jb6nJSN3oR9vfL514o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtpPcnwLBiZQg4pxmb20Caodv8/KhUZsj/fdSpH+ZpLKgep398Yjwent/3e6lKSID
	 MCYu/7cBtJCKr1dMf1ISLeZaVyjX6sbLtFjqx3Cg6c99btiNwzear16oDffEyvrups
	 j9BdoNjvAKiRW/hjwDcwQzUywdpAUGsZ5WMYoDRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/73] riscv: Remove duplicated GET_RM
Date: Wed,  6 Nov 2024 13:05:59 +0100
Message-ID: <20241106120301.603060010@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

[ Upstream commit 164f66de6bb6ef454893f193c898dc8f1da6d18b ]

The macro GET_RM defined twice in this file, one can be removed.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Fixes: 956d705dd279 ("riscv: Unaligned load/store handling for M_MODE")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241008094141.549248-3-zhangchunyan@iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps_misaligned.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index b246c3dc69930..d548d6992d988 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -131,8 +131,6 @@
 #define REG_PTR(insn, pos, regs)	\
 	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
 
-#define GET_RM(insn)			(((insn) >> 12) & 7)
-
 #define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
 #define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
 #define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
-- 
2.43.0



