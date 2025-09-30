Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBC0303A05;
	Tue, 30 Sep 2025 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244419; cv=none; b=Y5hao6WStfoqdTs9SyKnypQvdr7kBrK9bNG/u8u3qox/Nt20YPcunmIaMDM2EtvcNfoBypMi9TdCBgYomLEfqhgRxVbG5EU5xQJKJuSbbQN6CJ+uCY1dY8cnl51/5aka3ghoXq2OUV27urvtr63Ualfc/Q30TG5UvKjmr05LPBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244419; c=relaxed/simple;
	bh=5hYtZLI/8QOs/6O6w+/OPvA2THcW7qU8eJLl9rocw1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIlLlvUSGji4ca7USzwA8p9U7zlkxRKzWVg7CkAacmOjUBt7p6tWuQUU4AaZEsKKMtf1+j6v536huUWJ8hlXCxoKKTo63Wq5XX+lBt+mFWoSLOqZn/qFFbP8cL5PUcQonft9y1ofeT7jlDe8aUnEqWFVSY0H0WPvMtAcgvhIaqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYcBRCbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYcBRCbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDEDC4CEF0;
	Tue, 30 Sep 2025 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244418;
	bh=5hYtZLI/8QOs/6O6w+/OPvA2THcW7qU8eJLl9rocw1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYcBRCbZdEQDRPg08foyrQd+E3qW8UIUYTN+zxVpEXOEUY5yFA9So6NMsxQ8ox5qD
	 7E4d54z8q47olQbqs2CfLP8kILr40U4AuHCrC5xazdglNtSuo39Mo3AidD5fOv3urK
	 nO+A1h3WMBjVD9EGmR73AJwT6eEnZCwONRIfsHoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/122] usb: core: Add 0x prefix to quirks debug output
Date: Tue, 30 Sep 2025 16:47:03 +0200
Message-ID: <20250930143826.764190381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f5894cb166867..55efefc5d702a 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -728,7 +728,7 @@ void usb_detect_quirks(struct usb_device *udev)
 	udev->quirks ^= usb_detect_dynamic_quirks(udev);
 
 	if (udev->quirks)
-		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
+		dev_dbg(&udev->dev, "USB quirks for this device: 0x%x\n",
 			udev->quirks);
 
 #ifdef CONFIG_USB_DEFAULT_PERSIST
-- 
2.51.0



