Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544B2566;
	Tue, 15 Jul 2025 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587297; cv=none; b=m6VeT8yi1qCp27YKq94K8inWYjpIGddYzuG3W4XSK3m+3o+HTkVleB3oByj8IznhcTevmodX9t4zvojrFz4Da6EbJ8tlKhzVwUhaMRqPzKr6mm/tCBvMmDc19lvvmUMSSMxlbD5pR+ycrZIZuWa4Ur62v72gtcXC5Wndnwarjmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587297; c=relaxed/simple;
	bh=rGB7RPFQ2pXLVIt8GvT4PN8y0X71Fa0eDEJ1MI1ngSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1SEEmmM/otyUNFPnBFWRVuMdA1qpD3FMdmQjaxCn0h1IUp7wqcBZRiPBkNcGlSWUr5Oz2CztXrP71XBDxmWCfXbGwzqUHQMMIJCv/GarA4ZCxgRRd2kQAmxfNJZAU3MQkcj0yfOITtMIo45prb5hQrPfLt2d5vOM7wn+u03kWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHFe/bIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHFe/bIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83293C4CEE3;
	Tue, 15 Jul 2025 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587296;
	bh=rGB7RPFQ2pXLVIt8GvT4PN8y0X71Fa0eDEJ1MI1ngSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHFe/bIJYKqhmYUwUb5kqIxK6hQgfULrpi+fUIHijYgA01VvkkwN4YETcUBO/ob4J
	 a6ATGYDR0ABKMruePAGJlR5K37HPXhGqlBepz0Usbxss1jn3xOMxgYGMiswnZn+kIp
	 2foYSji3BKv0i/c3KZvOfRBICcUVezpepGe0RFDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/88] Input: xpad - support Acer NGR 200 Controller
Date: Tue, 15 Jul 2025 15:14:24 +0200
Message-ID: <20250715130756.474816427@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nilton Perim Neto <niltonperimneto@gmail.com>

[ Upstream commit 22c69d786ef8fb789c61ca75492a272774221324 ]

Add the NGR 200 Xbox 360 to the list of recognized controllers.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250608060517.14967-1-niltonperimneto@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 872381221e754..7c11d9a1de0e5 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -167,6 +167,7 @@ static const struct xpad_device {
 	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3030, "Chic Controller", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3031, "Chic Controller", 0, XTYPE_XBOX },
+	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0020, "Logic3 Xbox GamePad", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0033, "Competition Pro Steering Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },
@@ -468,6 +469,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
+	XPAD_XBOX360_VENDOR(0x0502),		/* Acer Inc. X-Box 360 style controllers */
 	XPAD_XBOX360_VENDOR(0x056e),		/* Elecom JC-U3613M */
 	XPAD_XBOX360_VENDOR(0x06a3),		/* Saitek P3600 */
 	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
-- 
2.39.5



