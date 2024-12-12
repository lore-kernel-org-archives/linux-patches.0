Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D338120A5EE;
	Thu, 12 Dec 2024 17:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025243; cv=none; b=RD22xfuU7OmWbzp9WNWQyq2atibgBAqkjUwnqH5rcn0aiLqFqe/NI8nd4VpbApTV6FIXMzGiyCdnE+YnAZL2i6c/amkj/shWEIb5wGodQ+/vJYUgfnMTWHdb27sV0cJyhepBpTNWdoVQPR2w7IZz4qh7J4RSV60dm97tVXYvo6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025243; c=relaxed/simple;
	bh=owewg07qQg5rGh8gG6pGebaEKP4N1AGhUaf3M560Qwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fae0/gt8UY0IaseSElLovtP3r4lFxrJUO+Ac9J3brq5oalZkvpnjkGibRFEyXYEOtnhmO9muGelntT+1160NRyH3JwI2cOldxbtsXwT71gcr5rll9tZhTFB+Mtk50a6P2wuP50fOyZRVrnvVYPic0O1Zh2Qm/viz4TghsnHBq8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdwIhd4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdwIhd4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B69CC4CECE;
	Thu, 12 Dec 2024 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025243;
	bh=owewg07qQg5rGh8gG6pGebaEKP4N1AGhUaf3M560Qwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdwIhd4EBgqcVq5/wNaqXI+hMAWGJkDIptInuypX4z26vNdBW33zBOo8quDQRE3TP
	 dj1QeZnTL54Hqtn9xQgj/wAcHj80e7s8f2IyUHCXWqSzI4kr3j+QvfIXVavWIwVdFR
	 E522eT69UI8gOH7ZQYzs46iapuVSYgpyLN+CwjqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/321] powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static
Date: Thu, 12 Dec 2024 16:00:21 +0100
Message-ID: <20241212144234.059289636@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 769f055509c9a..eef81dd406075 100644
--- a/arch/powerpc/include/asm/sstep.h
+++ b/arch/powerpc/include/asm/sstep.h
@@ -160,9 +160,4 @@ extern int emulate_step(struct pt_regs *regs, unsigned int instr);
  */
 extern int emulate_loadstore(struct pt_regs *regs, struct instruction_op *op);
 
-extern void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
-			     const void *mem, bool cross_endian);
-extern void emulate_vsx_store(struct instruction_op *op,
-			      const union vsx_reg *reg, void *mem,
-			      bool cross_endian);
 extern int emulate_dcbz(unsigned long ea, struct pt_regs *regs);
diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 490162fb0893f..368a36079cb6c 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -663,8 +663,8 @@ static nokprobe_inline int emulate_stq(struct pt_regs *regs, unsigned long ea,
 #endif /* __powerpc64 */
 
 #ifdef CONFIG_VSX
-void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
-		      const void *mem, bool rev)
+static nokprobe_inline void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
+					     const void *mem, bool rev)
 {
 	int size, read_size;
 	int i, j;
@@ -744,11 +744,9 @@ void emulate_vsx_load(struct instruction_op *op, union vsx_reg *reg,
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
@@ -820,8 +818,6 @@ void emulate_vsx_store(struct instruction_op *op, const union vsx_reg *reg,
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(emulate_vsx_store);
-NOKPROBE_SYMBOL(emulate_vsx_store);
 
 static nokprobe_inline int do_vsx_load(struct instruction_op *op,
 				       unsigned long ea, struct pt_regs *regs,
-- 
2.43.0



