Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045021;
	b=etHYFCfq43/mVXjCmiEHbecixGa+0rCbMzms3oA63kwHuWhbvdGndVux0ewnqHi00VuV
	 shJdbUtMyidDG1Z0iW+aLqLDJ/BqLzovNbnD3ODxMs5NPo10KAHCiECefB+HErf0l5usk
	 KNrzx6bbE6qD9lZLpVlqAGMc1y/8xTloNEzUYuiYXvsDS+OwiB0DlFBVX19+86ihJsx8n
	 Jyb8EayAXv+bY3x7mQurSR6gXLml1/xj7SYvkX/4PcCNF4ox2yu1e0IE5Obf9cM09I/C0
	 pg9xJkRzPtgcV6VZjQ9EDQ9s+iZQHgd8ZGr8ZQOAORwT0DypfVpnxc33RWxSMb1eG9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=808O/rAqmF1oH3r9mE1ve6xH3LkWaKAlGXRfW30kZPc=;
	b=OKbo9HmHB36Y3ta06ULCmiape22DIoGryZAXB6RKLZcWWQ637l9XNT37zfcJz81EV6Bl
	 Na9cGgLtZWE21wspXVGrX9iZZspgmm09RqbSzb1Fb8LRuwNW/jzND4v3emL1hFUBQCnp6
	 ppjaGoYCS9qb+/rYM9wfFrSNXH+IxyroNWyvhDJaA/YwvQ1eJIZFMbXGAZ+OcCgN0+AAU
	 VO0P+SfTVNg62XnABf/nJo+4q0WdWxTuwSaKY5le798mu6n0F9j2YOZadKDKJgYepu2z2
	 KK3T2NptcEZJIjPjxHaJpJsAeSouhpwlfY9swUSFg23jWdaY1zsnZ+CTiOnFmQ6JyOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ib3hF/9Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD4606A325;
	Wed, 18 Nov 2026 23:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ib3hF/9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2F21F000C4;
	Wed, 18 Nov 2026 23:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045021;
	bh=808O/rAqmF1oH3r9mE1ve6xH3LkWaKAlGXRfW30kZPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ib3hF/9YTAKLRbxHJRhqJqHw93IgEnzH8jG2VVfj9TPriXFLZZWfMzx0qqxZJ8e7x
	 6+gqjepwE0TjkTzT4+h465JKqhBXR30VCBdcneLMyiBG5ViGtoUJWtt335qZp+JJI+
	 qtCfgrDm/7SFdb6m543rMKh9+4Q0TS6eFfwmYqzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Chao <liuc63@xiaopeng.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0773/2857] usb: fotg210: validate endpoint index in ep0 handlers
Date: Wed, 18 Nov 2026 15:30:07 +0100
Message-ID: <20261118150229.405275921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/gadget/udc/fotg210-udc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 3350b7776086a..fc57ba4313eaa 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -650,7 +650,7 @@ static void fotg210_set_feature(struct fotg210_udc *fotg210,
 	case USB_RECIP_ENDPOINT: {
 		u8 epnum;
 		epnum = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
-		if (epnum)
+		if (epnum && epnum < FOTG210_MAX_NUM_EP)
 			fotg210_set_epnstall(fotg210->ep[epnum]);
 		else
 			fotg210_set_cxstall(fotg210);
@@ -666,8 +666,8 @@ static void fotg210_set_feature(struct fotg210_udc *fotg210,
 static void fotg210_clear_feature(struct fotg210_udc *fotg210,
 				struct usb_ctrlrequest *ctrl)
 {
-	struct fotg210_ep *ep =
-		fotg210->ep[ctrl->wIndex & USB_ENDPOINT_NUMBER_MASK];
+	u8 epnum = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
+	struct fotg210_ep *ep;
 
 	switch (ctrl->bRequestType & USB_RECIP_MASK) {
 	case USB_RECIP_DEVICE:
@@ -677,7 +677,12 @@ static void fotg210_clear_feature(struct fotg210_udc *fotg210,
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
@@ -733,8 +738,8 @@ static void fotg210_get_status(struct fotg210_udc *fotg210,
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



