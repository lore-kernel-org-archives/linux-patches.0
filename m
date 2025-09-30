Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DDA1AB6F1;
	Tue, 30 Sep 2025 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244008; cv=none; b=VmySbB3vazgdCesAIUp9uokCQLgA2mU33l3tUO+SqD3uZrP4lbZtq6HdgsGxMQ8Yr1vRiC26SP3iV7BCelCS2EK8sBsAzvnJGdMX9EpgvQvbKJF4IXjGy+ZVBxQ8amDE17sn7d2fnstveYwgDQzit4SQskH+fCJuuqQoAEKUyi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244008; c=relaxed/simple;
	bh=RDY6PLaWXWFIoeHZVDyVy+DknTWWRMK/Qn/biRLP57M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJDfuMnVF1iBdhtGgx14sbOSzugSlyjrMChkf6rMfSD0UsVppQJAIpvjheOnsmeTn0XpG3JbpprnNBrWwAo8aeiTRecoNEV2QNUFYFwdsyh0GegT6k2glUJrQW/btoOsNHBUa8gLbCOsxJj1AFDuQyeTvY7KqWLJ/EcEaLyALbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSNvqaYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSNvqaYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AF9C116D0;
	Tue, 30 Sep 2025 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244008;
	bh=RDY6PLaWXWFIoeHZVDyVy+DknTWWRMK/Qn/biRLP57M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSNvqaYiVlTA3kktT/ySFtcF3xmc6vq9YDy66Z9ApHv1OMOz/YP4wvG0DizMtWSjW
	 7G67llY3FhQRi3Rly35sjGGbYqr/HaNOwyNyIH4mJWZI0gr7/qf+hOItPuA9wKCUxJ
	 p4WupZ/yM6QV/wDbW3IeYWlKv7HkpYI5wNnJ266Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/81] usb: core: Add 0x prefix to quirks debug output
Date: Tue, 30 Sep 2025 16:47:04 +0200
Message-ID: <20250930143822.273745659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 75a4d162c58b3..716bcf9f4d347 100644
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



