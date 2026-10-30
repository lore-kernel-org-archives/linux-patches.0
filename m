Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378826;
	b=mQ6W21RCyQ0WVHNzH7wc3LxcMrLNaOW1fFltehWYl4zs5EUfMfYaQ4hopgWrpP7XfU8g
	 tGhm0asuW+CDTzrLKI90QkNLudt1YdbL4+TQX8waH0AbVBL6+HZQV1L4okOZKQDM2XNzO
	 vhrY8mdfR2fUCORt+zHGRHNgl0+ZRcPSpWTKBi4XFEe0eWA4P7vxNNlrNIannixrNmTbL
	 74UR0Q7EVP6PRL1gszSuLlkcslx8PHfJfub+kzpBtsXAy7/oYj/42qQX5W4abHJuVFHpu
	 QyEEzB4TbrIQTqCAsqw6656hxFJirIvFYFh1OgmAon56RiRR5+q2thV9hoUrgpGbt+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378826;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=XUE9Za/x16rpxRJDuuxaoR/vN4NrR3EBaPfLI6kVNBQ=;
	b=IwwWhliDAojyhHDg+11plrqpExOxCP49RBCrIwqtdlojj5sslOsSHhR7MxPJMHeEo1BO
	 5bOMTSoPv8wV5QrCZLKr+X0QoszF/Jhk0Kpu5xz3mxswokzyCXnqPqkgE8h80HEwlD0jb
	 bub5GxVd7JJ/ys8Dxm+HbWFdhDPZ13Xg31oUZalReMJ8X6nOv+CWXdrieVbI8PlxBgVHc
	 pDDFc9W7jIiXI1su+Q/jBmY8R05sZr9i6tq4hgmQt5/fp052eJ7SfKJCiugeBysAwlLzy
	 qNSWguWrMvxgSWUZSl7hNMj+p8AeaR4h7XOA+FSTMjzIPF3BAMcGQJ+M6Z5h9RgFQiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CtePEMfc;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAD1606A31D;
	Fri, 30 Oct 2026 16:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CAD1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CtePEMfc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=XUE9Za/x16rpxRJDuuxaoR/vN4NrR3EBaPfLI6kVNBQ=; b=CtePEMfcEorHY2ZWc4nYrXDUYa
	/z8mF9g5JT55suvr8lwFzi2D4kCeF57Ee7yLQ4szfudAAlcM9aWtiqAYlJOAjhNum0WLeTYxZJ9xO
	nIifJSdub8TDjBQfk17NomOtHQGEb9eJMH2vhaWBqnX++rS6XEFceANlbPUMB7ZiThEB0RocBkwGh
	rLYCTfxK45CkoBhUO3Bipd0v9mqHCGzM4cVtYWHwAv4jx1tcZoXA1ZJC8s38UxuwQRyHpP7Cp2Bpf
	x5Sd1COLgyNgEalWW2rRGd18gK/kVSkUuWeqt/tkUx0nhFCAKwPhMIa1DYKK7z0UOfs9CHLMtFPNk
	fwHMa1yg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpko-0000000C9vQ-2kpb;
	Fri, 30 Oct 2026 16:46:58 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 0/8] MIPS: Octeon: fix missing function prototype warnings
Date: Fri, 30 Oct 2026 09:46:49 -0700
Message-ID: <20261030164657.2808262-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing function prototypes to header files in most cases;
use the header files in the C source files.
In 2 cases, make the functions static so that no prototype is
needed.


 [PATCH 1/8] MIPS: mm/c-octeon: fix missing function prototype warnings
 [PATCH 2/8] MIPS: Octeon: cvmx-helper: fix missing function prototype warning
 [PATCH 3/8] MIPS: Octeon: cvmx-interrupt: fix missing function prototype warning
 [PATCH 4/8] MIPS: c-octeon: fix missing function prototype warning
 [PATCH 5/8] MIPS: Octeon: octeon-platform: fix missing function prototype warning
 [PATCH 6/8] MIPS: msi-octeon: fix missing function prototype warning
 [PATCH 7/8] MIPS: Octeon: pci: fix missing function prototype warnings
 [PATCH 8/8] MIPS: Octeon: octeon.h: fix missing function prototype warning


 arch/mips/cavium-octeon/executive/cvmx-helper-errata.c |    1 +
 arch/mips/cavium-octeon/executive/cvmx-helper.c        |    1 +
 arch/mips/cavium-octeon/executive/cvmx-interrupt-rsl.c |    2 --
 arch/mips/cavium-octeon/setup.c                        |    2 --
 arch/mips/include/asm/octeon/cvmx-gmxx-defs.h          |    1 +
 arch/mips/include/asm/octeon/octeon.h                  |    3 +++
 arch/mips/include/asm/r4kcache.h                       |    3 +++
 arch/mips/mm/c-octeon.c                                |    1 -
 arch/mips/pci/msi-octeon.c                             |    2 +-
 arch/mips/pci/pci-octeon.c                             |    2 +-
 arch/mips/pci/pcie-octeon.c                            |    2 +-
 drivers/edac/octeon_edac-pc.c                          |    4 +---
 12 files changed, 13 insertions(+), 11 deletions(-)


Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: linux-edac@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org
