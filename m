Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626307;
	b=PH9P+rcUbuvIYM+ZQCuF8KbYw+jxMU7GVUM96RskZsq4JC0bT0bkIdsfqzlJ/sNTHTJf
	 wRwyEdrhq97XyjR2CsmLsmq/Zfblo9AhtSasRTV8jmnjj1vtUy4sSyP+Tbvjq8ONtZo2i
	 n67TOzi/Bfw4z78+GxhbeOqikr/aFLjSnT9cM2yczg18OGLzOhoymuzr19CGr6iz9GfSN
	 hsp035MUGmI8lmr8wSGBxlsk60pqM6RneoCdpYKC/l3WB6MB4B83kGlDoD5mC7a5xM0XL
	 kvyDU4VKG+DpMGY1o14keESxV+pKlPUHADPOLEuGpqS1obB5a0inE6Odrrhus4aOWPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qHWsgHQBxhTiJNDhN1Go+yEANLAN9i1IupaVezPNrx4=;
	b=eLig64L3fgWEDARpXjrNFuVnTB1Jptx1FIapBPFG5VgvqJbnQSdrigdaMxHeOOE6ObQB
	 CMTPAFRqLD7iN7jRNXwztj29ffNTBJF4YX2SfNP8c4cJSNy2NTMe7daY8xknrsl9kG+uR
	 gSUQ82YJY5RqEn3vWj5i8Q1qJ5yZuJJQVD5MwdDIS3Kd4UZZOiO1O6lFGxUyITP3FeZaZ
	 cih/653Mw6YIOWLiQBjP9slwRqrLpnsKUoIdrT44uT2Rc/4jzW87nOWUMC/fLGiJR/rG8
	 QsY5CWKKUpfATiveuaxflICZ2AV16MVyRiDnc36+mkv2+6KlRgog3dNjM/vMgwANfUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=te+qyjGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F9606A31E;
	Wed, 25 Nov 2026 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=te+qyjGD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDBC1F000C4;
	Wed, 25 Nov 2026 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626307;
	bh=qHWsgHQBxhTiJNDhN1Go+yEANLAN9i1IupaVezPNrx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=te+qyjGDcW6dZrpmvzPmT3D72YnIhwAKhjCzOoBQqp8BcMLe01Nn/RUgGB7VzKsqG
	 mx7yokh+nIQRMRtsvEkS2iU7p2Brpwz2ClF9nFqbIAxBGj2NRaz6pUIVHcPh8H+4YK
	 D+2cIz6f68D7VdM9rNbH0voFaqmVXg7kbkueOxyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 755/816] usb: dwc3: gadget: Reject requests to a disabled endpoint
Date: Wed, 25 Nov 2026 15:38:23 +0100
Message-ID: <20261125143906.649975674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 5eb11b1647b0534b3a61a21473d77ebf4ffbed7c upstream.

__dwc3_gadget_ep_disable() releases the lock while giving back requests,
and DWC3_EP_ENABLED is only cleared afterward. A function driver can
queue a new request in this window, and the driver would start a
transfer on an endpoint that is already disabled in hardware.

Clear DWC3_EP_ENABLED before giving back the requests, and reject
requests queued to an endpoint that is not enabled.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/4ceab6aa5d6af0e4780f9d3a964fd5d8168a0a02.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1074,6 +1074,8 @@ static int __dwc3_gadget_ep_disable(stru
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
+	dep->flags &= ~DWC3_EP_ENABLED;
+
 	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
@@ -1987,7 +1989,8 @@ static int __dwc3_gadget_ep_queue(struct
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
+	if (!(dep->flags & DWC3_EP_ENABLED) || !dep->endpoint.desc ||
+	    !dwc->pullups_connected || !dwc->connected) {
 		dev_dbg(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;


