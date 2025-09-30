Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9BB245010;
	Tue, 30 Sep 2025 15:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245983; cv=none; b=AL1c3DkF4QVNCWpkNIRK00ymiK08O73Gf7zRpDDAES2E/MfkGybFg3CRM1OsSeDHjQOyvvI4y9OrJYOfCNqgIoxOobejLJ5mZT3zYFZceZmcOaxTYjUclTWBFmrd+YT/AX9vJpbGJGQUuAwfnNWxNF4g4LF8tuxk3UWBAoRz2hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245983; c=relaxed/simple;
	bh=hqkyJq7/vzqsdMU2kGY7PXMRCIO6Wv0fqJU1/7xCvJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXxjWRqvwDuY3J0LGE+UqH1NEskArofIueFmLr/M5zQUlP3hjavrskybBVWJ7MFLJKDSw0bBBpn3J4nhZCbnpfdwftC/74VfozXlKq5fYxwlafMCI0Hnql/JosbbeEztFdSqgx5WW6ar3tkeIlSCdbdb+tkECsbu9JGkn+Sh2EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQhCtH7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQhCtH7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F70BC4CEF0;
	Tue, 30 Sep 2025 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245983;
	bh=hqkyJq7/vzqsdMU2kGY7PXMRCIO6Wv0fqJU1/7xCvJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQhCtH7vvCgH/Hk9aL4tu7yCLDSsYFyHEpYzCa+S1U9PG+vp5Vtlj/8cP0m3CSY4H
	 k/aIwpCa/gV/Az3eXcFRzUgvgH3XG6CKXfHAqswSFF4AWqFM3IhaP/q3++Eu7xbpgZ
	 wx5E+IyRuZ0aJj21Catg9RbH3fpavozPx/oDy74g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 17/89] usb: core: Add 0x prefix to quirks debug output
Date: Tue, 30 Sep 2025 16:47:31 +0200
Message-ID: <20250930143822.583887295@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



