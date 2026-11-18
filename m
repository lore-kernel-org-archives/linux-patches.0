Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061870;
	b=pwaS5kuAuWc2lC9Sw7MxlPobylPHWFrNcJUFemSENtqfYx9G+vKA70skoRzYQMR9dZoI
	 WcYqTM8vB8KB3bZBDtgzyy6vRbeDyt8boaSZhsCECd9u5JI1jICEF7oVNQniUvJLn3fxI
	 O2t+wE+jC5/QZckrNtUFuL3FIlRp0mMZ9q26nRzu9YgNQdJeZBoJhTIUHS9QA9W0eFxgP
	 WpLNrhwIqH8UNEknOy6P/9coMvzDiHwJYK7K5r88z1i8gIIZT53fa2X7PvuCuzomYHpdU
	 EQjN8oxHmrgzT50/lqPFAw8rHtf4aiOphjggdtln/OHlgU7BaLbJ/60IkBGuqd447SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v9gjvuWFjxCBC0M/REKT1jTp8yRMl+q3FY9bgTcj46g=;
	b=n+DXxBWpTmjhZc/GkrdRQE3hylpDSC7NE415kZsSieXFnL78CCfx6vO1JuTTyP9JjrKr
	 3RmkbhYPprhAUAoGhHjPWbhAbFLpzNXQOxBKiYcekvIhAY7zLenDRwnO5DbpMMa2EJtgu
	 o4AUB8sn9l5GffeLb5aDyEmjpn+YQIXbOQxKUYpPvtllfHj0I6fSxiG8VtyzAH1QG2mEh
	 8Kev10H5sc1dq3jRB0Kb7zPOmNQf9MHUyC27aHzMAeWUot5lTK1iwoZmcC4b5altgDQ4+
	 A+J8HLe5smztWMa4dBVS6nqRz+E9XsQ7xJ57N8xvOKaC+MGSARsqkKIdKLvshaSCPyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KC/ypMq4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624E606A336;
	Thu, 19 Nov 2026 04:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KC/ypMq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31B31F000C4;
	Thu, 19 Nov 2026 04:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061869;
	bh=v9gjvuWFjxCBC0M/REKT1jTp8yRMl+q3FY9bgTcj46g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC/ypMq4EHT/54ec0TE7IEX72BKMHc2TsmHQa1ta4eHzL2qoNUnF+V7saaK2Es53u
	 tUqXulhjcx26VCPeD/Gxs1Z6Q6mQFx1l0RTEM820KbC9Bmk4AT2/rGo8e28hZuIJKT
	 SDhjKtZ6MMV5VVdMd2Mu0wtOaZKLGCFbX+OCnHfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Igor Skalkin <igor.skalkin@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1707/1848] usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
Date: Wed, 18 Nov 2026 16:02:25 +0100
Message-ID: <20261118150031.170961029@linuxfoundation.org>
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
index 0a024392571c6..aae61663bebc9 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -912,7 +912,7 @@ static int dummy_set_selfpowered(struct usb_gadget *_gadget, int value)
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



