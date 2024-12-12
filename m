Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2272288CB;
	Thu, 12 Dec 2024 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021827; cv=none; b=YwGGrZiAGK6I+aWdxsLo+CT2bSPOg57aLJEM/o0YRphc6OZejZ6VXZLKoWueW4+4qUFeeOvc4GZtRtUtS9RfSJvdn0oB4EnPaPRyoGwdYhjyL2jbdxox8Xj8Y7rO8hAVxPy/D2LpHp/KOfLWQnVBYkDFimsVgxWtIbbhcEPgxng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021827; c=relaxed/simple;
	bh=JUB3OzHdnnYw5gBccm4K27R6yc+Kyhvc/gveh+BfEU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A6V0P161NcpX0EdaONTvOAsJ9xdeWp4rCrwm1M/ylePVq7wosqWSOIo7ErN3hXzBdoB1nD23QWJ4PXrwzr02ZPDVAebDK2Zkh24oOms0So8skEXrV2uXBK6c5GZ+FjL2Uir1vqUENCUi4ntwDEWm8KZV7Mxw16tiHac6tGQEzi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1kXE0j0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1kXE0j0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88355C4CECE;
	Thu, 12 Dec 2024 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021826;
	bh=JUB3OzHdnnYw5gBccm4K27R6yc+Kyhvc/gveh+BfEU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1kXE0j08r8VoqYqfGSUAWpeR/29dd9/uiAVLNSJNm2LXex48j0NssJ0V8UO4vFpU
	 XOfjL/ZkvA3gkR10EtHPSplZsyFlNMEgN3cBGUGj8Szet8UtXaqHrs4LJvhqQZXukp
	 QHEUdXIbf2jpoMpJZPY5qToUOJQn2Dt5eaTCFXCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Benjamin=20Gro=C3=9Fe?= <ste3ls@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/565] usb: add support for new USB device ID 0x17EF:0x3098 for the r8152 driver
Date: Thu, 12 Dec 2024 15:54:11 +0100
Message-ID: <20241212144313.712272407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e8fd743a1509d..abf4a488075ef 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9843,6 +9843,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3062) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3069) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3082) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3098) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7205) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x720c) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7214) },
-- 
2.43.0



