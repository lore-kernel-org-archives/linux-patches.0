Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576830;
	b=lMZ/SYFTlnzRhPm3i694EC388VEip63HaAPyY0nY2QQAELhbkgF2FsGkMQ55Ez6y+Qqc
	 SJLijST0qdMj3bbP7CHmynB8+9Sfmg+bJnsk6jTAnfgOCjbvWZdJj6XIGpCkJr4n8J4HH
	 9W53QxbJdGUZ4ZFU3H73ZOaCNASvyedw3gZRfWbSzVfZyh2B9L1K40IV1txm62PMgiz2i
	 mSIX5xOB47OmgIRZCjEItVa6BIBra1UR4UnHTh6rescDaeVgr3xT9OUWHD2iUXrvZZMi4
	 7v2wG/b2Ht5mE2nTe/Q7seDIgeaRoZhB+YN7ZbMHT9r37vTXP7xUvVGdG07rFq9uEdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576830;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dfbnE33LdddbYP4rPcgipu3MYvLeg/qAyG79sFC6sfw=;
	b=nboqRy4irsgtY8GGGnNZOR9kIll7iSikavcjofFohN9vOqXm22UWErZPKVh4qSWzI/Hv
	 lnmFgdlB/2MoiQInYioMWTFxMfgleVOvKNC2rVtP4mpu37VAhHleHRjKShLQ9tFp/X7fI
	 CpsYCq2ntE8SC7oA7fX52SetfkOEEfCJxy6plhXDHvDeEuALmmCjonOBS9bycwnW1AMrr
	 /cU8y+38j5J7GkW435dkoIhW9vbxGAkDdxNivZJ6sZsD2UoajHvv0rLYartjKBejme2RA
	 X1O5cmglTkUNCxlXtK4KkiZIeIciTssAwaY3PMZuhEv9qsorN8uvOwhOxmccToQtlng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="nLQC05f/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF34606A327;
	Sun,  1 Nov 2026 23:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BF34606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nLQC05f/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dfbnE33LdddbYP4rPcgipu3MYvLeg/qAyG79sFC6sfw=; b=nLQC05f/3VV7MkWnITGgcmtAHg
	cOSc0VWO9FLr6ph+JAnollIdBk6/w5Ffs7C75sr1Tsq5mIMRuXoHeykVB6JplexHFxYrUr0Zt8yg5
	uZCvEwk40CrJ1pI9aASK70Gw0EZqBqPiiSxNTC/dv/h84MKnrzdzdQgF+5UlXp+RzEY3l61JheyjD
	Hfsl1ERxEpA17PVTFOu6/uHGgpQqryLLVeLhIJTVZwFr6mxLBZfLWmBVbogp1wmYN9qvfFsm5nAoY
	F0WDaR/I2Cie3KP+apbc0ZnQ93TxT754xEfRtXo+Hobv7li6/wcWMlwOUsrKr4NPIyygIqz0gltMK
	3TOTcXvQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGP-0000000FGD8-2kbd;
	Sun, 01 Nov 2026 23:47:01 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 6/8] MIPS: msi-octeon: fix missing function prototype warning
Date: Sun,  1 Nov 2026 15:46:55 -0800
Message-ID: <20261101234657.1820661-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101234657.1820661-1-rdunlap@infradead.org>
References: <20261101234657.1820661-1-rdunlap@infradead.org>
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
v2: no change

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
