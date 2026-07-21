Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E1B44AB7F;
	Tue, 21 Jul 2026 21:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668972; cv=none; b=LKhObJb14Ndz3E2AJL5a/4Zawkckjhx8MyEn/m2nVbq4fxSYEPGb/ihDQuOOSvhXMU780nBA/F3UbUwmaVIqlyEvY8845GR0sh74BKJwFSvuq2VZM+jx2yzxrR2SqR7eipFgrRoe58jCo4neNWK+snVDgSjjgY/AmldZyzNuzCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668972; c=relaxed/simple;
	bh=WThCv6xlyKDMv9Wxq7B6vx+dC2YfFbkenuU4CgzZ70w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZX0LJWn9W23XkS2o87hpY4Iw0RzLoluWLjYVe7STLwrH5sbOZ5mp9C0nb5zuFLZA19iuVTh4ZfJIR6MyEV6ykwbsYmrmGYiWPGeT4wTLhZ3xEmjfAci+72tppW9lJ5lAGE1CpYS9Fzjkgvs/+va9MEtUuhWUYXhr0xv4sCsibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJRUfNze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJRUfNze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3751F000E9;
	Tue, 21 Jul 2026 21:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668971;
	bh=dd64nYs3JfazwcrngZHHClGjRgdLiyEq0eUpdM0e8T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJRUfNzeiKCEsr9+0/xCANA6Tpw0XWFvBkoN0LBIzzLBhIJ4vtATgZc6geS6BjH3I
	 +8o6m+G/TuQdiTN6o3YLTMN2rHUbEIjDTWdsABTIcYLdCAlJcu4FJ8uBnRSvpZlwt7
	 SEY0yhVSMJ1puR+WbDfAzyA42erZHRva0ZQOCDRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0335/1067] mips: n64: add __iomem for writel call
Date: Tue, 21 Jul 2026 17:15:36 +0200
Message-ID: <20260721152432.090896557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



