Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064878;
	b=Qop10RhQTpQ5+/GYuyiSAxOaVDrV33Pj9Jl6uq26qWIzyCCCANX7rcuLMkkeWdfGKZS5
	 Ed7/QkS0N+rAoKxOwTsc1xtIkSoECKF3uSQvw7DwQXPY/u27O1bDNYuqEiRWxoowHfKDk
	 w24xu4b8dmblkWgaiTiKzMRyEAbabW94VIjwkMrMgvqTUIi7HqmOfNMS3iHhFidzTFYPi
	 mR+iZ1JoL+/JrF30l2H+irBeonZ9+ddXmNA9z6fjUiwszS6QD2ydX89fXJOoYRYyBQyNg
	 RRbcGfnRv0FATXNiE5rj3sV535GOL61+e8ejqyDsXKohbPl2s7eZLKAvXxhS2/owbCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cwqWYRasLFeEJOljOZVtXpETlhvtZsTvPgQxUBj8Bps=;
	b=pHahiNNT1WogRcF/fuWIcFPbueA2KgVGFOEAirGSdwiTB8Dp070JawCY+vu3/DNsfP20
	 hAU4yTZW/ut2uEW2CHF1y330XrCDxd9CHfe88IQBf6V+RSTOspsBtEBhmmE2ER4cWPeGo
	 0yNBcPw7DGSw60sVF6JXFH/B+AGIHLX1JDfNQye1/eWFnCRQgnu+oJLx4TwZBNMRacx52
	 6xhfcXUpOj740d/V3FxxlYdVSfl6i3co+xQ/LNLnS5oknWsJwdR6DLlx2Ipy5lAZFoFEN
	 8xpiuU1nGdyH4o10iWv5n5Qwx19W4Iz1M2wUD4R/Sxr+14CCHUemcf+1qswXhQG+fGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NX0YCOXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5344F606A9DB;
	Sat,  7 Nov 2026 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NX0YCOXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F391A1F0089F;
	Sat,  7 Nov 2026 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064878;
	bh=cwqWYRasLFeEJOljOZVtXpETlhvtZsTvPgQxUBj8Bps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NX0YCOXrTETF2p9EIwyzalP6rV2+J00Y8NN+S8rVp7Qesm0Dw0cb3uoIs2Ji2jReq
	 yKkCTB7FhsPV61tto2WLvle7O/EdLOg2j8ozWsGm7F/ih/r/XvT/nd+4eOkKrdEIl0
	 XL2P/WdFsfmt7tZFrbdaSun5ANO7wz/ViaAWicFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ferry Toth <ftoth@exalondelft.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0754/1257] Revert "serial: 8250_port: Drop duplicate NULL check"
Date: Sat,  7 Nov 2026 08:50:50 -0500
Message-ID: <20261107135000.114051946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ferry Toth <ftoth@exalondelft.nl>

[ Upstream commit 6ae994d513a6ace5462137e1025a4e7086b87348 ]

This reverts commit 7885af04df6e4efd72910200c1bfc079d61202e4.

Commit 7885af04df6e ("serial: 8250_port: Drop duplicate NULL check")
added `up->dma = NULL;` to serial8250_release_dma(), with the stated
intent of making sure DMA would not be used again after release.

However, up->dma is assigned once at probe time.  serial8250_do_startup()
only calls serial8250_request_dma() when up->dma is non-NULL, so after
the first close the pointer stays NULL and DMA is never re-acquired.

On Intel Tangier (Edison) with HSU DMA this causes a regression: the
first port open uses TX DMA, the second and later opens transmit in PIO
mode, producing 64-byte FIFO bursts with ~50us gaps between them.

Fixes: 7885af04df6e ("serial: 8250_port: Drop duplicate NULL check")
Cc: stable@kernel.org
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20261010193755.187706-2-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index b01baff71f60e..c961b969021ec 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2428,8 +2428,8 @@ void serial8250_do_shutdown(struct uart_port *port)
 
 	synchronize_irq(port->irq);
 
-	serial8250_release_dma(up);
-	up->dma = NULL;
+	if (up->dma)
+		serial8250_release_dma(up);
 
 	scoped_guard(uart_port_lock_irqsave, port) {
 		if (port->flags & UPF_FOURPORT) {
-- 
2.53.0



