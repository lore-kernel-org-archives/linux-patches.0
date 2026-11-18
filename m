Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050138;
	b=hFYpzWhj9VUBpU9drXjd1qz7JAKa6GZ9aAl5xpVfgoFVwkblK74HQ+F9R/FD2PZYsh9Q
	 sm87ShwHeV2U+/GVYBlnbvTVQMHEPq30x/AqtdbKc5cJVNRvpdlF4SbaKq+vGvTzdiHaI
	 tL9BHq8Dflmw0B2a/Xl3oKSkmGpTOA+xqmV8v+ITnisUQP1wJduMzv89tEhvMRlKZ92Sy
	 kI4fiKHsGTTtHCsQLlDZXWhwos/1tnNE0Y60sF2aFCsozx+oHD4FGMzr5rZZBGgR0pbQM
	 bc3dhULTf7VhbNPM14pnNZgzGkI4/u/g1H1v7BznIqwc9GkLi/LtVAM3HTNTwL13e0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XMVG0WzKKj/MJpcRGgd7GfhBqKPy4mQB9ic9xEImeRs=;
	b=lPnHv143U/AC6sdotR5nmj3Qoy8JX20gmaLrOF0ns1lXdTWbSoGzPi+4uGqZY2ZgWe+H
	 3hNqSyZg7ga3zcCNNOCPz7j410F9FlcTONWxm9SstEDsWFAfzbfTZzxtDw2RNRziHAtYV
	 2d6WFiYtl521cS2XeYTu2MlshIgPsINFZUcG0g1KAws/pICxhS8HwoVomCgMREwpx8F/C
	 9jtCcoJHzzaKbVGfxvvrwUkbYWB8iqoCnPnjzR1A/MNxEOjxlW5ix8jrmEWI6HdmJO5e5
	 IhCpw9TbT0p/eL5CUCbZaRvRyHUHtFm+3GYqT6vzX51AR7ZMFpcwOfK1GVOquJgeuhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XSOC07vE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC35606A32A;
	Thu, 19 Nov 2026 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XSOC07vE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A41F000C4;
	Thu, 19 Nov 2026 01:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050138;
	bh=XMVG0WzKKj/MJpcRGgd7GfhBqKPy4mQB9ic9xEImeRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XSOC07vE2x6QYxX+z2+xNwJ4rdwCvYvEq70UcBQX2zn0NmlrBVCpkXPXcnysDNWWp
	 ZYg+9F24j0BvqgFft1yFCeggUJj8y+W8LAD7FEiCntfubvbyjDbo+1VgGy3TVgFRE2
	 RMQzSguUXYESKwoBS0Yo7vuhIdSDuiDxsWAYwjA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Igor Skalkin <igor.skalkin@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2601/2857] usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
Date: Wed, 18 Nov 2026 16:00:35 +0100
Message-ID: <20261118150335.190718159@linuxfoundation.org>
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

From: Igor Skalkin <igor.skalkin@oss.qualcomm.com>

[ Upstream commit e68f245bcb1f863aeb8eab617bd06878c078029a ]

For USB_SPEED_SUPER, dummy_hcd sets ep0 maxpacket to 9.
That is incorrect for SuperSpeed ep0 and breaks short packet handling
in control transfer tests.

Set ep0 maxpacket to 512 for SuperSpeed.

Fixes: 1cd8fd2887e1 ("usb: gadget: dummy_hcd: add SuperSpeed support")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Igor Skalkin <igor.skalkin@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812081910.6821-2-igor.skalkin@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index b105de3575438..cb554c831c83f 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -917,7 +917,7 @@ static int dummy_set_selfpowered(struct usb_gadget *_gadget, int value)
 static void dummy_udc_update_ep0(struct dummy *dum)
 {
 	if (dum->gadget.speed == USB_SPEED_SUPER)
-		dum->ep[0].ep.maxpacket = 9;
+		dum->ep[0].ep.maxpacket = 512;
 	else
 		dum->ep[0].ep.maxpacket = 64;
 }
-- 
2.53.0



