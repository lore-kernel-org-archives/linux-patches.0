Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620605;
	b=gVpskbTBB7oyyxJLZsd2rnrlFE1denlL9sK0/y7Y7nzyAuFXKbVE8bGLtE6DoZl9ydYr
	 vmmnMu0xWsb2dk9fIkDDswVDEJX0RFX3POU4v11ZJGU5zxTK7CZBd4a3OZYjHm9+BHjKF
	 A5yOtcGBYAMofhKqCHY9o/83BYK8GdQ7RRxo+S1gEjsBkqAnMTYDbGMpI8q/U9WgUCepH
	 dusDXQIE21hrp64wmUgaozaTYncVUv4FFw9a66ZSCjleMXKPIlEaK/TitCp2iz2I6K4qU
	 DPl15UVbMOYNoF5hoKa1uENC6HLj+ED9U9SI5+9nrCmUdOEIRJlroZ+PevOqRgOOV6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzlJrVnxqAEQYiWjjxtL2q7eYXvQTJ5ZTT0C3M2nuaI=;
	b=LbPYNTKB6S2hu9MapQDepG2TX14sBgfDXSg3kLWhMgL+nCVcZIg655TwBkWsHOU95b6o
	 SJWtfR65iNxa8/eNT3E1xZ0D9SMoQIYONw1uJFs/K0JrlBYh4xJhfxqkkVVy/8IkRWRR0
	 ZxFnL8iqMhVHvvUrpTLIcnESo/QsJyOpOgimK3EXoKuwtOvLEB8r9yjgUkDfjsndikq6j
	 qxo3vuqcdxVDHadwI9vxrqFQVOGF7b/BgUEhhv8ajEtfp4h7o50Kp8PGfyHdUs5S+CZWl
	 CXGGfacPHOGSMQSOibJxjaA7WTkNX65vJcDcx2nSJ/VzbWEAbleKKY32b/mbrAvC1KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0pktoi1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A89606A323;
	Wed, 25 Nov 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0pktoi1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D499B1F000C4;
	Wed, 25 Nov 2026 15:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620605;
	bh=QzlJrVnxqAEQYiWjjxtL2q7eYXvQTJ5ZTT0C3M2nuaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0pktoi1SxXpLFaV/b1dHzTl02GsyuV0FFt8r+60C7YxBnbnqOGr7hp00tVCOy6I6
	 rAzhRh/SyAWfnkzibPuKUAxLaFk8u5RzTOvup7dmBmlrjJNfDo8etLrQ1O+dj37vEs
	 eDV9lkKYLXw6pQeaDpe4AE2LXUAs5zvmd6+nVN3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.3 0936/1005] usb: dwc3: gadget: Reject requests to a disabled endpoint
Date: Wed, 25 Nov 2026 15:37:54 +0100
Message-ID: <20261125143843.609778597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -1087,6 +1087,8 @@ static int __dwc3_gadget_ep_disable(stru
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc, DWC3_DALEPENA, reg);
 
+	dep->flags &= ~DWC3_EP_ENABLED;
+
 	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
@@ -1998,7 +2000,8 @@ static int __dwc3_gadget_ep_queue(struct
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
+	if (!(dep->flags & DWC3_EP_ENABLED) || !dep->endpoint.desc ||
+	    !dwc->pullups_connected || !dwc->connected) {
 		dev_dbg(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;


