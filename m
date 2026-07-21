Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D9143B4A2;
	Tue, 21 Jul 2026 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671486; cv=none; b=h4Ruteo8vXpWZpgV+mV+Cf9710w9ZxDjVTIhq1UkXRQG+E2cnzBtwhrSHHcCzR66uUAhibuIb7478FquOqhC5PxphJEnBewF3Wd67JwXOCp1Eonkub92FAEA22fn9ZT7dRhHnR9n26Tp2lvu5Tejj0vctaRNVLx/Kv4bK7gHcCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671486; c=relaxed/simple;
	bh=3yj636CWhHYbqcudylQc1AQE9b5OdVp+E/xRuNCz0lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3wBaHP08crGsA/MXX1Uk/8L9WvaMnalUs10G39MeeiiBXki2hEJf/pQ1db4CFdlA21tYhYBv7CEpJli4107cKo4eB4YBN+UK7Cd+/L6A9Ebun3C47uQCzV69xWeVP8L5x8ejrZ85jHUmsGxh9MX05zXEOjbFwZJkxv2E/MGENE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm02vsUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm02vsUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64011F000E9;
	Tue, 21 Jul 2026 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671485;
	bh=iGbSAVDh5jviphVCVfmVuGd06NaA2AWVELnVaXB0D58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qm02vsUhlYfBD7tG9RToEbxK7vxRh6u2i3cCngwvqsHYY63HxAOrM+TLlJNaFRV20
	 Dm8QTi3cMIy4PCZOumF1lnBkWHH5MRshffLaLr6WPJ46IkbEEhMl1qvHDzlaci20wx
	 /UdICmUj07Og3uLWnHrHMMJr0stzX+dhFE8Jf668=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/843] mips: ralink: mt7621: add missing __iomem
Date: Tue, 21 Jul 2026 17:18:17 +0200
Message-ID: <20260721152411.918896431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0db23bcf2a970f..9638464fdc9d54 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -32,7 +32,7 @@ phys_addr_t mips_cpc_default_phys_base(void)
 
 static bool __init mt7621_addr_wraparound_test(phys_addr_t size)
 {
-	void *dm = (void *)KSEG1ADDR(&detect_magic);
+	void __iomem *dm = (void __iomem *)KSEG1ADDR(&detect_magic);
 
 	if (CPHYSADDR(dm + size) >= MT7621_LOWMEM_MAX_SIZE)
 		return true;
-- 
2.53.0



