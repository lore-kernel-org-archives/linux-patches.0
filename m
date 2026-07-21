Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671FB4071E3;
	Tue, 21 Jul 2026 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656002; cv=none; b=hiS/GAKSKHS1mM+TBcSu0iMOlnj67P5p/IxGTKa0RjvOOBKOsM0dXULshNvvnoglNMAsC/qe9OlCFv8nmsFtHD3fWrm2+U/HfXjd6qn1m5J4LUdkHlu0ffMc7VAsz5JB9cBF/AJtOiUL97NgGbocPqycQECOiRAhGAeaMXMQfCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656002; c=relaxed/simple;
	bh=ZjMSIYVD0+O2HAlB71VQ7RyDbMLF46/mGsJ9gcq7Ri4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1s/Ik/mFJ3yNt15rSrx3F2faKN5HUuXlk5e03dnYvJxuJHR3en+n1L7Aa8mzkkxKOxTGFlxhOJKQf8h05WPae4zfzuvileHLsJEJZTx8MTFsKAmwicBkuRLe1omCE7BsI5uhsmrZw5UqX8TNc/Ly0ZAduJq59PrLVVzdPseZ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtCiMLSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtCiMLSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC08C1F000E9;
	Tue, 21 Jul 2026 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656001;
	bh=XNxcl+ifpawKD1iWYKUGRXDgO45D7CEgWCksHidC+3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtCiMLSPLaqA3DR0XZDjof7eVLyNzxIuS/lUUiwYneXQvctsGJI5gt7NCjjjGzty7
	 6ujGojQpxQGKQ/XvG9AjaqOioA7DaW5BWea/qp0GoBjnGoutmGcGrr4uJ2zAjgbZba
	 4rg4xVuldty2ZUj/QekDdESw/wO9/zAppiIERvgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0221/1611] mips: ralink: mt7621: add missing __iomem
Date: Tue, 21 Jul 2026 17:05:37 +0200
Message-ID: <20260721152519.971084437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a9fd3fe41d7c5..e25444b149f772 100644
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



