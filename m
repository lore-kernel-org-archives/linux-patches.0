Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639577D074;
	Mon,  8 Apr 2024 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583526; cv=none; b=Bsbi3yFP3qFMWavb5dwhEbR5Lbr9EcH3WcLZudn8XvWijppyBRezRQxaosWmj2noJ52Q6788/U5ApfUZpn1asFt/eHV5JGPGxUiLEoswbCesCkzDjrDwZpw3lHq9DsiteZpMOh0YCO3rkF/9r/Uo3Xoe/dj6yVFozZ+qsuW3Uk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583526; c=relaxed/simple;
	bh=+0pDmkOV3j7V8e00X6TxZEpW/DIDcA6vgMtAVVZPnVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOsTBl+9KRYvpJ/3fay0QNbAuafnfNRRpcgBXMCi7VLLmScsdFSIwO14+FtfNAMSNX5KcL5eF7QWimsihNw/LRTk9Vjufw7dyAxDZ7S1e7tW4AcZgA8lkAjssQWSvEyC+XrcTCr5qidDSsZVVfjTiZJry/TWbhAIG8+0IF63OSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pghfxaa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pghfxaa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE339C433C7;
	Mon,  8 Apr 2024 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583526;
	bh=+0pDmkOV3j7V8e00X6TxZEpW/DIDcA6vgMtAVVZPnVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pghfxaa+Nuae3HhI4xQAuC8nGDx0wf2HDhX+zst3KWcqlNmWQiRFdXrEZ04qC6dzB
	 FsYbAgHnvn4HeMxoNxyKfgbypqXNJXjXKh48/+jxvtoTk/x3g2oyipVNCJT6SX+yOL
	 TqpChyLjWj6LKlSNY4TldbhzHZPtDIGi0ZoARXE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Atish Patra <atishp@rivosinc.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 188/273] riscv: use KERN_INFO in do_trap
Date: Mon,  8 Apr 2024 14:57:43 +0200
Message-ID: <20240408125315.129745497@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@suse.de>

[ Upstream commit dd33e5dc7247041b565014f66286c9566b0e32b6 ]

Print the instruction dump with info instead of emergency level.  The
unhandled signal message is only for informational purpose.

Fixes: b8a03a634129 ("riscv: add userland instruction dump to RISC-V splats")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Yunhui Cui <cuiyunhui@bytedance.com>
Link: https://lore.kernel.org/r/mvmy1aegrhm.fsf@suse.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index a1b9be3c4332d..142f5f5168fb1 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -121,7 +121,7 @@ void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
 		print_vma_addr(KERN_CONT " in ", instruction_pointer(regs));
 		pr_cont("\n");
 		__show_regs(regs);
-		dump_instr(KERN_EMERG, regs);
+		dump_instr(KERN_INFO, regs);
 	}
 
 	force_sig_fault(signo, code, (void __user *)addr);
-- 
2.43.0



