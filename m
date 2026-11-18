Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058268;
	b=FSFk4+r3C2o3sqMgZDTJHwK9fe7JDAv4nXbChCwbEnMDINYBHFHf3ejJQEcW8wNcEhrL
	 ASPpVB7cfo/4spDBRQ8ZHdaiIZelT7gMUuXr4kVHrIxmVzLV6o0YnIfEp+ttajjs2D0y9
	 ok71w/TZvPTTgZAH85kcT6zOSMww1F5g2BErHQXVhpICWuC6/WJ9oCUU69U7xgxd/dngs
	 MilCZ+9t560MSttypafeq5yavWyUy/+mjE+CNYqH0sSZr82iA1FQhFRx5TbTbSlNONlI7
	 d1ceEHXab3a2iEiSFU68to4WhcH5AKg7957whQNbIJfplqtW8zr6Sk5SBe6AogtCO3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ERri8X6BskqxNEseYjbciMw9EE1XzwWZDsSuL+kQBJI=;
	b=QJagYULjOASuJiYuZjiTzsS0FgL+LKy3H69LoqjMOlQ4rLs48CLDqbwwT7s6FR/ht1K0
	 WANLEoM7rgGJyKbrV9SHiZIga5IIN9wgvTzISY52Ce0dQcexpOtOef5hxfwe2SguGqZnu
	 +Ui0vN+bUi2UKC1+OST1Bc+RZZyTzuGOBAjHWIknJOfjXKlcbpg9B0XhH7OmK568cJcaU
	 qa0w6OrEKqrk3av+DnrnkvyW1xpNeoN9pKX6dmPsReHEHegWLwNei8U37YoOMIFkb+Suk
	 Uwha37GiZdkfcqmO4Hznan/nWBvyK1YJHfBMHBp2lhjwu0BHDbTFWdcn+158+efCOUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yx7DBasg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12630606A325;
	Thu, 19 Nov 2026 03:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yx7DBasg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BAA1F000C4;
	Thu, 19 Nov 2026 03:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058267;
	bh=ERri8X6BskqxNEseYjbciMw9EE1XzwWZDsSuL+kQBJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yx7DBasgq2z2ovh/SlaOz7xl2EagqZBElmQGWOl7ehwEc6vuC4LBQFdXlF/2QcKtK
	 IRhz0nHM2rhtX5mF7dXX958BoL1yWrWI3mNPeleVCGpYwM42UlQUGBp1I4v4qK7IUw
	 fHjPWGS1ndSs2zusQgBLCk1vgt65oCfT//cQl9Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Chao <liuc63@xiaopeng.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0398/1848] usb: fotg210: validate endpoint index in ep0 handlers
Date: Wed, 18 Nov 2026 15:40:36 +0100
Message-ID: <20261118145930.467441398@linuxfoundation.org>
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
index 11712bc896352..766eaa34e5cec 100644
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
@@ -719,8 +724,8 @@ static void fotg210_get_status(struct fotg210_udc *fotg210,
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



