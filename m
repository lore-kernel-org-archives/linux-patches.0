Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521A221FF2B;
	Mon, 23 Jun 2025 22:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717026; cv=none; b=eSx7RtVKghomG2v8uEXg+mm19mgYrUuvIC17e7JhpxFzQPGBczVKm5yRCNikufU7Y9OXpn/s3DjIEm+53A4RnREugkzFh1ZnwrO1CK/Gd2IAmSbcFx8/xLSjyUT4PNQFquGUkkN8rrDLvMmLkRKEpdUViECWIZD785Qsz/f2bKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717026; c=relaxed/simple;
	bh=8ZtJ6iDNCbaXca9sHpPRwYEWJ4jBsRPEFaJYufGeUK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsxB6K8V02d4cxUFx+yWOqYksp7IFsnDXYNsJYZ6pE9Ga9BOMQmsFMO+aMD3j5gol+PLm4XYrighTM/J0eybonkZ7LmXWZgDmt6rPIvP01x8nY6tCxvxF4oVu4qscn7d4Q9x+UE0JL4W4mcfxBiGATRHYDTkdopPDb1VMZmqgQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ox7T1tiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ox7T1tiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEABC4CEEA;
	Mon, 23 Jun 2025 22:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717025;
	bh=8ZtJ6iDNCbaXca9sHpPRwYEWJ4jBsRPEFaJYufGeUK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ox7T1tiFFDT5IV+to8HBQmNZEcFLyhOjcMwCXvfgW0X9YW1bu4FybfFCGnX58HzSW
	 ITYcfAgPdmkMk+ACH8U9lbUYABGn04qeZY+s2/uc7J4NFj+S9v1Asuc75ZSAvJuIsu
	 2VYi9pzNC72vZrMOYm3xdI5tdaWye99o5EglEaFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Will Deacon <will@kernel.org>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.15 388/411] arm64: move AARCH64_BREAK_FAULT into insn-def.h
Date: Mon, 23 Jun 2025 15:08:52 +0200
Message-ID: <20250623130643.430994937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 97e58e395e9c074fd096dad13c54e9f4112cf71d ]

If CONFIG_ARM64_LSE_ATOMICS is off, encoders for LSE-related instructions
can return AARCH64_BREAK_FAULT directly in insn.h. In order to access
AARCH64_BREAK_FAULT in insn.h, we can not include debug-monitors.h in
insn.h, because debug-monitors.h has already depends on insn.h, so just
move AARCH64_BREAK_FAULT into insn-def.h.

It will be used by the following patch to eliminate unnecessary LSE-related
encoders when CONFIG_ARM64_LSE_ATOMICS is off.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20220217072232.1186625-2-houtao1@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/debug-monitors.h |   12 ------------
 arch/arm64/include/asm/insn-def.h       |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -34,18 +34,6 @@
  */
 #define BREAK_INSTR_SIZE		AARCH64_INSN_SIZE
 
-/*
- * BRK instruction encoding
- * The #imm16 value should be placed at bits[20:5] within BRK ins
- */
-#define AARCH64_BREAK_MON	0xd4200000
-
-/*
- * BRK instruction for provoking a fault on purpose
- * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
- */
-#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
-
 #define AARCH64_BREAK_KGDB_DYN_DBG	\
 	(AARCH64_BREAK_MON | (KGDB_DYN_DBG_BRK_IMM << 5))
 
--- a/arch/arm64/include/asm/insn-def.h
+++ b/arch/arm64/include/asm/insn-def.h
@@ -3,7 +3,21 @@
 #ifndef __ASM_INSN_DEF_H
 #define __ASM_INSN_DEF_H
 
+#include <asm/brk-imm.h>
+
 /* A64 instructions are always 32 bits. */
 #define	AARCH64_INSN_SIZE		4
 
+/*
+ * BRK instruction encoding
+ * The #imm16 value should be placed at bits[20:5] within BRK ins
+ */
+#define AARCH64_BREAK_MON	0xd4200000
+
+/*
+ * BRK instruction for provoking a fault on purpose
+ * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
+ */
+#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
+
 #endif /* __ASM_INSN_DEF_H */


