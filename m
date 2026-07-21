Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B4A3FE356;
	Tue, 21 Jul 2026 20:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665791; cv=none; b=qUhh17PqB2Jn06IYyKARozCSqhvEAcPJvMB1VcbWXFBH3KFGqLTKlu8+qRyT8MnmKnxXr65wDNZN37U1OanCouOJq2C7swpBT/pJOr5lemzU3OprePfpQ6sU0CMzUPTMEnEze+BVs8nkmRIgfNQ6UfW2G5FTxTzuUpC5UvYqMKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665791; c=relaxed/simple;
	bh=XpWCrf9SOJFHSpbc41IXtneYoJrKNnHERLmXM+8kTYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TigDsy5Gp6IRs6UEY/JjzKpnRzix9MaMkYnrqxNAU86ROU4wcYmsJxntH0jNcVT5ZnTlJZSDlMDMreNJRsNCsEnWhsCC2USVLeYKwfzLTr1wRBDFoSCEYNfUijBNI5Ab76/u3QhB56O4E46n+wYPaQZiSHmOwnbB9vWt6y33MeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDDbtY9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDDbtY9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9441F000E9;
	Tue, 21 Jul 2026 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665790;
	bh=SBq6/ZJCoFgbVi9QOX8yagqj5FIyoNUJnLz0Zbl+8MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDDbtY9ZEKl6EYc5igT97FwOIMheN7RC+5LGM9Y+lGhV+vcECPNjbwVbYEP9xwUfv
	 US3GkzHSgqYUzwoVURheTzTmoqbPGYcenMoVTxPZx3PjMrDq8iGWMYy1WZBECQASFm
	 gFyc+aOACkoWV2g0D0oQhncRensJnGzCg4XL/hYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0437/1266] mips: n64: add __iomem for writel call
Date: Tue, 21 Jul 2026 17:14:34 +0200
Message-ID: <20260721152451.618657580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 579f5329d5df2dbcf4bb5ef398701c2501d24892 ]

sparse: incorrect type in argument 2 (different address spaces) @@
expected void volatile [noderef] __iomem *mem @@
got unsigned int [usertype] *

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202105261445.AcvPd2EE-lkp@intel.com/
Fixes: baec970aa5ba ("mips: Add N64 machine type")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/n64/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/n64/init.c b/arch/mips/n64/init.c
index dfbd864f466700..66ec28ab41f321 100644
--- a/arch/mips/n64/init.c
+++ b/arch/mips/n64/init.c
@@ -50,7 +50,7 @@ void __init prom_init(void)
 
 #define W 320
 #define H 240
-#define REG_BASE ((u32 *) CKSEG1ADDR(0x4400000))
+#define REG_BASE ((u32 __iomem *) CKSEG1ADDR(0x4400000))
 
 static void __init n64rdp_write_reg(const u8 reg, const u32 value)
 {
-- 
2.53.0



