Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9C121E0AE;
	Thu, 12 Dec 2024 15:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018778; cv=none; b=tZ+PBKa8uOs7wa5ZWoiEXFvZeOqkLBNTSCsLKoihAaS7mjWc4wd9WTpQyWa1ks5Td1VSnP5adYSyrC6mVYlV75ihCV9u61VTOyhdMWlykxaGCw4iTXWPv2qWyxtQHkx7Zm49HOeRZI59VVoW/SYnRwog6Qz4W/tvhLTpV3e80fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018778; c=relaxed/simple;
	bh=4puIxbPoXslyw6C6+vtLy1jzWG5nrTu6RgkQFuRDPRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cLZZze8OdmyFgXpL2QbTvH/7z4AEJEijnXYY4FeHmrIGhqLelGvfQzWu58yFoelHIIbb6RLmYmDINZRzd+GeKwI7GtJ3neFGKjrjQ5DShWarg5efsL5Z3WismgrBWV4qc6q5b85fZJKWPA2lafyVM0+Qwum9oXxN1G8C62ZpMU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFNCyxPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFNCyxPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4772DC4CED4;
	Thu, 12 Dec 2024 15:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018777;
	bh=4puIxbPoXslyw6C6+vtLy1jzWG5nrTu6RgkQFuRDPRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFNCyxPd3Pl/Fga6HMu/HbSnyzXWurzX7TlMPyBFw1Us1kWAXIDfUafBfPO43S8X7
	 bWiSalJrQI7oB1zjkq73PnVbhxn3B1tDkJcm7VdGEKvi5boofim8YANO5kAtT/uvBj
	 I5TlsSozETfYUWrVuULaTNl5E77KfZL7AJRqJ3bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Benjamin=20Gro=C3=9Fe?= <ste3ls@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/772] usb: add support for new USB device ID 0x17EF:0x3098 for the r8152 driver
Date: Thu, 12 Dec 2024 15:49:11 +0100
Message-ID: <20241212144350.075098599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Große <ste3ls@gmail.com>

[ Upstream commit 94c11e852955b2eef5c4f0b36cfeae7dcf11a759 ]

This patch adds support for another Lenovo Mini dock 0x17EF:0x3098 to the
r8152 driver. The device has been tested on NixOS, hotplugging and sleep
included.

Signed-off-by: Benjamin Große <ste3ls@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241020174128.160898-1-ste3ls@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 958a02b19554d..061a7a9afad04 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9870,6 +9870,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3062) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3069) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3082) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3098) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7205) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x720c) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7214) },
-- 
2.43.0



