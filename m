Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033835;
	b=y4ntFMleA52MY1Z/DdMVCe226DTsO/7zh7/GfKVpGKGkVFCPtDrO/+10j66BU0j1nGxF
	 QMzNOYE4VP/JhQeHMwb+jfOnEOVCLzeagUrusgDgzQfbHZe3CqarULgU3vKd3WY2Dqgz1
	 OBNRqfPISEOC4uCwwky8ffXOZlMEdCxPAJnxilRs/1FaQQltE/OgyI5co7x1YrfWYfKNp
	 fOD9o7inQQ+DX3t6XHzV1X2Vdurnn4cSod2RkU9RgOsqVtr+3DSlUWE5S+OB3UkBBrPnN
	 Lt2Rzi19v9lluveLYBLqcpqxSI2YVOmjxpPlckz2tZFM2f7XQQ7M5OTmUW50y/90/6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ppGFeM4qqKxy6Nh1rzdCB0fLO3nLl74zikaOOgugVY=;
	b=mFeYINkRt4IILX9vEZeKEQQq9uIuM65MquCAZCxihZmkJaPvqmI2yf89PzdPMjMeMfza
	 OiI1mv18YXwNpLa0s+OzSkASKLus0vVqeBFfObAFe34aYCqSMQw/UZgKQueTg59JBeXqR
	 0dRZhDqnJTQ0EqkkXSLAVTsq+FABJn8VkxrbDfX9FRC8bnv010Twf1hxuAN8aIVKfYivy
	 3c+9furV2ZjVfJFjf/Nwu3Cn8xq3jQK9e4/sS3/CdyyDY5Q20/MdCID3/6POBpu8lW3ol
	 V7tZT6JwWcVZds5P8pn3nrFYc9o5Gl1xHivQJtJ4u8X40cHZyF8ot61iuWQ8oU12EFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pS0DuWOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EFA606A32F;
	Wed, 18 Nov 2026 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pS0DuWOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6151F000C4;
	Wed, 18 Nov 2026 20:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033834;
	bh=8ppGFeM4qqKxy6Nh1rzdCB0fLO3nLl74zikaOOgugVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pS0DuWOvwYyDc0LsfEemQDbF5jked4f58iRR1doSLKRzXOWxMd4jTr5zmEFcDtGuE
	 5h1pv9qyNVC6lVrPIxpC00fNm/BRlkNg57Dfm/bTzWYkqbu6Gv7YCrKTv+S4MDnpTh
	 E5y/Rlc+O/rYYiCE6arl5blSeQrJFJ0oDOrNZzxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0118/3318] usb: musb: host: clear stale RX interrupt on three-strikes error
Date: Wed, 18 Nov 2026 15:12:20 +0100
Message-ID: <20261118150317.854650241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bc45077811679..96fbd7baf8e84 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1774,7 +1774,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		status = -EPIPE;
 
 	} else if (rx_csr & MUSB_RXCSR_H_ERROR) {
-		dev_err(musb->controller, "ep%d RX three-strikes error", epnum);
+		dev_err_ratelimited(musb->controller,
+				    "ep%d RX three-strikes error\n", epnum);
 
 		/*
 		 * The three-strikes error could only happen when the USB
@@ -1788,6 +1789,17 @@ void musb_host_rx(struct musb *musb, u8 epnum)
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



