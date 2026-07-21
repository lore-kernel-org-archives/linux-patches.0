Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9D3783D4;
	Tue, 21 Jul 2026 20:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665788; cv=none; b=fVFK2hq4lv/xUWrLwLJe7/u3SwuWQx/n950bw1nazWtcOipLHwOhcPlsNIWQd0IBn899MJzIlxxCCvGGzPhE0ln+mKOCm3kus6VjqH1yO75k8y1YfL21sKIulQ/LlFtWxH/b9Cu19MRKSoklrlEA5199RFhtF2uHk6BY0z8vN9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665788; c=relaxed/simple;
	bh=+f/elpM9NnjDQL/N88L/3axnKEFLxcRmo/flQpoQ8M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Suz4Q9bO6o4KSCqNV3I1OiqJ7ZrSAshoqXQnjzOiQSLIX+ZRmQX3TC08b2FYjlSDP5hSWCnicT+QHVisR4JcxxpAeCr6lN4c67CR/eQdpqxvyh2/KITv5J8fPxdxCa/w/je4xvp5nzC7OfeHM0eoeIX955tr7Jb03RczqCPeP8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5CjsJD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5CjsJD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2326D1F000E9;
	Tue, 21 Jul 2026 20:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665787;
	bh=yMSk3McuC4e4BEjDJEPBF1hVeDCrOc1GSDq2zKzzH8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5CjsJD2Nv1DF0yTe2lQi2DdPnpNVa/6m0t6PFAEZGnl6yJyavBbXuGM5460AKddT
	 zhoIg6DwnmA/BFkc8w5/xzidrm/MDndelQQ8cpzLFDe7NksbFxKLFaQQiBWXQ9Zz2P
	 Ih5T1prjWrASzS5lyHwdfcTG3jJBBNFTdCca3bGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0436/1266] mips: ralink: mt7621: add missing __iomem
Date: Tue, 21 Jul 2026 17:14:33 +0200
Message-ID: <20260721152451.596936188@linuxfoundation.org>
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

[ Upstream commit 4ddaf88aadd3bd09c2eb3734c53d2864af6b144e ]

raw_readl and writel calls expect pointers annotated with __iomem.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild/202211060456.cnV6IK6G-lkp@intel.com/
Fixes: cc19db8b312a ("MIPS: ralink: mt7621: do memory detection on KSEG1")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/mt7621.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ralink/mt7621.c b/arch/mips/ralink/mt7621.c
index 137781d0bd0a12..01a6219214081a 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -63,7 +63,7 @@ phys_addr_t mips_cpc_default_phys_base(void)
 
 static bool __init mt7621_addr_wraparound_test(phys_addr_t size)
 {
-	void *dm = (void *)KSEG1ADDR(&detect_magic);
+	void __iomem *dm = (void __iomem *)KSEG1ADDR(&detect_magic);
 
 	if (CPHYSADDR(dm + size) >= MT7621_LOWMEM_MAX_SIZE)
 		return true;
-- 
2.53.0



