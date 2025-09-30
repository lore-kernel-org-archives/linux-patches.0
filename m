Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367A1EE02F;
	Tue, 30 Sep 2025 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244608; cv=none; b=s1LNFe2jlQS9M5sZH/DZYoQDhA5nkupis5JXoTYwIqmPicdpk2vKQ+hBtusTptmVGQ1GPW4e5TqqOTVpPtyKyEfUlHsD1VoX3Zhr1sul7GOXfYcqSqZMqBP8G+m3DDAgoWPScfpcSbFCvdLbU5F/mERnZ/n9gsIHvJi2zFUm0vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244608; c=relaxed/simple;
	bh=3Rnrdf6RqMkbWCmnSRgspBQORXYYvLmMaYuwYjlRIsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C86Z6nqV2ysbYeG2OJhb/jqZdu3qaWyBvHTUjCB3dgQehgwu/GAQojS7oPxATTCWrrCi04Dw8ac9LyoQr555i0su04bfgAix3WrBjxA8eJ3TlMy+XsCiw+JhPwHHmeJdLhjq7+9zRiWXy0NWGIsymG4EUdkTR+gRxwCqVo7I5EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6mjlDt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6mjlDt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650C9C4CEF0;
	Tue, 30 Sep 2025 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244607;
	bh=3Rnrdf6RqMkbWCmnSRgspBQORXYYvLmMaYuwYjlRIsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6mjlDt6v8pJvhnQfNfxpfaUw0F4A8mRqiIqw5GoM6Rn3zS0Qw72FkP4NXE2FuWAv
	 5dlM1i1NIszzBdHSSazA2q1Ju7Tx+iVEyFi5n+5Z/tcdzcQlNRGs3tbsQD6athvWWV
	 F+RcUKsxk4GRmYZkbhn0VC1ep+f3vRnUetVWsc3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 018/143] usb: core: Add 0x prefix to quirks debug output
Date: Tue, 30 Sep 2025 16:45:42 +0200
Message-ID: <20250930143831.971150687@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d6daad39491b7..f5bc538753301 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -737,7 +737,7 @@ void usb_detect_quirks(struct usb_device *udev)
 	udev->quirks ^= usb_detect_dynamic_quirks(udev);
 
 	if (udev->quirks)
-		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
+		dev_dbg(&udev->dev, "USB quirks for this device: 0x%x\n",
 			udev->quirks);
 
 #ifdef CONFIG_USB_DEFAULT_PERSIST
-- 
2.51.0



