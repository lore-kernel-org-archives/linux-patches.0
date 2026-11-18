Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020948;
	b=UB2xnsb+IPvdWwsZj7+qpl1kUxypMW7trhsJG8wXn7bdAZRLMZdvJfUHhwTJccDqQCga
	 zTJAdPmJl3rWi6C2GlUNrRC2oRbkFgN8XSEtfh/5rURRfkmqWh/0jNp5GJji0XvRIK+VS
	 HotbmJoPs7b9h8bXcbs0gMvRMfnc17UPMhKkKoR3v7d6yqifDwyVfLyaEXGB7xS2VB3lz
	 TAdT3wmQ1zEWuhQFn+0WQUvDEuwFdmiTl42la2BIf0ex6h8ICn1e5/kAbHmtoMR7RA0UV
	 OwPQAEPS0e1FHnJX6QDzZUVyQoFQ8/S9Ubu1Eaf2Lvh6ZNz8jSxwWrXukQsCQoBfzWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FHnwBJ9WW9rfcOrJRaQYuaKT/weipyVlTxD4OmsK3rA=;
	b=ZkJbEsCfOuK7bVdiZK9FU5kg8v02Ge5Cr5BB1oRDabMPW1jFpIOu0qcBrJ18FvcHu++v
	 rc1ImjL5rsmwB0fwengMPNQhcyYnM3Bn7qoOiWw0Ln5ZXz6b6e28XRGq9gcFUZ8Lgu8LV
	 L0aKzyQd8fwKjjOTQZS+MPGfcBRBaLvC/8veMHRA2JO3RVpQCPkl4TXxdgJKgIHqelv37
	 NVfGcHgDiz5k3YqB0xZnbfAfG4A8BTUTLB3RqcbqZSJHStrAOeHSdWDcH7VoqTWQMt7GU
	 gTTmNcqfTvXZlTiWA2MxRzpu/7vOf1+6uA7QFjH6UzXv0z/8JtlboexOAOpZgf8NsZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQQm9XlF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ADB606A31C;
	Wed, 18 Nov 2026 16:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQQm9XlF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055351F000C4;
	Wed, 18 Nov 2026 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020948;
	bh=FHnwBJ9WW9rfcOrJRaQYuaKT/weipyVlTxD4OmsK3rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQQm9XlFs+pcWHwz9hddkMsA2GaNZBo3w22npgfzhSX1vE37qI4PNNbeCkSkjWXuA
	 yzdBmu8Sl8ABrWDoToLkCyKaV2HFdglzqL41IbCuDUousig/mFZX+Z+3Faj6DsTY9U
	 3/55MXcq/hOOiAkets1p2YUfwx6XpKLOaOaAkNoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Igor Skalkin <igor.skalkin@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2132/2651] usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
Date: Wed, 18 Nov 2026 15:56:12 +0100
Message-ID: <20261118150402.644427388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 0d30dd67b9cad..d3076a429b401 100644
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



