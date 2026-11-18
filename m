Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042025;
	b=zOveESthNC9YqlzvW1KF5nrdkAjNp1gqz162PLXmKIw5e8Fllt76J4YBrc4+fQ5k/OUM
	 cq+X5HmZcNqiONGqBBeguwm10yczeYlPwj4sD9ean4S1r0bNmawF3V5XqcQ/C93cMiOeQ
	 ZwOoypKv43XimrbVVdVCba0uqDkDlweQ90y/DC8iFXxWZVoEFkYaN1qQWcPm21izgx4iv
	 25wUsr63R6fXESWPDe5/b7G34SfN1lbamKP+wZ4WXhrmX9cbhQ8hRcgwsmFd8x0SUdd1V
	 bq9aPJVy3nt78Q3ZACRfEOVBOOo4+qgAFWbAp5WCab9XR5QS5G2i+NQFA+Ol2pfFp0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sc9pcKTHqmRM0kBJKQ9Kxt9PkfW9owTMHL4iRIebMhM=;
	b=xsJ6hNb9s7l/H4CTPAwcjepLUT7V3nAI+fn12NueOZcZFuCesyVMysB3a+/xbqiQMVHO
	 b8CMhDxa0Rq/lg6bBwlff1G46Gc8HadANT7nEW3oT6K2YdklqSTfjdEK0QlkLj4/wWQ6S
	 ediax08PlD/q/WAuHR7rrzh4henyXl69sQvPJQrbAv1TfGitQxlUvw8z/4jknjuvTAGJU
	 4fVKh5/tDQrYq5QMU6pWC2CjiPd5pyUi+mrdlN1D/BA1U8W+7M934Uf8e2MnD7OkFzCKk
	 b/26TsJBuwqEe3bK6eIBGYJZl7Wt7FmKMY6gvjbTn/dO7WA4dguefg/Mge/c3BTLp7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVfOwL9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D1606A320;
	Wed, 18 Nov 2026 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVfOwL9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6474C1F000C5;
	Wed, 18 Nov 2026 22:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042024;
	bh=sc9pcKTHqmRM0kBJKQ9Kxt9PkfW9owTMHL4iRIebMhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVfOwL9tB+wVk13RduVX/YNvyAUEwUovqvMwZ6xPJTOAW3YpKgeIYwaTXlUHAnLuG
	 2V6XMndo0XKO5J7vY/LKmMf04ZlZwEblH5IjgU4O4M+8gUgRwZu2hC1uoKCE645jpi
	 DwD2EyIOBQChktNCy/jN4mwsVUSVjP3XNAkJmQNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Igor Skalkin <igor.skalkin@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3021/3318] usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
Date: Wed, 18 Nov 2026 16:00:43 +0100
Message-ID: <20261118150450.835456399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 26c2a87e9cd7c..b77c868d21fc8 100644
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



