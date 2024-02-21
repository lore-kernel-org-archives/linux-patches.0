Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D096EB77;
	Wed, 21 Feb 2024 13:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521475; cv=none; b=YyBbw4Bw1CYFu04AdnFsmJ4h9m3NxuvF/2vv6LQ7aR32HJN7MAM0cwnxi8y15jj69l91yLApra8H2L9N/wG2L5XYqGBuJrvTZg3Inaj669f0AsxpLyPnCOCuWVqj1xlvpSrgK8mvGEpC2jriU7wl3zjn49Be9NgvwyAR3Czg930=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521475; c=relaxed/simple;
	bh=GvwVNsG8Bk87xGXb2jH/QkWckT17KQWSTa9HnK5DRD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQxgDQPvMnAuT+CFyPJBjho/IP7RIQc6ZDSTVhJ1ua6mz0mi+fNdw25LhSxSj1r1w0GkFzN+FSL+ujcWH1lr7sEn93CV7HUU44xs+JDWq4UEBzHsku2/FTQUh3KlDzwFHwF6eMncNuxh3SZBT/AC2HOr2aKyJOzBuvxeNbAKNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zD58i8eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zD58i8eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDBEC433F1;
	Wed, 21 Feb 2024 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521475;
	bh=GvwVNsG8Bk87xGXb2jH/QkWckT17KQWSTa9HnK5DRD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zD58i8eZ6GYITiw6URGI7Ea0rUYq4Sod2M6ccy10fqSjLNm3umgi43UpzoDIUO9cD
	 E/hiDVbnmC46sO7AW4dFVzXmAYXiPQuaDOd+iMdcapF/XdmF5es7wsbJGPd/o6yZmO
	 PfURyFc2FAsGmBO5XEovbEry6vgdtnGOblblzNUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/202] usb: hub: Replace hardcoded quirk value with BIT() macro
Date: Wed, 21 Feb 2024 14:07:03 +0100
Message-ID: <20240221125935.657312757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit 6666ea93d2c422ebeb8039d11e642552da682070 ]

This patch replaces the hardcoded quirk value in the macro with
BIT().

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231205181829.127353-1-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 898df2e43945..b4e970ad1f79 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -43,8 +43,8 @@
 #define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
 #define USB_PRODUCT_TUSB8041_USB3		0x8140
 #define USB_PRODUCT_TUSB8041_USB2		0x8142
-#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
-#define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
+#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	BIT(0)
+#define HUB_QUIRK_DISABLE_AUTOSUSPEND		BIT(1)
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
-- 
2.43.0



