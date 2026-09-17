Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD72E4E01F0;
	Thu, 17 Sep 2026 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667258; cv=none; b=SY5JjhfzVfaarVLWPs49zCjb8XB/XMlHpL5iDkd0c/mFY0jYS8NDorezytXnx+sqrgp6p0i5XgpuQBiQI0UuyczNgGU/GRWbqFu3/Q2Sl5W0bYtbqK9DrURv12yyU8gIIn0zDyh5YFCAIwWQJDMmRJJGXhaJ9aLtEGyumpUfeCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667258; c=relaxed/simple;
	bh=bz5MfhYIPOocgK5LFvSLVf/9zvncFxbTPQDZJimeJYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiTpXoFi+SFRrbsXKE4mly8X5Ku73toPGv7gItfOyydpsM+W20kwa3Z6pvTAtlzEER55xzeH/aUGA49nP+MsKskapZQBHKXyuwt2TZ9ua8MqtAtSKOc9I8+ii11x+BnfF4EYEjYne53PLKPIvMG4ZiacwGD2MZCGiBdlRfuupvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/5hcryi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/5hcryi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116281F000FF;
	Thu, 17 Sep 2026 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667256;
	bh=xg3CgF8Xkffx9IcbNfH00v4H+vGZZJtB2XSIkanFx5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/5hcryiCkVkM3h1PlzST0zV/7efKpYlHp2Yf7yiVrObfrvTY9il/9jDXeX8MBaf7
	 mXMSyEjJXJXMZEukiU0I/gaXAPCu9On43PSC1Z9egAqTEEH6eX9DiCeWm3ogkKwjWX
	 ogTSyqMP0T3zj2W5OyNB4LgDMDNjhg0wM8lQu9Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Boninsegna <rboninsegna2@gmail.com>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0032/1102] media: rc: mceusb: Add support for 04eb:e033
Date: Thu, 17 Sep 2026 15:59:35 +0100
Message-ID: <20260917151540.247025643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Riccardo Boninsegna <rboninsegna2@gmail.com>

[ Upstream commit 0692c2602e4cd410aa045f8991bd1c142b2e56f9 ]

This is a Sonix SN8P2202XG microcontroller with firmware compatible with
the already supported Northstar 04eb:e004, implementing an MCE IR receiver
(PCB seems to be tracked for a transmitter too but missing related parts).

Found in a Skintek SK-CR-IN+IR ( http://www.skintek.it/SK-CR-IN+IR.php )
internal 3.5 inch USB card reader and MCE receiver combo
(implemented by, and wired as, separate USB devices)
PCB marking: AU6475 966816 STIR REV:A02 MCE

Signed-off-by: Riccardo Boninsegna <rboninsegna2@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/mceusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index bf93b94d337fe..b989d3f1d7b6a 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -398,6 +398,8 @@ static const struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_COMPRO, 0x3082) },
 	/* Northstar Systems, Inc. eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe004) },
+	/* Northstar Systems, Inc. eHome Infrared Transceiver - variant */
+	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe033) },
 	/* TiVo PC IR Receiver */
 	{ USB_DEVICE(VENDOR_TIVO, 0x2000),
 	  .driver_info = TIVO_KIT },
-- 
2.53.0



