Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D8444AB99;
	Tue, 21 Jul 2026 21:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668954; cv=none; b=YKlJ/u1AKAsFEy4H4gteC2Pl1Neyg6v0Yqk/L+JJa4gXLz/uFjKr/cfxiPk8ZEhEE7bsq1eX1ZQWE5EYYghSromBzvVrfZ3kJmQsduWMzvcEPtDjWtgA2ZuGM88Z8uYXWxQZMX3S7c3VaejwdJm8n1Tgv1Rx22EyWna87HcfOt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668954; c=relaxed/simple;
	bh=GsTFt81D0/e6syTmSqyUJp1Jbh3gpK79ObYD/seMoLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5RiZFQ+T6bs7nasJa3K2yFz3OXoyOe7KjL5FKS6uzJby6ZN4GSWA8jDv03y7Fd1zbzPXOk5fEumM5MMNIS9yfrHtNuumdnxlTgGkPscSyW/gO7SCYmo6oimrikRFWsiSSASg34ECgrUGH3uNjP5gaacuemhapWNeRJdgvYyOj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiZd/7cQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiZd/7cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1B81F000E9;
	Tue, 21 Jul 2026 21:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668952;
	bh=5lhXWT5xVycKC9GIZ6vjRELUpDTTuA72ruF2ecDHJWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiZd/7cQhZ9ZXfh3XfkbsedgUEj2cTY0Wh+CYm/TRiG9VlUY50c+y1n2N65pyTiSp
	 RD/tSrKh1sdBPDVwquQHUzdQFzkp8EtVheT+pRCGd/LdOhbD7QY51rPH4sM7+GrQjX
	 k9JRixHDCUbWeFRKluq+Ibgm8pv5OD9MRnASupX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0334/1067] mips: ralink: mt7621: add missing __iomem
Date: Tue, 21 Jul 2026 17:15:35 +0200
Message-ID: <20260721152432.068347163@linuxfoundation.org>
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
index bbf5811afbf2c0..efa430dbe15241 100644
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



