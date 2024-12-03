Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952411F76AE;
	Tue,  3 Dec 2024 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241522; cv=none; b=gSOz5jPtWCdqd1eaZsfvmlq0qnPmqxndYwPwxJE41Qn+cqHJMJ8/dVuPDzQRrDQUqPDhB2BVKvayx1naAEjmYiQG7Qp/UGdKq1uv5w+zvxUIvP/LcwaWPAouXskV00NDI0c4z7QtWTmZj37p6+mZGFQuRIHbfz662AlmC0itBjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241522; c=relaxed/simple;
	bh=QTRxpbvjDf7Ta3cI6M3ZxTvCAc7EJ4w0rDUEpEbTFDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr0R03NuF45k5vJN9Iq+Bf11Fc258osYacLgzRkMxj7KN5uxrqG0FzClQu8J2dFkjkpwqePp/diq9mYwToJL5wMFR/JMCJrJVPQU0U3uib9yK6DCzsddjN6M+zGmj0/ivgdH7zE2S5MhQ9C/uagTabU2rmyPFpLBwFuHRF78yG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODMS4q0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODMS4q0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF24C4CED8;
	Tue,  3 Dec 2024 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241522;
	bh=QTRxpbvjDf7Ta3cI6M3ZxTvCAc7EJ4w0rDUEpEbTFDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODMS4q0BT4xTd4aumiOnpXcQh1+TEK8x5dweJzSRt2iGyS+vNTzjBf7wnI8Tz8p/z
	 nHbJRsnOo4bfxcICLWsykSbR8WuVziZ1/v+0uqR+CSWYU2aFO1mGDKZ5gTMav0ZoH2
	 E/Pf27BKoTHvyeFm0dSOHYLoLB2nyBg0u82upn10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 441/826] powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static
Date: Tue,  3 Dec 2024 15:42:48 +0100
Message-ID: <20241203144800.963709082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 50950deedb873..e3d0e714ff280 100644
--- a/arch/powerpc/include/asm/sstep.h
+++ b/arch/powerpc/include/asm/sstep.h
@@ -173,9 +173,4 @@ int emulate_step(struct pt_regs *regs, ppc_inst_t instr);
  */
 extern int emulate_loadstore(struct pt_regs *regs, struct instruction_op *op);
 
-extern void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
-			     const void *mem, bool cross_endian);
-extern void emulate_vsx_store(struct instruction_op *op,
-			      const union vsx_reg *reg, void *mem,
-			      bool cross_endian);
 extern int emulate_dcbz(unsigned long ea, struct pt_regs *regs);
diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index e65f3fb68d06b..ac3ee19531d8a 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -780,8 +780,8 @@ static nokprobe_inline int emulate_stq(struct pt_regs *regs, unsigned long ea,
 #endif /* __powerpc64 */
 
 #ifdef CONFIG_VSX
-void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
-		      const void *mem, bool rev)
+static nokprobe_inline void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
+					     const void *mem, bool rev)
 {
 	int size, read_size;
 	int i, j;
@@ -863,11 +863,9 @@ void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
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
@@ -955,8 +953,6 @@ void emulate_vsx_store(struct instruction_op *op, const union vsx_reg *reg,
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(emulate_vsx_store);
-NOKPROBE_SYMBOL(emulate_vsx_store);
 
 static nokprobe_inline int do_vsx_load(struct instruction_op *op,
 				       unsigned long ea, struct pt_regs *regs,
-- 
2.43.0



