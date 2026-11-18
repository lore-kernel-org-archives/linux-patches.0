Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032364;
	b=S10yxbmLSzT3PW8OAmJzIQon69xSlrSDQAvFG9DrhABIv/IqlX9teHcov1lJpyZqJsrv
	 dWlaayrPEiZQI5S8l+z8LdJnRsvjmmeStkE14lA/+v578uarJ25+cttA8lyLFWF0FJJQg
	 4Z3fk/TgS/CDiVbZ1fv/Pz85tVzyJk7QedfgGAxYJ2mYzdCUKXyDriEY/7bXfWiD1Ym97
	 7QD3ajCbEfkuCQJI5+3zJk53XBu9yQI9ajIWX5a6IJPuO6IMe0NtkC36BrO/W32yX5AF3
	 VxvS2vZzMsQ+MLyQKEutqeOmtcDs2WKeNwVrXvRc3HrcrPZcK7wslEbdltP++fYUjTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LGW/S5dgn8hKrOVltjdEY4MV3wWc7LQKK7fvZEF6LEE=;
	b=0AxF5yWfpTPcwfXYsrJgvMiZWgke/NDF+2r9uNX64QtGYS4XacxbP6poyEwju2wl7GhJ
	 WvNZTNW0xVPZJ8PPW4uR19w5msHU8rXcIhYVMcu9VEJMQ3Ew4PJXzRlUWLR8ci11VuWNw
	 dHwh7IEDNNBYydpMugnBemet3VuIAlcsInBfnaDwA0MhVyRsyl+gEgd7L+saZY/jjiHNK
	 sf1agpKAoUYCFoTJqnoUjuxbCrhCUaXKKDG1sEQ4RpP890jDBhUHhWccTFsX9/VQSW/fN
	 tHgbfJIXhgz/bVBa5O3g0L3yUxLiYAYIJYVP3QEOyrYWuKz73/52mskj4qeBc6sLBGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VGXUM/Dg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDA2606A320;
	Wed, 18 Nov 2026 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VGXUM/Dg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD15A1F000C4;
	Wed, 18 Nov 2026 20:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032364;
	bh=LGW/S5dgn8hKrOVltjdEY4MV3wWc7LQKK7fvZEF6LEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGXUM/DgLmERDgCrbTiOGZjWpt/Bb7SFQ+T3ngj+NbHI1zWsSt/C70WnLoMXM7WY+
	 4nHiv1huwByCDgade6FgGAWyJQ3Y5MbhEQ2NGuzwWz34tJcIwMuhQPfBZE9+f+XBqU
	 TAugAvf1tIPMHHdELYq0VIiioPP7wc8nBjCnrW2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Igor Skalkin <igor.skalkin@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1387/1756] usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
Date: Wed, 18 Nov 2026 15:58:34 +0100
Message-ID: <20261118150104.386952745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index bc0a69c65a83b..2a5641c3b3821 100644
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



