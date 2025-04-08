Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988C12690CB;
	Tue,  8 Apr 2025 11:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110374; cv=none; b=PFwPSCrT9stqW7OdNwzikjR+nAVpqp3gJ5xvoxeYtbmlyI3re6GY/rdUoQjrHN/CX5hSUGu+dXjpGyEZUORTN4tDFK+gyEfjWtd9h7XV1qk7Z/AQylUxc5JXv7ZdBdfaCmfyqovncF/ohTb0AZNdu6JYR8QNBsxqWrZtJUlbiFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110374; c=relaxed/simple;
	bh=Ak0kkM4FEkc7aXB3hQZDu3LNz6sNBOX70FpZc1AHSFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8rlhC8VOwxZUrsM46mY2s/3mwFqNtn9+5RAy54DEr5MlQxgKrNlGhEhYZdDFL5JlCcHrNw9CJ+7riS9MJZBNh94JGjUZE/RySj1hbMaLLIjl1Nn/4NKx0UlDcpac9Wa3qLI0Gw8eW1TTsMhx4HASpeXxACKXPuq8JkI+cgVqKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyTYl8SS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyTYl8SS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274F3C4CEE5;
	Tue,  8 Apr 2025 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110374;
	bh=Ak0kkM4FEkc7aXB3hQZDu3LNz6sNBOX70FpZc1AHSFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyTYl8SSp2cSDVM5nYa1Gc99KNTRD0JIGl+WqhZUIMR0Q2oE6QO/tjf7rWjYYSQJv
	 xmY/pveghPrUjn02CsLRtxIfmmZO/dgWF2BzCyIe1GlNJRzaOw5k8uh7rJjH13dwsv
	 y4OCXn52sodf1ebT/r+T4tgQ72pi9qE+hPmPTdco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 004/731] m68k: sun3: Use str_read_write() helper in mmu_emu_handle_fault()
Date: Tue,  8 Apr 2025 12:38:21 +0200
Message-ID: <20250408104914.361171733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 751b3d8d886e73ecc24a5426adba228ef7eb39e8 ]

Remove hard-coded strings by using the str_read_write() helper.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20250117120605.126941-2-thorsten.blum@linux.dev
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Stable-dep-of: 723be3c6ab31 ("m68k: sun3: Fix DEBUG_MMU_EMU build")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/sun3/mmu_emu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index 119bd32efcfbc..7b15cc12637bf 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/sched/mm.h>
+#include <linux/string_choices.h>
 
 #include <asm/setup.h>
 #include <asm/traps.h>
@@ -371,7 +372,7 @@ int mmu_emu_handle_fault (unsigned long vaddr, int read_flag, int kernel_fault)
 
 #ifdef DEBUG_MMU_EMU
 	pr_info("%s: vaddr=%lx type=%s crp=%p\n", __func__, vaddr,
-		read_flag ? "read" : "write", crp);
+		str_read_write(read_flag), crp);
 #endif
 
 	segment = (vaddr >> SUN3_PMEG_SIZE_BITS) & 0x7FF;
-- 
2.39.5



