Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7614E3DFC7E;
	Tue, 31 Mar 2026 16:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976282; cv=none; b=mCf8KwAtBws6c5aGChSys2YTxJC67utT/MVBiSdqVv/F7+RACX5qZT9NTxQcRPrsB44w9IkJrDk9Vp5POmKU3lQcaCyH1JXCHir9tVsUOKRCHOmKSeWqLp0ByFSBFVEwUc3cNVIjibppJk+UKBGac6msZOq8+osWRr1gdFoQInw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976282; c=relaxed/simple;
	bh=2A2OINQZcyxqVLQC8WSkuzinOjzB8YsIjbwLvtvoBzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bcgn1XMQ+kypAgujo+ReC1TvXaIt9iUIFRIIeTI9lZfUCNJw2OUDGZrfqVqJvMgn8nTrvNqqQDC9yRv9qWGibBQnJwS5RAynaY/iMEn+2MbMWgA7DPdD3fX2xAmkuyIMf59UJ48g+eMq5XSmKUTvNVM+cidic/NMXOoCpBA0VZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWlu+psw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWlu+psw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBA9C19423;
	Tue, 31 Mar 2026 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976282;
	bh=2A2OINQZcyxqVLQC8WSkuzinOjzB8YsIjbwLvtvoBzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWlu+psw5AVtNwJzqKlrahm5tgGo5+B94lFXhBT3CFR3qO7+UNiZgnaQtaqmdpcBY
	 EIMpU1M9qvv39+SrY3DjKuwVJMYukb+qTgLiSQyjICdlLI235qkcYPdc3YU3EzAoUe
	 Zvy13Q6EMF2iWyB4d2cHPyvIWyHdWWsyQNWOqV+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Spreckels <valentin@spreckels.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/309] net: usb: r8152: add TRENDnet TUC-ET2G
Date: Tue, 31 Mar 2026 18:18:56 +0200
Message-ID: <20260331161754.700753093@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Spreckels <valentin@spreckels.dev>

[ Upstream commit 15fba71533bcdfaa8eeba69a5a5a2927afdf664a ]

The TRENDnet TUC-ET2G is a RTL8156 based usb ethernet adapter. Add its
vendor and product IDs.

Signed-off-by: Valentin Spreckels <valentin@spreckels.dev>
Link: https://patch.msgid.link/20260226195409.7891-2-valentin@spreckels.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c   | 1 +
 include/linux/usb/r8152.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index da8de7b1a4891..357f5c733d0b5 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10061,6 +10061,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_DLINK,   0xb301) },
 	{ USB_DEVICE(VENDOR_ID_DELL,    0xb097) },
 	{ USB_DEVICE(VENDOR_ID_ASUS,    0x1976) },
+	{ USB_DEVICE(VENDOR_ID_TRENDNET, 0xe02b) },
 	{}
 };
 
diff --git a/include/linux/usb/r8152.h b/include/linux/usb/r8152.h
index 2ca60828f28bb..1502b2a355f98 100644
--- a/include/linux/usb/r8152.h
+++ b/include/linux/usb/r8152.h
@@ -32,6 +32,7 @@
 #define VENDOR_ID_DLINK			0x2001
 #define VENDOR_ID_DELL			0x413c
 #define VENDOR_ID_ASUS			0x0b05
+#define VENDOR_ID_TRENDNET		0x20f4
 
 #if IS_REACHABLE(CONFIG_USB_RTL8152)
 extern u8 rtl8152_get_version(struct usb_interface *intf);
-- 
2.51.0



