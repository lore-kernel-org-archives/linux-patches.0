Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F494217F55;
	Tue, 30 Sep 2025 15:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245419; cv=none; b=EhiaO2G39Ij4AyEyTYkxIJETFy2J/9K/mke2yk+hdY7TQI/oQwnLsaDT8ukiaqqUjvnoTzwYpTlld+fpoiHlptH6hwLgfBAlHV3TCQh2S2x35CNTQC+1jJweIcKF7h1Wx3uB2VijHh+A9BzUcpIeN4IicDF69bJ87RuYDH3KueY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245419; c=relaxed/simple;
	bh=PSdJ6WZujNv9Buh3RZx+DZTkrqxU7OKOVDqV15dT2v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hX4rqStyHtXwGxEJQrdRk/+Jlw5RiOE7S23qnKmuXYs8KGGSuS4Cx/k22oeX9T6LeMxMlnv1pEaNtZvKIn0cePZz4NAqppTx4EGVcq7gf/BUTj/GuWAuzST3bKDIRxSgCWOXoprB0gjJsGARcnlhNEyTaa6ul1pag4kNcEhM9lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GViYTUBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GViYTUBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170C0C4CEF0;
	Tue, 30 Sep 2025 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245419;
	bh=PSdJ6WZujNv9Buh3RZx+DZTkrqxU7OKOVDqV15dT2v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GViYTUBKFUrylOWs2v2R5pk3lGQLVhJ5+zEMxBn8szTTx8tMjCPf4p3xmYvlKHpcx
	 6nuNV61VPwiK+h9frMrpBq18CZkW4N1jC3r2QTJ0vqwxAqu58X8yMLcukgxliBknnB
	 Rriqsv7adaCx2mWPtq32uQ7+poRLPpIknsY5QYFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/73] usb: core: Add 0x prefix to quirks debug output
Date: Tue, 30 Sep 2025 16:47:17 +0200
Message-ID: <20250930143821.110469895@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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
index bfd97cad8aa4d..c0fd8ab3fe8fc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -734,7 +734,7 @@ void usb_detect_quirks(struct usb_device *udev)
 	udev->quirks ^= usb_detect_dynamic_quirks(udev);
 
 	if (udev->quirks)
-		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
+		dev_dbg(&udev->dev, "USB quirks for this device: 0x%x\n",
 			udev->quirks);
 
 #ifdef CONFIG_USB_DEFAULT_PERSIST
-- 
2.51.0



