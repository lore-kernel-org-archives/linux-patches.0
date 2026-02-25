Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660BD2641FC;
	Wed, 25 Feb 2026 01:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983488; cv=none; b=mpbY0cPgA18k858aMvsrGbFJJS1L3b9yM6AqTdwp9G3y/N3X4euygpwsKqkKz1d1ovaFr4HFmP7D/RPN42HGtW65pngua01dmSYECTWzwd2ADff2kH9x6iNZR6t7NXTd3HTMkf14FJX5cioerGKo7ijOGFrMVDrSxfpP+Q+iTlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983488; c=relaxed/simple;
	bh=XgVOx060x4RobTkkBVxqrqM6MXy3SSjIFCJ8jSJai9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYEkWGt/I4cRsa7kFAlu9YEpHl92uaksQc/jSzMfmiFfbPlAFQ2YMjeroKg06hs9BuCT1Dx9WkP4HW7pUKCA2mpOZZprNUUFGUWckOo4dGOlSHyno+4bhgOGfAaEljoKW4dcRy0Xg/GHIRiYHkU+wYg+HPfLrMbMyNpPVMIddFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEc5J68y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEc5J68y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1EAC116D0;
	Wed, 25 Feb 2026 01:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983488;
	bh=XgVOx060x4RobTkkBVxqrqM6MXy3SSjIFCJ8jSJai9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEc5J68yC/pm0inxB+VOqV7EdkOku1FneJdv97fvTQlUYWEHm+a2b5KZ5ebHIX8r1
	 22QCI1gnXtKx29cwPdC3caZkur45/R6sTHv/rJrqLqvXI6BvDZJZGrdDpce2BDppbD
	 YvYHiPf5CpyHeLysOnp78kWDq6fI3QI/Z4JO73yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Keguang Zhang <keguang.zhang@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 600/781] mips: LOONGSON32: drop a dangling Kconfig symbol
Date: Tue, 24 Feb 2026 17:21:49 -0800
Message-ID: <20260225012414.511774265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d463fc5ca1ace0b2e8bb764df04fc12ecd6f8e2b ]

CPU_HAS_LOAD_STORE_LR is not used anywhere in the kernel sources,
so drop it.

Fixes: 85c4354076ca ("MIPS: loongson32: Switch to generic core")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Keguang Zhang <keguang.zhang@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b88b97139fa8e..d87db7c535ea1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1408,7 +1408,6 @@ config CPU_LOONGSON32
 	select CPU_MIPS32
 	select CPU_MIPSR2
 	select CPU_HAS_PREFETCH
-	select CPU_HAS_LOAD_STORE_LR
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_CPUFREQ
-- 
2.51.0



