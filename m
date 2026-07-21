Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AED03ED3B2;
	Tue, 21 Jul 2026 19:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661692; cv=none; b=rxhWsCopHW0GaPJpHyWgNkwmY9Wj+0OYc5xC8P+vZ2jkR8HgSh/KAjGmLdkMfPMPgWV9TiUI/CpYlIuqZ+L4jk4SLp/67ExH6FD6dU9rzj+T+5NX3mXciqO9BMqIO9tbQDP4fqfi4J2lGYoZSa5xDLjHXCsHchiuq8S4G5QxEk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661692; c=relaxed/simple;
	bh=eaCOLLL6nuElXcIKWuZEsjHutqAxAnv0vLdBoX24rbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE/JrOizbTup1SywDefRvoEcJc9eWJ1SPc7gezy9H7UQ45uUYcFBh+zPnHPq4vwMKLZZREywP3YJmPCgIDVWcbAQ+cCAomHB9CgcWleKQg97tTF7iHbypJjJaatSDsWa3pXQZ3QjFI/C6nR2awMzkqkfYn6AHSSHwzzijr74elI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJsy0J0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJsy0J0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D061F000E9;
	Tue, 21 Jul 2026 19:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661691;
	bh=JiZkICX/ya/XVf6MftHNguLsK/YAohXfLA26dzvG44w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJsy0J0YDAgXxh+VRtigms70kz8gavRTDqwt5HS7Pg/i/Btp7kBKE625R5ITIzyqI
	 a/ZsvG6BduA4uiLBr+DXxzB4e7Q6JBLYbzSOh6R3DeJ38cnmBJEY52D2uLZj6yEM2O
	 v07l8x6LjTdEm+2LKzpp91McBJWhM7fNXmDhXvhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0162/1276] mips: ralink: mt7621: add missing __iomem
Date: Tue, 21 Jul 2026 17:10:05 +0200
Message-ID: <20260721152449.725638990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



