Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19457225788;
	Thu,  8 Oct 2026 18:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484220; cv=none; b=c2NzmD2wUPHqAcuFhlIh+1XgqcrWPQhemNoy4AO18KBlX2hLBtBKTWqpfy/e+bgYNkrPNNF6vktY56m1xPZJC2X9zZ81onkRJRS2Sec0nlHM0vwJBagTZgkDc6EwerE5PBv6uzaiN1eo197NyUpBR+60nzGnKaYJDRkTvpyo4Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484220; c=relaxed/simple;
	bh=RNdz9UKzKcC+uRjuFbNWTDQFLvNmnGRTk1T8npahb/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TOglIIrbW/GOuF9uIpPggsuqCm5257U4GqoHyQgW3aEizot2/DN0/uSZS7qZas5p9A7By3xa8mkd4dfXwB27NamdSq4yr3WOhhwqQ13L4IdKgW5mVGBq+vIqmuwIb6uuDgwwEsDAMpiTo3VPmVMjEo10zvqOc7mu/46Sf2P/Gzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vcSz85uM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vcSz85uM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Pw8rpueyBeSecqu2/DLa0dDqLjzyaoDXNmPpBPUzR70=; b=vcSz85uMDFTL72hLE3AjFxFPO5
	X2uB1yThmy3+sW2DNHo7Fv8OlZnK//W62vh+bN7+fCJO2FGu5IrKKACQzLYP1y/HWSYJ5J+65qTAm
	25A2e58DY2fXnyPmgUo17HClPuEQmn6rWZy12k6ebY1kV6Wabisqoy7Cz+qksE2sYzEbGpaD4gKgR
	WUkD+tK6iCxPOM19nL6AIi/JjCJUl0KoWADXFWzH7I4oQaZqVk+nds8CJbkndeQX/WUJOZecaOG1A
	AhExPcXOsKSdJoP8gln7TZAY1UxJruY6SiyNhSQX7URzTInQZomLLZgNJKX8WMKxheyOORhtBlBny
	GD9+utlQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEssf-00000004rhg-48e6;
	Thu, 08 Oct 2026 18:30:14 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: natsemi: xtsonic: make probe function static
Date: Thu,  8 Oct 2026 11:30:13 -0700
Message-ID: <20261008183013.3223131-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid a build warning by making the probe function static:

drivers/net/ethernet/natsemi/xtsonic.c:200:5: warning: no previous prototype for 'xtsonic_probe' [-Wmissing-prototypes]
  200 | int xtsonic_probe(struct platform_device *pdev)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org

 drivers/net/ethernet/natsemi/xtsonic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linext-2026-1007.orig/drivers/net/ethernet/natsemi/xtsonic.c
+++ linext-2026-1007/drivers/net/ethernet/natsemi/xtsonic.c
@@ -197,7 +197,7 @@ out:
  * Actually probing is superfluous but we're paranoid.
  */
 
-int xtsonic_probe(struct platform_device *pdev)
+static int xtsonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
