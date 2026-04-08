Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E013F3D8138;
	Wed,  8 Apr 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671641; cv=none; b=QGRUGBRy/9RrBoq+S9s34kbb5i3WFz/fK5J58O+g4JoBEebNtDC0bv9MK+zCZo93hceukG+qlzDSFNRKSY25udSX3dyCNfO2D/JRVrttHM7FkPC0K0LZuan0aS60fUkbvo8+EQBLMzLD7FpKwDvtxS6Z7oKyHA0fV/2AzELd7/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671641; c=relaxed/simple;
	bh=umcnWs3TIEcVBS+NSoJ66o1N3z4bbYtBTbjfWjH6mEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deBLQMYuFc0fVPmJfgwDyi7tqGc9loCwjFMemy9S9+4XcHLCqG/FhUdVMYsrEoloHfry2pS6BTlKyG46CN8euwVqYxvKW420tMmKMObJEe8+p9R7FtVgAt+1bDVPIkeIslfG+c6Kk7vkbnfoPWoKf0hkINGZ9wFhM2YGR2xTAMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpSFsE4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpSFsE4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B2BC19421;
	Wed,  8 Apr 2026 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671640;
	bh=umcnWs3TIEcVBS+NSoJ66o1N3z4bbYtBTbjfWjH6mEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpSFsE4IyG8YwJ0sTutY1gY03rijmXAbewR53cU0eQ5zxRlxGnS1exe7uYbm4XJxw
	 Uia3PWl1SG9ooMtQfU+KmlWwTbPt24bnno1xnmlqw223noTRGWljz0JEnoBFioZqxP
	 R0z70AhrxmvOVjEaQclhm6N4vOiSOirE/LvUpS3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Spreckels <valentin@spreckels.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/312] net: usb: r8152: add TRENDnet TUC-ET2G
Date: Wed,  8 Apr 2026 19:58:49 +0200
Message-ID: <20260408175934.187606738@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fef3e3fd26e6b..15979cd7d15ae 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9884,6 +9884,7 @@ static const struct usb_device_id rtl8152_table[] = {
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



