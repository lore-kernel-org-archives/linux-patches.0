Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4B746D550;
	Tue, 21 Jul 2026 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648742; cv=none; b=p2DbbfSekBY24XMqN7LUBJozPLWHM8tP6jgQYksV2KPYIM5CGWeBPOWdOvjpl5sCF7LTaOsjY2ws+naV3ttYPtjJXrxjr5wsDo4MSJb7oRj/0MKTcryX7+SXlqu0wn1hfpvDbPjNNhIKPAnLz4Za59Q+pc4ab54+M8Duz/pI9jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648742; c=relaxed/simple;
	bh=kQ8kb1rbCJpcn5/n6reHa48vhUnAvdi+4fwUQz+ib0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkhHTPWiJ4oE5GE3PknjBlkhzDAsbs0drRBrEshdEZ6vQsS9zGVay36kgZzkKKZmPwVm8uua/2EyZjvqW8Aj1lwrHjKkDh5HN+44WOhL2H53n9FV45rjp9oXEpYk0wKEFpO+Hr5CKYXjEEwgPBN85v1KCFc8K/qLXJsR0cucxzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbJoJCO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbJoJCO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850A21F000E9;
	Tue, 21 Jul 2026 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648741;
	bh=6a211OdS15hE+sCZv9aEsw7s1NYafIvDQAbCidSCxjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbJoJCO4syyHtLb+SNERw7cp1UXOPcodo0aQ1E8x2E+xS7J/XhBTdpWjIXYOVU0US
	 Djyn6o1FmKMJDxjUTJMcp4OuHNMz+LBxu54SZl8qJiOlN+ZrR2xxZ6fG88KO7VqMB1
	 MPeMiJ6XWs39Kno4oXtiBoa2VPioxlcK4Lr19cYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0312/2077] mips: ralink: mt7621: add missing __iomem
Date: Tue, 21 Jul 2026 16:59:45 +0200
Message-ID: <20260721152600.037680138@linuxfoundation.org>
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
index a4bdda8541c074..ae7b8cfedd5f7f 100644
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



