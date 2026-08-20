Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614B133D4E8;
	Thu, 20 Aug 2026 16:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243725; cv=none; b=Jn4yGjLwmA2+JJL6Ax9I+jAoan47pxionmq9HG3m4tkC9+TaZM0zxNIJJhBLGBFelUGo/xBR1obU/0AuLvzGeu4iJ+FnKKOhGMufCsMbUrcGNGkMy5Ra+k0k+chm3PtH4+jJ+CIpToDDWffmS8v91mG+f89cowvzCyKRQAvOl2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243725; c=relaxed/simple;
	bh=kQ1tPVncQM+brVQZgGQ0Fseb3JBem5fxjfitKcWyaeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aylqUeeTQBy3nwDxTq2P0c4JxEOW+mthdDUqleyykX2iTdaTBg3g5ul3gqEnAulmePYyc0WuvURL/CvUTElCj+naxtNRyyZxMS0aCRRA676JOa/xTxlYJ93Cf8s/t3WKcP7E4tRqDA98gRy5FbkgHFrzQUpOoH3Og5yGPYyjs9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/Or4yrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/Or4yrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8471F000E9;
	Thu, 20 Aug 2026 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243724;
	bh=0+JTVqHeKokpDwjLxvnzxZeSBcJjGs6YczBOcsR1JQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/Or4yrIOK7+o1CGuy+3ZLJLnFMsf6EzPmTzaz2qrt3zrjVuSQtRwtikPk6dMSDgH
	 e3e6KLHEANuMGB+hxS7rGmNE/Dxur7VOJXN+voHO9sQAZlmb1kEAoLIUpPTGmIcDJP
	 IN+SjrzYiM37J6arfnI9kL2NE/EH1e1PalG0D3CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/272] serial: 8250_mid: Remove unneeded test for ->setup() presence
Date: Thu, 20 Aug 2026 16:56:17 +0200
Message-ID: <20260820145237.264057048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 324facd1ccb353a213ea2c2785604f2507f79297 ]

All supported platforms by this driver require ->setup() and ->exit().
Remove unneeded test for ->setup() presence.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220215101111.47250-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 7fb13fd7e9a5 ("serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mid.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -319,11 +319,9 @@ static int mid8250_probe(struct pci_dev
 	if (!uart.port.membase)
 		return -ENOMEM;
 
-	if (mid->board->setup) {
-		ret = mid->board->setup(mid, &uart.port);
-		if (ret)
-			return ret;
-	}
+	ret = mid->board->setup(mid, &uart.port);
+	if (ret)
+		return ret;
 
 	ret = mid8250_dma_setup(mid, &uart);
 	if (ret)


