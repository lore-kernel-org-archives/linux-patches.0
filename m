Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057287;
	b=1kdLnnPZBBHD0AoChHFFqRy5/JR95pbfhhE7NwkEC/bUYSADE1qgFlkgWR4WHegtpIO/
	 Ku71bJ7eML8HeXtpHmxB9hqa+Ai4QFwfh0GIKEzkgW520H9VJHTqUiooLZjVYVbcDYr9s
	 K16cbp5rT2+8izgEgty/KRJ4EYMD2wSkPVcC74AGbYH62JdjIX8jQPmU+O5wK7PoJq45d
	 F1/vaC/AqQFpZktIdnBSMX00P2Xa0fI81GmYBc1UdzFsN+d1ZVUU0T8LvwvynCOqFIH1M
	 uVQ8EWoZIay7oSam8cE2EYU2dacqa4J5i8FchhntwJVyzjZ8/Z6BqOwl5iHNXPqEwkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hNvFvQSpd8QXgRG8xaU7tWQE4Ibb19eADLV6WvvFJdA=;
	b=JuanUt+ZvdQgySuSVg7FDEeUhKS7kyTCX6A21CRmiD/h/A3Lvvj7q/8YEcFQ6hMYWERw
	 UqUNGLF8Yxpn0QYIY83Ui3keQ5cKSNHGlzSLCDUHexZFExAa6EOoK27J2fVE8atuMJsen
	 2PxWPJqTknQlAJ6HVUa20JYHkEig2nZMOO9fx3yBFlr3RjHe7mQsdkX88p61PdBcSJeqp
	 SIgg17t0Zn2F/E7ZS+vYUvl05JQtHSP5C7ZrfVGZyQmdaUd8zGYZ0T+mW5rkHHHNiSNm7
	 qlvU1nt83mbH4rOzYwzhJX0trxFFnuGfSAo4CqHmDrswc5NEMjVzjC0cQuPnAB+XqbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IR12jX2o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E7060A262F;
	Thu, 19 Nov 2026 03:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IR12jX2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DBE1F000D0;
	Thu, 19 Nov 2026 03:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057287;
	bh=hNvFvQSpd8QXgRG8xaU7tWQE4Ibb19eADLV6WvvFJdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IR12jX2okgjdtSn2SJoLxpyLKUwslP2zllOrmundSQyVNjYIdGd1i27SCKkTknzOL
	 zM4VYTK2rW/WEuC3Nhp4H1E0+Li+C7sH0qZv0ZBh9ddC2r8eSzZlrbc1wjVyGDvZl8
	 W79kgsP4/Bdfa5RTVQsXrhEzB2B7XGHqBrdHHDV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0077/1848] usb: musb: host: clear stale RX interrupt on three-strikes error
Date: Wed, 18 Nov 2026 15:35:15 +0100
Message-ID: <20261118145914.358762199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Martins Alves <lucas.alves@lumal21.com.br>

[ Upstream commit 3a3a48487344a653f46a4aadc9ba296386eb3541 ]

Unplugging a busy USB Ethernet adapter can leave a stale RX interrupt
pending while the host handles MUSB_RXCSR_H_ERROR. On AM335x/DSPS
platforms this can retrigger the same three-strikes error before the
disconnect path completes, flooding the log and potentially leaving the
host port stuck until reboot.

Clear the pending endpoint RX interrupt when aborting the transfer so
the error storm is broken, and rate limit the error message to avoid
spamming the log while the fault path completes.

Signed-off-by: Lucas Martins Alves <lucas.alves@lumal21.com.br>
Link: https://patch.msgid.link/20260714134941.18508-1-lucas.alves@lumal21.com.br
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_host.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index a89011c946dd2..9148283e2f47b 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1780,7 +1780,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		status = -EPIPE;
 
 	} else if (rx_csr & MUSB_RXCSR_H_ERROR) {
-		dev_err(musb->controller, "ep%d RX three-strikes error", epnum);
+		dev_err_ratelimited(musb->controller,
+				    "ep%d RX three-strikes error\n", epnum);
 
 		/*
 		 * The three-strikes error could only happen when the USB
@@ -1794,6 +1795,17 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		rx_csr &= ~MUSB_RXCSR_H_ERROR;
 		musb_writew(epio, MUSB_RXCSR, rx_csr);
 
+		/*
+		 * Unplugging a USB-Ethernet adapter while it is busy can make
+		 * the controller keep re-asserting the three-strikes error for
+		 * this endpoint before the disconnect is processed. That floods
+		 * the log and can wedge the host port until reboot. Drop the
+		 * stale pending RX interrupt on platforms that support it (e.g.
+		 * AM335x/DSPS) to break the storm; the transfer is still
+		 * aborted below via the fault path.
+		 */
+		musb_platform_clear_ep_rxintr(musb, epnum);
+
 	} else if (rx_csr & MUSB_RXCSR_DATAERROR) {
 
 		if (USB_ENDPOINT_XFER_ISOC != qh->type) {
-- 
2.53.0



