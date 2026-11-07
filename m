Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065002;
	b=sCHd6hlTWbHt6py5p6dwg0NyJYxfGR9uKZZEm/baRr2YktvHuMgnDl+/9QSB77A6AXi3
	 GIp1GPa5V61m0M5UGwlnJ47oZmEu7G3SQXf6wYMHP8DiCGKEiFSJdFxQMLkQgIVouzkY1
	 rKEJRF7Zcy2QSlih5wnocWlzW4DEeHQjH0ci7lFmkVgyEKiufERqXpy2XEEo0O9nUtrO3
	 NiQH10U354gRrn6j755JIrGqETwp0uIqSGeZCA4H/rcWnGLw0rJF1oaR/QMYQgfM/RGem
	 hRtUQjJbh6o/IvXJFrIB0Rg0uw+gLGPcrFNz9CeMSCb282hsmxdlbtwXLLoFWTJ/kQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nRljaqg3h8DjFhr2QB5xmwXID3cZlsLoQ7rerWWdiD0=;
	b=wqHH4hi6LteADWCclMWAWBIDCNM3AaPBUzd+4TUy0uvozDMgpASySYZMXkxuPR3lur2K
	 xttv/tVCuRVDBFIdh7SIxAG/WOK+Fo7U/HKxDmth9zLOO0/u6WDGrr+01K4O4WvTV5En0
	 Tvn7ttoOMOkQ+WkLTw/lECxqM6WcGJsM1PBEIFzxPkEI+mUmu4M8zuu+Smpsmgj/buEz/
	 ueWgnO3FBy5R3kj6+7skLN0UvpLkZrPY2yH5QR0gH9iMHBpwY4nkpBdY3SLDGebtZJmhf
	 h2ikE9HPRo/8Pd8zondJrYxE4++GXBLdK42D3+AQDsXBtMcu8xSvWWqDyzKfD8oFq+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKdEsPCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438FC606A333;
	Sat,  7 Nov 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKdEsPCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C8F1F0089F;
	Sat,  7 Nov 2026 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065002;
	bh=nRljaqg3h8DjFhr2QB5xmwXID3cZlsLoQ7rerWWdiD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKdEsPCI/ZDdDmtNd7RPG5mdwgZtZ/xpnXZB1+w0ZSQMPZBVklDVEJwzvZPIfzRnc
	 xDvNf+pVprijNPyrTLpznlGMz2PmGRBdFPV7nxkKXeSHQ707a5MRXyLKEGuWc0LCzZ
	 uKaLmAWBgBPK5Nxf1HTUMaJgt90xJ1ezpi973/Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0870/1257] spi: ch341: handle transfers without a TX or RX buffer
Date: Sat,  7 Nov 2026 08:52:46 -0500
Message-ID: <20261107135003.353945882@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 84182c48999f856c3865e4a537c244f9569c9f6c ]

ch341_transfer_one() unconditionally copies from trans->tx_buf into the
TX packet and hands trans->rx_buf to usb_bulk_msg() for the readback.

The SPI core allows half-duplex transfers where either of the buffers
is NULL, so a transfer without TX data crashes the kernel on the memcpy
and a transfer without RX data makes usb_bulk_msg() store the received
data at address 0.

The CH341A clocks data in both directions on every transfer; there is
no mode to disable a direction. Set SPI_CONTROLLER_MUST_TX and
SPI_CONTROLLER_MUST_RX so the SPI core fills in dummy buffers for
half-duplex transfers.

Fixes: 8846739f52af ("spi: add ch341a usb2spi driver")
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261013054339.77477-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ch341.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-ch341.c b/drivers/spi/spi-ch341.c
index 6448a44a8b67e..56a5caa5975a4 100644
--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -189,6 +189,12 @@ static int ch341_probe(struct usb_interface *intf,
 	ctrl->transfer_one = ch341_transfer_one;
 	ctrl->set_cs = ch341_set_cs;
 	ctrl->auto_runtime_pm = false;
+	/*
+	 * The CH341A SPI_STREAM command clocks data in both directions on
+	 * every transfer, so the driver always needs a TX and an RX buffer;
+	 * let the SPI core supply dummy buffers for half-duplex transfers.
+	 */
+	ctrl->flags = SPI_CONTROLLER_MUST_TX | SPI_CONTROLLER_MUST_RX;
 
 	usb_set_intfdata(intf, ch341);
 
-- 
2.53.0



