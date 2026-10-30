Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378828;
	b=oTkJC6tArCkwsZcPRzDlsm29IwyV0Sa3fl6OgTp0xGnvt02g8u+QgwRR75N80ouFJ3ga
	 i9jWFqEos9AhODuc3RTI7bVD1YPNIs/PfVNceRZuAcnj8Bjum3pPkUoAzS7CV4FdRy+fi
	 jB7tHb5r0Fx14ux4Q5LuSifJFJwEXTrFGQxHIZKWXDEzox+/i/bAo0cPrKRMyNzpHLNMf
	 BteeNNzQvo4ZdloHU/2ALE4QRk3Fq0QTgpUXtcyTBnpfp9uIxL4YGyZfuPBVD2o4LSUhN
	 27BVj0MCRBHxVKrObvg96kXzZKS4cKLS9JDmdHm6RX52N6knP+Bb8qh8v1kbYzJ6NwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378828;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9p1GuUEXJDhpEntzHN7rpZzjkEvrs5EXLhtizQRPF9g=;
	b=TW6khviAVFi7ADVMysWYpOxawOFJqy0yfNR5mJQBETTWKJVdlzks75/+n4Qk5SNzq5ik
	 PfHC3KgIWHBy/kiJLSjO9GfKXykKi6AtsuV+uSu2dyy6R6U2BeV21MthV/8/tjfOKgnK3
	 AgIpETjRhf93ScfEMoWURzgApCI0dlyUEqcUArgkFnEt2ji0XYMhKQEHpHp5az5wj/Gf6
	 j/7gEvUgElF6SHU3k+BKIPuJjTCkkRdSNkVwo7zQO92n6pB55V130fuJvbhEdhiR0zZLo
	 xqDXSEoMN7VoSGBqM1+2y/LEvImIt+mui77tmgfh5uIC7MJR3ICX5ATSyfD1Z7TukBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=sKfgIY0w;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829AE606A321;
	Fri, 30 Oct 2026 16:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 829AE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=sKfgIY0w
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9p1GuUEXJDhpEntzHN7rpZzjkEvrs5EXLhtizQRPF9g=; b=sKfgIY0w6IEuz6XI5QUeBSnhyO
	12+sGBEymM17vQpJY0iqf/tygY8sD8vPoKtZgtOTBcUKhRCeKEJHZcynCXzZggqDtsAB7w0Eu3TkU
	4dtO+qn4ZY/dkrCnRLpkoc37p0/qZzIKQiQSpussqPKZpFW+qlX2zVFs8a2SMWKFBXEVS0NRBRhKO
	mf1U8+N5aGUBMp3YwP6UCYGX9yHmk94zdAsU+35bzEsKKHRDDItbFqvyAJ9KP2FDbJnzCGsU0AlUE
	zZLRSZemcy9Exv03T/FgtINlG7QOpmnYP8qBEQN3U9IRUqcl/z/4g7FaE3Ydbxh54t7YAFeh8eUHm
	rvzbIcJQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpkq-0000000C9vQ-0ThR;
	Fri, 30 Oct 2026 16:47:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 6/8] MIPS: msi-octeon: fix missing function prototype warning
Date: Fri, 30 Oct 2026 09:46:55 -0700
Message-ID: <20261030164657.2808262-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030164657.2808262-1-rdunlap@infradead.org>
References: <20261030164657.2808262-1-rdunlap@infradead.org>
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

octeon_msi_intialize() isn't used outside of this source file so it can
be static to eliminate a build warning:

arch/mips/pci/msi-octeon.c:343:12: warning: no previous prototype for 'octeon_msi_initialize' [-Wmissing-prototypes]
  343 | int __init octeon_msi_initialize(void)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org

 arch/mips/pci/msi-octeon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20261028.orig/arch/mips/pci/msi-octeon.c
+++ linux-next-20261028/arch/mips/pci/msi-octeon.c
@@ -340,7 +340,7 @@ OCTEON_MSI_INT_HANDLER_X(3);
 /*
  * Initializes the MSI interrupt handling code
  */
-int __init octeon_msi_initialize(void)
+static int __init octeon_msi_initialize(void)
 {
 	int irq;
 	struct irq_chip *msi;
