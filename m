Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF5D1BBBD7;
	Tue,  2 Jul 2024 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941019; cv=none; b=ix23AP2hch6n39IBLa6Koh+6MM3VOKRft8XnuJ0HtTPmAbgd8+jB7KznKf/1f1R2X7en7enjRyuAhK6Kbc/PYqw8Sk04u9XTh0QghC/G0RYnsbdBwLoCqFgnd9r6XZxJC9CxkA+SUEZORnfJ/0nrE/I2sVRmF8gL8EUpTijtK7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941019; c=relaxed/simple;
	bh=c+HQVhPUgR2FLGXY8Rb11LClCf4gFzwZwzgo1TyTaOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBJWYyILZcBagW6pEe1W6W7BbJgOT+ZVDdFKHYIRgBbBnW+qmIm4/xc6J+mx/+JiP2DyW7L41e8wg14IFvHAaMDKDnx8Ir1lOGU1k4wZVUfH4E4+952kneyHQ2qcuwYZG439EkaYptxJ75fA5O1mn/ge0Pa1Ch+8zC+p1VxO5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4QK497b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4QK497b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939D2C116B1;
	Tue,  2 Jul 2024 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941019;
	bh=c+HQVhPUgR2FLGXY8Rb11LClCf4gFzwZwzgo1TyTaOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4QK497bVp0FrtbulMcWO1tOz/0tOEioD53hSMnCgdNVSjgWM8P/equ2Jmzu+GS8k
	 mmeX3gSppHIcSjrDpDFD1dD+MRN92VqTGv7AHjPQc21cE6n7E+h4o4L6ifiUjNw2s/
	 RxfaRr1JdfG8SzssXm/Lu/obn85NgigGd4koX6GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <jesse@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/163] RISC-V: fix vector insn load/store width mask
Date: Tue,  2 Jul 2024 19:03:07 +0200
Message-ID: <20240702170235.828595564@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Jesse Taube <jesse@rivosinc.com>

[ Upstream commit 04a2aef59cfe192aa99020601d922359978cc72a ]

RVFDQ_FL_FS_WIDTH_MASK should be 3 bits [14-12], shifted down by 12 bits.
Replace GENMASK(3, 0) with GENMASK(2, 0).

Fixes: cd054837243b ("riscv: Allocate user's vector context in the first-use trap")
Signed-off-by: Jesse Taube <jesse@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20240606182800.415831-1-jesse@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/insn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 06e439eeef9ad..09fde95a5e8f7 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -145,7 +145,7 @@
 
 /* parts of opcode for RVF, RVD and RVQ */
 #define RVFDQ_FL_FS_WIDTH_OFF	12
-#define RVFDQ_FL_FS_WIDTH_MASK	GENMASK(3, 0)
+#define RVFDQ_FL_FS_WIDTH_MASK	GENMASK(2, 0)
 #define RVFDQ_FL_FS_WIDTH_W	2
 #define RVFDQ_FL_FS_WIDTH_D	3
 #define RVFDQ_LS_FS_WIDTH_Q	4
-- 
2.43.0



