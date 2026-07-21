Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B527C46D55F;
	Tue, 21 Jul 2026 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648744; cv=none; b=u64M4Q5IUz+yZ+1VBKQPmEguaMKHQCLNnuCHRRQ5yTDPzHWhIKJ8ISqDtpG1QDrqB9NOwpODiIurbld+eKZgda9lUq86OZ63tSrMkjJFMouGQ8jOTr9ddE49FwEGOGqTb3OexrUaYtqO0/SaPXc8c4dU5WnXu/xwJNEme/FBDys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648744; c=relaxed/simple;
	bh=PEHyzN8okKI8l5bl+vxzHbKX14VCb4nE0+Rc4k7JIOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5MniXnnupe1/yCIN0xzdny3juaQuv2hjSNJsT9DmwcSD0dOJWaPOOohNP50YM6kUWqTw0WxyjvmrMLro54DO60HTeoa7Wg2uOLi+8qLk9inrHssOCW5q1ipe8my/zT2eWxS70OxZto8mfO/zI2nxOHal2UvDhLCpqlkTQsKAwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkywwSYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkywwSYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C5A1F000E9;
	Tue, 21 Jul 2026 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648743;
	bh=f9sTafjiHLgvZbxp6CqjPLrdBFXQ8iOvizRzMXhLSTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkywwSYhWZfimb9gqIQz4xauikq3tr7fJY91GOc5RZgMUe+2mRL3qJ/s1qsY6pdFo
	 H4cvSN+dKc9VFrOtkwVLHSsdH6FTfJZXrtm1RDioLbxbR1KNuMJ92Eok28A0gVt8PJ
	 MBoQmVuWP4Fkk/aGN14nQi/OBlQOQz0fy4bvPnjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0313/2077] mips: n64: add __iomem for writel call
Date: Tue, 21 Jul 2026 16:59:46 +0200
Message-ID: <20260721152600.061171234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



