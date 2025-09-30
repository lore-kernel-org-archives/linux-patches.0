Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D1A223DD6;
	Tue, 30 Sep 2025 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245249; cv=none; b=TaM0FTDDPJ4kFa2GaVKlq50cwWvW3hW0WknJZb0WtL+XYHQ2AwiOI82BtjkwWUGMZggadRDZUbsN6DqYenR5wWuvGe60tl57uO/iRGm2CM+Zra1qaqUDasC0y4UOuvidw0D1tnf5sagVzrIqODlADq0sNQI0oDsI99hHyb7DXsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245249; c=relaxed/simple;
	bh=V0BGGr2tWQbhpPYoRgX56TR9wgMOuTHLKhvOe8nmOMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUFURCRo7J2uRlUVVqKbFQZwGCzYYIJR52eKBjn9/HtwGh2cuefXsemWQrmyo7IrRZa+ejdO3nc+TVuCK1m3tOVHt5CbRk/sqo0vEDVJ4ORExZA9p341GG8oZG8g8+3132OZRLv1VnDESW9FY17WmbaEJefNc+XT8l287QLouUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CC7aDxN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CC7aDxN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A09C4CEF0;
	Tue, 30 Sep 2025 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245248;
	bh=V0BGGr2tWQbhpPYoRgX56TR9wgMOuTHLKhvOe8nmOMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CC7aDxN7qHlF6W4wZy0tHiFSun9ZCvzAM9Hl8Phk8XIGC16a78sM9MdzBpTG/Wvaa
	 5KDkNKGz7rrfCRFeSModGCSx7EEP8cg6OE1EuHUEGmAH3BDDvb2MhPGBcVWUjmshEs
	 WIJKATqX+mM4r1P5DZD5rG5q3hP0AkM7EWHeOiBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/151] usb: core: Add 0x prefix to quirks debug output
Date: Tue, 30 Sep 2025 16:47:21 +0200
Message-ID: <20250930143832.028821959@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayi Li <lijiayi@kylinos.cn>

[ Upstream commit 47c428fce0b41b15ab321d8ede871f780ccd038f ]

Use "0x%x" format for quirks debug print to clarify it's a hexadecimal
value. Improves readability and consistency with other hex outputs.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Link: https://lore.kernel.org/r/20250603071045.3243699-1-lijiayi@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 5935ab39bf8d8..f7747524be6dc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -727,7 +727,7 @@ void usb_detect_quirks(struct usb_device *udev)
 	udev->quirks ^= usb_detect_dynamic_quirks(udev);
 
 	if (udev->quirks)
-		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
+		dev_dbg(&udev->dev, "USB quirks for this device: 0x%x\n",
 			udev->quirks);
 
 #ifdef CONFIG_USB_DEFAULT_PERSIST
-- 
2.51.0



