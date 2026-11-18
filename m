Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056569;
	b=IvlSy+3srnk0BVQF0wMKkvvgjKnNH3lx/sLce2REMHdMBvSkScB6wbrn6bOWQ6Z4+g/y
	 4fiBLOI0LnSIiSp6ooN4k/RmlkNET5ApbJnUQo18qhLYBpAl6SDu04TeRpkhiqPX5KFtZ
	 wPEIb17p3u9AXw+r2lErPo1aCABl8UYAKpor37hnj/CFLehbDzqHz2fL4YdEFOTlBUFMI
	 +gF7JTZGSt2ykUKD0TUMoZPD7SThk2FyBkGGmet5BZzt0CSYRHYkAoN69/+YBw2m56a85
	 G+bGHVoWQ+6qz007EbNhCoZoxFXQr0JAWVRwptiDVNfVzjd3s5wCvwBmvJx0J/qnhWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Beod3u3NLU3kjMQcqsL/jmjoKM1xvleL4E00RIEAQTc=;
	b=O+xx/YeX8j553wodQBT4cZud2ky9siE4rLl60LkRlwHAf0mQyHq6rt563Dh9G9pgTKEd
	 iPoKhqyvlg/lst2I39/vYRTKeetzRwNYYYhBEK5gOjy9Azvfv5o3/xIU0npFKj2R7BZ+f
	 LabKTS3WMYnvobYB4rW+6EYVONzLBuHHpqY3+8VwlCCpb85SvmUsus5XrtV/LmSb6p3fU
	 hDUobK52Q5Kc7LSggKKouiA36oYKk5qGaNmrdKJbUbnGIAf2VH6foYOV1I3BBUgOAOn0N
	 YJ1KSL/zYGL19kgJKQuAjbM4SKTGIlG78yWNyfTwTTYbvlYdew8F74pM2r0jzftzVRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGifOeMD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23608606A32C;
	Thu, 19 Nov 2026 02:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGifOeMD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795E41F000C4;
	Thu, 19 Nov 2026 02:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056569;
	bh=Beod3u3NLU3kjMQcqsL/jmjoKM1xvleL4E00RIEAQTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGifOeMDNpbE4PezxiTUGMxfDr5fAuAc/kV/pbAiB1YG0xwUAw1/pEEqGv0H6JiPg
	 jf/DeM4pbDuC6ySyhRHBpF1Drbuejs1J5Q8diuzYGKnuwrZpZMoUdjkj+R6F5DIIn/
	 J6Rg6xwL5TRNr/ZTmB2wzup9qhb3YTvEzIdHBSBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Igor Skalkin <igor.skalkin@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2032/2214] usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
Date: Wed, 18 Nov 2026 16:01:48 +0100
Message-ID: <20261118150132.041639875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 37e50ec6ad737..134ce1bb25372 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -914,7 +914,7 @@ static int dummy_set_selfpowered(struct usb_gadget *_gadget, int value)
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



