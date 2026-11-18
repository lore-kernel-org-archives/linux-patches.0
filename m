Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027319;
	b=yboHNK4yY/a6vMAit6Y22XcbBkagPt7i8sJeXQk1z8TcHy7r3tFatJgClMBT+gQDwhz4
	 kx5XhABsC5J3taHnm6bo8NlpmJNddgeLsP7RYt/yVGkoGn0vvkx3f2zdXg7+hkDrYWL70
	 8c37NiAWs+fI+fbDjGQx/uun5QyJIgCxjF7YPH70iXBELsWT3+F3SMmhbAWVrt02QlaDc
	 T28ITzEBNVfMNy14ga9MYGbqt8dt7g1IinnEZrl4WzjJ7hTPc1B7WNwMOiLl4QKd7RbAY
	 otMKJjmMYEfdCeqOt0drYkAieW4aYsrkE+4XccDsOkr2L3RYySiBK+ysxh/xWA7gUnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FsdzwxuhRNm39cLr90OF4sBCkk7jrY3Z0DvSH4XzI00=;
	b=nOdzYWRTbiORrxVxLGEkoujlfRdyyPi5EW+HLVUyrzi7wL9aBCOA1i6z7er4WtL6j4rX
	 Y9xBGrIFAj/htpA1h3gLSHhJhNwGdKPO4dlSxjX492Eztb0zi0fjeEx1br/ePcumrLnVn
	 FiWDHQuu8moM3WtFryisr/Bogj6st4+40LwkjOuoGt/35ulxS+9pXUUH1MoeGXEVEFMpl
	 X6pSO4wZUBI/C+UeO6w9DZzjUDDSuSnLGhcrbTUmtjKpsORXWMYo3O6D+rLNdS+7r1tre
	 Ynlu8beo35R7LyI/wsVytPdVdbobw7jxtDojhqdVRptcBYGru+vAAY+0Hdq3wxfhnhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTbMI8mi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A24E606A33E;
	Wed, 18 Nov 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTbMI8mi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3D81F000C4;
	Wed, 18 Nov 2026 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027319;
	bh=FsdzwxuhRNm39cLr90OF4sBCkk7jrY3Z0DvSH4XzI00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTbMI8mioaiTg98PPzgd2pRbMZi9Q5nTIFeMqbEuG+yPaYrAkjDozv9F74DTkg32C
	 tW/K5x+1NMGz5wz9Ygnst8Apf3w+FSYh9MlyH/nErq+YLoaKXWdsg85jA+VYyHfIhV
	 qFYpcSP9IQbySeBfI2qf4S6WC9medlcqRqQg+oGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Igor Skalkin <igor.skalkin@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1748/2151] usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
Date: Wed, 18 Nov 2026 15:58:03 +0100
Message-ID: <20261118150225.529901764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1d4df43f0f8c2..41643b19d90a8 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -918,7 +918,7 @@ static int dummy_set_selfpowered(struct usb_gadget *_gadget, int value)
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



