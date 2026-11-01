Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576835;
	b=rNGvs6dukZfCQyaBHzRfnNHe1Tmz5AyTg+PcgZ79kBE21mQxlPv/21PUWKBRdhtBMcpY
	 KwqoGLQrJgM1BYnmKnuVtVI3KO9adXhA8Jw49N30ROFqCPDJNM5GYo86MHUbkNr6wGjQO
	 SYTc2bH6sJcqu7t9TmrWj9p5Gsv1h4y5FnZd4iKkVSOZipr2KL4ngDjX2YWCFhgiT8WBL
	 184o3IsRNwiveNGnTEDjVqafTccDiuONypO/EFQdVTWhdHx2wRAuv7XWyqLoYA26MyjSx
	 n2hdnqntKqNM9yrQGFMoqMTo9ol40X2H2zA7WWTr75+u16/BfEG73NroO4WVPIuPQaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576835;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=M7Oyx2DZUoSsesoCOnmxqcLWoeKFeTaaJkmC8arYcXY=;
	b=hBEzltwwtx1ZGFoVnyA2s8cZZWpZq5ScSgYLbewJlZPJJbJl97jL18E6GuP0gcxfOCbJ
	 rhmyj9LnsqxECZPIH8EXbNR+t6zqC6gBPciDa7awcKQSwD6Y5/0y80Ks+cv5V1AX9mzYJ
	 3z3e4Me/sNVpaoeGAsuN2fA3k47fSUKVZQjSvRJd5neqq1BVZOSBIUNXYEqDlG1FWSDTC
	 Iesy50l/RWUe5D9i1gWZtOYHkGDpRsXOdWCcDnccBsYiGI+JIc9RCZgoSi/T0mjRtWh7W
	 /ZBUrvmt7WTOlOhB4SbQWDEWbyD3X0EffE9oIrq/iX0rsyMYngCUYPtee9vdCJqSFCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0F1606A32C;
	Sun,  1 Nov 2026 23:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C0F1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=M7Oyx2DZUoSsesoCOnmxqcLWoeKFeTaaJkmC8arYcXY=; b=MyeaQvIZRvtvw+ZwAephG4YBF2
	CPwq/2MCQ0R3Qmujb5V6S7WG2bVpA1APNU7BTaPXM2ymbQQe7kkkj3SZ5CVE/WZBxA6msTYrEL1JD
	zcWTYl7Bpc/dKPgRRUw0g6XI14QXF4Y46XSB5jcv8Ryrk7+opIsQSkNKjmcOdzHDmbm4Ilr2lslQm
	l347I2iF1kJRwWHf5MSIVRKKzYUEiERs7I8B339YPcmDmm2lXqfwlEbSNtAMt9KAEGPtr0Jlo815x
	UVZebrHFRkInF1EsAbGzZQTOx9u5ya3xnd+oI/Tlk9KD7BvqPmkCn1TO2l6cj2zAvvnsB9wWjWQ2T
	Mvna73IQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGM-0000000FGD8-1hqA;
	Sun, 01 Nov 2026 23:47:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 0/8] MIPS: Octeon: fix missing function prototype warnings
Date: Sun,  1 Nov 2026 15:46:49 -0800
Message-ID: <20261101234657.1820661-1-rdunlap@infradead.org>
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

v2 changes:
 [PATCH v2 1/8] add more cache prototypes to fix mm/c-octeon build warnings

series:
 [PATCH v2 1/8] MIPS: mm/c-octeon: fix missing function prototype warnings
 [PATCH v2 2/8] MIPS: Octeon: cvmx-helper: fix missing function prototype warning
 [PATCH v2 3/8] MIPS: Octeon: cvmx-interrupt: fix missing function prototype warning
 [PATCH v2 4/8] MIPS: c-octeon: fix missing function prototype warning
 [PATCH v2 5/8] MIPS: Octeon: octeon-platform: fix missing function prototype warning
 [PATCH v2 6/8] MIPS: msi-octeon: fix missing function prototype warning
 [PATCH v2 7/8] MIPS: Octeon: pci: fix missing function prototype warnings
 [PATCH v2 8/8] MIPS: Octeon: octeon.h: fix missing function prototype warning


 arch/mips/cavium-octeon/executive/cvmx-helper-errata.c |    1 +
 arch/mips/cavium-octeon/executive/cvmx-helper.c        |    1 +
 arch/mips/cavium-octeon/executive/cvmx-interrupt-rsl.c |    2 --
 arch/mips/cavium-octeon/setup.c                        |    2 --
 arch/mips/include/asm/octeon/cvmx-gmxx-defs.h          |    1 +
 arch/mips/include/asm/octeon/octeon.h                  |    3 +++
 arch/mips/include/asm/r4kcache.h                       |    5 +++++
 arch/mips/mm/c-octeon.c                                |    1 -
 arch/mips/pci/msi-octeon.c                             |    2 +-
 arch/mips/pci/pci-octeon.c                             |    2 +-
 arch/mips/pci/pcie-octeon.c                            |    2 +-
 drivers/edac/octeon_edac-pc.c                          |    4 +---
 12 files changed, 15 insertions(+), 11 deletions(-)

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: linux-edac@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org
