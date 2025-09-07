Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5A817BB21;
	Sun,  7 Sep 2025 20:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276940; cv=none; b=brwRhxqyxdyyvYsdu7rHIZC3LwJI6Agl2HTDO14QbG91Mt/MJU55mh/n3niMP9txRniKPgyGrsX6f/3Catl9gVDRBnP6pCtUg0ghPbTrTtXiPOISgeYrO57ODnzMyg2R5izD6Tt34fV2uxCi5dtxFQuyEAQJVFgzTJVtTKYjeTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276940; c=relaxed/simple;
	bh=k7ypZ0gyoi6eDdBgqMnUgHBgVEyDD9T153SabqbwiLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igg1UwZsbxNRjeIhUIW0u+q6ybntEuMRbY30jWqePYdWufWmVnVkQ6ArHSSeyrWXwNRUs7a9VomZZnUUl22trpBRSfZ0FiXIcdD2Za34pCckDRW21P/mtysXKfU2fp3H9wtt3JUugdDAtCqre/Flx4jOVJME9bF/P3c7Kz78pmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKo+V4o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKo+V4o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA28C4CEF0;
	Sun,  7 Sep 2025 20:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276940;
	bh=k7ypZ0gyoi6eDdBgqMnUgHBgVEyDD9T153SabqbwiLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKo+V4o/1cckF6FWN+l+x0VxrJEU1oEC9HrKq9hhnubgYh6ZGmz3IPe70QrEMH+39
	 3ycJOavgJKnvxRa4Vx29M0In9wRFR0ex49MMEIOOrLCsBO1ORHJ6fY2t8vG/c6Vn/9
	 EQp0VGlfes/UDszie8X6wTURTRBFSkqioTXuy/+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/175] cdc_ncm: Flag Intel OEM version of Fibocom L850-GL as WWAN
Date: Sun,  7 Sep 2025 21:56:44 +0200
Message-ID: <20250907195615.111977936@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 4a73a36cb704813f588af13d9842d0ba5a185758 ]

This lets NetworkManager/ModemManager know that this is a modem and
needs to be connected first.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://patch.msgid.link/20250814154214.250103-1-lkundrak@v3.sk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 4abfdfcf0e289..5c89e03f93d61 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2088,6 +2088,13 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
+	/* Intel modem (label from OEM reads Fibocom L850-GL) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x8087, 0x095a,
+		USB_CLASS_COMM,
+		USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&wwan_info,
+	},
+
 	/* DisplayLink docking stations */
 	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
 		| USB_DEVICE_ID_MATCH_VENDOR,
-- 
2.50.1



