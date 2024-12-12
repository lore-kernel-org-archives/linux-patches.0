Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0867213CA93;
	Thu, 12 Dec 2024 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024210; cv=none; b=ln6TgOrspDdpRE5wX0+zeA5Ex2X+lZ4DAD+NGTp2BJCOu/kIuOovLtTXf5050K5AiUmR8S5bb9fRMxApfUhDPk3OzUxi28vXLT8LPevtoeKcgDhb8jX7lcRm+MdBo6gFb5I44DJbYpASGkDItCgxMmZX772mOS5W9eqmMxzFBAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024210; c=relaxed/simple;
	bh=3/9B9T/3stHdpNNlXfH1nU1MOHdL6DLjGhdQrag7qKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mM0WBL7u6ZwjZMNgyRDnbwXOvCVCyohCWYzvChUfXGvQrbBDVenbRIZsKnrR9fQb/T1kPHVnBbjgtzJtdffhoY06mPOKQyl84GOcE8m8hb5FoHdwQ889CMS8M5bivihmV64BEpAAwdexA6GMUbFoXIzIY7F3ePNLxO2fablBHp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejAW1z/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejAW1z/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81677C4CED0;
	Thu, 12 Dec 2024 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024209;
	bh=3/9B9T/3stHdpNNlXfH1nU1MOHdL6DLjGhdQrag7qKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejAW1z/QqyPbRjYt9nVQex/rGMBT1BlTepoETDbJxQ+EALmxP30uqnHQ/YsCg57zA
	 TwuJL2kOxH0Sx1WmTGfh1Ya4i/bRQAB7nbuX1cFiZwcMlwGP/sTwmamrWmBfFO3crr
	 8BnztVZjNH9JBWd0CLoPpL8Y+7iJyrwDNrCNuCjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/459] powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static
Date: Thu, 12 Dec 2024 15:58:40 +0100
Message-ID: <20241212144300.746479622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit a26c4dbb3d9c1821cb0fc11cb2dbc32d5bf3463b ]

These functions are not used outside of sstep.c

Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instruction emulation code")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241001130356.14664-1-msuchanek@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/sstep.h |  5 -----
 arch/powerpc/lib/sstep.c         | 12 ++++--------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/sstep.h b/arch/powerpc/include/asm/sstep.h
index 972ed0df154d6..35765c30fef2c 100644
--- a/arch/powerpc/include/asm/sstep.h
+++ b/arch/powerpc/include/asm/sstep.h
@@ -174,9 +174,4 @@ extern int emulate_step(struct pt_regs *regs, struct ppc_inst instr);
  */
 extern int emulate_loadstore(struct pt_regs *regs, struct instruction_op *op);
 
-extern void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
-			     const void *mem, bool cross_endian);
-extern void emulate_vsx_store(struct instruction_op *op,
-			      const union vsx_reg *reg, void *mem,
-			      bool cross_endian);
 extern int emulate_dcbz(unsigned long ea, struct pt_regs *regs);
diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index ca4733fbd02de..568a888d169d7 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -706,8 +706,8 @@ static nokprobe_inline int emulate_stq(struct pt_regs *regs, unsigned long ea,
 #endif /* __powerpc64 */
 
 #ifdef CONFIG_VSX
-void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
-		      const void *mem, bool rev)
+static nokprobe_inline void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
+					     const void *mem, bool rev)
 {
 	int size, read_size;
 	int i, j;
@@ -787,11 +787,9 @@ void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(emulate_vsx_load);
-NOKPROBE_SYMBOL(emulate_vsx_load);
 
-void emulate_vsx_store(struct instruction_op *op, const union vsx_reg *reg,
-		       void *mem, bool rev)
+static nokprobe_inline void emulate_vsx_store(struct instruction_op *op, const union vsx_reg *reg,
+					      void *mem, bool rev)
 {
 	int size, write_size;
 	int i, j;
@@ -863,8 +861,6 @@ void emulate_vsx_store(struct instruction_op *op, const union vsx_reg *reg,
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(emulate_vsx_store);
-NOKPROBE_SYMBOL(emulate_vsx_store);
 
 static nokprobe_inline int do_vsx_load(struct instruction_op *op,
 				       unsigned long ea, struct pt_regs *regs,
-- 
2.43.0



