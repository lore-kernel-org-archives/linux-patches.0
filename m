Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE6B35946;
	Wed,  5 Feb 2025 15:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768437; cv=none; b=VmMheYPsPrxHy/QMzEN47Lx4wY4uwy/1cbP/nRimjPBIim2p5PXBnihyvE6rFpRS1LEde8R4qB/gSxxq1HfKbUaiuBMfWymnhogw6Rsn5DkIfWzmMDEklpY1CWF7eX87g31pc+xkfERC/p4EOQl/8adgCqk2oezVAKRM9OjjHEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768437; c=relaxed/simple;
	bh=HjxDT1VAgJrxFsN4+5HqlQgkf0aslvtaTv3rNPzPSu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3CdIhB4ZXnIqGhLGWe6mixuJnm2hS6GmrsF52BFpwMJe5GekDFNi/s0OB3Nw/6q6hS5RYx/mngTTyU8Orp8HXQ5ihWKYivG/JpIDDmeHKRWQXJ/jaxMsMLCO3akLzubO0WucqHAuaL1T6TwAlAU32DrefHlFd+to5TttKyKKsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyow0Wbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyow0Wbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A1DC4CED1;
	Wed,  5 Feb 2025 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768435;
	bh=HjxDT1VAgJrxFsN4+5HqlQgkf0aslvtaTv3rNPzPSu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyow0Wbvv0/AQcPjoG75IHRXT1XCDAnFJhaVg5PSHhYZOzlIo9Q0WWPfbQRQ1W2Yw
	 7HdOqioftQbcE/DSyg4K5zIPbTaKHL4yKPWKKsbdoxXmsRe8pnDeaU8Nb8JqlZyCO4
	 14uEoX/mVKZSOwh/hUVcIkpTMm6fl9u1gZGHc2Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 557/623] RISC-V: Mark riscv_v_init() as __init
Date: Wed,  5 Feb 2025 14:44:59 +0100
Message-ID: <20250205134517.529562387@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit 9d87cf525fd2e1a5fcbbb40ee3df216d1d266c88 ]

This trips up with Xtheadvector enabled, but as far as I can tell it's
just been an issue since the original patchset.

Fixes: 7ca7a7b9b635 ("riscv: Add sysctl to set the default vector rule for new processes")
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20250115180251.31444-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 821818886fab0..39f0577f580de 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -309,7 +309,7 @@ static int __init riscv_v_sysctl_init(void)
 static int __init riscv_v_sysctl_init(void) { return 0; }
 #endif /* ! CONFIG_SYSCTL */
 
-static int riscv_v_init(void)
+static int __init riscv_v_init(void)
 {
 	return riscv_v_sysctl_init();
 }
-- 
2.39.5



