Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063997;
	b=o6f6rhpGoP067hNlQvWOWskUjVHUlYWvlole4IQlFjPWTd1lSnkZSWwlqXaTlLyd2BQB
	 WJuG0ddjK0jgG1a2krqJXPZ9K/RiEOKnK1NE/gLREirtWpYzNh0nBb6x8WxVuRh492jwb
	 DwD4W8kA8Yz1na3NQ59eHZpoIkPoetqHXSpjthR+8vG06ZfhYDy6T6fqb1aFBTAp56xZG
	 SbFLIGz+ExobB61t3yQSolbwaOeAJl1yFKgQbCuJLKULEIUSdhXXWu5PVSsGy5/j375bN
	 BvFZ9rPK7TR3KygfhHLFw5g9kUvZU8kjwsj/1BB8+qVVgK78A2odYLUI5hDFkJmr5PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NBiqgvI7ihWNzZ2MrGtJR5ngfR3gPcJIj1zAjTuwqRA=;
	b=Vg61ydzBmfJQPiE1Z+NyLdS6qhUAp0R5BJdyXpV/Swt6av8cXmUWXojg8UrNn4k+mPWo
	 EfBP42D6pHKiZm3zFlyY8NRVcH6H3H9C2/tWGLHwJikMTE090YZ3P2oOXyC32RW383Knp
	 PEAncaU2+7c6n7zcXMOLzZotItPIBxgsgcpIBs6gKsC1X64Y4kTWP+Fb1/Db4RIm3d7ZA
	 sAWbd/Mwqk2vKoCikB4mGHgtZlrQV1/LP92dqDtgswtuMMYezj5kWK/YX2D33IOyIvMhp
	 Fxvi6lu4ejz6AY2NaeY4iQYk377gW2if9awemsx48m6+bKm/UzvI4feGCLJwbLY+sEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JR+e7I0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B993606A332;
	Sat,  7 Nov 2026 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JR+e7I0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DDF1F008A1;
	Sat,  7 Nov 2026 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063997;
	bh=NBiqgvI7ihWNzZ2MrGtJR5ngfR3gPcJIj1zAjTuwqRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JR+e7I0SLfq8d/0dpChM73KPs2m9Nb6aw4G4EIAZt7Ue096B4c/cW/T5AGw9yLV3c
	 fSKu7plZIM4MhnomiwfgqoWVYQoVaLP80HC0z8wLNM/7vKcHp9eA5qHjcAh89ZSGq4
	 BAHXzu5EtVzsUCz2PirGYAxvgRQ1zkeIDDRf8nhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Chao <liuc63@xiaopeng.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0179/1257] usb: fotg210: validate endpoint index in ep0 handlers
Date: Sat,  7 Nov 2026 08:41:15 -0500
Message-ID: <20261107134944.397880865@linuxfoundation.org>
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

From: Liu Chao <liuc63@xiaopeng.com>

[ Upstream commit bbddb219b00af0792242a0ad1dc7fb3344f38733 ]

fotg210_set_feature(), fotg210_clear_feature() and fotg210_get_status()
use wIndex from the USB setup packet to index the fotg210->ep[] array
without verifying that the endpoint number falls below
FOTG210_MAX_NUM_EP (5).  USB_ENDPOINT_NUMBER_MASK is 0x0f, so a
malicious host can issue a setup packet with wIndex 5..15, resulting in
an out-of-bounds array read.  The resulting wild pointer is then
dereferenced in fotg210_set_epnstall() or fotg210_is_epnstall(), which
compute an MMIO register offset from ep->epnum and perform iowrite32
through it.

fotg210_clear_feature() is especially problematic: the out-of-bounds
access occurs at function entry (source-level) regardless of which
USB_RECIP_* case is taken, because the ep pointer is computed before the
switch statement.

Add upper-bound checks on the endpoint number derived from wIndex in
all three functions.  Invalid endpoint numbers in clear_feature now
trigger fotg210_request_error() (STALL) instead of silently falling
through to fotg210_set_cxdone().  Also add the missing le16_to_cpu()
conversion for ctrl->wIndex in fotg210_get_status() to fix a sparse
endianness warning.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260913120458.1608186-1-liuc63@xiaopeng.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/fotg210/fotg210-udc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/fotg210/fotg210-udc.c b/drivers/usb/fotg210/fotg210-udc.c
index d9e024873a429..127a259c8d1ea 100644
--- a/drivers/usb/fotg210/fotg210-udc.c
+++ b/drivers/usb/fotg210/fotg210-udc.c
@@ -661,7 +661,7 @@ static void fotg210_set_feature(struct fotg210_udc *fotg210,
 	case USB_RECIP_ENDPOINT: {
 		u8 epnum;
 		epnum = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
-		if (epnum)
+		if (epnum && epnum < FOTG210_MAX_NUM_EP)
 			fotg210_set_epnstall(fotg210->ep[epnum]);
 		else
 			fotg210_set_cxstall(fotg210);
@@ -677,8 +677,8 @@ static void fotg210_set_feature(struct fotg210_udc *fotg210,
 static void fotg210_clear_feature(struct fotg210_udc *fotg210,
 				struct usb_ctrlrequest *ctrl)
 {
-	struct fotg210_ep *ep =
-		fotg210->ep[ctrl->wIndex & USB_ENDPOINT_NUMBER_MASK];
+	u8 epnum = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
+	struct fotg210_ep *ep;
 
 	switch (ctrl->bRequestType & USB_RECIP_MASK) {
 	case USB_RECIP_DEVICE:
@@ -688,7 +688,12 @@ static void fotg210_clear_feature(struct fotg210_udc *fotg210,
 		fotg210_set_cxdone(fotg210);
 		break;
 	case USB_RECIP_ENDPOINT:
-		if (ctrl->wIndex & USB_ENDPOINT_NUMBER_MASK) {
+		if (epnum >= FOTG210_MAX_NUM_EP) {
+			fotg210_request_error(fotg210);
+			break;
+		}
+		if (epnum) {
+			ep = fotg210->ep[epnum];
 			if (ep->wedged) {
 				fotg210_set_cxdone(fotg210);
 				break;
@@ -744,8 +749,8 @@ static void fotg210_get_status(struct fotg210_udc *fotg210,
 		fotg210->ep0_data = cpu_to_le16(0);
 		break;
 	case USB_RECIP_ENDPOINT:
-		epnum = ctrl->wIndex & USB_ENDPOINT_NUMBER_MASK;
-		if (epnum)
+		epnum = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
+		if (epnum && epnum < FOTG210_MAX_NUM_EP)
 			fotg210->ep0_data =
 				cpu_to_le16(fotg210_is_epnstall(fotg210->ep[epnum])
 					    << USB_ENDPOINT_HALT);
-- 
2.53.0



