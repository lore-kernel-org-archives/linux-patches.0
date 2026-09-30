Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A03E50C2B7;
	Wed, 30 Sep 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783463; cv=none; b=cLnYavwVjcsB9Taywj8BzysXtNVNOvXlvJIAy4X1e+vkEoim5D7x+/khfM8Zd5aYg5YIO2vJiHX7QQmeKe33X1BkA4j7XipPR5E31wSxKmLqEw/d7Mq0IgtXniyjP9yo75GFwGn2IZFq8Hz7viXSmVLqw2TrGJFxHVE5bSvo51w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783463; c=relaxed/simple;
	bh=pSrmlDhKWb7YqShV9zm3KWik5nB3E1ER6BrhqSXTexU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krjSqBzULThjJQTnD20jRjlznve39eI9LlfmdNp4/X6H7brUXlliKuRBxHHaDQJFW/86rMlvrEgxgx0gBWKDkH0IvkzlXxDAY9/Jj0110QL6inobR4Lo5juZDuFCQSvznDmZqUh1RVhkth3iUgjFklnC63JQogfQw4lWKXzv9v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZgK0mUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZgK0mUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B421F0089A;
	Wed, 30 Sep 2026 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783458;
	bh=WGGppnw4+k2p3NbIjyCcm1CnuEI1hDVeoZ6EcQWUwis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZgK0mUjKyi/hFRPvjHE2ZVM5bHLwJaYagQJLNEkfl2ZOxQeBeuyOkq66xCAHaIwa
	 +eTp0mrPHiZkqAQoEj/Iw3uHWteQKUkF2OLRXTcarzegBdk+GJUUjzzzE3wmsDz/tY
	 eNCB8RYkRrXxYTIDzuFEUJsUl9Dyvnui3LTQihW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/595] ARM: socfpga: select the PL310 erratum 753970 workaround
Date: Wed, 30 Sep 2026 17:24:04 +0200
Message-ID: <20260930152355.229365969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit cfc1e9a543e3589ba200795b6e7fd8ef4314efdf ]

ARCH_INTEL_SOCFPGA selects CACHE_L2X0 and several PL310 erratum
workarounds. The 753970 workaround is still conditioned on PL310, but that
Kconfig symbol no longer exists, so this one selection is always disabled.

Select PL310_ERRATA_753970 directly, consistently with the other PL310
workarounds required by the platform.

Fixes: fbc125afdc50 ("ARM: socfpga: Turn on ARM errata for L2 cache")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-socfpga/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index b62ae4dafa2eb..02e4b27992c4c 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -17,7 +17,7 @@ menuconfig ARCH_SOCFPGA
 	select ARM_ERRATA_775420
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
-	select PL310_ERRATA_753970 if PL310
+	select PL310_ERRATA_753970
 	select PL310_ERRATA_769419
 	select RESET_CONTROLLER
 
-- 
2.53.0



